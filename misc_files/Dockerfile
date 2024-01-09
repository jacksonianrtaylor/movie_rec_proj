FROM ubuntu:latest


# Note: An older version of python is specified to mitigate the chance that a newer verison of python runs into an issue with the notebook code.
# Python 3.10.7 worked on personal machine
RUN apt-get update && apt-get install -y python3.10 \
    python3-pip




# numpy==1.23.5, opendatasets, pandas, scikit-learn, scipy, ordered-set, gensim, nltk, jupyter, numba, dask, scikit-optimize, scikit-surprise
# not sure if dask or "dask[complete]"
# LOOK: not all the packages are used in full_model.ipynb

# LOOK: Be sure to update the readme with the new packages

# LOOK: Might need to use force reinstall for numpy version if a new verison is installed as a part of one of the other packages


# Install all packages:
RUN pip3 install numpy==1.23.5
RUN pip3 install opendatasets
RUN pip3 install pandas
RUN pip3 install scikit-learn
RUN pip3 install scipy
RUN pip3 install ordered-set
RUN pip3 install gensim
RUN pip3 install nltk
RUN pip3 install jupyter
RUN pip3 install kaggle
# LOOk: try removing these
# RUN pip3 install numba
# RUN pip3 install dask

# Also try changing python version
RUN pip3 install scikit-optimize
RUN pip3 install scikit-surprise

WORKDIR /home/jupyter

# Copy the notebook file into the container:
COPY full_model.ipynb .


EXPOSE 8888


#Create a jupyter notebook server listening on all available network interfaces and ips.
#Therefore, the notebook is accesible outside the container on the host machine, with the correct port binding and token.

ENTRYPOINT ["jupyter", "notebook", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]


