FROM sd2e/jupyteruser-base:devel

USER root

LABEL "comment"="Support for plotly igraph and networkx" "issue"="SD2E/jupyteruser-sd2e/issues/3"
RUN pip install python-igraph plotly networkx

# Extend and customize jupyter $HOME environment
USER jupyter

# ADD examples/myexample.ipynb examples/
