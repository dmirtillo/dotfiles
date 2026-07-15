import subprocess
import json
import sys
import argparse

def get_dom_path(file_path, target_text):
    # Escape quotes for CSS selector
    escaped_text = target_text.replace('"', '\\"')
    
    # Run officecli query searching for text anywhere
    cmd = [
        "officecli", 
        "query", 
        file_path, 
        f':contains("{escaped_text}")', 
        "--json"
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        data = json.loads(result.stdout)
        
        if data.get("success") and "data" in data and "results" in data["data"]:
            results = data["data"]["results"]
            if len(results) > 0:
                # Return the path of the first match
                return results[0]["path"]
                
    except subprocess.CalledProcessError as e:
        print(f"Error querying officecli: {e.stderr}", file=sys.stderr)
    except json.JSONDecodeError:
        print(f"Failed to parse officecli output", file=sys.stderr)
        
    return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Find DOM path for text in Office file")
    parser.add_argument("file", help="Path to Office file")
    parser.add_argument("text", help="Text to search for")
    
    args = parser.parse_args()
    
    path = get_dom_path(args.file, args.text)
    if path:
        print(path)
    else:
        print(f"Target text not found", file=sys.stderr)
        sys.exit(1)
