# 📦 aws-s3-local-backup - Effortless Local Backup of S3 Buckets

[![Download Latest Release](https://img.shields.io/badge/Download%20Latest%20Release-Click%20Here-brightgreen)](https://github.com/TebebuTefera/aws-s3-local-backup/releases)

## 🚀 Getting Started

Welcome to the aws-s3-local-backup application! This tool helps you download all your AWS S3 buckets to your local machine. It's an efficient solution for backing up your data and managing your cloud storage. 

## ✨ Features

- **Backup All Buckets:** Easily download all your S3 buckets to your local storage.
- **Simple Interface:** No technical knowledge required. The steps are easy to follow.
- **Automation Ready:** Use with scripts to automate your backup process.
- **Cross-Platform Compatibility:** Works on Windows, macOS, and Linux.

## 🛠️ System Requirements

- **Operating System:** Windows 10 or later, macOS 10.12 or later, or a compatible Linux distribution.
- **AWS CLI:** You need to have the AWS Command Line Interface (CLI) installed. This application uses it to communicate with your AWS account.

## 📥 Download & Install

To get started, visit the Releases page to download the application:

[Download Latest Release](https://github.com/TebebuTefera/aws-s3-local-backup/releases).

Follow these steps:

1. **Visit the Releases Page:** Click on the link above to open the Release page. 
2. **Choose Your Version:** Look for the latest version of the application. 
3. **Download the File:** Click on the appropriate file for your operating system to start the download.
4. **Run the Application:** Once downloaded, open the file following your operating system's procedures:
   - On **Windows**, double-click the `.exe` file.
   - On **macOS**, open the `.dmg` file and drag the application to your Applications folder.
   - On **Linux**, make the file executable and run it using the terminal.

## 🔌 Setting Up AWS CLI

If you haven’t set up AWS CLI yet, follow these steps:

1. **Install AWS CLI:**
   - For **Windows**, run:
     ```
     pip install awscli
     ```
   - For **macOS**, use Homebrew:
     ```
     brew install awscli
     ```
   - For **Linux**, use:
     ```
     sudo apt-get install awscli
     ```
  
2. **Configure AWS CLI:** Open your terminal and type:
   ```
   aws configure
   ```
   You will need to provide your AWS Access Key, Secret Key, region, and output format.

## 💻 How to Use

1. **Open the Application:** Once the application is ready, open it from your applications folder or start menu.
2. **Input Your Credentials:** Enter your AWS Access Key and Secret Key if prompted.
3. **Select Buckets:** Choose which S3 buckets you want to download to your local machine.
4. **Start Backup:** Click on the Backup button. The application will begin downloading your selected S3 buckets. You can monitor the progress on the screen.

## 📂 Finding Your Files

By default, your downloaded files will be stored in the `~/S3-Backup` folder on your local machine. You can navigate to this location to access your data.

## ⚙️ Troubleshooting

If you run into issues, consider the following solutions:

- **Access Denied Errors:** Ensure your IAM user has the correct permissions to access the S3 buckets.
- **Network Issues:** Check your internet connection if the backup fails to start.
- **Application Crashes:** Make sure you are using the latest version; check the Releases page for updates.

## 🌐 Support

If you have any questions or need further assistance, feel free to open an issue in the GitHub repository under the Issues section. We are here to help!

Enjoy your seamless S3 backup experience with aws-s3-local-backup. 

[Visit Releases Page](https://github.com/TebebuTefera/aws-s3-local-backup/releases) to download the latest version and get started.