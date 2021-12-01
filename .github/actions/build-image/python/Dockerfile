FROM python:3.9-slim
RUN mkdir -p /home/acuity && addgroup acuity && useradd -d /home/acuity -g acuity acuity && chown acuity:acuity /home/acuity
RUN apt-get update && apt-get install -y curl
USER acuity
WORKDIR /home/acuity
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
ENV PATH=/home/acuity/.poetry/bin:$PATH
RUN poetry config virtualenvs.in-project true