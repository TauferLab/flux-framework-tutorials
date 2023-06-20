#include "{{ file_prefix }}_reader.hpp"

{{ class_prefix }}Reader::{{ class_prefix }}Reader(const CLI::Option_group* cmd_line_args)
{
    // CONSTRUCTOR CODE HERE
}

void {{ class_prefix }}Reader::set_cmdline_args(CLI::Option_group* cmd_line_arg_defs)
{
    // COMMAND LINE ARGUMENTS DEFINED HERE
}

Chunk* {{ class_prefix }}Reader::read_one_chunk(unsigned long int chunk_id)
{
    // READING CODE HERE
}

// Uncomment if you want a custom implementation of read_chunks
// std::vector<Chunk*> {{ class_prefix }}Reader::read_chunks(unsigned long int chunks_from, unsigned long int chunks_to)
// {
// }
