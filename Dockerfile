FROM ros:crystal

# install ROS2 dependencies
RUN apt-get update && apt-get install -q -y \
      build-essential \
      cmake \
      git \
      python3-colcon-common-extensions \
      python3-vcstool \
      wget \
    && rm -rf /var/lib/apt/lists/*

# copy ros package repo
ENV ROS_WS /opt/ros_ws
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS
COPY ./ src/rosbag2/

# install dependency package dependencies
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && \
    rosdep install -q -y \
      --from-paths \
        src/rosbag2/rosbag2_storage_checkpoint_plugin \
      --ignore-src \
    && rm -rf /var/lib/apt/lists/*

# build dependency package source
ARG CMAKE_BUILD_TYPE=Release
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build \
      --symlink-install \
      --packages-select \
        rosbag2_storage_checkpoint_plugin \
      --cmake-args \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE

# source navigation2 workspace from entrypoint
RUN sed --in-place \
      's|^source .*|source "$ROS_WS/install/setup.bash"|' \
      /ros_entrypoint.sh
