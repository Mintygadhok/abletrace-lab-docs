# SECTION 1 — NOW

> Rewritten WHOLE every session. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5.

---

## ▶ RESUME HERE — S86 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S85 — SLICE 4b BUILT, SHIPPED TO DEV AND VERIFIED
               LIVE (453f1f44). And THE CANCEL DEFECT WAS FOUND,
               REPRODUCED AND DIAGNOSED. The S84 "DO-0010 vs
               DO-0011" mystery is dissolved — it was never an
               anomaly, just cancel COUNT.
               P52 print-slip redesign designed and FROZEN.

THIS SESSION   S86 — CANCEL FIRST, IN THIS ORDER:
                 1  Is REAL CLIENT DATA affected? One read-only
                    query on PROD, before any code.
                 2  Read the cancel code, find the defect, fix it.
                 3  Prove it — cancel a slip, watch the tally return.
                 4  Heal bad rows (prod if needed; dev fixtures are
                    housekeeping, not a goal).
                 5  Mirror the 4b row template to CREATE.
                 6  Promote — BACKEND FIRST, THEN FRONTEND (J96).

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Web       https://github.com/Mintygadhok/abletrace-lab-docs
  ⚠ CLAUDE CANNOT BUILD A FETCH URL ITSELF. A raw URL is only
    fetchable if it appears IN THE CHAT AS TEXT. Minty pastes
    ONE raw URL, e.g.
      https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_5.md
    and Claude can then fetch the rest. Proven S85.
  ⚠ A SCREENSHOT OF A URL DOES NOT COUNT. It must be text.
  ⚠ THE GITHUB WEB PAGE READS AS README-ONLY when Claude fetches
    it — the file list is stripped by the extractor. That is a
    rendering artifact, NOT a missing repo. Do not re-raise it.
  ⚠ CACHE  the raw URL can lag a fresh commit. Minty's web view is
    immediate truth. If a fetch looks stale, paste the section.

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    ⚠ RE-PROVEN S85 on a NON-1:1 FIXTURE: test1.39 is 1.39 Kg per
      unit and renders 1# (1.390 Kg) correctly. That satisfies
      JT21 — every earlier proof used 1:1 or 20:1.
  • THE PACKING SLIP FLOW (Minty, S82): move DOs → SAVE → shipping
    reference + vehicle condition → SHIP (terminal). → J97.
  • SHIPPED QUANTITY IS NOT AN OPERATOR INPUT (Minty, S84).
  • ⚠ NEW, S85 — THE DO ROW IS A READ-ONLY DISPLAY OF THE DISPATCH
    ORDER. Nothing on it is typed. To change what is on the slip,
    remove the DO and add a different one. (Minty, S85.)
    ▶ Belongs in Section 2 — fold with P41.
  • ⚠ NEW, S85 — THE UNIFORM QUANTITY STRING:
        <units># (<Kg> <uom>)      e.g.  1# (20.000 Kg)
    Units read STORED, Kg DERIVED by multiplying. (Minty, S85.)
  • ⚠ THE RECONCILE ORACLE. A DO's qty_shipped must ALWAYS equal
    the sum of its packingslipdos rows. Block below. Empty = clean.
```

---

## ⚠⚠ P53 — THE CANCEL DEFECT. FOUND, REPRODUCED, DIAGNOSED S85.

```
⚠ THIS BLOCKS PROMOTION OF P7. Read this before touching anything.

THE SYMPTOM    Cancelling a packing slip DELETES its packingslipdos
               join rows but LEAVES dispatchorders.qty_shipped
               untouched. The DO's tally climbs and never comes back.

THE EVIDENCE   S85, four DOs, arithmetic fits every one:
                 DO-0004  1 → +1 (PS-0018) → cancel
                              → +1 (PS-0019) → cancel   = 3 / 0 rows
                 DO-0005  same history                   = 3 / 0 rows
                 DO-0010  2 → cancel PS-0016 → +1 PS-0020 = 3 / 1 row
                 DO-0011  1 → cancel PS-0016 → +1 PS-0020 = 2 / 1 row
               ⚠ TWO OF THESE (0004, 0005) WERE CLEAN at the start
                 of S85 and drifted during the session. Reproduced
                 live, not inherited.

CONFIRMED      Minty confirms he used CANCEL (whole slip), not
               Remove (one row). So the guilty path is the
               WHOLE-SLIP CANCEL.

FRONTEND       INNOCENT. deletePs() (edit-packslips.component.ts
               ~:642) walks packslip.Refer_DOs and sends per-DO
               shipped_qty in the payload. The data the backend
               needs is on the wire.

BACKEND        inActivatePS — ⚠ NOT YET READ. That is the first
               file to open in S86.

⚠ THIS CONTRADICTS THE SETTLED DOMAIN RULE (Minty S81, J92): "a DO
  coming off a packing slip ALWAYS returns its quantity". The rule
  is right; the code does not implement it.

⚠ IT DISSOLVES THE S84 MYSTERY. DO-0010 drifted and DO-0011 did not
  on the same slip. Nothing differed about the DOs — DO-0010 had
  simply been through one more cancel. Not an anomaly. → J105.

⚠⚠ SLICE 1 IS NOW SUSPECT, NOT MERELY UNVERIFIED.
   Slice 1 (backend ff5d183) fixed deletedDos BY MIRRORING
   inActivatePS. If inActivatePS never returns the quantity, slice 1
   copied a broken pattern into the remove-one-DO path.
   ▶ READ BOTH TOGETHER. DO NOT FIX ONE IN ISOLATION.

⚠⚠ PROD RUNS THE SAME CANCEL CODE, WITH A REAL CLIENT.
   Nothing in P7 touched deletePs/inActivatePS, and slice 1 was
   never promoted. So prod almost certainly behaves identically —
   ⚠ A READING, NOT A PROOF. Prod's copy has not been read.
   IF GLUTENULL HAS EVER CANCELLED A PACKING SLIP, THEIR
   qty_shipped IS OVERSTATED RIGHT NOW. Real traceability data.
   ▶ S86 STEP 1, BEFORE ANY CODE: run the oracle on PROD.
     Read-only. Empty = forward fix only. Not empty = a data heal
     must be planned and the job changes shape.

⚠ LEAVE THE FOUR DEV ROWS AS THEY ARE until the fix is proven.
  They are the reproduction. Minty's call, S85: the CODE is the
  target — test data is recreatable and irrelevant by itself.
```

---

## ⚠⚠ P7 — WHAT IS LEFT. REVISED S85.

```
DONE AND PROVEN
  SLICE 2   auto-select by lot+customer+address. Proven 3x,
            including twice in S85.
  SLICE 3   stored packing_units instead of dividing Kg. S82.
  SLICE 4a  Save/Ship split; shipped_qty posts the unit count;
            Ship gated on both shipping fields. S82–S84.
  SLICE 4b  ✅ S85, commit 453f1f44. Unified READ-ONLY DO row on
            the EDIT screen. Built green, deployed, verified live.
            → J104.

⚠ DONE BUT SUSPECT
  SLICE 1   backend ff5d183. See the P53 block above.

STEP A  ⚠ FIX CANCEL (P53). BLOCKS EVERYTHING ELSE.

STEP B  MIRROR 4b TO THE CREATE SCREEN.
        Same eight-field template. Independent of Step A —
        different files, frontend vs backend, so it can proceed
        in parallel if cancel turns out to be big.
        ⚠ P45 AND P49 MUST BE IN THE SAME PATCH.
          create parses its quantity string BY POSITION (:169,
          :265, :296). Under the read-only rule nothing is typed,
          so the parsing and BOTH validators get DELETED, not
          repaired. Change the format without deleting the
          parsing and you silently break what three lines
          enforce — exactly how P49 happened.
        ⚠ READ BEFORE PATCHING: does create populate its HEADER
          customer/address FROM the row controls? Controls survive
          (only markup is removed) so it should be safe. SHOULD,
          not proven.
        ⚠ CREATE HAS AN "Authorized By" FIELD EDIT DOES NOT.
          Decide whether it stays. → domain call.

STEP C  PROMOTE. ⚠ BACKEND FIRST, THEN FRONTEND (J96).

STILL INSIDE P7, SMALL
        · The DO picker POPUP TITLE. (The BUTTON was renamed S84
          and is live.) Minutes.
        · P44 vehicle_condition never written on edit — same file
          as Step B. ▶ RIDE ALONG OR SEPARATE: Minty's call, asked
          S85, not yet answered.

CUT FROM P7 — DO NOT REINSTATE
        · Slice 4c / the sequencing change (S84).
        · The PO barcode → now folded into P52 (S85).

⚠ THE EIGHT FIELDS ARE FINAL AND ALREADY SHIPPED. Minty's S85 cuts
  (drop Order Qty, drop Shipped Units) reduce the S84 ten to
  exactly the eight already live on dev. NO FIELD WORK REMAINS.
```

---

## HEADS — ⚠ verify against the boxes before working (rule 1.2)

```
Frontend  DEV  453f1f44   ⚠ AHEAD OF PROD — S81 s2, S82 s3+4a,
                            S83 cancel, S84 D2 + pre-fill, S85 4b
          PROD 53db203d   served bundle
Backend   DEV  083fc96    ⚠ AHEAD OF PROD — S81 s1, S82 s4a + guard
          PROD d3104ea

⚠ PROD WAS HEALTH-CHECKED IN S85 AND IS CLEAN.
  backend d3104ea, tree clean, pm2 abletrace-backend online,
  curl 1337 = 200. Ubuntu 26.04, kernel 7.0.0-1004-aws.
  Frontend CHECKOUT reads 9bce0238 — the S66 lag trap, expected,
  cosmetic → P8. The SERVED bundle is 53db203d.
  ⚠ THE SERVED BUNDLE ITSELF WAS NOT INDEPENDENTLY READ. Still a
    claim, not a reading.

⚠ THE DIVERGENCE IS DELIBERATE. Do NOT "reconcile" by promoting —
  P7 is mid-build AND the cancel defect is unfixed (rule 5.5).

S85 COMMITS
  frontend  453f1f44  4b: unified read-only DO row template on
                      edit packing slip (2 files, +59 −130)

Dev tree clean at S85 close. Dev health 200. PM2 abletrace-dev online.

ROLLBACK POINTS
  DEV frontend build  /home/ubuntu/www-html.bak-dev-453f1f446318
  DEV frontend .html  /home/ubuntu/edit-packslips.component.html.bak-S85-4b-20260725-041243
  DEV frontend .ts    /home/ubuntu/edit-packslips.component.ts.bak-S85-4b-20260725-041243
  or                  git revert 453f1f44
  PROD frontend       www-html.bak-prod-53db203d4ef4
  DEV backend         /home/ubuntu/PackingSlips.js.bak-S82
  DEV backend         /home/ubuntu/PackingSlips.js.bak-S81
```

## ⚠ CI — PUSH AUTO-BUILDS DEV

```
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → deliberate manual dispatch.
Build time observed S85: ~8 minutes.
⚠ CI warns "Node.js 20 is deprecated" on every build. Housekeeping,
  not our code. Raise it only if a build fails.
⚠ THE ARTIFACT NAME CARRIES THE COMMIT SHA —
    dist-dev-<full-sha>.zip
  Use the SHA to pick the right zip, never the timestamp. → P12.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S85-verified)

```
1  [DEV]  edit + commit + push
2  WEB    github.com/Mintygadhok/abletrace-lab-frontend/actions
          wait for green
3  WEB    open the run, download the artifact
4  [MAC]  ⚠ MATCH BY SHA, NOT BY NAME TYPED FROM A SCREEN.
          S85 lost a round trip to a mistyped filename. Use:
            ZIP=$(ls -t ~/Downloads/dist-dev-<sha8>*.zip | head -1)
            echo "MATCH: ${ZIP:-none}"
            [ -n "$ZIP" ] && ~/promote.sh "$ZIP" dev
5  BROWSER  Cmd+Q ENTIRELY. Not a hard reload. Lazy popup chunks
          survive everything else (J66).

⚠ promote.sh lives on the MAC, not on a box.
⚠ ssh/scp always from the MAC:
    ssh -4 -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
    (the -4 is the S73 IPv6 workaround → P23)
⚠ THE ARTIFACT DOES NOT ALWAYS DOWNLOAD ON THE FIRST CLICK.
  Check with: ls -lt ~/Downloads | head -5
```

## ⚠ HANDING PATCH SCRIPTS TO MINTY — the scp route. WORKED AGAIN S85.

```
⚠ PASTING LONG PATCH SCRIPTS INTO THE TERMINAL FAILS. → P46.

⚠ THE WORKING METHOD, DEFAULT FOR ANY PATCH SCRIPT:
    1  Claude writes the patch and hands it over as a FILE (0.2b)
    2  [MAC]  scp -i ~/.ssh/abletrace-lab-key.pem ~/Downloads/<patch>.py ubuntu@16.55.10.205:/tmp/
    3  [DEV]  python3 /tmp/<patch>.py
    4  [DEV]  git --no-pager diff
  Worked cleanly again in S85.

⚠ MINTY MUST DOWNLOAD THE FILE BEFORE THE scp.
  Confirm with: ls -lt ~/Downloads | head -3
⚠ THE BOX LABEL GOES ABOVE THE BLOCK, NEVER INSIDE IT.
⚠ SHORT COMMANDS PASTE FINE. Only long multi-line scripts fail.
```

## ⚠ THE TWO STANDING QUERIES — build a temp cnf from .env (J43)

```
A bare `mysql` on dev hits a nonexistent local socket. Both blocks
below are ONE PASTE each and self-clean.

⚠ THE RECONCILE ORACLE — run after EVERY quantity change.
  Empty = clean. ⚠ ADD `WHERE d.company_id=464` on dev to scope it;
  on PROD run it UNSCOPED to catch the real client.

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "SELECT d.id, d.internalCode, d.company_id, d.qty_shipped AS tally, COALESCE(SUM(p.shipped_qty),0) AS rows_total, COUNT(p.id) AS row_count FROM dispatchorders d LEFT JOIN packingslipdos p ON p.DO_id=d.id GROUP BY d.id, d.internalCode, d.company_id, d.qty_shipped HAVING d.qty_shipped <> COALESCE(SUM(p.shipped_qty),0);"
rm -f /tmp/q.cnf

GENERAL QUERY — same recipe, swap the SQL after the cnf block:
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "<QUERY>"

⚠ THE JOIN TABLE IS packingslipdos — ALL LOWERCASE. Dev MySQL is
  case-sensitive. "PackingSlipDOs" DOES NOT EXIST. → P48.
```

## ⚠ IDENTIFIERS — TWO SYSTEMS, AND MIXING THEM COST TIME IN S85

```
⚠ THE SCREEN SHOWS internalCode.  THE ORACLE RETURNS id.
  Section 1 previously named slips by DB id ("PS 2389") while the
  same block named others by code ("PS-0010"). Minty could not find
  them. → JT25.

⚠ NEVER NAME A SLIP OR DO BY DB id IN THIS SECTION. Always the
  internalCode Minty can see. If an id is needed, give both.
```

## DEV FIXTURE STATE — ⚠ AS AT S85 CLOSE. RE-QUERY BEFORE TRUSTING.

```
⚠ THIS BLOCK AGES FASTER THAN A SESSION. It has been WRONG at the
  start of every recent session. TREAT IT AS A HINT, NOT A FACT —
  run the oracle and a slip listing before testing. (S85 lesson.)

DRIFTED — the P53 reproduction. ⚠ DO NOT RESET until the fix is
proven:
    DO-0004  tally 3, rows 0
    DO-0005  tally 3, rows 0
    DO-0010  tally 3, rows 1
    DO-0011  tally 2, rows 1

⚠ OPEN, UNEXPLAINED: DO-0006 went onto PS-0019 with DO-0004/0005
  and does NOT appear in the drift list. Its tally must equal its
  rows. Why it behaved differently is NOT KNOWN — it was not
  queried directly. ▶ Query it in S86; it may sharpen the diagnosis.

SLIPS at S85 close (company 464)
    PS-0020   LIVE — DO-0010, DO-0011, DO-0012
    PS-0016 · PS-0018 · PS-0019   CANCELLED during S85 testing
    PS-0001..0004  SHIPPED (read-only)
    Others cancelled — re-query rather than trusting a list.

⚠ id ↔ code mapping confirmed S85:
    2389 = PS-0008 · 2393 = PS-0012 · 2397 = PS-0016 · 2398 = PS-0017

STANDING FIXTURE DEFECTS (unrelated to P7)
    1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
    2. MAT-6 missing its Sesame allergen       (S73 → P24)
    3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)

⚠ CLOSED S85: the S84 question "who cancelled PS-0008 and PS-0015"
  is still OPEN. It was NOT answered — S85 briefly claimed it was,
  on evidence about a different slip. packingslips.updatedAt dates
  it. One query. Low priority.
```

## ⚠ PROD RESIDUE — S80, STILL OPEN

```
DO-0006 created on PROD in error during the S80 walk (SO-0004,
customer "Jade 3", testpdt260703 / FO-0001-4, 1# (20 Kg), lot
Pdt-260701-1). Almost certainly sandbox company 464 but NEVER
CONFIRMED. One query settles it → P37.
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING — no full pass since S73, now THIRTEEN sessions. ▶ Minty's, one pass, at session open.

**P7  PACKING-SLIP REDESIGN — ⚠ IN BUILD. Slices 1·2·3·4a·4b DONE. See the P7 block above. ⚠ BLOCKED ON P53.**

**P1  DOCUMENTATION CONVERGENCE — ✅ DONE.** ⚠ REMAINING: delete the two dead physical files → P20 (old Section J) and P22 (old Section A).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
⚠ GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY (J83).
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT.
  • Products list (admin-formulation.component.ts:878) divides separately.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. Copy it.
⚠ **THE PACKING-SLIP SITES ARE NOW ALL CLOSED.** S82 closed five (897096b4) plus edit's write (db415d74). ⚠ S85 CLOSED THE LAST TWO IN edit-packslips: the :245 site was DEAD (computed, never read) and deleted; the :299 site sits in createEditItem which is PROVEN UNREACHABLE (→ P51). → J104, J106.
⚠ **S81 ADDED A SITE TO FIND:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with file, line, and the stored units column that should replace it. THEN rank.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91 · J94 · J95 · J104]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. ⚠ Packing-slip alerts surface only the HTTP status; the real message is in pm2 logs. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default.
✅ PRECONDITION MET S81 — MO-Release Global Select read. Findings:
```
FILE   src/app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/
       release-mat/release-mat-details/
BACK   MaterialsProductsReleased.js:150 createReleaseMaterialProductsV2
CONTROL  html:35-40 one "Select All" → setAllSelect()
HANDLER  ts:176-192 three blocks setting x.isDirectQty
FIELD    the selection flag is `isDirectQty`, NOT `selected`
⚠ IT IS A SELECT-ALL, NOT A SELECT-MATCHING. No predicate.
⚠ DEAD CODE IN THIS FILE → P38.
```
⚠ **NEW S85 — P6 AND P52's BARCODE ARE TWO ENDS OF ONE LOOP.** The barcode Minty's client prints is scanned by the CUSTOMER's PO receiving screen. The encoding must match what P6's scanner searches on. ▶ Design them together or they will not meet.
[3A.3 · J89]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** ⚠ Confirmed again S85: checkout 9bce0238, served 53db203d. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** ⚠ SAME SHAPE AS P54's logo column — a DB column written via `.update().set()` is silently dropped unless declared in the Waterline model. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ S82 FOUND THE MECHANISM: FormData stringifies blanks so the four-letter string 'null' reaches the backend. → J98. ⚠ SEEN AGAIN S85 — "Product External Code" and "Customer PO No" both print the literal word `null` on the packing slip row. ⚠ P52's spec requires "—" regardless of whether P10 is fixed first. [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** ⚠ WORSE AGAIN S85. ⚠ MITIGATION FOUND: the artifact filename carries the commit SHA — match on SHA, never timestamp. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK — and it now holds the ONLY copies of the S85 4b backups. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ RELATED TO P52 — the print redesign has the same page-break problem, and tall barcode rows must not split. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed again S85 on every login, both boxes. Prod 26.04 / dev 24.04.4 — a dev reboot rehearses nothing. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ `ssh -4` needed throughout S85. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ▶ Does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN: does mlomanagement.allergens hold a stored value nobody reads? ⚠ TIES TO P52 — whether allergens print on the customer's slip is the same domain question. [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** ⚠ PROD GETS NO RENEWAL-FAILURE WARNING. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ 42 updates pending on prod at S85, 7 security. Do NOT disable casually. [3B.2 · J84]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** ⚠ CONFIRMED S84: both create and edit open DoListComponent. ⚠ Grep for other references first. [J87]

**P37  CONFIRM THE COMPANY OF PROD SO-0004 (one query, minutes).** ⚠ Run on prod: `SELECT id, internalCode, company_id FROM somanagement WHERE internalCode='SO-0004';` [Section 1 PROD RESIDUE]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** ⚠ Same JT9/JT22 decoy as P36 and P51, in the exact file P6 will redesign. [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ FOOD-SAFETY-CRITICAL: JT8. Sites: lines 609, 632, 1063. [§2 to-verify 1 · JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP.** ⚠ STILL UNTESTED. ⚠ NOW COUPLED TO P53 — slice 1 fixed this path by mirroring inActivatePS, which S85 proved broken. ▶ Fix and test both together. [J92 · J96 · J105]

**P41  WRITE THE SETTLED RULES INTO SECTION 2 — ⚠ NOW FIVE EDITS, ONE PASS.**
  1. A DO coming off a slip ALWAYS returns its quantity (Minty S81). ⚠ REISSUE §2 Core #2's sentence WHOLE with the decision folded in. ⚠ S85 NOTE: the rule is right, the CODE does not implement it (P53) — record the rule, not the bug.
  2. The three-step flow (move → save → ship) is settled domain logic (S82).
  3. Shipped quantity is not an operator input (S84).
  4. ⚠ NEW S85 — THE DO ROW IS A READ-ONLY DISPLAY. Nothing typed; to change what is on the slip, remove the DO and add another.
  5. ⚠ NEW S85 — THE UNIFORM QUANTITY STRING: `<units># (<Kg> <uom>)`, units stored, Kg derived.
[J92 · J97 · J104]

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG.** ⚠ DO NOT START UNTIL P7 IS CLOSED. ▶ 5A = JT traps + JR rebuild checklist. 5B = J-entries. ⚠⚠ J-NUMBERS ARE PERMANENT. ⚠ Also update rule 0.3 and rule 9.

**P43  SHIPPING REFERENCE → MULTIPLE INVOICES, QUICKBOOKS-READY.** ⚠ DESIGN DECIDED, BUILD DEFERRED: a CHILD TABLE, not delimited text. ⚠ OPEN: are invoices raised in QuickBooks BEFORE or AFTER the slip ships? If after, the field must be fillable post-ship — which breaks "Ship is terminal". ⚠ DB CHANGE → rule 4.8. [§2 GR7 vehicle_no · 3A.4 · J97]

**P44  editPackslips NEVER WRITES vehicle_condition.** ⚠ PRE-EXISTING. ⚠ MATTERS MORE NOW: 4a made the dropdown editable and gated SHIP on it, so an operator can pick a condition, ship, and have it silently discarded. ▶ Add `vehicle_condition` to the edit PSOBJ with the same blank-guard as createPS. ▶ RIDE ALONG WITH P7 STEP B, OR SEPARATE — Minty's call, asked S85, unanswered. [J98]

**P45  THE FRAGILE GUARD IS ON CREATE, NOT EDIT.**
```
EDIT    HAS the CORRECT kind: Validators.max(shipment_order_units)
CREATE  STILL PARSES A DISPLAY STRING by position:
        :169  caps qtyShip at   ...split(' ')[0]
        :265  min AND max at    ...split(' ')[3]   <- EQUALITY LOCK
        :296  reads             ...split(' ')[0]
```
⚠ S82's slice 3 flipped create's string format, so [3] now returns the Kg figure. → P49.
▶ **UNDER THE READ-ONLY RULE THE FIELD IS NEVER TYPED, so the parsing and both validators are DELETED, not repaired. Do it in P7 STEP B, SAME PATCH as the template mirror.**
⚠ **CLOSED S85 — one sub-question answered: an invalid form DOES NOT block Save.** Nothing reads `packForm.valid`; Save and Ship are gated only on vehicle_num + vehicle_condition. And `manufacturing_LOT_order_num` is declared required but never patched, so the new-DO group has ALWAYS been invalid and it never blocked anything. → J107. [J95]

**P46  TERMINAL PASTE TRUNCATION — INVESTIGATE, DO NOT KEEP GUESSING.** ⚠ TWO THEORIES DISPROVEN. ⚠ THE WORKAROUND WORKS AND IS THE DEFAULT: files + scp. [Section 0 rule 8]

**P47  ✅ CLOSED S85 — FOLDED INTO P52.** The PO barcode was designed in S85 and cannot be built without the print template. ⚠ Its open questions (grouping, and matching free-typed PO text to the customer's own internal code) travel with P52 and P6. ▶ DELETE THIS LINE at S86 open once Section 5 carries the stamped entry (rule 7.6).

**P48  NAMING DEFECTS. Cheap individually, expensive in aggregate.**
```
moStartDate               holds a LOT CODE, not a date
sales_order_num           holds the SYSTEM SO   ("System SO No")
sales_order_num_system    holds the CUSTOMER's ref ("Customer PO No")
                          ⚠ the "_system" one is the CUSTOMER's.
shipment_order_units  vs  shipping_order_units
shipment_product_order_qty vs shipping_order_qty
"MO Lot Code" vs "Pdt Lot Code"   SAME THING, two captions
"PackingSlipDOs"          the table is packingslipdos, lowercase
vehicle_no                holds the SHIPPING REFERENCE
```
⚠ **S85 ADDED THE COST:** every field in P52's frozen spec had to be annotated with which control lies about it, or the print build would read the wrong one.
▶ Rename the CAPTIONS freely (safe). ⚠ Renaming CONTROLS touches form bindings, patchValue keys and the payload — its own careful pass.

**P49  THE QUANTITY STRING IS BUILT TWO WAYS.** ⚠ HALF CLOSED S85 — EDIT now builds the uniform string in one place (453f1f44). CREATE still builds the old format AND still parses it by position. ▶ Fix in P7 STEP B, same patch as P45.

**P50  ⚠ NEW S85 — UNDOCUMENTED FOLDER ON THE PROD BOX.** `/home/ubuntu/abletrace-lab-backend-dev` exists on PROD and is NOT a git repository. It appears in no section. ⚠ Almost certainly inert — pm2 runs one process and the backend answers 200 — but it is undocumented residue on the box carrying a real client. ⚠ "Probably inert" is reasoning, not a reading. ▶ One `ls` and a config grep.

**P51  ⚠ NEW S85 — DELETE createEditItem / addEditItem (dead code).** PROVEN unreachable S85 by grep: three hits only — the two definitions and addEditItem's call to createEditItem. Nothing calls addEditItem. ⚠ createEditItem contains R3 acrobatics (divide by weight, compare, multiply back) which is therefore a dead defect, not a live one. ⚠ Same JT9/JT22 decoy family as P36 and P38. [J106]

**P52  ⚠ NEW S85 — PRINTED PACKING SLIP REDESIGN. DESIGN FROZEN.**
⚠ **THE ROOT CAUSE IS STRUCTURAL, NOT COSMETIC:** the printed document and the editing screen are THE SAME DOM. `doNotPrint` hides the buttons; everything else prints as Material form fields. The customer receives a printed data-entry form. ▶ SPLIT THEM — the print view becomes its own template.
⚠ Full frozen spec handed over S85 as a file (P52_packing_slip_print_design_FROZEN). ▶ Fold into Section 4 when built.
```
LETTERHEAD    client logo · name · address, top left
DOCUMENT ID   "Packing slip" + number, top right
HEADER        Ship to (left) · Shipping date (right)
LINE ITEMS    two-line stacked rows, five columns, hairline between
              MO/DO · Product/Ext code · Lot/Best before ·
              Customer PO (+ barcode) · Shipped qty (right)
BELOW TABLE   Shipping reference · Remarks
SIGNATURES    Shipped by — finalShipmentUserId.name printed
              Received by — entirely blank
NOT PRINTED   vehicle condition · storage temp · buttons · accordion
DEFERRED      totals · page footer  (Minty, S85, "for the time being")
DATES         01 Jul 2027, not 27 JL 01
BLANKS        "—", never the literal word null
PRINT CONTROL print symbol at the TOP of the screen
BARCODE       one per UNIQUE customer PO, first occurrence only.
              Duplicates get text, no barcode. Code 128.
```
⚠ RESOLVED S85: company name and Shipped-by name both already exist and need no build. `company.address` EXISTS (varchar 255). NO LOGO COLUMN → P54.
⚠ OPEN: group rows by customer PO? · print before shipping? · allergens on the slip (ties P29) · the free-text PO matching problem (ties P6).
⚠ P52 CAN SHIP WITHOUT P54 — name + address, with space reserved for the logo.

**P53  ⚠⚠ NEW S85 — CANCEL DOES NOT RETURN THE DO QUANTITY. FOOD-SAFETY-RELEVANT: OVERSTATED SHIPPED QUANTITIES.** Full diagnosis in the P53 block near the top of this section. ⚠ BLOCKS P7 PROMOTION. ⚠ PROD EXPOSURE UNKNOWN AND MUST BE CHECKED FIRST. [J105]

**P54  ⚠ NEW S85 — COMPANY LOGO: STORE AND SERVE.** No logo column exists on `company` (confirmed S85). ▶ Add `company.logo varchar(255)` + ⚠ **the Waterline model attribute — BOTH, or the write is silently dropped (rule 4.7 / JT2, the same trap as P9)**. Reuse UploadFilesService and the existing `"<uuid>.<ext>|<name>"` convention. ⚠ Retrieval must be at RENDER time (signed URL or base64), NOT the click-to-download path used for ref docs — a different mechanism. ⚠ Constrain type and size or a 5MB photo lands in every printed slip (ties P4). ⚠ DB change → rule 4.8, log the SQL. [J108]

**P55  ⚠ NEW S85 — COMPANY LOGO: SUPER ADMIN CAPTURE.** Add the upload to company CREATE and ⚠ **also to company EDIT — companies rebrand, and a logo missed at creation must not be permanent.** ⚠ Backfill: existing companies (Glutenull, sandboxes) have none. ⚠ Depends on P54; P54 is useful without P55 (it unblocks P52's letterhead), so they are logged separately.

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good. P28 CLOSED S79. P35 CLOSED S84. P47 CLOSED S85 (folded into P52).

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
P7 slices 1, 2, 3, 4a, 4b + the S83 cancel fix + the S84 D2 and
pre-fill fixes — dev only, deliberately NOT promoted.
⚠⚠ PROMOTION IS NOW BLOCKED BY P53, NOT MERELY DEFERRED. Shipping a
  packing-slip redesign on top of a cancel path that silently
  overstates shipped quantities would be worse than not shipping.
  Rule 5.5.
```

**END SECTION 1**
