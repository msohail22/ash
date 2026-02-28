cmake_minimum_required(VERSION 3.22)

project(ash_shell VERSION 0.1.0 LANGUAGES CXX)

# ----------------------------
# C++ Standard
# ----------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ----------------------------
# Project Warning Interface
# ----------------------------
add_library(project_warnings INTERFACE)

target_compile_options(project_warnings INTERFACE
    -Wall
    -Wextra
    -Wpedantic
    -Wconversion
    -Werror
)

# ----------------------------
# Production Executable
# ----------------------------
add_executable(ash_shell
    src/main.cpp
)

target_include_directories(ash_shell PRIVATE include)
target_link_libraries(ash_shell PRIVATE project_warnings)

# ----------------------------
# Catch2 (Testing)
# ----------------------------
add_subdirectory(external/Catch2)

add_executable(shell_tests
    tests/test_parser.cpp
)

target_include_directories(shell_tests PRIVATE include)

target_link_libraries(shell_tests PRIVATE
    Catch2::Catch2WithMain
    project_warnings
)

# ----------------------------
# Sanitizers (Debug Only)
# ----------------------------
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(ash_shell PRIVATE -fsanitize=address,undefined -g)
    target_link_options(ash_shell PRIVATE -fsanitize=address,undefined)

    target_compile_options(shell_tests PRIVATE -fsanitize=address,undefined -g)
    target_link_options(shell_tests PRIVATE -fsanitize=address,undefined)
endif()
