#
# PACKAGE_NAME =
# PORT = falcosecurity-libs
# CMAKE_CURRENT_LIST_DIR =
# SOURCE_PATH =
# CURRENT_PACKAGES_DIR =
#

message("${PORT} currently requires the following programs from the system package manager:
    autoconf bison clang flex libelf llvm
On Debian and Ubuntu derivatives:
    sudo apt install autoconf bison clang flex libelf-dev llvm"
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO falcosecurity/libs
    REF 5a0302c8752f77a942b8ecc05b3dfc5f0fcf6830
    SHA512 62c884ff635a08f2fa6fd502c02201928673c01c124a70b5e1370ee848476039f61f53a7a528f8c5124cb9d9b073172752404df85f3777802ac4da1f498eadc2
    HEAD_REF master
    PATCHES
        export_as_cmake_package.patch
	libsinsp_CMakeLists.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/falcosecurity-libsConfig.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeInstallTargets.cmake DESTINATION ${SOURCE_PATH})

#
# Variables in falcosecurity's CMake scripts:
#
#  option(CREATE_TEST_TARGETS "Enable make-targets for unit testing" ON)
#  option(ENABLE_DRIVERS_TESTS "Enable driver tests (bpf, kernel module, modern bpf)" OFF)
#  option(ENABLE_LIBSCAP_TESTS "Enable libscap unit tests" OFF)
#  option(ENABLE_LIBSINSP_E2E_TESTS "Enable libsinsp e2e tests" OFF)
#  option(ENABLE_VM_TESTS "Enable driver sanity tests" OFF)
#  option(BUILD_LIBSCAP_EXAMPLES "Build libscap examples" ON)
#  option(BUILD_LIBSINSP_EXAMPLES "Build libsinsp examples" ON)
#

#vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
#    FEATURES
#        bpf                BUILD_BPF
#        driver             BUILD_DRIVER
#        libscap_examples   BUILD_LIBSCAP_EXAMPLES
#        libsinsp_examples  BUILD_LIBSINSP_EXAMPLES
#        create_tests       CREATE_TEST_TARGETS
#        enable_tests       ENABLE_LIBSCAP_TESTS
#        libscap_modern_bpf BUILD_LIBSCAP_MODERN_BPF
#        libscap_gvisor     BUILD_LIBSCAP_GVISOR
#    INVERTED_FEATURES
#        # ...
#)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_BPF=ON
        -DBUILD_DRIVER=ON

        # examples should be built only through a feature
        -DBUILD_LIBSCAP_EXAMPLES=OFF
        -DBUILD_LIBSINSP_EXAMPLES=OFF

        -DBUILD_LIBSCAP_MODERN_BPF=ON
        -DBUILD_LIBSCAP_GVISOR=ON
        -DBUILD_SHARED_LIBS=$$<STREQUAL:${VCPKG_LIBRARY_LINKAGE},dynamic>

        # tests should be built only through a feature
        -DCREATE_TEST_TARGETS=ON
        -DENABLE_LIBSCAP_TESTS=OFF
        -DENABLE_LIBSINSP_E2E_TESTS=OFF

        -DUSE_BUNDLED_DEPS=OFF
        -DUSE_BUNDLED_LIBBPF=ON
        -DUSE_BUNDLED_LIBELF=OFF
        -DUSE_BUNDLED_MODERN_BPF=ON
        -DUSE_BUNDLED_CARES=OFF
        -DUSE_BUNDLED_CURL=OFF
        -DUSE_BUNDLED_GRPC=OFF
        -DUSE_BUNDLED_GTEST=OFF
        -DUSE_BUNDLED_JSONCPP=OFF
        -DUSE_BUNDLED_OPENSSL=OFF
        -DUSE_BUNDLED_PROTOBUF=OFF
        -DUSE_BUNDLED_RE2=OFF
        -DUSE_BUNDLED_TBB=OFF
        -DUSE_BUNDLED_UTHASH=OFF
        -DUSE_BUNDLED_VALIJSON=OFF
        -DUSE_BUNDLED_ZLIB=OFF
        #${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

# these files should not be duplicated into the debug installation
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share ${CURRENT_PACKAGES_DIR}/debug/include)

# remove empty directories to avoid a vcpkg warning when installing the library
# TBD: check where and why these directories are being generated
file(REMOVE_RECURSE
  ${CURRENT_PACKAGES_DIR}/include/falcosecurity/jit
  ${CURRENT_PACKAGES_DIR}/include/falcosecurity/userspace/libscap/engine/gvisor/proto
  ${CURRENT_PACKAGES_DIR}/include/falcosecurity/userspace/libsinsp/sinsp_debug
)

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
#vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST ${SOURCE_PATH}/LICENSE)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
