ARG PYTHON_VERSION=2.7
ARG SSH_DIND="ssh-dind:latest"
FROM ${SSH_DIND} as sshdind

FROM python:${PYTHON_VERSION}

RUN mkdir /src
WORKDIR /src

COPY requirements.txt /src/requirements.txt
RUN pip install -r requirements.txt

COPY test-requirements.txt /src/test-requirements.txt
RUN pip install -r test-requirements.txt

COPY . /src
RUN pip install .

# install SSHD
RUN apt-get install -y openssh-client

# Add the keys and set permissions
COPY --from=sshdind /root/.ssh /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub
