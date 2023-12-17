# DJGPP_CONTAINER
It's a container for cross compiling code from Linux to the DOS platform.
The container is built upon the Debian platform and makes use of the following software

DJGPP v12.2.0  - [[andrewwutw/build-djgpp]](https://github.com/andrewwutw/build-djgpp)

By encasulating the cross-compiler in a container, the developement environment for DOS can therefore be a uniform experience regardless of the state or environment used for the host OS.

---
### Image builds:

The image for the container resides either here on github or on docker. Images are built every Monday at midnight. You can use these images by first importing them

**Github Repository**
```
podman pull ghcr.io/ilobmirt/djgpp_container:latest
```

or

**Docker Repository**
```
podman pull docker.io/ilobmirt/djgpp_container:latest
```
---
### Working with the container
To have djgpp_container work with your project, run the following command:

```
podman run --security-opt label=disable --volume ./hellocpp:/input -dit --name hellocpp djgpp_container:latest
```

In this example, we have a simple hello world project we wish to cross compile to DOS, we attached the local ./hellocpp folder to the container's /input folder, the place where the this project expects outside data to be provided to the container.

Since cross-compilation projects are far from uniform, as of now, there's no work done automatically by the container when it is run, so we will have to cross compile the example ourselves.

```
[user@host]$ podman container ls
CONTAINER ID  IMAGE                                      COMMAND     CREATED        STATUS        PORTS       NAMES
1ab54571fa79  docker.io/ilobmirt/djgpp_container:latest              6 minutes ago  Up 6 minutes              hellocpp

[user@host]$ podman container attach hellocpp

root@1ab54571fa79:/input# ls
hello.cpp

root@1ab54571fa79:/input# g++ -o hello.exe hello.cpp 

root@1ab54571fa79:/input# ls
hello.cpp  hello.exe

root@1ab54571fa79:/input# exit
exit

[user@host]$
```

In this example, we simply invoked the DJGPP version of the g++ compiler itself, but of course, many projects may actually invoke makefiles and cmake. The environment within this container should point both tools to the cross-compiler rather than the linux native compiler and therefore, it should be able to cross compile the project to the DOS platform while benefitting the ability to utilize the linux's compiling host's ability to use long file names and access to more memory + cpu resources.
