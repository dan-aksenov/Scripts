# recreate pools with lower pg count
# First - stop rados gw

old_pool=$1
new_pool=new.$old_pool

# Create a new pool, with the correct pg count:
ceph osd pool create $new_pool 8

# Copy the contents of the old pool the new pool:
rados cppool $old_pool $new_pool

# Remove the old pool:
# Currently not remove, but rename.
#ceph osd pool delete $old_pool $old_pool --yes-i-really-really-mean-it
ceph osd pool rename $old_pool old.$old_pool

# Rename the new pool to original name.
ceph osd pool rename $new_pool $old_pool

# Now can start radow gw.