#ifndef __DSPACES_WRITER_HPP__
#define __DSPACES_WRITER_HPP__

#include <memory>

#include "benchmark_writer.hpp"
#include <dataspaces_writer.h>

class DSpacesWriter : public ChunkWriter
{

    public:

        DSpacesWriter(const CLI::Option_group* cmd_line_args, MPI_Comm comm);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

        void write_chunks(std::vector<Chunk*> chunks) override;

    private:

        void write_one_chunk(Chunk* chunk);

        std::unique_ptr<DataSpacesWriter> m_writer;

};

#endif /* __DSPACES_WRITER_HPP__ */
