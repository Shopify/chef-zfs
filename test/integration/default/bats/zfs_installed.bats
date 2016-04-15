#!/usr/bin/env bats

@test "zfs binary is found in PATH" {
  run which zfs
  [ "$status" -eq 0 ]
}
