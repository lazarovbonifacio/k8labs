# Cargas de trabalho

## Acesso

- NGINX Ingress Controller: `helm install -n ingress-system --create-namespace this oci://ghcr.io/nginx/charts/nginx-ingress --version 2.1.0`
- ExternalDNS:
    ```bash
    $ helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
    $ helm install this external-dns/external-dns -n dns --create-namespace --version 1.14.5
    ```
- Cloudflare Tunnel:
    ```bash
    $ helm repo add community-charts https://community-charts.github.io/helm-charts
    $ helm install this community-charts/cloudflared -f cloudflared-values.yml -n tunneling --create-namespace --version 2.0.7
    ```
    - https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deployment-guides/kubernetes/#_top
    - https://artifacthub.io/packages/helm/community-charts/cloudflared

## Segurança

- Cert-Manager:
    ```bash
    $ helm repo add jetstack https://charts.jetstack.io --force-update
    $ helm install this jetstack/cert-manager -f cert-manager-values.yml --namespace cert-manager --create-namespace --version v1.18.0
    ```
