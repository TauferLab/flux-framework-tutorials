#ifndef __DYAD_WRITER_HPP__
#define __DYAD_WRITER_HPP__

#include "benchmark_writer.hpp"
#include "dtl_defines.hpp"

#if defined(DYAD_API_STREAM) && defined(DYAD_API_WRAPPER)
#error "Cannot build DyadWriter to work with both DYAD's stream and wrapper APIs"
#endif

#ifdef DYAD_API_STREAM
#include <dyad_stream_api.hpp>
#endif

class DyadWriter : public BenchmarkWriter
{

    public:

        DyadWriter(unsigned long int group_id, const CLI::Option_group* cmd_line_args);

        static void set_cmdline_args(CLI::Option_group* cmd_line_arg_defs);

    protected:

        void write_one_chunk(Chunk* chunk) override;

        std::string m_write_dir;

#ifdef DYAD_API_STREAM
        dyad::ofstream_dyad m_of;
#endif

};

#endif /* __DYAD_WRITER_HPP__ */
