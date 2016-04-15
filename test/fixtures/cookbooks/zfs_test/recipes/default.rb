execute 'zpool destroy tank || true'
execute 'truncate -s 100M /tmp/zfsblock'
execute 'zpool create tank /tmp/zfsblock'
execute 'zfs create -V 1M tank/vol'
execute 'zfs create tank/test1 -o mountpoint=/tank/mnt1 -o recordsize=128K -o atime=off'
execute 'zfs create tank/test3'

# This filesystem had mountpoint, recordsize and atime set prior to Chef.
# Also tests value coercion (atime=off => atime: false)
zfs 'tank/test1' do
  mountpoint '/tank/mnt2'
end

# This creates a new filesystem
zfs 'tank/test2'

# This destroys a filesystem
zfs 'tank/test3' do
  action :destroy
end

# This creates a new filesystem, with options
zfs 'tank/test4' do
  atime false
  recordsize '64K'
end
