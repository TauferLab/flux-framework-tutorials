import os
from pathlib import Path
import sysconfig

# Since Python 3.11, tomli has been included in the Python
# standard library as tomllib.
# If using a new enough version of Python, leverage tomllib for
# parsing the TOML configuration file. Otherwise, fall back
# to tomli
try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib

DTL_DIR = Path(os.path.abspath("./dtl"))
TEMPLATE_DIR = DTL_DIR / "template"


BUILTIN_DTL = [
    "dspaces",
    "dyad"
]


def generate_dtl_options(dtl_config):
    if "cmake_options" not in dtl_config:
        return None
    option_str = ""
    for opt_dict in dtl_config["cmake_options"]:
        entry_value = "\"{}\"".format(str(opt_dict["default_value"]))
        entry_type = "STRING"
        if isinstance(opt_dict["default_value"], bool):
            entry_value = "ON" if opt_dict["default_value"] else "OFF"
            entry_type = "BOOL"
        option_str += "set({} {} CACHE {} {})\n".format(
            opt_dict["name"],
            entry_value,
            entry_type,
            "\"\"" if "description" not in opt_dict else opt_dict["description"]
        )
    return option_str


def validate_dtl_subtable(dtl_key, subtable_dict):
    if (TEMPLATE_DIR / dtl_key).exists():
        return False
    if "class_prefix" not in subtable_dict:
        raise KeyError("A subtable of 'dtl' must have a 'class_prefix' key-value pair")
    elif not isinstance(subtable_dict["class_prefix"], str):
        raise TypeError("The value for 'class_prefix' must be a string")
    if "file_prefix" not in subtable_dict:
        raise KeyError("A subtable of 'dtl' must have a 'file_prefix' key-value pair")
    elif not isinstance(subtable_dict["file_prefix"], str):
        raise TypeError("The value for 'file_prefix' must be a string")
    if "cmake_target" not in subtable_dict:
        raise KeyError("A subtable of 'dtl' must have a 'cmake_target' key-value pair")
    elif not isinstance(subtable_dict["cmake_target"], str):
        raise TypeError("The value for 'cmake_target' must be a string")
    if "needs_mpi" not in subtable_dict:
        raise KeyError("A subtable of 'dtl' must have a 'needs_mpi' key-value pair")
    elif not isinstance(subtable_dict["needs_mpi"], bool):
        raise TypeError("The value for 'needs_mpi' must be a bool")
    if "cmake_options" in subtable_dict:
        if (not isinstance(subtable_dict["cmake_options"], list) or
            any(not isinstance(opt_dict, dict) for opt_dict in subtable_dict["cmake_options"]) or
            any(k not in ["name", "default_value", "description"] for opt_dict in subtable_dict["cmake_options"] for k in opt_dict)):
            raise TypeError("If provided, the 'cmake_options' value must be a list of tables with subkeys 'name', \
                    'default_value', and (optionally) 'description'")
    return True


def validate_and_split_dtl_config(config):
    if "dtl" not in config:
        raise KeyError("Config must have a 'dtl' table to configure new insitu tools")
    if not isinstance(config["dtl"], dict):
        raise TypeError("'dtl' key must correspond to a TOML table")
    valid_dtl_subtables = {}
    for key, subdict in config["dtl"].items():
        is_valid = validate_dtl_subtable(key, subdict)
        if is_valid:
            valid_dtl_subtables[key] = subdict
        else:
            print("A DTL named {} already exists! Please delete {} if you \
                    really want to create this from scratch".format(
                key,
                str(TEMPLATE_DIR / key)
            ))
    return valid_dtl_subtables


def parse_config(conf_file):
    if not conf_file.is_file():
        raise FileNotFoundError("The config file ({}) does not exist".format(str(conf_file)))
    config = None
    with open(str(conf_file), "rb") as f:
        config = tomllib.load(f)
    if config is None:
        raise RuntimeError("TOML file was read without issue, but somehow the contents are still None")
    return config


def get_python_includedir():
    """Get the include directory associated with the Python interpreter running
    this script.

    :return: the include directory for this Python interpreter
    :rtype: Path
    """
    return Path(sysconfig.get_config_var("INCLUDEPY")).resolve()


def get_python_lib():
    """Get the library (likely a ".so" file) associated with the Python interpreter running
   this script.

    :return: the library for this Python interpreter
    :rtype: Path
    """
    libdir = Path(sysconfig.get_config_var("LIBDIR"))
    libfile = Path(sysconfig.get_config_var("LDLIBRARY"))
    return (libdir / libfile).resolve()
