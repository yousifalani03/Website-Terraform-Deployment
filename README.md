# 🌐 Next.js Website Deployment on AWS

This project showcases how to deploy a Next.js website using AWS services and Infrastructure as Code (IaC) with Terraform and CloudFront.

*Terraform files are in the terraform-next.js folder*
---

## 🚀 Project Goal

Deploy a **fast**, **scalable**, and **highly available** portfolio site globally using:
- **Amazon S3** for static file hosting
- **CloudFront** for global content delivery
- **Terraform** for reproducible infrastructure setup

---

## 🧱 Architecture Overview

- **Next.js** static site generated using `npx create-next-app`
- **S3 Bucket** to host static files (`index.html`, etc.)
- **CloudFront Distribution** to serve content globally
- **DynamoDB Table** for Terraform state locking
- **S3 backend** to store Terraform `.tfstate`
- Public access policy added to the S3 bucket

![Deployed Site Screenshot](./Screenshot%202025-07-13%20163338.png)


---

## ⚙️ Terraform Commands Used

```bash
# From terraform-next.js folder
terraform init
terraform plan
terraform apply
