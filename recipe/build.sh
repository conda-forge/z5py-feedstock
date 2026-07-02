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
        -DPython_EXECUTABLE=${PYTHON_EXECUTABLE} \
        -DPython_INCLUDE_DIR=${PREFIX}/include/python${PY_VER} \
        -DPYTHON_MODULE_INSTALL_DIR=${SP_DIR} \
        -DBUILD_Z5PY=ON \
        -DWITH_BLOSC=ON \
        -DWITH_ZLIB=ON \
        -DWITH_BZIP2=ON \
        -DWITH_XZ=ON \
        -DWITH_LZ4=ON \
        -DWITH_ZSTD=ON \
        -DWITHIN_TRAVIS=OFF \


##
## Compile and install
##
make -j${CPU_COUNT}
make install

# Cross-compiled packages cannot reliably run their target Python during the
# build. Check the staged payload directly so a package containing only the C++
# headers cannot be published as z5py.
test -f "${SP_DIR}/z5py/__init__.py"
test -f "${SP_DIR}"/z5py/_z5py*.so

# The direct CMake install bypasses the Python build backend, so create the
# distribution metadata that importlib.metadata and pip use for dependency
# resolution. Use the build interpreter when cross-compiling because the
# target interpreter cannot run on the build platform.
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
    METADATA_PYTHON="${BUILD_PREFIX}/bin/python"
else
    METADATA_PYTHON="${PYTHON}"
fi
"${METADATA_PYTHON}" "${RECIPE_DIR}/write_dist_info.py" "${SP_DIR}" "${PKG_VERSION}"
