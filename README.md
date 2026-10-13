This project has been created as part of the 42 curriculum by clwenhaj.

Description

Inception is a system administration project aimed at discovering Docker and containerization. The goal is to build a secure infrastructure composed of multiple isolated services (NGINX, WordPress, and MariaDB) communicating through a custom Docker network, with persistent data stored using named volumes mapped to host directories.

Instructions

To build and launch the infrastructure, run:

make


To stop the containers:

make down


To clean everything (including images, networks, and persistent data):

make fclean


Resources and AI Usage

Official Documentation: Docker, NGINX, MariaDB, and WordPress CLI documentation.

AI Usage: Artificial intelligence tools were utilized to assist with structuring configuration files, optimizing shell entrypoint scripts, and writing comprehensive technical documentation.

Project Description & Technical Choices

Virtual Machines vs Docker

Virtual Machines virtualize physical hardware, running a full guest operating system on top of a hypervisor. In contrast, Docker containers share the host operating system's kernel, providing lightweight, process-level isolation with minimal performance overhead.

Secrets vs Environment Variables

Environment variables can be easily exposed via process inspection (docker inspect). Docker Secrets provide a secure alternative by mounting confidential information (such as passwords) directly into memory-backed files inside the container.

Docker Network vs Host Network

Docker Networks isolate containers in a private bridge network, allowing secure and controlled internal communication. The Host Network removes network isolation entirely, binding containers directly to the host machine's network stack.

Docker Volumes vs Bind Mounts

Docker Volumes are completely managed by Docker within a dedicated storage area on the host, ensuring high portability and data safety. Bind Mounts allow direct mapping of any arbitrary directory from the host machine into the container filesystem.
