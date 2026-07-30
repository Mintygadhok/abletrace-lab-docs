# TRAPS

Last appended: S94.

Only things that bit twice or cost real hours. A line goes in when it
bites again — not every session. Never cut, never reorganised.

⚠ MERGED S93: the separate TRAPS-additions-S92.md has been folded into
  this file, as instructed. There is now ONE traps file. Nothing was cut
  or reordered; the S92 edit was inserted where it was marked to go and
  the rest appended.

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
⚠ STILL OWED AS AT S93 CLOSE. THIRD SESSION RUNNING.

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

⚠ ON PROD, ADD THIS SEVENTH LINE. The git checkout lags the served build,
  so it is the ONLY reliable read of what prod is actually serving:

  ls -1dt /home/ubuntu/www-html.bak-* | head -1
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
S92  Chased TWICE MORE in one session, on a second Mac. Same two
     causes, no new mechanism. FOURTH AND FIFTH TIME.

⚠ THE RULE: before touching nginx or certbot, do two things — full-quit
  the browser, and curl -I the http:// address. A 301 means the server
  is doing its job and the fault is on the client side.

⚠ AND THE SEPARATE, PERMANENT CASE — see the localhost entry below.
  Do not confuse them: on an app URL the chip is a fault to clear,
  on localhost:9101 it is normal forever.
```

---

## JT — LABEL PRINTING HAS THREE BARRIERS, NOT ONE

```
S91 documented ONE barrier — the self-signed certificate — and closed
the question. S92 walked a clean second Mac as a client and found
THREE, all real, all required, and they fire in a FIXED ORDER:

  1 CERTIFICATE        Browser warning at https://localhost:9101.
                       Cleared via Advanced → Proceed.
                       Scope: PER BROWSER, PER USER. Stored: browser.

  2 CHROME LOCAL NET   "<site> wants to Access other apps and services
                       on this device"   Block / ALLOW
                       Scope: PER BROWSER, PER SITE. Stored: Chrome
                       site settings.

  3 BROWSER PRINT      "<site> wants to access your Zebra Devices.
                       Allow <site> and add it to the accepted hosts
                       list?"   Cancel / No / YES
                       Scope: PER USER, PER HOSTNAME. Stored: Browser
                       Print's own Accepted Hosts list.

⚠ THE ORDER IS FIXED AND IT IS WHY ONLY ONE WAS EVER SEEN. Barrier 1
  blocks the connection outright, so 2 and 3 CANNOT FIRE until it is
  cleared. S91 cleared the certificate, saw printing work, and
  concluded the certificate was the whole story. It was the first
  gate of three.

⚠ 2 AND 3 FIRE ON THE FIRST PRINT, NOT DURING INSTALL. Anyone
  documenting setup and stopping at "it prints" will miss both.

⚠ CLICKING Block OR No BREAKS PRINTING SILENTLY AND PERMANENTLY, and
  the two are undone in DIFFERENT PLACES:
    Chrome  Settings → Privacy and security → Site settings → the site
    Browser Print  menu bar icon → Settings → Blocked Hosts →
                   Delete Selected
  The app shows only "print failed" for either.

⚠ PER HOSTNAME, PROVEN: dev.mintekfoodsafety.com and
  trace.mintekfoodsafety.com are SEPARATE Accepted Hosts entries.
  Testing on dev does NOT pre-authorise prod.

⚠ BROWSER PRINT'S CONTROLS ARE IN THE MENU BAR, TOP RIGHT, NOT THE
  DOCK. Clicking the Dock icon appears to do nothing. Cost real
  minutes in S92 to somebody who already knew the app existed.

⚠ THE WIDER SHAPE: "it worked after I did X" identifies A barrier,
  never THE barrier — because a gate that is still closed downstream
  cannot announce itself. Same family as S90's kill-and-reopen, where
  two faults had one fix each and the record collapsed them into one
  mystery. When a fix works, ask what ELSE would have been invisible
  until that moment.
```

---

## JT — ON localhost, "NOT SECURE" IS PERMANENT AND MEANS NOTHING

```
Accepting a self-signed certificate stops the browser BLOCKING the
connection. It does NOT turn the padlock green. The chip on
https://localhost:9101 reads Not Secure forever, on every machine,
including while printing works perfectly.

PHOTOGRAPHED S92, one screen: chip red "Not Secure", printer listed in
full (usb#vid_0a5f&pid_00d5#52N224501603, ZPL), label printed.

⚠ THE TRAP: this is the SAME CHIP that has been a real fault twice on
  app URLs (see the Not Secure entry above). On localhost it is
  meaningless. Reading it as a health indicator will mislead every
  time, and a client will read it exactly that way.

⚠ NOW IN THE CLIENT GUIDE for that reason.
```

---

## JT — A HANDOVER NOTE IS NOT THE RECORD. NOW SUPERSEDES IT.

```
S92 opened with an S92-opening-note.md written DURING S91, before
S91 finished. Claude read it as current and told Minty that the
275c0250 prod artifact still needed promoting and that P72 had not
reached Glutenull.

BOTH WERE ALREADY DONE. NOW.md, written at S91 CLOSE, recorded the
promote to dev AND prod with scanner verification. The note also
listed P75, P76 and P78 as new/open when NOW had all three closed,
and described P58 as a different item entirely.

⚠ THE RULE: a note written mid-session freezes at the moment it was
  written. NOW.md is rewritten at CLOSE and is the only current
  record. WHERE THEY DISAGREE, NOW WINS — always, without checking.

⚠ WHY IT MATTERS MORE THAN IT LOOKS: the note is pasted FIRST and
  reads as a brief, so it frames everything after it. Claude acted on
  it for two turns before NOW arrived and contradicted it.

⚠ S93 ADDENDUM — THE RULE HAS A PRECONDITION NOBODY CHECKED. "NOW
  wins" assumes NOW is the close-of-last-session record. In S93 it was
  not: the repo held the S87 version, five sessions stale, because the
  S91 and S92 rewrites were downloaded and never committed. See the
  next entry.
```

---

## JT — "A JAVA PROCESS" AND "A SECURITY WARNING" NAME NOTHING

```
Extension of the existing Browser Print / java entry, same shape,
different surface.

S92: Minty reported "a security warning which said something about
accessing your other apps". Claude inferred a macOS permission prompt
and reasoned from there. IT WAS CHROME'S OWN local-network prompt —
different mechanism, different place to undo it, different platform
behaviour.

⚠ THE RULE: a half-remembered dialog is a CATEGORY, not an identity.
  "A security warning", "a java process", "a permission popup" — all
  name a shape and no more. Get the WORDING, or a photograph, before
  building anything on it. The wording is one screenshot away and the
  inference is always cheaper and always worse.
```

---

## JT — THE ZEBRA DOWNLOAD PATH IS NOT WHERE ANYONE LOOKS

```
Browser Print is NOT under support.zebra.com's "Drivers and
Downloads". It is on the main site:
  zebra.com/us/en/support-downloads/software/printer-software/
    browser-print.html
Breadcrumb: Support and Downloads → SOFTWARE → Browser Print.

⚠ THE DANGER IS NOT GETTING LOST. "Drivers and Downloads" leads to a
  printer DRIVER, which installs the macOS print path and invites
  adding the Zebra in Printers & Scanners — the exact thing the client
  procedure forbids. The wrong door does not dead-end, it succeeds at
  the wrong thing.

⚠ The link is labelled "Download Browser Print For OSX", not Mac.
⚠ The form is plain — country, name, company, email. NO ACCOUNT AND
  NO MFA, despite the site-wide MFA banner (effective 1 July 2026).
```

---

## JT — A DOCUMENT THAT IS WRITTEN BUT NEVER COMMITTED DOES NOT EXIST

```
S93 opened by pasting NOW.md. It was the S87 version, dated 27 July,
FIVE SESSIONS STALE. The first stretch of the session went on
establishing that the record — not the boxes — was what was wrong.

CAUSE: NOW is rewritten at close, produced in the chat, and downloaded.
Nothing then commits it. The S91 rewrite and the S92 rewrite were both
still sitting in ~/Downloads as NOW (5).md when S93 found them, along
with TRAPS-additions-S92.md and the opening note.

⚠ WHY IT IS WORSE THAN A FILING SLIP: the whole documentation system
  rests on "NOW wins". That rule silently assumes NOW is current. When
  it is not, the rule actively points at the wrong answer, and every
  document that leans on NOW leans the same wrong way.

⚠ THE TELL, and it is cheap: read the "Last rewritten" line against the
  session number you are opening. One glance.

⚠ THE HARDER TELL: the STATE block will not match the boxes. S93's
  stale NOW claimed dev HEAD 734f3305 against an actual 275c0250. The
  health check catches this — but only if someone compares rather than
  skims.

⚠ THE RULE: NOW IS COMMITTED AT CLOSE, IN THE SAME BREATH AS BEING
  WRITTEN. A downloaded file is not the record. Now in RULES.
```

---

## JT — A SLASH IS NOT ALWAYS A DIVISION

```
S93 swept 154 grep hits for `/` to find acrobatics. Six of them looked
exactly like divisions and were not:

  `${element.wgt_kgs_per_unit} ${unit_name} / ${materials_title}`

That slash is TEXT inside a template literal — "2 Kg / Sugar" on screen.
Sites: edit-mlc:126 · edit-mlo:454 · add-mlo:423 · edit-closed-mlcs:209 ·
start-mlc:120.

⚠ A grep for `/` CANNOT distinguish arithmetic from punctuation. Neither
  can a LIKE pattern. Read the expression, not the character.
```

---

## JT — A GREP PATTERN CAN BE INCAPABLE OF FINDING WHAT YOU ASKED IT FOR

```
Two of Claude's own patterns were wrong in S93 in ways that LOOKED
right and returned confident-looking output.

  grep -o "JR1[0-4]*"      Intended: find JR1 to JR14.
                           Actually: matches JR1 and JR10-JR14 ONLY.
                           It CANNOT match JR2 through JR9. The output
                           looked like a complete list and was not.
                           Correct: grep -o "JR[0-9][0-9]*" | sort -u -V

  LIKE '%/%wgt_kgs_per_unit%'   Intended: find divisions BY the column.
                           Actually: matches a slash ANYWHERE before the
                           column name — a comment, a date, an unrelated
                           divide three lines earlier. Produces suspects,
                           never verdicts.

Both were caught before becoming findings. Neither would have announced
itself: a wrong pattern returns rows, and rows read as evidence.

⚠ THE RULE: before trusting a pattern's OUTPUT, ask what it is
  STRUCTURALLY capable of matching. A pattern that cannot express the
  question will still answer it.
⚠ Same family as GREP OUTPUT IS A RENDERED SCREEN — but one layer
  earlier. That entry is about reading results wrongly; this is about
  asking wrongly.
```

---

## JT — THE FIELD ON SCREEN IS NOT ALWAYS THE FIELD THAT IS SAVED

```
Defect 1 hid for months in plain sight. The MO create form:

  WDU          "Shipping Units"  — what the operator types
  displayKg    readonly, visible — derived Kg
  quantity     HIDDEN INPUT      — ⚠ THIS IS WHAT IS SAVED
  batches      shown, disabled

onQtyChange() took the typed value, round-tripped it through batches,
and patched the RESULT into the hidden `quantity` control. saveMLO()
then sent that as obj.qty. So the number the operator entered and the
number stored were different fields, and nothing on screen showed the
one that mattered.

⚠ THE RULE: when a stored value is wrong but the form "looks right",
  find which control actually feeds the save payload. It may not be on
  screen at all. Read the save function, not the visible fields.
```

---

## JT — A ROUNDED INTERMEDIATE FIGURE CAN REACH REAL QUANTITIES

```
`batches` looks like a display convenience. It is not.

  mlomanagement.batches is stored ROUNDED to 3 decimal places —
  7.292 against a true 7.29166… — and is then MULTIPLIED OUT at
    release-mat-details.component.ts:1071  ingredients
    release-mat-details.component.ts:1083  intermediates
    release-mat-details.component.ts:1095  packaging
  to compute final_qty, i.e. HOW MUCH MATERIAL IS RELEASED TO THE FLOOR.
  Also add-mlo:150 and :223 for packaging quantities.

So the rounding does not stay on screen. It slightly over-releases
material on every MO whose plan does not divide evenly. ~5g in 100kg.

⚠ S93 DELIBERATELY DID NOT TOUCH IT while fixing Defect 1 two lines
  away. "Tidying" the batches line would have changed physical release
  quantities on a live client, in a commit whose message said it was
  fixing a display figure. → P89

⚠ THE RULE: before changing how a number is CALCULATED, grep where that
  number is CONSUMED. A figure that is cosmetic in one screen may be
  load-bearing two files away.
```

---

## JT — SHIPPED_QTY IS UNITS-STORED, AND IT HAS BEEN MISREAD THREE TIMES

```
`packingslipdos.shipped_qty` and `dispatchorders.qty_shipped` hold a
UNIT COUNT. The Kg figure beside them is DERIVED BY MULTIPLYING.

MEASURED ON DEV, S94, company 464:
    testpdt260703   20 Kg/unit    qty_to_ship 100    shipped_qty 5
    test1.39        1.39 Kg/unit  qty_to_ship 9.73   shipped_qty 7
7 x 1.39 = 9.73 EXACTLY. Not approximately.

THREE SEPARATE BITES:
  S16  stock-info.component.ts subtracted shipped_qty (units) from
       qty_to_ship (Kg) in the same expression. Fixed by multiplying.
  S93  dispatch-orders printed it raw as Kg AND divided it for the
       unit figure. Diagnosed, not fixed.
  S94  fixed. Same field, third encounter.

⚠ THE RULE: the DO row mixes units and Kg in adjacent columns, and
  every neighbouring field reads plausible. Before combining or
  dividing anything on that row, look the column up in GR7. Do not
  infer the basis from the column name — qty_to_ship and qty_shipped
  sit side by side and are OPPOSITE bases.

⚠ THE KNOWN-GOOD SHAPES, both already in the codebase:
    frontend  edit-packslips.component.ts:280   units# (units x wgt Kg)
    SQL       Trace_ProductOneStepForward_SP    shipped_qty * wgt
  Copy one. Do not invent a third.
```

---

## JT — TWO DOCUMENTS CAN BOTH CLAIM TO BE CURRENT

```
S93's trap was a STALE document. This is its sibling and it is worse:
TWO LIVE DOCUMENTS, neither stale, both authoritative, disagreeing.

FOUND S94, and it had stood for an unknown number of sessions:
  Section 0's standing paste  =  Section 0 + Section 1 + Section 5
  PLAN's paste list           =  RULES + NOW + TRAPS + PLAN
  Section 0's rule 9 maps NOW to Section_1.md. NOW does not live there.

So RULES and Section 0 are two heads of one document, and NOW and
Section 1 are the other pair. Following either is defensible. Following
both is impossible.

⚠ WHY IT SURVIVED: neither head is WRONG about anything. They are each
  internally consistent. A staleness check cannot see this — both
  stamps are recent. Only reading them SIDE BY SIDE reveals it.

⚠ THE TELL: two files whose OPENING INSTRUCTION differs. If two
  documents both tell you what to read first, one of them is a head
  that should have been retired.

⚠ SAME FAMILY AS THE A COLLAPSE AND THE G COLLAPSE — but those went
  two-headed WITHIN one file, by append. This went two-headed ACROSS
  files, by a fold that retired the content and left the container.
  Rule 9E catches the first shape and not the second.

⚠ AND THE PART THAT MATTERS: the retired head is not empty. Section 0
  carries five load-bearing rules RULES does not. Deleting it loses
  them; keeping it keeps the contradiction. → P95
```

---

## JT — A PLACEHOLDER IN A COMMAND BLOCK WILL BE PASTED LITERALLY

```
Twice in S94, Claude wrote a command containing a stand-in and Minty
pasted it exactly as given, because that is what a command block means.

  mysql --defaults-file=/tmp/dev.cnf ...
      → ERROR 1049 Unknown database '...'
  ~/promote.sh ~/Downloads/dist-dev-c2a52d8e<rest-of-sha>.zip dev
      → -bash: rest-of-sha: No such file or directory

Neither was ambiguous to Claude. Both were unambiguous to bash too,
which is the problem: a placeholder is valid syntax.

⚠ THE RULE: a command block contains ONLY what is to be typed. If
  Claude does not know a value, it does not write the command — it asks
  for the value first, or gives a form that does not need it:
      type the stem and press Tab
      ls -1t ~/Downloads/dist-* | head -5   then read the name back

⚠ AND THE ANGLE BRACKETS ARE THEIR OWN HAZARD: `<` is a shell
  redirect. A placeholder in brackets does not just fail, it fails
  with an error about the wrong thing entirely.

⚠ SAME SHAPE AS THE PROSE-INSIDE-THE-FENCE FAILURE (P68): anything
  inside a command block is a command. Explanations, placeholders and
  warnings all live OUTSIDE it.
```

