# Image: taccsciapps/jupyteruser-base

FROM taccsciapps/jupyteruser-pub
LABEL origin="https://bitbucket.org/tacc-cic/jupyter/notebooks/tenants/sd2e/Dockerfile"

USER root
RUN chmod -R a+rw /home

RUN echo 'PS1="${JPY_USER}@\h:\w\$ "' >> /home/jupyter/.bashrc
USER jupyter
