# Artifact for "Inference of Resource Management Specifications" (OOPSLA 2023)

This file describes the artifact for "Inference of Resource Management Specifications". The artifact contains the implementation of the tool("Resource Leak Inference") and the case study programs used in the experiments in section 5.

The artifact is a Docker environment, to ease reproduction. You can access it on Zenodo TODO. Install docker (instructions are [here](https://www.docker.com/get-started)), and then run the following commands.

```
docker run -it nargeshdb/resource_leak_inference:latest
```
This command will log you into a bash shell inside the Docker container as the
`oopsla` user, in the `/home/oopsla` directory.  All relevant code and scripts are
present within that directory.  We provide saved inference outputs from our analysis for
all the case studies, and you can run scripts to re-generate the outputs if desired (detailed instructions below).

### Generate Inference Output

```
./inference.sh
```

### Generate Numbers for Table 1
```
./table1.sh
```
