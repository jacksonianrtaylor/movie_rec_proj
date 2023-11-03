FROM ubuntu:latest


# Note: An older version of python is specified to mitigate the chance that a newer verison of python runs into an issue with the notebook code.
# Python 3.10.7 worked on personal machine
RUN apt-get update && apt-get install -y python3.10 \
    python3-pip



# Install all packages:
RUN pip3 install opendatasets
RUN pip3 install pandas
RUN pip3 install numpy
RUN pip3 install scikit-learn
RUN pip3 install scipy
RUN pip3 install ordered-set
RUN pip3 install gensim
RUN pip3 install nltk
RUN pip3 install jupyter


WORKDIR /home/jupyter

# Copy the notebook file into the container:
COPY complete_11_03_2023.ipynb .


EXPOSE 8888


#Create a jupyter notebook server listening on all available network interfaces and ips.
#Therefore, the notebook is accesible outside the container on the host machine, with the correct port binding and token.

ENTRYPOINT ["jupyter", "notebook", "--ip", "*", "--port", "8888", "--no-browser", "--allow-root"]


