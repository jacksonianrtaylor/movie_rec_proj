
#most upto date python
FROM python:3.10-bullseye

#important step before downloading packages
RUN pip install --upgrade pip

# the root directory is the working directory
# WORKDIR /handle_data

#not sure exactlyr what this does???
COPY requirements.txt ./

#install from the 
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "handle_data.py" ]