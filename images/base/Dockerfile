#Image: sd2e/jupyteruser-base
#Version: 0.1.0

FROM taccsciapps/jupyteruser-base:latest
LABEL origin="https://bitbucket.org/gzynda/jupyter/src/40adbad7b10b34de715d5a86aec3fcf65e724b70/notebooks/base/jupyter-notebook/Dockerfile?at=CIC-425-image-redesign&fileviewer=file-view-default"

###############################################
# Environment
###############################################
USER root

# Image release
ARG image_version=development
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-base-release && \
chmod a+r /etc/sd2e_jupyteruser-base-release && \
# Make sure Jupyter group == SD2E-Community == 819382
groupadd --gid 819382 G-819382 && \
usermod -a -G G-819382 jupyter && \
usermod -g G-819382 jupyter && \
# Jupyterhub correctly sets JUPYTERHUB_USER
echo 'PS1="$JUPYTERHUB_USER@\h:\w\$ "' >> /home/jupyter/.bashrc && \
# allow users to add kernels
chmod 777 /opt/conda/share/jupyter/kernels

# Environment variables
ENV WORK /home/jupyter/tacc-work
ENV SD2_DATA /home/jupyter/sd2e-community

# Add readme
ADD docs/SD2E_README.md /home/jupyter/SD2E_README.md
# Add examples
ADD examples examples

###############################################
# Packages
###############################################

# Bioconductor and BioPython
RUN conda install --yes --quiet -c bioconda bioconductor-biocinstaller && \
	conda install --yes --quiet biopython && \
	conda install --yes --quiet -n python2 biopython && \
# Enable sd2nb sharing service
cd /root && \ 
	git clone https://github.com/SD2E/sd2nb-app.git && \
	( cd sd2nb-app && make && make install ) && \
	rm -rf sd2nb-app && \
# Enable sd2e-jupyter 
cd /root && \ 
	git clone https://github.com/SD2E/sd2e-jupyter-ascending.git && \
	( cd sd2e-jupyter-ascending && make && make install ) && \
	rm -rf sd2e-jupyter-ascending && \
# Ubuntu Packages
apt-get update && \
    apt-get install -y tree less openjdk-8-jre && \
    apt-get clean && \
# Replace stock Agave CLI with SD2E-customized tooling
curl -L https://raw.githubusercontent.com/sd2e/sd2e-cli/master/install/install.sh | sh && \
	rm -rf /opt/cli && \
	mv /home/jupyter/sd2e-cloud-cli /opt/cli && \
# Spark 2.2.1 and pyspark
cd /usr/local && \
        curl http://apache.claz.org/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz | tar -xzf - && \
        mv spark-2.2.1-bin-hadoop2.7 spark && \
        conda install --yes biopython pyspark && \
        conda install -n python2 --yes biopython pyspark && \
# Clean conda cache
conda clean -tipsy && \
# Clean temporary files
apt-get clean && conda clean -tipsy && \
bash -c "for dir in /tmp/* /var/tmp/* /home/jupyter/.cache/pip /root/.cache/pip; do [ -e $dir ] && rm -rf $dir; done"

ENV SPARK_HOME=/usr/local/spark

###############################################
# Permissions
###############################################

# The notebook is run by the TACC userid, not jupyter,
# so permissions need to be open
RUN chown -R jupyter:G-819382 /home/jupyter && \
	chmod 777 /home/jupyter && \
	find /home/jupyter -type f -exec chmod 666 {} \; && \
	find /home/jupyter -type d -exec chmod 777 {} \;

USER jupyter
