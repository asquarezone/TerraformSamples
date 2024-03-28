resource "aws_launch_template" "listings" {
    default_version         = 1
    description             = "This is listings template"
    image_id                = "ami-0aba5af2d290ca42f"
    instance_type           = "t2.micro"
    key_name                = "ansible"
    name                    = "listings"
    vpc_security_group_ids  = [
        "sg-01812b8bb24c1d56e",
    ]
}

resource "aws_lb" "listings" {
    internal                                    = false
    ip_address_type                             = "ipv4"
    load_balancer_type                          = "application"
    name                                        = "listings-lb-tf"
    security_groups                             = [
        "sg-01812b8bb24c1d56e",
    ]
    subnets                                     = [
        "subnet-068da44055b5121fd",
        "subnet-09433d3bc18c87be9",
    ]
    tags                                        = {}
    tags_all                                    = {}
}

resource "aws_autoscaling_group" "listing" {
    availability_zones        = [
        "us-east-1a",
        "us-east-1b",
    ]
    desired_capacity          = 2
    health_check_grace_period = 300
    health_check_type         = "EC2"
    #load_balancers            = []
    max_size                  = 2
    min_size                  = 2
    name                      = "listings-asg-tf"
    target_group_arns         = [
        "arn:aws:elasticloadbalancing:us-east-1:381491878286:targetgroup/listings/5706e79ed5b9f069",
    ]

    launch_template {
        id      = "lt-0e8a5f8b59d75b137"
        version = "$Latest"
    }

    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "listings"
    }

    # traffic_source {
    #     identifier = "arn:aws:elasticloadbalancing:us-east-1:381491878286:targetgroup/listings/5706e79ed5b9f069"
    #     type       = "elbv2"
    # }
}

resource "aws_lb_target_group" "listings" {
    ip_address_type                   = "ipv4"
    # load_balancer_arns                = [
    #     "arn:aws:elasticloadbalancing:us-east-1:381491878286:loadbalancer/app/listings-lb-tf/84e1f64f3257813d",
    # ]
    name                              = "listings"
    port                              = 80
    protocol                          = "HTTP"
    target_type                       = "instance"
    vpc_id                            = "vpc-03f22673504092d57"

    health_check {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }

    stickiness {
        cookie_duration = 86400
        enabled         = false
        type            = "lb_cookie"
    }

}