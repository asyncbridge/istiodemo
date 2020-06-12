#!/usr/bin/env bash

export PROJECT=synthetic-nova-278803
export CONTAINER_VERSION=jun13v1
export IMAGE=gcr.io/$PROJECT/petmedicalhistoryservice:$CONTAINER_VERSION
export BUILD_HOME=.

gcloud config set project $PROJECT
gcloud container clusters get-credentials aisland-cluster-1 --zone asia-northeast3-a --project $PROJECT

echo $IMAGE
docker build -t petmedicalhistoryservice -f "${PWD}/Dockerfile" $BUILD_HOME
echo 'Successfully built ' $IMAGE

docker tag petmedicalhistoryservice $IMAGE
echo 'Successfully tagged ' $IMAGE

#push to google container registry
docker -- push $IMAGE
echo 'Successfully pushed to Google Container Registry ' $IMAGE

# inject envoy proxy
kubectl apply -f <(istioctl kube-inject -f "${PWD}/kube/petinfo.yaml")
