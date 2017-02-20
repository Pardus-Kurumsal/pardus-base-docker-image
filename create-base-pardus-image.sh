#!/bin/sh
# Cihangir Akturk
# In order for this script to run properly, you need to make
# sure that you have pardus-archive-keyring installed on your
# system.

set -e

if ! [ $(id -u) = 0 ]; then
    echo "You need superuser privileges to run this script!"
    exit 127
fi

PARDUS_REPO_URL=http://161.9.194.174:33333/pardus
SUITE="pardus-devel"
TARGET=$(mktemp -d "pardus.base.XXXXXX")

# clean up the mess on premature exits
clean_up() {
    rm -fr "${TARGET}"
}
trap clean_up EXIT INT

debootstrap "${SUITE}" "${TARGET}" "${PARDUS_REPO_URL}"

# Clean up chroot
chroot "${TARGET}" apt-get clean
rm -rf "${TARGET}/var/lib/apt/lists/*"

tar -C "${TARGET}" -c . | docker import - pardus-base
