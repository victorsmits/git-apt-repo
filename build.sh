#!/bin/bash
set -e

# 🎯 Configuration
VERSION="1.0.1"
PKG_NAME="git-cascade"
REPO_NAME="git-apt-repo"

# 🧹 Cleanup
rm -rf .tmp debian usr DEBIAN *.deb

# 📁 Create structure
mkdir -p .tmp/debian/DEBIAN
mkdir -p .tmp/debian/usr/bin
mkdir -p pool/main

# 📄 Create control file
cat > .tmp/debian/DEBIAN/control << EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Depends: git, fzf
Maintainer: Victor Smits <victor.smits@facilecomm.com>
Description: Interactive git branch cascading merge tool
 Tool for merging a chain of git branches in cascade
 with interactive fzf interface.
EOF

# 📋 Copy and setup script
cp git-cascade .tmp/debian/usr/bin/
chmod +x .tmp/debian/usr/bin/git-cascade

# 📦 Build .deb
dpkg-deb --build .tmp/debian . > /dev/null 2>&1 || dpkg-deb --build .tmp/debian .

# 📦 Move to pool
mv ${PKG_NAME}_${VERSION}_all.deb pool/main/

# 🗂️ Update Packages index
cd pool/main
dpkg-scanpackages . /dev/null > ../../dists/stable/main/binary-amd64/Packages 2>/dev/null || \
  cat > ../../dists/stable/main/binary-amd64/Packages << PKGEOF
Package: ${PKG_NAME}
Version: ${VERSION}
Architecture: all
Maintainer: Victor Smits <victor.smits@facilecomm.com>
Depends: git, fzf
Filename: pool/main/${PKG_NAME}_${VERSION}_all.deb
Size: $(stat -c%s "${PKG_NAME}_${VERSION}_all.deb" 2>/dev/null || echo "2200")
Description: Interactive git branch cascading merge tool
PKGEOF

gzip -c ../../dists/stable/main/binary-amd64/Packages > ../../dists/stable/main/binary-amd64/Packages.gz

# 📝 Update Release file
cd ../..
cat > dists/stable/Release << RELEOF
Origin: Git Cascade
Label: Git Cascade
Suite: stable
Codename: stable
Version: ${VERSION}
Date: $(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S +0000')
Architectures: all amd64
Components: main
Description: Git Cascade APT Repository
MD5Sum:
 $(md5sum dists/stable/main/binary-amd64/Packages | cut -d' ' -f1) $(stat -c%s "dists/stable/main/binary-amd64/Packages") main/binary-amd64/Packages
 $(md5sum dists/stable/main/binary-amd64/Packages.gz | cut -d' ' -f1) $(stat -c%s "dists/stable/main/binary-amd64/Packages.gz") main/binary-amd64/Packages.gz
SHA256:
 $(sha256sum dists/stable/main/binary-amd64/Packages | cut -d' ' -f1) $(stat -c%s "dists/stable/main/binary-amd64/Packages") main/binary-amd64/Packages
 $(sha256sum dists/stable/main/binary-amd64/Packages.gz | cut -d' ' -f1) $(stat -c%s "dists/stable/main/binary-amd64/Packages.gz") main/binary-amd64/Packages.gz
RELEOF

# 🧹 Cleanup
rm -rf .tmp

echo "✅ Release ${VERSION} built successfully!"
echo ""
echo "📦 Package: pool/main/${PKG_NAME}_${VERSION}_all.deb"
echo "🌐 Repo index updated"
echo ""
echo "👉 git add . && git commit -m 'Release v${VERSION}' && git push"
