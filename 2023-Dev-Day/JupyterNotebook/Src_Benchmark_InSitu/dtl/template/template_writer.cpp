#include "{{ file_prefix }}_writter.hpp"

{{ class_prefix }}Writer::{{ class_prefix }}Writer(const CLI::Option_group* cmd_line_args)
{
    // CONSTRUCTOR CODE HERE
}

void {{ class_prefix }}Writer::set_cmdline_args(CLI::Option_group* cmd_line_arg_defs)
{
    // COMMAND LINE ARGUMENTS DEFINED HERE
}

void {{ class_prefix }}Writer::write_one_chunk(Chunk* chunk)
{
    // WRITING CODE HERE
}

// Uncomment if you want a custom implementation of read_chunks
// void {{ class_prefix }}Writer::write_chunks(std::vector<Chunk*> chunks)
// {
// }
