import json
import os

log_path = "/home/akshansh/.gemini/antigravity/brain/f533c833-75f3-4a35-bbaf-8d8f7eb47f77/.system_generated/logs/overview.txt"
output_path = "/home/akshansh/sandbox/maarg/runtime/component/sql-service-assignment/service/SQL-Assignment1.xml"

print("Reading log from:", log_path)
if not os.path.exists(log_path):
    print("Log path does not exist!")
    exit(1)

found = False
with open(log_path, 'r', encoding='utf-8') as f:
    for line in f:
        if not line.strip():
            continue
        try:
            data = json.loads(line)
            # Look for model tool calls to write_to_file
            if 'tool_calls' in data:
                for tc in data['tool_calls']:
                    if tc.get('name') == 'write_to_file':
                        args = tc.get('args', {})
                        # Handle potential double-encoding of arguments
                        if isinstance(args, str):
                            try:
                                args = json.loads(args)
                            except:
                                pass
                        
                        target_file = args.get('TargetFile')
                        if target_file and isinstance(target_file, str) and 'SQL-Assignment1.xml' in target_file:
                            content = args.get('CodeContent')
                            if content and 'A1Q02ActivePhysicalProducts' in content:
                                # Strip outer quotes if any
                                if content.startswith('"') and content.endswith('"'):
                                    content = content[1:-1]
                                # Unescape newlines and quotes
                                content = content.replace('\\n', '\n').replace('\\"', '"').replace('\\\\', '\\')
                                with open(output_path, 'w', encoding='utf-8') as out_f:
                                    out_f.write(content)
                                print("Successfully wrote extracted service to:", output_path)
                                found = True
                                break
        except Exception as e:
            # print("Error parsing line:", e)
            pass

if not found:
    print("Could not find the service content in the log file.")
