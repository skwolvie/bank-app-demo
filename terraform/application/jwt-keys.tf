resource "tls_private_key" "jwt" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "kubernetes_secret" "jwt_key" {
  metadata {
    name = "jwt-key"
    /*
    labels = {
      app         = "userservice"
      application = "bank-of-anthos"
      environment = "development"
      team        = "accounts"
      tier        = "backend"
    }
    */
  }

  data = {
    "jwtRS256.key"     = tls_private_key.jwt.private_key_pem
    "jwtRS256.key.pub" = tls_private_key.jwt.public_key_pem
  }

  type = "Opaque"
}

