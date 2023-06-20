#include <string>

#include <mpi.h>
#include <pdb_chunker.h>
#include <md_stager.h>
#include <md_intermediator.h>
#include <md_generator.h>
#include <timer.h>

#include "dtl_writer.hpp"

int main(int argc, char** argv)
{
    printf("---======== In Producer::main()\n");
    MPI_Init(&argc, &argv);

    CLI::App app;
    CLI::Option_group* dtl_args;
    std::string py_path;
    std::string py_func;
    int n_frames;
    int n_atoms;
    int n_delay_ms;
    unsigned long int group_id;

    MPI_Comm_rank(MPI_COMM_WORLD, (int*) &group_id);

    app.add_option(
        "py_path",
        py_path,
        "Path to Python script containing the data generation function"
    );
    app.add_option(
        "py_func",
        py_func,
        "Name of the data generation function"
    );
    app.add_option(
        "n_frames",
        n_frames,
        "Number of frames to generate"
    );
    app.add_option(
        "n_atoms",
        n_atoms,
        "Number of atoms in generated data"
    );
    app.add_option(
        "n_delay_ms",
        n_delay_ms,
        "TBA"
    );
    dtl_args = app.add_option_group(
        "dtl_args",
        "Arguments for the specified Data Transport Layer"
    );
    @dtl_writer_class_name@::set_cmdline_args(dtl_args);

    CLI11_PARSE(app, argc, argv);

    // Number of chunks
    unsigned long int total_chunks = n_frames;

    // Preprocess Python script
    std::size_t module_start = py_path.find_last_of("/");
    std::size_t module_end = py_path.rfind(".py");
    if (module_end == std::string::npos)
    {
        fprintf(stderr, "ERROR: Expecting a python module in the py_path argument.\n");
        return -1;
    }
    // get directory
    std::string py_dir = (std::string::npos==module_start)? std::string(".") : py_path.substr(0,module_start);
    // get file
    std::string py_name = py_path.substr(module_start+1, module_end-module_start-1);
    printf("Python directory : %s\n", py_dir.c_str());
    printf("Python script name : %s\n", py_name.c_str());
    printf("Python function: %s\n", py_func.c_str());

    char *file_path = (char*)"";
    ChunkReader *chunk_reader = new PDBChunker((char*)py_name.c_str(), (char*)py_func.c_str(), (char*)py_dir.c_str(), file_path, n_atoms, 0);

    ChunkWriter *chunk_writer;

#ifdef NEEDS_MPI
    chunk_writer = new @dtl_writer_class_name@(
        group_id,
        dtl_args,
        MPI_COMM_WORLD
    );
#else
    chunk_writer = new @dtl_writer_class_name@(
        group_id,
        dtl_args
    );
#endif

    ChunkStager *chunk_stager = new MDStager(chunk_reader, chunk_writer);
    Ingester *ingester = new MDGenerator(*chunk_stager, total_chunks, n_delay_ms);

    // Main run
    TimeVar t_start = timeNow();
    ingester->run();
    DurationMilli ingester_time_ms = timeNow() - t_start;
    auto total_ingester_time_ms = ingester_time_ms.count();
    printf("total_ingester_time_ms : %f\n", total_ingester_time_ms);

    // Free Memory
    delete ingester;
    delete chunk_stager;
    delete chunk_writer;
    delete chunk_reader;
    //}

    MPI_Finalize();
    return 0;
}
