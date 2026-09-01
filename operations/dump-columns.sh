#!/usr/bin/env bash
# dump-columns.sh — every column of every table and view in one schema.
#
# Required at every close, on BOTH boxes, then diff the two files (RULES 6).
#
#   ./dump-columns.sh <label> [schema]
#
#   <label>   names the OUTPUT FILE ONLY. It does NOT select a box.
#             Running this on prod with the label "dev" produces columns-dev.txt
#             holding PROD's schema. Read the hostname it prints.
#   [schema]  defaults to abletracelab_live. Pass "abletrace" for the archive.
#
# Credentials come from ~/.my.cnf. Nothing is passed on the command line.
# Output: /tmp/columns-<label>.txt
#
# One line per column, sorted, so two files diff cleanly:
#   TABLE_TYPE|TABLE_NAME|COLUMN_NAME|COLUMN_TYPE|IS_NULLABLE|DEFAULT|EXTRA

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 <label> [schema]" >&2
  exit 2
fi

LABEL="$1"
SCHEMA="${2:-abletracelab_live}"
OUT="/tmp/columns-${LABEL}.txt"

echo "host   : $(hostname -s)"
echo "schema : ${SCHEMA}"
echo "output : ${OUT}"
echo

mysql -N -B -e "
SELECT CONCAT_WS('|',
         t.TABLE_TYPE,
         c.TABLE_NAME,
         c.COLUMN_NAME,
         c.COLUMN_TYPE,
         c.IS_NULLABLE,
         IFNULL(c.COLUMN_DEFAULT, 'NULL'),
         c.EXTRA)
FROM information_schema.COLUMNS c
JOIN information_schema.TABLES  t
  ON t.TABLE_SCHEMA = c.TABLE_SCHEMA
 AND t.TABLE_NAME   = c.TABLE_NAME
WHERE c.TABLE_SCHEMA = '${SCHEMA}'
ORDER BY c.TABLE_NAME, c.COLUMN_NAME;
" > "${OUT}"

echo "lines  : $(wc -l < "${OUT}")"
echo "first  : $(head -1 "${OUT}")"
