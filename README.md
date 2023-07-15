## Evaluation of Inference and Resource Leak Checker for C# Code

This Docker image contains:

* source code (CodeQL queries) of our tools (will be found in /home/oopsla/codeql-repo/csharp/ql/src/RLC-Codeql-Queries)
* all benchmarks (will be found in /home/oopsla/csharp-open-source-projects)
* scripts to reproduce our experiments (will be found in /home/oopsla/scripts)
* manual analysis report of warnings generated by the verifier (will be found at https://docs.google.com/spreadsheets/d/1qEQyj2kmLOnURmDFiHAPnu-vR4NbAUIwOliGqopLqnE/edit?usp=sharing)
* annotations for standard libraries of C# and hand-written annotations for our benchmarks (will be found in /home/oopsla/docs)

### Software Versions
* [dotnet](https://dotnet.microsoft.com/en-us/download): 6.0.119
* [CodeQL](https://codeql.github.com/): 2.13.5
* [Ubuntu](https://ubuntu.com/): 22.04 for Docker image and host machines


### Setup

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
We use the option '--ram=65536' in the `codeql database analyze ....` command for our experiments which sets the maximum RAM usage for the query evaluator. The results reported in the paper and the estimated time for each script are based on this configuration. However, specifying this configuration in a Docker container may not be feasible due to varying machine configurations. Consequently, the performance-related data produced may vary based on your machine's configuration.

CodeQL experiments begin with the generation of a CodeQL database. 

### CodeQL Database Creation

A CodeQL database is a relational database that is created by extracting code information from the source code of the target project, allowing CodeQL to perform in-depth analysis and identify potential security vulnerabilities or issues. Once the CodeQL database is generated, it can be queried using CodeQL queries to uncover insights and perform various analyses on the codebase.

The `createCodeQLDB.py` script clones the repositories of Lucene.Net and EF Core and generates their respective CodeQL databases. It takes approximately 25-30 minutes to create both databases.
```python
python3 scripts/createCodeQLDB.py
```

### Reproducing Table 1

Table 1 in our paper presents the percentage of hand-written annotations that our algorithm was able to infer.
You can reproduce Table 1 by executing the `csharp-table1.py` script. This script runs the CodeQL query for Inference on both benchmarks and compares the inferred annotations from the query with the manually added annotations (available in the docs directory). The output format is identical to that in the paper. Generating the results takes approximately 20-22 minutes. 
The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table1.txt`.
```python
python3 scripts/csharp-table1.py

```
### Reproducing Table 2

Table 2 in our paper presents the number of warnings generated by RLC# in two scenarios: without annotations and with inferred annotations. These numbers are presented in the second and third columns of the table. The remaining columns in Table 2 involve manual analysis of the warnings and cannot be generated automatically. We offer this information separately in a Google Doc [Manual-Report](https://docs.google.com/spreadsheets/d/1qEQyj2kmLOnURmDFiHAPnu-vR4NbAUIwOliGqopLqnE/edit?usp=sharing).

To reproduce Table 2, execute the `csharp-table2.py` script. This script runs RLC# twice for each benchmark, first without annotations and then with inferred annotations (generated in the previous step). The output of the script gives the first three columns of Table 2. It takes approximately 4.5 hours for the script to produce results for both benchmarks. The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table2.txt`.
```python
python3 scripts/csharp-table2.py
```
RLC# warnings for each benchmark can be found in `csharp-results/rlc/<db-name>-rlc-warnings-with-no-annotations.csv` and `csharp-results/rlc/<db-name>-rlc-warnings-with-inferred-annotations.csv` for the two settings.

### Reproducing Table 3 

In our paper, Table 3 presents the performance of Inference and checking. To reproduce Table 3, execute the `csharp-table3.py` script. This script executes Inference and RLC# with the inferred annotations for a total of three runs, recording the average runtime for each query and benchmark. The output of this script generates Table 3, excluding the kLoC column. It takes approximately 8.5 hours for the script to produce results for both benchmarks. 
The output is shown on stdout and is also saved in the file `~/csharp/results/overall-results/table3.txt`.
```python
python3 scripts/csharp-table3.py
```
## Evaluating Inference and Resource Leak Checker on Various C# Benchmarks

You can test both Inference and RLC# on benchmarks that are not included with this artifact.

### CodeQL Database Creation

If you want to create a CodeQL database for a different project, use the following command. In some cases, you might need to use custom commands. For details, check [codeql database create](https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases).
```python
cd <source-code-project>
codeql database create <database> --language=<language-identifier> 
```
You must specify:

* \<database\>: a path to the new database to be created. This directory will be created when you execute the command. You cannot specify an existing directory.
* \<language-identifier\>: the identifier for the language to create a database for. For C#, it is `csharp`.

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
