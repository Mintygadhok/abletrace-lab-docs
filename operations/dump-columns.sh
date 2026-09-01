#!/usr/bin/env bash
# S146 - dump every column of every table and view in abletracelab_live.
# Usage: bash dump-columns-s146.sh prod
#        bash dump-columns-s146.sh dev
# Read-only. Writes one file under /tmp and prints its line count.

set -euo pipefail

LABEL="${1:-}"
if [ -z "$LABEL" ]; then
  echo "ERROR: pass a label - prod or dev"
  exit 1
fi

OUT="/tmp/columns-${LABEL}.txt"

mysql abletracelab_live -B -N -e "
SELECT CONCAT(
         t.TABLE_TYPE, '|',
         c.TABLE_NAME, '|',
         c.COLUMN_NAME, '|',
         c.COLUMN_TYPE, '|',
         c.IS_NULLABLE, '|',
         IFNULL(c.COLUMN_DEFAULT, 'NULL'), '|',
         c.EXTRA
       )
FROM information_schema.COLUMNS c
JOIN information_schema.TABLES  t
  ON t.TABLE_SCHEMA = c.TABLE_SCHEMA
 AND t.TABLE_NAME   = c.TABLE_NAME
WHERE c.TABLE_SCHEMA = 'abletracelab_live'
ORDER BY c.TABLE_NAME, c.COLUMN_NAME;
" > "$OUT"

echo "--- wrote $OUT"
wc -l "$OUT"
echo "--- first line:"
head -1 "$OUT"
