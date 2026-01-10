FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

# Copy entire project
COPY . .

# Collect static files and run migrations
WORKDIR /app/core
RUN python manage.py collectstatic --noinput --clear
RUN python manage.py migrate --noinput || true

# Expose port
EXPOSE 8000

# Run Daphne ASGI server
CMD daphne -b 0.0.0.0 -p ${PORT:-8000} core.asgi:application
