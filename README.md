# ExpenseWise

ExpenseWise is a Django app to track expenses and income, with category prediction and forecasting.

## Features

- Expense and income tracking
- Category prediction using ML
- Expense forecasting
- User authentication
- Instant account creation (no email activation step)

## Local setup (Windows)

```bash
py -3.11 -m venv .venv
.\.venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python nltk_downloader.py
python manage.py migrate
python manage.py runserver
```

Open: http://127.0.0.1:8000/

## Local setup (macOS/Linux)

`requirements.txt` in this repo is UTF-16, so convert before installing:

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -c "import pathlib; p=pathlib.Path('requirements.txt'); pathlib.Path('requirements.utf8.txt').write_text(p.read_text(encoding='utf-16'), encoding='utf-8')"
pip install -r requirements.utf8.txt
python nltk_downloader.py
python manage.py migrate
python manage.py runserver
```

## Deploy to Render (no Docker, no YAML)

Create a **Web Service** in Render from this repo.

This repo includes:
- `.python-version` (pins Python 3.11)
- `requirements.render.txt` (clean dependency list for Render)
- `render-build.sh` and `render-start.sh`

Use these commands in Render:

### Build Command

```bash
bash render-build.sh
```

### Start Command

```bash
bash render-start.sh
```

### Environment variables on Render

Set these in Render dashboard:

- `DJANGO_DEBUG=1`
- `DJANGO_SECRET_KEY=<any long random string>`
- `DJANGO_ALLOWED_HOSTS=<your-service>.onrender.com`
- `DJANGO_CSRF_TRUSTED_ORIGINS=https://<your-service>.onrender.com`

Optional SMTP (only if you want outbound email features like alerts):

- `DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend`
- `DJANGO_EMAIL_HOST=smtp.gmail.com`
- `DJANGO_EMAIL_PORT=587`
- `DJANGO_EMAIL_USE_TLS=1`
- `DJANGO_EMAIL_HOST_USER=<your-email>`
- `DJANGO_EMAIL_HOST_PASSWORD=<your-app-password>`
- `DJANGO_DEFAULT_FROM_EMAIL=<your-email>`

### Keep DB data between deploys (recommended)

Attach a Render disk and set:

- `DJANGO_DB_PATH=/var/data/mydatabase`

Without a disk, SQLite data can be lost on redeploy/restart.

## Useful commands

Create admin user:

```bash
python manage.py createsuperuser
```

Reset all data:

```bash
python manage.py flush
```
