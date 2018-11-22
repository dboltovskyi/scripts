## Description
This repository consists of a few scripts. They allow to build docker image for testing with ATF

## Steps

1. Make sure docker is installed
2. Clone this repository
3. Go to the root of repo
4. Build docker image:
```
docker build -f dockerfile -t ubuntu_14.04:01 .
```
5. Make sure image was created:
```
docker images
```
There should be the following:
```
REPOSITORY          TAG
ubuntu_14.04        01
```
6. Run docker container:
```
start_14.04.sh
```

## Notes:
1. Steps are described for Ubuntu 14.04, but it's possible to build 16.04 as well
