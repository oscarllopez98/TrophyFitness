#!/bin/bash

# -----------------------------------
# 🛠 Validation
# -----------------------------------
echo "🛠 Starting replace_placeholders.sh script..."
echo "🔍 Checking environment variables..."

echo "COGNITO_POOL_ID: ${COGNITO_POOL_ID:-EMPTY}"
echo "COGNITO_APP_CLIENT_ID: ${COGNITO_APP_CLIENT_ID:-EMPTY}"
echo "AWS_REGION: ${AWS_REGION:-EMPTY}"
echo "IDENTITY_POOL_ID: ${IDENTITY_POOL_ID:-EMPTY}"
echo "APPSYNC_URL: ${APPSYNC_URL:-EMPTY}"

# Validate environment variables
if [[ -z "$COGNITO_POOL_ID" || -z "$COGNITO_APP_CLIENT_ID" || -z "$AWS_REGION" || -z "$IDENTITY_POOL_ID" || -z "$APPSYNC_URL" ]]; then
    echo "❌ Error: One or more environment variables are not set."
    exit 1
fi

# -----------------------------------
# Paths to template files
# -----------------------------------
TEMPLATE_DIR="TrophyFitness/shared/resources/config"
AMPLIFY_OUTPUTS_TEMPLATE_FILE="$TEMPLATE_DIR/amplify_outputs.json.template"

# Paths to output files in the project root
AMPLIFY_OUTPUT_FILE="amplify_outputs.json"

# -----------------------------------
# Check if template files exist
# -----------------------------------
echo "🔍 Checking if template files exist..."

if [[ ! -f "$AMPLIFY_OUTPUTS_TEMPLATE_FILE" ]]; then
    echo "❌ Error: Amplify outputs template file not found at $AMPLIFY_OUTPUTS_TEMPLATE_FILE"
    exit 1
fi

echo "✅ Template files found."

# -----------------------------------
# Generate amplify_outputs.json
# -----------------------------------
echo "🗄 Generating amplify_outputs.json..."

sed -e "s|\${COGNITO_POOL_ID}|$COGNITO_POOL_ID|g" \
    -e "s|\${COGNITO_APP_CLIENT_ID}|$COGNITO_APP_CLIENT_ID|g" \
    -e "s|\${AWS_REGION}|$AWS_REGION|g" \
    -e "s|\${IDENTITY_POOL_ID}|$IDENTITY_POOL_ID|g" \
    -e "s|\${APPSYNC_URL}|$APPSYNC_URL|g" \
    "$AMPLIFY_OUTPUTS_TEMPLATE_FILE" > "$AMPLIFY_OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
    echo "✅ Generated: $AMPLIFY_OUTPUT_FILE"
else
    echo "❌ Error generating $AMPLIFY_OUTPUT_FILE"
    exit 1
fi

echo "🎉 Configuration files generated successfully!"
