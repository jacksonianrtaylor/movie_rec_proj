# general docker for jupyter notebook
# https://www.youtube.com/watch?v=ajPppaAVXQU&ab_channel=MultiMindsInnovationLab
# https://www.youtube.com/watch?v=0qG_0CPQhpg&ab_channel=AbhishekThakur


#access running jupyter server with vscode:
#https://saturncloud.io/blog/how-to-use-vscode-ssh-remote-to-run-jupyter-notebooks/#:~:text=To%20do%20this%2C%20click%20on%20the%20Remote%20Explorer%20icon%20and,Window%E2%80%9D%20from%20the%20dropdown%20menu.
#https://saturncloud.io/blog/how-to-connect-vs-code-to-jupyter-server-with-a-password-instead-of-token/#:~:text=Connect%20VS%20Code%20to%20the,server's%20URL%20and%20port%20number.
#https://www.youtube.com/watch?v=-j6y-5t37os&ab_channel=devinschumacher
#https://www.youtube.com/watch?v=czlfsMZwCmU&ab_channel=MacPCZoneLondon
#https://devinschumacher.com/how-to-setup-jupyter-notebook-virtual-environment-vs-code-kernels/#install-jupyter


#^^^this has changed!!!!:
#https://github.com/microsoft/vscode-jupyter/discussions/13145
#https://code.visualstudio.com/docs/datascience/jupyter-kernel-management


#look!!!!
#docker for python files:
#can output results to a text file
#https://www.geeksforgeeks.org/how-to-run-a-python-script-using-docker/#
#https://stackoverflow.com/questions/48561981/activate-python-virtualenv-in-dockerfile


FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 \
    python3-pip

# not sure if this is aleady done...
# RUN pip3 install --upgrade pip


#note sure if these are necessary...
# RUN apt install -y sudo
# RUN sudo apt-get install -y python3-dev default-libmysqlclient-dev build-essential
# RUN sudo apt-get install -y pkg-config


WORKDIR /home/jupyter

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

#alternative to kaggle api (open od download):
#https://www.geeksforgeeks.org/how-to-download-kaggle-datasets-into-jupyter-notebook/

# this was used to install the same packages...
# but fails because it is machine dependent
# all used with requiremnts.txt
# RUN mkdir packages
# COPY requirements.txt ./packages
# RUN pip3 install --upgrade --force-reinstall -r ./packages/requirements.txt
# RUN pip3 install -r ./packages/requirements.txt

# is this necessary???
# not with root user!!!
# RUN useradd -ms /bin/bash jupyter
# USER jupyter


COPY complete_02_08_2023.ipynb .




#what does --ip=* mean???
#all ips point to the server


#cmd and entrypoint differences
#https://www.youtube.com/watch?v=C1GE07UEFDo&ab_channel=BretFisherDockerandDevOps
#https://www.youtube.com/watch?v=U1P7bqVM7xM&ab_channel=ManuelCastellin
#ENTRYPOINT vs CMD does not seem to make a difference here!!! but
#ENTRYPOINT makes more sense here since there are no options

#misc jupyter labs and ports:
#https://stackoverflow.com/questions/41159797/how-to-disable-password-request-for-a-jupyter-notebook-session
#https://supercomputing.swin.edu.au/rcdocs/jupyter-notebooks/#:~:text=When%20launching%20a%20jupyter%20notebook,8000%20of%20our%20local%20machine.&text=where%20the%20%2DL%20option%20specifies,connect%20i.e.%20creates%20a%20tunnel.
#https://saturncloud.io/blog/changing-jupyter-notebooks-default-localhost8888-server-with-other-options/


#why is 8888 th default port???
#other ports wont work unless default is changed with the method below...
#https://saturncloud.io/blog/how-to-change-the-default-port-for-ipython-notebook-server-jupyter/#:~:text=As%20mentioned%20earlier%2C%20Jupyter%20Notebook,also%20using%20the%20same%20port.


#make a public server...
#https://jupyter-notebook.readthedocs.io/en/5.7.5/public_server.html


#this is simply for documentation purposes
EXPOSE 8888


ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]


# note: The ip address in the entrypoint command is the address that the server will listen on
# listening: (waiting for a request)
# https://chat.openai.com/c/74842544-65fa-4bea-9240-23dfcb20b488
# https://dmitrijskass.netlify.app/2021/05/04/how-to-start-a-jupyter-notebook-on-the-remote-server/


# methods to connect to a jupyter server...
# https://dmitrijskass.netlify.app/2021/05/04/how-to-start-a-jupyter-notebook-on-the-remote-server/

#what does --hostname mean?
#https://chat.openai.com/c/082d87ff-ab45-4840-8fd0-d4b72a5ab20a

#--hostname: specifies the hostname that will be set relative to the container
#if the (--hostname set in the docker run command) is equal to the (--ip option in the jupyter notebook command)
#then the server is listening on the host machine
#in this case the --hostname also specifies the ip section of the first url in the container output 

#if the --hostname is present and the jupyter server is listening on all ips with "--ip=0.0.0.0" not "--ip=*"
#then the --hostname also specifies the ip section of the first url in the container output

#if --hostname is equal to localhost and there is no ip specified 
#then the server is listening on the host machine
#this is because the default --ip alias is localhost
#in this case the --hostname(localhost) also specifies the ip section of the first url in the container output

# this does not work becaue there is no ip "1.1.1.1" local to the the container
# ENTRYPOINT ["jupyter", "notebook", "--ip=1.1.1.1","--port=8888", "--no-browser", "--allow-root"]


#working...
#docker run -p 8888:8888 --hostname localhost image_1
#ENTRYPOINT ["jupyter", "notebook", "--ip=*","--port=8888", "--no-browser", "--allow-root"]
#ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0","--port=8888", "--no-browser", "--allow-root"]
#ENTRYPOINT ["jupyter", "notebook", "--ip=localhost","--port=8888", "--no-browser", "--allow-root"]
#127.0.0.1 is the default ip but its alias "localhost" is applied when the host name "localhost" is used
#ENTRYPOINT ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root"]

#problem with "--ip=*": anyone who knows your IP and the port you used in jupyter would be able to visit your jupyter notebook
#however, there is still a needed authentication token
#https://stackoverflow.com/questions/35345605/ipython-notebook-listening-on-all-ip-addresses


#difference between --ip=* and --ip=0.0.0.0:
#answer: chat gpt says none...
#https://chat.openai.com/c/7b81ae50-b098-4d94-a171-29434c125ae9
#then why do they give different urls???
#note --ip=* seems to always give the local host in the first url no matter the --hostname and
#--ip=0.0.0.0 always gives the --hostname in the url and if there is no hostname it creates a string
#why does this warning show up for --ip=* and not --ip=0.0.0.0: 
#WARNING: The Jupyter server is listening on all IP addresses and not using encryption. This is not recommended.


#not working:
#docker run -p 8888:8888 image_1
#ENTRYPOINT ["jupyter", "notebook", "--ip=localhost","--port=8888", "--no-browser", "--allow-root"]
#ENTRYPOINT ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root"]
#note: others above are working...

#not working:
#https://stackoverflow.com/questions/59179831/docker-app-server-ip-address-127-0-0-1-difference-of-0-0-0-0-ip
#In Docker, 127.0.0.1 almost always means the local host of “this container”, not “the host machine”.
#docker run -p 8888:8888 --hostname localhost image_1
#ENTRYPOINT ["jupyter", "notebook", "--ip=127.0.0.1", "--no-browser", "--allow-root"]

#not working:
#note: config file must be changed to allow use of different ports for jupyter
#ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--no-browser", "--allow-root", "--port", "9999"]

#get the ip of the docker host from inside the docker container
#https://stackoverflow.com/questions/22944631/how-to-get-the-ip-address-of-the-docker-host-from-inside-a-docker-container
#https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach
#--network="host" can be used in the docker run command, (then --ip=127.0.0.1 will point to the docker host)
#this only works on docker for linux!!!

#some docker compose
#https://www.youtube.com/watch?v=UXxUcZDSNwA&ab_channel=KathrynSchuler

#how do docker ip addresses work!!!
#https://linuxhandbook.com/get-container-ip/#:~:text=If%20you%20run%20the%20inspect,That's%20your%20container's%20IP%20address.

