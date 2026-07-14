import os
try:
    with open("/home/akshansh/sandbox/maarg/runtime/component/sql-service-assignment/log.txt", "w") as f:
        f.write("Workspace is writable!\n")
    print("Write successful!")
except Exception as e:
    print("Write failed:", e)
