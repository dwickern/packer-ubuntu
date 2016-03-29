#!/bin/bash -eux

if [[ ! $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  # the virtualbox output is converted to a hyper-v box
  exit
fi

echo "==> Installing Hyper-V Tools"

# install tools required by hyper-v
# https://technet.microsoft.com/en-us/library/dn531029.aspx

echo "==> Checking version of Ubuntu"
. /etc/lsb-release

if [[ $DISTRIB_RELEASE == 12.04 ]]; then

  apt-get update
  apt-get install --yes --install-recommends linux-generic-lts-trusty
  apt-get install --yes --install-recommends hv-kvp-daemon-init linux-tools-lts-trusty linux-cloud-tools-generic-lts-trusty

elif [[ $DISTRIB_RELEASE == 14.04 ]]; then

  apt-get update
  apt-get install --yes --install-recommends linux-virtual-lts-wily
  apt-get install --yes --install-recommends linux-tools-virtual-lts-wily linux-cloud-tools-virtual-lts-wily

  # also upgrade linux-image-extra so we don't break docker
  # https://docs.docker.com/engine/installation/linux/ubuntulinux/
  apt-get install --yes linux-image-extra-virtual-lts-wily

elif [[ $DISTRIB_RELEASE == 15.04 || $DISTRIB_RELEASE == 15.10 ]]; then

  apt-get update
  apt-get install --yes linux-tools-virtual linux-cloud-tools-virtual

else

  echo "==> Hyper-V Tools not supported on ${DISTRIB_RELEASE}"
  exit

fi

reboot
sleep 60
