##THIS SCRIPT WILL BUILD A IMAGE FOR PI2B QUAD CORE 1GB
#
#
#

## Ask version number
echo "What version number should this script use? example: 0.0.3"
read version

### Show version
echo "Show version"
echo $version

## Creating fat16 filesystem on /dev/sdc1
echo "Creating fat16 filesystem on /dev/sdc1"
mkfs.vfat -n BOOT /dev/sdc1
## Creating ext4 filesystem on /dev/sdc2
echo "Creating ext4 filesystem on /dev/sdc2"
mkfs.ext4 /dev/sdc2

## Mount sdc1 on boot
echo "Mount sdc1 on boot"
mount /dev/sdc1 boot
echo "Mount sdc2 on root"
mount /dev/sdc2 root

## Untar ArchLinuxARM to root filestem
echo "Untar ArchLinuxARM 2 to root filestem"
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root

## Sync in-memory changes back to disk
echo "sync changes back to disk"
sync

## Move boot files to the first partition:
mv root/boot/* boot

## Copy new config file for 16Mb GPU memory
echo "Create new config.txt for 16Mb GPU memory"
cp repo/config.txt boot

## Copy Image Builder Version to boot mount
cp repo/image_version.txt boot
echo -e "Platform Version: Pi2" >> boot/image_version.txt
echo -e "Image Builder Version: $version" >> boot/image_version.txt
echo -e "Timestamp: `date +%Y%m%d_%H%M%S`" >> boot/image_version.txt

## THIS SCRIPT IS NOT READY YEP FOR DEPLOYMENTS
#echo "Copy system-config.sh to /root on filesystem root" 
#cp repo/system-config.sh root/root

## Sync in-memory changes back to disk
echo "sync changes back to disk"
sync

## Unmount the two partitions:
echo "unmount boot and root"
umount boot root

## Copy disk in 1MB blocks to image file
echo "create a image from sdc disk"
dd bs=1000000 if=/dev/sdc of=/root/builds/ArchLinux_ARMv6_Pi2_Baseline_v$version.img

## Copy file to Mac desktop
echo "Copy files to mac, this, can take some time"
scp builds/ArchLinux_ARMv6_Pi2_Baseline_v$version.img remonlam@10.10.40.12:/Users/remonlam/Desktop
