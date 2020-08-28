#!/bin/bash

echo "Creating GKE cluster"
CLUSTER_NAME="k8s-nginx"
ZONE="europe-west2-b"
DEPLOY_NAME=$1
NAMESPACE=$2

echo "Deployment: $1 , Namespace:$2"

gcloud container clusters create $CLUSTER_NAME \
    --num-nodes=3 \
    --machine-type=n1-standard-1 \
    --zone=$ZONE
	
echo "Creating Service"

cat "ng-svc.yaml" | sed "s/{{NAMESPACE}}/$NAMESPACE/g"

kubectl create -f ng-svc.yaml

NODEPORT = kubectl get svc -n $NAMESPACE | grep nginx-svc | awk '{print $5}' | cut -d ':' -f 2 | cut -d '/' -f 1
#SVCIP = kubectl get svc -n $NAMESPACE | grep nginx-svc | awk '{print $3}'

# echo "Creating Ingress"

# cat "ng-ingress.yaml" | sed "s/{{NODEPORT}}/$NODEPORT/g"

# kubectl create -f ng-ingress.yaml

cat "ng-deploy.yaml" | sed "s/{{DEPLOY_NAME}}/$DEPLOY_NAME/g"

kubectl create -f ng-deploy.yaml
