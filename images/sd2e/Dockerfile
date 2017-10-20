FROM sd2e/jupyteruser-custom:devel

# Convention envs to help
# people build portable scripts
ENV WORK /home/jupyter/tacc-work
ENV SD2_DATA /home/jupyter/sd2e-community

# Force ownership and permissions on /home/jupyter
USER root
RUN echo 'PS1="$JPY_USER@\h:\w\$ "' >> /home/jupyter/.bashrc
ADD ./dotjupyter/custom.css /home/jupyter/.jupyter/custom/custom.css
ADD docs/SD2E_README.md /home/jupyter/SD2E_README.md
RUN chmod -R a+rw /home
RUN chown -R jupyter /home/jupyter/examples

# Bioconductor
RUN conda install -c bioconda bioconductor-biocinstaller
# BioPython
RUN conda install -c anaconda biopython

# Install latest AgavePy
WORKDIR /home/jupyter/
RUN /opt/conda/envs/python2/bin/pip install -e git+https://github.com/TACC/agavepy.git#egg=agavepy
RUN pip install -e git+https://github.com/TACC/agavepy.git#egg=agavepy

# Enable sd2nb sharing service
RUN cd /root && \ 
    git clone https://github.com/SD2E/sd2nb-app.git && \
    cd sd2nb-app && \
    make && make install

# Enable sd2e-jupyter 
RUN cd /root && \ 
    git clone https://github.com/SD2E/sd2e-jupyter-ascending.git && \
    cd sd2e-jupyter-ascending && \
    make && make install

# Tree
RUN apt-get update && \
    apt-get install -y tree && \
    apt-get clean

# Make sure Jupyter group == SD2E-Community == 819382
RUN groupadd --gid 819382 G-819382
RUN usermod -g G-819382 jupyter -a -G G-818301
RUN find /home/jupyter -gid G-819382 -exec chown jupyter:G-819382 {} \;

ADD jupyteruser-sd2e_release /etc/jupyteruser-sd2e_release

USER jupyter
