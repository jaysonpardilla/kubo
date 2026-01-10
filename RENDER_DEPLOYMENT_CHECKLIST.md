# Pre-Deployment Checklist for Render

## Configuration Files ✅
- [x] `Dockerfile` - Created at project root
- [x] `.dockerignore` - Created to optimize build
- [x] `render.yaml` - Updated with proper build/start commands
- [x] `requirements.txt` - Added python-decouple

## Django Settings ✅
- [x] `ALLOWED_HOSTS` - Made configurable and specific
- [x] Security headers - Added for production
- [x] DEBUG mode - Defaults to False
- [x] SSL/TLS settings - Configured for HTTPS
- [x] Static files - WhiteNoise configured

## Environment Variables Required
Add these to Render dashboard under Settings → Environment:

```
# Core Settings
DEBUG=False
SECRET_KEY=<generate a strong random string>
ALLOWED_HOSTS=localhost,127.0.0.1,<your-app>.onrender.com
CSRF_TRUSTED_ORIGINS=https://<your-app>.onrender.com

# Database
DATABASE_URL=postgresql://username:password@host:port/dbname

# Redis
REDIS_URL=redis://username:password@host:port

# Email (Gmail)
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=<app-specific-password>

# Cloudinary
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name

# reCAPTCHA
RECAPTCHA_SITE_KEY=<your-site-key>
RECAPTCHA_SECRET_KEY=<your-secret-key>
```

## Pre-Deployment Steps

1. **Local Testing** (Optional)
   ```bash
   # Windows
   docker-run.bat
   
   # Linux/Mac
   bash docker-run.sh
   ```

2. **Commit Changes**
   ```bash
   git add .
   git commit -m "Fix Docker deployment for Render"
   git push origin master
   ```

3. **Render Setup**
   - Go to https://render.com
   - Create new Web Service
   - Connect GitHub repository
   - Select branch: master (or main)
   - Build command: Leave empty (using Dockerfile)
   - Start command: Leave empty (using Dockerfile)
   - Add all environment variables from above
   - Click "Create Web Service"

4. **Monitor Deployment**
   - Watch logs for build progress
   - Verify migrations complete successfully
   - Check for any static file collection errors
   - Wait for "Deploy successful"

5. **Post-Deployment Testing**
   - Visit your app URL: https://<your-app>.onrender.com
   - Test login/authentication
   - Test WebSocket connections (if applicable)
   - Check browser console for any errors
   - Verify database is accessible
   - Test file uploads to Cloudinary

## Common Issues & Solutions

### Build Fails: "ModuleNotFoundError: No module named 'decouple'"
- ✅ Already fixed - python-decouple added to requirements.txt

### Build Fails: "Permission denied while trying to connect to Docker daemon"
- Ensure Docker is installed on Render (it is by default)
- Check Dockerfile at project root

### Static Files Not Loading
- Verify staticfiles/ directory is created during build
- Check STATIC_URL and STATIC_ROOT in settings
- WhiteNoise should be first in MIDDLEWARE after SecurityMiddleware

### Database Connection Error
- Verify DATABASE_URL format: postgresql://user:pass@host:port/dbname
- Ensure PostgreSQL is running
- Check SSL requirement: ssl_require=True in settings

### WebSockets Not Working
- Verify REDIS_URL is set and correct
- Check Redis is running and accessible
- Verify CHANNEL_LAYERS configuration in settings
- Daphne server should be running (check logs)

### CSRF Errors
- Verify CSRF_TRUSTED_ORIGINS includes your domain
- Check CSRF_COOKIE_SECURE is True in production
- Verify your frontend sends X-CSRFToken header

### Email Not Sending
- Verify EMAIL_HOST_USER and EMAIL_HOST_PASSWORD
- For Gmail: Use app-specific password, not regular password
- Enable 2FA on Gmail and generate app password

## Render-Specific Notes

- **Free Tier**: Service spins down after 15 mins of inactivity
- **Paid Tier**: Always running, better for production
- **SSL**: Automatically provided via Let's Encrypt
- **Port**: Must use environment variable $PORT (already configured)
- **Logs**: Available in Render dashboard, updated in real-time
- **Restart**: Automatic on each deployment

## File Structure After Fix

```
EKUBO 1/
├── Dockerfile                          ← NEW (at root)
├── .dockerignore                       ← NEW (at root)
├── render.yaml                         ← UPDATED (at root)
├── DOCKER_DEPLOYMENT_GUIDE.md         ← NEW
├── DEPLOYMENT_FIXES_SUMMARY.md        ← NEW
├── docker-run.sh                       ← NEW (for local testing)
├── docker-run.bat                      ← NEW (for Windows)
├── requirements.txt                    ← UPDATED (added python-decouple)
├── core/
│   ├── manage.py
│   ├── core/
│   │   ├── settings.py                 ← UPDATED (security & ALLOWED_HOSTS)
│   │   ├── asgi.py
│   │   └── ...
│   ├── Dockerfile                      ← CAN DELETE (old, at core/)
│   ├── render.yaml                     ← CAN DELETE (old, at core/)
│   └── ...
└── ...
```

## Support Resources

- Render Documentation: https://render.com/docs
- Django Deployment: https://docs.djangoproject.com/en/stable/howto/deployment/
- Daphne Documentation: https://github.com/django/daphne
- Channels Documentation: https://channels.readthedocs.io/

---
**Ready to Deploy!** 🚀

Once you've completed the steps above, your application will be live on Render.
