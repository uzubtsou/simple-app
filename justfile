default:
    @just --list

[private]
_render path:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "${BRANCH:-}" =~ ^[A-Za-z0-9._/-]+$ ]] || { echo "A branch named with letters, numbers, '.', '_', '/', or '-' must be checked out." >&2; exit 1; }
    kubectl kustomize "{{ path }}" | sed -E "s#^([[:space:]]*(branch|targetRevision): )main\$#\1${BRANCH}#"

[private]
_apply path:
    #!/usr/bin/env bash
    set -euo pipefail
    export BRANCH="$(git branch --show-current)"
    just --quiet _render "{{ path }}" | kubectl --context sandpit apply -f -

check:
    @just --fmt --check
    @test "$(BRANCH=feature/test just --quiet _render flux | grep -c 'branch: feature/test')" -eq 1
    @test "$(BRANCH=feature/test just --quiet _render argocd | grep -c 'targetRevision: feature/test')" -eq 3

dev-urls:
    @echo
    @echo "dev URLs:"
    @echo http://dev-info.sand.pit.im
    @echo http://dev-backend-info.sand.pit.im

qa-urls:
    @echo
    @echo "qa URLs:"
    @echo http://qa-info.sand.pit.im
    @echo http://qa-backend-info.sand.pit.im

prod-urls:
    @echo
    @echo "prod URLs:"
    @echo http://prod-info.sand.pit.im
    @echo http://prod-backend-info.sand.pit.im

argocd-dev-urls:
    @echo
    @echo "argocd dev URLs:"
    @echo http://argocd-dev-info.sand.pit.im
    @echo http://argocd-dev-backend-info.sand.pit.im

argocd-qa-urls:
    @echo
    @echo "argocd qa URLs:"
    @echo http://argocd-qa-info.sand.pit.im
    @echo http://argocd-qa-backend-info.sand.pit.im

argocd-prod-urls:
    @echo
    @echo "argocd prod URLs:"
    @echo http://argocd-prod-info.sand.pit.im
    @echo http://argocd-prod-backend-info.sand.pit.im

flux-dev: (_apply "flux/dev")
    @just dev-urls

flux-qa: (_apply "flux/qa")
    @just qa-urls

flux-prod: (_apply "flux/prod")
    @just prod-urls

flux: (_apply "flux")
    @just dev-urls
    @just qa-urls
    @just prod-urls

argocd-dev: (_apply "argocd/dev")
    @just argocd-dev-urls

argocd-qa: (_apply "argocd/qa")
    @just argocd-qa-urls

argocd-prod: (_apply "argocd/prod")
    @just argocd-prod-urls

argocd: (_apply "argocd")
    @just argocd-dev-urls
    @just argocd-qa-urls
    @just argocd-prod-urls
