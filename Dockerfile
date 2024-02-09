# Use the official Alpine Linux as a parent image
# FROM python:3.9.13-alpine
FROM continuumio/miniconda3:latest

ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Pull the environment name out of the environment.yml
ENV PATH /opt/conda/envs/ts_snowflake_python/bin:$PATH
RUN /bin/bash -c "source activate ts_snowflake_python"

# RUN apk --no-cache add build-base
# RUN apk update && apk add --no-cache cython
# RUN apk add make automake gcc g++ subversion python3-dev

# Set the working directory inside the container
WORKDIR /app

# Copy the contents of the local "src" directory to the working directory in the container
COPY src/ /app/

# Install any needed packages specified in requirements.txt
# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt

# Define the command to run your Python script
CMD ["python", "snowflake_test.py"]
