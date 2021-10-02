# Raspberry PI Docker images

The following images are made for Rasperry PI 64bit. All images has restrictions for using memory.
Please be sure you add following at last in /boot/cmdline.txt. Otherwise, docker not able to read and restrict 
memor, cpu and swap size.

 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1
