# AWS S3 Backup to Local - Download All Buckets

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![AWS S3](https://img.shields.io/badge/AWS-S3-orange?logo=amazon-aws)](https://aws.amazon.com/s3/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/lmotwani/aws-s3-local-backup/graphs/commit-activity)

> **Download all your AWS S3 buckets to your local machine with a single command**

A production-ready bash script to automatically backup all Amazon S3 buckets to your local computer. Perfect for creating offline backups, archiving data, or migrating away from AWS.

![AWS S3 Local Backup](https://img.shields.io/badge/AWS%20S3-Local%20Backup-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

---

## Table of Contents

- [Features](#features)
- [Use Cases](#use-cases)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [Configuration](#configuration)
- [Sample Output](#sample-output)
- [Folder Structure](#folder-structure)
- [Scheduling Backups](#scheduling-backups)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contributing](#contributing)
- [Related Projects](#related-projects)
- [License](#license)

---

## Features

| Feature | Description |
|---------|-------------|
| **One-Command Backup** | Automatically discovers and downloads all buckets |
| **Resumable Downloads** | Safe to re-run if interrupted (uses `aws s3 sync`) |
| **Organized Structure** | Creates separate folders for each bucket |
| **Progress Tracking** | Shows file counts and sizes during download |
| **Detailed Logging** | Creates timestamped log files |
| **Incremental Sync** | Only downloads new or modified files on re-runs |
| **Multi-Region Support** | Works with buckets in any AWS region |
| **Lightweight** | Single bash script, no dependencies beyond AWS CLI |

---

## Use Cases

- **Offline Backup** - Keep local copies of all S3 data
- **Disaster Recovery** - Prepare for AWS outages or account issues
- **Account Closure** - Archive before closing AWS account
- **Cloud Migration** - Move data to another cloud provider
- **Compliance** - Meet data retention requirements
- **Development** - Work with S3 data locally
- **Cost Optimization** - Download and archive infrequently accessed data

---

## Prerequisites

### Required Software
- **AWS CLI v2** - [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **Bash shell** - Linux, macOS, or Windows (WSL/Git Bash)
- **Sufficient disk space** - Check your S3 usage first

### AWS Configuration
```bash
# Verify AWS CLI is installed
aws --version

# Configure your AWS profile
aws configure --profile my-account
```

### Required IAM Permissions

<details>
<summary><strong>Minimum Required Permissions (click to expand)</strong></summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": "*"
        }
    ]
}
```
</details>

---

## Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/lmotwani/aws-s3-local-backup.git
cd aws-s3-local-backup
```

### Step 2: Configure the Script

Edit `backup.sh` and update these variables:

```bash
SOURCE_PROFILE="old-account"           # Your AWS CLI profile name
DOWNLOAD_DIR="$HOME/s3_backups"        # Where to save backups
```

### Step 3: Run the Backup

```bash
# Make executable
chmod +x backup.sh

# Run backup
./backup.sh
```

---

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                      BACKUP WORKFLOW                             │
└─────────────────────────────────────────────────────────────────┘

        AWS S3                              LOCAL MACHINE
        ══════                              ═════════════
          │                                       │
          │  1. Authenticate & List buckets       │
          ├─────────────────────────────────────> │
          │                                       │
          │  2. Create local directories          │
          │ <─────────────────────────────────────┤
          │                                       │
          │  3. Sync each bucket                  │
          ├─────────────────────────────────────> │
          │                                       │
          │  4. Verify & Report                   │
          │ <─────────────────────────────────────┤
          │                                       │

  ┌─────────────────┐              ┌────────────────────────────┐
  │  my-bucket-1    │  ────────>   │  ~/s3_backups/my-bucket-1/ │
  │  my-bucket-2    │  ────────>   │  ~/s3_backups/my-bucket-2/ │
  │  my-bucket-3    │  ────────>   │  ~/s3_backups/my-bucket-3/ │
  └─────────────────┘              └────────────────────────────┘
```

---

## Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `SOURCE_PROFILE` | AWS CLI profile name | `old-account` | Yes |
| `DOWNLOAD_DIR` | Local directory for backups | `$HOME/s3_backups` | Yes |

---

## Sample Output

```
============================================
  AWS S3 LOCAL BACKUP
============================================

[2024-01-15 10:30:00] Download location: /Users/you/s3_backups
[2024-01-15 10:30:00] Log file: /Users/you/s3_backups/download_20240115_103000.log
[2024-01-15 10:30:01] Verifying AWS credentials...
[2024-01-15 10:30:01] Connected to Account: 123456789012
[2024-01-15 10:30:02] Found 3 bucket(s) to download

Buckets to download:
  - my-website
  - my-backups
  - my-logs

================================================
[1/3] Downloading: my-website
[2024-01-15 10:30:05] Region: us-east-1
[2024-01-15 10:30:06] Objects to download: 1523
[2024-01-15 10:35:00] SUCCESS: Downloaded 1523 files (2.3G)

================================================
[2/3] Downloading: my-backups
[2024-01-15 10:35:05] Region: us-west-2
[2024-01-15 10:35:06] Objects to download: 847
[2024-01-15 10:40:00] SUCCESS: Downloaded 847 files (5.1G)

================================================
[3/3] Downloading: my-logs
[2024-01-15 10:40:05] Region: us-east-1
[2024-01-15 10:40:06] Objects to download: 3477
[2024-01-15 10:45:00] SUCCESS: Downloaded 3477 files (1.3G)

============================================
  DOWNLOAD SUMMARY
============================================
Total buckets: 3
Successful: 3
Total files downloaded: 5847
Total size: 8.7G

Files saved to: /Users/you/s3_backups

All buckets downloaded successfully!

To view your backups, run:
  open /Users/you/s3_backups
```

---

## Folder Structure

After running the script, your backups will be organized like this:

```
~/s3_backups/
├── my-website/
│   ├── index.html
│   ├── css/
│   │   └── styles.css
│   └── images/
│       ├── logo.png
│       └── banner.jpg
├── my-backups/
│   ├── backup-2024-01.zip
│   ├── backup-2024-02.zip
│   └── backup-2024-03.zip
├── my-logs/
│   └── access-logs/
│       ├── 2024-01-01.log
│       └── 2024-01-02.log
├── download_20240115_103000.log
└── download_20240116_020000.log
```

---

## Scheduling Backups

### macOS/Linux (using cron)

```bash
# Edit crontab
crontab -e

# Add line for daily backup at 2 AM
0 2 * * * /path/to/aws-s3-local-backup/backup.sh >> /var/log/s3-backup.log 2>&1

# Or weekly on Sundays at 3 AM
0 3 * * 0 /path/to/aws-s3-local-backup/backup.sh >> /var/log/s3-backup.log 2>&1
```

### macOS (using launchd)

<details>
<summary><strong>Create a launchd plist (click to expand)</strong></summary>

Create `~/Library/LaunchAgents/com.s3backup.daily.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.s3backup.daily</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/aws-s3-local-backup/backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
```

Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.s3backup.daily.plist
```
</details>

### Windows (Task Scheduler)

<details>
<summary><strong>Steps for Windows Task Scheduler (click to expand)</strong></summary>

1. Open Task Scheduler
2. Click "Create Basic Task"
3. Name: "S3 Daily Backup"
4. Trigger: Daily at 2:00 AM
5. Action: Start a program
6. Program: `C:\Program Files\Git\bin\bash.exe`
7. Arguments: `-c "/path/to/backup.sh"`
</details>

---

## Troubleshooting

<details>
<summary><strong>"Access Denied" error</strong></summary>

Ensure your AWS profile has the required IAM permissions:
```bash
# Test access
aws s3 ls --profile your-profile

# Verify identity
aws sts get-caller-identity --profile your-profile
```
</details>

<details>
<summary><strong>Slow download speed</strong></summary>

Download speed depends on:
- Your internet connection
- AWS region distance
- Number of small files (many small files = slower)

Tips:
- Run overnight for large datasets
- Use a machine closer to your AWS region
- The script is resumable, so interruptions are okay
</details>

<details>
<summary><strong>"No space left on device"</strong></summary>

Check your S3 usage before running:
```bash
# Check total S3 usage
aws s3 ls --summarize --human-readable --recursive s3:// --profile your-profile
```

Free up disk space or change `DOWNLOAD_DIR` to an external drive.
</details>

<details>
<summary><strong>Partial download / Interrupted</strong></summary>

The script is resumable. Simply run it again:
```bash
./backup.sh
```
Only missing or modified files will be downloaded.
</details>

---

## FAQ

<details>
<summary><strong>How long does the backup take?</strong></summary>

Backup time depends on:
- Total data volume
- Number of objects
- Internet connection speed
- AWS region distance

As a reference: ~100GB typically takes 1-2 hours on a fast connection.
</details>

<details>
<summary><strong>Does it download object versions?</strong></summary>

No, this script downloads only the latest version of each object. For versioned backups, you would need to modify the script to use `aws s3api list-object-versions`.
</details>

<details>
<summary><strong>What about large files?</strong></summary>

AWS CLI automatically handles large files using multipart downloads. Files larger than 8MB are downloaded in parallel chunks.
</details>

<details>
<summary><strong>Can I backup specific buckets only?</strong></summary>

Yes! Modify the `BUCKETS` variable in the script to specify only the buckets you want:
```bash
BUCKETS="bucket1 bucket2 bucket3"
```
</details>

<details>
<summary><strong>Will it overwrite existing local files?</strong></summary>

The script uses `aws s3 sync` which:
- Downloads new files
- Updates modified files (based on size/timestamp)
- Does NOT delete local files that were removed from S3
</details>

---

## Storage Considerations

### Estimating Required Space

Before running, check your S3 usage:

```bash
# List all buckets with sizes
for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text --profile your-profile); do
    echo -n "$bucket: "
    aws s3 ls s3://$bucket --recursive --summarize --human-readable --profile your-profile 2>/dev/null | tail -1
done
```

### Using External Storage

To backup to an external drive:

```bash
# Set DOWNLOAD_DIR to external drive
DOWNLOAD_DIR="/Volumes/MyExternalDrive/s3_backups"

# Or on Windows
DOWNLOAD_DIR="/d/s3_backups"
```

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## Related Projects

| Project | Description |
|---------|-------------|
| [aws-s3-cross-account-migration](https://github.com/lmotwani/aws-s3-cross-account-migration) | Migrate S3 buckets between AWS accounts |

---

## Star History

If this project helped you, please consider giving it a star!

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

**Lokesh Motwani** - [GitHub](https://github.com/lmotwani)

---

<p align="center">
  <strong>Found this useful? Give it a ⭐ on GitHub!</strong>
</p>

---

## Keywords

`aws s3 backup` `download s3 buckets` `s3 to local` `backup aws s3` `s3 backup script` `download all s3 files` `aws s3 export` `s3 sync local` `aws backup tool` `s3 offline backup` `s3 disaster recovery` `aws cli s3 download` `s3 local copy` `aws s3 download all` `backup s3 to disk` `s3 data export` `aws s3 backup script` `download entire s3 bucket`
