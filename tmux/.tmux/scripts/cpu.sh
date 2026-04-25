#!/bin/sh
ps -A -o %cpu | awk 'BEGIN{
  cmd = "sysctl -n hw.logicalcpu"
  cmd | getline n
  close(cmd)
} NR>1 { s += $1 } END { printf "%.0f%%", s/n }'
