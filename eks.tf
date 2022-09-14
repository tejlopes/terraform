resource "aws_iam_role" "iam_eks_role_template" {
  name = "eks_cluster_role_template"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_template" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_eks_role_template.name
}

resource "aws_iam_role" "iam_eks_node_group_template" {
  name = "eks_node_group_template"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "node_group_node_policy_template" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_eks_node_group_template.name
}

resource "aws_iam_role_policy_attachment" "node_group_cni_policy_template" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_eks_node_group_template.name
}

resource "aws_iam_role_policy_attachment" "node_group_container_registry_policy_template" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_eks_node_group_template.name
}

resource "aws_eks_cluster" "eks_cluster_template" {
  name     = "eks_template"
  role_arn = aws_iam_role.iam_eks_role_template.arn

  vpc_config {
    subnet_ids = module.vpc-template.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_template
  ]
}

resource "aws_eks_node_group" "node_group_template" {
  cluster_name    = aws_eks_cluster.eks_cluster_template.name
  node_group_name = "node_group_template"
  node_role_arn   = aws_iam_role.iam_eks_node_group_template.arn
  subnet_ids      = module.vpc-template.private_subnets

  scaling_config {
    desired_size = var.eks_nodes_desired_template
    max_size     = var.eks_nodes_max_template
    min_size     = var.eks_nodes_min_template
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_node_policy_template,
    aws_iam_role_policy_attachment.node_group_cni_policy_template,
    aws_iam_role_policy_attachment.node_group_container_registry_policy_template
  ]
}