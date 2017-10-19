FROM sd2e/jupyteruser-base:devel

USER root
LABEL "comment"="Support for plotly igraph and networkx" "issue"="SD2E/jupyteruser-sd2e/issues/3"
# Py3
RUN pip install python-igraph plotly networkx
# Py2
RUN /bin/bash -c "source activate python2 && \
    pip install python-igraph plotly networkx"

USER root
LABEL "comment"="Support for Open Probabilistic Programming Stack" "issue"="SD2E/jupyteruser-sd2e/issues/2"
# Py2
RUN apt-get update && \
    apt-get install -y libboost-all-dev libgsl0-dev ccache && \
    apt-get clean
RUN /bin/bash -c "source activate python2 && \
    pip install https://github.com/probcomp/Venturecxx/archive/v0.5.1a20170816.tar.gz"
RUN /bin/bash -c "source activate python2 && \
    pip install git+https://github.com/probcomp/cgpm.git@v0.1"
RUN /bin/bash -c "source activate python2 && \
    pip install git+https://github.com/probcomp/crosscat.git@v0.1.56"
RUN /bin/bash -c "source activate python2 && \
    pip install git+https://github.com/probcomp/bayeslite.git@v0.3.1"
RUN /bin/bash -c "source activate python2 && \
    pip install git+https://github.com/probcomp/iventure.git@v0.2"

ADD ./examples/probcomp /home/jupyter/examples/probcomp
RUN chown -R jupyter:G-818301 /home/jupyter/examples/probcomp
RUN chmod -R a+rwX /home/jupyter/examples/probcomp

# Always end on switch to notebook user
USER jupyter
