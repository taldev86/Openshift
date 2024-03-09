



## Getting started


```

## Integrate with your tools
1- pull the git repo
2- change the access_key and secret_key in "openshift.tf" file
3- then run below commands
docker build -t my-terraform-image-5 .
docker run my-terraform-image-5 

## if docker container is shows exited then run
docker container start <container_ name>
## Now go to aws and check ec2 instnace and ssh to ec2 instnace
./openshift-install create cluster --dir=cluster
export KUBECONFIG=cluster/auth/kubeconfig
export CLUSTER_NAME=my-cluster
export BASE_DOMAIN=sandbox.acme.com
./adjust-single-node.sh
-