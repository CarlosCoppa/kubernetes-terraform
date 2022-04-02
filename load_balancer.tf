# #Obtener dos subnets IDs de dos availability zones distintas de la VPC existente. La creación de un Loadbalancer requiere al menos dos availability zones.
# data "aws_subnet_ids" "test-subnet-ids" {
#   vpc_id = data.aws_vpc.vpc-default.id
#   filter {
#     name   = "availability-zone"
#     values = ["us-east-1c", "us-east-1a"] # insert values here
#   }

# }

# #Obtener el Security Group por defecto de AWS
# data "aws_security_group" "default-sg" {
#   #id = var.security_group_id
#   filter {
#     name   = "group-name"
#     values = ["default"] # insert values here
#   }
# }

# #Creación del LoadBalancer
# resource "aws_lb" "test-service-lb" {
#   name               = "test-service-lb"
#   internal           = false
#   load_balancer_type = "application"
#   ip_address_type    = "ipv4"
#   security_groups    = [data.aws_security_group.default-sg.id]
#   subnets            = data.aws_subnet_ids.test-subnet-ids.ids #[for subnet in aws_subnet.public : subnet.id]


#   tags = {
#     Environment = "production"
#   }
# }

# #Creación del target group
# resource "aws_lb_target_group" "test-lb-tg" {
#   name        = "test-lb-tg"
#   port        = 30000
#   protocol    = "HTTP"
#   vpc_id      = data.aws_vpc.vpc-default.id
#   target_type = "instance"
# }

# # Creación del listener/routing
# resource "aws_lb_listener" "test-service-listener" {
#   load_balancer_arn = aws_lb.test-service-lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.test-lb-tg.arn
#   }
# }

# # Attachment between the Loadbalancer and the target groups
# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.test-lb-tg.arn
#   target_id        = aws_instance.kubernetes-cluster[1].id
#   port             = aws_lb_target_group.test-lb-tg.port
# }
