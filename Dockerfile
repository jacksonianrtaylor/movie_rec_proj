
#most up to date 3.10 python
FROM python:3.10-bullseye

#important step before downloading packages
RUN pip install --upgrade pip

# the root directory is the working directory
# WORKDIR /handle_data


#get get and install the appopriate packages in requiremnts.txt
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .


ADD https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset/download?datasetVersionNumber=7 /test_dir
#after this there should be a way to move the contents of the file



#dont need to run this, the jupyter notebook should be run manually instead
# CMD [ "python", "handle_data.py" ]


