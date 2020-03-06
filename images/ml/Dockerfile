#Image: sd2e/tacc-ml-jupyter
#Version: 0.0.1

ARG TAG
FROM tacc/tacc-ml:${TAG}
ARG TAG

# Image release
USER root
ARG image_version=development
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-ml-singularity-release && \
	chmod a+r /etc/sd2e_jupyteruser-ml-singularity-release

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
RUN groupadd --gid 816877 ${AGAVE_GID}
RUN useradd --uid 458981 --gid ${AGAVE_GID} -m --home /home/jupyter --shell /bin/bash $NB_USER
RUN groupadd --gid ${NB_GID} tacc-group
RUN usermod -a -G ${NB_GROUP} jupyter
# While not ideal, this is required since the users that are injected
# into the container do not exist.
ENV HOME=/home/jupyter \
    USER=jupyter
#    LC_ALL=en_US.UTF-8 \
#    LANG=en_US.UTF-8 \
#    LANGUAGE=en_US.UTF-8
# Make primary group TACC_GID
RUN usermod -g ${NB_GROUP} jupyter

###################################################################
# Add jupyter helper scripts
###################################################################
ARG BURL=https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook
RUN cd /usr/local/bin \
	&& for target in fix-permissions start{,-notebook,-singleuser}.sh; do \
		curl -sL ${BURL}/$target > $target \
		&& chmod a+rx $target; \
	done
RUN mkdir /etc/jupyter && cd /etc/jupyter && curl -sL ${BURL}/jupyter_notebook_config.py > jupyter_notebook_config.py && \
chmod -R a+rX /etc/jupyter /usr/local/bin

##########################################
# Modify default config
##########################################
RUN echo -e "\n\n# Set a password if PASSWORD is set\n\
if 'PASSWORD' in os.environ:\n\
\tfrom IPython.lib import passwd\n\
\tc.NotebookApp.password = passwd(os.environ['PASSWORD'])\n\
\tdel os.environ['PASSWORD']\n\n\
c.NotebookApp.iopub_data_rate_limit=10000000" >> /etc/jupyter/jupyter_notebook_config.py
##########################################
# Update CMD
##########################################
COPY enter_singularity.sh /bin/enter_singularity.sh
RUN chmod 755 /bin/enter_singularity.sh
#ENTRYPOINT ["/bin/bash"]
CMD ["/bin/enter_singularity.sh"]
#CMD ["jupyter","notebook"]
#ENTRYPOINT ["/bin/enter_singularity.sh"]
#CMD []

EXPOSE 8888
##########################################
# Clean up ENV
##########################################
ENV NB_USER=
ENV NB_UID=
ENV NB_GID=
ENV NB_GROUP=
ENV USER=
ENV HOME=
#'$STOCKYARD/jupyter'
ENV PYTHONUSERBASE='$STOCKYARD/jupyter_packages'
ENV JUPYTER_PATH='$STOCKYARD/jupyter_packages/share/jupyter:'
ENV JUPYTER_WORK='$STOCKYARD/jupyter_packages'
ENV LOCAL_ENVS='$STOCKYARD/jupyter_packages/envs'
ENV CONDA_ENVS_PATH='$STOCKYARD/jupyter_packages/envs:'
#ENV XDG_CACHE_HOME=
#ENV WORK=

USER jupyter
