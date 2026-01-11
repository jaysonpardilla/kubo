FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV PYTHONPATH=/app/core
ENV DJANGO_SETTINGS_MODULE=core.settings

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Copy entire project
COPY . .

# Change to core directory for remaining setup
WORKDIR /app/core

# Run migrations and collect static files
RUN python manage.py migrate --noinput 2>/dev/null || true
RUN python manage.py collectstatic --noinput --clear

EXPOSE 8000

# Start the application
CMD ["daphne", "-b", "0.0.0.0", "-p", "8000", "core.asgi:application"]
