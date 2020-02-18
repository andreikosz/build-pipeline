FROM python:alpine3.7
RUN mkdir -p ~/python-app
RUN sudo su && yes | apt-get install python-pip && pip install flask
ADD /app-folder /python-app
WORKDIR /python-app
ENTRYPOINT ["sh", "-c"]
CMD ["python backend.py"]