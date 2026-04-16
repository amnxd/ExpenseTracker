FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    NLTK_DATA=/usr/local/share/nltk_data

WORKDIR /app

# System dependencies (kept minimal; helps if any wheel needs compilation)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        default-libmysqlclient-dev \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt

# requirements.txt is UTF-16 in this repo; convert for Linux/pip.
RUN python - <<'PY'
import pathlib
p = pathlib.Path('requirements.txt')
text = p.read_text(encoding='utf-16')
pathlib.Path('requirements.utf8.txt').write_text(text, encoding='utf-8')
PY

RUN pip install --upgrade pip \
    && pip install -r requirements.utf8.txt \
  && pip install gunicorn whitenoise

# Pre-download NLTK corpora used by the app.
RUN python - <<'PY'
import os
import nltk

d = os.environ.get('NLTK_DATA')
for pkg in ('stopwords', 'punkt', 'punkt_tab'):
    nltk.download(pkg, download_dir=d)
PY

COPY . /app

RUN chmod +x /app/docker/entrypoint.sh \
    && adduser --disabled-password --gecos "" appuser \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

ENTRYPOINT ["/app/docker/entrypoint.sh"]
