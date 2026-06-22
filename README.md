# simple-app

Test repository that deploys a dummy app (podinfo) into a local Kubernetes cluster via Flux CD or Argo CD. Intended to be spun up for testing and torn down when done.

## Prerequisites

- A local Kubernetes cluster with `sandpit` kubectl context configured — use [uzubtsou/lean-k8s](https://github.com/uzubtsou/lean-k8s) to spin one up
- [Flux CLI](https://fluxcd.io/flux/installation/) or [Argo CD](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- DNS wildcard `*.sand.pit.im` pointing to `127.0.0.1`

## Cluster setup

### 1. Create the test cluster

Use [lean-k8s](https://github.com/uzubtsou/lean-k8s) to create a cluster with the shared components:

```bash
just up
just mesh
just progressive
```

For Flux, also install Flux Operator:

```bash
just gitops flux-operator
```

For Argo CD, install Argo CD in the `argocd` namespace. Both options use Istio, Flagger, and the `sandpit` Gateway.

## Deploy with Flux

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

## Deploy with Argo CD

With Argo CD installed in the `argocd` namespace, apply the environment-specific ApplicationSets:

```bash
kubectl apply -k argocd/
kubectl get applications -n argocd --watch
```

The generated `simple-app-dev` and `simple-app-qa` Applications deploy alongside Flux in the same `dev` and `qa` namespaces. Their resources and URLs use an `argocd-` prefix to avoid collisions:

- <http://argocd-dev-info.sand.pit.im>
- <http://argocd-dev-backend-info.sand.pit.im>
- <http://argocd-qa-info.sand.pit.im>
- <http://argocd-qa-backend-info.sand.pit.im>

The Flux-only `ResourceSet` URLs are not created by Argo CD.

### Argo CD teardown

```bash
kubectl delete -k argocd/
```
