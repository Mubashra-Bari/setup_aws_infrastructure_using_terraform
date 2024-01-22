# Output for VPC ID
output "vpc_id" {
  value = aws_vpc.myVPC.id
}

# Output for Subnet ID
output "subnet_id" {
  value = aws_subnet.mySubnet.id
}

# Output for Internet Gateway ID
output "internet_gateway_id" {
  value = aws_internet_gateway.myIGW.id
}

# Output for Route Table ID
output "route_table_id" {
  value = aws_route_table.myRoute.id
}

# Output for Security Group ID
output "security_group_id" {
  value = aws_security_group.mySG.id
}

# Output for Network Interface ID
output "network_interface_id" {
  value = aws_network_interface.myNI.id
}

/*Output for Elastic IP Allocation ID
output "eip_allocation_id" {
  value = aws_eip.myeip.id
}*/

# Output for Instance ID
output "instance_id" {
  value = aws_instance.myServer.id
}

# Output for Instance Public IP
output "instance_public_ip" {
  value = aws_instance.myServer.public_ip
}
