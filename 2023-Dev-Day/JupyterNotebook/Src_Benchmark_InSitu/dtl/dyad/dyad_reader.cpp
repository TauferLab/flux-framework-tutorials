#include "dyad_reader.hpp"

#include <chunk_serializer.h>
#include <stdexcept>
#include <cstdio>

#if (__cplusplus >= 201703L) && __has_include(<filesystem>)
#include <filesystem>

using namespace std::filesystem;
#else
#include <boost/filesystem.hpp>

using namespace boost::filesystem;
#endif

DyadReader::DyadReader(unsigned long int group_id,
        const CLI::Option_group* cmd_line_args)
    : BenchmarkReader(group_id, cmd_line_args)
#ifdef DYAD_API_STREAM
    , m_if()
#endif
{
    std::string managed_dir = cmd_line_args->get_option("--managed_dir")->as<std::string>();
    std::string read_dir = "group";
    read_dir += std::to_string(m_group_id);
    path read_dir_path(managed_dir);
    read_dir_path /= read_dir;
    if (!exists(read_dir_path))
        create_directory(read_dir_path);
    if (!is_directory(read_dir_path))
        throw std::runtime_error("Specified read directory is not a directory");
    m_read_dir = read_dir_path.string();
}

void DyadReader::set_cmdline_args(CLI::Option_group* cmd_line_arg_defs)
{
    CLI::TypeValidator<unsigned long int> ulong_validator("unsigned long");
    CLI::TypeValidator<int> int_validator("int");
    CLI::detail::ExistingDirectoryValidator dir_validator;
    cmd_line_arg_defs->add_option(
        "-d, --managed_dir",
        "Directory from which to read data files"
    )->check(dir_validator)->required();
}

Chunk* DyadReader::read_one_chunk(unsigned long int chunk_id)
{
    printf("IN READ_ONE_CHUNK!!!!\n");
    std::string fname = "a4md_chunk";
    fname += std::to_string(chunk_id);
    fname += ".dat";
    path p(m_read_dir);
    p /= fname;
    p = absolute(p);
    fname = p.string();
    std::size_t chunk_size;
    char* data_buf;
    printf("Reading file %s\n", fname.c_str());
#ifdef DYAD_API_WRAPPER
    FILE* fp = fopen(fname.c_str(), "r");
    if (fp == NULL) {
        // TODO Log error
        printf("Failed to open %s\n", fname.c_str());
        return nullptr;
    }
    int ret = fseek(fp, 0, SEEK_END);
    if (ret != 0) {
        // TODO log error
        fclose(fp);
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    long long_size = ftell(fp);
    if (long_size == -1) {
        // TODO log error
        fclose(fp);
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    chunk_size = (std::size_t) long_size;
    ret = fseek(fp, 0, SEEK_SET);
    if (ret != 0) {
        // TODO log error
        fclose(fp);
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    printf("Size of %s: %lu\n", fname.c_str(), chunk_size);
    data_buf = (char*) malloc(chunk_size);
    if (data_buf == NULL) {
        fclose(fp);
        printf("Cannot allocate memory for %s\n", fname.c_str());
        return nullptr;
    }
    std::size_t num_read = fread(
        (void*) data_buf,
        sizeof(char),
        chunk_size,
        fp
    );
    fclose(fp);
    if (num_read != chunk_size) {
        // TODO log error
        free(data_buf);
        printf("Failed to read %s\n", fname.c_str());
        return nullptr;
    }
#endif
#ifdef DYAD_API_STREAM
    m_if.open(fname, std::ios::in | std::ios::binary);
    if (!m_if.is_open()) {
        printf("Failed to open %s\n", fname.c_str());
        return nullptr;
    }
    std::ifstream& real_if = m_if.get_stream();
    real_if.seekg(0, std::ios::end);
    if (real_if.bad()) {
        m_if.close();
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    real_if.clear();
    std::streampos end = real_if.tellg();
    if (real_if.bad()) {
        m_if.close();
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    real_if.clear();
    real_if.seekg(0, std::ios::beg);
    if (real_if.bad()) {
        m_if.close();
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    real_if.clear();
    std::streampos begin = real_if.tellg();
    if (real_if.bad()) {
        m_if.close();
        printf("Failed get size of %s\n", fname.c_str());
        return nullptr;
    }
    chunk_size = (std::size_t) (end - begin);
    if (chunk_size == 0) {
        m_if.close();
        printf("Cannot ingest empty file %s\n", fname.c_str());
        return nullptr;
    }
    real_if.clear();
    printf("Size of %s: %lu\n", fname.c_str(), chunk_size);
    data_buf = (char*) malloc(chunk_size);
    if (data_buf == NULL) {
        m_if.close();
        printf("Cannot allocate memory for %s\n", fname.c_str());
        return nullptr;
    }
    real_if.read(data_buf, chunk_size);
    m_if.close();
    if (real_if.fail()) {
        // TODO log error
        free(data_buf);
        printf("Failed to read %s\n", fname.c_str());
        return nullptr;
    }
#endif
    SerializableChunk ser_chunk;
    ChunkSerializer<SerializableChunk> chunk_serializer;
    bool ser_ret = chunk_serializer.deserialize(
        ser_chunk,
        data_buf,
        chunk_size
    );
    free(data_buf);
    if (!ser_ret) {
        // TODO log error
        printf("Failed to deserialize %s\n", fname.c_str());
        return nullptr;
    }
    printf("Read succeeded: %s\n", fname.c_str());
    return ser_chunk.get_chunk();
}
