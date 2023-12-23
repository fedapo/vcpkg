# CMakeInstallTargets.cmake

if(ENABLE_ENGINE_BPF)
	set(TARGET_scap_engine_bpf scap_engine_bpf)
endif()

if(BUILD_LIBSCAP_GVISOR)
	set(TARGET_scap_engine_gvisor scap_engine_gvisor)
endif()

if(HAS_ENGINE_KMOD)
	set(TARGET_scap_engine_kmod scap_engine_kmod)
endif()

if(BUILD_LIBSCAP_MODERN_BPF)
	set(TARGET_scap_engine_modern_bpf scap_engine_modern_bpf)
endif()

if(HAS_ENGINE_NODRIVER)
	set(TARGET_scap_engine_nodriver scap_engine_nodriver)
endif()

if(HAS_ENGINE_SAVEFILE)
	set(TARGET_scap_engine_savefile scap_engine_savefile)
endif()

if(HAS_ENGINE_SOURCE_PLUGIN)
	set(TARGET_scap_engine_source_plugin scap_engine_source_plugin)
endif()

if(CREATE_TEST_TARGETS)
	set(TARGET_scap_engine_test_input scap_engine_test_input)
endif()

message(STATUS "[debug] TARGET_scap_engine_bpf           : ${TARGET_scap_engine_bpf}")
message(STATUS "[debug] TARGET_scap_engine_gvisor        : ${TARGET_scap_engine_gvisor}")
message(STATUS "[debug] TARGET_scap_engine_kmod          : ${TARGET_scap_engine_kmod}")
message(STATUS "[debug] TARGET_scap_engine_modern_bpf    : ${TARGET_scap_engine_modern_bpf}")
message(STATUS "[debug] TARGET_scap_engine_nodriver      : ${TARGET_scap_engine_nodriver}")
message(STATUS "[debug] TARGET_scap_engine_savefile      : ${TARGET_scap_engine_savefile}")
message(STATUS "[debug] TARGET_scap_engine_source_plugin : ${TARGET_scap_engine_source_plugin}")
message(STATUS "[debug] TARGET_scap_engine_test_input    : ${TARGET_scap_engine_test_input}")

# Install the libraries
install(
TARGETS
        cri_v1       # ????
        cri_v1alpha2 # ????
	driver_event_schema
	pman
	containerd_interface # ????
	scap
	sinsp
	${TARGET_scap_engine_bpf}
	${TARGET_scap_engine_gvisor}
	scap_engine_kmod # ${TARGET_scap_engine_kmod}
	${TARGET_scap_engine_modern_bpf}
	scap_engine_nodriver # ${TARGET_scap_engine_nodriver}
	scap_engine_noop
	scap_engine_savefile # ${TARGET_scap_engine_savefile}
	scap_engine_source_plugin # ${TARGET_scap_engine_source_plugin}
	${TARGET_scap_engine_test_input}
	scap_engine_util
	scap_error
	scap_event_schema
	scap_platform
	scap_platform_util
	scap_savefile_converter
EXPORT falcosecurity-libs-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDE}
)

# Generate and install the necessary CMake files
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    falcosecurity-libsConfigVersion.cmake
    VERSION 0.19.0
    COMPATIBILITY AnyNewerVersion
)

install(EXPORT falcosecurity-libs-targets
        FILE falcosecurity-libsTargets.cmake
        NAMESPACE falcosecurity::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/falcosecurity-libs)

install(FILES falcosecurity-libsConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/falcosecurity-libsConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/falcosecurity-libs)
