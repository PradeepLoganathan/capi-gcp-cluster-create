#login to GCP
gcloud auth login

export projectid=$(gcloud info --format=json --format=json | jq '.config.project' | tr -d '"')

gcloud iam service-accounts create pradeepsvcac

gcloud projects add-iam-policy-binding $projectid --member="serviceAccount:pradeepsvcac@${projectid}.iam.gserviceaccount.com" --role="roles/owner"


export GCP_B64ENCODED_CREDENTIALS=$( cat ~/.gcp/pradeepl-svc-key.json | base64 | tr -d '\n' )

❯ kind create cluster --name gcpcluster
# Creating cluster "gcpcluster" ...
#  ✓ Ensuring node image (kindest/node:v1.21.1) 🖼 
#  ✓ Preparing nodes 📦  
#  ✓ Writing configuration 📜 
#  ✓ Starting control-plane 🕹️ 
#  ✓ Installing CNI 🔌 
#  ✓ Installing StorageClass 💾 
# Set kubectl context to "kind-gcpcluster"
# You can now use your cluster with:

# kubectl cluster-info --context kind-gcpcluster

# Thanks for using kind! 😊

❯ kubectl get pods -A
# NAMESPACE            NAME                                               READY   STATUS    RESTARTS   AGE
# kube-system          coredns-558bd4d5db-bqn7w                           1/1     Running   0          30s
# kube-system          coredns-558bd4d5db-djgh2                           1/1     Running   0          30s
# kube-system          etcd-gcpcluster-control-plane                      1/1     Running   0          41s
# kube-system          kindnet-j9mc6                                      1/1     Running   0          31s
# kube-system          kube-apiserver-gcpcluster-control-plane            1/1     Running   0          41s
# kube-system          kube-controller-manager-gcpcluster-control-plane   1/1     Running   0          48s
# kube-system          kube-proxy-fcrrr                                   1/1     Running   0          31s
# kube-system          kube-scheduler-gcpcluster-control-plane            1/1     Running   0          41s
# local-path-storage   local-path-provisioner-547f784dff-mfvrt            1/1     Running   0          30s

 clusterctl init --infrastructure gcp

#  Fetching providers
# Installing cert-manager Version="v1.5.3"
# Waiting for cert-manager to be available...
# Installing Provider="cluster-api" Version="v1.0.2" TargetNamespace="capi-system"
# Installing Provider="bootstrap-kubeadm" Version="v1.0.2" TargetNamespace="capi-kubeadm-bootstrap-system"
# Installing Provider="control-plane-kubeadm" Version="v1.0.2" TargetNamespace="capi-kubeadm-control-plane-system"
# I1209 15:51:55.012459   17400 request.go:665] Waited for 1.029008849s due to client-side throttling, not priority and fairness, request: GET:https://127.0.0.1:32885/apis/node.k8s.io/v1?timeout=30s
# Installing Provider="infrastructure-gcp" Version="v1.0.0" TargetNamespace="capg-system"

# Your management cluster has been initialized successfully!

# You can now create your first workload cluster by running the following:

#   clusterctl generate cluster [name] --kubernetes-version [version] | kubectl apply -f -

❯ kubectl get pods -A
# NAMESPACE                           NAME                                                           READY   STATUS    RESTARTS   AGE
# capg-system                         capg-controller-manager-55f88499b-sfcxz                        0/1     Running   0          19s
# capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-b7cb4df8b-h42pr      1/1     Running   0          23s
# capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-cf88668b-q2wxh   1/1     Running   0          21s
# capi-system                         capi-controller-manager-6849b49bbb-ldp7s                       1/1     Running   0          24s
# cert-manager                        cert-manager-848f547974-6cjnb                                  1/1     Running   0          51s
# cert-manager                        cert-manager-cainjector-54f4cc6b5-kwfxw                        1/1     Running   0          51s
# cert-manager                        cert-manager-webhook-7c9588c76-kbvdf                           1/1     Running   0          51s
# kube-system                         coredns-558bd4d5db-bqn7w                                       1/1     Running   0          119s
# kube-system                         coredns-558bd4d5db-djgh2                                       1/1     Running   0          119s
# kube-system                         etcd-gcpcluster-control-plane                                  1/1     Running   0          2m10s
# kube-system                         kindnet-j9mc6                                                  1/1     Running   0          2m
# kube-system                         kube-apiserver-gcpcluster-control-plane                        1/1     Running   0          2m10s
# kube-system                         kube-controller-manager-gcpcluster-control-plane               1/1     Running   0          2m17s
# kube-system                         kube-proxy-fcrrr                                               1/1     Running   0          2m
# kube-system                         kube-scheduler-gcpcluster-control-plane                        1/1     Running   0          2m10s
# local-path-storage                  local-path-provisioner-547f784dff-mfvrt                        1/1     Running   0          119s


# Name of the GCP datacenter location. Change this value to your desired location
export GCP_REGION="australia-southeast1"
export GCP_PROJECT=$projectid
# Make sure to use same kubernetes version here as building the GCE image
export KUBERNETES_VERSION=1.20.9
export GCP_CONTROL_PLANE_MACHINE_TYPE=n1-standard-2
export GCP_NODE_MACHINE_TYPE=n1-standard-2
export GCP_NETWORK_NAME="pradeep-clstr-ntwrk"
export CLUSTER_NAME="pradeepl-gcp-clstr"
export IMAGE_ID="gcr.io/google-containers/pause-amd64:3.1"

clusterctl generate cluster capi-quickstart \
  --kubernetes-version v1.23.0 \
  --control-plane-machine-count=1 \
  --worker-machine-count=1 \
  > pradeepl-cluster.yaml


  clusterctl generate cluster pradeepl-gcp-cluster \
  --kubernetes-version v1.23.0 \
  --control-plane-machine-count=1 \
  --worker-machine-count=1 \
  > pradeepl-gcp-cluster.yaml

> cat pradeepl-cluster.yaml
# apiVersion: cluster.x-k8s.io/v1beta1
# kind: Cluster
# metadata:
#   name: pradeepl-gcp-cluster
#   namespace: default
# spec:
#   clusterNetwork:
#     pods:
#       cidrBlocks:
#       - 192.168.0.0/16
#   controlPlaneRef:
#     apiVersion: controlplane.cluster.x-k8s.io/v1beta1
#     kind: KubeadmControlPlane
#     name: pradeepl-gcp-cluster-control-plane
#   infrastructureRef:
#     apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
#     kind: GCPCluster
#     name: pradeepl-gcp-cluster
# ---
# apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
# kind: GCPCluster
# metadata:
#   name: pradeepl-gcp-cluster
#   namespace: default
# spec:
#   network:
#     name: pradeep-clstr-ntwrk
#   project: pradeepl-sandbox
#   region: australia-southeast1
# ---
# apiVersion: controlplane.cluster.x-k8s.io/v1beta1
# kind: KubeadmControlPlane
# metadata:
#   name: pradeepl-gcp-cluster-control-plane
#   namespace: default
# spec:
#   kubeadmConfigSpec:
#     clusterConfiguration:
#       apiServer:
#         extraArgs:
#           cloud-provider: gce
#         timeoutForControlPlane: 20m
#       controllerManager:
#         extraArgs:
#           allocate-node-cidrs: "false"
#           cloud-provider: gce
#     initConfiguration:
#       nodeRegistration:
#         kubeletExtraArgs:
#           cloud-provider: gce
#         name: '{{ ds.meta_data.local_hostname.split(".")[0] }}'
#     joinConfiguration:
#       nodeRegistration:
#         kubeletExtraArgs:
#           cloud-provider: gce
#         name: '{{ ds.meta_data.local_hostname.split(".")[0] }}'
#   machineTemplate:
#     infrastructureRef:
#       apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
#       kind: GCPMachineTemplate
#       name: pradeepl-gcp-cluster-control-plane
#   replicas: 1
#   version: v1.23.0
# ---
# apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
# kind: GCPMachineTemplate
# metadata:
#   name: pradeepl-gcp-cluster-control-plane
#   namespace: default
# spec:
#   template:
#     spec:
#       image: gcr.io/google-containers/pause-amd64:3.1
#       instanceType: n1-standard-2
# ---
# apiVersion: cluster.x-k8s.io/v1beta1
# kind: MachineDeployment
# metadata:
#   name: pradeepl-gcp-cluster-md-0
#   namespace: default
# spec:
#   clusterName: pradeepl-gcp-cluster
#   replicas: 1
#   selector:
#     matchLabels: null
#   template:
#     spec:
#       bootstrap:
#         configRef:
#           apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
#           kind: KubeadmConfigTemplate
#           name: pradeepl-gcp-cluster-md-0
#       clusterName: pradeepl-gcp-cluster
#       failureDomain: australia-southeast1-a
#       infrastructureRef:
#         apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
#         kind: GCPMachineTemplate
#         name: pradeepl-gcp-cluster-md-0
#       version: v1.23.0
# ---
# apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
# kind: GCPMachineTemplate
# metadata:
#   name: pradeepl-gcp-cluster-md-0
#   namespace: default
# spec:
#   template:
#     spec:
#       image: gcr.io/google-containers/pause-amd64:3.1
#       instanceType: n1-standard-2
# ---
# apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
# kind: KubeadmConfigTemplate
# metadata:
#   name: pradeepl-gcp-cluster-md-0
#   namespace: default
# spec:
#   template:
#     spec:
#       joinConfiguration:
#         nodeRegistration:
#           kubeletExtraArgs:
#             cloud-provider: gce
#           name: '{{ ds.meta_data.local_hostname.split(".")[0] }}'


kubectl apply -f pradeepl-gcp-cluster.yaml 

# cluster.cluster.x-k8s.io/pradeepl-gcp-cluster created
# gcpcluster.infrastructure.cluster.x-k8s.io/pradeepl-gcp-cluster created
# kubeadmcontrolplane.controlplane.cluster.x-k8s.io/pradeepl-gcp-cluster-control-plane created
# gcpmachinetemplate.infrastructure.cluster.x-k8s.io/pradeepl-gcp-cluster-control-plane created
# machinedeployment.cluster.x-k8s.io/pradeepl-gcp-cluster-md-0 created
# gcpmachinetemplate.infrastructure.cluster.x-k8s.io/pradeepl-gcp-cluster-md-0 created
# kubeadmconfigtemplate.bootstrap.cluster.x-k8s.io/pradeepl-gcp-cluster-md-0 created

kubectl get cluster
# NAME                   PHASE          AGE   VERSION
# pradeepl-gcp-cluster   Provisioned   54s 


clusterctl describe cluster pradeepl-gcp-cluster

# NAME                                                                               READY  SEVERITY  REASON                           SINCE  MESSAGE                                                      
# /pradeepl-gcp-cluster                                                              False  Warning   ScalingUp                        25s    Scaling up control plane to 1 replicas (actual 0)            
# ├─ClusterInfrastructure - GCPCluster/pradeepl-gcp-cluster                                                                                                                                                
# ├─ControlPlane - KubeadmControlPlane/pradeepl-gcp-cluster-control-plane            False  Warning   ScalingUp                        25s    Scaling up control plane to 1 replicas (actual 0)            
# │ └─Machine/pradeepl-gcp-cluster-control-plane-6v8lx                               False  Info      WaitingForInfrastructure         35s    1 of 2 completed                                             
# │   └─MachineInfrastructure - GCPMachine/pradeepl-gcp-cluster-control-plane-5xlpq                                                                                                                        
# └─Workers                                                                                                                                                                                                
#   └─MachineDeployment/pradeepl-gcp-cluster-md-0                                    False  Warning   WaitingForAvailableMachines      112s   Minimum availability requires 1 replicas, current 0 available
#     └─Machine/pradeepl-gcp-cluster-md-0-79dd48f5bc-rzl4g                           False  Info      WaitingForInfrastructure         111s   0 of 2 completed                                             
#       ├─BootstrapConfig - KubeadmConfig/pradeepl-gcp-cluster-md-0-7gpjq            False  Info      WaitingForControlPlaneAvailable  36s                                                                 
#       └─MachineInfrastructure - GCPMachine/pradeepl-gcp-cluster-md-0-rz6kt  


kubectl get kubeadmcontrolplane
# NAME                                 CLUSTER                INITIALIZED   API SERVER AVAILABLE   REPLICAS   READY   UPDATED   UNAVAILABLE   AGE     VERSION
# pradeepl-gcp-cluster-control-plane   pradeepl-gcp-cluster                                        1                  1         1             3m57s   v1.23.0   

# The control plane won’t be Ready until we install a CNI in the next step.
# retrieve the workload cluster Kubeconfig
clusterctl get kubeconfig pradeepl-gcp-cluster > pradeepl-gcp-cluster.kubeconfig


#Deploy the CNI solution. CALICO is used here
kubectl --kubeconfig=./pradeepl-gcp-cluster.kubeconfig \
  apply -f https://docs.projectcalico.org/v3.21/manifests/calico.yaml


gcloud compute project-info describe --project pradeepl-sandbox