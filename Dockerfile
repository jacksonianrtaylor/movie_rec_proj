# Use a base image with a Linux distribution
FROM ubuntu:latest

# Install necessary packages (e.g., curl) if needed
RUN apt-get update && apt-get install -y curl

# Create a directory to save the downloaded file
RUN mkdir /downloaded-filess

# Set the working directory
WORKDIR /downloaded-files

# Download the file from the internet and save it in the current directory
# this is an actual file that exists and works

#there is no file at the end of this url
#maybe an api call will suffice:

#kaggle datasets download -d rounakbanik/the-movies-dataset
RUN curl -O https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset/download?datasetVersionNumber=7

# Optionally, you can set environment variables or configure other settings here

# Expose the directory as a volume (optional, for easy access to the downloaded file)


# The volume in question is generated with a default volume name making it hard to access
# what if the name was extracted somehow????
# if this is run with multiple arguments then multple volumns will be made
# how do we transfer the data to the host machine

VOLUME /downloaded-files
# VOLUME /downloaded-files /something-else
# VOLUME ["/downloaded-files", "/something-else"]


#this is where docker volumes are located (host)
#\\wsl$\docker-desktop-data\data\docker\volumes




# this creates a new container with the volume in the directory /app
# docker run -d \
#   --name devtest \
#   --mount source=myvol2,target=/app \
#   nginx:latest

#is there a way to do this with an existing image instea of creatinga contain on the fly???










#to test...
# FROM python:3.10-bullseye
# FROM ubuntu:latest
# RUN  apt-get update \
#   && apt-get install -y wget \
#   && rm -rf /var/lib/apt/lists/*
# RUN wget https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset/download?datasetVersionNumber=7
# RUN mv download?datasetVersionNumber=7 /download_dir
# WORKDIR /downloaded-files


# my dockerfile
# FROM python:3.10-bullseye
# #important step before downloading packages
# RUN pip install --upgrade pip
# # the image_dir directory is the working directory
# WORKDIR /image_dir
# #get get and install the appopriate packages in requiremnts.txt
# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# ADD https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset/download?datasetVersionNumber=7 /test_dir
# #after this there should be a way to move the contents of the file
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
