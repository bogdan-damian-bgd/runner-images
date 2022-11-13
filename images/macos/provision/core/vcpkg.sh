#!/bin/bash -e -o pipefail
source ~/utils/utils.sh

# Set env variable for vcpkg
GIT_COMMIT_HASH="299b1e17df207b4ea4b07c85af15cc7027f8cc25"
VCPKG_INSTALLATION_ROOT=/usr/local/share/vcpkg
echo "export VCPKG_INSTALLATION_ROOT=${VCPKG_INSTALLATION_ROOT}" | tee -a ~/.bashrc

# Install vcpkg
git clone https://github.com/Microsoft/vcpkg $VCPKG_INSTALLATION_ROOT

pushd $VCPKG_INSTALLATION_ROOT
git checkout $GIT_COMMIT_HASH
popd

$VCPKG_INSTALLATION_ROOT/bootstrap-vcpkg.sh
$VCPKG_INSTALLATION_ROOT/vcpkg integrate install
chmod -R 0777 $VCPKG_INSTALLATION_ROOT
ln -sf $VCPKG_INSTALLATION_ROOT/vcpkg /usr/local/bin

invoke_tests "Common" "vcpkg"
