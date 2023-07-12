# Artifact for "Inference of Resource Management Specifications" (OOPSLA 2023)

This README.md file provides information about the artifact for "Inference of Resource Management Specifications." The artifact includes the implementation of the tool called "Resource Leak Inference" and the case study programs used in the experiments described in section 5 of the paper.

The artifact is provided as a Docker environment to facilitate easy reproduction. You can access it on Zenodo TODO. To get started, please follow the instructions below:

### Prerequisites

Before running the artifact, make sure you have Docker installed on your machine. If you don't have Docker installed, you can find installation instructions [here](https://www.docker.com/get-started)).

### Running the Artifact

To run the artifact, execute the following commands:

```
docker run -it nargeshdb/resource_leak_inference:latest
```

This command will log you into a bash shell inside the Docker container as the oopsla user, with the current working directory set to /home/oopsla. All the relevant code and scripts are located within this directory.

### Generate Inference Output

If you only wish to run the scripts and view the numbers reported in the tables without going through the entire artifact, you can skip this section. Otherwise, to generate the inference output, run the following command:

```
./inference.sh
```

### Generate Numbers for Table 1

To generate the numbers for Table 1, execute the following command:

```
./table1.sh
```
