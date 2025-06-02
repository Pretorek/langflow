#!/bin/bash
# Health Check Script dla LangFlow
# Usage: ./health-check.sh

echo "🔍 LangFlow Health Check Starting..."

# Colors dla output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if containers are running
echo "📦 Checking containers..."
LANGFLOW_CONTAINER=$(docker ps --filter "name=langflow" --format "{{.Names}}" | head -1)
POSTGRES_CONTAINER=$(docker ps --filter "name=postgres" --format "{{.Names}}" | head -1)

if [ -z "$LANGFLOW_CONTAINER" ]; then
    echo -e "${RED}❌ LangFlow container not running${NC}"
    exit 1
else
    echo -e "${GREEN}✅ LangFlow container: $LANGFLOW_CONTAINER${NC}"
fi

if [ -z "$POSTGRES_CONTAINER" ]; then
    echo -e "${RED}❌ PostgreSQL container not running${NC}"
    exit 1
else
    echo -e "${GREEN}✅ PostgreSQL container: $POSTGRES_CONTAINER${NC}"
fi

# Check container health
echo "🏥 Checking container health..."
LANGFLOW_HEALTH=$(docker inspect --format='{{.State.Health.Status}}' $LANGFLOW_CONTAINER 2>/dev/null)
if [ "$LANGFLOW_HEALTH" = "healthy" ]; then
    echo -e "${GREEN}✅ LangFlow health: healthy${NC}"
else
    echo -e "${YELLOW}⚠️  LangFlow health: $LANGFLOW_HEALTH${NC}"
fi

# Check HTTP endpoint
echo "🌐 Checking HTTP endpoint..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:7860/health || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ HTTP endpoint: responding (200)${NC}"
else
    echo -e "${RED}❌ HTTP endpoint: not responding ($HTTP_CODE)${NC}"
fi
# Check database connectivity
echo "🗄️ Checking database..."
DB_CHECK=$(docker exec $POSTGRES_CONTAINER pg_isready -U langflow 2>/dev/null)
if [[ $DB_CHECK == *"accepting connections"* ]]; then
    echo -e "${GREEN}✅ PostgreSQL: accepting connections${NC}"
else
    echo -e "${RED}❌ PostgreSQL: not ready${NC}"
fi

# Check memory usage
echo "💾 Checking memory usage..."
MEMORY_USAGE=$(docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}" | grep -E "(langflow|postgres)")
echo "$MEMORY_USAGE"

# Check disk usage for volumes
echo "💿 Checking volume usage..."
docker system df -v | grep -E "(langflow|postgres)"

echo "🎯 Health check completed!"
echo "📊 For detailed logs run: docker logs $LANGFLOW_CONTAINER"