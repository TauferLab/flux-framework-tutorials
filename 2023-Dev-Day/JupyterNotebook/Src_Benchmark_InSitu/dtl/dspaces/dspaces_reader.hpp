#ifndef __DSPACES_READER_HPP__
#define __DSPACES_READER_HPP__

#include <memory>

#include "benchmark_reader.hpp"
#include <dataspaces_reader.h>

class DSpacesReader : public BenchmarkReader
{

    public:

        DSpacesReader(const CLI::Option_group* cmd_line_args, MPI_Comm comm);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

        std::vector<Chunk*> read_chunks(unsigned long int chunks_from,
                unsigned long int chunks_to) override;

    protected:

        Chunk* read_one_chunk(unsigned long int chunk_id) override;

        std::unique_ptr<DataSpacesReader> m_reader;

};

#endif /* __DSPACES_READER_HPP__ */
