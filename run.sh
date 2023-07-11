docker rmi --force resource_leak_inference
docker build --no-cache -t resource_leak_inference .
docker run resource_leak_inference