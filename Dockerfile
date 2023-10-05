# general docker for jupyter labs
# https://www.youtube.com/watch?v=ajPppaAVXQU&ab_channel=MultiMindsInnovationLab
# https://www.youtube.com/watch?v=0qG_0CPQhpg&ab_channel=AbhishekThakur


FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 \
    python3-pip

# not sure if this is aleady done...
# RUN pip3 install --upgrade pip




RUN apt install -y sudo
RUN sudo apt-get install -y python3-dev default-libmysqlclient-dev build-essential
RUN sudo apt-get install -y pkg-config

# this is providing problems
# RUN pip3 install mysqlclient

#realted issues:
#https://www.youtube.com/watch?v=DkjfV4jmZWs&ab_channel=PeterSchneider
#https://stackoverflow.com/questions/76585758/mysqlclient-cannot-install-via-pip-cannot-find-pkg-config-name



#to use kaggle api:
# RUN pip3 install kaggle
# RUN kaggle datasets download -d rounakbanik/the-movies-dataset
#https://www.google.com/search?q=how+to+download+file+from+a+kaggle+data+set&rlz=1C1ONGR_enUS1021US1021&oq=how+to+download+file+from+a+kaggle+data+set&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIJCAEQIRgKGKABMgkIAhAhGAoYoAEyCQgDECEYChigATIHCAQQIRirAjIHCAUQIRiPAjIHCAYQIRiPAtIBCTIyNDM3ajBqN6gCALACAA&sourceid=chrome&ie=UTF-8
#https://www.youtube.com/watch?v=W86uvkzaqLg&ab_channel=JonathanPerry
#need to have credentials


#alternative (open od download):
#https://www.geeksforgeeks.org/how-to-download-kaggle-datasets-into-jupyter-notebook/


RUN mkdir packages

COPY requirements.txt ./packages

RUN pip3 install --upgrade --force-reinstall -r ./packages/requirements.txt
#RUN pip3 install -r ./packages/requirements.txt

RUN useradd -ms /bin/bash jupyter
USER jupyter
WORKDIR /home/jupyter

#need to copy the jupyter notebook from the host
COPY complete_02_08_2023.ipynb .

ENTRYPOINT ["jupyter", "notebook", "--ip=*"]

#how to to migrate packages between systems (windows to ubuntu)
#python environments solution...
#https://stackoverflow.com/questions/34684281/the-same-list-of-python-libraries-for-ubuntu-and-windows




#solutions:
#how to copy files from host to container
#https://stackoverflow.com/questions/30455036/how-to-copy-file-from-host-to-container-using-dockerfile


#might solve the issue of the reuse of predefined jupyter notebook:
#https://www.youtube.com/watch?v=UXxUcZDSNwA&ab_channel=KathrynSchuler
#docker compose???

#https://stackoverflow.com/questions/72121390/how-to-use-jupyterlab-in-visual-studio-code
#https://www.google.com/search?q=acess+a+local+jupyter+server+vscode&sca_esv=569640401&rlz=1C1ONGR_enUS1021US1021&sxsrf=AM9HkKmGSVWUP-lP2zOMSTCsROy5_wLeZA%3A1696043985794&ei=0ZMXZbaPMLiT0PEPuvmMuAo&ved=0ahUKEwj2u6-asNGBAxW4CTQIHbo8A6cQ4dUDCBE&uact=5&oq=acess+a+local+jupyter+server+vscode&gs_lp=Egxnd3Mtd2l6LXNlcnAiI2FjZXNzIGEgbG9jYWwganVweXRlciBzZXJ2ZXIgdnNjb2RlMgoQIRigARjDBBgKMgoQIRigARjDBBgKSLQRUMcEWPAOcAJ4AZABAJgBgAGgAZAHqgEDNC41uAEDyAEA-AEBwgIKEAAYRxjWBBiwA-IDBBgAIEGIBgGQBgg&sclient=gws-wiz-serp
#steps to connect to a jupyter server in vs code



#potential problem:
#(if the maximum space is reached then need to figure out how to get more space)






