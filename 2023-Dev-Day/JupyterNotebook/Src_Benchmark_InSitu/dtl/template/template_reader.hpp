#ifndef __{{ file_prefix | upper }}_READER_HPP__
#define __{{ file_prefix | upper }}_READER_HPP__

#include "benchmark_reader.hpp"

class {{ class_prefix }}Reader : public BenchmarkReader
{

    public:

        {{ class_prefix }}Reader(const CLI::Option_group* cmd_line_args);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

        // Uncomment if you want a custom implementation of read_chunks
        // std::vector<Chunk*> read_chunks(unsigned long int chunks_from,
        //         unsigned long int chunks_to) override;

    protected:

        Chunk* read_one_chunk(unsigned long int chunk_id) override;

};

#endif /* __{{ file_prefix | upper }}_READER_HPP__ */
