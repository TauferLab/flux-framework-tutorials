from pathlib import Path

from .general import (
    generate_dtl_options,
    validate_and_split_dtl_config,
    BUILTIN_DTL
)

def validate_build_config(config):
    if "build" not in config:
        return None
    valid_build_config_keys = [
        "dtl",
        "build_type",
        "CC",
        "c_compiler",
        "CFLAGS",
        "c_flags",
        "CXX",
        "cxx_compiler",
        "CXXFLAGS",
        "cxx_flags",
        "FC",
        "fortran_compiler",
        "FFLAGS",
        "fortran_flags",
        "prefix",
        "extra_cmake_config"
    ]
    if any(k not in valid_build_config_keys for k in config["build"]):
        raise KeyError("Unrecognized key found in the 'build' table!")
    if not isinstance(config["build"]["dtl"], str):
        raise TypeError("'dtl' field of 'build' table must be a string")
    if "CC" in config["build"] and "c_compiler" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'CC' and 'c_compiler'")
    if "CFLAGS" in config["build"] and "c_flags" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'CFLAGS' and 'c_flags'")
    if "CXX" in config["build"] and "cxx_compiler" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'CXX' and 'cxx_compiler'")
    if "CXXFLAGS" in config["build"] and "cxx_flags" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'CXXFLAGS' and 'cxx_flags'")
    if "FC" in config["build"] and "fortran_compiler" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'FC' and 'fortran_compiler'")
    if "FFLAGS" in config["build"] and "fortran_flags" in config["build"]:
        raise KeyError("The 'build' table can only contain one of 'FFLAGS' and 'fortran_flags'")
    if "extra_cmake_config" in config["build"]:
        if not isinstance(config["build"]["extra_cmake_config"], dict):
            raise TypeError("If provided, 'extra_cmake_config' must be a table where \
                    keys are CMake configuration variables and values are the values \
                    of those variables")
    return config["build"]


def create_cmake_cache(dtl_subtables, build_config, cache_path,
             pyexec, pyinc_dir, pylib):
    cache_contents = ""
    if build_config is not None:
        cache_contents += "########################################\n"
        cache_contents += "# Set built-in configuration variables #\n"
        cache_contents += "########################################\n"
        cmake_variable_name_dict = {
            "build_type": "CMAKE_BUILD_TYPE",
            "CC": "CMAKE_C_COMPILER",
            "c_compiler": "CMAKE_C_COMPILER",
            "CFLAGS": "CMAKE_C_FLAGS",
            "c_flags": "CMAKE_C_FLAGS",
            "CXX": "CMAKE_CXX_COMPILER",
            "cxx_compiler": "CMAKE_CXX_COMPILER",
            "CXXFLAGS": "CMAKE_CXX_FLAGS",
            "cxx_flags": "CMAKE_CXX_FLAGS",
            "FC": "CMAKE_Fortran_COMPILER",
            "fortran_compiler": "CMAKE_Fortran_COMPILER",
            "FFLAGS": "CMAKE_Fortran_FLAGS",
            "fortran_flags": "CMAKE_Fortran_FLAGS",
        }
        for config_key, value in build_config.items():
            if config_key == "dtl":
                cache_contents += "set(ENABLE_DTL \"{}\" CACHE STRING \"\")\n".format(
                    value
                )
            elif config_key == "prefix":
                cache_contents += "set(CMAKE_INSTALL_PREFIX \"{}\" CACHE STRING \"\")\n".format(
                        str(Path(value).expanduser().resolve())
                )
            elif config_key != "extra_cmake_config":
                cache_contents += "set({} \"{}\" CACHE STRING \"\")\n".format(
                    cmake_variable_name_dict[config_key],
                    value
                )
        if "extra_cmake_config" in build_config:
            for extra_variable_name, extra_variable_val in build_config["extra_cmake_config"].items():
                cache_contents += "set({} \"{}\" CACHE STRING \"\")\n".format(
                    extra_variable_name,
                    extra_variable_val
                )
        cache_contents += "\n"
    cache_contents += "###############################################\n"
    cache_contents += "# Set variables to search for Python in CMake #\n"
    cache_contents += "###############################################\n"
    cache_contents += "set(PYTHON_EXECUTABLE \"{}\" CACHE PATH \"\")\n".format(str(pyexec))
    cache_contents += "set(PYTHON_INCLUDE_DIR \"{}\" CACHE PATH \"\")\n".format(str(pyinc_dir))
    cache_contents += "set(PYTHON_LIBRARY \"{}\" CACHE PATH \"\")\n\n".format(str(pylib))
    cache_contents += "################################################\n"
    cache_contents += "# Sets variables to configure DTL integrations #\n"
    cache_contents += "################################################\n\n"
    for dtl_name, dtl_config in dtl_subtables.items():
        cache_contents += "# Variables for {}\n".format(dtl_name)
        option_str = generate_dtl_options(dtl_config)
        if option_str is not None:
            cache_contents += option_str
        cache_contents += "\n"
    cache_path_obj = cache_path.resolve()
    with open(str(cache_path_obj), "w") as f:
        f.write(cache_contents)
    print("Initial CMake input cache file has been created")
    print("at {}.".format(str(cache_path_obj)))
    print("Use this file to set most of your command-line arguments.")
    print("Once set, the arguments can be passed to CMake with")
    print("`cmake -C {} ..`".format(str(cache_path_obj)))


def configure_build(config, cache_path, pyexec, pyinc_dir, pylib):
    dtl_subtables = validate_and_split_dtl_config(config)
    build_config = validate_build_config(config)
    if build_config is None:
        raise KeyError("No 'build' table in config file")
    if build_config["dtl"] not in (BUILTIN_DTL + list(dtl_subtables.keys())):
        raise ValueError("'build' table requests unrecognized DTL {}".format(build_config["dtl"]))
    create_cmake_cache(
        dtl_subtables,
        build_config,
        cache_path,
        pyexec,
        pyinc_dir,
        pylib
    )
