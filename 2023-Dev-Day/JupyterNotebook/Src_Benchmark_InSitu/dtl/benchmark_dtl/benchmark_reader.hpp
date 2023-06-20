#ifndef __BENCHMARK_DTL_READER_HPP__
#define __BENCHMARK_DTL_READER_HPP__

#include <chunk_reader.h>
#include <CLI/CLI.hpp>

class BenchmarkReader : public ChunkReader
{
    public:

        BenchmarkReader() = default;

        BenchmarkReader(unsigned long int group_id,
                const CLI::Option_group* cmd_line_args);

        virtual ~BenchmarkReader() = default;

        virtual std::vector<Chunk*> read_chunks(unsigned long int chunk_id_from,
                unsigned long int chunk_id_to) override;

    protected:

        virtual Chunk* read_one_chunk(unsigned long int chunk_id) = 0;

        unsigned long int m_group_id;

};

#endif /* __BENCHMARK_DTL_READER_HPP__ */
