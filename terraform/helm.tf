resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.0-beta.0"

  create_namespace = true
  namespace  = "ingress-nginx"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"

  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  version    = "8.6.1"

  create_namespace = true
  namespace  = "external-dns"

  set {
    name  = "provider"
    value = "google"
  }
  set {
    name  = "google.project"
    value = "${var.project}"
  }
  set {
    name  = "google.zoneVisibility"
    value = "public"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.16.2"

  create_namespace = true
  namespace  = "cert-manager"

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.7"

  create_namespace = true
  namespace  = "argocd"

  set {
    name  = "global.domain"
    value = "argocd.personal.arsalen.xyz"
  }
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/force-ssl-redirect"
    value = "true"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTP"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-passthrough"
    value = "true"
  }
  set {
    name  = "server.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }
  set {
    name  = "server.ingress.extraTls[0].hosts[0]"
    value = "argocd.personal.arsalen.xyz"
  }
  set {
    name  = "server.ingress.extraTls[0].secretName"
    value = "argocd-tls"
  }
}

resource "kubernetes_manifest" "clusterissuer_letsencrypt_prod" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "email" = "arsalen.hagui@hotmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
}