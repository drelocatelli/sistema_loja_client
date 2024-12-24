#!/bin/bash

# set app current version
# Default version if --version is not provided
DEFAULT_VERSION="1.1"
VERSION=$DEFAULT_VERSION
# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2 ;; # Move past the flag and its value
        *)
            echo "Unknown option: $1"
            exit 1 ;;
    esac
done

cat > build/web/version.php << EOF
<?php

header('Content-Type: application/json');

echo json_encode([
    'current_version' => '$VERSION' 
]);
EOF

sed -i "s/^VERSION='.*'/VERSION='$VERSION'/g" .env
sed -i "s/^VERSION='.*'/VERSION='$VERSION'/g" .env.dev
sed -i "s/^APP_MODE'.*'/APP_MODE'production'/g" .env.dev
sed -i "s/^APP_MODE'.*'/APP_MODE'production'/g" .env

# Build the Flutter web app
flutter build web --release --base-href="/raccoontech/"

# Path to the generated index.html file
INDEX_FILE="build/web/index.html"

# Remove <base href="/"> tag
# sed -i '/<base href="\/">/d' "$INDEX_FILE"

# Set a custom <title>
sed -i 's|<title>.*</title>|<title>Raccoon Tech</title>|' "$INDEX_FILE"

flutter build apk --release

sed -i "s/^APP_MODE'.*'/APP_MODE'development'/g" .env.dev
sed -i "s/^APP_MODE'.*'/APP_MODE'development'/g" .env

echo "version.php created with version $VERSION."

# echo "Modifications complete: Removed <base href> and updated <title> in index.html"
