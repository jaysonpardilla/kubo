FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

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

# Run migrations and collect static files
RUN cd core && python manage.py migrate --noinput 2>/dev/null || true
RUN cd core && python manage.py collectstatic --noinput --clear

EXPOSE 8000

# Start the application
CMD ["sh", "-c", "cd core && daphne -b 0.0.0.0 -p $PORT core.asgi:application"]
