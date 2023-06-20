import os
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from .general import (
    generate_dtl_options,
    validate_and_split_dtl_config,
    DTL_DIR,
    TEMPLATE_DIR
)

TEMPLATE_FILES = [
    "CMakeLists.txt",
    "template_reader.hpp",
    "template_writer.hpp",
    "template_reader.cpp",
    "template_writer.cpp",
]
JINJA_ENV = Environment(loader=FileSystemLoader(str(TEMPLATE_DIR)))


def generate_dtl_template_content(dtl_name, dtl_config):
    dtl_dir = DTL_DIR / dtl_name
    if dtl_dir.is_file():
        raise FileExistsError("{} is a file! Delete this file before running this script".format(str(dtl_dir)))
    if dtl_dir.is_dir():
        print("{} already exists! Delete this directory and rerun this script if you really want to create this DTL".format(str(dtl_dir)))
        return False
    dtl_dir.mkdir()
    template_data = dtl_config.copy()
    template_data["dtl_name"] = dtl_name
    option_str = generate_dtl_options(dtl_config)
    if option_str is not None:
        template_data["cmake_option_commands"] = option_str
    template_data["needs_mpi"] = "TRUE" if template_data["needs_mpi"] else "FALSE"
    for temp_file in TEMPLATE_FILES:
        template = JINJA_ENV.get_template(temp_file)
        out_fname = temp_file
        if temp_file.startswith("template"):
            out_fname = temp_file.replace("template", dtl_config["file_prefix"], 1)
        with open(dtl_dir / out_fname, "w") as f:
            f.write(template.render(template_data))
    return True


def configure_dtl(config):
    dtl_subtables = validate_and_split_dtl_config(config)
    print("Generating templates for the following tools:")
    for dtl_name, dtl_config in dtl_subtables.items():
        if generate_dtl_template_content(dtl_name, dtl_config):
            print("  * {}".format(dtl_name))
    print("\n")
    print("Your templates can be found in the subdirectories of 'dtl/'.")
    print("You will still need to implement the functions in the '.cpp' files")
    print("in those directories to complete your tool integration")
