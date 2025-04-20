#!/bin/bash
basedir=/mnt/repos
CF="$basedir/.credentials.txt"
greencolor='\033[0;32m'
nocolor='\033[0m'
source "$CF"
dockeruser=${DOCKERUSER}
dockerpass=${DOCKERPASS}
docker login --username="$dockeruser" --password="$dockerpass"
if [ -z $1 ];
then
	echo -e "${greencolor}No repository name given as parameter.${nocolor}"
	exit 0
else
	repo=$(echo $1 | cut -d':' -f1)
	if [[ $1 == *":"* ]]; then
		tag=$(echo $1 | cut -d':' -f2)
	else
		tag="latest"
	fi
	if [ -z $2 ]; then
		echo -e "${greencolor}leaving local images intact. use --purge-images as parameter 2 to remove them.${nocolor}"
	else
		if [[ $2 == "--purge-images" ]]; then
			docker images | grep "$repo" | awk '{print $1":"$2}' | xargs docker rmi
		else
			echo -e "${greencolor}leaving local images intact. use --purge-images as parameter 2 to remove them.${nocolor}"
		fi
	fi
	echo -e "${greencolor} (1/4) building $repo:$tag${nocolor}"
	docker build -t "$repo:$tag" .
	echo -e "${greencolor} (2/4) building $repo:$tag${nocolor}"
	docker build -t "$dockeruser/$repo:$tag" .
	echo -e "${greencolor} (3/4) building $repo:$tag${nocolor}"
	docker push "$dockeruser/$repo:$tag"
	echo -e "${greencolor} (4/4) building $repo:$tag${nocolor}"
	docker run 	--name="dockerhub-description" \
			-v $PWD:/workspace \
			-e DOCKERHUB_USERNAME="$dockeruser" \
			-e DOCKERHUB_PASSWORD="$dockerpass" \
			-e DOCKERHUB_REPOSITORY="$dockeruser/$repo" \
			-e README_FILEPATH='/workspace/README.md' \
			peterevans/dockerhub-description:latest
	docker rm dockerhub-description
fi