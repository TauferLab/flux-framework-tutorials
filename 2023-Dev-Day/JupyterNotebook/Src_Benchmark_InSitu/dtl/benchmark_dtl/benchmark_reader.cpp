#include "benchmark_reader.hpp"

#include <cstdio>

BenchmarkReader::BenchmarkReader(unsigned long int group_id,
        const CLI::Option_group* cmd_line_args)
    : m_group_id(group_id)
{
}

std::vector<Chunk*> BenchmarkReader::read_chunks(
        unsigned long int chunk_id_from,
        unsigned long int chunk_id_to)
{
    std::vector<Chunk*> chunks;
    for (unsigned long int i = chunk_id_from; i <= chunk_id_to; i++) {
        printf("READING CHUNK %lu!!!!\n", i);
        chunks.push_back(read_one_chunk(i));
    }
    return chunks;
}
