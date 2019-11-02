#!/usr/bin/env bash

export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
export S3BMUX_MASTER_BUCKET=master
export MINIO_HTTP_TRACE=/tmp/minio_trace

./minio gateway s3bmux http://localhost:9001
