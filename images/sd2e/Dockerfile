FROM sd2e/jupyteruser-custom:devel

# Convention envs to help
# people build portable scripts
ENV WORK /home/jupyter/mydata
ENV DATA /home/jupyter/sd2e-community

# Force ownership and permissions on /home/jupyter
USER root
RUN chmod -R a+rw /home
RUN chown -R jupyter:G-818301 /home/jupyter/examples
RUN echo 'PS1="$JPY_USER@\h:\w\$ "' >> /home/jupyter/.bashrc
ADD ./dotjupyter/custom.css /home/jupyter/.jupyter/custom/custom.css
USER jupyter
