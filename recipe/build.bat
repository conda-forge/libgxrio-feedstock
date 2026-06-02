@echo on

cmake -S . -B build -G "NMake Makefiles JOM" ^
  %CMAKE_ARGS% ^
  -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -DBUILD_TESTING=ON ^
  -DBUILD_SHARED_LIBS=ON
if %ERRORLEVEL% neq 0 exit /b 1

cmake --build build --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit /b 1

ctest -V --test-dir build
if %ERRORLEVEL% neq 0 exit /b 1

cmake --install build
if %ERRORLEVEL% neq 0 exit /b 1
