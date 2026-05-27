import os
import json
import requests

def test_mcp():
    print("Testing LiteLLM MCP Integration...")
    
    url = "http://localhost:4001/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer sk-1234" 
    }
    
    # Let's force it to call the tool by using `tool_choice` dict format
    payload = {
        "model": "gemini-3.1-flash-lite-preview",
        "messages": [
            {"role": "user", "content": "Get the estimation guide for Cloud Run."}
        ],
        "tools": [
            {
                "type": "mcp",
                "server_url": "litellm_proxy",
                "server_label": "litellm",
                "require_approval": "never"
            }
        ],
        "tool_choice": {
            "type": "function",
            "function": {
                "name": "gcp_cost-get_estimation_guide"
            }
        }
    }
    
    print(f"Sending request to {url}...")
    try:
        response = requests.post(url, headers=headers, json=payload)
        print(f"Status Code: {response.status_code}")
        
        try:
            result = response.json()
            
            if "choices" in result and len(result["choices"]) > 0:
                message = result["choices"][0].get("message", {})
                if "tool_calls" in message:
                    print("\n✅ TOOL CALLED SUCCESSFULLY:")
                    print(json.dumps(message["tool_calls"], indent=2))
                else:
                    print("\n❌ NO TOOL WAS CALLED")
                    print(message.get("content", ""))
                    
        except json.JSONDecodeError:
            print("Raw response:")
            print(response.text)
            
    except requests.exceptions.ConnectionError:
        print("Failed to connect. Is LiteLLM running on port 4001?")

if __name__ == "__main__":
    test_mcp()
