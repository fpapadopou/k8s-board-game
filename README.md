## Board Game

A set of kubernetes HTTP [services](https://kubernetes.io/docs/concepts/services-networking/service) consisting of multiple boards and a client interacting with them.

The apps are deployed on [Google Cloud Platform Kubernetes Engine](https://console.cloud.google.com/kubernetes).


kubectl apply -f kube/controllers --dry-run=true # dry run apply all deployments

kubectl apply -f kube/controllers # update all deployments config

