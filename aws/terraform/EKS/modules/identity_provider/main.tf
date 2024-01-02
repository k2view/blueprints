resource "aws_iam_openid_connect_provider" "oidc_provider" {
    url             = "${data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}"
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = ["${data.tls_certificate.tls.certificates.0.sha1_fingerprint}"]

    tags = {
        Name    = "${var.cluster_name}_deployer_identity_provider"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
}