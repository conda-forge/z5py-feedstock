##
## START THE BUILD
##

mkdir -p build
cd build

PYTHON_EXECUTABLE="${PREFIX}/bin/python"

if [[ "${target_platform}" == "osx-64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

##
## Configure
##
cmake ${CMAKE_ARGS} .. \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_PREFIX_PATH=${PREFIX} \
\
        -DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS} -O3 -DNDEBUG" \
        -DCMAKE_CXX_FLAGS_DEBUG="${CXXFLAGS}" \
\
        -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE} \
        -DBOOST_ROOT=${PREFIX} \
        -DBUILD_Z5PY=ON \
        -DWITH_BLOSC=ON \
        -DWITH_ZLIB=ON \
        -DWITH_BZIP2=ON \
        -DWITH_XZ=ON \
        -DWITH_LZ4=OFF \
        -DWITHIN_TRAVIS=OFF \


##
## Compile and install
##
make -j${CPU_COUNT}
make install
