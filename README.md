# Bài thực hành 04 – TurtleBot 4 Simulation (SLAM, Localization, Nav2)

Mô phỏng TurtleBot 4 trong Gazebo (Ignition Fortress), xây dựng bản đồ bằng SLAM Toolbox, định vị bằng AMCL và điều hướng tự động bằng Nav2.

- Video demo: <DÁN LINK GOOGLE DRIVE>
- Môi trường: Ubuntu 22.04, ROS 2 Humble, world `maze`

## 1. Cài đặt

```bash
sudo apt install -y git python3-colcon-common-extensions python3-rosdep
mkdir -p ~/tb4_ws/src && cd ~/tb4_ws/src
git clone -b humble https://github.com/turtlebot/turtlebot4.git
git clone -b humble https://github.com/turtlebot/turtlebot4_simulator.git
git clone -b humble https://github.com/turtlebot/turtlebot4_desktop.git

source /opt/ros/humble/setup.bash
cd ~/tb4_ws
sudo rosdep init   # bỏ qua nếu báo đã tồn tại
rosdep update
rosdep install --from-paths src -yir --rosdistro humble
colcon build --symlink-install
source install/setup.bash
sudo apt install -y ros-humble-teleop-twist-keyboard
```

Clone repo này:
```bash
git clone https://github.com/23020736-glitch/turtlebot4-bai04.git
```

## 2. Cấu trúc repo

## 3. Cách chạy

### Phần 1 – Simulation
```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze rviz:=true
ros2 action send_goal /undock irobot_create_msgs/action/Undock "{}"
ros2 topic hz /scan
ros2 topic echo /odom --once
ros2 topic info /cmd_vel
```

### Phần 2 – Mapping với SLAM Toolbox
```bash
./launch/mapping.sh                      # terminal 1
ros2 action send_goal /undock irobot_create_msgs/action/Undock "{}"
ros2 run teleop_twist_keyboard teleop_twist_keyboard   # terminal 2
```
Đặt Fixed Frame = `map` trong RViz2, lái robot chậm quanh toàn bộ mê cung. Lưu bản đồ:
```bash
ros2 run nav2_map_server map_saver_cli -f maps/map
```

### Phần 3 – Localization
```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze   # terminal 1
ros2 action send_goal /undock irobot_create_msgs/action/Undock "{}"
./launch/localization.sh                                                          # terminal 2
ros2 launch turtlebot4_viz view_robot.launch.py use_sim_time:=true                 # terminal 3
```
Dùng **2D Pose Estimate** trong RViz2 để đặt vị trí ban đầu. Kiểm tra: `ros2 run tf2_ros tf2_echo map odom`.

### Phần 4 – Navigation với Nav2
```bash
./launch/navigation.sh
```
Dùng **Nav2 Goal** trong RViz2 để đặt goal. Robot tự lập kế hoạch và di chuyển, không điều khiển tay.

