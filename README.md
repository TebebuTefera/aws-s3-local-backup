# AWS S3 Backup to Local - Download All S3 Buckets

> **Download all your AWS S3 buckets to your local machine with a single command**

A bash script to automatically backup all Amazon S3 buckets to your local computer. Perfect for creating offline backups, archiving data, or migrating away from AWS.

## Features

- **One-command backup** - Automatically discovers and downloads all buckets
- **Resumable downloads** - Safe to re-run if interrupted (uses `aws s3 sync`)
- **Organized structure** - Creates separate folders for each bucket
- **Progress tracking** - Shows file counts and sizes during download
- **Detailed logging** - Creates timestamped log files
- **Incremental sync** - Only downloads new or modified files on re-runs

## Use Cases

- Creating local backups of all S3 data
- Archiving before closing an AWS account
- Offline access to S3 files
- Disaster recovery preparation
- Migrating to another cloud provider
- Compliance and audit requirements

## Prerequisites

- **AWS CLI v2** installed ([Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **AWS CLI profile** configured with access to your S3 buckets
- **Sufficient disk space** for your S3 data
- **IAM permissions**: `s3:ListAllMyBuckets`, `s3:GetBucketLocation`, `s3:ListBucket`, `s3:GetObject`

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/lmotwani/aws-s3-local-backup.git
cd aws-s3-local-backup
```

### 2. Configure AWS CLI

```bash
# Configure your AWS profile
aws configure --profile my-account

# Or use default profile
aws configure
```

### 3. Edit the script configuration

Open `backup.sh` and update these variables:

```bash
SOURCE_PROFILE="old-account"           # Your AWS CLI profile name
DOWNLOAD_DIR="$HOME/s3_backups"        # Where to save the backups
```

### 4. Run the backup

```bash
chmod +x backup.sh
./backup.sh
```

## How It Works

1. **Discovery** - Lists all S3 buckets in your AWS account
2. **Download** - Syncs each bucket to a local folder
3. **Verification** - Reports file counts and sizes
4. **Logging** - Creates detailed log file for reference

```
AWS S3                              Local Machine
┌─────────────────┐                ┌─────────────────────────────┐
│  my-bucket-1    │  ────────>     │  ~/s3_backups/my-bucket-1/  │
│  my-bucket-2    │  ────────>     │  ~/s3_backups/my-bucket-2/  │
│  my-bucket-3    │  ────────>     │  ~/s3_backups/my-bucket-3/  │
└─────────────────┘                └─────────────────────────────┘
```

## Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| `SOURCE_PROFILE` | AWS CLI profile name | `old-account` |
| `DOWNLOAD_DIR` | Local directory for backups | `$HOME/s3_backups` |

## Sample Output

```
============================================
  AWS S3 LOCAL BACKUP
============================================

[2024-01-15 10:30:00] Download location: /Users/you/s3_backups
[2024-01-15 10:30:01] Connected to Account: 123456789012
[2024-01-15 10:30:02] Found 3 bucket(s) to download

Buckets to download:
  - my-website
  - my-backups
  - my-logs

================================================
[1/3] Downloading: my-website
[2024-01-15 10:30:10] Objects to download: 1523
[2024-01-15 10:35:00] SUCCESS: Downloaded 1523 files (2.3G)

============================================
  DOWNLOAD SUMMARY
============================================
Total buckets: 3
Successful: 3
Total files downloaded: 5847
Total size: 8.7G

Files saved to: /Users/you/s3_backups
```

## Folder Structure

After running the script, your backups will be organized like this:

```
~/s3_backups/
├── my-website/
│   ├── index.html
│   ├── css/
│   └── images/
├── my-backups/
│   ├── backup-2024-01.zip
│   └── backup-2024-02.zip
├── my-logs/
│   └── access-logs/
└── download_20240115_103000.log
```

## Troubleshooting

### "Access Denied" error
Ensure your AWS profile has the required IAM permissions listed in Prerequisites.

### Slow download speed
- S3 downloads are limited by your internet connection
- Consider running overnight for large datasets
- The script is resumable, so interruptions are okay

### "No space left on device"
Check available disk space before running. You can check S3 usage in AWS Console first.

### Partial download
The script is resumable. Simply run it again to continue downloading.

## Important Notes

- **Disk space**: Ensure you have enough local storage for all your S3 data
- **Costs**: Standard S3 data transfer OUT charges apply
- **Time**: Download time depends on data volume and internet speed
- **Incremental**: Re-running only downloads new/modified files

## Scheduling Regular Backups

### macOS/Linux (cron)
```bash
# Edit crontab
crontab -e

# Add line for daily backup at 2 AM
0 2 * * * /path/to/aws-s3-local-backup/backup.sh >> /var/log/s3-backup.log 2>&1
```

### Windows (Task Scheduler)
Create a scheduled task to run the script via Git Bash or WSL.

## License

MIT License - feel free to use, modify, and distribute.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Related Tools

- [aws-s3-cross-account-migration](https://github.com/lmotwani/aws-s3-cross-account-migration) - Migrate S3 buckets between AWS accounts

## Keywords

AWS S3 backup, download S3 buckets, S3 to local, backup AWS S3, S3 backup script, download all S3 files, AWS S3 export, S3 sync local, AWS backup tool, S3 offline backup, S3 disaster recovery, AWS CLI S3 download
