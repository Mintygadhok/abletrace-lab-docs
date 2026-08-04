# NOW

Last rewritten: S102, 4 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠ NOTHING WAS CHANGED ON EITHER BOX IN S102. No commits, no deploys,
  no schema changes, no view changes, NO WRITES OF ANY KIND.
  S102 was a MEASUREMENT AND SCOPING session, start to finish.

---

## STATE

⚠ VERIFIED AT OPEN OF S102, both boxes. Unchanged at close.
⚠ IDENTICAL TO S101's BLOCK. Nothing has moved in two sessions.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺129 · 200
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 2ae869c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ STILL 129. Held FOUR sessions.

PROD      15.157.38.101 · pm2 abletrace-backend ↺337 · 200
          Glutenull live · SERVING prod-f53986ca39e9
          backend HEAD 2ae869c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 29 updates pending · restart required

✓ BACKENDS MATCH.  2ae869c on both.
✓ FRONTENDS MATCH. f53986ca on both.
✓ DATABASES MATCH. qty_produced_su repointed on BOTH (S100).

GITHUB    frontend main = f53986ca (P82 fix 7)

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-f53986ca39e9
          prod  /home/ubuntu/www-html.bak-prod-f53986ca39e9
          prod view  /home/ubuntu/phv-prod-before-repoint-S100.sql
          ⚠ A backup dir holds the build it REPLACED.

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small

COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ 474 = test260805@ ON DEV. THE CLEAN REFERENCE SET.
          ⚠ dev also carries 466, 469, 470, 472, 473 — unaccounted.
            → P100 IS BIGGER THAN RECORDED. Five, not two.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          → P134

⚠ PROD IS REACHED FROM THE MAC — OR RUN LOCALLY ON A PROD TERMINAL.
  NEVER by ssh from dev; the pem does not exist on the boxes. S102
  attempted it from a prod terminal and it FAILED LOUDLY, which is
  the correct outcome. Three prior occurrences failed SILENTLY.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156.
```

---

## THE S101/S102 FIXTURE — THE STANDING REFERENCE SET

⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW OR THE SCREEN.
⚠ USE THIS INSTEAD OF COMPANY 464. It is clean; 464 is not.
⚠ NOTHING HERE IS 1:1. TRAPS 9 is satisfied by construction.

```
COMPANY   474 · test260805@ · on DEV

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  material_id 8120  pouch  quantity 1  wgt 1.39
                    whd_flag 0
  fopackaging 5733  material_id 8121  case   quantity 6  wgt 8.34
                    whd_flag 1  ← THE ANCHOR
  batch = 6 cases = 50.04 Kg
  ⚠ NOT FORKED. Original version. The control.

⚠ CONFIRMED S102 — WHAT `quantity` MEANS ON THESE ROWS.
  The CASE row's quantity=6 means SIX POUCHES PER CASE. It is a
  PACKING RATIO, not a batch figure. Proven by arithmetic:
  6 × 1.39 = 8.34 EXACTLY, the case weight.
  ⚠ DO NOT READ IT AS "6 cases per batch". That misreading is what
    made add-mlo:150 look like a defect for most of S102.

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  fopackaging 5736  pouch  quantity 1  wgt 0.32  whd_flag 0
  fopackaging 5737  case   quantity 6  wgt 1.92  whd_flag 1
  batch = 40 cases = 76.8 Kg
  ⚠ FORKED ONCE from FO-0002 (id 3691, status_id 2). The fork
    carried batch_qty and BOTH packaging rows correctly. Clean.
  ⚠ NOT A TEST OF S45 — that bug is about INTERMEDIATES. This used
    a Sub Recipe. S45 REMAINS UNTESTED. → P104

THE CYCLE THAT WAS RUN, all on FO-0001
  MO-0001   mlomanagement.id 11809
            qty 7 · received_qty 58.38 · received_units 7
            batches 1.167 (STORED — see P82 below)
            lotCode Pdt-260804-1 · Rec-260804-1
  MPR       materialsproductsreleased.id 11602  (HEADER ONLY)
    mprrecievelots 84016  material 8119  qty_allocated 58.397
    mprrecievelots 84017  material 8120  qty_allocated 42   ✓ pouches
    mprrecievelots 84018  material 8121  qty_allocated 7    ✓ cases
  SO-0001   somanagement.id 2515
    soproducts 6920  quantity 33.36  FO-0001    (4 cases)
    soproducts 6919  quantity 7.68   FO-0002-2  (4 cases)
  DO-0001 · PS-0001 · shipped 1# (8.34 Kg)
  MR-0007   rejectmaterialandproduct.id 3360  qty_rejected 16.68
            ⚠ entered as 2 CASES. The count was discarded. → P82c

TRACEABILITY DETAILS, verified on screen, ALL EXACT
  Qty Produced 7# (58.38) · SOH 4# (33.36) · Misc Rel 2# (16.68)
  Shipped 1# (8.34) · Qty in DO 0# · Qty in PS 0#
  7 − 1 − 2 = 4 ✓
```

---

## MEASURED IN S102 — ⚠ THIS OVERTURNS TWO S101 FINDINGS

```
✓ PACKAGING IS CLEAN. NO DEFECT. Measured at the row:
    mprrecievelots 84017 = 42   (7 cases × 6 pouches)
    mprrecievelots 84018 = 7    (7 cases)
  BOTH EXACT. Stored, not display-rounded.
  ▶ THE PACKAGING REQUIREMENT SCALES FROM SHIPPING UNITS, NOT FROM
    BATCHES. Minty read this off the screen and was right.
  ⚠ S101 RECORDED "R3-c the pack-level multiplier is MISSING".
    THAT IS DOUBTFUL AS RECORDED. The multiplier plainly works —
    42 IS 7 × 6. Struck pending a fresh look at the yield screen.

✓ INGREDIENTS SCALE BY BATCHES — AND MINTY RULED THAT CORRECT.
    58.397 = 1.167 × 50.04.  Exact would be 7 × 8.34 = 58.38.
    Difference ~0.017 Kg on 58 Kg — about 0.03%.
  ▶ MINTY S102: "small rounding changes not of concern". A recipe
    genuinely scales by batches; that is the right concept. NOT
    BEING FIXED. Do not re-raise it as a defect.

⚠ THE ADD-MLO CODE READS AS IF IT MULTIPLIES PACKAGING BY BATCHES
  AND THE ROWS SAY IT DOES NOT. Lines 150 and 228 both read
    data.quantity * mloForm.get("batches").value
  and finishProductionUnit is filtered to whd_flag==1 (case only) —
  yet the release holds BOTH pouch AND case, correctly.
  ▶ SO LINE 150 IS NOT WHAT WRITES THE PACKAGING REQUIREMENT.
    The real path was NOT FOUND in S102.
  ⚠ UNRESOLVED, AND DELIBERATELY LEFT. The output is correct at the
    row. DO NOT "FIX" LINES 150/228 — a future session reading them
    cold will think they are broken. They may be dead, like the
    six siblings in P115. → P139

✓ THE BATCHES FIELD IS ALREADY READ-ONLY. add-mlo.component.ts:84
  and :107 declare it `{value: null, disabled: true}`. Minty's
  ruling — "operator can change the no of shipping units but not
  how many batches" — is ALREADY the code's behaviour. Nothing to
  change. The split-brain risk (typed value vs derived value) does
  not exist.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

⚠ S101 lost three round trips to guessed column names. This block
  exists so that does not happen again. S102 added the last group.

```
company                  company_name  ← NOT `name`
                         also address (J108), food_safety_enabled
fopackaging              formulation_id · material_id ·
                         wgt_kgs_per_unit · quantity · whd_flag ·
                         pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW
                         ⚠ quantity ON THE CASE ROW = pouches per
                           case. A PACKING RATIO.
mlomanagement            qty · received_qty · received_units ·
                         batches · company_id · formula_id ·
                         mlc_status · close_status · lotCode
                         ⚠ batches IS A STORED double COLUMN, and
                           it holds the ROUNDED figure (7.292 on
                           Glutenull MO-0001). NOT display-only.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           THE CHILD. MPR_id · qty_allocated ·
                         Rec_Lot_id · material_id
                         ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id COLUMN.
                         ⚠ NO UNIT COUNT STORED. → P138
rejectmaterialandproduct qty_rejected (KG) · formula_id · mlc_id ·
                         receiveProduct_id · material_id ·
                         recievedlot_id · type · disposition ·
                         disposition_authorized_by · status ·
                         remarks_reasons · internalCode
                         ⚠ NO UNITS COLUMN. That is P82c.
```

---

## P82c — THE MR UNITS COLUMN. ⚠ FULLY SCOPED S102. THIS IS S103.

```
THE DEFECT, MEASURED
  Operator types Shipping Units = 1 on /Reject-products.
  Screen derives Quantity (Kg) = 8.34. Correct.
  The ROW stores qty_rejected only. THE COUNT IS DISCARDED.
  ⚠ NOT AN R3. Nothing is rounded. THE COLUMN DOES NOT EXIST.

▶ THE 2# ON THE TRACEABILITY PAGE IS DERIVED — 16.68 ÷ 8.34. A live
  R2 division giving the right answer because the weight is exact.

WHY IT IS WORTH DOING, in order of weight
  1  Edit the case weight later and the unit count on an OLD
     release silently changes. The record is recomputed, not kept.
  2  It is the ONLY thing blocking qty_misc_release_su in
     Trace_ProductHeaderView (P135). Nothing stored to point at.
  3  It is the last write path that stores Kg and derives units.
     Every other product hop was re-anchored in Fix B.

⚠ NOTHING IS WRONG TODAY. This is prevention, not repair.
  Glutenull has ZERO MR rows. NO BACKFILL (measured prod S98).

THE FOUR PIECES — full detail, file paths and line numbers in PLAN
  1  ALTER TABLE ... ADD COLUMN qty_rejected_units double DEFAULT 0
  2  declare it in RejectMaterialAndProduct.js  ⚠ TRAPS 3
  3  reject-product.component.ts:299 — send the typed units value
  4  edit-reject-product.component.ts:123 — or an edit ERASES it
```

---

## P82 — WHERE IT STANDS AFTER S102

⚠ MINTY'S RULING S101: EVERYTHING QUANTITY-RELATED STAYS UNDER P82.
⚠ THE ARITHMETIC IS EFFECTIVELY CLOSED. What remains is one missing
  column and one display screen.

```
R2  ACROBATICS. Reconstructing a unit count by DIVIDING a stored
    weight. ▶ MEASURED CLEAN S101 against a non-1:1 fixture.
    Still present, still low priority. → P135
R3  ROUND-TRIP. Converting a count OUT, ROUNDING it, converting
    BACK. ▶ CONFIRMED S101, RE-SCOPED S102.
```

### R3 — RE-SCOPED BY MEASUREMENT S102

```
THE ROOT, ONE LINE — add-mlo.component.ts:204
  const batches = Math.round((qty / shippingUnitsPerBatch)
                  * 10^3) / 10^3
  7 ÷ 6 = 1.1666666… → 1.167.
⚠ THE ROUNDED FIGURE IS STORED on mlomanagement.batches, so it is
  not display-only. release-mat-details:1071/1083/1095, start-mlc,
  edit-mlo and edit-mlc all read it back OFF THE ROW.

⚠ READ THE S93 COMMENT ABOVE LINE 204 FIRST. It records that the
  unit count was deliberately fixed and BATCHES WAS LEFT UNCHANGED
  ON PURPOSE, and names four downstream sites.
  ⚠ ITS LIST IS INCOMPLETE — it misses add-mlo:161 (the MAIN MO
    save, reading the form control) and the createMLC block at
    ~228-240.

WHERE IT ACTUALLY LANDS — MEASURED, NOT INFERRED
  INGREDIENTS   58.397 instead of 58.38.
                ▶ MINTY S102: NOT OF CONCERN. NOT BEING FIXED.
  PACKAGING     42 and 7. EXACT. NO DEFECT.
  GLUTENULL     one MO affected, by 0.005%. Yield not activated.
                ▶ NO HEAL. Ruling S102.

▶ SO R3 HAS NO OPEN WORK. It is measured, ruled on, and closed
  unless the yield screen reopens it.
```

### ⚠ THE YIELD SCREEN — RE-SCOPED, NOT CLOSED

```
S101 recorded four faults and concluded the screen was wrong
BECAUSE THE NUMBERS BENEATH IT WERE WRONG.
⚠ S102 MEASURED THOSE NUMBERS AND THEY ARE RIGHT. The release
  stored 42 and 7. So the yield screen showing 7.002 on both lines
  is COMPUTING something instead of READING what was stored.
▶ IT IS WRONG ON ITS OWN. A DIFFERENT BUG THAN THE ONE RECORDED,
  and possibly a smaller one.

STILL STANDING
  the −34.998 Ea variance on Pouch — a 35-pouch shortfall that
  never happened. ⚠ CLIENT-FACING AND FOOD-SAFETY in principle.
  R3-d  "QTY Planned(Kg)" holds 7, a UNIT COUNT, beside
        "QTY Completed(Kg)" holding 58.38. A LABEL fault. Same
        family as P131.

NOW DOUBTFUL AS RECORDED
  R3-b "planned 7.002 for both lines"  — mechanism unknown
  R3-c "pack-level multiplier missing" — the multiplier WORKS

⚠ NOT ACTIVATED FOR GLUTENULL (Minty S102). NO CLIENT EXPOSURE.
▶ NEXT STEP IS ONE SCREENSHOT of Check Material Yield on MO-0001,
  read against the known-correct 42 and 7. NOT SCHEDULED. → P140
```

### DONE, all on PROD, all verified on screen

```
fix 1  SOManagement.js:182-206              2ae869c   (S98)
fix 2  admin-formulation.component.ts:878   a52e4bfc  (S98)
fix 3  add-mlo.component.html:87            b8e7248b  (S98)
fix 4  closed-mlcs.component.html:79/84     824e0e6d  (S98)
fix 5  edit-closed-mlcs.component.ts:126/136 770d3c4f (S99)
fix 7  product-traceability.component.ts:109,161
                                            f53986ca  (S100)
CLOSED S100: P82e no defect · P82f absorbed · P82g stale
CLOSED S102: R3 packaging — NO DEFECT, measured at the row
             R3 ingredients — ACCEPTED, Minty's ruling
```

⚠ FIX 7 LINE 161 IS STILL NOT PROVEN ON SCREEN. The lot-code search
  table has NO Completed Qty column. Deployed and safe, unproven.
  UNCHANGED SINCE S100. Do not record it as resolved.

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending.
FRONTEND   nothing pending. Both boxes on f53986ca.
DATABASE   nothing pending.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. Built S101.
Reads .env itself. Driver is node_modules/mysql (NOT mysql2).
READ-ONLY — refuses anything that is not SELECT/SHOW/DESCRIBE.
PRINTS THE DATABASE NAME EVERY RUN (P134).

  node /home/ubuntu/read-rows.js co 474
  node /home/ubuntu/read-rows.js cols rejectmaterialandproduct
  node /home/ubuntu/read-rows.js sql "SELECT ..."

⚠ NOT ON PROD. Prod has ~/.my.cnf, so a plain `mysql
  abletracelab_live -e "..."` works there — used successfully S102.
⚠ DEV HAS NO ~/.my.cnf. Use read-rows.js on dev, .my.cnf on prod.
⚠ IT SURVIVES A REBOOT (not in /tmp).
```

---

## QUEUE

⚠ New items at the bottom with the next free number. Claude never
renumbers. Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod.
      ⚠ ALSO packing slip, Closed MOs Excel, Closed MOs screen.
      ⚠ SEEN AGAIN S101 on dev — SO row and MO details, FO-0001.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. FIVE — 466, 469, 470,
      472, 473.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      Prod 29 updates, dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1 THROUGH 6 AUG. RESCHEDULE.
P104  No intermediate fixture on dev. 474 has none. S45 UNTESTED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ P82's ARITHMETIC IS NOW CLOSED. Only P82c stands between.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ⚠ PROMOTED AGAIN BY S102. The S93 comment above add-mlo:204
        saved an hour — and its INCOMPLETE list cost most of a
        session. Both halves of the case, in one artefact.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
      ⚠ THIS IS TRAPS 3 LIVE, TODAY. Same shape as P82c step 2.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ SAME FAMILY AS P82 R3-d. Consider fixing together.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE ACROBATICS WATCH ITEM (R2). LOW PRIORITY.
      ▶ MEASURED CLEAN S101 against a non-1:1 fixture.
      CONTENTS: fix 6 (/Edit-Mlc, needs a backend change first —
      reverted patch is in history at 34e99c3e, READ IT rather
      than rewriting) and six header-view divisions:
        qty_shipped_su · qty_packing_slip_su · qty_do_su
        qty_misc_release_su · intermediate_prd_su · SOH_su
      ⚠ P82c UNBLOCKS qty_misc_release_su. One of the six.
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ⚠ CAUSE FOUND S102 — DO NOT RE-INVESTIGATE.
        RejectMaterialAndProduct.js:51 counts with company_id, but
        the callers at :63 and :78 PASS NO ARGUMENT, so it is
        undefined and the count is app-wide.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST — renumbering changes how
        MRs read to a client. Business question, not a tidy-up.
      ⚠ SAME FILE AS P82c. SEPARATE COMMIT.
P138  soproducts STORES NO UNIT COUNT — Kg only. R2 by construction.
      ⚠ READS CORRECTLY TODAY. Logged, not scheduled.
```

```
NEW IN S102

P139  ⚠ add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY
      THEY ARE NOT. Both read
        data.quantity * mloForm.get("batches").value
      which would give 6 × 1.167 = 7.002 — yet mprrecievelots
      holds 42 and 7, EXACT, and includes the POUCH which the
      whd_flag filter at :291 excludes.
      ▶ THE REAL PACKAGING WRITE PATH WAS NOT FOUND. Find it and
        mark BOTH sites, live or dead. → feeds P118 and P115.
      ⚠ DO NOT "FIX" THESE LINES. The output is correct.
      LOW. Nothing is wrong; the code merely lies about itself.

P140  THE YIELD SCREEN IS WRONG ON ITS OWN.
      S101 blamed the numbers beneath it. S102 measured those and
      they are RIGHT (42 and 7). So the screen computes rather
      than reads.
      ▶ FIRST STEP IS ONE SCREENSHOT — Check Material Yield on
        MO-0001, company 474, read against 42 and 7.
      ⚠ NOT ACTIVATED FOR GLUTENULL. No client exposure.
      ⚠ NO HEAL EVER NEEDED — a display fault corrects itself.
      MEDIUM. It reports a discrepancy that did not occur.

P141  SECTION 5's HEADER IS THREE SESSIONS STALE.
      Says "Highest is J113 — next is J114" and "Last appended:
      S95". J114 AND J115 BOTH EXIST (S97).
      ▶ NEXT FREE IS J116. Highest trap JT27.
      ⚠ ASKED IN S85, S86 AND S95 AND NOT DONE. Fix it with the
        S103 append.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs
  risks orphaning lot codes, receipts and traceability links.

company 464 — CORRUPTED PLANNED QUANTITIES, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/9/10/11 10.008 · MO-0013 1750.08
  ⚠ Residue from before the S93 fix. DO NOT read as a live defect.
  ⚠ MO-0019 exists on dev and was never recorded. Harmless.
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
  ⚠ test0.7 fixture set from S97 (FO-0009, MO-0015/16, SO-0014)

⚠ 50.04 IS NOT 50.004. FO-0001's batch really is 6 × 8.34 = 50.04.
  Coincidence of digits with the old corruption. DO NOT CONFUSE.

⚠ NO NEW RESIDUE FROM S102. Nothing was created or written.
```
