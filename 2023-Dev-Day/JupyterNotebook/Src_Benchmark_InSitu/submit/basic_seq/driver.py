from basic_seq_driver.config import ConfigManager
from basic_seq_driver.dtl_plugins import *

import argparse
import concurrent
import os
from pathlib import Path
import sys
import time

import flux

# Parse command line arguments
parser = argparse.ArgumentParser("Launch the basic sequential workflow")
parser.add_argument("dtl_mode", choices=AVAILABLE_DTLS,
                    help="DTL plugin to use")
parser.add_argument("config_file", type=str,
                    help="Path to the TOML configuration file for the workflow")
parser.add_argument("--gen_basic_config", "-g", action="store_true",
                    help="Generate a starting configuration TOML instead of running the workflow")
parser.add_argument("--mpi", "-m", choices=["spectrum"], default=None,
                    help="If provided, use support for special type of MPI")
args = parser.parse_args()
# Parse the TOML config using ConfigManager
manager = ConfigManager(args.dtl_mode)
# If basic TOML generation was requested, generate that file and exit
if args.gen_basic_config:
    manager.generate_base_toml(args.config_file)
    sys.exit()
# Load the configuration
manager.from_toml(args.config_file)
# Create the correct DTL object based on dtl_mode
dtl = None
if args.dtl_mode == "dyad":
    dtl = Dyad(
        manager["install_prefix"],
        consumer_path=manager["dtl"]["consumer_path"],
        producer_path=manager["dtl"]["producer_path"],
        kvs_namespace=manager["dtl"]["kvs_namespace"],
        dtl_mode=manager["dtl"]["dtl_mode"],
        api=manager["dtl"]["api"],
        needs_spectrum=args.mpi is not None and args.mpi == "spectrum"
    )
# Get the paths to a few directories we need
script_dir = manager["install_prefix"] / "libexec"
bin_dir = manager["install_prefix"] / "bin"
# Get rid of any log files from earlier runs
for logfile in Path.cwd().glob("log.*"):
    logfile.unlink()
# Create the output directory if needed
if not manager["out_dir"].is_dir():
    manager["out_dir"].mkdir(parents=True)
# Start the DTL
if args.dtl_mode == "dyad":
    dtl.startup()
# Generate Flux JobSpecV1 objects for the producer and consumer
base_consumer_cmd = [
    str(bin_dir / "pipeline1_consumer"),
    str(script_dir / "compute.py"),
    "analyze",
    str(manager["nsteps"]),
]
base_producer_cmd = [
    str(bin_dir / "pipeline1_producer"),
    str(script_dir / "load.py"),
    "extract_frame",
    str(manager["nsteps"]),
    str(manager["natoms"]),
    "0",
]
consumer_jobspec = dtl.create_jobspec(
    base_consumer_cmd,
    False,
    manager["nsteps"],
    num_nodes=1,
    exclusive=True,
    extra_envs=manager["extra_envs"],
)
consumer_jobspec.stdout = str(manager["out_dir"] / "log.consumer")
consumer_jobspec.stderr = str(manager["out_dir"] / "log.consumer")
producer_jobspec = dtl.create_jobspec(
    base_producer_cmd,
    True,
    manager["nsteps"],
    num_nodes=1,
    exclusive=True,
    extra_envs=manager["extra_envs"],
)
producer_jobspec.stdout = str(manager["out_dir"] / "log.producer")
producer_jobspec.stderr = str(manager["out_dir"] / "log.producer")
# Launch the producer and consumer with FluxExecutor and wait for them to finish
with flux.job.FluxExecutor() as executor:
    start_time = time.perf_counter_ns()
    cons_future = executor.submit(consumer_jobspec)
    prod_future = executor.submit(producer_jobspec)
    concurrent.futures.wait([prod_future, cons_future])
    end_time = time.perf_counter_ns()
# Shutdown the DTL
dtl.shutdown()
# Calculate makespan
makespan = end_time - start_time
with open(manager["out_dir"] / "makespan.txt", "w") as f:
    f.write("natoms,nsteps,makespan\n{},{},{}".format(
        manager["natoms"],
        manager["nsteps"],
        makespan
    ))
