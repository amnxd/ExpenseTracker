#!/usr/bin/env bash
set -e

python -m pip install --upgrade pip
pip install -r requirements.render.txt

python - <<'PY'
import nltk
for pkg in ('stopwords', 'punkt', 'punkt_tab'):
    nltk.download(pkg)
PY

python manage.py collectstatic --noinput
