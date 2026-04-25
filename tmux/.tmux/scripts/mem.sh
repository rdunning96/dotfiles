#!/bin/sh
vm_stat | awk '
  /Pages active/  { a = $3 }
  /Pages wired/   { w = $4 }
  /page size/     { s = $8 }
  END { printf "%.0fGB", (a + w) * s / 1073741824 }
'
