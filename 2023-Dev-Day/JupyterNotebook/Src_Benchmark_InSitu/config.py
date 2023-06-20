import argparse
from pathlib import Path
import sys

from configure_helpers.general import (
    parse_config,
    get_python_includedir,
    get_python_lib,
)
from configure_helpers.build import configure_build
from configure_helpers.dtl import configure_dtl


def main():
    parser = argparse.ArgumentParser("python3 config.py")
    parser.add_argument("mode", choices=["build", "dtl"],
                        help="If in 'build' mode, generate a CMake input cache file. \
                                If in 'dtl' mode, create template directories for new in situ tools")
    parser.add_argument("config_file", type=Path,
                        help="Path to the TOML config file used to generate templates")
    parser.add_argument("--cache_path", "-C", type=Path, default=Path("./insitu_benchmark.cmake").resolve(),
                        help="Sets path to the CMake input cache to be created when in 'generate' mode")
    parser.add_argument("--python_exec", "-pe", type=Path, default=Path(sys.executable).resolve(),
                        help="In generate mode, overrides the default Python executable to use when building the benchmark")
    parser.add_argument("--python_inc_dir", "-pi", type=Path, default=get_python_includedir(),
                        help="In generate mode, overrides the default Python include directory to use when building the benchmark")
    parser.add_argument("--python_library", "-pl", type=Path, default=get_python_lib(),
                        help="In generate mode, overrides the default Python library (i.e., libpythonX.Y.so) to use when building the benchmark")
    args = parser.parse_args()
    config = parse_config(args.config_file)
    if args.mode == "dtl":
        configure_dtl(config)
    else:
        configure_build(
            config,
            args.cache_path,
            args.python_exec.resolve(),
            args.python_inc_dir.resolve(),
            args.python_library.resolve(),
        )


if __name__ == "__main__":
    main()
