#Image: sd2e/jupyteruser-base
#Version: 0.2.2

FROM ubuntu:xenial
LABEL maintainer="Greg Zynda <gzynda@tacc.utexas.edu>"
###################################################################
# Environment
###################################################################
ENV DEBIAN_FRONTEND=noninteractive
USER root
WORKDIR /root
# Image release in /etc
ARG image_version=development
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-base-release && \
	chmod a+r /etc/sd2e_jupyteruser-base-release
# Use IU ubuntu mirror
RUN sed -i "s~archive.ubuntu.com~ftp.ussg.iu.edu/linux~" /etc/apt/sources.list
# Add clean script
RUN echo "#!/bin/bash\n\
apt-get clean\n\
[ -x \"\$(command -v conda)\" ] && conda clean -tipsy\n\
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/\.[^\.]* /var/lib/apt/lists/* /var/log/*; do\n\
	[ -e \$dir ] && rm -rf \$dir || true\n\
done" > /usr/bin/docker-clean && chmod a+rx /usr/bin/docker-clean && docker-clean
# Create Singularity Mounts
RUN mkdir /scratch /work /home1 /gpfs /corral-repl /corral-tacc /data
# Expose notebook port
EXPOSE 8888
###################################################################
# Dependencies
###################################################################
USER root
# Install dependencies
# - jq - required for abaco CLI
# - bsdmainutils->column - required for abaco CLI \
# - Install *-nox (non-GUI) versions of tools when available 
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        bzip2 unzip ca-certificates build-essential \
        emacs-nox vim-nox git wget openssh-client curl \
        tree less jq rsync bsdmainutils && \
    docker-clean
###################################################################
# Create jupyter user
###################################################################
# the default $NB_USER is jovyan, but we want the default user to be jupyter
# - create jupyter early
# - run all user installation commands as jupyter
# - add jupyter user to special uid

# Jupyter GIDs
ARG TACC_GID=65536
ARG AGAVE_GID=G-816877
# Parameterize GID
# 65536 is a dummy value since we now override user UID/GID at launch
#  using Docker nsmap. This should means it's only important for GIDs not
#  collide and that g+r(x) permissions are set where needed
ENV NB_USER=jupyter \
    NB_GID=${TACC_GID} \
    NB_GROUP=${TACC_GID} \
    SHELL=/bin/bash
RUN groupadd --gid 816877 ${AGAVE_GID} && \
    useradd --uid 458981 --gid ${AGAVE_GID} -m --home /home/jupyter --shell /bin/bash $NB_USER && \
    groupadd --gid ${NB_GID} ${NB_GROUP} && \
    usermod -a -G ${NB_GROUP} jupyter
# While not ideal, this is required since the users that are injected
# into the container do not exist.
ENV HOME=/home/jupyter
# Make primary group TACC_GID
RUN usermod -g ${NB_GROUP} jupyter

###################################################################
# Modify jupyter user environment
###################################################################

# Add jupyter helper scripts
ARG BURL=https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook
RUN bash -c "cd /usr/local/bin && for target in fix-permissions start{\"\",-notebook,-singleuser}.sh; do wget -q ${BURL}/\$target && chmod a+rx \$target; done" && \
mkdir /etc/jupyter && cd /etc/jupyter && wget -q ${BURL}/jupyter_notebook_config.py && \
fix-permissions /etc/jupyter /usr/local/bin

# Fix git for all users
ADD src/setup-git-user.sh /etc/profile.d/setup-git-user.sh
RUN chmod a+rx /etc/profile.d/setup-git-user.sh

# login as jupyter
USER jupyter
# Change docker CWD to /home/jupyter
WORKDIR /home/jupyter/

# Changes to local bashrc - these will require different variables in Singularity
## Jupyterhub correctly sets JUPYTERHUB_USER
RUN echo 'PS1="${JUPYTERHUB_USER:-jupyter}@\h:\w\$ "' >> /home/jupyter/.bashrc
## Environment variables
RUN echo "export JPY_USER=\$JUPYTERHUB_USER\n\
export WORK=/home/jupyter/tacc-work\n\
export SD2_DATA=/home/jupyter/sd2e-community\n\
export PROJECTS_DATA=/home/jupyter/sd2e-projects\n\
export PARTNERS_DATA=/home/jupyter/sd2e-partners\n\
export PYTHONUSERBASE=/home/jupyter/tacc-work/jupyter_packages\n" >> /home/jupyter/.bashrc

# Add readme
ADD docs/SD2E_README.md /home/jupyter/SD2E_README.md
# Add examples
ADD examples examples
# Add R kernel
ADD https://raw.githubusercontent.com/IRkernel/IRkernel/master/example-notebooks/Demo.ipynb examples/R-Demo.ipynb

###################################################################
# Install python
###################################################################
USER root
# Add conda env variables
ENV MINICONDA_VERSION=4.4.10 \
    CONDA_DIR=/opt/conda
# Conda path needs to go first so system python is not used
ENV PATH=${CONDA_DIR}/bin:$PATH
# Download and install miniconda
RUN mkdir $CONDA_DIR && chmod -R a+rX $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
RUN docker-clean && conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda update -n base conda && \
    conda update --all --quiet --yes && \
    docker-clean
###################################################################
# Create python3 environment
###################################################################

# Add packages to python3 environment
## installing r-essentials without r-base breaks gcc
RUN conda install --yes \
    notebook jupyter_console nbconvert ipykernel ipywidgets \
    'numpy=1.14*' \
    'scipy=1.0*' \
    'cython=0.27*' \
    'pandas=0.22*' \
    matplotlib seaborn \
    'h5py=2.7*' \
    'r-essentials' 'r-base' \
    'scikit-learn=0.19*' \
    'scikit-image=0.13*' \
    'biopython' && \
conda install -c defaults -c conda-forge --no-update-deps jupyterhub && \
conda create --yes -n python2 \
    'python=2.7' \
    'ipykernel' \
    'numpy=1.14*' \
    'scipy=1.0*' \
    'cython=0.27*' \
    'pandas=0.22*' \
    'h5py=2.7*' \
    matplotlib seaborn \
    'scikit-learn=0.19*' \
    'scikit-image=0.13*' \
    'biopython' \
    && docker-clean && rm -rf ${CONDA_DIR}/pkgs/*

# Create pip2 and pip3 shortcuts
RUN ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 && \
    ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3 && \
    chmod a+rX $CONDA_DIR

# Add activation sripts
ENV PYTHONUSERBASE=/home/jupyter/tacc-work/jupyter_packages
#ADD src/activate-python.sh /opt/conda/etc/conda/activate.d/activate-python.sh
#ADD src/activate-python.sh /opt/conda/envs/python2/etc/conda/activate.d/activate-python.sh
#RUN find ${CONDA_DIR} -type d -name activate.d -exec chmod -R a+rx {} \;

###################################################################
# Additional kernels
###################################################################
# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime and to allow the notebook server running out of the root
# environment to find it. Also, activate the python2 environment upon kernel

# Create python2 kernel
RUN bash -c "source activate python2 && ipython kernel install"
# Create bash kernel
RUN pip install bash_kernel && \
    python -m bash_kernel.install && \
    docker-clean
# Create R kernel
#    'r-base' && \
#RUN conda install --quiet --yes -n base r-essentials && docker-clean
#RUN conda create --quiet --yes -n R \
#    'r-essentials' && \
#    docker-clean
# Install bioconductor
RUN bash -c "source activate base && Rscript -e 'source(\"https://bioconductor.org/biocLite.R\"); biocLite();'"

###############################################
# Environment activation Kernels
###############################################

# Fixes compilers and local package installations
ADD src/activate_kernel /opt/conda/bin/activate_kernel
RUN chmod 755 /opt/conda/bin/activate_kernel && \
	TMPF=/tmp/tmp.json && \
	MODK=/usr/local/share/jupyter/kernels/python2/kernel.json && \
	jq " .argv = [\"activate_kernel\", \"python2\", \"{connection_file}\"] " ${MODK} | tee $TMPF && \
	mv $TMPF ${MODK} && \
	MODK=/opt/conda/share/jupyter/kernels/python3/kernel.json && \
	jq " .argv = [\"activate_kernel\", \"base\", \"{connection_file}\"] " ${MODK} | tee $TMPF && \
	mv $TMPF ${MODK}

###################################################################
# Agave tools
###################################################################

# install SD2E Agave CLI
ADD src/configuration.rc configuration.rc
RUN git clone https://github.com/SD2E/sd2e-cli.git && \
	mv configuration.rc sd2e-cli/ && cd sd2e-cli && \
	git submodule update --init --recursive && \
	make && make install && \
	cd ../ && rm -rf sd2e-cli && \
	mv /root/sd2e-cloud-cli /opt/cli && \
	ls -a /root && rm -rf /root/* /root/.[^\.]* && \
	chmod -R a+rX /opt/cli && chmod -R a+x /opt/cli/bin && \
	docker-clean
# add cli to PATH
ENV PATH=$PATH:/opt/cli/bin

# install agavepy
RUN bash -c "source activate base && pip install git+https://github.com/TACC/agavepy.git" && \
	bash -c "source activate python2 && pip install git+https://github.com/TACC/agavepy.git" && \
	docker-clean && find /root
# Enable sd2nb sharing service
RUN cd /root && \
	git clone https://github.com/SD2E/sd2nb-app.git && \
	( cd sd2nb-app && make && make install ) && \
	rm -rf sd2nb-app && \
	docker-clean
# Enable sd2e-jupyter
RUN cd /root && \
	git clone https://github.com/SD2E/sd2e-jupyter-ascending.git && \
	( cd sd2e-jupyter-ascending && make && make install ) && \
	rm -rf sd2e-jupyter-ascending && \
	docker-clean
# Add hub
RUN cd /root && \
    curl -skL -O "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz" && \
    tar zxf hub-linux-amd64-2.3.0-pre10.tgz && \
    cd hub-linux-amd64-2.3.0-pre10 && \
    ./install && \
    cd /root && rm -rf hub-linux-amd64-2.3.0-pre10*

###################################################################
# Add entrypoint
###################################################################
# Add Tini
ARG TINI_VERSION=v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod a+rx /usr/local/bin/tini
ENTRYPOINT ["tini", "--"]
#ENTRYPOINT ["bash"]
CMD ["start-notebook.sh"]

###############################################
# Persistent local conda environments
###############################################

# conda create -p $LOCAL_ENVS/tmnt python=2.7 ipykernel
# conda env list
# source activate tmnt
ENV LOCAL_ENVS=/home/jupyter/tacc-work/jupyter_packages/envs
ENV CONDA_ENVS_PATH=$LOCAL_ENVS:$CONDA_ENVS_PATH

###############################################
# Persistent local jupyter kernels
###############################################

# $LOCAL_ENVS/tmnt/bin/python -m ipykernel install --prefix $JUPYTER_WORK --name tmnt --display-name "tmnt python"
#  *Must use full path*
# refresh main jupyter to load the new kernel option
ENV JUPYTER_PATH=/home/jupyter/tacc-work/jupyter_packages/share/jupyter:$JUPYTER_PATH
ENV JUPYTER_WORK=/home/jupyter/tacc-work/jupyter_packages

###############################################
# Affiliated projects
###############################################

ADD src/add-sd2e-groups.sh /tmp/add-sd2e-groups.sh
RUN bash /tmp/add-sd2e-groups.sh && docker-clean

###############################################
# Permissions
###############################################

# The notebook is run by the TACC userid, not jupyter,
# so permissions need to be open
RUN chown -R jupyter:${NB_GROUP} /home/jupyter && \
	chmod 777 /home/jupyter && \
	find /home/jupyter -type f -exec chmod 666 {} \; && \
	find /home/jupyter -type d -exec chmod 777 {} \;

###################################################################
# Cache matplotlib for jupyter user
###################################################################
USER jupyter
# build matplotlib python2 font cache
RUN MPLBACKEND=Agg $CONDA_DIR/envs/python2/bin/python -c "import matplotlib.pyplot" && \
	docker-clean
# build matplotlib python3 font cache
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
	docker-clean
