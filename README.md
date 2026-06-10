# simple-app

Test repository that deploys a dummy app (podinfo) into a local Kubernetes cluster via Flux CD. Intended to be spun up for testing and torn down when done.

## Prerequisites

- A local Kubernetes cluster with `sandpit` kubectl context configured — use [uzubtsou/lean-k8s](https://github.com/uzubtsou/lean-k8s) to spin one up
- [Flux CLI](https://fluxcd.io/flux/installation/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- DNS wildcard `*.sand.pit.im` pointing to `127.0.0.1`

## Cluster setup

### 1. Create the test cluster

Use [lean-k8s](https://github.com/uzubtsou/lean-k8s) to create a cluster with all required components:

```bash
just up
just mesh
just progressive flagger
just gitops flux-operator
```

This installs Istio, Flagger, and Flux Operator with all required CRDs and the `sandpit` Gateway.

## Deploy the app

Apply the Flux resources:

```bash
kubectl apply -k flux/
```

Flux will reconcile and deploy the app into the `dev` and `qa` namespaces. Watch progress:

```bash
flux get kustomizations --watch
```

## URLs

Once all kustomizations are `Ready`:

### dev

- <http://dev-info.sand.pit.im>
- <http://dev-backend-info.sand.pit.im>
- <http://dev-rset.sand.pit.im> (ResourceSet)

### qa

- <http://qa-info.sand.pit.im>
- <http://qa-backend-info.sand.pit.im>
- <http://qa-rset.sand.pit.im> (ResourceSet)

## Teardown

```bash
kubectl delete -k flux/
```
