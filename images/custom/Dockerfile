FROM taccsciapps/jupyteruser-base:devel

USER root
RUN apt-get update && apt-get install -y libboost-all-dev libgsl0-dev ccache
RUN /bin/bash -c "source activate python2 && pip install https://github.com/probcomp/Venturecxx/archive/v0.5.1a20170816.tar.gz"
RUN /bin/bash -c "source activate python2 && pip install git+https://github.com/probcomp/cgpm.git@v0.1"
RUN /bin/bash -c "source activate python2 && pip install git+https://github.com/probcomp/crosscat.git@v0.1.56"
RUN /bin/bash -c "source activate python2 && pip install git+https://github.com/probcomp/bayeslite.git@v0.3.1"
RUN /bin/bash -c "source activate python2 && pip install git+https://github.com/probcomp/iventure.git@v0.2"

ADD probcomp_examples /home/jupyter/probcomp_examples
RUN chown -R jupyter:G-818301 /home/jupyter/probcomp_examples
RUN chmod -R a+rwX /home/jupyter/probcomp_examples
