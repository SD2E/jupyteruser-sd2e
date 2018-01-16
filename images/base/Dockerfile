#Image: sd2e/jupyteruser-base
#Version: 0.3.0

FROM taccsciapps/jupyteruser-base
LABEL origin="https://bitbucket.org/gzynda/jupyter/src/40adbad7b10b34de715d5a86aec3fcf65e724b70/notebooks/base/jupyter-notebook/Dockerfile?at=CIC-425-image-redesign&fileviewer=file-view-default"

###############################################
# Environment
###############################################
USER root

# Image release
ARG image_version=test
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-base-release && \
	chmod a+r /etc/sd2e_jupyteruser-base-release

# Environment variables
ENV WORK /home/jupyter/tacc-work
ENV SD2_DATA /home/jupyter/sd2e-community

# Prompt
RUN echo 'PS1="$JPY_USER@\h:\w\$ "' >> /home/jupyter/.bashrc

# allow users to add kernels
RUN chmod 777 /opt/conda/share/jupyter/kernels

# Add readme
ADD docs/SD2E_README.md /home/jupyter/SD2E_README.md

###############################################
# Packages
###############################################

# Bioconductor and BioPython
RUN conda install --yes --quiet -c bioconda bioconductor-biocinstaller && \
	conda install --yes --quiet biopython && \
	conda install --yes --quiet -n python2 biopython && \
	conda clean -tipsy

# Enable sd2nb sharing service
RUN cd /root && \ 
	git clone https://github.com/SD2E/sd2nb-app.git && \
	( cd sd2nb-app && make && make install ) && \
	rm -rf sd2nb-app

# Enable sd2e-jupyter 
RUN cd /root && \ 
	git clone https://github.com/SD2E/sd2e-jupyter-ascending.git && \
	( cd sd2e-jupyter-ascending && make && make install ) && \
	rm -rf sd2e-jupyter-ascending

# Ubuntu Packages
RUN apt-get update && \
    apt-get install -y tree less && \
    apt-get clean

# Replace stock Agave CLI with SD2E-customized tooling
RUN curl -L https://raw.githubusercontent.com/sd2e/sd2e-cli/master/install/install.sh | sh && \
	rm -rf /opt/cli && \
	mv /home/jupyter/sd2e-cloud-cli /opt/cli

###############################################
# Permissions
###############################################
chown -R jupyter /home/jupyter
find /home/jupyter -type f -exec chmod 660 {} \;
find /home/jupyter -type d -exec chmod 770 {} \;

USER jupyter
