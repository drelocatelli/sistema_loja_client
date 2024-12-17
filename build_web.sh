#!/bin/bash

# Build the Flutter web app
flutter build web --release --base-href="/raccoontech/"

# Path to the generated index.html file
INDEX_FILE="build/web/index.html"

# Remove <base href="/"> tag
# sed -i '/<base href="\/">/d' "$INDEX_FILE"

# Set a custom <title>
sed -i 's|<title>.*</title>|<title>Raccoon Tech</title>|' "$INDEX_FILE"

echo "Modifications complete: Removed <base href> and updated <title> in index.html"
