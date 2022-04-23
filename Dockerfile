FROM python:3.9-slim as base

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
ENV PATH="/venv/bin:$PATH"


# weirdly, this is need in both the worker and the base image
# hadolint ignore=DL3008
RUN apt-get update --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*

# Setup the virtualenv
RUN python -m venv /venv

# install dependencies
COPY requirements.txt /app/requirements.txt
# Install Python deps
RUN pip install --no-cache-dir -r requirements.txt


# ---- Worker ----
FROM python:3.9-slim AS worker
# Extra python env
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
ENV PATH="/venv/bin:$PATH"

# weirdly, this is need in both the worker and the base image
# hadolint ignore=DL3008
RUN apt-get update --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*


COPY . /app/
# copy in Python environment
COPY --from=base /venv /venv

# copy project
COPY . .

# add non-priviledged user
RUN adduser --uid 1000 --disabled-password --gecos '' --no-create-home webdev
