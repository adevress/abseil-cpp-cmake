#
# Copyright 2017 The Abseil Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set(_ABSEIL_PKGCONFIG_HELPERS_PATH "${CMAKE_CURRENT_LIST_DIR}")

# generate pkgconfig file
function(abseil_pkgconf_generate)
    set(SRC_PKG_CONFIG_IN ${_ABSEIL_PKGCONFIG_HELPERS_PATH}/absl.pc.in)
    set(SRC_PKG_CONFIG_OUT ${CMAKE_CURRENT_BINARY_DIR}/absl.pc)


    cmake_parse_arguments(PKGCONF
        ""
        "VERSION;URL;NAME;DESCRIPTION"
        "LIB_NAMES;PRIVATE_LIB_NAMES"
        ${ARGN}
    )

    set(PKGCONF_ALL_LIB_NAMES "")
    set(PKGCONF_ALL_PRIVATE_LIB_NAMES "")


    foreach(_PKG_TARGET_NAME ${PKGCONF_LIB_NAMES})
        set(PKGCONF_ALL_LIB_NAMES "${PKGCONF_ALL_LIB_NAMES} -l${_PKG_TARGET_NAME}")
    endforeach()

    foreach(_PKG_PRIVATE_NAME ${PKGCONF_PRIVATE_LIB_NAMES})
        set(PKGCONF_ALL_PRIVATE_LIB_NAMES "${PKGCONF_ALL_PRIVATE_LIB_NAMES} -l${_PKG_PRIVATE_NAME}")
    endforeach()

    # if absolute path are specified, use them
    if((IS_ABSOLUTE ${CMAKE_INSTALL_INCLUDEDIR}) OR (IS_ABSOLUTE ${CMAKE_INSTALL_LIBDIR}))
        set(PKGCONF_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
        set(PKGCONF_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_FULL_LIBDIR}")
        set(PKGCONF_INSTALL_LIBDIR "${CMAKE_INSTALL_FULL_LIBDIR}")
    else()
        set(PKGCONF_INSTALL_PREFIX "\${pcfiledir}/../..")
        set(PKGCONF_INSTALL_INCLUDEDIR "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}")
        set(PKGCONF_INSTALL_LIBDIR "\${prefix}/${CMAKE_INSTALL_LIBDIR}")
    endif()

    configure_file(${SRC_PKG_CONFIG_IN} ${SRC_PKG_CONFIG_OUT} @ONLY)

    message(STATUS "create pkgconfig file ${SRC_PKG_CONFIG_OUT}")

    install(FILES ${SRC_PKG_CONFIG_OUT} DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/pkgconfig)

endfunction()
