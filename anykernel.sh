# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
do.devicecheck=1
do.supported.versions=1
do.version.sdk=1
do.build.id=1
do.supported.patchlevels=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=rosy
device.name2=Redmi 5
'; } # end properties

# shell variables
block=auto;
is_slot_device=auto;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
#example ramdisk set_perm_recursive
#set_perm_recursive 0 0 755 644 $ramdisk/*;
#set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
chmod -R 750 $home/ramdisk/*;
chown -R root:root $home/ramdisk*;
mount -o remount,rw /;
mount -o remount,rw /vendor;
mount -o remount,rw /system;
mount -o remount,rw /sbin;
mount -o remount,rw /data;
mount -o remount,rw /storage;

## AnyKernel install
dump_boot;

# Clean up other kernels' ramdisk files before installing ramdisk
rm -rf /vendor/etc/init/hw/init.mrt.rc

#Spectrum========================================
cp -rpf $home/ramdisk/init.mrt.rc /vendor/etc/init/hw/init.mrt.rc
chmod 644 /vendor/etc/init/hw/init.mrt.rc
#spectrum write
if [ -e /system/etc/init/hw/init.rc ]; then
	cp -rpf /system/etc/init/hw/init.rc~ /system/etc/init/hw/init.rc
		remove_line /system/etc/init/hw/init.rc "import /vendor/etc/init/hw/init.mrt.rc";
		backup_file /system/etc/init/hw/init.rc;
		insert_line /system/etc/init/hw/init.rc "init.mrt.rc" before "import /init.environ.rc" "import /vendor/etc/init/hw/init.mrt.rc";
fi;

if [ -e /vendor/etc/init/hw/init.qcom.rc ]; then
	cp -rpf /vendor/etc/init/hw/init.qcom.rc~  /vendor/etc/init/hw/init.qcom.rc
		remove_line /vendor/etc/init/hw/init.qcom.rc "import /vendor/etc/init/hw/init.mrt.rc";
		backup_file /vendor/etc/init/hw/init.qcom.rc;
		insert_line /vendor/etc/init/hw/init.qcom.rc "init.mrt.rc" before "import /vendor/etc/init/hw/init.qcom.usb.rc" "import /vendor/etc/init/hw/init.mrt.rc";
fi;
#Spectrum========================================

rm -rf /system/etc/init/hw/init.rc~
rm -rf /vendor/etc/init/hw/init.qcom.rc~

# end ramdisk changes

write_boot;
## end install
