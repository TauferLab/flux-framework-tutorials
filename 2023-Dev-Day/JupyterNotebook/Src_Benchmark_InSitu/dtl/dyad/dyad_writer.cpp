#include "dyad_writer.hpp"
#include <chunk_serializer.h>
#include <stdexcept>
#include <string>

#if (__cplusplus >= 201703L) && __has_include(<filesystem>)
#include <filesystem>

using namespace std::filesystem;
#else
#include <boost/filesystem.hpp>

using namespace boost::filesystem;
#endif

DyadWriter::DyadWriter(unsigned long int group_id, const CLI::Option_group* cmd_line_args)
    : BenchmarkWriter(group_id, cmd_line_args)
#ifdef DYAD_API_STREAM
    , m_of()
#endif
{
    std::string managed_dir = cmd_line_args->get_option("--managed_dir")->as<std::string>();
    std::string write_dir = "group";
    write_dir += std::to_string(m_group_id);
    path write_dir_path(managed_dir);
    write_dir_path /= write_dir;
    if (!exists(write_dir_path))
        create_directory(write_dir_path);
    if (!is_directory(write_dir_path))
        throw std::runtime_error("Specified write directory is not a directory");
    m_write_dir = write_dir_path.string();
}

void DyadWriter::set_cmdline_args(CLI::Option_group* cmd_line_arg_defs)
{
    CLI::TypeValidator<int> int_validator("int");
    CLI::TypeValidator<unsigned long int> ulong_validator("unsigned long");
    CLI::detail::ExistingDirectoryValidator dir_validator;
    cmd_line_arg_defs->add_option(
        "-d,--managed_dir",
        "Directory to which to write data files"
    )->check(dir_validator)->required();
}

void DyadWriter::write_one_chunk(Chunk* chunk)
{
    unsigned long int chunk_id = chunk->get_chunk_id();
    std::string fname = "a4md_chunk";
    fname += std::to_string(chunk_id);
    fname += ".dat";
    path p(m_write_dir);
    p /= fname;
    p = absolute(p);
    fname = p.string();
    printf("Writing file %s\n", fname.c_str());
    SerializableChunk serializable_chunk = SerializableChunk(chunk);
    std::string raw_data;
    ChunkSerializer<SerializableChunk> chunk_serializer;
    bool ret = chunk_serializer.serialize(serializable_chunk, raw_data);
    if (!ret)
    {
        printf("----====== ERROR: Failed to serialize chunk in FileIOWriter\n");
        printf("Failed to serialize %s\n", fname.c_str());
        return;
    }
    std::size_t data_size = raw_data.size();
    printf("File size for %s: %lu\n", fname.c_str(), data_size);
    char* c_data = (char*) raw_data.data();
#ifdef DYAD_API_WRAPPER
    FILE* fp = fopen(fname.c_str(), "w");
    if (fp == NULL)
    {
        printf("----====== ERROR: Could not open file %s (errno = %d)\n", fname.c_str(), errno);
        printf("Failed to open %s\n", fname.c_str());
        return;
    }
    std::size_t num_written = fwrite(
            (void*) c_data,
            sizeof(char),
            data_size,
            fp
    );
    fclose(fp);
    if (num_written != data_size)
    {
        printf("----====== ERROR: Could not successfully write to file %s (errno = %d)\n", fname.c_str(), errno);
        printf("Failed to write %s\n", fname.c_str());
        return;
    }
#endif
#ifdef DYAD_API_STREAM
    m_of.open(fname, std::ios::out | std::ios::binary);
    if (!m_of.is_open()) {
        printf("----====== ERROR: Could not open file %s (errno = %d)\n", fname.c_str(), errno);
        printf("Failed to open %s\n", fname.c_str());
        return;
    }
    std::ofstream& real_of = m_of.get_stream();
    real_of.write(c_data, data_size);
    m_of.close();
    if (real_of.fail()) {
        printf("----====== ERROR: Could not successfully write to file %s (errno = %d)\n", fname.c_str(), errno);
        printf("Failed to write %s\n", fname.c_str());
        return;
    }
#endif
    printf("Successfully wrote file %s\n", fname.c_str());
    return;
}
