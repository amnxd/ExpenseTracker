# ExpenseWise (Personal Expense Tracker)

![Expense Tracker UI](https://github.com/hemantshirsath/Expensetracker/assets/102463335/f31d97f4-4841-44cb-b2af-62286c60a0c9)
![Forecast UI](https://github.com/hemantshirsath/Expensetracker/assets/102463335/c1188567-39c5-4cc1-8916-24f3d3712ee8)

![Forecast UI 2](https://github.com/hemantshirsath/Expensetracker/assets/102463335/a2088949-c4f6-4d18-ba23-308ce3ad19f4)
![Report UI](https://github.com/hemantshirsath/Expensetracker/assets/102463335/c3271340-d3ea-4171-9618-04c8c0a98759)

## Overview

ExpenseWise is a Django web app to track expenses and income, categorize spending, and generate basic statistics and forecasts.

## Features

- Expense logging (date/amount/category/description)
- Income tracking
- Automated expense categorization (ML)
- Forecasting (ARIMA-based)
- User authentication + email activation

## Tech stack

- Django + Django REST Framework
- SQLite (default)
- scikit-learn + NLTK (categorization)
- statsmodels (forecast)
- Docker + Caddy (production-style deployment)

## Local development

### Prerequisites

- Python **3.11** recommended (best wheel support for `pandas`, `scipy`, `scikit-learn`)
- pip

> Note: `requirements.txt` in this repo is **UTF-16**. On Windows this usually installs fine. On Linux/macOS, use Docker (recommended) or convert it to UTF-8 before installing.

### Windows (recommended)

```bash
py -3.11 -m venv .venv
.\.venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python nltk_downloader.py
python manage.py migrate
python manage.py runserver
```

Open http://127.0.0.1:8000/

### macOS / Linux

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip

# Convert requirements to UTF-8 (because requirements.txt is UTF-16)
python - <<'PY'
import pathlib
p = pathlib.Path('requirements.txt')
pathlib.Path('requirements.utf8.txt').write_text(p.read_text(encoding='utf-16'), encoding='utf-8')
PY

pip install -r requirements.utf8.txt
python nltk_downloader.py
python manage.py migrate
python manage.py runserver
```

### Admin user

```bash
python manage.py createsuperuser
```

### Reset database (delete all accounts/data)

```bash
python manage.py flush
```

## Email activation (registration)

Registration creates a user with `is_active=False` and sends an activation link.

- In **DEBUG mode**, the default email backend is the **console backend**, so the email content + activation link will print in the server logs.
- To send real emails, set SMTP environment variables (don’t hardcode secrets in code):

```bash
DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
DJANGO_EMAIL_HOST=smtp.gmail.com
DJANGO_EMAIL_PORT=587
DJANGO_EMAIL_USE_TLS=1
DJANGO_EMAIL_HOST_USER=your-email@gmail.com
DJANGO_EMAIL_HOST_PASSWORD=your-app-password
DJANGO_DEFAULT_FROM_EMAIL=your-email@gmail.com
```

## API endpoints

- `POST /api/predict-category/` — body: `{ "description": "..." }` (authenticated)
- `POST /api/update-dataset/` — body: `{ "new_data": { "description": "...", "category": "..." } }`

## Configuration (environment variables)

The app is configured for local + production via environment variables:

- `DJANGO_SECRET_KEY` — required for production
- `DJANGO_DEBUG` — `1` or `0`
- `DJANGO_ALLOWED_HOSTS` — comma-separated hosts (e.g. `example.com,1.2.3.4`)
- `DJANGO_CSRF_TRUSTED_ORIGINS` — comma-separated origins (e.g. `https://example.com`)
- `DJANGO_DB_PATH` — path to SQLite file (default: `mydatabase` in the project root)

Email:
- `DJANGO_EMAIL_BACKEND`, `DJANGO_EMAIL_HOST`, `DJANGO_EMAIL_PORT`, `DJANGO_EMAIL_USE_TLS`
- `DJANGO_EMAIL_HOST_USER`, `DJANGO_EMAIL_HOST_PASSWORD`, `DJANGO_DEFAULT_FROM_EMAIL`

Optional:
- `CELERY_BROKER_URL`, `CELERY_RESULT_BACKEND`
- `GUNICORN_WORKERS`, `GUNICORN_THREADS`, `GUNICORN_TIMEOUT`

## Deployment (VPS + Docker)

This repo includes a Docker-based setup suitable for a VPS.

### 1) On your VPS

- Install Docker + Compose
- Clone this repo onto the server

### 2) Create `.env` on the VPS

Example:

```env
DJANGO_DEBUG=0
DJANGO_SECRET_KEY=replace-with-a-long-random-string
DJANGO_ALLOWED_HOSTS=your-domain.com,your-vps-ip
DJANGO_CSRF_TRUSTED_ORIGINS=https://your-domain.com
DOMAIN=your-domain.com
```

### 3) Start

```bash
docker compose up -d --build
```

### 4) Create admin

```bash
docker compose exec web python manage.py createsuperuser
```

### Notes

- SQLite is stored in a Docker volume (`/data/db.sqlite3`) so it persists between restarts.
- Static files are collected automatically on container start and served by Caddy.

## FAQ (basic questions)

**Q: Where is my data stored?**

A: By default, SQLite is stored in a file named `mydatabase` in the project root. In Docker it’s stored at `/data/db.sqlite3` inside a persistent volume.

**Q: I registered but didn’t receive an activation email. Why?**

A: In `DJANGO_DEBUG=1`, emails print to the server console by default. In production, set SMTP env vars and ensure your provider allows SMTP (use app passwords where required).

**Q: What Python version should I use?**

A: Use Python 3.11 for the smoothest installs (scientific packages are much more likely to have prebuilt wheels).

**Q: How do I delete all accounts and start fresh?**

A: Run `python manage.py flush`.

**Q: Does this require Redis/Celery?**

A: Not for the core web app. Redis/Celery are only needed if you enable background/scheduled tasks.
