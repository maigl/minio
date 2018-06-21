# Federation Quickstart Guide [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)
This document explains how to configure Minio with `Bucket lookup from DNS` style federation.

## Get started

### 1. Prerequisites
Install Minio - [Minio Quickstart Guide](https://docs.minio.io/docs/minio).

### 2. Run Minio in federated mode
Bucket lookup from DNS federation requires two dependencies

- etcd (for config, bucket SRV records)
- coredns (for DNS management based on populated bucket SRV records, optional)

## Architecture

![bucket-lookup](https://github.com/minio/minio/blob/master/docs/federation/lookup/bucket-lookup.png?raw=true)

### Environment variables

#### MINIO_ETCD_ENDPOINTS

This is comma separated list of etcd servers that you want to use as the Minio federation back-end. This should
be same across the federated deployment, i.e. all the Minio instances within a federated deployment should use same
etcd back-end.

#### MINIO_DOMAIN

This is the top level domain name used for the federated setup. This domain name should ideally resolve to a load-balancer
running in front of all the federated Minio instances. The domain name is used to create sub domain entries to etcd. For
example, if the domain is set to `domain.com`, the buckets `bucket1`, `bucket2` will be accessible as `bucket1.domain.com`
and `bucket2.domain.com`.

#### MINIO_PUBLIC_IPS

This is comma separated list of IP addresses to which buckets created on this Minio instance will resolve to. For example,
a bucket `bucket1` created on current Minio instance will be accessible as `bucket1.domain.com`, and the DNS entry for
`bucket1.domain.com` will point to IP address set in `MINIO_PUBLIC_IPS`.

*Note*

- This field is mandatory for standalone and erasure code Minio server deployments, to enable federated mode.
- This field is optional for distributed deployments. If you don't set this field in a federated setup, we use the IP addresses of
hosts passed to the Minio server startup and use them for DNS entries.

### Run Multiple Clusters

> cluster1

```sh
export MINIO_ETCD_ENDPOINTS="http://remote-etcd1:2379,http://remote-etcd2:4001"
export MINIO_DOMAIN=domain.com
export MINIO_PUBLIC_IPS=44.35.2.1,44.35.2.2,44.35.2.3,44.35.2.4
minio server http://rack{1...4}.host{1...4}.domain.com/mnt/export{1...32}
```

> cluster2

```sh
export MINIO_ETCD_ENDPOINTS="http://remote-etcd1:2379,http://remote-etcd2:4001"
export MINIO_DOMAIN=domain.com
export MINIO_PUBLIC_IPS=44.35.1.1,44.35.1.2,44.35.1.3,44.35.1.4
minio server http://rack{5...8}.host{5...8}.domain.com/mnt/export{1...32}
```

In this configuration you can see `MINIO_ETCD_ENDPOINTS` points to the etcd backend which manages Minio's
`config.json` and bucket DNS SRV records. `MINIO_DOMAIN` indicates the domain suffix for the bucket which
will be used to resolve bucket through DNS. For example if you have a bucket such as `mybucket`, the
client can use now `mybucket.domain.com` to directly resolve itself to the right cluster. `MINIO_PUBLIC_IPS`
points to the public IP address where each cluster might be accessible, this is unique for each cluster.

NOTE: `mybucket` only exists on one cluster either `cluster1` or `cluster2` this is random and
is decided by how `domain.com` gets resolved, if there is a round-robin DNS on `domain.com` then
it is randomized which cluster might provision the bucket.

### 3. Test your setup
To test this setup, access the Minio server via browser or [`mc`](https://docs.minio.io/docs/minio-client-quickstart-guide). You’ll see the uploaded files are accessible from the all the Minio endpoints.

# Explore Further
- [Use `mc` with Minio Server](https://docs.minio.io/docs/minio-client-quickstart-guide)
- [Use `aws-cli` with Minio Server](https://docs.minio.io/docs/aws-cli-with-minio)
- [Use `s3cmd` with Minio Server](https://docs.minio.io/docs/s3cmd-with-minio)
- [Use `minio-go` SDK with Minio Server](https://docs.minio.io/docs/golang-client-quickstart-guide)
- [The Minio documentation website](https://docs.minio.io)