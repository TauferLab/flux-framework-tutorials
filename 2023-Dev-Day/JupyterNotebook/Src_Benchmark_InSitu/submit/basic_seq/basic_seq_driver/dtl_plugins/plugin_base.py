from abc import ABC, abstractmethod


class DTL(ABC):

    def __init__(self, needs_spectrum=False):
        self.needs_spectrum = needs_spectrum
        self.configure_args = {}

    def __setitem__(self, key, val):
        self._validate_configure_arg(key, val)
        self.configure_args[key] = val

    def __getitem__(self, key):
        if key not in self.configure_args:
            raise KeyError("{} is not in configuration arguments".format(key))
        return self.configure_args[key]

    @abstractmethod
    def startup(self, *args, **kwargs):
        pass

    @abstractmethod
    def shutdown(self):
       pass

    @abstractmethod
    def create_jobspec(self, base_cmd, is_producer, nsteps, num_nodes=None, num_tasks=1,
                       cores_per_task=1, gpus_per_task=None, exclusive=False, extra_envs=None):
        pass

    @staticmethod
    @abstractmethod
    def generate_base_toml():
        pass

    @classmethod
    @abstractmethod
    def get_required_config_args(cls):
        pass

    @abstractmethod
    def _validate_configure_arg(self, name, val):
        pass
