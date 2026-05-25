cmake_minimum_required(VERSION 3.20)

project(plasma-applet-tokenusage
    VERSION 1.0.0
    LANGUAGES CXX
)

set(KF6_MIN_VERSION 6.0)
find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${ECM_MODULE_PATH}")
include(KDEInstallDirs)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml)
find_package(KF6 Plasma ${KF6_MIN_VERSION} REQUIRED)
find_package(KF6 I18n ${KF6_MIN_VERSION} REQUIRED)

plasma_install_package(
    ${CMAKE_CURRENT_SOURCE_DIR}
    org.kde.plasma.tokenusage
)
