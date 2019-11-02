#!/usr/bin/env bash

docker run -e SERVER_ENDPOINT=localhost:9000 \
        -e ACCESS_KEY=minioadmin \
        -e SECRET_KEY=minioadmin \
        -e ENABLE_HTTPS=0 \
        --net=host \
        minio/mint awscli healthcheck mc minio-dotnet minio-go minio-java minio-js s3cmd security
#        minio/mint aws-sdk-go aws-sdk-java  aws-sdk-ruby awscli healthcheck mc minio-dotnet minio-go minio-java minio-js s3cmd security
#        minio/mint aws-sdk-go aws-sdk-java aws-sdk-php aws-sdk-ruby awscli healthcheck mc minio-dotnet minio-go minio-java minio-js s3cmd security worm

