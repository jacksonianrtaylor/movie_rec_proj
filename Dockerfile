
#most up to date 3.10 python
FROM python:3.10-bullseye

#important step before downloading packages
RUN pip install --upgrade pip

# the image_dir directory is the working directory
WORKDIR /image_dir


#get get and install the appopriate packages in requiremnts.txt
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .


ADD https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset/download?datasetVersionNumber=7 /test_dir
#after this there should be a way to move the contents of the file



#dont need to run this, the jupyter notebook should be run manually instead
# CMD [ "python", "handle_data.py" ]


# (simple method)
# FROM python:3.9-slim-bullseye

# RUN python3 -m venv /opt/venv

# # Install dependencies:
# COPY requirements.txt .
# RUN . /opt/venv/bin/activate && pip install -r requirements.txt


# don't need to run an application...
# just need to connect to the virtual env manually when running the jupyter notebook
# # Run the application:
# COPY myapp.py .
# CMD . /opt/venv/bin/activate && exec python myapp.py



# (know what everything does...)
# FROM python:3.9-slim-bullseye

# ENV VIRTUAL_ENV=/opt/venv
# RUN python3 -m venv $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# # Install dependencies:
# COPY requirements.txt .
# RUN pip install -r requirements.txt


# don't need to run an application...
# just need to connect to the virtual env manually when running the jupyter notebook
# Run the application:
# COPY myapp.py .
# CMD ["python", "myapp.py"]
