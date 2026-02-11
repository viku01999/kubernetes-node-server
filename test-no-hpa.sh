#!/bin/bash

# ⏱ Start time
START_TIME=$(date +%s)

URL="http://192.168.29.13:32051/api/hello"
TMP_FILE=$(mktemp)
> "$TMP_FILE"

# Function to call API and log result
call_api() {
  RESPONSE=$(curl -s "$URL")
  POD_NAME=$(echo "$RESPONSE" | jq -r '.pod')
  STATUS=$(echo "$RESPONSE" | jq -r '.message')

  if [[ "$STATUS" == "Hello from Node + TypeScript API running in Kubernetes!" ]]; then
    echo "$POD_NAME:1" >> "$TMP_FILE"
  else
    echo "$POD_NAME:0" >> "$TMP_FILE"
  fi
}

export -f call_api
export URL
export TMP_FILE

# Set how many requests and concurrency
TOTAL_REQUESTS=20000
CONCURRENCY=50

for ((i=0; i<TOTAL_REQUESTS; i+=CONCURRENCY)); do
  for ((j=0; j<CONCURRENCY && i+j<TOTAL_REQUESTS; j++)); do
    bash -c "call_api" &
  done
  wait
done

# Aggregate results by pod
echo "✅ Success/Fail per pod:"
awk -F: '{
  success[$1]+=$2
  total[$1]++
}
END {
  for (p in total)
    print p, "Success:", success[p], "Fail:", total[p]-success[p]
}' "$TMP_FILE"

# Cleanup
rm "$TMP_FILE"

# ⏱ End time
END_TIME=$(date +%s)

# ⏳ Total execution time
TOTAL_TIME=$((END_TIME - START_TIME))
echo "⏳ Total script execution time: ${TOTAL_TIME} seconds"
