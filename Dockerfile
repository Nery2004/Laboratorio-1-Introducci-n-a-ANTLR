FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        python3 \
        python3-pip \
        python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# El generador y el runtime usan la misma versión de ANTLR.
COPY antlr-4.13.2-complete.jar /usr/local/lib/antlr-4.13.2-complete.jar
COPY commands/antlr commands/grun /usr/local/bin/
RUN chmod +x /usr/local/bin/antlr /usr/local/bin/grun

COPY python-venv.sh requirements.txt /tmp/lab-1/
RUN VENV_PATH=/opt/venv /tmp/lab-1/python-venv.sh \
    python -m pip install --no-cache-dir -r /tmp/lab-1/requirements.txt

ENV PATH="/opt/venv/bin:${PATH}"
WORKDIR /program

CMD ["bash"]
