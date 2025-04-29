# Alertmanager Deployment for Prometheus Alerts

## 📌 Overview

This project deploys Alertmanager in a Kubernetes environment to manage alerts from Prometheus. Alerts are routed based on severity and sent to **Slack**, **Email**, and optionally **PagerDuty**. This document provides setup instructions, configuration details, and testing steps.

---

## 🚀 Scope of Work

- Deploy Alertmanager in Kubernetes.
- Define alert routing based on severity.
- Integrate alert notifications with Slack and email.
- Test alert delivery.
- Document the configuration and setup process.

---

## ⚙️ Prerequisites

- A Kubernetes cluster with access via `kubectl`
- Prometheus deployed and running in the cluster
- Configured Slack webhook URL
- Email credentials (SMTP server, port, user, password)
- (Optional) PagerDuty Integration Key
- Helm installed (for easier deployment)

---

## 📁 Project Structure

