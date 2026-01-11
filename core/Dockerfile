FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    postgresql-client \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
# Prefer binary wheels to avoid compiling packages like scikit-learn from source
RUN pip install --prefer-binary -r requirements.txt

# Copy entire project
COPY . .

# Run migrations and collect static files from the core subdirectory
RUN cd /app/core && python manage.py migrate --noinput 2>/dev/null || true
RUN cd /app/core && python manage.py collectstatic --noinput --clear

EXPOSE 10000

# Run daphne from /app/core where manage.py is located
CMD ["sh", "-c", "cd /app/core && daphne -b 0.0.0.0 -p $PORT core.asgi:application"]
