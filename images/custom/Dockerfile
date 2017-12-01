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


##########################################
####  Common Lisp Kernel Setup Begin  ####
##########################################

# Get sbcl from the package manage and use it to build
# the sbcl 1.4.0 from source. The version from the package
# manager is not the current version.
RUN mkdir /opt/common-lisp && \
    apt-get update && \
    apt-get install -y sbcl libzmq3-dev && \
    cd /opt/common-lisp && \
    git clone git://git.code.sf.net/p/sbcl/sbcl && \
    cd sbcl && \
    git checkout tags/sbcl-1.4.0 && \
    sh make.sh && \
    cd /opt/common-lisp/sbcl && \
    sh install.sh && \
    apt-get purge -y sbcl   # Uninstall the version from apt-get

COPY common-lisp/ql_setup.lisp /opt/common-lisp/ql_setup.lisp

# Install the common lisp jupyter kernel
RUN cd /opt/common-lisp/ && \
    git clone https://github.com/fredokun/cl-jupyter.git && \
    cd cl-jupyter && \
    python ./install-cl-jupyter.py && \
    cd /opt/common-lisp && \
    curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --load ql_setup.lisp && \
    rm quicklisp.lisp ql_setup.lisp

# SBCL init file
# Loads required packages for common lisp kernel
# everytime sbcl starts
COPY common-lisp/sbclrc /home/jupyter/.sbclrc

# Move the kernel json file to the correct location
RUN mkdir /opt/conda/share/jupyter/kernels/lisp && \
    mv /home/jupyter/.ipython/kernels/lisp/kernel.json /opt/conda/share/jupyter/kernels/lisp

COPY examples/common-lisp /home/jupyter/examples/common-lisp

########################################
####  Common Lisp Kernel Setup End  ####
########################################


# Always end on switch to notebook user
USER jupyter
