#! /bin/sh
# stop any previously running instance
docker build -t rust-dev . && \
export rust_container_id=$(docker run -d -p127.0.0.1:2222:22 -v $(pwd)/vm_workdir:/home/dev/workspace rust-dev) && \
sleep 3 && \
ssh -X dev@localhost -p 2222 -oStrictHostKeyChecking=no
docker stop $rust_container_id
