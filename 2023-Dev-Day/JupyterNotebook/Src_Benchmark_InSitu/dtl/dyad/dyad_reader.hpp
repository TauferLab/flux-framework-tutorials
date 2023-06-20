#ifndef __DYAD_READER_HPP__
#define __DYAD_READER_HPP__

#include "benchmark_reader.hpp"
#include "dtl_defines.hpp"

#if defined(DYAD_API_STREAM) && defined(DYAD_API_WRAPPER)
#error "Cannot build DyadReader to work with both DYAD's stream and wrapper APIs"
#endif

#ifdef DYAD_API_STREAM
#include <dyad_stream_api.hpp>
#endif

class DyadReader : public BenchmarkReader
{

    public:

        DyadReader(unsigned long int group_id,
                const CLI::Option_group* cmd_line_args);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

    protected:

        Chunk* read_one_chunk(unsigned long int chunk_id) override;

        std::string m_read_dir;

#ifdef DYAD_API_STREAM
        dyad::ifstream_dyad m_if;
#endif

};

#endif /* __DYAD_READER_HPP__ */
