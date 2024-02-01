Install Kubernetes Ingress Controller per K2view Specifications

Following Helm chart Utilizes 3 Sub charts


1. for deploying nginx-ingress controller on aws
2. for deploying nginx-ingress controller on gcp

3. for deploying nginx-ingress controller Custom Errors - (Not Cloud specific)
    Things to keep in mind:
        place your fullchain.pem/crt and privkey.pem./cert in Additionals Directory Located in the subchart directory