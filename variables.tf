variable "internal" {
  description = "Variavel utilizada para especificar se o recurso é do tipo Internal ou não."
  default     = false
  type        = bool
}
variable "project_name" {
  description = "Nome do projeto. Esse nome será utiliza como variável para outros recursos na tag Name"
  type        = string
}

variable "public_subnets" {
  description = "Lista de IDs das subnets públicas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
  default     = []
}

variable "privates_subnets" {
  description = "Lista de IDs das subnets privadas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
  default     = []
}
variable "enable_deletion_protection" {
  description = "Habilitar a proteção de deleção do recurso"
  type        = bool
  default     = false
}

variable "access_logs" {
  type = object({
    access_logs_bucket = string
    access_logs_prefix = string
    enable_access_logs = bool
  })
  description = "Configuração de logs de acesso para o Load Balancer."
  default = {
    access_logs_bucket = ""
    access_logs_prefix = ""
    enable_access_logs = false
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o serviço será implantado. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC. Usado para a regra de entrada do security group. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
  default     = ""
}

variable "ingress_rules_ipv4" {
  description = "Conjunto de regras de entrada para o Load Balancer. Cada item pode definir from_port, to_port, ip_protocol, e opcionalmente cidr_ipv4 e description."
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_ipv4   = string
    description = optional(string)
  }))
  default = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    },
    {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    }
  ]
}

variable "ingress_rules_ipv6" {
  description = "Conjunto de regras de entrada para o Load Balancer. Cada item pode definir from_port, to_port, ip_protocol, e opcionalmente cidr_ipv4 e description."
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_ipv6   = string
    description = optional(string)
  }))
  default = [
    {
      cidr_ipv6   = "::/0"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    },
    {
      cidr_ipv6   = "::/0"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    }
  ]
}
variable "ssl_policy" {
  description = "Variavel utilizada para especificar com a security policy do loadbalancer."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "certificate_arn" {
  description = "Utilize para especificar com o certificado será utilizado pelo listiner 443."
  type        = string
  default     = ""
}

variable "alb_message_body" {
  description = "Ajustar mensagem do ALB"
  type        = string
  default     = "Not Found"
}

variable "alb_fixed_response" {
  description = "Ajuste mensagem padrão do ALB"
  type = object(
    {
      type         = string
      content_type = string
      message_body = string
      status_code  = string
    }
  )

  default = {
    type         = "fixed-response"
    content_type = "text/plain"
    message_body = "Not Found"
    status_code  = "404"
  }
}