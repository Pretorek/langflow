# 📋 LangFlow Deployment Guide

**Krok po kroku deployment LangFlow w Coolify**

## 🎯 **Pre-deployment Checklist**

### ✅ **Server Requirements**
- [ ] Coolify server działający i dostępny
- [ ] Minimum 3GB RAM free (dla LangFlow + PostgreSQL)
- [ ] Port 7860 available (lub custom port)
- [ ] Domain skonfigurowana (opcjonalnie)

### ✅ **Access Requirements**  
- [ ] GitHub account z dostępem do tego repo
- [ ] Admin access do Coolify dashboard
- [ ] SSL certificate (automatycznie przez Let's Encrypt)

## 🚀 **Deployment Steps**

### **KROK 1: Przygotowanie w Coolify**

1. **Login do Coolify Dashboard**
   - Otwórz: `https://twoj-coolify-server.com`
   - Zaloguj się jako admin

2. **Utwórz nowy projekt** (opcjonalnie)
   - Dashboard → **Projects** → **Create New Project**
   - Name: `LangFlow Production`

### **KROK 2: Utworzenie Service**

1. **Create New Resource**
   - Dashboard → **Create New Resource**
   - Wybierz: **Service**

2. **Service Configuration**
   - **Source Type**: `Public Repository` 
   - **Repository URL**: `https://github.com/Pretorek/langflow.git`
   - **Branch**: `main`
   - **Build Pack**: `Docker Compose`
   - **Docker Compose Path**: `docker-compose.yml`
### **KROK 3: Environment Variables**

**KRYTYCZNE: Ustaw następujące Environment Variables w Coolify:**

```bash
# Database Security  
POSTGRES_PASSWORD=super_secure_db_password_2024_xyz

# LangFlow Admin Access
LANGFLOW_SUPERUSER=admin_damian
LANGFLOW_SUPERUSER_PASSWORD=very_secure_admin_password_2024

# Application Security
LANGFLOW_SECRET_KEY=very-long-random-secret-key-at-least-32-characters-long-xyz

# Performance (Optional - defaults są OK)
LANGFLOW_WORKERS=2
LANGFLOW_LOG_LEVEL=INFO
```

**❗ UWAGA: Zmień powyższe wartości na swoje bezpieczne hasła!**

### **KROK 4: Domain Configuration**

1. **Custom Domain** (opcjonalnie)
   - **Domain**: `langflow.twoja-domena.com`
   - **Port**: `7860`
   - **HTTPS**: ✅ (automatycznie przez Let's Encrypt)

2. **Lub użyj Coolify subdomain**
   - Coolify automatically generuje: `random-name.twoj-coolify-server.com`

### **KROK 5: Deploy!**

1. **Review Configuration**
   - Sprawdź wszystkie settings
   - Environment variables set ✅
   - Repository URL correct ✅

2. **Start Deployment**
   - Kliknij: **Deploy**
   - Monitor w real-time logs

3. **Wait for Completion**
   - Initial deployment: ~3-5 minut
   - Watch for "langflow" and "postgres" containers starting
## ✅ **Post-Deployment Verification**

### **KROK 6: Test Access**

1. **Check Health Status**
   - Coolify Dashboard → Your Service → **Containers**
   - Both containers should show: 🟢 **Healthy**

2. **Access LangFlow**
   - URL: `https://langflow.twoja-domena.com` (lub Coolify URL)
   - Should load LangFlow login page

3. **Login Test**
   - **Username**: wartość z `LANGFLOW_SUPERUSER`
   - **Password**: wartość z `LANGFLOW_SUPERUSER_PASSWORD`
   - Should redirect to LangFlow dashboard

### **KROK 7: Create First Flow**

1. **Test Basic Functionality**
   - Click: **+ New Flow**
   - Try: **Basic Chatbot** template
   - Test w built-in playground

2. **Database Persistence Test**
   - Create simple flow
   - Refresh page
   - Flow should persist (PostgreSQL working!)

## 🔍 **Monitoring & Maintenance**

### **Logs Monitoring**
```bash
# W Coolify Terminal lub SSH:
docker logs langflow-container-name
docker logs postgres-container-name
```

### **Resource Usage**
- **Memory**: ~2.5GB total (visible w Coolify dashboard)
- **CPU**: Low during idle, spikes during flow creation
- **Disk**: Growing z database size

### **Backup Strategy**
- Coolify automatic backup włączony dla volumes
- Manual backup: Export flows jako JSON
- Database backup: PostgreSQL dumps