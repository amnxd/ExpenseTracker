#!/usr/bin/env bash
set -e

PYTHON_BIN="${PYTHON_BIN:-python}"
if [ -x ".venv/bin/python" ]; then
	PYTHON_BIN=".venv/bin/python"
elif [ -x ".venv/Scripts/python" ]; then
	PYTHON_BIN=".venv/Scripts/python"
fi

PORT="${PORT:-8000}"

"$PYTHON_BIN" manage.py migrate --noinput
exec "$PYTHON_BIN" manage.py runserver 0.0.0.0:${PORT}
