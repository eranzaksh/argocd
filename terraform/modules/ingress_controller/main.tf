resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version = "4.7.1"
  create_namespace = true

  values = [
    <<EOF
    controller:
      service:
        type: LoadBalancer
    EOF
  ]
}

data "kubernetes_service" "nginx_ingress_lb" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "ingress-nginx"
  }
}
