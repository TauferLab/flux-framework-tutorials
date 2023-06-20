#include <CLI/CLI.hpp>

#include <cstdio>

int main(int argc, char** argv)
{
    CLI::App app("Calculate data size (in bytes) based on number of atoms");
    int natoms = 0;
    app.add_option("natoms", natoms, "Number of atoms");
    CLI11_PARSE(app, argc, argv);
    std::size_t int_size = sizeof(int);
    std::size_t double_size = sizeof(double);

    // Size of timestep and the 6 box fields
    std::size_t chunk_size = int_size + (6 * double_size);
    // Add size of types field
    chunk_size += natoms * int_size;
    // Add size of the 3 coordinate fields
    chunk_size += 3 * (natoms * double_size);

    printf("Chunks of data will be (roughly) %lu bytes\n", chunk_size);
    return 0;
}
