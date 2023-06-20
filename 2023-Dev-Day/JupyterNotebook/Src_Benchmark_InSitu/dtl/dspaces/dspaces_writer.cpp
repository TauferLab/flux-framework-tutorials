#include "dspaces_writter.hpp"

DSpacesWriter::DSpacesWriter(const CLI::App* cmd_line_args, MPI_Comm comm)
{
    m_writer = std::make_unique(
        cmd_line_args->get_option("client_id")->as<int>(),
        cmd_line_args->get_option("group_id")->as<int>(),
        cmd_line_args->get_option("total_chunks")->as<unsigned long int>(),
        comm,
    );
}

void DSpacesWriter::set_cmdline_args(CLI::App* cmd_line_arg_defs)
{
    CLI::TypeValidator<int> int_validator("int_validator");
    CLI::TypeValidator<unsigned long int> ulong_validator("ulong_validator");
    cmd_line_arg_defs->add_option(
        "client_id",
        "Unique ID for this application"
    )->check(int_validator);
    cmd_line_arg_defs->add_option(
        "group_id",
        "Unique ID for the group to which this application belongs"
    )->check(int_validator);
    cmd_line_arg_defs->add_option(
        "total_chunks",
        "Number of chunks to read"
    )->check(ulong_validator);
}

void DSpacesWriter::write_one_chunk(std::shared_ptr<Chunk> chunk)
{
    return;
}

void DSpacesWriter::write_chunks(std::vector<Chunk*> chunks)
{
    m_writer->write_chunks(chunks);
}
