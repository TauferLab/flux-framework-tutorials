#include "dspaces_reader.hpp"

DSpacesReader::DSpacesReader(const CLI::Option_group* cmd_line_args,
        MPI_Comm comm)
{
    m_reader = std::make_unique(
        cmd_line_args->get_option("client_id")->as<int>(),
        cmd_line_args->get_option("group_id")->as<int>(),
        cmd_line_args->get_option("total_chunks")->as<unsigned long int>(),
        comm,
    );
}

void DSpacesReader::set_cmdline_args(CLI::App* cmd_line_arg_defs)
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

Chunk* DSpacesReader::read_one_chunk(unsigned long int chunk_id)
{
    return nullptr;
}

std::vector<Chunk*> DSpacesReader::read_chunks(unsigned long int chunks_from, unsigned long int chunks_to)
{
    return m_reader->read_chunks(chunks_from, chunks_to);
}
