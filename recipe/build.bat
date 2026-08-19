@echo on

@REM Fix MSVC build: `std::array` iterators are not raw pointers, while `setp()` requires pointers
sed -i.bak "s/Base::setp(buffer_\.begin(), buffer_\.end());/Base::setp(buffer_.data(), buffer_.data() + buffer_.size());/" test/unit-test-xz.cpp

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
