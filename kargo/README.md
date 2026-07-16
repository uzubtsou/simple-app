# Kargo promotion demo

This configuration creates a `simple-app` Kargo project with a `podinfo`
Warehouse and a manual `dev` to `qa` promotion pipeline.

Apply it after Kargo and the Flux application environments are running:

```bash
kubectl --context sandpit apply -k kargo
```

Open <http://kargo.sand.pit.im>, log in with the sandpit demo credentials
(`admin` / `admin`), and select the `simple-app` project. Promote a Freight
item to `dev` first, then promote the same item to `qa`. Each promotion checks
that the frontend in its corresponding environment is healthy.

This initial demo records which Helm chart Freight has reached each Stage. It
does not update the Flux configuration or change the deployed chart version.
Git-based version updates can be added later when write credentials and the
desired promotion workflow are decided.

Remove the demo with:

```bash
kubectl --context sandpit delete -k kargo
```
