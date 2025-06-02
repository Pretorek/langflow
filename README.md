# 🚀 LangFlow Production Deployment

**Professional LangFlow setup zoptymalizowany dla Coolify i Hetzner VPS**

[![Deploy to Coolify](https://img.shields.io/badge/Deploy%20to-Coolify-blue)](https://coolify.io)
[![LangFlow Version](https://img.shields.io/badge/LangFlow-Latest-green)](https://github.com/langflow-ai/langflow)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-blue)](https://postgresql.org)

## 📋 **Co to jest?**

Ten repository zawiera production-ready konfigurację LangFlow dla deployment na:
- **Coolify** (self-hosted deployment platform)
- **Hetzner VPS** (8GB RAM, 80GB disk) 
- **Integracja** z istniejącym stackiem (n8n, NocoBase, Weaviate)

## 🏗️ **Architektura**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   LangFlow      │    │   PostgreSQL    │    │   Coolify       │
│   Port: 7860    │◄──►│   Port: 5432    │◄──►│   Management    │
│   Memory: 2GB   │    │   Memory: 512MB │    │   & Monitoring  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## ⚡ **Features**

- ✅ **Production Ready**: Resource limits, health checks, restart policies
- ✅ **Secure**: Environment variables, strong passwords, network isolation  
- ✅ **Scalable**: PostgreSQL database, volume persistence, backup ready
- ✅ **Optimized**: Configured dla Hetzner 8GB VPS
- ✅ **Integrated**: Compatible z Coolify ecosystem
- ✅ **Monitored**: Health checks, logging, optional Langfuse integration
## 🚀 **Quick Deploy do Coolify**

### 1. **Prerequisite**
- Działający Coolify server
- Dostęp do tego GitHub repo

### 2. **Deploy Steps**
1. W Coolify: **Create New Resource** → **Service** → **Docker Compose**
2. **Repository**: `https://github.com/Pretorek/langflow.git`
3. **Environment Variables** (USTAW W COOLIFY!):
   ```bash
   POSTGRES_PASSWORD=twoje_bezpieczne_haslo_db
   LANGFLOW_SUPERUSER=twoj_admin_user  
   LANGFLOW_SUPERUSER_PASSWORD=twoje_admin_haslo
   LANGFLOW_SECRET_KEY=bardzo_dlugi_losowy_klucz_min_32_znaki
   ```
4. **Custom Domain**: `langflow.twoja-domena.com`
5. **Deploy!** 🚀

### 3. **Dostęp**
- **URL**: `https://langflow.twoja-domena.com`
- **Login**: credentials z Environment Variables
- **Port**: 7860 (automatically handled by Coolify)
## 📊 **System Requirements**

### **Minimal (zalecane dla twojego Hetzner VPS):**
- **RAM**: 3GB total (LangFlow: 2GB + PostgreSQL: 512MB + system: 512MB)
- **CPU**: 2 cores (1.5 dla LangFlow + 0.5 dla PostgreSQL)  
- **Disk**: 10GB+ (dla database growth)
- **Network**: Stable internet connection

### **Twój obecny setup:** ✅
- **Hetzner VPS**: 8GB RAM, 80GB disk - **IDEALNY!**
- **Existing apps**: NocoBase, n8n, Help Desk, Weaviate - **COMPATIBLE**

## 🔧 **Configuration Files**

| Plik | Opis |
|------|------|
| `docker-compose.yml` | Main deployment configuration |
| `.env.example` | Template environment variables |
| `docs/deployment.md` | Detailed deployment guide |
| `docs/troubleshooting.md` | Common issues & solutions |
| `scripts/health-check.sh` | Custom health monitoring |

## 📁 **Project Structure**

```
langflow/
├── docker-compose.yml      # Main deployment file
├── .env.example           # Environment template  
├── README.md             # This file
├── docs/                 # Documentation
│   ├── deployment.md     # Deployment guide
│   ├── troubleshooting.md # Problem solving
│   └── integration.md    # n8n & other integrations
├── scripts/              # Utility scripts
│   ├── backup.sh         # Backup automation
│   └── health-check.sh   # Health monitoring
└── config/               # Optional configs
    └── postgresql.conf   # PostgreSQL tuning
```
## 🔐 **Security Best Practices**

- 🔑 **Strong Passwords**: Min 16 characters dla production
- 🎯 **Environment Variables**: Wszystkie secrets tylko w Coolify
- 🚫 **Never Commit**: Prawdziwe credentials NIE w repo  
- 🔒 **Network Isolation**: Docker network separation
- 📜 **Regular Updates**: Monitor for LangFlow updates
- 💾 **Backup Strategy**: Automatic volume backups w Coolify

## 🚨 **Troubleshooting Quick Fixes**

| Problem | Solution |
|---------|----------|
| "502 Bad Gateway" | Poczekaj 2-3 min na startup, sprawdź health check |
| DB Connection Error | Verify environment variables w Coolify |
| Out of Memory | Check if swap enabled on Hetzner |
| Port conflicts | Ensure port 7860 nie używany przez inne apps |

## 📖 **Documentation**

- 📋 [Deployment Guide](docs/deployment.md) - Szczegółowe instrukcje  
- 🔧 [Troubleshooting](docs/troubleshooting.md) - Rozwiązywanie problemów
- 🔗 [Integration Guide](docs/integration.md) - Integracja z n8n, NocoBase

## 🤝 **Support**

Jeśli masz problemy:
1. Sprawdź [Troubleshooting Guide](docs/troubleshooting.md)
2. Zobacz logi w Coolify dashboard
3. Check [LangFlow Documentation](https://docs.langflow.org)

## 📝 **License**

MIT License - feel free to modify dla swoich potrzeb!