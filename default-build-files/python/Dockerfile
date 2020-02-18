FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN mkdir -p ~/python-app
ADD /app-folder /python-app
WORKDIR /python-app
ENTRYPOINT ["sh", "-c"]
CMD ["python backend.py"]