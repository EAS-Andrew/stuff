#!/bin/bash

# Step 1: Read the Service Account token
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# Step 2: Determine the API server endpoint
APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}

# Step 3: Prepare the Secret data (example with dummy data)
# Replace `your-username` and `your-password` with your actual secret data
DATA=$(echo -n '{"apiVersion":"v1","kind":"Secret","metadata":{"name":"my-secret"},"data":{"username":"$(echo -n 'your-username' | base64)","password":"$(echo -n 'your-password' | base64)"}}')

# Step 4: Use curl to send a POST request to the Kubernetes API to create the Secret
curl -k -X POST $APISERVER/api/v1/namespaces/default/secrets \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d "$DATA"

# Note: The `-k` option is used to skip certificate verification. In a production environment, it's important to verify the API server's certificate to ensure secure communication.
