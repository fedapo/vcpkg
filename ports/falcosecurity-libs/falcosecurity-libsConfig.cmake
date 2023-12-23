get_filename_component(falcosecurity-libs_CMAKE_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)

include(CMakeFindDependencyMacro)

#find_path(UTHASH_INCLUDE_DIRS "utarray.h")

#find_dependency(c-ares)
find_dependency(CURL)
find_dependency(gRPC CONFIG)
#find_dependency(valijson)

#if(NOT TARGET falcosecurity::scap)
    #include(${falcosecurity-libs_CMAKE_DIR}/falcosecurity-libsTargets.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/falcosecurity-libsTargets.cmake)
#endif(
