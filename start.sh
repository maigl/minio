#!/usr/bin/env bash

export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
./minio gateway --address localhost:8080 s3bmux http://localhost:9000
