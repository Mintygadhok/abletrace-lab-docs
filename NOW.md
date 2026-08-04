# NOW

Last rewritten: S101, 4 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠ NOTHING WAS CHANGED ON EITHER BOX IN S101. No commits, no deploys,
  no schema changes, no view changes. S101 was a MEASUREMENT session.
  The only writes were app-level data on DEV company 474.

---

## STATE

⚠ VERIFIED AT OPEN OF S101, both boxes. Unchanged at close.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺129 · 200
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 2ae869c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ STILL 129. Held THREE sessions.

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
          ⚠ 474 = test260805@ CREATED S101 ON DEV. THE CLEAN
            REFERENCE SET. See THE S101 FIXTURE below.
          ⚠ PLAN S100 called it "260804". IT IS 474 / test260805@.
          ⚠ dev also carries 466, 469, 470, 472, 473 — unaccounted.
            → P100 IS BIGGER THAN RECORDED. Five, not two.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          → P134
```

---

## THE S101 FIXTURE — THE STANDING REFERENCE SET

⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW, NOT THE SCREEN.
⚠ USE THIS INSTEAD OF COMPANY 464. It is clean; 464 is not.
⚠ NOTHING HERE IS 1:1. TRAPS 9 is satisfied by construction.

```
COMPANY   474 · test260805@ · on DEV

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  pouch  qty 1  wgt 1.39  whd_flag 0
  fopackaging 5733  case   qty 6  wgt 8.34  whd_flag 1  ← THE ANCHOR
  batch = 6 cases = 50.04 Kg
  ⚠ NOT FORKED. Original version. The control.

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  fopackaging 5736  pouch  qty 1  wgt 0.32  whd_flag 0
  fopackaging 5737  case   qty 6  wgt 1.92  whd_flag 1  ← THE ANCHOR
  batch = 40 cases = 76.8 Kg
  ⚠ FORKED ONCE from FO-0002 (id 3691, status_id 2) by a full
    edit. THE FORK CARRIED batch_qty AND BOTH PACKAGING ROWS
    CORRECTLY. Clean.
  ⚠ THIS IS NOT A TEST OF S45. That bug is about INTERMEDIATES
    (ship_qty on the subrecipe path). This product used a Sub
    Recipe, not an Intermediate Product. S45 REMAINS UNTESTED.

⚠ THE DIVISOR IN EVERY P82 DIVISION IS THE whd_flag=1 ROW.
  8.34 and 1.92 — NOT 1.39 and 0.32.
⚠ THE POUCH ROW ALSO CARRIES A PLAUSIBLE wgt_kgs_per_unit.
  ANY JOIN ON fopackaging THAT DOES NOT FILTER whd_flag=1 GETS
  TWO ROWS AND CAN SILENTLY TAKE THE POUCH WEIGHT — a 6x error
  that looks entirely reasonable. Same family as TRAPS 10.

THE CYCLE THAT WAS RUN, all on FO-0001
  MO-0001   mlomanagement.id 11809
            qty 7 · received_qty 58.38 · received_units 7
            lotCode Pdt-260804-1 · Rec-260804-1
  MPR       materialsproductsreleased.id 11602  (HEADER ONLY)
    mprrecievelots 84016  qty_allocated 58.397  ⚠ THE DEFECT
    mprrecievelots 84017  qty_allocated 42      ✓ pouches
    mprrecievelots 84018  qty_allocated 7       ✓ cases
  SO-0001   somanagement.id 2515
    soproducts 6920  quantity 33.36  FO-0001    (4 cases)
    soproducts 6919  quantity 7.68   FO-0002-2  (4 cases)
  DO-0001 · PS-0001 · shipped 1# (8.34 Kg)
  MR-0007   rejectmaterialandproduct.id 3360  qty_rejected 16.68

TRACEABILITY DETAILS, verified on screen, ALL EXACT
  Qty Produced 7# (58.38) · SOH 4# (33.36) · Misc Rel 2# (16.68)
  Shipped 1# (8.34) · Qty in DO 0# · Qty in PS 0#
  7 − 1 − 2 = 4 ✓
```

---

## MEASURED IN S101 — THE WHOLE CYCLE

```
CLEAN — entered vs STORED agreed at every one of these hops
  MO CREATE          qty 7 stored EXACT.
    ⚠ THE ROUND-TRIP IS DEAD ON THIS PATH. The screen showed
      batches 1.167 — every condition for the old bug was
      present — and 7.002 DID NOT REACH THE ROW. The S93 fix
      holds. MEASURED, not inferred.
  PRODUCT RECEIVE    received_units 7 · received_qty 58.38
  SO CREATE          33.36 and 7.68, both exact
  DO CREATE          1# (8.34)
  PACKING SLIP       1# (8.34)
    ⚠ TRAPS 2 DID NOT BITE. Fourth encounter with shipped_qty,
      first clean one. Rendered units-first, Kg derived.
  SHIP               SO went amber / Partially Shipped, 1 of 4
  STOCK ON HAND      4# (33.36 Kg). EXACT.
    ▶ THIS IS SOH_su — the whole subtraction, divided. THE P135
      DIVISIONS ARE READING RIGHT on a non-1:1 fixture.
  TRACEABILITY       both search paths, every figure reconciles

⚠ /Dispatch-orders showed 0# Qty Shipped BEFORE shipping and the
  real figure after. Minty's S100 ruling confirmed by measurement.

⚠ FIX 7 LINE 161 IS STILL NOT PROVEN ON SCREEN. The lot-code
  search table has NO Completed Qty column — it shows MO Qty only,
  where the dropdown path shows two columns. Deployed and safe,
  unproven. UNCHANGED FROM S100. Do not record it as resolved.

⚠ MR NUMBERING IS GLOBAL, NOT PER-COMPANY. A brand-new company
  produced MR-0007 while its MO and SO both started at 0001.
  Not a defect. Do not read MR-0007 as "the seventh for 474".
```

---

## SCHEMA FACTS LEARNED IN S101 — DO NOT REDERIVE

⚠ THREE QUERIES FAILED IN S101 ON GUESSED COLUMN NAMES. This block
  exists so that does not happen again.

```
company                  company_name  ← NOT `name`
                         also food_safety_enabled (P129)
fopackaging              formulation_id · wgt_kgs_per_unit ·
                         quantity · whd_flag · pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           THE CHILD. MPR_id · qty_allocated ·
                         Rec_Lot_id · material_id
                         ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id COLUMN.
                         ⚠ NO UNIT COUNT STORED. See P82 R2-struct.
rejectmaterialandproduct qty_rejected (KG) · formula_id · mlc_id
                         ⚠ NO UNITS COLUMN. That is P82c.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. 5438 bytes. Built S101.
Reads .env itself. Driver is node_modules/mysql (NOT mysql2).
READ-ONLY — refuses anything that is not SELECT/SHOW/DESCRIBE.
PRINTS THE DATABASE NAME EVERY RUN (P134).

  node /home/ubuntu/read-rows.js co 474
  node /home/ubuntu/read-rows.js co 474 mlomanagement --full
  node /home/ubuntu/read-rows.js cols fopackaging
  node /home/ubuntu/read-rows.js sql "SELECT ..."
  node /home/ubuntu/read-rows.js view 474

⚠ NOT ON PROD. scp it from the Mac if prod rows are needed.
⚠ IT SURVIVES A REBOOT (not in /tmp).
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending.
FRONTEND   nothing pending. Both boxes on f53986ca.
DATABASE   nothing pending.
```

---

## P82 — WHERE IT STANDS AFTER S101

⚠ MINTY'S RULING S101: EVERYTHING QUANTITY-RELATED STAYS UNDER P82.
⚠ P82 NOW HOLDS TWO MECHANISMS. THEY ARE NOT THE SAME BUG.

```
R2  ACROBATICS.  Reconstructing a unit count by DIVIDING a stored
    weight. Wrong only when the stored weight and the true count
    disagree. ▶ SUSPECTED. Never seen wrong.
R3  ROUND-TRIP.  Converting a count OUT, ROUNDING it, and
    converting BACK. Always wrong on a fractional result.
    ▶ CONFIRMED S101.
⚠ DO NOT GREP FOR A DIVISION ON AN R3 ITEM. There isn't one.
   R3's signature is Math.round(...) followed by a multiplication.
```

### CONFIRMED — R3 — measured S101

```
ROOT CAUSE, ONE LINE
  add-mlo.component.ts:204
    const batches = Math.round((qty / shippingUnitsPerBatch)
                    * 10^3) / 10^3
  7 ÷ 6 = 1.1666666… → 1.167. Everything below multiplies THAT.

⚠ THERE IS A COMMENT ABOVE LINE 204, WRITTEN IN S93. READ IT
  FIRST. It records that the unit count was deliberately fixed
  (which is why qty=7 is clean today) and that BATCHES WAS LEFT
  UNCHANGED ON PURPOSE, and it NAMES THE DOWNSTREAM SITES:
      release-mat-details  1071 · 1083 · 1095
      add-mlo              150 · 223
  ▶ A PREVIOUS SESSION FIXED HALF OF THIS AND WROTE DOWN WHY IT
    STOPPED. That comment saved an hour. → strongest case yet
    for P118.

⚠ THE COMMENT'S LIST IS INCOMPLETE. S101 found a FOURTH site the
  comment does not mention, in add-mlo createMLC (~227-237):
      qty: this.batches * data.qty
      quantity: data.quantity * this.mloForm.get("batches").value
  ▶ THIS ONE WRITES. It is not display.

R3-a  MATERIAL REQUIREMENT.  ⚠ A WRITE.
      MO-0001, 7 cases: 1.167 × 50.04 = 58.39668 → stored 58.397.
      Correct is 7 × 8.34 = 58.38.
      STORED IN mprrecievelots.qty_allocated id 84016.
      ⚠ Kg-MEASURED INGREDIENTS ONLY. Unit-counted packaging is
        exact (Pouch 42, Case 7). That is why the S44 packaging
        fix did not catch it.
      ⚠ A CODE FIX WILL NOT HEAL SAVED ROWS.

R3-b  CHECK MATERIAL YIELD — planned quantity is the round-trip
      figure. Both Pouch AND Case show planned 7.002 Ea
      (1.167 × 6). Should be 42 and 7.
      ▶ Variance reads −34.998 Ea on Pouch: a 35-pouch shortfall
        THAT DID NOT HAPPEN.
      ⚠ CLIENT-FACING AND FOOD-SAFETY. Yield is how a producer
        proves what went into a lot.

R3-c  SAME SCREEN — the pack-level multiplier is missing
      entirely. Pouch planned ignores 6-per-case. A SECOND fault
      stacked on the same screen, separate from the rounding.

R3-d  SAME SCREEN — "QTY Planned(Kg)" holds 7, a UNIT COUNT,
      beside "QTY Completed(Kg)" holding 58.38, a real weight.
      Same label, opposite bases. Same family as P131.
      ⚠ LABEL DEFECT, NOT ARITHMETIC. Separate one-line fix.

⚠ IT ONLY APPEARS ON A PARTIAL BATCH. A whole-number batch count
  divides clean and hides it completely. SIX YEARS OF ROUND-NUMBER
  FIXTURES IS WHY THIS WAS NEVER SEEN.
  ▶ ANY TEST OF THIS MUST USE A NON-INTEGER BATCH COUNT.

NOT ESTABLISHED — DO NOT ASSUME
  ⚠ PROD NOT MEASURED. Behaviour there is UNKNOWN.
  ⚠ WHETHER GLUTENULL HAS ANY PARTIAL-BATCH MO — NOT MEASURED.
    ▶ THIS IS THE FIRST QUESTION OF S102. One query. If zero,
      there is no live client exposure and no heal is needed.
```

### CONFIRMED — GAP — P82c — measured S101

```
P82c  MISC RELEASE STORES NO UNIT COUNT.
      MEASURED: entered 2 cases. Screen derived 16.68 Kg
      correctly. rejectmaterialandproduct.id 3360 stored
      qty_rejected=16.68 AND NOTHING ELSE. The 2 was discarded
      silently at the write.
      ⚠ NOT AN R3. Nothing was rounded; 16.68 is exact. The
        column does not exist. Different fix entirely.
      ▶ The 2# shown on the traceability page is DERIVED —
        16.68 ÷ 8.34. A live R2 division, giving the right
        answer because the stored weight is exact.
      ▶ FIXING P82c IS WHAT WOULD UNBLOCK qty_misc_release_su
        in the header view.
      ⚠ NO BACKFILL NEEDED. Measured prod S98: company 464 only,
        4 rows, GLUTENULL ZERO.
```

### SUSPECTED — R2 — and now MEASURED CLEAN

```
▶ P135 holds these. S101 MEASURED THEM AGAINST A CLEAN NON-1:1
  FIXTURE AND EVERY ONE READ RIGHT.
    SOH 4# (33.36) · Misc Rel 2# (16.68) · Shipped 1# (8.34) ·
    Qty in DO 0# · Qty in PS 0#
▶ THIS IS THE MEASUREMENT P135 WAS WAITING FOR. It does not
  close P135 — the divisions are still there and still hide a
  disagreement if one ever arises — but it removes the case for
  urgency. LOW PRIORITY CONFIRMED BY MEASUREMENT.

R2-struct  soproducts STORES KG ONLY, NO UNIT COUNT.
           So any screen showing "4 cases" against an SO MUST
           divide. This is R2 BY CONSTRUCTION — not bad code, a
           MISSING COLUMN, same root as P82c.
           ⚠ NEW IN S101. Not previously recorded.
           ⚠ Reads correctly today. Not scheduled.
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
      ⚠ SEEN AGAIN S101 on dev — External ID renders "null" on
        the SO row and MO details for FO-0001.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES.
      ⚠ S101: it is FIVE, not two — 466, 469, 470, 472, 473.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      Prod 29 updates, dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1, 2, 3, 4 AND 5 AUG. RESCHEDULE.
P104  No 1.39 intermediate fixture on dev.
      ⚠ STILL TRUE. 474 has NO intermediate. S45 remains untested.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ⚠ PROMOTED IN VALUE BY S101. The S93 comment above
        add-mlo:204 named four downstream sites and saved an
        hour of grepping. THIS IS THE PROOF THE PRACTICE WORKS.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ SAME FAMILY AS P82 R3-d. Consider fixing together.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
      ⚠ CONFIRMED AGAIN S101: soproducts.product_status=1 and
        status='Active' both written on the new SO, both unused.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE ACROBATICS WATCH ITEM (R2). LOW PRIORITY.
      ▶ MEASURED CLEAN IN S101 against a non-1:1 fixture. See
        P82 SUSPECTED above. Still deliberate, still low.
      CONTENTS: fix 6 (/Edit-Mlc, needs a backend change first —
      reverted patch is in history at 34e99c3e, READ IT rather
      than rewriting) and six header-view divisions:
        qty_shipped_su · qty_packing_slip_su · qty_do_su
        qty_misc_release_su · intermediate_prd_su · SOH_su
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
```

```
NEW IN S101

P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      A brand-new company produced MR-0007 while its MO and SO
      both started at 0001. ▶ DECIDE: intended or not.
      LOW. Not a wrong number, an inconsistent one.

P138  soproducts STORES NO UNIT COUNT — Kg only.
      Any unit figure on an SO screen must be derived by
      division. R2 by construction, same root as P82c.
      ⚠ READS CORRECTLY TODAY. Logged, not scheduled.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS NOW THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs
  risks orphaning lot codes, receipts and traceability links.

company 464 — CORRUPTED PLANNED QUANTITIES, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/9/10/11 10.008 · MO-0013 1750.08
  ⚠ Residue from before the S93 fix. DO NOT read as a live defect.
  ⚠ MO-0019 exists on dev and was never recorded. Harmless.
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)

⚠ 50.04 IS NOT 50.004. FO-0001's batch really is 6 × 8.34 = 50.04.
  Coincidence of digits with the old corruption. DO NOT CONFUSE.
```
