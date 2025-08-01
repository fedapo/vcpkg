vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH
    REPO SFML/SFML
    REF "${VERSION}"
    HEAD_REF master
    SHA512 cee56eef93728aef9b361f8b1080572532ce5247c80a9d1be53b30dab4d67e8588316890555d4c4ba423e87b09f954327d70615e1ba72d458d8238fa84e589f9
    PATCHES
        01-fix-dependency-resolve.patch
        02-fix-pkgconfig.patch
        03-fix-android-install-path.patch
)

if(VCPKG_TARGET_IS_LINUX)
    message(STATUS "SFML currently requires the following libraries from the system package manager:\n    libudev\n    libx11\n    libxi\n    libxrandr\n    libxcursor\n    opengl\n\nThese can be installed on Ubuntu systems via apt-get install libx11-dev libxi-dev libxrandr-dev libxcursor-dev libxi-dev libudev-dev libgl1-mesa-dev")
endif()

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "network"  SFML_BUILD_NETWORK
        "graphics" SFML_BUILD_GRAPHICS
        "window"   SFML_BUILD_WINDOW
        "audio"    SFML_BUILD_AUDIO
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSFML_BUILD_FRAMEWORKS=OFF
        -DSFML_USE_SYSTEM_DEPS=ON
        -DSFML_MISC_INSTALL_PREFIX=share/sfml
        -DSFML_GENERATE_PDB=OFF
        ${FEATURE_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        SFML_MISC_INSTALL_PREFIX
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/SFML)
vcpkg_copy_pdbs()

# move sfml-main to manual link dir
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/sfml-main.lib")
    file(COPY "${CURRENT_PACKAGES_DIR}/lib/sfml-main.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/manual-link")
    file(REMOVE "${CURRENT_PACKAGES_DIR}/lib/sfml-main.lib")
    file(GLOB FILES "${CURRENT_PACKAGES_DIR}/share/sfml/SFMLMain*Targets-*.cmake")
    foreach(FILE ${FILES})
        vcpkg_replace_string("${FILE}" "/lib/sfml-main" "/lib/manual-link/sfml-main")
    endforeach()
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/sfml-main-d.lib")
    file(COPY "${CURRENT_PACKAGES_DIR}/debug/lib/sfml-main-d.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/manual-link")
    file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/lib/sfml-main-d.lib")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_pkgconfig()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/license.md")
