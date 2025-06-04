#!/bin/bash

# Configuration
DEVICE="/dev/sdb"
LABEL="chessdata"
MOUNTPOINT="/mnt/chesskeeper-data"

# Ensure device exists
if ! lsblk "$DEVICE" &>/dev/null; then
  echo "❌ Device $DEVICE not found."
  exit 1
fi

if [ "$FORCE_FORMAT" = "1" ]; then
  echo "⚠️ FORCE_FORMAT is set – formatting $DEVICE as ext4..."
  mkfs.ext4 -F "$DEVICE"
else
  if blkid "$DEVICE" > /dev/null 2>&1; then
    echo "✅ Filesystem detected on $DEVICE – skipping format."
  else
    echo "📭 No filesystem found – creating ext4..."
    mkfs.ext4 "$DEVICE"
  fi
fi

# Mountpoint
echo "📁 Creating mount point at $MOUNTPOINT"
sudo mkdir -p "$MOUNTPOINT"

# Set label if missing
echo "🔖 Ensuring label is set to $LABEL"
sudo e2label "$DEVICE" "$LABEL"

# Add to fstab if not present
if ! grep -q "LABEL=$LABEL" /etc/fstab; then
  echo "📄 Adding to /etc/fstab"
  echo "LABEL=$LABEL $MOUNTPOINT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
fi

# Mount now
echo "🔗 Mounting volume"
sudo mount -a

# Set permissions
echo "🔐 Setting ownership to chesskeeper:chesskeeper"
sudo chown -R chesskeeper:chesskeeper "$MOUNTPOINT"

echo "✅ Volume setup complete."
