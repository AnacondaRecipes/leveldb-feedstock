cmake_minimum_required(VERSION 3.4)

project(leveldb)

set(SNAPPY_LIBRARY "snappy")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
    include
    ${SNAPPY_INCLUDE_DIRS})

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

add_definitions(
    -DLEVELDB_ATOMIC_PRESENT
    -DLEVELDB_PLATFORM_WINDOWS
    -Dssize_t=ptrdiff_t
    )

set(LEVEL_DB_FILES
    include/leveldb/c.h
    include/leveldb/cache.h
    include/leveldb/comparator.h
    include/leveldb/db.h
    include/leveldb/dumpfile.h
    include/leveldb/env.h
    include/leveldb/iterator.h
    include/leveldb/filter_policy.h
    include/leveldb/iterator.h
    include/leveldb/options.h
    include/leveldb/slice.h
    include/leveldb/status.h
    include/leveldb/table.h
    include/leveldb/table_builder.h
    include/leveldb/write_batch.h
    db/c.cc
    db/builder.cc
    db/builder.h
    db/db_impl.cc
    db/db_impl.h
    db/db_iter.cc
    db/db_iter.h
    db/dbformat.cc
    db/dbformat.h
    db/dumpfile.cc
    db/filename.cc
    db/filename.h
    db/log_format.h
    db/log_reader.cc
    db/log_reader.h
    db/log_writer.cc
    db/log_writer.h
    db/skiplist.h
    db/snapshot.h
    db/memtable.cc
    db/memtable.h
    db/repair.cc
    db/table_cache.cc
    db/table_cache.h
    db/version_edit.cc
    db/version_edit.h
    db/version_set.cc
    db/version_set.h
    db/write_batch.cc
    table/block.cc
    table/block.h
    table/block_builder.cc
    table/block_builder.h
    table/filter_block.cc
    table/filter_block.h
    table/format.cc
    table/format.h
    table/iterator.cc
    table/iterator_wrapper.h
    table/merger.cc
    table/merger.h
    table/table.cc
    table/table_builder.cc
    table/two_level_iterator.cc
    table/two_level_iterator.h
    util/arena.cc
    util/arena.h
    util/bloom.cc
    util/cache.cc
    util/coding.cc
    util/coding.h
    util/comparator.cc
    util/crc32c.cc
    util/crc32c.h
    util/env.cc
    util/env_win.cc
    util/filter_policy.cc
    util/hash.cc
    util/hash.h
    util/histogram.cc
    util/histogram.h
    util/logging.cc
    util/logging.h
    util/mutexlock.h
    util/options.cc
    util/random.h
    util/status.cc
    port/port.h
    port/port_win.h
    port/port_win.cc
    port/port_posix_sse.cc
    )

set (MEM_ENV_FILES
    helpers/memenv/memenv.cc
    helpers/memenv/memenv.h
    )

add_library(leveldb SHARED ${LEVEL_DB_FILES})
add_library(leveldb_static STATIC ${LEVEL_DB_FILES})

add_library(memenv_static STATIC ${MEM_ENV_FILES})

include_directories(
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
    )

target_link_libraries(leveldb
    shlwapi
    ${SNAPPY_LIBRARY}
    )

target_link_libraries(leveldb_static
    shlwapi
    ${SNAPPY_LIBRARY}
    )

target_link_libraries(memenv_static
    leveldb_static
    )

install(DIRECTORY include DESTINATION .)

add_executable(leveldbutil
    db/leveldbutil.cc)

target_link_libraries(leveldbutil
    leveldb_static)

install(TARGETS leveldb leveldb_static leveldbutil memenv_static
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

##################################### TESTS #######################################
# Every leveldb test file has to be compiled as an independant binary
# because of the test framework used by leveldb.
add_library(leveldb_test_rt
    util/testutil.h
    util/testutil.cc
    util/testharness.h
    util/testharness.cc)

enable_testing()

target_include_directories(leveldb_test_rt
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

macro(leveldb_tests)
    foreach(t ${ARGN})
        get_filename_component(_tname ${t} NAME_WE)
        add_executable(${_tname} ${t})
        target_link_libraries(${_tname}
            leveldb_test_rt
            leveldb_static
                        memenv_static
            )
        add_test(NAME ${_tname}
            COMMAND $<TARGET_FILE:${_tname}>)
    endforeach()
endmacro()

leveldb_tests(
    db/autocompact_test
    db/c_test
    db/corruption_test
    db/db_test
    db/dbformat_test
    db/fault_injection_test
    db/filename_test
    db/log_test
    db/recovery_test
    db/skiplist_test
    db/version_edit_test
    db/version_set_test
    db/write_batch_test
    helpers/memenv/memenv_test
    issues/issue178_test
    issues/issue200_test
    table/filter_block_test
    table/table_test
    util/arena_test
    util/bloom_test
    util/cache_test
    util/coding_test
    util/crc32c_test
    util/env_test
    util/hash_test)
