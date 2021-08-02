FROM osrf/ros:noetic-desktop-full-focal

USER root 
Run printenv | grep ROS
EXPOSE 80
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