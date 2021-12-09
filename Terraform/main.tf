

# Creating AWS Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}


resource "aws_instance" "web_instance_1" {
  ami           = "${var.instance_ami}"
  instance_type = "t3.micro"
  subnet_id     = "${var.subnet_id_1}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "web_instance_1"
  }
  user_data = "${file("userdata.sh")}"
}

resource "aws_lb_target_group" "web_al_tg" {
  name     = "web-al-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "web_tg_inst" {
  target_group_arn = aws_lb_target_group.web_al_tg.arn
  target_id        = aws_instance.web_instance_1.id
  port             = 80
}

resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_tls.id}"]
  subnets            = ["${var.subnet_id_1}","${var.subnet_id_2}"]

  tags = {
    Environment = "app_web_lb"
  }
}


resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = "${aws_lb.web_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_al_tg.arn}"
  }
}
