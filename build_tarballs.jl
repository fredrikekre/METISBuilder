using BinaryBuilder

# Collection of sources required to build metis
sources = [
    "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz" =>
    "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd metis-5.1.0/

make config prefix=$prefix shared=1
make
make install

exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.Linux(:aarch64, :glibc),
    BinaryProvider.Linux(:armv7l, :glibc),
    BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS()
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmetis", :libmetis)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "metis", sources, script, platforms, products, dependencies)

