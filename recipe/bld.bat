mkdir build
cd build

set CONFIGURATION=Release

cmake .. -GNinja ^
         -DCMAKE_BUILD_TYPE=%CONFIGURATION% ^
         -DCMAKE_PREFIX_PATH="%PREFIX%" ^
         -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
         -DWITH_BLOSC=ON ^
         -DWITH_ZLIB=ON ^
         -DWITH_BZIP2=ON ^
         -DWITH_XZ=ON ^
         -DWITH_LZ4=OFF ^
         -DWITH_ZSTD=ON ^
         -DWITHIN_TRAVIS=OFF ^
         -DBUILD_Z5PY=ON ^
         -DPYTHON_EXECUTABLE="%PYTHON%"

cmake --build . --config %CONFIGURATION% --target install

REM The direct CMake install bypasses the Python build backend, so create the
REM distribution metadata that importlib.metadata and pip use for dependency
REM resolution.
"%PYTHON%" "%RECIPE_DIR%\write_dist_info.py" "%SP_DIR%" "%PKG_VERSION%"
