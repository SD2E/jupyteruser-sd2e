#Image: sd2e/jupyteruser-sd2e
#Version: 0.3.0

FROM sd2e/jupyteruser-base:0.3.0

# Image release
USER root
ARG image_version=test
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-sd2e-release && \
	chmod a+r /etc/sd2e_jupyteruser-sd2e-release

##########################################
# igraph and networkx
##########################################
USER root
LABEL "comment"="Support for plotly igraph and networkx" "issue"="SD2E/jupyteruser-sd2e/issues/3"
RUN conda install --quiet --yes python-igraph plotly networkx && \
	conda install --quiet --yes -n python2 python-igraph plotly networkx && \
	conda clean -tipsy

##########################################
# Probcomp stack
##########################################
USER root

LABEL "comment"="Support for Open Probabilistic Programming Stack" "issue"="SD2E/jupyteruser-sd2e/issues/2"
# Libraries
RUN apt-get update && \
    apt-get install -y libboost-all-dev libgsl0-dev ccache && \
    apt-get clean
# Packages
RUN conda install -n python2 --quiet --yes flask jsonschema patsy requests six && \
	conda install -n python2 -c conda-forge apsw && \
	conda uninstall -n python2 --yes \
		binutils_impl_linux-64 binutils_linux-64 \
		gcc_impl_linux-64 gcc_linux-64 \
		gxx_impl_linux-64 gxx_linux-64

ENV MPLBACKEND=Agg
RUN bash -c "source activate python2 && pip2 install git+https://github.com/probcomp/Venturecxx@v0.5.1.1 && \   
        pip2 install git+https://github.com/probcomp/cgpm.git@v0.1.2 && \       
        pip2 install git+https://github.com/probcomp/crosscat.git@v0.1.56.1 && \
        pip2 install git+https://github.com/probcomp/bayeslite.git@v0.3.2 && \  
        pip2 install git+https://github.com/probcomp/iventure.git@v0.2.2"
RUN rm -rf /home/jupyter/.cache/pip && conda clean -tipsy

RUN mkdir -p /home/jupyter/examples/probcomp && \
	cd /home/jupyter/examples/probcomp && \
	curl http://probcomp-workshop-materials.s3.amazonaws.com/latest.tgz | tar -xzf -

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

###############################################
# Permissions
###############################################
RUN chown -R jupyter /home/jupyter && \
	find /home/jupyter -type f -exec chmod 660 {} \; && \
	find /home/jupyter -type d -exec chmod 770 {} \;

USER jupyter
