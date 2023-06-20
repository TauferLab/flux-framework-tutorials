#include <CLI/CLI.hpp>

#include <cmath>
#include <cstdio>

int main(int argc, char** argv)
{
    CLI::App app("Calculate number of natoms for the descired data size (in bytes)");
    std::size_t dsize = 0;
    app.add_option("data_size", dsize, "Desired data size (in bytes)");
    CLI11_PARSE(app, argc, argv);
    std::size_t int_size = sizeof(int);
    std::size_t double_size = sizeof(double);

    dsize -= int_size + (6 * double_size);

    double natoms_float = static_cast<double>(dsize) / (int_size + (3 * double_size));
    std::size_t natoms = static_cast<std::size_t>(std::ceil(natoms_float));
    
    std::size_t chunk_size = natoms * (int_size + (3 * double_size)) + int_size + (6 * double_size);

    printf(
        "%lu atoms will produce a chunk of size %lu (target %lu)\n",
        natoms,
        chunk_size,
        dsize
    );
    return 0;
}
