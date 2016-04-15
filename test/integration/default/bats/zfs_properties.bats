#!/usr/bin/env bats

@test "filesystems" {
  zfs list -H tank/test1 >/dev/null
  zfs list -H tank/test2 >/dev/null
  run zfs list -H tank/test3 2>/dev/null
  [ "$status" -eq 1 ]
  zfs list -H tank/test4 >/dev/null
}

@test "properties" {
  # Mountpoint got set on tank/test1
  zfs get -H -o value mountpoint tank/test1 | grep -q /tank/mnt2

  # No non-inherited attributes on tank/test2
  [ "$(zfs get -H -s local all tank/test2)" = "" ]

  # recordsize + atime set on tank/test4
  zfs get -H -s local all tank/test4 | grep -q recordsize
  zfs get -H -s local all tank/test4 | grep -q atime
}
