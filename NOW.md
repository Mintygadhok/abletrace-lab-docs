# NOW

Last rewritten: S103, 4 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠ S103 CHANGED BOTH BOXES. Schema, backend and frontend. Everything
  below was verified at the row or on the screen before close.

---

## STATE

⚠ VERIFIED THROUGH S103. Both boxes moved this session.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺130 · 200
          frontend SERVING dev-125014a3ab26
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 05f786c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ⚠ ↺ MOVED 129 → 130 IN S103. Ours, the model restart.
            It had held four sessions before that.

PROD      15.157.38.101 · pm2 abletrace-backend ↺338 · 200
          Glutenull live · SERVING prod-125014a3ab26
          backend HEAD 05f786c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 43 updates pending · restart required
            ⚠ WAS 29 AT S102. It has grown on its own. → P102
          ⚠ ↺ MOVED 337 → 338 IN S103. Ours, the git-pull restart.

✓ BACKENDS MATCH.  05f786c on both.
✓ FRONTENDS MATCH. 125014a3ab26 on both.
✓ DATABASES MATCH. qty_rejected_units added to BOTH (S103, JR15).

GITHUB    frontend main = 125014a3 (P82c create-screen write)
          backend  main = 05f786c  (P82c attribute + REJPRODOBJ)
          docs     main = eb5312c  (JR15 + Section 5 header fix)

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-125014a3ab26
          prod  /home/ubuntu/www-html.bak-prod-125014a3ab26
          ⚠ BOTH HOLD f53986ca — a backup dir holds the build it
            REPLACED, not the one it is named after.
          DB backups, S103, before the ALTER:
            dev  /home/ubuntu/rejectmaterialandproduct-before-S103.sql
            prod /home/ubuntu/rejectmaterialandproduct-before-S103-PROD.sql

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
  S103 used BOTH successfully. NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156. S103 ran it four times and it cost nothing.
```

---

## P82c — ⚠ DONE. BOTH BOXES. VERIFIED AT THE ROW.

```
THE FIX, IN FOUR PIECES — three built, one found unnecessary

1  ALTER TABLE rejectmaterialandproduct
     ADD COLUMN qty_rejected_units double DEFAULT 0;
   BOTH BOXES. Recorded as JR15. ⚠ IN NO REPO — JR is the only copy.

2  RejectMaterialAndProduct.js attributes — qty_rejected_units
   declared. Commit 05f786c. ⚠ TRAPS 3. Without it the write is
   discarded silently with a 200.

3  reject-product.component.ts:300 — sends the TYPED units value:
     qty_rejected_units: this.rejectProductForm.get('WDU').value
   ⚠ THE CONTROL IS NAMED `WDU`. That was the unknown at S103 open.
   Commit 125014a3. NOT line 347's maxWdu — that is a validator
   ceiling built by DIVIDING Kg, and it is R2.

4  edit-reject-product — ⚠ NOT NEEDED. NOT BUILT. See below.

PROVEN ON DEV, company 474, FO-0001 at 8.34 Kg/case:
  Screen: Shipping Units 3 → Quantity (Kg) 25.02. Correct.
  ROW:  id 3361 · MR-0008 · qty_rejected 25.02 · qty_rejected_units 3
  CONTRAST, same query, same screen, same product:
        id 3360 · MR-0007 · 16.68 · units 0   ← before the fix
        id 3359 · MR-0006 ·  1.39 · units 0   ← before the fix

VERIFIED ON PROD, Glutenull, FO-0019 at 0.32 Kg/unit:
  Shipping Units 10 → Quantity 3.2 Kg. Derivation correct on live
  client data. ⚠ NOT SAVED — deliberately. No client row was created.
  MINTY CONFIRMED 0.32 IS THE UNIT WEIGHT.
```

### ⚠ WHAT S103 FOUND THAT PLAN HAD WRONG

```
⚠ PLAN's STEP 4b WAS WRONG ON BOTH COUNTS. It said editing an MR
  silently blanks the count, and named edit-reject-product:123 as
  the fix site. Neither holds:

  1  THE UPDATE HANDLER ONLY WRITES WHAT IT IS SENT.
     RejectMaterialAndProduct.js:222
       const updateObj = req.body.updates
     handed straight to .set(). The edit screen sends five named
     fields; qty_rejected_units is not among them and is never
     touched. NO ERASURE.

  2  THERE IS NO EDIT BUTTON ON THE SCREEN AT ALL.
     edit-reject-product.component.html lines 49-56 — the Save,
     Return and Edit buttons are ALL INSIDE AN HTML COMMENT.
     ⚠ SO THE SCREEN IS READ-ONLY BY SOMEONE'S DELIBERATE CHOICE,
       NOT BY DESIGN OF THE DATA PATH.
     ⚠ THIS IS A LANDMINE. Uncomment that block and saving works
       again — and THEN the erasure concern becomes real, because
       the form carries no units field to send. → P142

  ▶ THIS IS THE THIRD CODE-READ OVERTURNED BY THE SCREEN IN TWO
    SESSIONS. S102 had two. See THE LESSONS below.
```

---

## ⚠ THE COUNT IS STORED AND SHOWN NOWHERE. → P143. S104's JOB.

```
MINTY RAISED THIS AT S103 CLOSE AND HE IS RIGHT. The column holds
the number and not one screen displays it.

  MR list    /Rejected-material/product — "Qty Released" shows Kg only
  MR details /Edit-reject-product       — "Quantity(kgs)" shows Kg only

▶ MINTY'S RULING S103: build it, in the format  2# (16.68 Kg)
▶ MINTY'S RULING S103 ON OLD ROWS: NO FALLBACK, NO DIVISION. Show
  the stored count as-is. Glutenull has ZERO MR rows, so the only
  rows that can ever read 0# are the two dev fixtures.
  ⚠ THIS DECISION IS SAFE BECAUSE THE CLIENT TABLE IS EMPTY. Any
    new client creates rows AFTER the column exists.

⚠ ONE QUESTION IS UNRESOLVED AND IT SIZES THE JOB. See PLAN.
  The list is fed by WhC_GetAllRejectedList_SP. If that proc does
  not SELECT the new column, the screen cannot display what it
  never receives — and the fix becomes a DATABASE OBJECT on both
  boxes, gated separately, with no promote path.
  ⚠ TWO READ ATTEMPTS IN S103 BOTH RETURNED EMPTY. read-rows.js
    printed a blank row for SHOW CREATE PROCEDURE and again for
    information_schema.ROUTINES.ROUTINE_DEFINITION. The proc body
    is STILL UNREAD. → PLAN STEP 1.
```

---

## THE S101/S102/S103 FIXTURE — THE STANDING REFERENCE SET

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

⚠ WHAT `quantity` MEANS ON THESE ROWS (confirmed S102).
  The CASE row's quantity=6 means SIX POUCHES PER CASE. A PACKING
  RATIO, not a batch figure. 6 × 1.39 = 8.34 EXACTLY.
  ⚠ DO NOT READ IT AS "6 cases per batch".

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  fopackaging 5736  pouch  quantity 1  wgt 0.32  whd_flag 0
  fopackaging 5737  case   quantity 6  wgt 1.92  whd_flag 1
  batch = 40 cases = 76.8 Kg
  ⚠ FORKED ONCE from FO-0002 (id 3691, status_id 2). Clean fork.
  ⚠ NOT A TEST OF S45 — that bug is about INTERMEDIATES. This used
    a Sub Recipe. S45 REMAINS UNTESTED. → P104

THE CYCLE THAT WAS RUN, all on FO-0001
  MO-0001   mlomanagement.id 11809
            qty 7 · received_qty 58.38 · received_units 7
            batches 1.167 (STORED)
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
            units 0 — THE BEFORE-ROW. 2 cases entered, count lost.
  MR-0008   rejectmaterialandproduct.id 3361  qty_rejected 25.02
            units 3 — ⚠ THE AFTER-ROW, S103. THE PROOF.

⚠ MR-0008 SHIFTS THE TRACEABILITY ARITHMETIC. 3 more cases are
  now released against MO-0001. Anyone re-reading the old
  7 − 1 − 2 = 4 line will not reconcile. RE-READ THE SCREEN.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

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
                         ⚠ batches IS A STORED double and holds the
                           ROUNDED figure. NOT display-only.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           THE CHILD. MPR_id · qty_allocated ·
                         Rec_Lot_id · material_id
                         ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id COLUMN.
                         ⚠ NO UNIT COUNT STORED. → P138
rejectmaterialandproduct createdAt · updatedAt · id · internalCode ·
                         type · qty_rejected (KG) · remarks_reasons ·
                         disposition · disposition_authorized_by ·
                         status · user_id · company_id · material_id ·
                         recievedlot_id · formula_id ·
                         receiveProduct_id · mlc_id ·
                         qty_rejected_units  ⚠ NEW S103, JR15
                         ⚠ FULL COLUMN LIST, read off the box S103.
```

---

## P82 — WHERE IT STANDS AFTER S103

⚠ MINTY'S RULING S101: EVERYTHING QUANTITY-RELATED STAYS UNDER P82.
⚠ THE ARITHMETIC IS CLOSED. THE STORAGE IS NOW CLOSED TOO. What
  remains is DISPLAY — P143 and P135 — and one screen, P140.

```
R2  ACROBATICS. Reconstructing a unit count by DIVIDING a stored
    weight. ▶ MEASURED CLEAN S101 against a non-1:1 fixture.
    Still present, still low priority. → P135
R3  ROUND-TRIP. ▶ MEASURED, RULED ON, CLOSED S102.
      INGREDIENTS 58.397 vs 58.38 — MINTY: not of concern.
      PACKAGING   42 and 7. EXACT. NO DEFECT.
      GLUTENULL   one MO affected by 0.005%. NO HEAL.
P82c STORAGE. ▶ DONE S103, both boxes.
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
P82c   column + attribute + create write    05f786c / 125014a3 (S103)
CLOSED S100: P82e no defect · P82f absorbed · P82g stale
CLOSED S102: R3 packaging — NO DEFECT · R3 ingredients — ACCEPTED
CLOSED S103: P82c storage — DONE, both boxes
```

⚠ FIX 7 LINE 161 IS STILL NOT PROVEN ON SCREEN. The lot-code search
  table has NO Completed Qty column. Deployed and safe, unproven.
  UNCHANGED SINCE S100. Do not record it as resolved.

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending. Both on 05f786c.
FRONTEND   nothing pending. Both on 125014a3ab26.
DATABASE   nothing pending. qty_rejected_units on both.
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

⚠ IT CANNOT PRINT A ROUTINE BODY. S103 tried twice — SHOW CREATE
  PROCEDURE and information_schema ROUTINE_DEFINITION — and BOTH
  printed an EMPTY ROW. Cause not established: either it truncates
  long text or it cannot render a multi-column SHOW result.
  ▶ USE PROD's mysql CLI for routine reads, or fix the reader. → P144

⚠ NOT ON PROD. Prod has ~/.my.cnf, so `mysql abletracelab_live -e`
  works there.
⚠ DEV HAS NO ~/.my.cnf. Build one from .env, or use read-rows.js.
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
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
      ⚠ STILL SAYS 275c025039d7. TWO DEPLOYS STALER AFTER S103.
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
      ⚠ PROD IS NOW 43 UPDATES, WAS 29 AT S102. Dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1 THROUGH 8 AUG. RESCHEDULE.
P104  No intermediate fixture on dev. 474 has none. S45 UNTESTED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
      ⚠ PROMOTED BY S103. Section_5.md is 2770+ lines and its
        header has now gone stale TWICE (S85 fixed it at J93/S81,
        S103 fixed it at J113/S95). A file that drifts twice is
        too big to maintain by append. The JR block — the only
        record of what is not in git — is buried in it.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ P82's ARITHMETIC AND STORAGE ARE NOW CLOSED. Only display
        work remains (P143, P135, P140).
      ⚠ IT NEEDS A NEW COLUMN. S103 IS THE REHEARSAL — the exact
        sequence is JR15 plus PLAN's STEP 2.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ⚠ PROMOTED AGAIN BY S103 — see P142, a commented-out button
        block with no note saying why.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
      ⚠ THIS IS TRAPS 3 LIVE, TODAY. S103 proved the fix shape.
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
      ⚠ P82c HAS NOW UNBLOCKED qty_misc_release_su. There is a
        stored column to point at. ▶ PAIRS WITH P143.
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ⚠ CAUSE FOUND S102 — DO NOT RE-INVESTIGATE.
        RejectMaterialAndProduct.js:51 counts with company_id, but
        the callers at :63 and :78 PASS NO ARGUMENT, so it is
        undefined and the count is app-wide.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST — renumbering changes how
        MRs read to a client. Business question, not a tidy-up.
      ⚠ SAME FILE AS P82c AND P143. SEPARATE COMMIT.
P138  soproducts STORES NO UNIT COUNT — Kg only. R2 by construction.
      ⚠ READS CORRECTLY TODAY. Logged, not scheduled.
P139  ⚠ add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY
      THEY ARE NOT. Both read
        data.quantity * mloForm.get("batches").value
      yet mprrecievelots holds 42 and 7, EXACT.
      ▶ THE REAL PACKAGING WRITE PATH WAS NOT FOUND. Find it and
        mark BOTH sites, live or dead. → feeds P118 and P115.
      ⚠ DO NOT "FIX" THESE LINES. The output is correct. LOW.
P140  THE YIELD SCREEN IS WRONG ON ITS OWN.
      ⚠ NOT REACHED IN S103. SPEC CARRIED FORWARD UNCHANGED IN PLAN.
      S101 blamed the numbers beneath it. S102 measured those and
      they are RIGHT (42 and 7). So the screen computes rather
      than reads.
      ⚠ NOT ACTIVATED FOR GLUTENULL. No client exposure.
      ⚠ NO HEAL EVER NEEDED — a display fault corrects itself.
      MEDIUM. It reports a discrepancy that did not occur.
P141  SECTION 5's HEADER. ✓ DONE S103, commit eb5312c.
      Now reads J115 / next J116 / last appended S103.
      ⚠ KEPT IN THE QUEUE AS A CLOSED ITEM FOR ONE SESSION so the
        S104 reader does not re-raise it. Delete at S105 close.
```

```
NEW IN S103

P142  ⚠ THE EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT, WITH NO NOTE SAYING WHY.
      edit-reject-product.component.html lines 49-56. The screen is
      read-only because of that comment block, not by design.
      ⚠ IT IS A LANDMINE. Uncomment it and saving works again — and
        the form carries NO units field, so a save would then write
        qty_rejected_units back to its 0 default and DESTROY a
        correctly stored count. Silently.
      ▶ EITHER mark it in the code saying why it is disabled
        (→ P118), OR build the units field first so it is safe to
        re-enable. ⚠ ASK MINTY — it is a screen question.
      MEDIUM. Nothing is wrong today. It is wrong the moment
      someone tidies it.

P143  ⚠ THE MR UNIT COUNT IS STORED AND DISPLAYED NOWHERE.
      MINTY RAISED IT AT S103 CLOSE. → THIS IS S104's JOB, SPECIFIED
      IN FULL IN PLAN.
      FORMAT RULED BY MINTY: 2# (16.68 Kg)
      OLD ROWS RULED BY MINTY: no fallback, no division, show the
      stored value as-is. Safe because Glutenull has zero MR rows.
      HIGH — it is the visible half of work already paid for.

P144  read-rows.js CANNOT PRINT A ROUTINE BODY.
      Two methods tried in S103, both returned an EMPTY ROW:
        SHOW CREATE PROCEDURE WhC_GetAllRejectedList_SP
        SELECT ROUTINE_DEFINITION FROM information_schema.ROUTINES
      ⚠ THIS BLOCKED S103 FROM SIZING P143. It is not cosmetic —
        every proc question on dev runs into it.
      ▶ Cause unknown: truncation, or multi-column SHOW results.
      MEDIUM.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs
  risks orphaning lot codes, receipts and traceability links.

NEW IN S103, company 474 — ⚠ DELIBERATE, KEEP IT
  MR-0008 (id 3361) qty_rejected 25.02 · qty_rejected_units 3
  ⚠ THIS IS THE P82c PROOF ROW. Do not delete it. It is the only
    stored evidence that the fix works.
  ⚠ It changes MO-0001's release arithmetic. See the fixture block.

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

⚠ NOTHING WAS CREATED ON PROD IN S103. The Glutenull screen check
  was deliberately NOT SAVED.
```
