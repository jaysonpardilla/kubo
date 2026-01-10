#!/bin/bash
# Local development startup script with Docker

echo "Building Docker image..."
docker build -t ekubo-app .

echo "Starting container..."
docker run -it \
  --env-file .env \
  -p 8000:8000 \
  -v $(pwd)/core:/app/core \
  ekubo-app

echo "Container stopped."
