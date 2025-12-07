cmake_minimum_required(VERSION 3.13)
project(IntPatch LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# 1. Use the macro you requested
# Note: Pointing to "pass/pass.cpp" based on your directory structure
add_llvm_pass_plugin(IntPatch pass/pass.cpp)

# 2. THE CRITICAL FIX FOR MACOS
# Without this, 'add_llvm_pass_plugin' will still fail with "undefined symbols"
if(APPLE)
    target_link_options(IntPatch PRIVATE "LINKER:-undefined,dynamic_lookup")
endif()