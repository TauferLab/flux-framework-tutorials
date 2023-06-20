#include <unistd.h>

#include <mpi.h>
#include <md_stager.h>
#include <md_analyzer.h>
#include <md_retriever.h>
#include <timer.h>

#include <stdlib.h>

#include "dtl_reader.hpp"

#include <execinfo.h>
#include <signal.h>

#define TRACE_MAX 1024

void handler(int sig)
{
    void *array[TRACE_MAX];
    size_t size;
    const char msg[] = "Failed with SIGSEV\n";
    size = backtrace(array, TRACE_MAX);
    write(STDERR_FILENO, msg, sizeof(msg));
    backtrace_symbols_fd(array, size, STDERR_FILENO);
    exit(1);
}

int main (int argc, char** argv)
{
    char* e = NULL;
    if ((e = getenv("LD_PRELOAD")))
        printf("LD_PRELOAD = %s\n", e);
    signal(SIGSEGV, handler);
    printf("---======== In Consummer::main()\n");
    MPI_Init(&argc,&argv);

    CLI::App app;
    CLI::Option_group* dtl_args;
    std::string py_path;
    std::string py_func;
    int n_frames;
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
    dtl_args = app.add_option_group(
        "dtl_args",
        "Arguments for the specified Data Transport Layer"
    );
    @dtl_reader_class_name@::set_cmdline_args(dtl_args);

    CLI11_PARSE(app, argc, argv);

    // Number of chunks
    unsigned long int total_chunks = n_frames;// +1 for the call before simulation starts

    // Preprocess Python path
    std::size_t module_start = py_path.find_last_of("/");
    std::size_t module_end = py_path.rfind(".py");
    if (module_end == std::string::npos)
    {
    fprintf(stderr, "ERROR: Expecting a python module in the python script path argument.\n");
        return -1;
    }
    // get directory
    std::string py_dir = (std::string::npos==module_start)? std::string(".") : py_path.substr(0,module_start);
    // get file
    std::string py_name = py_path.substr(module_start+1, module_end-module_start-1);
    printf("Python directory : %s\n", py_dir.c_str());
    printf("Python script name : %s\n", py_name.c_str());
    printf("Python function: %s\n", py_func.c_str());


    ChunkReader* chunk_reader;
#ifdef NEEDS_MPI
    chunk_reader = new @dtl_reader_class_name@(
        group_id,
        dtl_args,
        MPI_COMM_WORLD
    );
#else
    chunk_reader = new @dtl_reader_class_name@(
        group_id,
        dtl_args
    );
#endif

    ChunkWriter *chunk_writer = new MDAnalyzer((char*)py_name.c_str(), (char*)py_func.c_str(), (char*)py_dir.c_str());

    ChunkStager *chunk_stager = new MDStager(chunk_reader, chunk_writer);
    int n_window_width = 1;
    Retriever *retriever = new MDRetriever(*chunk_stager, n_frames, n_window_width);

    // Main run
    TimeVar t_start = timeNow();
    retriever->run();
    DurationMilli md_retriever_time_ms = timeNow()-t_start;
    auto total_md_retriever_time_ms = md_retriever_time_ms.count();
    printf("total_retriever_time_ms : %f\n",total_md_retriever_time_ms);

    // Free memory
    delete retriever;
    delete chunk_stager;
    delete chunk_writer;
    delete chunk_reader;
    //}

    //MPI_Comm_free(&dtl_comm);
    MPI_Finalize();
    return 0;
}
