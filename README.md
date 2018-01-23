## Description
This repo consists of a few scripts. They allow to build docker image and to run test jobs in container.

## Steps

1. Make sure docker is installed
2. Clone this repository
3. Go to the root of repo
4. Build docker image ('docker build -f dockerfile -t ubuntu_14.04:01 .')
5. Make sure image was created ('docker images')
There should be the following:
	REPOSITORY          TAG
	ubuntu_14.04        01
6. Get back to the root of the repo and go to 'jobs' folder
7. Create 'reports' sub-folder
8. Run any job (ex. 'dev_smoke.sh')
