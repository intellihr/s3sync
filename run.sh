#!/usr/bin/env sh

if [ "$USE_ECS_TASK_IAM_ROLE" = "true" ]; then
  AWS_CREDS=`curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI`
fi

if [ -n "$AWS_CREDS" ]; then
  export AWS_ACCESS_KEY_ID=`echo $AWS_CREDS | jq -r '.AccessKeyId'`
  export AWS_SECRET_ACCESS_KEY=`echo $AWS_CREDS | jq -r '.SecretAccessKey'`
  export AWS_SESSION_TOKEN=`echo $AWS_CREDS | jq -r '.Token'`
fi

if [ -n "$CRON_SCHEDULE" ]; then
  exec env /opt/mantra "$CRON_SCHEDULE" /opt/sync.sh
else
  exec env /opt/sync.sh
fi
