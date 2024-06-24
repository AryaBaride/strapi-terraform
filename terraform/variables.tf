variable "private_key_path" {
  description = ""
  type        = string
}

variable "public_key_path" {
  description = ""
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}