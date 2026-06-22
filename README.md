# simple-app

Test repository that deploys a dummy app (podinfo) into a local Kubernetes cluster via Flux CD or Argo CD. Intended to be spun up for testing and torn down when done.

## Prerequisites

- A local Kubernetes cluster with `sandpit` kubectl context configured — use [uzubtsou/lean-k8s](https://github.com/uzubtsou/lean-k8s) to spin one up
- [Flux CLI](https://fluxcd.io/flux/installation/) or [Argo CD](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [just](https://just.systems/)
- DNS wildcard `*.sand.pit.im` pointing to `127.0.0.1`

## Cluster setup

### 1. Create the test cluster

Use [lean-k8s](https://github.com/uzubtsou/lean-k8s) to create a cluster with the shared components:

```bash
just up
just mesh
```

For Flux, also install Flagger and Flux Operator:

```bash
just progressive
just gitops flux-operator
```

For Argo CD, install Argo CD in the `argocd` namespace. Both options use Istio and the `sandpit` Gateway.

## Deploy with Flux

Apply both Flux environments with either command:

```bash
kubectl apply -k flux/
# or
just flux
```

Apply one environment only:

```bash
kubectl apply -k flux/dev/ # or: just flux-dev
kubectl apply -k flux/qa/  # or: just flux-qa
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

With Argo CD installed in the `argocd` namespace, apply both environment-specific ApplicationSets with either command:

```bash
kubectl apply -k argocd/
# or
just argocd
```

Apply one environment only:

```bash
kubectl apply -k argocd/dev/ # or: just argocd-dev
kubectl apply -k argocd/qa/  # or: just argocd-qa
```

Watch reconciliation:

```bash
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
