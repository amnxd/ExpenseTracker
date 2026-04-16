#!/usr/bin/env bash
set -e

PYTHON_BIN="${PYTHON_BIN:-python}"
if [ -x ".venv/bin/python" ]; then
    PYTHON_BIN=".venv/bin/python"
elif [ -x ".venv/Scripts/python" ]; then
    PYTHON_BIN=".venv/Scripts/python"
fi

"$PYTHON_BIN" -m pip install --upgrade pip
"$PYTHON_BIN" -m pip install -r requirements.render.txt

"$PYTHON_BIN" - <<'PY'
import nltk
for pkg in ('stopwords', 'punkt', 'punkt_tab'):
    nltk.download(pkg)
PY

"$PYTHON_BIN" manage.py collectstatic --noinput
