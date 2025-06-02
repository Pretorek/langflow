# 🔗 Integration Guide

**Integracja LangFlow z istniejącymi aplikacjami**

## 🎯 **Twój obecny stack**

- ✅ **NocoBase** - Low-code platform
- ✅ **n8n** - Workflow automation  
- ✅ **Help Desk** (Next.js + Supabase)
- ✅ **Weaviate** - Vector database
- ✅ **LangFlow** - AI workflow builder (NEW!)

## 🔄 **LangFlow + n8n Integration**

### **Use Case 1: n8n triggers LangFlow**
```javascript
// n8n HTTP Request Node
POST https://langflow.twoja-domena.com/api/v1/run/flow-id
Headers: {
  "Authorization": "Bearer YOUR_API_KEY",
  "Content-Type": "application/json"
}
Body: {
  "input_value": "{{$json.message}}",
  "session_id": "{{$json.user_id}}"
}
```

### **Use Case 2: LangFlow webhook do n8n**
```yaml
# W LangFlow dodaj Webhook component na końcu flow:
webhook_url: "https://n8n.twoja-domena.com/webhook/langflow-result"
method: POST
data: "{{flow_output}}"
```

## 🗄️ **LangFlow + Weaviate Integration**

### **Vector Search w LangFlow**
```python
# Custom component w LangFlow
from weaviate import Client

client = Client("http://weaviate:8080")  # Same Docker network!

def search_vectors(query: str):
    result = client.query.get("Documents").with_near_text({
        "concepts": [query]
    }).with_limit(5).do()
    return result
```

### **Shared Network Configuration**
```yaml
# W docker-compose.yml dodaj external network:
networks:
  coolify:
    external: true
    name: coolify
```