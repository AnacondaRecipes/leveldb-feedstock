:: Modified version of https://github.com/willyd/leveldb/blob/master/CMakeLists.txt

:: Remove -GL from CXXFLAGS as this causes a fatal error
set "CXXFLAGS= -MD"
set

xcopy /s /y "%RECIPE_DIR%\CMakeLists.txt" "%SRC_DIR%"
if errorlevel 1 exit 1

mkdir build_release
cd build_release

cmake -G"NMake Makefiles" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DSNAPPY_INCLUDE_DIRS="%LIBRARY_INC%" ^
    ..
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

ctest --tests-regex _test
if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1
