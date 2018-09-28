# Change Log

All notable changes to this project are to be documented in this file.

## Version 0.3.4

- Base now getting Ubuntu xenial security updates
- Updated SD2E CLI to latest (1.2.1)
- Image rebuild updates jupyter notebook, conda base versions
- README updated
  - converted to .ipynb for better readabilty in notebook environment

## Version 0.3.3

 - Added hub https://github.com/github/hub
 - Create persistent environments
   - `conda create -y -p $LOCAL_ENVS/tabsAreGreat python=2.7 ipykernel 'scipy==0.16.0'`
 - Discover persistent environments
   - `conda env list`
 - Create a new kernel
   - `$LOCAL_ENVS/tabsAreGreat/bin/python -m ipykernel install --prefix $JUPYTER_WORK --name tabsAreGreat --display-name "tabs are great"`
   - Refresh main page
 - Added ML modules
   - Tensorflow 1.6
   - Theano
   - Keras
 - Optimized image size by starting from ubuntu base

## Version 0.3.1

 - Added `PYTHONUSERBASE` variable, which points at `tacc-work/jupyter_packages`, and allows for persistent local pip installs
 - Added pyemd
 - Added graphviz, python-graphviz, cmake to support DSGRN
 - FIXED git funtionality by setting
   - `GIT_COMMITTER\_NAME=$JUPYTERHUB\_USER`
   - `GIT_COMMITTER\_EMAIL=${JUPYTERHUB\_USER}@sd2e.org`
 - REMOVED the hardcoding of `MPLBACKEND` to `Agg`

## Version 0.3.0

 - Refactored images to start from taccsciapps/jupyteruser-base
 - Removed jovyan user and environment
 - Optimized docker files for size (now smaller)
 - Updated python stack
 - Numpy now uses Intel MKL
 - pip2 now works
 - Updated probcomp stack and examples
 - Updated sbcl to 1.4.3
 - Removed Spark, pyspark, and example
 - Updated instructions for contributing and maintaining software
 - Updated Makefile to utilize `build/build_jupyteruser.sh` to:
   - Check for dependencies
   - Check tags on docker hub
   - Version each sub-image
   - Build, test, and deploy without squashing tags

## Version 0.2.0

Summary: Add R, base R and Py packages, useful bits

## Version 0.1.0

Summary: Import from original jupyteruser-sd2e:0.1.0 base

### Added
* Introduced a community-extensible build process for the image

### Changed
* Command prompt in Jupyter Terminal now returns your TACC username

### Removed
* Nothing

