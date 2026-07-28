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

**THE BROWSER CACHES ITS SECURITY VERDICT TOO**
Chrome decides secure/not-secure once, when a page loads, and a long-open
tab keeps that verdict through reloads. S87 spent an hour treating a red
"Not Secure" chip on both boxes as a server fault; certificates were valid
to October and http was redirecting to https on both. Cmd+Q cleared it.
Same family as J66 lazy chunks: before diagnosing anything TLS-shaped,
full-quit the browser first.

**TWO SCREENS ARE BOTH CALLED "DISPATCH ORDERS"**
`/Dispatch-orders` is the list, with Back and Create Packing Slip. The
DIALOG that opens on top of Create Packing Slip is DoListComponent. Both
carry that heading and both have a Search box in the same place. A console
reading was taken on the wrong one in S87 and read as a null result.

**RAW GITHUB URLS SERVE STALE CONTENT**
The CDN caches. Reasoning that it "should be fine" has been wrong more than
once. Test it, do not argue it.
---

## JT — FOCUS DECIDES WHETHER A KEYSTROKE TEST MEANS ANYTHING

```
A key event only reaches the element that HOLDS FOCUS. Clicking into
DevTools — the Console, the Search panel, anywhere — takes focus OUT of
the page. Press Enter after that and the app receives nothing.

S87 concluded "pressing Enter ticks nothing, the (keyup.enter) binding
is broken" and wrote two hypotheses into NOW off the back of it. S90
spent most of a session investigating. The binding was never broken.
Clicking the field first and pressing Enter ticked correctly on the
first attempt.

⚠ THE RULE: before reporting that a keystroke does nothing, state where
  the focus was. If the answer involves having clicked DevTools first,
  the test is void. Re-run it with the cursor visibly in the field and
  nothing clicked in between.

⚠ THE WIDER SHAPE: a negative observation ("nothing happened") is only
  evidence if the setup could have produced a positive one.
```

---

## JT — AN ABSENT CONSOLE LOG IS NOT EVIDENCE OF ANYTHING

```
Through all of S90 the diagnostic console.log inside onScan NEVER
PRINTED — not once — while onScan demonstrably ran and ticked rows.

This was not a stale build. DevTools Search proved the string present in
the chunk the browser had actually loaded:
  9576.1fe196695fc02a9c.js   served from dev.mintekfoodsafety.com
  do-list.component.ts:153   via sourcemap
Cause never established.

NOW ALSO CARRIED A FALSE CLAIM built on this: "DoListComponent logs on
open at line ~44". It does not, or the log is never reached. That claim
became a DECISION RULE in the handover ("if nothing appears on open, the
browser is not running the deployed chunk") and nearly sent S90 chasing a
caching problem that did not exist.

⚠ THE RULE: do not build a decision rule on a log line nobody has
  watched appear. Verify the log fires before treating its absence as a
  signal.
```

---

## JT — A BARCODE THAT OVERRUNS THE LABEL PRINTS INVALID, NOT FAINT

```
ZPL draws the barcode from ^FO<x> at module width ^BY<n>. Nothing warns
when the result runs past the label edge — it simply prints as far as
the media goes and the tail is gone. Losing the stop pattern makes the
symbol INVALID, so a scanner will not beep at all. Silence reads exactly
like a dead scanner, a flat battery, or a disabled symbology.

⚠ THE ARITHMETIC, on a 4x4 label at 203 dpi = 812 dots:
    Code 128 packs DIGIT PAIRS two-to-a-symbol, but any letter or dash
    forces one module per character.
      "260530"       6 digits       ~68 modules  x BY4 = ~272 dots
      "Pdt-260718-1" 12 alphanum   ~167 modules  x BY4 = ~668 dots
    Same ^BY, same printer, nearly 2.5x the width. At ^FO256 the second
    one ends around 924 — off the label.

⚠ THE TELL: the barcode sits visibly off-centre, with a large margin on
  one side and none on the other. Check ^FO + estimated width against
  the media width BEFORE blaming hardware.

⚠ WHAT WAS WRONGLY BLAMED FIRST, in order: the scanner, print quality,
  a disabled symbology, a changed scanner config, and app code. All
  wrong. The content had grown; the layout had not.

⚠ AND: a factory reset was advised on the scanner to fix this. It was
  not the cause, and a reset WIPES any custom configuration the unit was
  carrying. Do not reset a working scanner to chase a barcode fault.
```

---

## JT — CLAUDE MAPPING COMMITS TO SESSIONS FROM MEMORY

```
S90 opened by asserting that backend HEAD 13e3fcd was an S84-era commit,
and reasoned from there that NEITHER BOX carried 44759a9 — the P53
cancel-packing-slip fix — on a live-client box. Stated with more
confidence than it deserved.

git log settled it in one command: 13e3fcd is S86 P56, with 44759a9
directly beneath it. Both boxes were correct and always had been.

⚠ THE RULE: a commit's session, purpose or ordering is a FACT ON THE
  BOX, not a recollection. Read git log before building any argument on
  which commit is which — especially before saying something is missing
  from prod.
```

---

## RULES CORRECTION OWED (→ P68)

```
The OPEN block restored in S87 cannot be pasted. Its prose sits inside
the same fenced box as the commands, so the terminal receives
"(Fuller version, plus the host check, lives in 3B.5.)" and dies with
  zsh: parse error near `)'
It also carries a bare `git status --short` with no -C, which from ~ on
dev runs against no repository at all and reports nothing useful.

REPLACE THE COMMAND LIST WITH:

  git -C ~/abletrace-lab-frontend rev-parse --short HEAD
  git -C ~/abletrace-lab-backend rev-parse --short HEAD
  git -C ~/abletrace-lab-frontend status --short
  git -C ~/abletrace-lab-backend status --short
  pm2 status
  curl -s -o /dev/null -w "%{http_code}\n" localhost:1337

and keep every warning line OUTSIDE the fenced command block.
```

---

## JT — BROWSER PRINT IS THE JAVA PROCESS ON 9100. IT IS NOT AN INTRUDER.

```
Zebra Browser Print ships its own bundled Java runtime, so it appears in
lsof and ps as "java" with no vendor name. IT HOLDS BOTH 9100 AND 9101,
under ONE process id.

  /Applications/Browser Print.app/Contents/MacOS/jre/bin/java

⚠ 3B.7 SAID THE OPPOSITE for an unknown number of sessions — that a
  Java process may occupy 9100 and block Browser Print, and should be
  killed. That is BACKWARDS. Following it tells a client to kill their
  own printer software. Corrected S91 (P76).

⚠ WHAT IT COST: S90 killed that process and also accepted the browser
  certificate, then could not tell which had fixed printing. S91 proved
  the certificate was the barrier — but ALSO found the kill-and-reopen
  probably fixed a SECOND, separate fault (an empty device list). Two
  faults, one fix each, and the record had collapsed them into one
  mystery.

⚠ THE RULE: "a java process" names a RUNTIME, not a program. Read the
  full path with  ps -p <pid> -o command=  before concluding anything
  about what it is.
```

---

## JT — A LOCALHOST CERTIFICATE IS TRUSTED PER BROWSER AND PER USER

```
Browser Print serves https on localhost with a SELF-SIGNED certificate
it generates AT INSTALL on that machine. Browsers reject it by default.

⚠ ACCEPTING IT IN ONE BROWSER DOES NOTHING FOR ANOTHER. Proven S91:
  Chrome printed successfully while Safari, same machine, same moment,
  same running helper, could not connect at all.
⚠ IT IS ALSO PER USER ACCOUNT. Safari stored it with NO admin password,
  so nothing was written machine-wide. A second login on the same Mac
  starts from zero.
⚠ IT SURVIVES a full browser quit AND a restart. So it is not fragile —
  it is just narrow.
⚠ REINSTALLING OR UPGRADING Browser Print GENERATES A NEW CERTIFICATE.
  Every browser exception on that machine breaks at once, silently, and
  the app shows only "Failed to fetch".

⚠ WHY THE APP CANNOT DIAGNOSE IT: a browser that rejects a certificate
  tells the page NOTHING, by design. Untrusted certificate, helper not
  running, and helper never installed all produce the identical error.
  The app can only list what to check.

⚠ THE SEARCH RESULTS ARE WRONG ON THIS. Public setup guides say
  accepting once "usually works in other browsers too". Disproven on the
  box S91. Trust the machine over the guide.
```

---

## JT — HTTP 200 IS NOT "ACCEPTED". READ WHAT CAME BACK.

```
S91 ran certbot update_account to put an email on prod's Let's Encrypt
account. Certbot printed "Your e-mail address was updated". The server
returned HTTP 200. BOTH WERE MISLEADING.

The returned account object contained key, createdAt and status — AND NO
CONTACT FIELD. Content-Length was 467 bytes before and after: identical.
Nothing had changed. certbot show_account had been right all along and
was talked past twice.

CAUSE: LET'S ENCRYPT ENDED EXPIRATION NOTIFICATION EMAILS ON 4 JUNE 2025
and no longer stores contact addresses. Their own community forum notes
that Boulder still returns 200 while storing nothing.

⚠ THE RULE: a success message from a client tool is the CLIENT's claim.
  A 200 means the request was processed, not that it did what you asked.
  Read the returned object. If the tool caches nothing locally (certbot's
  regr.json body is {}), the log of the server's REPLY is the only truth.

⚠ THE WIDER SHAPE: an assumption inherited from the documentation sent
  40 minutes into a change that could never have worked. The docs said
  the missing email was the risk. The conclusion was right; the mechanism
  was wrong; the implied fix was impossible.
```

---

## JT — THE DEPLOY BACKUP IS NAMED AFTER THE BUILD THAT REPLACED IT

```
deploy-frontend.sh backs up the CURRENT live directory to
/home/ubuntu/www-html.bak-<label>, where <label> is the INCOMING build.

  So  www-html.bak-prod-275c025039d7  contains the build that was live
  BEFORE 275c025039d7 — NOT 275c025039d7 itself.

⚠ THE ROLLBACK LINE THE SCRIPT PRINTS IS CORRECT, but reads as though
  you are restoring TO the new build. Under pressure that inverts.

⚠ THE USEFUL SIDE: the newest backup directory names the build you are
  CURRENTLY serving. That is how S91 discovered prod had been running
  8997acdcf4ab since 26 July — a deploy NO DOCUMENT RECORDED. The
  record only ever carried the git checkout, which lags and means
  nothing. → P81
```

---

## JT — "NOT SECURE" HAS MORE THAN ONE CAUSE, AND NEITHER IS THE SERVER

```
Chased twice now, different cause each time, same wasted hunt.

S87  A long-open tab held a CACHED security verdict. Certificates were
     valid and http was redirecting on both boxes. Cmd+Q cleared it.
S91  Dev showed "Not Secure" on /login. The vhost was FINE —
     curl -I http://dev.mintekfoodsafety.com returned 301. The BOOKMARK
     pointed at http://, so the chip appeared for the instant before
     the redirect completed.

⚠ THE RULE: before touching nginx or certbot, do two things — full-quit
  the browser, and curl -I the http:// address. A 301 means the server
  is doing its job and the fault is on the client side.

