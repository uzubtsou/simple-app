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

For Flux, install the Flux CD controllers.

For Argo CD, install Argo CD in the `argocd` namespace. Both options use Istio and the `sandpit` Gateway.

## Deploy with Flux

Push the branch you want Flux to reconcile, then apply all environments:

```bash
git push -u origin HEAD
just flux
```

`just flux` renders the checked-out branch into the Flux `GitRepository` and
always applies through the `sandpit` kubectl context.

Apply one environment only:

```bash
just flux-dev
just flux-qa
just flux-prod
```

Flux will reconcile and deploy frontend and backend into the `dev`, `qa`, and `prod` namespaces. Watch progress:

```bash
flux get kustomizations --watch
```

## URLs

Once all kustomizations are `Ready`:

### dev

- <http://dev-info.sand.pit.im>
- <http://dev-backend-info.sand.pit.im>

### qa

- <http://qa-info.sand.pit.im>
- <http://qa-backend-info.sand.pit.im>

### prod

- <http://prod-info.sand.pit.im>
- <http://prod-backend-info.sand.pit.im>

## Teardown

```bash
kubectl --context sandpit delete -k flux/
```

## Try Kargo promotions

With Kargo and the Flux environments running, apply the standalone Kargo demo:

```bash
kubectl --context sandpit apply -k kargo
```

Open <http://kargo.sand.pit.im> and select the `simple-app` project. Promote a
Freight item to `dev`, then promote it from `dev` to `qa` and `prod`. See
[kargo/README.md](kargo/README.md) for the scope of this initial demo.

## Deploy with Argo CD

With Argo CD installed in the `argocd` namespace, push the checked-out branch
and apply all environment-specific ApplicationSets:

```bash
git push -u origin HEAD
just argocd
```

`just argocd` renders the checked-out branch into each Git source and always
applies through the `sandpit` kubectl context.

Apply one environment only:

```bash
just argocd-dev
just argocd-qa
just argocd-prod
```

Watch reconciliation:

```bash
kubectl get applications -n argocd --watch
```

The generated `simple-app-dev`, `simple-app-qa`, and `simple-app-prod` Applications deploy alongside Flux in the same namespaces. Their resources and URLs use an `argocd-` prefix to avoid collisions:

- <http://argocd-dev-info.sand.pit.im>
- <http://argocd-dev-backend-info.sand.pit.im>
- <http://argocd-qa-info.sand.pit.im>
- <http://argocd-qa-backend-info.sand.pit.im>
- <http://argocd-prod-info.sand.pit.im>
- <http://argocd-prod-backend-info.sand.pit.im>

### Argo CD teardown

```bash
kubectl --context sandpit delete -k argocd/
```
