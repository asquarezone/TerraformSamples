data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
    filter {
      name = "availabilityZone"
      values = ["us-east-1a", "us-east-1b"]
    }
  
}



resource "aws_launch_template" "listings" {
    image_id = var.ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [ var.security_group_id ]
    key_name = var.key_name
    name = "listings"
    description = "This is listings template"
  
}

# create a application load balancer 
resource "aws_lb" "listings" {
    name = "listings-lb-tf"
    load_balancer_type = "application"
    security_groups = [var.security_group_id]
    subnets = data.aws_subnets.public.ids

}

# resource "aws_lb_listener" "listings" { 
#     load_balancer_arn = aws_lb.listings.arn
#     port = "80"
#     protocol = "HTTP"
#     default_action {
#         type = "forward"
#         target_group_arn = aws_lb_target_group.listing.arn
#   }
# }

resource "aws_autoscaling_group" "listing" {
    name = "listings-asg-tf"
    max_size = 2
    min_size = 2
    desired_capacity = 2
    availability_zones = ["us-east-1a", "us-east-1b"]
    launch_template {
        id = aws_launch_template.listings.id
        version = "$Latest"
    }
    #target_group_arns = [aws_launch_template.listings.arn]
    tag {
        key = "Name"
        value = "listings"
        propagate_at_launch = true
    }
}

# resource "aws_lb_target_group" "listing" {
#     name = "listings-lb-tg-tf"
#     port = "80"
#     protocol = "TCP"
#     vpc_id = data.aws_vpc.default.id
#     target_type = "alb"
  
# }

# resource "aws_lb_target_group_attachment" "listing" {
#     target_group_arn = aws_lb_target_group.listing.arn
#     target_id = aws_lb.listings.arn
#     port = 80
# }
    

  

  
