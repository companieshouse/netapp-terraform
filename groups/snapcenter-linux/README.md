# SnapCenter Linux Terraform Configuration

This Terraform configuration deploys SnapCenter instances in AWS using Linux (RHEL9) as the base OS.

## Overview

SnapCenter is NetApp's data protection software that provides backup, restore, and clone capabilities for various applications and databases.

## Requirements

- SnapCenter 6.1+ on Linux requires:
  - RHEL 8 or 9
  - Minimum 4 CPU cores, 8GB RAM
  - 15GB disk space for SnapCenter Server and repository
  - .NET Framework 8.0.12+
  - PowerShell 7.4.2+
  - Nginx (reverse proxy)

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 22 | SSH | Administrative access |
| 3306 | TCP | MySQL repository |
| 5672 | TCP | RabbitMQ messaging |
| 8145 | HTTPS | SMCore communication |
| 8146 | HTTPS | SnapCenter main port (Web UI & API) |
| 8154 | HTTPS | Scheduler service |

## Monitoring

CloudWatch alarms are configured for:
- Instance status checks
- CPU utilisation
- Disk usage
