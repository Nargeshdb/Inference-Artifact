# Artifact for "Inference of Resource Management Specifications" (OOPSLA 2023)

This README.md file provides information about the artifact for "Inference of Resource Management Specifications." The artifact includes the implementation of our inference algorithm for both the Java and C# languages. It is provided with two separate Docker containers to facilitate easy reproduction. Each container contains the respective implementations and the case study programs used in the experiments described in Section 5 of the revise version of the paper which is uploaded in the artifact.

To access the artifact, you can find it on [Zenodo](https://doi.org/10.5281/zenodo.8149274). To get started, please follow the instructions below:

# Java Implementation

This section contains the instructions to reproduce the numbers reported for the Java implementation. 

### Prerequisites

Before running the artifact, make sure you have Docker installed on your machine. If you don't have Docker installed, you can find installation instructions [here](https://www.docker.com/get-started).

### Running the Artifact

To run the artifact, you need to download the artifact from [here](https://doi.org/10.5281/zenodo.8149274), then execute the following command:

```
gunzip -c path/to/resource_leak_inference.tar.gz > resource_leak_inference.tar
docker load < resource_leak_inference.tar
docker run -it nargeshdb/resource_leak_inference:latest
```

This command will log you into a bash shell inside the Docker container as the oopsla user, with the current working directory set to `/home/oopsla`. All the relevant code and scripts are located within this directory.

### Kicking the tires
If you just want to make sure that everything **can** run, we suggest running
the following commands. Load the docker image following the commands above.

Then, within the Docker image in the initial directory (`/home/oopsla`), analyze
table3.sh: 

```
./table3.sh
```

Check that you get a "Results for table 3 is generated" message at the end.

Running this command should take a few minutes on commodity hardware.

### Generate Inference Output

If you only want to run the scripts to view the numbers reported in the tables without actually running inference on the benchmarks, you can skip this section. Otherwise, to generate the inference output, run the following command:

```
./inference.sh
```

### Generate Numbers for Table 1
(**Note**: There are slight differences in the numbers reported by this script compared to the numbers in the original PDF we submitted for review, due to errors we fixed while preparing the artifact. The revised PDF referenced above contains the updated numbers consistent with the artifact.)

To generate the numbers for Table 1, execute the following command:

```
./table1.sh
```

**Note**: There are two discrepancies with the results presented in the paper. First, in the paper, we made a manual effort to separate @Owning annotations into three different categories: @Owning annotations on final fields, non-final fields, and params. However, by running this script, you can only observe the total count of @Owning annotations in all three categories for each benchmark. Second, in the Java implementation, the annotation referred to as @Calls in the paper is named @EnsuresCalledMethods, and the annotation referred to as @MustCall in the paper is named @InheritableMustCall.

### Generate Numbers for Table 2

Table 2 in our paper presents the number of warnings generated by the Resource Leak Checker in two scenarios: without annotations and with inferred annotations. These numbers are presented in the second and third columns of the table. The remaining columns in Table 2 involve manual analysis of the warnings and cannot be generated automatically.We provide this information separately within Zenodo, in a file named "Manual-Report.xlsx," as well as in a Google Doc [Manual-Report](https://docs.google.com/spreadsheets/d/1qEQyj2kmLOnURmDFiHAPnu-vR4NbAUIwOliGqopLqnE/edit?usp=sharing). 

To reproduce Table 2, execute the 

```
./table2.sh
```

### Generate Numbers for Table 3

If you are only interested in running the scripts and viewing the numbers reported in Table 3 for the verification time column, you can skip this step. However, if you would like to collect execution time by running the Resource Leak Checker on each benchmark, please execute the following command

```
./rlc-perf.sh
```

The numbers reported in the first column of Table 3.b are borrowed from the "Lightweight and Modular Resource Leak Checker" paper, as we conducted our experiments using the same module. However, to generate the numbers for columns 2 and 3 of Table 3, please execute the following command:

```
./table3.sh
```

**Note**: The numbers reported in Table 3 were generated on a machine with a 12th Gen Intel Core i-7-12700 Processor with 20 cores and 32 GB of RAM. Performance of the inference algorithm and Resource Leak Checker on the Docker container might be different compared to those reported in the paper.

# C\# Implementation
This section contains the instruction to reproduce numbers reported for the C\# implementation. The Docker image for C\# experiments contains:

* source code (CodeQL queries) of our tools (will be found in /home/oopsla/codeql-repo/csharp/ql/src/RLC-Codeql-Queries)
* all benchmarks (will be found in /home/oopsla/csharp-open-source-projects)
* scripts to reproduce our experiments (will be found in /home/oopsla/scripts)
* manual analysis report of warnings generated by the verifier (will be found at https://docs.google.com/spreadsheets/d/1qEQyj2kmLOnURmDFiHAPnu-vR4NbAUIwOliGqopLqnE/edit?usp=sharing)
* annotations for standard libraries of C# and hand-written annotations for our benchmarks (will be found in /home/oopsla/docs)

## Software Versions
* [dotnet](https://dotnet.microsoft.com/en-us/download): 6.0.119
* [CodeQL](https://codeql.github.com/): 2.13.5
* [Ubuntu](https://ubuntu.com/): 22.04 for Docker image and host machines


## Setup

  1. Install Docker based on your system configuration: [Get Docker](https://docs.docker.com/get-docker/).
  2. Import the artifact into Docker: `docker load --input oopsla-artifact-csharp-471.tar`
  3. Run the Docker image: `docker run -it --user oopsla oopsla-artifact-csharp-471 /bin/bash`

Additional packages can be installed as usual via `apt update && apt install <package>`.

Our paper's goal is to infer resource management specifications that can be utilized by our verifier Resource Leak Checker (RLC#) for C# code. Our tool is available at [RLC#](https://github.com/microsoft/global-resource-leaks-codeql).

This Docker container offers a means to reproduce the data reported in the paper. Additionally, it includes guidelines (last section) on how to execute Inference and RLC# on benchmarks that are not part of our evaluation. This enables users to extend the analysis and apply the techniques to other projects.

We have developed both Inference and RLC# as CodeQL queries.
For the evaluation of Inference and RLC#, we utilize two open-source projects: [Lucene.Net](https://github.com/apache/lucenenet) and [EF Core](https://github.com/dotnet/efcore). This artifact does not include proprietary C# microservices, which are discussed in the paper.

We tested the container on a Windows-based system equipped with an Intel Xeon(R) W-2145 CPU operating at 3.7 GHz and 64 GB of RAM. 
We provide an estimated execution time for each script on this specific system.
We use the option '--ram=65536' for our experiments which sets the maximum RAM usage for the query evaluator. The results reported in the paper and the estimated time for each script are based on this configuration. However, specifying this configuration in a Docker container may not be feasible due to varying machine configurations. Consequently, the performance-related data produced may vary based on your machine's configuration.

CodeQL experiments begin with the generation of a CodeQL database. 

## CodeQL Database Creation

A CodeQL database is a relational database that is created by extracting code information from the source code of the target project, allowing CodeQL to perform in-depth analysis and identify potential security vulnerabilities or issues. Once the CodeQL database is generated, it can be queried using CodeQL queries to uncover insights and perform various analyses on the codebase.

The `createCodeQLDB.py` script clones the repositories of Lucene.Net and EF Core and generates their respective CodeQL databases. It takes approximately 25-30 minutes to create both databases.
```python
python3 scripts/createCodeQLDB.py
```

## Reproducing Table 1

Table 1 in our paper presents the percentage of hand-written annotations that our algorithm was able to infer.
You can reproduce Table 1 by executing the `csharp-table1.py` script. This script runs the CodeQL query for Inference on both benchmarks and compares the inferred annotations from the query with the manually added annotations (available in the docs directory). The output format is identical to that in the paper. Generating the results takes approximately 20-22 minutes. 
The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table1.txt`.
```python
python3 scripts/csharp-table1.py

```
## Reproducing Table 2

Table 2 in our paper presents the number of warnings generated by RLC# in two scenarios: without annotations and with inferred annotations. These numbers are presented in the second and third columns of the table. The remaining columns in Table 2 involve manual analysis of the warnings and cannot be generated automatically. We provide this information separately within Zenodo, in a file named "Manual-Report.xlsx," as well as in a Google Doc (https://docs.google.com/spreadsheets/d/1qEQyj2kmLOnURmDFiHAPnu-vR4NbAUIwOliGqopLqnE/edit?usp=sharing).

To reproduce Table 2, execute the `csharp-table2.py` script. This script runs RLC# twice for each benchmark, first without annotations and then with inferred annotations (generated in the previous step). The output of the script gives the first three columns of Table 2. It takes approximately 4.5 hours for the script to produce results for both benchmarks. The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table2.txt`.
```python
python3 scripts/csharp-table2.py
```
RLC# warnings for each benchmark can be found in `csharp-results/rlc/<db-name>-rlc-warnings-with-no-annotations.csv` and `csharp-results/rlc/<db-name>-rlc-warnings-with-inferred-annotations.csv` for the two settings.

## Reproducing Table 3 

In our paper, Table 3 presents the performance of Inference and checking. To reproduce Table 3, execute the `csharp-table3.py` script. This script executes Inference and RLC# with the inferred annotations for a total of three runs, recording the average runtime for each query and benchmark. The output of this script generates Table 3, excluding the kLoC column. It takes approximately 8.5 hours for the script to produce results for both benchmarks. 
The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table3.txt`.
```python
python3 scripts/csharp-table3.py
```
## Evaluating Inference and Resource Leak Checker on Various C# Benchmarks

You can test both Inference and RLC# on benchmarks that are not included with this artifact.

### CodeQL Database Creation

If you want to create a CodeQL database for a different project, use the following command. In some cases, you might need to use custom commands. For details, check [codeql database create](https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases)
```python
cd <source-code-project>
codeql database create <database> --language=<language-identifier> 
```
You must specify:

* \<database\>: a path to the new database to be created. This directory will be created when you execute the command. You cannot specify an existing directory.
* \<language-identifier\>: the identifier for the language to create a database for. For C#, it is csharp.

### Inference

To run the Inference algorithm on a different C# project, use the `inference.py` script. This script executes the Inference query on a CodeQL database and generates two files in the `~/csharp-results/inference` directory. One file (named \<db-name\>-inferred-attributes.csv) contains a list of annotations inferred by the query in a format that RLC# understands. The second file (named \<db-name\>-inference-summary.csv) summarizes the Inference run, providing the total number of inferred annotations and the runtime of a single query run.
```python
python3 scripts/inference.py <path-of-codeql-db>
```
### RLC\#

To run RLC# on a different C# project, use the `rlc.py` script. This script executes RLC# on a CodeQL database and generates two files in the `~/csharp-results/rlc` directory. One file (named \<db-name\>-rlc-warnings-with-\<no|manual|inferred\>-annotations.csv) contains a list of warnings generated by RLC#. Each entry corresponds to one warning, providing meta information and the location where the resource was allocated, which may not be disposed along some path. The second file (named \<db-name\>-rlc-summary-with-\<no|manual|inferred\>-annotations.csv) summarizes the RLC# run, offering the total number of generated warnings (including those related to annotation verification), actual resource leaks, and the runtime of a single RLC# run.
```python
python3 scripts/rlc.py <path-of-codeql-db> <0|1|2>
```
`0`: run RLC# with no annotations

`1`: run RLC# with hand-written (manual) annotations

`2`: run RLC# with inferred annotations

### Performance 

To measure the performance of inference and RLC# on a different C# project, use the `time-inference.py` and `time-rlc.py` scripts. These scripts run inference and RLC# on a CodeQL database for a specified number of times. Both scripts generate a file reporting the runtime for each run and an average of all runs in the `~/csharp-results/inference` and `~/csharp-results/rlc` directories.
```python
python3 scripts/time-inference.py <path-of-codeql-db> <num-of-runs>
python3 scripts/time-rlc.py <path-of-codeql-db> <0|1|2> <num-of-runs>
```

