# SD2E Jupyter Notebook Environment

## What it Gives You

* Jupyter Notebook \(v5.2.0\)server
* Conda Python 3.4.x and Python 2.7.x environments
  * Custom environments and kernels now supported through `Advanced Jupyter.ipynb` notebook
* Pre-installed python packages (highlights)
  * pandas
  * matplotlib 2.1.2
  * numpy, scipy
  * seaborn
  * scikit-learn
  * numba
  * pyemd
* R-kernel
* Plotly, igraph, networkx, graphviz for graphs and plots
* MIT's [Open Probabilistic Programming Stack](http://probcomp.org/)
* [Common Lisp kernel and stack](http://www.sbcl.org/)
  * v1.4.6 Now installed as binary
* Bioconda and Bioconductor
* BioPython
* Git

### SD2E Specific Features

* Integration with TACC's Agave API via the sd2e-cli and AgavePy library
* The sd2nb Jupyter Notebook sharing service
* The sd2e-jupyter application for launching HPC & GPU-powered notebooks

## Details

This repository builds the Docker image supporting the SD2E Jupyter Notebooks environment. Until the platform team releases the upcoming feature to select beteween support environments at launch time, major dependencies and configuration options must be set in this base image. 

Via a combination of the repository itself plus GitHub's collaborative issue management, code review, and other features we are implementing a cooperative process for SD2 collaborators to improve and extend the runtime environment. When we transition to supporting multiple base images, we'll extend this process to support that feature.

## Guidelines and policies

The process for community contributions is outlined in [CONTRIBUTING](./CONTRIBUTING.md). Critical guidelines for the maintainers of this repo and the SD2E Jupyter are in [MAINTAINERS](./MAINTAINERS.md). 

