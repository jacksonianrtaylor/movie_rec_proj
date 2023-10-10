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

WORKDIR /home/jupyter

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
#https://dmitrijskass.netlify.app/2021/05/04/how-to-start-a-jupyter-notebook-on-the-remote-server/
#https://saturncloud.io/blog/changing-jupyter-notebooks-default-localhost8888-server-with-other-options/


#why is 8888 th default port???
#other ports wont work unless default is changed with the method below...
#https://saturncloud.io/blog/how-to-change-the-default-port-for-ipython-notebook-server-jupyter/#:~:text=As%20mentioned%20earlier%2C%20Jupyter%20Notebook,also%20using%20the%20same%20port.


#make a public server...
#https://jupyter-notebook.readthedocs.io/en/5.7.5/public_server.html


#note, pair with: docker run -p 8888:8888 --hostname localhost image_1
ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--allow-root"]

#working
#ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--no-browser", "--allow-root"]
#ENTRYPOINT ["jupyter", "notebook",  "--no-browser", "--allow-root"]
#ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]


#not working:
#ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--no-browser", "--allow-root", "--port", "9999"]

#general docker information
#some docker compose
#https://www.youtube.com/watch?v=UXxUcZDSNwA&ab_channel=KathrynSchuler

