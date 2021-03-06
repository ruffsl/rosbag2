cmake_minimum_required(VERSION 3.5)
project(rosbag2_tests)

add_definitions(-D_SRC_RESOURCES_DIR_PATH="${CMAKE_CURRENT_SOURCE_DIR}/resources")

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic -Werror)
endif()

find_package(ament_cmake REQUIRED)
find_package(ament_index_cpp REQUIRED)

find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
  find_package(ros1_bridge REQUIRED)
  include(${ros1_bridge_DIR}/find_ros1_interface_packages.cmake)
  include(${ros1_bridge_DIR}/find_ros1_package.cmake)
  find_ros1_package(roscpp)
  if(NOT ros1_roscpp_FOUND)
    set(SKIP_ROS1_TESTS "SKIP_TEST")
    message(WARNING "Skipping build of tests for rosbag_v2 plugin. ROS 1 not found")
  endif()
else()
  set(SKIP_ROS1_TESTS "SKIP_TEST")
  message(WARNING "Skipping build of tests for rosbag_v2 plugin. ROS 1 not found")
endif()

if(BUILD_TESTING)
  include(cmake/skip_ros1_tests_if_necessary.cmake)
  skip_ros1_tests_if_necessary()

  find_package(ament_cmake_gmock REQUIRED)
  find_package(ament_lint_auto REQUIRED)
  find_package(rclcpp REQUIRED)
  find_package(std_msgs REQUIRED)
  find_package(test_msgs REQUIRED)
  find_package(rosbag2_storage REQUIRED)
  find_package(rosbag2_storage_default_plugins REQUIRED)
  find_package(rosbag2_test_common REQUIRED)
  find_package(rosbag2_bag_v2_plugins QUIET)

  ament_lint_auto_find_test_dependencies()

  ament_add_gmock(test_rosbag2_record_end_to_end
    test/rosbag2_tests/test_rosbag2_record_end_to_end.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  if(TARGET test_rosbag2_record_end_to_end)
    ament_target_dependencies(test_rosbag2_record_end_to_end
      rclcpp
      rosbag2_storage
      rosbag2_storage_default_plugins
      rosbag2_test_common
      test_msgs)
  endif()

  ament_add_gmock(test_rosbag2_play_end_to_end
    test/rosbag2_tests/test_rosbag2_play_end_to_end.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  if(TARGET test_rosbag2_play_end_to_end)
    ament_target_dependencies(test_rosbag2_play_end_to_end
      rclcpp
      rosbag2_storage
      rosbag2_storage_default_plugins
      rosbag2_test_common
      test_msgs)
  endif()

  ament_add_gmock(test_rosbag2_info_end_to_end
    test/rosbag2_tests/test_rosbag2_info_end_to_end.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  if(TARGET test_rosbag2_info_end_to_end)
    ament_target_dependencies(test_rosbag2_info_end_to_end
      rosbag2_storage)
  endif()

  ament_add_gmock(test_converter
    test/rosbag2_tests/test_converter.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  if(TARGET test_converter)
    ament_target_dependencies(test_converter
      rosbag2
      rosbag2_test_common
      test_msgs)
  endif()

  ament_add_gmock(test_rosbag2_play_rosbag_v2_end_to_end
    test/rosbag2_tests/test_rosbag2_play_rosbag_v2_end_to_end.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    ${SKIP_ROS1_TESTS})
  if(TARGET test_rosbag2_play_rosbag_v2_end_to_end)
    ament_target_dependencies(test_rosbag2_play_rosbag_v2_end_to_end
      rosbag2_storage
      rclcpp
      rosbag2_test_common
      std_msgs)
  endif()

  ament_add_gmock(test_rosbag2_info_rosbag_v2_end_to_end
    test/rosbag2_tests/test_rosbag2_info_rosbag_v2_end_to_end.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    ${SKIP_ROS1_TESTS})
  if(TARGET test_rosbag2_info_rosbag_v2_end_to_end)
    ament_target_dependencies(test_rosbag2_info_rosbag_v2_end_to_end
      rosbag2_storage
      rclcpp
      rosbag2_test_common
      std_msgs)
  endif()
endif()

ament_package()
