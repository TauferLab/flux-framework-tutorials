#ifndef __{{ file_prefix | upper }}_WRITER_HPP__
#define __{{ file_prefix | upper }}_WRITER_HPP__

#include "benchmark_writer.hpp"

class {{ class_prefix }}Writer : public ChunkWriter
{

    public:

        {{ class_prefix}}Writer(const CLI::Option_group* cmd_line_args);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

        // Uncomment if you want a custom version of write_chunks
        // void write_chunks(std::vector<Chunk*> chunks) override;

    private:

        void write_one_chunk(Chunk* chunk);

};

#endif /* __{{ file_prefix | upper }}_WRITER_HPP__ */
