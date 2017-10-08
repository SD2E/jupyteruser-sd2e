# Image: taccsciapps/jupyteruser-base

FROM taccsciapps/jupyteruser-pub
LABEL origin="https://bitbucket.org/tacc-cic/jupyter/notebooks/tenants/sd2e/Dockerfile"

USER root
# Support jupyterthemes and other over-rides
RUN mkdir -p /home/jupyter/.jupyter/custom/fonts
RUN chmod -R a+rw /home

# allow users to add kernels
RUN chmod 777 /opt/conda/share/jupyter/kernels

RUN pip install jupyterthemes

USER jupyter

# Replace stock Agave CLI with SD2E-customized tooling
# Don't do this until CLI base is updated with Python 3.x support
#RUN curl -L https://raw.githubusercontent.com/sd2e/sd2e-cli/master/install/install.sh | sh
#RUN rm -rf /home/jupyter/cli && \
#    mv /home/jupyter/sd2e-cloud-cli /home/jupyter/cli

