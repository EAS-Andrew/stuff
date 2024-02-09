#!/bin/bash

# Variables
SECRET_NAME="my-secret"

# Step 1: Read the Service Account token and Namespace
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

# Step 2: Determine the API server endpoint
APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}

# Step 3: Check if the secret already exists
# Using wget to make a GET request. Note: wget's output is sent to stderr.
if ! wget --header="Authorization: Bearer $TOKEN" --method=GET \
    --output-document=- \
    --no-check-certificate \
    $APISERVER/api/v1/namespaces/$NAMESPACE/secrets/$SECRET_NAME 2>/dev/null; then

    echo "Secret $SECRET_NAME does not exist in namespace $NAMESPACE. Creating it..."

    # Step 4: Prepare the Secret data (example with dummy data)
    # Replace `your-username` and `your-password` with your actual secret data
    DATA='{"apiVersion":"v1","kind":"Secret","metadata":{"name":"'"$SECRET_NAME"'"},"data":{"username":"'"$(echo -n 'your-username' | base64)"'","password":"'"$(echo -n 'your-password' | base64)"'"}}'

    # Use echo to send this to a temporary file
    TMP_DATA=$(mktemp)
    echo $DATA > $TMP_DATA

    # Step 5: Use wget to send a POST request to the Kubernetes API to create the Secret
    wget --header="Authorization: Bearer $TOKEN" --header='Content-Type: application/json' \
        --post-file=$TMP_DATA \
        --no-check-certificate \
        $APISERVER/api/v1/namespaces/$NAMESPACE/secrets

    # Clean up temporary file
    rm $TMP_DATA

    echo "Secret created in namespace $NAMESPACE."
else
    echo "Secret $SECRET_NAME already exists in namespace $NAMESPACE. Skipping creation."
fi

