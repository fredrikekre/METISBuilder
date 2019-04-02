# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "METIS"
version = v"5.1.0"

# Collection of sources required to build METIS
sources = [
    "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz" =>
    "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/metis-5.1.0/
mkdir -p build
cd build/
cmake $WORKSPACE/srcdir/metis-5.1.0/ -DCMAKE_VERBOSE_MAKEFILE=1 -DGKLIB_PATH=$WORKSPACE/srcdir/metis-5.1.0/GKlib -DCMAKE_INSTALL_PREFIX=$prefix -DSHARED=1 -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc} install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmetis", :libmetis)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

