#!/usr/bin/env sh
set -e

: ${OPERATION:=pull}

OPTIONS=""
if [ "$DELETE_REMOVED" = "true" ]
then
  OPTIONS="--delete-removed"
fi

if [ -n "$SYNC_OPTIONS" ]
then
  OPTIONS="$OPTIONS $SYNC_OPTIONS"
fi

if [ "$OPERATION" = "pull" ]
then
  echo "sync from s3://${S3_BUCKET}/${S3_KEY}"
  sh -c "s3cmd sync ${OPTIONS} s3://${S3_BUCKET}/${S3_KEY} /opt/data/"
elif [ "$OPERATION" = "push" ]
then
  echo "sync to s3://${S3_BUCKET}/${S3_KEY}"
  sh -c "s3cmd sync $OPTIONS /opt/data/ s3://${S3_BUCKET}/${S3_KEY}"
else
  echo "Unsupported operation ${OPERATION}"
fi
