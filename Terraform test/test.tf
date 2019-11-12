resource "kubernetes_service" "Voting-app-services" {
  metadata {
    name = "voting-service"
    labels = {
      name = "voting-service"
      app = "demo-voting-app"
    }
  }
  spec {
    selector  {
      name = "${kubernetes_deployment.voting-app-deployment.spec.template.metadata.labels.0.app}"
      name = "${kubernetes_deployment.voting-app-deployment.spec.template.metadata.labels.0.name}"
    }
   # session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
      nodePort= 30009
    }

    type = "NodePort"
  }
}
#Deployment of voting App
resource "kubernetes_deployment" "voting-app-deployment" {
  metadata {
    name = "voting-app-deployment"
    labels = {
      app= "demo-voting-app"

    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        name= "voting-app-pod"
        app= "demo-voting-app"
      }
    }

    template {
      metadata {
        name= "voting-app-pod"
        labels = {
          name = "voting-app-pod"
          app = "demo-voting-app"
        }
      }

      spec {
        container {
          name= "voting-app"
          image= "dockersamples/examplevotingapp_vote"
          port {
            containerPort= 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

        }
      }
    }
  }
}