resource "aws_security_group" "sg-master-node" {
  name        = "masterSecurityGroup"
  description = "Open the required ports for the Kubernetes cluster"
  vpc_id      = data.aws_vpc.vpc-default.id

  ingress = [
    {
      description      = "SSH Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["186.139.143.141/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTP Access"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["186.139.143.141/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Kubernetes API server"
      from_port        = 6443
      to_port          = 6443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "etcd server client API"
      from_port        = 2379
      to_port          = 2380
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Kubelet API"
      from_port        = 10250
      to_port          = 10250
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "kube-scheduler"
      from_port        = 10259
      to_port          = 10259
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "kube-controller-manager"
      from_port        = 10257
      to_port          = 10257
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "weave net plugin"
      from_port        = 6783
      to_port          = 6783
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "weave net plugin"
      from_port        = 6783
      to_port          = 6784
      protocol         = "udp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }

  ]

  egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Master-node-security-group"
  }
}

resource "aws_security_group" "sg-worker-node" {
  name        = "workerSecurityGroup"
  description = "Open the required ports for the Kubernetes cluster"
  vpc_id      = data.aws_vpc.vpc-default.id

  ingress = [
    {
      description      = "Kubelet API"
      from_port        = 10250
      to_port          = 10250
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "NodePort Services"
      from_port        = 30000
      to_port          = 32767
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["186.139.143.141/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "weave net plugin"
      from_port        = 6783
      to_port          = 6783
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "weave net plugin"
      from_port        = 6783
      to_port          = 6784
      protocol         = "udp"
      cidr_blocks      = [data.aws_vpc.vpc-default.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Worker-node-security-group"
  }
}