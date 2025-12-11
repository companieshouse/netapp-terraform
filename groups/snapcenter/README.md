# SnapCenter Linux Terraform Configuration

This Terraform configuration deploys instances using the netapp-snapcenter-ami which includes:
- RHEL 9
- Required packages and dependencies
- Root user with temporary password - this is used and then removed in [netapp-snapcenter-ansible](https://github.com/companieshouse/netapp-snapcenter-ansible)
- NetApp SnapCenter server installed and enabled

- There are 2 EBS volumes:
  - **Root** - OS and system files
  - **Data** - Mounted at `/opt`, containing SnapCenter installation (inlcuding MySQL data)

## Monitoring

CloudWatch alarms are configured for:
- Instance status checks
- CPU utilisation
- Disk usage

## Post-run Ansible

To fully set up instances using this ami, you need to run `netapp-snapcenter-ansible` which will:
1. Mount the data volume
2. Set the hostname
3. Create Linux users with environment-specific passwords (via vault)
4. Register said users with SnapCenter via the API
5. Lock the root account, as an environment-specific admin is created

______________________  

# SnapCenter Overview

SnapCenter is NetApp's data protection software that provides backup, restore, and clone capabilities for various applications and databases.


SnapCenter 6.1+ on Linux requires:
- RHEL 8 or 9
- Minimum 4 cores, 8GB RAM
- 15GB disk space for SnapCenter Server and repository
- .NET Framework 8.0.12+
- PowerShell 7.4.2+
- Nginx (reverse proxy)


| Port | Protocol | Description |
|------|----------|-------------|
| 22 | SSH | Administrative access |
| 3306 | TCP | MySQL repository |
| 5672 | TCP | RabbitMQ messaging |
| 8145 | HTTPS | SMCore communication |
| 8146 | HTTPS | SnapCenter main port (Web UI & API) |
| 8154 | HTTPS | Scheduler service |
