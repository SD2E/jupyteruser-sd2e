#Image: sd2e/jupyteruser-base
#Version: 0.2.1

FROM taccsciapps/jupyteruser-base:0.1.2
LABEL origin="https://bitbucket.org/gzynda/jupyter/src/40adbad7b10b34de715d5a86aec3fcf65e724b70/notebooks/base/jupyter-notebook/Dockerfile?at=CIC-425-image-redesign&fileviewer=file-view-default"

###############################################
# Environment
###############################################
USER root

# Image release
ARG image_version=development
# Parameterize GID
# 65536 is a dummy value since we now override user UID/GID at launch
#  using Docker nsmap. This should means it's only important for GIDs not
#  collide and that g+r(x) permissions are set where needed
ARG TACC_GID=65536
ENV NB_GROUP=G-${TACC_GID}
ENV NB_GID=${TACC_GID}

RUN echo "${image_version}" > /etc/sd2e_jupyteruser-base-release && \
	chmod a+r /etc/sd2e_jupyteruser-base-release
RUN groupadd --gid ${NB_GID} ${NB_GROUP} && \
	usermod -a -G ${NB_GROUP} jupyter && \
	usermod -g ${NB_GROUP} jupyter

# Jupyterhub correctly sets JUPYTERHUB_USER
RUN echo 'PS1="$JUPYTERHUB_USER@\h:\w\$ "' >> /home/jupyter/.bashrc
# allow users to add kernels
RUN chmod 777 /opt/conda/share/jupyter/kernels
# Environment variables
RUN echo "export JPY_USER=\$JUPYTERHUB_USER\n\
export WORK=/home/jupyter/tacc-work\n\
export SD2_DATA=/home/jupyter/sd2e-community\n\
export PROJECTS_DATA=/home/jupyter/sd2e-projects\n\
export PARTNERS_DATA=/home/jupyter/sd2e-partners\n\
export PYTHONUSERBASE=/home/jupyter/tacc-work/jupyter_packages\n" >> /home/jupyter/.bashrc

# Add activation sripts
ADD src/activate-python.sh /opt/conda/etc/conda/activate.d/activate-python.sh
ADD src/activate-python.sh /opt/conda/envs/python2/etc/conda/activate.d/activate-python.sh
RUN find /opt/conda -type d -name activate.d -exec chmod -R a+rx {} \;

# Add readme
ADD docs/SD2E_README.md /home/jupyter/SD2E_README.md
# Add examples
ADD examples examples

###############################################
# Packages
###############################################

# Bioconductor and BioPython
RUN conda update --all && conda install --yes -c bioconda bioconductor-biocinstaller && \
	conda install --yes --quiet biopython && \
	conda install --yes --quiet -n python2 biopython && \
	docker-clean
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
# Ubuntu Packages
# - jq - required for abaco CLI
# - bsdmainutils->column - required for abaco CLI \
#apt-get install -y tree less openjdk-8-jre ca-certificates-java && \
RUN apt-get update && \
    apt-get install -y tree less jq rsync bsdmainutils && \
    docker-clean
# Replace stock Agave CLI with SD2E-customized tooling
ADD src/configuration.rc configuration.rc
RUN git clone https://github.com/SD2E/sd2e-cli.git && \
	mv configuration.rc sd2e-cli/ && cd sd2e-cli && \
	git submodule update --init --recursive && make && \
	make install && rm -rf /opt/cli && rm -rf $HOME/sd2e-cli && \
	mv /home/jupyter/sd2e-cloud-cli /opt/cli && \
	chmod -R a+rX /opt/cli && chmod -R a+x /opt/cli/bin && \
	docker-clean
# Spark 2.2.1 and pyspark
#cd /usr/local && \
#        curl http://apache.claz.org/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz | tar -xzf - && \
#        mv spark-2.2.1-bin-hadoop2.7 spark && \
#        conda install --yes pyspark && \
#        conda install -n python2 --yes pyspark && \
#ENV SPARK_HOME=/usr/local/spark

###############################################
# Environment activation Kernels
###############################################

ADD src/activate_kernel /opt/conda/bin/activate_kernel
RUN chmod 755 /opt/conda/bin/activate_kernel && \
	TMPF=/tmp/tmp.json && \
	MODK=/usr/local/share/jupyter/kernels/python2/kernel.json && \
	jq " .argv = [\"activate_kernel\", \"python2\", \"{connection_file}\"] " ${MODK} | tee $TMPF && \
	mv $TMPF ${MODK} && \
	MODK=/opt/conda/share/jupyter/kernels/python3/kernel.json && \
	jq " .argv = [\"activate_kernel\", \"root\", \"{connection_file}\"] " ${MODK} | tee $TMPF && \
	mv $TMPF ${MODK}

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
	jq " .argv = [\"activate_kernel\", \"root\", \"{connection_file}\"] " ${MODK} | tee $TMPF && \
	mv $TMPF ${MODK}

###############################################
# Persistent local conda environments
###############################################

# conda create -p $LOCAL_ENVS/tmnt python=2.7 ipykernel
# conda env list
# source activate tmnt
ENV LOCAL_ENVS=$HOME/tacc-work/jupyter_packages/envs
ENV CONDA_ENVS_PATH=$LOCAL_ENVS:$CONDA_ENVS_PATH

###############################################
# Persistent local jupyter kernels
###############################################

# $LOCAL_ENVS/tmnt/bin/python -m ipykernel install --prefix $JUPYTER_WORK --name tmnt --display-name "tmnt python"
#  *Must use full path*
# refresh main jupyter to load the new kernel option
ENV JUPYTER_PATH=$HOME/tacc-work/jupyter_packages/share/jupyter:$JUPYTER_PATH
ENV JUPYTER_WORK=$HOME/tacc-work/jupyter_packages

###############################################
# Affiliated projects
###############################################

ADD src/add-sd2e-groups.sh /tmp/add-sd2e-groups.sh
RUN bash /tmp/add-sd2e-groups.sh

###############################################
# Permissions
###############################################

# The notebook is run by the TACC userid, not jupyter,
# so permissions need to be open
RUN chown -R jupyter:${NB_GROUP} /home/jupyter && \
	chmod 777 /home/jupyter && \
	find /home/jupyter -type f -exec chmod 666 {} \; && \
	find /home/jupyter -type d -exec chmod 777 {} \;

USER jupyter
