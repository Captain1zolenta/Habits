cmake_minimum_required(VERSION 3.16)

project(Habits VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appHabits
    main.cpp
    src/habitmodel.cpp
)

qt_add_qml_module(appHabits
    URI Habits
    VERSION 1.0
    QML_FILES
        Main.qml
        qml/MainView.qml
        qml/components/HabitCard.qml
        qml/dialogs/AddEditDialog.qml
        qml/components/TaskDelegate.qml
        qml/components/Tasks.qml
        qml/components/TaskModel.qml
        qml/components/HabitsView.qml
        qml/dialogs/AddTaskDialog.qml
        qml/dialogs/EditTaskDialog.qml
    SOURCES
        dbmanager.h
        dbmanager.cpp
    RESOURCES
        qtquickcontrols2.conf
)

qt_add_resources(appHabits "controls_conf"
    PREFIX
        "/"
    FILES
        "qtquickcontrols2.conf"
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appHabits PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appHabits
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appHabits PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appHabits
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
