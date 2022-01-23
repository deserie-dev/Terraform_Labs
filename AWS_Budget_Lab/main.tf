terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region = "af-south-1"
}

resource "aws_budgets_budget" "terraform-budgets-lab" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "200"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2022-01-24_00:01"
}