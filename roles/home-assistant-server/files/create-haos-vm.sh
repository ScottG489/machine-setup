#!/bin/bash
set -ex

[[ -n "$1" ]] && VM_MEMORY=$1 || VM_MEMORY=4096

# Note that bridgeadapter may differ

# Note that latest version may differ
wget --progress=bar:force:noscroll https://github.com/home-assistant/operating-system/releases/download/6.6/haos_ova-6.6.vmdk.zip
unzip haos_ova-6.6.vmdk.zip

VM_UUID=$(vboxmanage createvm --name haos-vm --default --register --ostype Linux_64 | grep UUID | awk '{print $2}')
NET_DEVICE=$(ip link | grep -v 'lo\|vir\|wl\|^[^0-9]' | awk '{print $2}' | sed 's/.$//' | head -1)
#BLUETOOTH_USB_DEVICE_VENDOR_ID=$(vboxmanage list usbhost | grep VendorId | head -1 | awk '{print $2}')
#BLUETOOTH_USB_DEVICE_PRODUCT_ID=$(vboxmanage list usbhost | grep ProductId | head -1 | awk '{print $2}')
vboxmanage modifyvm "$VM_UUID" --firmware efi --nic1 bridged --bridgeadapter1 "$NET_DEVICE" --memory "$VM_MEMORY"
vboxmanage storageattach "$VM_UUID" --storagectl IDE --port 0 --device 0 --type hdd --medium haos_ova-6.6.vmdk
#vboxmanage usbfilter add 0 --name "Bluetooth USB device filter" --target haos-vm --vendorid "$BLUETOOTH_USB_DEVICE_VENDOR_ID" --productid "$BLUETOOTH_USB_DEVICE_PRODUCT_ID"

#vboxmanage startvm --type headless "$VM_UUID"
#vboxmanage showvminfo --machinereadable $VM_UUID --details
#vboxmanage unregistervm $VM_UUID --delete
