default:
    @just --list

flux-dev:
    kubectl apply -k flux/dev/
    @echo http://dev-info.sand.pit.im
    @echo http://dev-backend-info.sand.pit.im

flux-qa:
    kubectl apply -k flux/qa/
    @echo http://qa-info.sand.pit.im
    @echo http://qa-backend-info.sand.pit.im

flux:
    kubectl apply -k flux/
    @echo http://dev-info.sand.pit.im
    @echo http://dev-backend-info.sand.pit.im
    @echo http://qa-info.sand.pit.im
    @echo http://qa-backend-info.sand.pit.im

argocd-dev:
    kubectl apply -k argocd/dev/
    @echo http://argocd-dev-info.sand.pit.im
    @echo http://argocd-dev-backend-info.sand.pit.im

argocd-qa:
    kubectl apply -k argocd/qa/
    @echo http://argocd-qa-info.sand.pit.im
    @echo http://argocd-qa-backend-info.sand.pit.im

argocd:
    kubectl apply -k argocd/
    @echo http://argocd-dev-info.sand.pit.im
    @echo http://argocd-dev-backend-info.sand.pit.im
    @echo http://argocd-qa-info.sand.pit.im
    @echo http://argocd-qa-backend-info.sand.pit.im
