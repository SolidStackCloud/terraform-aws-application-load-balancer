# Application Load Balancer Module

Este módulo Terraform cria um Application Load Balancer (ALB) na AWS com listeners HTTP/HTTPS e security group configurado.

## Recursos Criados

- Application Load Balancer
- Security Group com regras de entrada e saída
- Listener HTTPS (porta 443) com certificado SSL
- Listener HTTP (porta 80) com redirecionamento para HTTPS

## Uso

```hcl
module "application_loadbalancer" {
  source = "./modules/application-loadbalancer"

  project_name    = "meu-projeto"
  vpc_id          = "vpc-12345678"
  public_subnets  = ["subnet-12345678", "subnet-87654321"]
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| `project_name` | Nome do projeto usado nas tags | `string` | - | Sim |
| `vpc_id` | ID da VPC | `string` | `""` | Sim |
| `public_subnets` | Lista de IDs das subnets públicas | `list(string)` | `[]` | Sim |
| `certificate_arn` | ARN do certificado SSL/TLS | `string` | `""` | Sim |
| `internal` | Se o ALB é interno | `bool` | `false` | Não |
| `enable_deletion_protection` | Habilitar proteção contra deleção | `bool` | `false` | Não |
| `ssl_policy` | Política SSL do listener HTTPS | `string` | `"ELBSecurityPolicy-TLS13-1-2-Res-2021-06"` | Não |
| `access_logs` | Configuração de logs de acesso | `object` | Ver abaixo | Não |
| `ingress_rules_ipv4` | Regras de entrada IPv4 | `list(object)` | HTTP/HTTPS | Não |
| `ingress_rules_ipv6` | Regras de entrada IPv6 | `list(object)` | HTTP/HTTPS | Não |
| `alb_fixed_response` | Resposta padrão do ALB | `object` | 404 Not Found | Não |

### Configuração de Access Logs

```hcl
access_logs = {
  access_logs_bucket = "meu-bucket-logs"
  access_logs_prefix = "alb-logs/"
  enable_access_logs = true
}
```

### Regras de Ingress Customizadas

```hcl
ingress_rules_ipv4 = [
  {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "10.0.0.0/8"
    description = "HTTP interno"
  }
]
```

## Outputs

| Nome | Descrição |
|------|-----------|
| `listener_arn` | ARN do listener HTTPS |

## Exemplo Completo

```hcl
module "application_loadbalancer" {
  source = "./modules/application-loadbalancer"

  project_name                = "minha-aplicacao"
  vpc_id                     = "vpc-12345678"
  public_subnets             = ["subnet-12345678", "subnet-87654321"]
  certificate_arn            = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  enable_deletion_protection = true
  
  access_logs = {
    access_logs_bucket = "meu-bucket-logs"
    access_logs_prefix = "alb-logs/"
    enable_access_logs = true
  }

  alb_fixed_response = {
    type         = "fixed-response"
    content_type = "text/html"
    message_body = "<h1>Serviço Indisponível</h1>"
    status_code  = "503"
  }
}
```

## Pré-requisitos

- VPC configurada
- Subnets públicas
- Certificado SSL/TLS no AWS Certificate Manager
- Bucket S3 (se logs de acesso estiverem habilitados)
