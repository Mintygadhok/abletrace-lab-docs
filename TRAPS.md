# TRAPS

Only things that bit twice or cost real hours. A line goes in when it
bites again — not every session. Never cut, never reorganised.

---

**A POPULATED FK IS AN OBJECT, NOT A NUMBER**
Read via Waterline populate, a status or id comes back as an object and is
never `=== 2`. It fails silently — the gate just never fires. Read via a
stored proc, the same field is a bare number and `?.id` is undefined, also
silently false. Confirm the read path before comparing. Bit twice, 19
sessions apart (mlc_status, then role_id).

**WATERLINE SILENTLY DROPS UNDECLARED COLUMNS**
A column written via `.update().set()` is discarded with no error unless it
is declared in the model's attributes. The DB column alone is not enough.
Any new column needs both.

**NEVER TWO COLLECTIONS IN ONE nestedPop POPULATE ARRAY**
v0.1.4 silently returns the second one empty. Use a dedicated second pass
and stitch by index. Food-safety-critical when it bit — subrecipe
formulations vanished.

**THE LIVE PATH IS NOT THE OBVIOUS ONE**
Release runs `createReleaseMaterialProductsV2`, not the older single
function sitting beside it in the same file. An edit on a dead path is an
invisible no-op. Trace controller to model to the function the button
actually calls, before editing.

**"DEAD CODE" IS A CLAIM ABOUT REACHABILITY, AND REACHABILITY IS CHECKABLE**
`PackingSlips.js:333-334` was recorded as dead for sessions. It is live
code that throws — unreachable only because the frontend button reaching it
is commented out, and the redesign restores that button. A right
instruction for a wrong reason stops anyone looking again.

**GUARD JSON-COLUMN READS WITH Array.isArray**
Not a null-check. A JSON column may return a string, and a string does not
throw on spread — it silently spreads into characters and corrupts the
array. `Array.isArray(x) ? x : []` is correct under both drivers.

**EDITS ARE INVISIBLE TO ROW COUNTS — AND SOME PROPAGATE**
In-place updates change no row count. Worse: editing one material's
allergen silently rewrote the allergen on seven products and on their
already-completed production lots, with zero rows added or removed. Verify
edits by SELECT value comparison, never by counting.

**THE DO ROW MIXES UNITS**
`dispatchorders.qty_to_ship` is Kg. `qty_shipped` and `packing_units` are
UNITS. Same row. Any calculation combining them must convert first.

**do_status NEVER ADVANCES**
It stays "Created" even after a full ship. The authoritative shipped state
is `packingslips.shipped_flag`. Never read do_status to determine shipped.

**MO CLOSE IS NOT MO COMPLETE**
Closing sets `close_status=1` and leaves `mlc_status` unchanged. Full
receipt does not auto-close. "Still open" tests close_status; "production
complete" tests `mlc_status=4`. Different questions.

**HACCP READS MUST ORDER BY step, NEVER id**
Hazard rows insert in parallel, so ids land in completion order, not step
order. A HACCP document that reads out of sequence is wrong.

**A BUTTON INSIDE A FORM NEEDS type="button"**
No type attribute defaults to submit, and the implicit submit eats the
click. The button silently does nothing.

**NEVER VERIFY A CONVERSION PATH WITH A 1:1 FIXTURE**
A weight ratio of exactly 1 makes a division invisible — 10/1 reconciles
whether the code divides or reads the stored value. Pick a product whose
`wgt_kgs_per_unit` is not 1, and ideally not round. A 1:1 test produced a
confident wrong conclusion that became a documented finding.

**WHEN AN ERROR IS HIDDEN, GO TO THE BROWSER CONSOLE FIRST**
nginx-level rejections (413, 502) never reach pm2 logs — Sails never runs.
The `alert()` plague renders every error as "[object Object]". One session
lost 40 minutes extracting a string the Console showed in 90 seconds.

**GREP OUTPUT IS A RENDERED SCREEN AND CAN LIE**
A missing dot in `datastore.sendNativeQuery` was a terminal paste artifact,
not a file defect. Verify a suspected typo against the file with `cat -A`,
never the grep echo.

**GREP THE PATTERN, NOT JUST THE BUG**
One bug is usually four. Grepping "oldFiles" found the identical unguarded
read in four models — one crashed, two were safe only by accident of their
data, one was safe by code.

**SOME CODE IS DELIBERATELY WRONG — DO NOT FIX IT**
`mlcpackaging` stores flat per-level quantities; the cascade is computed at
read time. Intermediates are not imported — manual entry post-upload, by
design. The `batch_qty` pencil-edit block was uncommented deliberately and
shipped. PS and SO create paths seed `[]` — that is the only reason their
reads were safe before the guards, so do not tidy the seeding away.

**THE CANCEL-PACKING-SLIP GAP IS ACCEPTED, NOT MISSED**
`inActivatePS` gates on `status_id: 1`, but shipping sets `shipped_flag`,
not `status_id` — so a shipped slip still satisfies the gate. Only the
frontend hides the button. Minty's ruling, S86: keep it closed in the
front end, revisit only if it matters later. Do not re-raise this as a
bug. ⚠ What WOULD reopen it: the cancel endpoint becoming reachable by
any route other than that screen — a second caller, an API client, a
script. The ruling assumes the frontend is the only door.

**DEV AND PROD ARE SEPARATE RDS INSTANCES**
The same fixture (464) has different row ids on each. Never compare ids
across boxes. And name the database explicitly — a bare `mysql` on prod
lands in the dormant archive.

**RAW GITHUB URLS SERVE STALE CONTENT**
The CDN caches. Reasoning that it "should be fine" has been wrong more than
once. Test it, do not argue it.
