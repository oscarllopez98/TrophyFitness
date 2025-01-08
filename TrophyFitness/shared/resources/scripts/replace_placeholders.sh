#  replace_placeholders.sh
#  TrophyFitness
#
#  Created by Oscar Lopez on 1/7/25.
#  

#!/bin/bash

# -----------------------------------
# Paths to template files
# -----------------------------------
TEMPLATE_DIR="TrophyFitness/shared/resources/config"
AWS_TEMPLATE_FILE="$TEMPLATE_DIR/awsconfiguration.json.template"
AMPLIFY_TEMPLATE_FILE="$TEMPLATE_DIR/amplifyconfiguration.json.template"

# Paths to output files in the project root
AWS_OUTPUT_FILE="awsconfiguration.json"
AMPLIFY_OUTPUT_FILE="amplifyconfiguration.json"

# Path to Config.xcconfig
CONFIG_FILE="TrophyFitness/Config.xcconfig"



#!/bin/bash

# -----------------------------------
# 🛠 Validation
# -----------------------------------
echo "🛠 Starting replace_placeholders.sh script..."
echo "🔍 Checking environment variables..."

echo "COGNITO_POOL_ID: ${COGNITO_POOL_ID:-EMPTY}"
echo "COGNITO_APP_CLIENT_ID: ${COGNITO_APP_CLIENT_ID:-EMPTY}"
echo "AWS_REGION: ${AWS_REGION:-EMPTY}"

# Validate environment variables
if [[ -z "$COGNITO_POOL_ID" || -z "$COGNITO_APP_CLIENT_ID" || -z "$AWS_REGION" ]]; then
    echo "❌ Error: One or more environment variables are not set."
    exit 1
fi

# -----------------------------------
# Logging
# -----------------------------------
echo "🛠 Starting replace_placeholders.sh script..."
echo "Template Directory: $TEMPLATE_DIR"
echo "AWS Template File: $AWS_TEMPLATE_FILE"
echo "Amplify Template File: $AMPLIFY_TEMPLATE_FILE"
echo "Config File: $CONFIG_FILE"
echo "AWS Output File: $AWS_OUTPUT_FILE"
echo "Amplify Output File: $AMPLIFY_OUTPUT_FILE"

# -----------------------------------
# Extract the correct API Gateway endpoint from Config.xcconfig
# -----------------------------------
echo "🔍 Extracting API Gateway endpoint from $CONFIG_FILE..."

API_GATEWAY_ENDPOINT=$(grep -E '^BASE_URL_DEV' "$CONFIG_FILE" | cut -d '=' -f 2 | tr -d ' ')

# Validate the extracted value
if [[ -z "$API_GATEWAY_ENDPOINT" ]]; then
    echo "❌ Error: API_GATEWAY_ENDPOINT not found in $CONFIG_FILE"
    exit 1
fi

echo "✅ API Gateway endpoint extracted: $API_GATEWAY_ENDPOINT"

# Export the API Gateway endpoint as an environment variable
export API_GATEWAY_ENDPOINT="$API_GATEWAY_ENDPOINT"

# -----------------------------------
# Check if template files exist
# -----------------------------------
echo "🔍 Checking if template files exist..."

if [[ ! -f "$AWS_TEMPLATE_FILE" ]]; then
    echo "❌ Error: AWS template file not found at $AWS_TEMPLATE_FILE"
    exit 1
fi

if [[ ! -f "$AMPLIFY_TEMPLATE_FILE" ]]; then
    echo "❌ Error: Amplify template file not found at $AMPLIFY_TEMPLATE_FILE"
    exit 1
fi

echo "✅ Template files found."

# -----------------------------------
# Generate awsconfiguration.json
# -----------------------------------
echo "📄 Generating awsconfiguration.json..."

sed -e "s|\${COGNITO_POOL_ID}|$COGNITO_POOL_ID|g" \
    -e "s|\${COGNITO_APP_CLIENT_ID}|$COGNITO_APP_CLIENT_ID|g" \
    -e "s|\${AWS_REGION}|$AWS_REGION|g" \
    -e "s|\${API_GATEWAY_ENDPOINT}|$API_GATEWAY_ENDPOINT|g" \
    "$AWS_TEMPLATE_FILE" > "$AWS_OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
    echo "✅ Generated: $AWS_OUTPUT_FILE"
else
    echo "❌ Error generating $AWS_OUTPUT_FILE"
    exit 1
fi

# -----------------------------------
# Generate amplifyconfiguration.json
# -----------------------------------
echo "📄 Generating amplifyconfiguration.json..."

sed -e "s|\${COGNITO_POOL_ID}|$COGNITO_POOL_ID|g" \
    -e "s|\${COGNITO_APP_CLIENT_ID}|$COGNITO_APP_CLIENT_ID|g" \
    -e "s|\${AWS_REGION}|$AWS_REGION|g" \
    -e "s|\${API_GATEWAY_ENDPOINT}|$API_GATEWAY_ENDPOINT|g" \
    "$AMPLIFY_TEMPLATE_FILE" > "$AMPLIFY_OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
    echo "✅ Generated: $AMPLIFY_OUTPUT_FILE"
else
    echo "❌ Error generating $AMPLIFY_OUTPUT_FILE"
    exit 1
fi

# -----------------------------------
# Success message
# -----------------------------------
echo "🎉 Configuration files generated successfully!"
