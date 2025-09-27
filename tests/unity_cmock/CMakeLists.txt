cmake_minimum_required(VERSION 3.22)

project(Template_STM32_Tests VERSION 1.0.0 LANGUAGES C CXX)

enable_testing()

set(UNITY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../submodules/Unity)
set(CMOCK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../submodules/CMock)

include_directories(
    ${UNITY_DIR}/src
    ${CMOCK_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/../../inc
)

set(PROJECT_SRC
    #${CMAKE_CURRENT_SOURCE_DIR}/../../src/my_module.c
)

set(TEST_SRC
    test.c
)

add_executable(UnitTests
    ${PROJECT_SRC}
    ${TEST_SRC}
    ${UNITY_DIR}/src/unity.c
    ${CMOCK_DIR}/src/cmock.c
)

target_include_directories(UnitTests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../inc
)

target_compile_options(UnitTests PRIVATE
    -Wall -Wextra -Werror
)

add_test(NAME RunUnitTests COMMAND UnitTests)
