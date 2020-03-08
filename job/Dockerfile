FROM python:3.8

WORKDIR /srv/job

ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt

ADD job.py job.py

CMD ["python", "-u", "./job.py"]
