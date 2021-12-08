resource "aws_elb" "ter_reem_lb" {
    subnets = [aws_subnet.ter_sub_reem1.id, aws_subnet.ter_sub_reem2.id]
    name = "reem_lb_ter"
    security_groups = [aws_security_group.ter_reem_sg_lb.id]
    listener {
        instance_port       = 3000
        instance_protocol   = "http"
        lb_port             = 80
        lb_protocol         = "http"
        path                = "/index.html"
    }

    health_check {
        timeout             = 3
        interval            = 30
        unhealthy_threshold = 2
        healthy_threshold   = 10
        target              = "HTTP:3000/"
        
        
    }

    instances                   = [aws_instance.reem_easy1.id, aws_instance.reem_easy1.id]
    cross_zone_load_balancing   = true

    tags = {
        Name = "ter_reem_lb"
    }
}