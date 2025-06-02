# 🚨 Troubleshooting Guide

**Rozwiązywanie najczęstszych problemów z LangFlow w Coolify**

## 🔍 **Diagnostyka podstawowa**

### **Quick Health Check Commands**
```bash
# Check containers status
docker ps | grep langflow

# Check logs
docker logs $(docker ps -q --filter "name=langflow")
docker logs $(docker ps -q --filter "name=postgres")

# Check resources
docker stats --no-stream
```

## ❌ **Najczęstsze problemy**

### **1. "502 Bad Gateway" Error**

**Symptom**: Strona nie ładuje się, błąd 502
**Przyczyny**:
- Container jeszcze się uruchamia
- Health check failing  
- Port conflict

**Rozwiązania**:
```bash
# 1. Poczekaj 2-3 minuty na pełne uruchomienie
# 2. Sprawdź health check:
docker exec -it langflow-container curl -f http://localhost:7860/health

# 3. Sprawdź czy port nie jest zajęty:
netstat -tulpn | grep 7860

# 4. Restart service w Coolify
```
### **2. Database Connection Error**

**Symptom**: LangFlow nie może połączyć się z PostgreSQL
**Log error**: `could not connect to server` lub `authentication failed`

**Rozwiązania**:
```bash
# 1. Sprawdź PostgreSQL status:
docker exec -it postgres-container pg_isready -U langflow

# 2. Verify environment variables w Coolify:
# POSTGRES_PASSWORD musi być identyczne w obu services

# 3. Check network connectivity:
docker exec -it langflow-container ping postgres
```

### **3. Out of Memory (OOM)**

**Symptom**: Containers restartują się, system slow
**Log error**: `Killed` lub `OOMKilled`

**Rozwiązania**:
```bash
# 1. Check current memory usage:
free -h
docker stats --no-stream

# 2. Enable swap na Hetzner (jeśli nie masz):
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 3. Reduce resource limits w docker-compose.yml
```

### **4. Login Problems**

**Symptom**: Nie można zalogować się do LangFlow
**Error**: `Invalid credentials` lub `User not found`

**Rozwiązania**:
```bash
# 1. Check environment variables w Coolify:
echo $LANGFLOW_SUPERUSER
echo $LANGFLOW_SUPERUSER_PASSWORD

# 2. Reset admin user (przez container):
docker exec -it langflow-container langflow superuser --username admin --password newpassword

# 3. Check logs for authentication errors:
docker logs langflow-container | grep -i auth
```
### **5. Performance Issues**

**Symptom**: LangFlow działa powoli, timeouts
**Causes**: Resource limits, concurrent users, complex flows

**Rozwiązania**:
```bash
# 1. Increase resource limits w docker-compose.yml:
# memory: 3G (zamiast 2G)
# cpus: "2.0" (zamiast 1.5)

# 2. Optimize PostgreSQL:
# Zwiększ shared_buffers, work_mem w postgresql.conf

# 3. Enable Redis cache (advanced):
# Dodaj Redis service do docker-compose.yml
```

## 🔧 **Advanced Debugging**

### **Container Inspection**
```bash
# Enter container for debugging:
docker exec -it langflow-container bash
docker exec -it postgres-container bash

# Check environment variables inside container:
docker exec -it langflow-container env | grep LANGFLOW

# Check file permissions:
docker exec -it langflow-container ls -la /app/langflow
```

### **Network Troubleshooting**
```bash
# Test network connectivity between containers:
docker network ls
docker network inspect coolify

# DNS resolution test:
docker exec -it langflow-container nslookup postgres
```

### **Data Recovery**
```bash
# Backup current data:
docker exec postgres-container pg_dump -U langflow langflow > backup.sql

# Restore from backup:
docker exec -i postgres-container psql -U langflow langflow < backup.sql
```