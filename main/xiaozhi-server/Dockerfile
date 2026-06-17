FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    TZ=UTC

WORKDIR /opt/xiaozhi-esp32-server

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        ffmpeg \
        git \
        libgomp1 \
        libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

COPY . .

EXPOSE 8000 8003

VOLUME ["/opt/xiaozhi-esp32-server/data", "/opt/xiaozhi-esp32-server/models"]

CMD ["python", "app.py"]
