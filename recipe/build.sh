set -exo pipefail

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

if [[ ${build_platform} != ${target_platform} ]]; then
  extra_cmake_args="-DTEST_STD_CHRONO_FROM_STREAM_R=ON"
fi

# Skip tests for cross compilation for macos
if [[ ${build_platform} != ${target_platform} && ${target_platform} == "osx-arm64" ]]; then
  cmake -S . -B build ${CMAKE_ARGS} -DBUILD_TESTING=OFF
else
  cmake -S . -B build ${CMAKE_ARGS} -DBUILD_TESTING=ON ${extra_cmake_args}
fi

cmake --build build --parallel ${CPU_COUNT}
ctest -V --test-dir build
cmake --install build
