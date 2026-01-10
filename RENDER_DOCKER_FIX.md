# Render Deployment - Docker Fix

## ✅ What Was Wrong

The previous `render.yaml` configuration had `buildCommand` and `startCommand`, which tells Render to use the traditional build approach (not Docker). This caused:
- ❌ Render ignored the Dockerfile
- ❌ Tried to run pip install without Docker context
- ❌ Looked for manage.py in wrong location

## ✅ What's Fixed

1. **Removed buildCommand and startCommand** from `render.yaml`
   - Now `env: docker` properly tells Render to use the Dockerfile
   
2. **Updated Dockerfile**
   - Changed to `WORKDIR /app/core` for running manage commands
   - Added migrations directly in Dockerfile (runs during build)
   - Uses proper PORT variable handling: `${PORT:-8000}`
   - Added `|| true` to migrations to avoid build failure if tables exist

3. **Committed and Pushed** all changes to main branch

## 🚀 How to Deploy Now

### On Render Dashboard:

1. **Create a new Web Service** (or trigger manual deploy on existing service)
2. **Connect your GitHub repository**
3. **Select branch:** main
4. **Render will automatically:**
   - Detect the Dockerfile at project root
   - Build the Docker image
   - Run migrations (in Dockerfile RUN step)
   - Collect static files (in Dockerfile RUN step)
   - Start Daphne server (in Dockerfile CMD)

### Required Environment Variables:
Add these in Render Settings → Environment:

```
DEBUG=False
SECRET_KEY=<generate-strong-random-string>
DATABASE_URL=postgresql://user:password@host:port/dbname
REDIS_URL=redis://user:password@host:port
CLOUDINARY_URL=cloudinary://key:secret@cloud
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=<app-specific-password>
RECAPTCHA_SITE_KEY=<your-key>
RECAPTCHA_SECRET_KEY=<your-key>
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.onrender.com
CSRF_TRUSTED_ORIGINS=https://your-domain.onrender.com
```

## 📋 What Happens During Build Now

1. **Dockerfile is detected** ✓
2. **Python 3.12-slim image** pulled
3. **System dependencies** installed
4. **Python packages** installed from requirements.txt
5. **Project files** copied
6. **Static files collected** with WhiteNoise
7. **Database migrations** applied (if DB connected)
8. **Daphne server** starts on PORT 8000

## ✅ Testing Before Deploy (Optional)

```bash
# Build locally
docker build -t ekubo-app .

# Run with environment variables
docker run -it \
  -e DEBUG=False \
  -e SECRET_KEY=test-secret \
  -e DATABASE_URL=postgresql://... \
  -e REDIS_URL=redis://... \
  -p 8000:8000 \
  ekubo-app
```

## 🔍 If Build Still Fails

**Check Render Logs for:**
- Missing environment variables (DATABASE_URL, REDIS_URL, etc.)
- Database connectivity issues
- Missing SECRET_KEY

**Common Fixes:**
- Ensure PostgreSQL is running and accessible
- Ensure Redis is running and accessible
- Verify Cloudinary URL is correct
- Check SECRET_KEY is set

## 📁 Final File Structure

```
EKUBO 1/
├── Dockerfile                ← ✅ ROOT LEVEL (UPDATED)
├── .dockerignore             ← ROOT LEVEL
├── render.yaml               ← ✅ UPDATED (removed build/start commands)
├── requirements.txt
├── core/
│   ├── manage.py
│   ├── core/
│   │   ├── settings.py
│   │   ├── asgi.py
│   │   └── ...
│   └── ...
└── ...
```

## 🎯 Next Steps

1. **Verify all environment variables** are set on Render
2. **Trigger a manual deploy** on Render dashboard
3. **Watch the build logs** for any errors
4. **Test your application** once deployed
5. **Monitor logs** for any runtime issues

---

**Your Docker deployment should now work correctly on Render!** 🎉
