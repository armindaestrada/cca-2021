#FROM nvidia/cudagl:11.2.1-runtime-ubuntu20.04
FROM osrf/ros:noetic-desktop-full-focal
ENV DEBIAN_FRONTEND=noninteractive

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup sources.list
#RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# bootstrap rosdep
#RUN rosdep init && \
  #rosdep update --rosdistro $ROS_DISTRO


ENV ROS_DISTRO noetic

RUN apt-get update && apt-get install -y --no-install-recommends && \
    apt install ros-noetic-desktop-full -y \
    && rm -rf /var/lib/apt/lists/*

USER root 
Run printenv | grep ROS

Run apt-get update 
Run apt-get install ros-noetic-controller-manager
Run apt-get install ros-noetic-ros-control -q -y
Run apt-get install ros-noetic-ros-controllers -q -y
Run apt-get install ros-noetic-velodyne -q -y

Run apt-get install -q -y git-lfs
Run git lfs install
RUN bin/bash -c "echo 'source /opt/ros/noetic/setup.bash' >> .bashrc"
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash &&\
    mkdir -p ~/catvehicle_ws/src &&\
    cd ~/catvehicle_ws/src &&\
    cd ~/catvehicle_ws &&\
    catkin_make'
RUN cd ~/catvehicle_ws/src
RUN git clone https://github.com/jmscslgroup/catvehicle 
RUN git clone https://github.com/jmscslgroup/obstaclestopper 
RUN git clone https://github.com/jmscslgroup/control_toolbox 
RUN git clone https://github.com/jmscslgroup/sicktoolbox
RUN git clone https://github.com/jmscslgroup/sicktoolbox_wrapper 
RUN git clone https://github.com/jmscslgroup/stepvel 
RUN git clone https://github.com/jmscslgroup/cmdvel2gazebo 
WORKDIR ~/catvehicle_ws/src/catvehicle &&\ git checkout noetic_gazebo-11
RUN cd .. 
RUN cd ..
RUN pwd
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash &&\
    cd ~/catvehicle_ws/src &&\
    #catkin_init_workspace && \
    cd ~/catvehicle_ws &&\
    catkin_make"
CMD ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash && source source ~/catvehicle_ws/devel/setup.bash && roslaunch catvehicle catvehicle_neighborhood.launch"]