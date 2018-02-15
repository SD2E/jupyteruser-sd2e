#Image: sd2e/jupyteruser-singularity
#Version: 0.1.0

FROM sd2e/jupyteruser-sd2e:0.3.1

# Image release
USER root
ARG image_version=development
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-singularity-release && \
	chmod a+r /etc/sd2e_jupyteruser-singularity-release

# Make sd2e dir
ENV SD2E_DIR=/opt/sd2e
ARG SD2E_HOME=/opt/sd2e/jupyter
RUN [ ! -e $SD2E_DIR ] && mkdir -p $SD2E_HOME && \
##########################################
# Archive HOME
##########################################
cp -r examples SD2E_README.md $SD2E_HOME/ && \
#cp -r .cache $SD2E_HOME/ && \
tar -czf $SD2E_DIR/home_archive.tar.gz -C $SD2E_DIR jupyter && \
chmod 644 $SD2E_DIR/home_archive.tar.gz && \
rm -rf $SD2E_HOME
##########################################
# Modify default config
##########################################
RUN echo "\n\n# Set a password if PASSWORD is set\n\
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
#CMD ["/bin/enter_singularity.sh"]
##########################################
# Clean up ENV
##########################################
ENV NB_USER=
ENV NB_UID=
ENV NB_GID=
#ENV HOME=
#ENV USER=
#ENV XDG_CACHE_HOME=
#ENV WORK=

USER jupyter
