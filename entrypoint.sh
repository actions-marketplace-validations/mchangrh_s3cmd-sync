#!/bin/sh

set -e

if [ -z "$S3_BUCKET" ]; then
  echo "S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$S3_ACCESS_KEY_ID" ]; then
  echo "S3_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$S3_ACCESS_KEY_SECRET" ]; then
  echo "S3_ACCESS_KEY_SECRET is not set. Quitting."
  exit 1
fi

# Default to us-east-1 if S3_REGION not set.
if [ -z "$S3_REGION" ]; then
  S3_REGION="us-east-1"
fi

# create profile from env vars
cat << EOF > ~/.s3cfg
[default]
access_key = $S3_ACCESS_KEY_ID
bucket_location = $S3_REGION
host_base = $S3_ENDPOINT
host_bucket = $S3_BUCKET.$S3_ENDPOINT
secret_key = $S3_ACCESS_KEY_SECRET
EOF

# All other flags are optional via the `args:` directive.
s3cmd sync ${SOURCE_DIR:-.} s3://${S3_BUCKET}/${DEST_DIR} \
  --no-progress \
  "$@"

# remove profile
rm ~/.s3cfg