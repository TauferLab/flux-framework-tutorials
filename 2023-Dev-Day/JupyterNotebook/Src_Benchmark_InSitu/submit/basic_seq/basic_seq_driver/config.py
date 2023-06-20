from .dtl_plugins import *

try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib
from pathlib import Path

import tomli_w

class ConfigManager:

    def __init__(self, dtl_choice):
        if dtl_choice not in AVAILABLE_DTLS:
            raise ValueError("DTL choice {} is invalid".format(dtl_choice))
        self.dtl_choice = dtl_choice
        self.required_dtl_args = None
        self.dtl_toml_generator = None
        if dtl_choice == "dyad":
            self.required_dtl_args = Dyad.get_required_config_args()
            self.dtl_toml_generator = Dyad.generate_base_toml
        self.required_pipeline_args = [
            "install_prefix",
            "out_dir",
            "natoms",
        ]
        self.config = {}

    def from_dict(self, arg_dict):
        for req_pipe_arg in self.required_pipeline_args:
            if req_pipe_arg not in arg_dict:
                raise KeyError("Required configuration argument {} not found".format(req_pipe_arg))
        if "dtl" not in arg_dict:
            if self.dtl_choice == "dyad":
                raise KeyError("The DYAD plugin requires a 'dtl' subsection")
        if self.required_dtl_args is not None:
            for req_dtl_arg in self.required_dtl_args:
                if req_dtl_arg not in arg_dict["dtl"]:
                    raise KeyError("Required DTL configuration argument {} not found".format(req_dtl_arg))
        self.config = arg_dict.copy()
        if not isinstance(self.config["install_prefix"], Path):
            self.config["install_prefix"] = Path(self.config["install_prefix"]).expanduser().resolve()
        if not isinstance(self.config["out_dir"], Path):
            self.config["out_dir"] = Path(self.config["out_dir"]).expanduser().resolve()
        # Make sure we have an "extra_envs" entry in self.config
        if "extra_envs" not in self.config:
            self.config["extra_envs"] = None
        # Force nsteps to be 1 for Basic Sequential
        self.config["nsteps"] = 1

    def from_kwargs(self, **kwargs):
        self.from_dict(kwargs)

    def from_toml(self, config_path):
        with open(config_path, "rb") as f:
            arg_dict = tomllib.load(f)
            self.from_dict(arg_dict)

    def generate_base_toml(self, config_path):
        config_contents = {
            "install_prefix": "BENCHMARK INSTALL PREFIX",
            "out_dir": "OUTPUT DIRECTORY FOR PIPELINE",
            "natoms": "NUMBER OF ATOMS IN THE DATA CHUNK(S)",
            "extra_envs": {
                "OPTIONAL TABLE": "FOR",
                "ENVIRONMENT": "VARIABLES"
            }
        }
        if self.dtl_toml_generator is not None:
            config_contents["dtl"] = self.dtl_toml_generator()
        with open(config_path, "wb") as f:
            tomli_w.dump(config_contents, f)

    def __getitem__(self, key):
        return self.config[key]

    def __setitem__(self, key, val):
        self.config[key] = val
