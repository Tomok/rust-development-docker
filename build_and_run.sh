#! /bin/sh
# stop any previously running instance
docker stop rust-dev-container
docker build -t rust-dev docker || exit -1
docker run --name rust-dev-container -v $(pwd)/vm_workspace:/home/dev/workspace --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it rust-dev
