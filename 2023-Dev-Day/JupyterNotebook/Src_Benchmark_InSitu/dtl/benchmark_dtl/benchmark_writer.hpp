#ifndef __BENCHMARK_DTL_WRITER_HPP__
#define __BENCHMARK_DTL_WRITER_HPP__

#include <chunk_writer.h>
#include <CLI/CLI.hpp>

class BenchmarkWriter : public ChunkWriter
{
    public:

        BenchmarkWriter() = default;

        BenchmarkWriter(unsigned long int group_id,
                const CLI::Option_group* cmd_line_args);

        virtual ~BenchmarkWriter() = default;

        virtual void write_chunks(std::vector<Chunk*> chunks) override;

    protected:

        virtual void write_one_chunk(Chunk* chunk) = 0;

        unsigned long int m_group_id;

};

#endif /* __BENCHMARK_DTL_WRITER_HPP__ */
