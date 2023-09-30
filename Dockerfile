# https://www.youtube.com/watch?v=ajPppaAVXQU&ab_channel=MultiMindsInnovationLab
# https://www.youtube.com/watch?v=0qG_0CPQhpg&ab_channel=AbhishekThakur
#see entrypoint...for vscode


FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 \
    python3-pip

RUN pip3 install jupyter


RUN useradd -ms /bin/bash jupyter

USER jupyter


WORKDIR /home/jupyter

#need to copy the jupyter notebook from the host
COPY complete_02_08_2023.ipynb .

ENTRYPOINT ["jupyter", "notebook", "--ip=*"]

#solutions:
#how to copy files from host to container
#https://stackoverflow.com/questions/30455036/how-to-copy-file-from-host-to-container-using-dockerfile


#might solve the issue of the reuse of predefined jupyter notebook:
#https://www.youtube.com/watch?v=UXxUcZDSNwA&ab_channel=KathrynSchuler
#docker compose???


#https://stackoverflow.com/questions/72121390/how-to-use-jupyterlab-in-visual-studio-code
#steps to connect to a jupyter server in vs code




#installations:
#need to install python...
#need to install jupyter labs inside the container...


#questions:
#Are jupyter files in the same directory where the docker image is run acessible to the container???
#are all files in the same directory where the docker image is run acessible to the container???


#steps:

#make a docker container

#need to make an api request from the kaggle movie data set and have the data sit in this container
#until it is used by the jupyetr lab file

#need to copy the completed jupyter lab file from outside to inside the container (not sure if necessary)
#copy the requirements.txt from outside to inside the container

#need to create a new virtual env inside the container for the jupyter lab with the packages from insde the requyirements.txt
#need to run make the jupyter lab file acessable so it can be run (not sure if necessary)



#potential problem:
#(if the maximum space is reached then need to figure out how to get more space)






