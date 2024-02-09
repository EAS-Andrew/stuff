#!/bin/bash

# Variables
SECRET_NAME="my-secret"

# Step 1: Read the Service Account token
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# Step 1b: Dynamically determine the namespace the pod is running in
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

# Step 2: Determine the API server endpoint
APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}

# Step 3: Check if the secret already exists
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -k -X GET $APISERVER/api/v1/namespaces/$NAMESPACE/secrets/$SECRET_NAME \
  -H "Authorization: Bearer $TOKEN")

if [ $RESPONSE -eq 404 ]; then
    echo "Secret $SECRET_NAME does not exist in namespace $NAMESPACE. Creating it..."

    # Step 4: Prepare the Secret data (example with dummy data)
    # Replace `your-username` and `your-password` with your actual secret data
    DATA=$(echo -n '{"apiVersion":"v1","kind":"Secret","metadata":{"name":"'"$SECRET_NAME"'"},"data":{"username":"$(echo -n 'your-username' | base64)","password":"$(echo -n 'your-password' | base64)"}}')

    # Step 5: Use curl to send a POST request to the Kubernetes API to create the Secret
    curl -k -X POST $APISERVER/api/v1/namespaces/$NAMESPACE/secrets \
      -H "Authorization: Bearer $TOKEN" \
      -H 'Content-Type: application/json' \
      -d "$DATA"

    echo "Secret created in namespace $NAMESPACE."
else
    echo "Secret $SECRET_NAME already exists in namespace $NAMESPACE. Skipping creation."
fi

# Note: The `-k` option is used to skip certificate verification. In a production environment, it's important to verify the API server's certificate to ensure secure communication.
