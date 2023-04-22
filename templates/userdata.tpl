#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install Packages / Update
sudo apt update -q
sudo apt install -qy jq unzip htop net-tools
sudo apt -y upgrade

# Install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Get / cache instance meta data
sudo wget -N -i http://169.254.169.254/latest/meta-data/ -P /etc/amazon-ec2
METADATA=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
ACC_ID=$(echo $METADATA | jq -r .accountId)

# Set vars
device="xvdf"
volume="${volume}"

# Terminate any server that already has the volume for this AZ attached
aws ec2 terminate-instances --region ${region} --instance $(aws ec2 describe-volumes --region ${region} --volume-id $volume --query 'Volumes[0].Attachments[0].InstanceId' | tr -d '"') || true

# Attach and Mount Volume
while [[ $(aws ec2 detach-volume --volume-id=$volume --region=${region}) == *"detaching"* ]]; do sleep 1; done;
while [[ $(aws ec2 attach-volume --volume-id=$volume --instance-id=$(cat /etc/amazon-ec2/instance-id) --device=$device --region=${region}) == *"attaching"* ]]; do sleep 1; done;

# Detect if volume is attached
while [[ ! $(/bin/lsblk) == *$device* ]]; do
    # Detect if we are on a Nitro based VM and then lookup nvme device
    if [ -f /sys/devices/virtual/dmi/id/board_asset_tag ]; then
        sudo apt install -qy nvme-cli
        for line in $(/bin/lsblk | awk '{print $1}' | /bin/grep ^nvme);
        do
            if [[ $(sudo /usr/sbin/nvme id-ctrl -v /dev/$line | grep $${volume/-/} | wc -c) -ne 0 ]]; then
                device=$line
            fi
        done
    fi
done;

# Mount data folder and bootstrap
sudo mkdir ${data_root}
if [[ $(blkid /dev/$device | head -c1 | wc -c) -eq 0 ]]; then
    sudo mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 /dev/$device
fi

# Auto expand FS before mount
sudo mount -t ext4 -o noatime,data=writeback,barrier=0,nobh,errors=remount-ro /dev/$device ${data_root}
sudo resize2fs /dev/$device
sudo chown ubuntu:ubuntu -R ${data_root}

# Run it!
docker run -d \
  --restart=always \
  -p 3001:3001 \
  -v ${data_root}/uptime-kuma:/app/data \
  --name uptime-kuma \
  louislam/uptime-kuma

sudo snap start amazon-ssm-agent