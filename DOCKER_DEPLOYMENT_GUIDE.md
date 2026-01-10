# Docker Deployment Fix for Render

## Overview
Your Django project has been configured to correctly deploy on Render using Docker. The following changes have been made:

## Changes Made

### 1. **Root-Level Dockerfile** (`/Dockerfile`)
- Moved from `core/Dockerfile` to project root
- Correctly handles the directory structure where Django project is in `core/`
- Uses Python 3.12-slim for smaller image size
- Includes all necessary system dependencies (PostgreSQL, PIL, etc.)
- Collects static files with `--clear` flag
- Runs Daphne ASGI server for WebSocket support

### 2. **.dockerignore** (`/.dockerignore`)
- Excludes unnecessary files from Docker build context
- Reduces image size and build time
- Excludes: virtual environments, cache files, git, node_modules, etc.

### 3. **Updated render.yaml** (`/render.yaml`)
- Configured for Docker deployment (`env: docker`)
- Added `buildCommand` for database migrations
- Properly sets environment variables (DEBUG=False)
- Specifies Python 3.12 runtime
- Configured for Singapore region and standard plan

### 4. **Enhanced Django Settings** (`core/core/settings.py`)
- Changed `ALLOWED_HOSTS` from wildcard to specific hosts
- Made hosts configurable via `ALLOWED_HOSTS` environment variable
- Added production security headers (HSTS, secure cookies, CSP)
- Security headers only apply when `DEBUG=False` (production)

## Required Environment Variables on Render

Add these in your Render dashboard under **Environment**:

```
DEBUG=False
SECRET_KEY=your-secret-key-here
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
CLOUDINARY_URL=cloudinary://...
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
RECAPTCHA_SITE_KEY=your-site-key
RECAPTCHA_SECRET_KEY=your-secret-key
ALLOWED_HOSTS=localhost,127.0.0.1,your-render-domain.onrender.com
CSRF_TRUSTED_ORIGINS=https://your-render-domain.onrender.com
```

## Deployment Steps

1. **Push your changes to GitHub:**
   ```bash
   git add .
   git commit -m "Fix Docker deployment for Render"
   git push origin master
   ```

2. **On Render Dashboard:**
   - Delete or update existing service
   - Create new "Web Service"
   - Connect your GitHub repository
   - Select branch (master/main)
   - Build command: Leave empty (using Dockerfile)
   - Start command: Leave empty (using Dockerfile CMD)
   - Add environment variables from list above
   - Deploy

3. **Database Migration:**
   - First deployment will run migrations via `buildCommand`
   - Check logs in Render dashboard for any migration errors

## Important Notes

- **WebSocket Support**: Using Daphne ASGI server for `channels` support
- **Static Files**: WhiteNoise middleware serves static files in production
- **Media Files**: Using Cloudinary for media uploads
- **Database**: PostgreSQL with SSL required (`ssl_require=True`)
- **Redis**: Required for Channels layer communication

## Troubleshooting

### If migrations fail:
- Check `DATABASE_URL` is correct
- Ensure database is accessible
- Check logs on Render dashboard

### If static files not loading:
- Verify `STATIC_URL` and `STATIC_ROOT` are correct
- Verify WhiteNoise middleware position (must be after SecurityMiddleware)
- Check `STATICFILES_STORAGE` configuration

### If WebSockets not working:
- Verify `REDIS_URL` is set and accessible
- Check `CHANNEL_LAYERS` configuration in settings
- Verify Daphne is running (check logs)

### If assets missing:
- Ensure `CLOUDINARY_URL` is set
- Verify Cloudinary storage settings
- Check `DEFAULT_FILE_STORAGE` configuration

## Architecture

```
Project Root
├── Dockerfile (NEW - at root level)
├── .dockerignore (NEW)
├── render.yaml (UPDATED)
├── requirements.txt
├── core/
│   ├── manage.py
│   ├── core/
│   │   ├── settings.py (UPDATED)
│   │   ├── asgi.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── chat/
│   ├── products/
│   ├── manage_business/
│   ├── shops/
│   └── ...
└── ...
```

## Files to Delete (optional cleanup)

You can safely delete:
- `core/Dockerfile` - superseded by root-level Dockerfile
- `core/render.yaml` - superseded by root-level render.yaml

These are no longer needed and may cause confusion.
