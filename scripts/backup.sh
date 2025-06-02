#!/bin/bash
# LangFlow Backup Script
# Usage: ./backup.sh [backup_name]

BACKUP_NAME=${1:-"langflow-backup-$(date +%Y%m%d-%H%M%S)"}
BACKUP_DIR="/tmp/langflow-backups"
DATE=$(date +%Y-%m-%d-%H%M%S)

echo "🔄 Starting LangFlow backup: $BACKUP_NAME"

# Create backup directory
mkdir -p $BACKUP_DIR

# Get container names
POSTGRES_CONTAINER=$(docker ps --filter "name=postgres" --format "{{.Names}}" | head -1)
LANGFLOW_CONTAINER=$(docker ps --filter "name=langflow" --format "{{.Names}}" | head -1)

if [ -z "$POSTGRES_CONTAINER" ] || [ -z "$LANGFLOW_CONTAINER" ]; then
    echo "❌ Error: Containers not found"
    exit 1
fi

echo "📦 Found containers:"
echo "  - PostgreSQL: $POSTGRES_CONTAINER"  
echo "  - LangFlow: $LANGFLOW_CONTAINER"

# Backup PostgreSQL database
echo "🗄️ Backing up PostgreSQL database..."
docker exec $POSTGRES_CONTAINER pg_dump -U langflow langflow > "$BACKUP_DIR/${BACKUP_NAME}-database.sql"

if [ $? -eq 0 ]; then
    echo "✅ Database backup completed"
else
    echo "❌ Database backup failed"
    exit 1
fi

# Backup LangFlow configuration and flows
echo "📁 Backing up LangFlow data..."
docker cp $LANGFLOW_CONTAINER:/app/langflow "$BACKUP_DIR/${BACKUP_NAME}-langflow-data"

if [ $? -eq 0 ]; then
    echo "✅ LangFlow data backup completed"
else
    echo "❌ LangFlow data backup failed"  
fi

# Create compressed archive
echo "🗜️ Compressing backup..."
cd $BACKUP_DIR
tar -czf "${BACKUP_NAME}.tar.gz" "${BACKUP_NAME}-database.sql" "${BACKUP_NAME}-langflow-data"

# Cleanup temporary files
rm -f "${BACKUP_NAME}-database.sql"
rm -rf "${BACKUP_NAME}-langflow-data"

echo "✅ Backup completed: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo "📊 Backup size: $(du -sh $BACKUP_DIR/${BACKUP_NAME}.tar.gz | cut -f1)"