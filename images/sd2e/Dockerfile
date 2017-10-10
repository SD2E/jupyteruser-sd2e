FROM sd2e/jupyteruser-custom:devel

# Convention envs to help
# people build portable scripts
ENV WORK /home/jupyter/mydata
ENV DATA /home/jupyter/sd2e-community

# Force ownership and permissions on /home/jupyter
USER root
RUN echo 'PS1="$JPY_USER@\h:\w\$ "' >> /home/jupyter/.bashrc
ADD ./dotjupyter/custom.css /home/jupyter/.jupyter/custom/custom.css
ADD docs/SD2E_READMD.md /home/jupyter/SD2E_READMD.md
RUN chmod -R a+rw /home
RUN chown -R jupyter:G-818301 /home/jupyter/examples

USER jupyter
