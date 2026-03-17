cmake_minimum_required(VERSION 3.16)

project(Habits VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(Habits
    main.cpp
    src/habitmodel.cpp
)

qt_add_qml_module(Habits
    URI Habits
    VERSION 1.0
    QML_FILES
        main.qml
        qml/MainView.qml
        qml/components/HabitCard.qml
        qml/dialogs/AddEditDialog.qml
)

target_link_libraries(Habits PRIVATE
    Qt6::Quick
    Qt6::Core
)
