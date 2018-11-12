#!/bin/bash
set -e

EMAIL=${EMAIL:-"root@localhost"}
PASSWORD=${PASSWORD:-"altereme"}
TITLE=${TITLE:-"Portal Modelo"}
DESCR=${DESCR:-"O Portal das Casas Legislativas"}
SMTP_SERVER=${SMTP_SERVER:-"smtp.dominio.leg.br"}
SMTP_PORT=${SMTP_PORT:-"25"}
ROOTPWD=${ROOTPWD:-"adminpw"}
ZEO_ADDRESS=${ZEO_ADDRESS:-"zeoserver:8100"}

sed -i "s/%EMAIL%/${EMAIL}/g" cfg_portal.py
sed -i "s/%PASSWORD%/${PASSWORD}/g" cfg_portal.py
sed -i "s/%TITLE%/${TITLE}/g" cfg_portal.py
sed -i "s/%DESCR%/${DESCR}/g" cfg_portal.py
sed -i "s/%SMTP_SERVER%/${SMTP_SERVER}/g" cfg_portal.py
sed -i "s/%SMTP_PORT%/${SMTP_PORT}/g" cfg_portal.py
sed -i "s/%ROOTPWD%/${ROOTPWD}/g" cfg_portal.py
sed -i "s/%HOSTNAME%/${HOSTNAME}/g" cfg_portal.py

if [ "$ZEO_ADDRESS" == "" ]; then
  sed -i "s/%ZEO_ADDRESS%//g" configure.cfg
  sed -i "s/%ZEO_ADDRESS%//g" upgrades.cfg
  sed -i "s/%ZEO_CLIENT%/false/g" configure.cfg
  sed -i "s/%ZEO_CLIENT%/false/g" upgrades.cfg
  sed -i "s/%SHARED_BLOB%//g" configure.cfg
  sed -i "s/%SHARED_BLOB%//g" upgrades.cfg
else
  sed -i "s/%ZEO_ADDRESS%/${ZEO_ADDRESS}/g" configure.cfg
  sed -i "s/%ZEO_ADDRESS%/${ZEO_ADDRESS}/g" upgrades.cfg
  sed -i "s/%ZEO_CLIENT%/true/g" configure.cfg
  sed -i "s/%ZEO_CLIENT%/true/g" upgrades.cfg
  sed -i "s/%SHARED_BLOB%/on/g" configure.cfg
  sed -i "s/%SHARED_BLOB%/on/g" upgrades.cfg
fi

if [ ! -e "/data/.custom-installed.cfg" ]; then
  bin/buildout -c configure.cfg && echo "Initial configuration completed."
fi

if [ ! -e "/data/.upgrade-3.0-12" ]; then
  echo "Upgrading Portal to version 3.0-12..."
  bin/buildout -c upgrades.cfg && cd /plone/instance && \
  ./bin/upgrade-portals --username admin --upgrade-profile interlegis.portalmodelo.policy:default && \
  echo "Successfully upgraded Portal to version 3.0-12." | tee /data/.upgrade-3.0-12
fi

