# Description

**s3sync** wraps [s3cmd sync](http://s3tools.org/s3cmd-sync) and [robfig/cron](https://github.com/robfig/cron)
to provide common s3 folder synchronisation usage. This is useful if you are already using Docker.

The image can be pulled publicly through:

- https://quay.io/repository/intellihr/s3sync (docker pull quay.io/intellihr/s3sync)
- https://hub.docker.com/r/soloman1124/s3sync (docker pull soloman1124/s3sync)


# Usage Instruction

## Volume

`/opt/data` is the designated local volume for sync from/to s3 bucket. To sync files from
your local folder `/tmp`, you might specify `-v /tmp:/opt/data` in your docker commands.


## Environment Variables

If you are  running the command inside EC2 instances with proper IAM role setup, you might skip the following
environment variables, e.g.

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
```

Please refert to http://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html for more details.

- *OPERATION* : `push` or `pull` (default set to `pull`)
  `push` sends files from local to s3 bucket
  `pull` download files from s3 bucket to local

- *DELETE_REMOVED* : set to `true` to synchronise deleted files. Please refer to `—delete-removed` option in http://s3tools.org/s3cmd-sync for more detail.

- *CRON_SCHEDULE* : specify this environment variable to enable scheduled s3 synchronisation. Please refer to https://godoc.org/github.com/robfig/cron for the available schedule/crontab input format. e.g.
`0 0 * * * *` -> sync files hourly
`@hourly` -> sync files hourly
`@every 1h30m10s` -> sync files every 1 hour, 30 minutes, 10 seconds

- *SYNC_OPTIONS* : include additional `s3cmd sync` options. e.g. `"--dry-run --exclude '*' --rinclude '^(dags|plugins)\/.*'"`. Please refer to http://s3tools.org/s3cmd-sync for the options support.

- *USE_ECS_TASK_IAM_ROLE* : if you are running the command inside AWS ECS Task, set `true` to automatically load task IAM role credential.


## Sync from local to S3:

```!bash
docker run --rm \
-e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
-e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
-e AWS_DEFAULT_REGION=ap-southeast-2 \
-e S3_BUCKET=test_bucket \
-e S3_KEY=envs/test \
-e OPERATION=push \
-v <LOCAL_FOLDER>:/opt/data \
quay.io/intellihr/s3sync:latest
```

* Change `LOCAL_FILE` to file/folder you want to upload to S3


## Sync from S3 to local:

```!bash
docker run --rm \
-e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
-e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
-e AWS_DEFAULT_REGION=ap-southeast-2 \
-e S3_BUCKET=test_bucket \
-e S3_KEY=envs/test \
-e OPERATION=pull \
-v <LOCAL_FOLDER>:/opt/data \
quay.io/intellihr/s3sync:latest
```

* Change `LOCAL_FOLDER` to the folder where you want to download the files from S3


## Sync from S3 to local every 5 minutes:

```!bash
docker run --rm \
-e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
-e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
-e AWS_DEFAULT_REGION=ap-southeast-2 \
-e S3_BUCKET=test_bucket \
-e S3_KEY=envs/test \
-e OPERATION=pull \
-e CRON_SCHEDULE="@every 5m" \
-v <LOCAL_FOLDER>:/opt/data \
quay.io/intellihr/s3sync:latest
```


## Sync from S3 to local every 5 minutes with include pattern and dry run:

```!bash
docker run --rm \
-e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
-e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
-e AWS_DEFAULT_REGION=ap-southeast-2 \
-e S3_BUCKET=test_bucket \
-e S3_KEY=envs/test \
-e OPERATION=pull \
-e CRON_SCHEDULE="@every 5m" \
-e SYNC_OPTIONS="--exclude '*' --rinclude '^(dags|plugins)\/.*' --dry-run" \
-v <LOCAL_FOLDER>:/opt/data \
quay.io/intellihr/s3sync:latest
```
