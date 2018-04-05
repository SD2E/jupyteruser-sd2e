#Image: sd2e/jupyteruser-sd2e
#Version: 0.3.2

FROM sd2e/jupyteruser-base:0.2.0

# Image release
USER root
ARG image_version=development
RUN echo "${image_version}" > /etc/sd2e_jupyteruser-sd2e-release && \
	chmod a+r /etc/sd2e_jupyteruser-sd2e-release

##########################################
# igraph and networkx
##########################################
USER root
LABEL "comment"="Support for plotly igraph and networkx" "issue"="SD2E/jupyteruser-sd2e/issues/3"
RUN conda install --quiet --yes python-igraph plotly networkx && \
	conda install --quiet --yes -n python2 python-igraph plotly networkx && \
	docker-clean

##########################################
# Probcomp stack
##########################################
USER root

LABEL "comment"="Support for Open Probabilistic Programming Stack" "issue"="SD2E/jupyteruser-sd2e/issues/2"
# Libraries
RUN apt-get update && \
    apt-get install -y libboost-all-dev libgsl0-dev ccache && \
    apt-get clean && \
# Install dependencies and remove anaconda toolchain
conda install -n python2 --quiet --yes flask jsonschema patsy requests six && \
	conda install -n python2 -c conda-forge apsw && \
	conda uninstall -n python2 --yes \
		binutils_impl_linux-64 binutils_linux-64 \
		gcc_impl_linux-64 gcc_linux-64 \
		gxx_impl_linux-64 gxx_linux-64 && \
# Install probcomp software stack
bash -c "export MPLBACKEND=Agg && source activate python2 && pip2 install git+https://github.com/probcomp/Venturecxx@v0.5.1.1 && \   
        pip2 install git+https://github.com/probcomp/cgpm.git@v0.1.2 && \
        pip2 install git+https://github.com/probcomp/crosscat.git@v0.1.56.1 && \
        pip2 install git+https://github.com/probcomp/bayeslite.git@v0.3.2 && \
        pip2 install git+https://github.com/probcomp/iventure.git@v0.2.3" && \
# Clean cache
docker-clean

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
    apt-get clean && \
    cd /opt/common-lisp && \
    git clone git://git.code.sf.net/p/sbcl/sbcl && \
    cd sbcl && \
    git checkout tags/sbcl-1.4.3 && \
    sh make.sh && rm -rf .git && \
    cd /opt/common-lisp/sbcl && \
    sh install.sh && \
    apt-get purge -y sbcl   # Uninstall the version from apt-get

COPY common-lisp/ql_setup.lisp /opt/common-lisp/ql_setup.lisp

# Install the common lisp jupyter kernel
RUN cd /opt/common-lisp/ && \
    git clone https://github.com/fredokun/cl-jupyter.git && \
    cd cl-jupyter && rm -rf .git && \
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
    mv $HOME/.ipython/kernels/lisp/kernel.json /opt/conda/share/jupyter/kernels/lisp && \
    chmod -R a+rwX /opt/conda/share/jupyter/kernels/lisp && \
    rm -rf ${HOME}/.ipython && docker-clean

COPY examples/common-lisp /home/jupyter/examples/common-lisp

##########################################
# pyemd support
##########################################
USER root
LABEL "comment"="support for pyemd" "issue"="SD2E/jupyteruser-sd2e/issues/8"
RUN conda install --quiet --yes pyemd && \
	conda install --quiet --yes -n python2 pyemd && \
	docker-clean

##########################################
# Support DSGRN code
##########################################
USER root
LABEL "comment"="Support DSGRN code" "issue"="SD2E/jupyteruser-sd2e/issues/9"
RUN apt-get install -y cmake graphviz && \
	conda install --quiet --yes python-graphviz && \
	conda install --quiet --yes -n python2 python-graphviz && \
	docker-clean

##########################################
# Support Tensorflow and Keras
##########################################
USER root
LABEL "comment"="Support Tensorflow and Keras" "issue"="SD2E/jupyteruser-sd2e/issues/13"
RUN bash -c "source activate python2 && \
pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.6.0-cp27-none-linux_x86_64.whl && \
pip install keras" && \
bash -c "source activate root && \
pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.6.0-cp36-cp36m-linux_x86_64.whl && \
pip install keras" && \
	docker-clean
RUN cd examples && \
	git clone https://github.com/leriomaggio/deep-learning-keras-tensorflow.git && \
	cd deep-learning-keras-tensorflow && rm -rf .git

###############################################
# Permissions
###############################################

# The notebook is run by the TACC userid, not jupyter,
# so permissions need to be open
RUN chown -R jupyter:G-819382 /home/jupyter && \
	chmod 777 /home/jupyter && \
	find /home/jupyter -type f -exec chmod 666 {} \; && \
	find /home/jupyter -type d -exec chmod 777 {} \;

USER jupyter