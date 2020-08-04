#!/usr/bin/env bash

set -e

echo "****************************************"
echo "Creating deb file for Debian Linux ${ARCH}"
echo "****************************************"

BUILD_ROOT="`pwd`/build/linux/debian"
# remove "v" since deb only allow version name with digits.
VERSION=`cat VERSION | sed 's/v//g'`
DEB_NAME=aws-opentelemetry-collector
AOC_ROOT=${BUILD_ROOT}

echo "BASE_ROOT: ${BUILD_ROOT}  agent_version: ${VERSION} AGENT_BIN_DIR_DEB: ${AOC_ROOT}"

echo "Creating debian folders"
mkdir -p ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/logs
mkdir -p ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin
mkdir -p ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/etc
mkdir -p ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/var
mkdir -p ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/doc

mkdir -p ${AOC_ROOT}/etc/init
mkdir -p ${AOC_ROOT}/etc/systemd/system/
mkdir -p ${AOC_ROOT}/bin
mkdir -p ${AOC_ROOT}/usr/bin
mkdir -p ${AOC_ROOT}/etc/amazon
mkdir -p ${AOC_ROOT}/var/log/amazon
mkdir -p ${AOC_ROOT}/var/run/amazon

echo "Copying application files"
cp LICENSE ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/
cp VERSION ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin/
cp build/linux/aoc_linux_${TARGET_SUPPORTED_ARCH} ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin/aws-opentelemetry-collector
cp tools/ctl/linux/aws-opentelemetry-collector-ctl ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin/
cp config.yaml ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/etc
cp .env ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/etc
cp tools/packaging/linux/aws-opentelemetry-collector.service ${AOC_ROOT}/etc/systemd/system/
cp tools/packaging/linux/aws-opentelemetry-collector.conf ${AOC_ROOT}/etc/init/

chmod ug+rx ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin/aws-opentelemetry-collector
chmod ug+rx ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/bin/aws-opentelemetry-collector-ctl
chmod ug+rx ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/etc/config.yaml
chmod ug+rx ${AOC_ROOT}/opt/aws/aws-opentelemetry-collector/etc/.env


echo "Creating symlinks"
# bin
ln -f -s /opt/aws/aws-opentelemetry-collector/bin/aws-opentelemetry-collector-ctl ${AOC_ROOT}/usr/bin/aws-opentelemetry-collector-ctl
# etc
ln -f -s /opt/aws/aws-opentelemetry-collector/etc ${AOC_ROOT}/etc/amazon/aws-opentelemetry-collector
# log
ln -f -s /opt/aws/aws-opentelemetry-collector/logs ${AOC_ROOT}/var/log/amazon/aws-opentelemetry-collector
# pid
ln -f -s /opt/aws/aws-opentelemetry-collector/var ${AOC_ROOT}/var/run/amazon/aws-opentelemetry-collector

echo "Copying debian build materials"
cp tools/packaging/debian/conffiles ${AOC_ROOT}/
cp tools/packaging/debian/preinst ${AOC_ROOT}/
cp tools/packaging/debian/postinst ${AOC_ROOT}/
cp tools/packaging/debian/prerm ${AOC_ROOT}/
cp tools/packaging/debian/debian-binary ${AOC_ROOT}/

echo "Constructing the control file"
echo 'Package: aws-opentelemetry-collector' > ${AOC_ROOT}/control
echo "Architecture: ${ARCH}" >> ${AOC_ROOT}/control
echo -n 'Version: ' >> ${AOC_ROOT}/control
echo -n ${VERSION} >> ${AOC_ROOT}/control
echo '-1' >> ${AOC_ROOT}/control
cat tools/packaging/debian/control >> ${BUILD_ROOT}/control

echo "Setting permissioning as required by debian"
cd ${AOC_ROOT}/..; find ./debian -type d | xargs chmod 755; cd ~-
# the below permissioning is required by debian
cd ${AOC_ROOT}; tar czf data.tar.gz opt etc usr var --owner=0 --group=0 ; cd ~-
cd ${AOC_ROOT}; tar czf control.tar.gz control conffiles preinst prerm postinst --owner=0 --group=0 ; cd ~-

echo "Creating the debian package"
ar r ${AOC_ROOT}/bin/aws-opentelemetry-collector-${ARCH}.deb ${AOC_ROOT}/debian-binary
ar r ${AOC_ROOT}/bin/aws-opentelemetry-collector-${ARCH}.deb ${AOC_ROOT}/control.tar.gz
ar r ${AOC_ROOT}/bin/aws-opentelemetry-collector-${ARCH}.deb ${AOC_ROOT}/data.tar.gz

echo "Copy debian file to ${DEST}"
mkdir -p ${DEST}
mv ${AOC_ROOT}/bin/aws-opentelemetry-collector-${ARCH}.deb ${DEST}/aws-opentelemetry-collector.deb

echo "remove working directory"
rm -rf ${AOC_ROOT}
