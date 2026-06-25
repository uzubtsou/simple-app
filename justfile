default:
    @just --list

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

flux-dev:
    kubectl apply -k flux/dev/
    @just dev-urls

flux-qa:
    kubectl apply -k flux/qa/
    @just qa-urls

flux:
    kubectl apply -k flux/
    @just dev-urls
    @just qa-urls

argocd-dev:
    kubectl apply -k argocd/dev/
    @just argocd-dev-urls

argocd-qa:
    kubectl apply -k argocd/qa/
    @just argocd-qa-urls

argocd:
    kubectl apply -k argocd/
    @just argocd-dev-urls
    @just argocd-qa-urls
