#include "benchmark_writer.hpp"

BenchmarkWriter::BenchmarkWriter(unsigned long int group_id,
        const CLI::Option_group* cmd_line_args)
    : m_group_id(group_id)
{
}

void BenchmarkWriter::write_chunks(std::vector<Chunk*> chunks)
{
    for (Chunk* c : chunks) {
        write_one_chunk(c);
    }
}
