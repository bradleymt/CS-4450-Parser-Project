cmake_minimum_required(VERSION 3.16)
project(PseudoPythonParser CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#makes build/compile_commands.json so vscode can find the antlr headers
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES OFF)

#jar and runtime need to be the same version
set(ANTLR_VERSION 4.13.2)

find_package(Java COMPONENTS Runtime REQUIRED)


#downloads the jar if you dont pass -DANTLR_JAR=...
set(ANTLR_JAR "" CACHE FILEPATH "Path to antlr jar")
if(NOT ANTLR_JAR)
    set(ANTLR_JAR ${CMAKE_BINARY_DIR}/antlr-${ANTLR_VERSION}-complete.jar)
    if(NOT EXISTS ${ANTLR_JAR})
        file(DOWNLOAD https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar ${ANTLR_JAR})
    endif()
endif()

#antlr c++ runtime, only need the static lib
include(FetchContent)
set(ANTLR_BUILD_CPP_TESTS OFF CACHE BOOL "" FORCE)
set(ANTLR_BUILD_SHARED OFF CACHE BOOL "" FORCE)
set(ANTLR_BUILD_STATIC ON CACHE BOOL "" FORCE)
set(DISABLE_WARNINGS ON CACHE BOOL "" FORCE)

FetchContent_Declare(antlr4_runtime
    URL https://www.antlr.org/download/antlr4-cpp-runtime-${ANTLR_VERSION}-source.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(antlr4_runtime)



#generate the lexer/parser from the grammar
set(GRAMMAR_FILE ${CMAKE_SOURCE_DIR}/grammar/PseudoPython.g4)
set(GENERATED_DIR ${CMAKE_BINARY_DIR}/generated)

set(GENERATED_FILES
    ${GENERATED_DIR}/PseudoPythonLexer.cpp
    ${GENERATED_DIR}/PseudoPythonLexer.h
    ${GENERATED_DIR}/PseudoPythonParser.cpp
    ${GENERATED_DIR}/PseudoPythonParser.h
    ${GENERATED_DIR}/PseudoPythonListener.cpp
    ${GENERATED_DIR}/PseudoPythonListener.h
    ${GENERATED_DIR}/PseudoPythonBaseListener.cpp
    ${GENERATED_DIR}/PseudoPythonBaseListener.h
)


#reruns antlr whenevr the .g4 changes
add_custom_command(
    OUTPUT ${GENERATED_FILES}
    COMMAND ${Java_JAVA_EXECUTABLE} -jar ${ANTLR_JAR} -Dlanguage=Cpp -o ${GENERATED_DIR} -Xexact-output-dir ${GRAMMAR_FILE}
    DEPENDS ${GRAMMAR_FILE}
)

add_executable(python_parser src/main.cpp src/parser.cpp ${GENERATED_FILES})
target_include_directories(python_parser PRIVATE ${CMAKE_SOURCE_DIR}/src ${GENERATED_DIR})
target_link_libraries(python_parser PRIVATE antlr4_static)
