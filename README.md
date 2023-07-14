# Artifact for "Inference of Resource Management Specifications" (OOPSLA 2023)

This README.md file provides information about the artifact for "Inference of Resource Management Specifications." The artifact includes the implementation of our inference algorithm and the case study programs used in the experiments described in section 5 of the paper.  This document contains the instruction to reproduce numbers reported for the Java implementation.

TODO(MS): be clear about which version of the paper this artifact validates, if needed.  (I'm not sure if we need to submit a version of the paper with the artifact or not.)

The artifact is provided as a Docker environment to facilitate easy reproduction. You can access it on Zenodo TODO. To get started, please follow the instructions below:

### Prerequisites

Before running the artifact, make sure you have Docker installed on your machine. If you don't have Docker installed, you can find installation instructions [here](https://www.docker.com/get-started).

### Running the Artifact

To run the artifact, execute the following command:

```
docker run -it nargeshdb/resource_leak_inference:latest
```

This command will log you into a bash shell inside the Docker container as the oopsla user, with the current working directory set to /home/oopsla. All the relevant code and scripts are located within this directory.

### Generate Inference Output

If you only want to run the scripts to view the numbers reported in the tables without actually running inference on the benchmarks, you can skip this section. Otherwise, to generate the inference output, run the following command:

```
./inference.sh
```

### Generate Numbers for Table 1

To generate the numbers for Table 1, execute the following command:

```
./table1.sh
```

**Note**: There are two discrepancies between the results presented in the paper. Firs, in the paper, we made a manual effort to separate @Owning annotations into three different categories: @Owning annotations on final fields, non-final fields, and params. However, by running this script, you can observe the total count of @Owning annotations in all three categories for each benchmark. Second, in the Java implementation, the annotation referred to as @Calls in the paper is named @EnsuresCalledMethods, and the annotation referred to as @MustCall in the paper is named @InheritableMustCall.



TODO(MS): will it be completely obvious how the output of the script corresponds to the table?  If not, give some guidance.
TODO: numbers for @EnsuresCalledMethods(@Calls in the table) is not concistent with the paper --> fix scripts to check if value set of manually written annotaion is subset of inferred annotation value set
TODO: numbers for @InheritableMustCall(@MustCall in the table) is not concistent with the paper --> fix scripts to not count @InheritableMustCall{} annotations

### Generate Numbers for Table 2

TODO

### Generate Numbers for Table 3

If you only want to run the scripts and view the numbers reported in the table 3 for the verification time column, skip this step. Otherwise, execute the following command to run the Resource Leak Checker on each benchmark to collect execution time data:

```
./rlc-perf.sh
```

To generate the numbers for Table 3, execute the following command:

```
./table3.sh
```

TODO(MS): will it be completely obvious how the output of the script corresponds to the table?  If not, give some guidance. (NS) This part is clear I think! The output contains all the information mentioned in the paper.

**Note**: The numbers reported in Table 3 were generated on a machine with a 12th Gen Intel Core i-7-12700 Processor with 20 cores and 32 GB of RAM. Performance of the inference algorithm and Resource Leak Checker on the Docker container might be different compared to those reported in the paper.
