#!/bin/sh
# Copies the environment-specific GoogleService-Info.plist into the built app
# bundle based on the active build configuration. Invoked as a Tuist post script.
set -e

case "${CONFIGURATION}" in
  Dev)     ENV_DIR="Dev" ;;
  Staging) ENV_DIR="Staging" ;;
  Prod)    ENV_DIR="Prod" ;;
  *) echo "error: Unknown CONFIGURATION ${CONFIGURATION}"; exit 1 ;;
esac

SRC="${SRCROOT}/Airlyhub/Firebase/${ENV_DIR}/GoogleService-Info.plist"
DST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

if [ ! -f "${SRC}" ]; then
  echo "error: Missing ${SRC}"; exit 1
fi

echo "Using GoogleService-Info.plist from ${ENV_DIR}"
cp "${SRC}" "${DST}"
