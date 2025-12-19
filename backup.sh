#!/bin/bash

# ============================================
# AWS S3 LOCAL DOWNLOAD SCRIPT
# ============================================
# Downloads all S3 buckets to your Mac
#
# Features:
#   - Auto-detects all buckets in your account
#   - Resumable (safe to re-run if interrupted)
#   - Progress tracking with file counts
#   - Creates organized folder structure
# ============================================

# --- CONFIGURATION ---
SOURCE_PROFILE="old-account"
DOWNLOAD_DIR="$HOME/s3_backups"
# ---------------------

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create download directory
mkdir -p "$DOWNLOAD_DIR"
LOG_FILE="$DOWNLOAD_DIR/download_$(date +%Y%m%d_%H%M%S).log"

# Logging function
log() {
    local timestamp="[$(date '+%Y-%m-%d %H:%M:%S')]"
    echo -e "$timestamp $1"
    echo "$timestamp $1" >> "$LOG_FILE"
}

echo ""
echo "============================================"
echo "  AWS S3 LOCAL BACKUP"
echo "============================================"
echo ""

# Initialize log
echo "Download started at $(date)" > "$LOG_FILE"
log "Download location: $DOWNLOAD_DIR"
log "Log file: $LOG_FILE"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    log "${RED}ERROR: AWS CLI is not installed${NC}"
    echo "Install with: brew install awscli"
    exit 1
fi

# Verify credentials
log "Verifying AWS credentials..."

IDENTITY=$(aws sts get-caller-identity --profile "$SOURCE_PROFILE" 2>&1)
if [[ $? -ne 0 ]]; then
    log "${RED}ERROR: Cannot authenticate with profile '$SOURCE_PROFILE'${NC}"
    log "Error: $IDENTITY"
    log "Run: aws configure --profile $SOURCE_PROFILE"
    exit 1
fi
ACCOUNT_ID=$(echo "$IDENTITY" | grep -o '"Account": "[0-9]*"' | grep -o '[0-9]*')
log "${GREEN}Connected to Account: $ACCOUNT_ID${NC}"

# Get list of all buckets
echo ""
log "Scanning for buckets..."

BUCKETS=$(aws s3api list-buckets --query 'Buckets[].Name' --output text --profile "$SOURCE_PROFILE" 2>&1)
if [[ $? -ne 0 ]]; then
    log "${RED}ERROR: Failed to list buckets: $BUCKETS${NC}"
    exit 1
fi

if [ -z "$BUCKETS" ]; then
    log "${YELLOW}No buckets found in account.${NC}"
    exit 0
fi

# Count buckets
BUCKET_COUNT=$(echo $BUCKETS | wc -w | tr -d ' ')
log "${BLUE}Found $BUCKET_COUNT bucket(s) to download${NC}"

# Show what will be downloaded
echo ""
echo "Buckets to download:"
for BUCKET in $BUCKETS; do
    echo "  - $BUCKET"
done
echo ""
echo "Download location: $DOWNLOAD_DIR"
echo ""

# Counters for summary
SUCCESS_COUNT=0
FAIL_COUNT=0
TOTAL_FILES=0
FAILED_BUCKETS=""

# Process each bucket
CURRENT=0
for BUCKET in $BUCKETS; do
    CURRENT=$((CURRENT + 1))
    LOCAL_PATH="$DOWNLOAD_DIR/$BUCKET"
    
    echo ""
    echo "================================================"
    log "[$CURRENT/$BUCKET_COUNT] Downloading: $BUCKET"
    log "Local path: $LOCAL_PATH"

    # Create local directory
    mkdir -p "$LOCAL_PATH"

    # Get bucket region for info
    REGION=$(aws s3api get-bucket-location --bucket "$BUCKET" --profile "$SOURCE_PROFILE" --output text 2>/dev/null)
    if [ "$REGION" == "None" ] || [ -z "$REGION" ] || [ "$REGION" == "null" ]; then
        REGION="us-east-1"
    fi
    log "Region: $REGION"

    # Count objects in source bucket
    SOURCE_COUNT=$(aws s3 ls "s3://$BUCKET" --recursive --profile "$SOURCE_PROFILE" 2>/dev/null | wc -l | tr -d ' ')
    log "Objects to download: $SOURCE_COUNT"

    if [ "$SOURCE_COUNT" -eq 0 ]; then
        log "${YELLOW}Bucket is empty. Skipping.${NC}"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        continue
    fi

    # Download using sync (resumable)
    log "Downloading... (this may take a while)"
    
    SYNC_OUTPUT=$(aws s3 sync "s3://$BUCKET" "$LOCAL_PATH" \
        --profile "$SOURCE_PROFILE" \
        2>&1)
    
    SYNC_EXIT_CODE=$?

    if [[ $SYNC_EXIT_CODE -ne 0 ]]; then
        log "${RED}ERROR: Download failed${NC}"
        log "Error: $SYNC_OUTPUT"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_BUCKETS="$FAILED_BUCKETS $BUCKET"
        continue
    fi

    # Count local files
    LOCAL_COUNT=$(find "$LOCAL_PATH" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    # Get local folder size
    LOCAL_SIZE=$(du -sh "$LOCAL_PATH" 2>/dev/null | cut -f1)
    
    log "${GREEN}SUCCESS: Downloaded $LOCAL_COUNT files ($LOCAL_SIZE)${NC}"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    TOTAL_FILES=$((TOTAL_FILES + LOCAL_COUNT))
done

# Calculate total downloaded size
TOTAL_SIZE=$(du -sh "$DOWNLOAD_DIR" 2>/dev/null | cut -f1)

# Summary
echo ""
echo "============================================"
echo "  DOWNLOAD SUMMARY"
echo "============================================"
log "Total buckets: $BUCKET_COUNT"
log "${GREEN}Successful: $SUCCESS_COUNT${NC}"
log "Total files downloaded: $TOTAL_FILES"
log "Total size: $TOTAL_SIZE"

if [ $FAIL_COUNT -gt 0 ]; then
    log "${RED}Failed: $FAIL_COUNT${NC}"
    log "${RED}Failed buckets:$FAILED_BUCKETS${NC}"
fi

echo ""
log "Files saved to: $DOWNLOAD_DIR"
log "Log file: $LOG_FILE"
log "Download completed at $(date)"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}All buckets downloaded successfully!${NC}"
else
    echo -e "${YELLOW}Download completed with some errors.${NC}"
    echo "Check $LOG_FILE for details."
    echo "Re-run this script to retry failed buckets."
fi

echo ""
echo "To view your backups, run:"
echo "  open $DOWNLOAD_DIR"
