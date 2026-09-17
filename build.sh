#!/bin/bash
set -e

echo "=== Vercel Flutter Web Build ==="

# Check if pre-compiled release artifacts already exist in build/web
if [ -d "build/web" ] && [ -f "build/web/index.html" ]; then
  echo "Found pre-built web artifacts in build/web! Deploying directly..."
  exit 0
fi

# Otherwise install Flutter on Vercel
echo "Installing Flutter SDK (stable)..."
if [ ! -d "_flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter
fi

export PATH="$PATH:`pwd`/_flutter/bin"
flutter doctor -v
flutter pub get
echo "Building Flutter Web release..."
flutter build web --release

echo "Build complete! Output ready in build/web"
