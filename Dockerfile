FROM jupyter/minimal-notebook:latest

# Do the pip installs as the unprivileged notebook user
USER $NB_USER

ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# Install NB2KG
# RUN pip install --upgrade nb2kg && \
RUN pip install "git+https://github.com/jupyter-incubator/nb2kg.git#egg=nb2kg" && \
    jupyter serverextension enable --py nb2kg --sys-prefix

# Git support: https://github.com/jupyterlab/jupyterlab-git
RUN jupyter labextension install @jupyterlab/git && \
  pip install jupyterlab-git && \
  jupyter serverextension enable --py jupyterlab_git

# HTML support: https://github.com/mflevine/jupyterlab_html
RUN jupyter labextension install @mflevine/jupyterlab_html

# Latex support: https://github.com/jupyterlab/jupyterlab-latex
RUN pip install jupyterlab_latex && \
  jupyter labextension install @jupyterlab/latex

USER root
ENV DEBIAN_FRONTEND noninteractive
#ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
#dpkg-reconfigure --frontend noninteractive tzdata

RUN apt update && apt install -y ssh vim awscli

USER $NB_USER
