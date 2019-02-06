// Copyright 2019, Ruffin White.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "rosbag2_storage_default_plugins/checkpoint/checkpoint_node.hpp"


namespace rosbag2_storage_plugins
{


CheckpointNode::CheckpointNode()
    : Node("_rosbag2"), count_(0)
{
  publisher_ = this->create_publisher<std_msgs::msg::String>("topic");
  timer_ = this->create_wall_timer(
      500ms, std::bind(&CheckpointNode::timer_callback, this));
}


void CheckpointNode::timer_callback()
{
  auto message = std_msgs::msg::String();
  message.data = "Hello, world! " + std::to_string(count_++);
  RCLCPP_INFO(this->get_logger(), "Publishing: '%s'", message.data.c_str());
  publisher_->publish(message);
}

}  // namespace rosbag2_storage_plugins
