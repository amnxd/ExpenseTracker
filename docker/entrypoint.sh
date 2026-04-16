#!/usr/bin/env sh
set -eu

# Safety checks for production-like runs
if [ "${DJANGO_DEBUG:-1}" = "0" ] || [ "${DJANGO_DEBUG:-1}" = "false" ]; then
  if [ -z "${DJANGO_ALLOWED_HOSTS:-}" ]; then
    echo "DJANGO_ALLOWED_HOSTS is required when DJANGO_DEBUG=0" >&2
    exit 1
  fi
fi

python manage.py migrate --noinput
python manage.py collectstatic --noinput

exec gunicorn expensetracker.wsgi:application \
  --bind "0.0.0.0:${PORT:-8000}" \
  --workers "${GUNICORN_WORKERS:-3}" \
  --threads "${GUNICORN_THREADS:-1}" \
  --timeout "${GUNICORN_TIMEOUT:-120}" \
  --access-logfile "-" \
  --error-logfile "-"
