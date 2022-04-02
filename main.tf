data "aws_vpc" "vpc-default" {
  id = "vpc-960e73eb"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211021"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }
}

resource "aws_key_pair" "kubernetes" {
  key_name   = "kubernetes"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxc3egVA9auVVOlZM95CFdMM3OVVKwPJxHI3QVHAuLGbNnPZ7bytwgdJ9QGMZ9HuOsSlEFItXaAf8hL6CzoQmOK8uTh6AeSIiPgxYYbuJlt03XLMKl/zWC/B/IRmRbsKMijNbsVIJ6Dc3LWtW9tui0ss7KCuWU5LJviiOzkPj58V8LK0TvbdbD3pR9+TgX+qbgFTPrjmUEOPAydobuU5C3wb4cbzwxf7KVt3bCDRrQxgfs8M1XJaz1An+hGkp12eupOnwYHFZ+0FadxflwC5E+4H2+lGTeobm9q/gnpc9pkAhOzYLWmm48LHsRqTW/NwOoCHm/cdAMapqELNfScNd59uEEyGX9cb7CJ55hVE0mIw4JMsruazY/LefcuZx2Hcmn1OulexNvczo74Og/unJY+J5Aq7K0G/+XKb942n9o6v6itiisNuYpXVpErrhZOXLSbT6gGfuYN8svHizvhkMkrELvaBmlpEQSlnGusd8eVxJ7nRuF/PwL8ZcD0t40GfE= carloscoppa@Carlos-Coppa"
}

resource "aws_instance" "kubernetes-cluster" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.kubernetes.key_name
  vpc_security_group_ids = count.index == 0 ? [aws_security_group.sg-master-node.id] : [aws_security_group.sg-worker-node.id]
  user_data              = count.index == 0 ? templatefile(abspath("${path.root}/user_data_master.yaml"), {}) : templatefile(abspath("${path.root}/user_data_worker.yaml"), {})


  tags = {
    Name = count.index == 0 ? "Master-node" : "Worker-node-${count.index}"

    #"%{if count.index == 0}Master-node%{else}Worker-node${count.index}%{endif}"
  }
}
