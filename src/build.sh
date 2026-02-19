#!/bin/bash
# Build script for git-cascade .deb package

echo "🔨 Building git-cascade package..."

# Ensure script is executable
chmod +x usr/bin/git-cascade

# Build the .deb package
dpkg-deb --build . ../git-cascade_1.0.0_all.deb

echo "✅ Package built: git-cascade_1.0.0_all.deb"
