from .plugin_base import DTL

import os
from pathlib import Path
import subprocess

from flux.job import JobspecV1

class Dyad(DTL):

    _required_config_args = [
        "api",
        "consumer_path",
        "producer_path",
        "kvs_namespace",
        "dtl_mode",
    ]

    _lassen_helper_script = (Path(__file__).resolve().parent.parent / "utils" / "lassen_dyad_wrapper.sh").resolve()

    def __init__(self, install_prefix, consumer_path=None, producer_path=None,
                 kvs_namespace=None, dtl_mode=None, api="wrapper", needs_spectrum=False):
        super().__init__(needs_spectrum)
        if isinstance(install_prefix, Path):
            self.install_prefix = install_prefix.expanduser().resolve()
        else:
            self.install_prefix = Path(install_prefix).expanduser().resolve()
        if api not in ("wrapper", "stream"):
            raise ValueError("'api' configuration value must be either 'wrapper' or 'stream'")
        self.configure_args["api"] = api
        self.configure_args["consumer_path"] = consumer_path
        self.configure_args["producer_path"] = producer_path
        self.configure_args["kvs_namespace"] = kvs_namespace
        self.configure_args["dtl_mode"] = dtl_mode
        self.libdir = self.install_prefix / "lib64"
        self.dyad_mod = self.libdir / "dyad.so"
        self.dyad_wrapper = self.libdir / "dyad_wrapper.so"
        self.num_ranks = 2

    def _check_for_needed_config_args(self):
        for ca in self._required_config_args:
            if ca not in self.configure_args or self.configure_args[ca] is None:
                raise KeyError("Required configuration arg {} is not found".format(ca))
        if not isinstance(self.configure_args["consumer_path"], Path):
            self.configure_args["consumer_path"] = Path(self.configure_args["consumer_path"]).expanduser().resolve()
        if not isinstance(self.configure_args["producer_path"], Path):
            self.configure_args["producer_path"] = Path(self.configure_args["producer_path"]).expanduser().resolve()

    def _validate_configure_arg(self, name, val):
        if name not in self._required_config_args:
            raise KeyError("Invalid key: {}".format(name))

    def _create_prod_and_cons_dirs(self):
        test_cons_cmd = "test ! -d {}".format(str(self.configure_args["consumer_path"] / "group0"))
        test_prod_cmd = "test ! -d {}".format(str(self.configure_args["producer_path"] / "group0"))
        for rank in range(self.num_ranks):
            if subprocess.run("flux exec -r {} {}".format(rank, test_prod_cmd), shell=True).returncode == 0:
                subprocess.run("flux exec -r {} mkdir -p {}".format(rank, str(self.configure_args["producer_path"] / "group0")),
                               shell=True, check=True)
            if subprocess.run("flux exec -r {} {}".format(rank, test_cons_cmd), shell=True).returncode == 0:
                subprocess.run("flux exec -r {} mkdir -p {}".format(rank, str(self.configure_args["consumer_path"] / "group0")),
                               shell=True, check=True)

    def _delete_prod_and_cons_dirs(self):
        test_cons_cmd = "test -d {}".format(str(self.configure_args["consumer_path"] / "group0"))
        test_prod_cmd = "test -d {}".format(str(self.configure_args["producer_path"] / "group0"))
        for rank in range(self.num_ranks):
            if subprocess.run("flux exec -r {} {}".format(rank, test_prod_cmd), shell=True).returncode == 0:
                subprocess.run("flux exec -r {} rm -r {}".format(rank, str(self.configure_args["producer_path"])),
                               shell=True, check=True)
            if subprocess.run("flux exec -r {} {}".format(rank, test_cons_cmd), shell=True).returncode == 0:
                subprocess.run("flux exec -r {} rm -r {}".format(rank, str(self.configure_args["consumer_path"])),
                               shell=True, check=True)

    def _remove_kvs_namespace(self):
        nspace_check_cmd = "flux kvs namespace list | grep -q \"{}\"".format(self.configure_args["kvs_namespace"])
        if subprocess.run(nspace_check_cmd, shell=True).returncode == 0:
            subprocess.run("flux kvs namespace remove {}".format(self.configure_args["kvs_namespace"]),
                           shell=True, check=True)

    def _unload_dyad_module(self):
        if subprocess.run("flux exec -r all flux module list | grep -q \"dyad\"", shell=True).returncode == 0:
            subprocess.run("flux exec -r all flux module unload dyad", shell=True, check=True)

    def _print_num_files_in_staging(self):
        print("Checking for files on Flux ranks")
        print("================================", end="\n\n")
        for rank in range(self.num_ranks):
            print("Node {}:".format(rank))
            num_files_prod_dir = subprocess.run(
                "flux exec -r {} ls {} | wc -l".format(rank, str(self.configure_args["producer_path"] / "group0")),
                shell=True,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip()
            lah_prod_dir = subprocess.run(
                "flux exec -r {} ls -lah {}".format(rank, str(self.configure_args["producer_path"] / "group0")),
                shell=True,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip()
            num_files_cons_dir = subprocess.run(
                "flux exec -r {} ls {} | wc -l".format(rank, str(self.configure_args["consumer_path"] / "group0")),
                shell=True,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip()
            lah_cons_dir = subprocess.run(
                "flux exec -r {} ls -lah {}".format(rank, str(self.configure_args["consumer_path"] / "group0")),
                shell=True,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip()
            print("  * Producer Directory: {}".format(num_files_prod_dir))
            print("  * Consumer Directory: {}".format(num_files_cons_dir))
            print("  Producer LAH: {}".format(lah_prod_dir))
            print("  Consumer LAH: {}".format(lah_cons_dir))

    def startup(self, *args, **kwargs):
        self._check_for_needed_config_args()
        self._create_prod_and_cons_dirs()
        self._print_num_files_in_staging()
        self._remove_kvs_namespace()
        subprocess.run("flux kvs namespace create {}".format(self.configure_args["kvs_namespace"]),
                       shell=True, check=True)
        self._unload_dyad_module()
        module_launch = "{} {} {}".format(
            str(self.dyad_mod),
            str(self.configure_args["producer_path"]),
            self.configure_args["dtl_mode"]
        )
        subprocess.run("flux exec -r all flux module load {}".format(module_launch), shell=True, check=True)

    def shutdown(self):
        self._print_num_files_in_staging()
        self._unload_dyad_module()
        self._remove_kvs_namespace()
        self._delete_prod_and_cons_dirs()

    def create_jobspec(self, base_cmd, is_producer, nsteps, num_nodes=None, num_tasks=1,
                       cores_per_task=1, gpus_per_task=None, exclusive=False, extra_envs=None):
        group_id = 0
        mod_cmd = base_cmd.copy()
        mod_cmd.extend(["-g", str(group_id), "-c", str(nsteps), "-d"])
        environ = dict(os.environ)
        environ["DYAD_KVS_NAMESPACE"] = self.configure_args["kvs_namespace"]
        environ["DYAD_DTL_MODE"] = self.configure_args["dtl_mode"]
        if self.configure_args["api"] == "wrapper":
            if not self.needs_spectrum:
                if "LD_PRELOAD" in environ:
                    environ["LD_PRELOAD"] = "{}:{}".format(str(self.dyad_wrapper), environ["LD_PRELOAD"])
                else:
                    environ["LD_PRELOAD"] = str(self.dyad_wrapper)
            else:
                mod_cmd.insert(0, str(self.dyad_wrapper))
                mod_cmd.insert(0, str(self._lassen_helper_script))
                # if "OMPI_LD_PRELOAD_PREPEND" in environ:
                #     environ["OMPI_LD_PRELOAD_PREPEND"] = "{}:{}".format(
                #         str(self.dyad_wrapper),
                #         environ["OMPI_LD_PRELOAD_PREPEND"]
                #     )
                # else:
                #     environ["OMPI_LD_PRELOAD_PREPEND"] = str(self.dyad_wrapper)
        if extra_envs is not None:
            if not isinstance(extra_envs, dict):
                raise TypeError("'extra_envs' parameter is an invalid type")
            environ.update({k: v for k, v in extra_envs.items() if k not in environ})
        if is_producer:
            mod_cmd.append(str(self.configure_args["producer_path"]))
            environ["DYAD_PATH_PRODUCER"] = str(self.configure_args["producer_path"])
            print("Producer Environment: {}".format(environ))
        else:
            mod_cmd.append(str(self.configure_args["consumer_path"]))
            environ["DYAD_PATH_CONSUMER"] = str(self.configure_args["consumer_path"])
            print("Consumer Environment: {}".format(environ))
        job_spec = JobspecV1.from_command(
            mod_cmd,
            num_tasks=num_tasks,
            cores_per_task=cores_per_task,
            gpus_per_task=gpus_per_task,
            num_nodes=num_nodes,
            exclusive=exclusive
        )
        job_spec.environment = environ
        if self.needs_spectrum:
            job_spec.setattr_shell_option("mpi", "spectrum")
        return job_spec

    @staticmethod
    def generate_base_toml():
        return {
            "api": "EITHER wrapper OR stream",
            "consumer_path": "PATH TO CONSUMER STAGING",
            "producer_path": "PATH TO PRODUCER STAGING",
            "kvs_namespace": "FLUX KVS NAMESPACE TO USE WITH DYAD",
            "dtl_mode": "DTL MODE FOR DYAD",
        }

    @classmethod
    def get_required_config_args(cls):
        return cls._required_config_args

