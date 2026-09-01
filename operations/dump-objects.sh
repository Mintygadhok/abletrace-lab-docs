#!/usr/bin/env bash
# S146 - dump procedures, functions, triggers and foreign keys in abletracelab_live.
# Usage: bash dump-objects-s146.sh prod
#        bash dump-objects-s146.sh dev
# Read-only. Writes one file under /tmp and prints a per-section count.
#
# Body text is included for routines and triggers, so a routine that exists on
# both boxes but has DIFFERENT LOGIC will show up as a difference.
# Newlines are flattened so one object stays on one line and diff stays readable.

set -euo pipefail

LABEL="${1:-}"
if [ -z "$LABEL" ]; then
  echo "ERROR: pass a label - prod or dev"
  exit 1
fi

DB="abletracelab_live"
OUT="/tmp/objects-${LABEL}.txt"

echo "host: $(hostname -s)"

{
mysql "$DB" -B -N -e "
SELECT CONCAT('ROUTINE|', ROUTINE_TYPE, '|', ROUTINE_NAME, '|',
              REPLACE(REPLACE(REPLACE(IFNULL(ROUTINE_DEFINITION,''),'\r',' '),'\n',' '),'\t',' '))
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='$DB'
ORDER BY ROUTINE_TYPE, ROUTINE_NAME;
"

mysql "$DB" -B -N -e "
SELECT CONCAT('TRIGGER|', TRIGGER_NAME, '|', EVENT_MANIPULATION, '|',
              ACTION_TIMING, '|', EVENT_OBJECT_TABLE, '|',
              REPLACE(REPLACE(REPLACE(IFNULL(ACTION_STATEMENT,''),'\r',' '),'\n',' '),'\t',' '))
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA='$DB'
ORDER BY TRIGGER_NAME;
"

mysql "$DB" -B -N -e "
SELECT CONCAT('FK|', k.CONSTRAINT_NAME, '|', k.TABLE_NAME, '|', k.COLUMN_NAME,
              '|->|', k.REFERENCED_TABLE_NAME, '|', k.REFERENCED_COLUMN_NAME,
              '|', IFNULL(r.UPDATE_RULE,''), '|', IFNULL(r.DELETE_RULE,''))
FROM information_schema.KEY_COLUMN_USAGE k
LEFT JOIN information_schema.REFERENTIAL_CONSTRAINTS r
  ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA
 AND r.CONSTRAINT_NAME   = k.CONSTRAINT_NAME
WHERE k.CONSTRAINT_SCHEMA='$DB'
  AND k.REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY k.TABLE_NAME, k.CONSTRAINT_NAME, k.COLUMN_NAME;
"
} > "$OUT"

echo "--- wrote $OUT"
wc -l "$OUT"
echo "--- counts by kind:"
awk -F'|' '{print $1}' "$OUT" | sort | uniq -c
