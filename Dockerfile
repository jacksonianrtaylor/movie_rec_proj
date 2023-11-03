FROM ubuntu:latest


#note: need to specify verison of python in case a newer versio of python comes that breaks
RUN apt-get update && apt-get install -y python3 \
    python3-pip


# WORKDIR /home/jupyter

#install all packages
RUN pip3 install opendatasets
RUN pip3 install pandas
RUN pip3 install numpy
RUN pip3 install scikit-learn
RUN pip3 install scipy
RUN pip3 install ordered-set
RUN pip3 install gensim
RUN pip3 install nltk
RUN pip3 install jupyter



#LOOK: there is slight variation in results between running on ubuntu and windows but it is very accurat to a certaun decimal
WORKDIR /home/jupyter

COPY complete_02_08_2023.ipynb .

ENTRYPOINT ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root"]


