# NOW

Last rewritten: S105, 6 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠⚠ S105 CHANGED DEV ONLY. PROD WAS NOT TOUCHED AT ALL.
  The boxes NO LONGER MATCH on either repo. That is DELIBERATE.

---

## STATE

⚠ READ OFF BOTH BOXES AT S105 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺260 · 200
          frontend SERVING dev-8fa2ed14179d
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 51e9f4e · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ⚠⚠ ↺ WENT 130 → 260 IN S105. About 130 of those were a
            CRASH LOOP caused by a backup file left inside
            api/models/. See PLAN's LESSON 1. It is FIXED and the
            count has been stable at 260 since.

PROD      15.157.38.101 · pm2 abletrace-backend ↺338 · 200
          Glutenull live · SERVING prod-0ad1f77cee1d
          backend HEAD 05f786c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 43 updates pending · restart required → P102
          ⚠ ↺ DID NOT MOVE IN S105. Held at 338. NOTHING WAS RUN
            ON PROD THIS SESSION.

⚠⚠ THE BOXES DIVERGE. DO NOT "RECONCILE" THEM.
   backend    dev 51e9f4e        prod 05f786c
   frontend   dev 8fa2ed14179d   prod 0ad1f77cee1d
   Both gaps are S105's dev-only work. Prod is exactly as S104 left it.

✗ DATABASES STILL MATCH. Nothing was changed in either database in
  S105. No rows written, no objects altered, on either box.

GITHUB    frontend main = 30b2ddd4  ⚠⚠ PUSHED, NOT BUILT
          backend  main = 51e9f4e   (the P140 cascade)
          docs     main = eab4b59   ⚠ RULES 7 STILL TO BE COMMITTED

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-8fa2ed14179d
          prod  /home/ubuntu/www-html.bak-prod-0ad1f77cee1d
          ⚠ THE DEV ONE HOLDS 0ad1f77cee1d — a backup dir holds the
            build it REPLACED, not the one it is named after.
          ⚠ READ OFF THE BOX AT CLOSE, not written from the label.

          BACKEND BACKUPS, S105, on DEV, in /home/ubuntu:
            MLOManagement.js.bak-S105-P140           (attempt 1)
            MLOManagement.js.bak-S105-P140-attempt2  (the live one)
          ⚠⚠ ATTEMPT 1's BACKUP WAS ORIGINALLY WRITTEN INSIDE
            api/models/ AND TOOK SAILS DOWN. It has been moved to
            /home/ubuntu. NEVER put a backup in an app directory.

          FRONTEND BACKUPS, S105, on the MAC, in ~:
            check-mat-yield.component.ts.bak-S105-P140
            check-mat-yield.component.html.bak-S105-P140
            check-mat-yield.component.ts.bak-S105-P140b

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small

COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ 474 = test260805@ ON DEV. THE CLEAN REFERENCE SET.
          ⚠ test260703@ IS A SANDBOX COMPANY ON PROD with FOUR MR
            ROWS including a MATERIAL one. ▶ USE IT for prod screen
            checks. NO CLIENT DATA IS TOUCHED.
          ⚠ dev also carries 466, 469, 470, 472, 473 → P100

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC — OR RUN LOCALLY ON A PROD TERMINAL.
  NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156.
```

---

## P140 — THE YIELD SCREEN. ⚠ MOSTLY DONE. ONE DEPLOY PENDING.

```
THREE FAULTS WERE RULED ON. TWO ARE FIXED AND PROVEN.

1  PACKAGING PLANNED. ✓ DONE, DEV, PROVEN ON SCREEN, BOTH PRODUCTS.
   Every packaging line showed ONE identical figure — batch_qty x
   batches — because packaging rows carry `quantity`, not `qty`, and
   fell to an else branch that never looked at the row.
   ▶ THE FIX IS THE S42 CASCADE from Formulations.js, dropped into
     getFormulaAndMlcs. Reads pack ratios only. No weight.
   ▶ COMMIT 51e9f4e. Backend, dev only.
   ⚠ COMPUTED BEFORE the map, because the map overwrites
     item.quantity with any pencil-edited figure.

2  GINGER POWDER. ✓ NOTHING TO DO. MINTY'S RULING S105: the
   1.167 x batch-qty method stays. The ~0.017 Kg variance is ACCEPTED.
   ⚠ DO NOT RE-RAISE. It was raised and closed in the same session.

3  THE HEADER BOXES. ⚠ COMMITTED, NOT DEPLOYED — GitHub outage.
   Was: QTY Planned(Kg) 7   QTY Completed(Kg) 58.38
        A case count and a weight under the same (Kg) label.
   Now: QTY Planned  7# (58.38 Kg)    QTY Completed  58.38 Kg
   ▶ COMMITS 8fa2ed14 (deployed) and 30b2ddd4 (NOT BUILT).

⚠ WHY COMPLETED SHOWS WEIGHT ONLY: received_units is NOT selected by
  WhC_GetMoDetails_SP. → P149. The frontend carries a comment naming
  the exact string to restore.

SEEN ON SCREEN, DEV, company 474, after the backend fix:
  MO-0002  Pouch 168 · Carton 42 · Case 14 · Pallet 2 · Label 2
           every variance 0 · Ginger 122.64 / 122.64 / 0
  MO-0001  Pouch 42 · Case 7 · both variance 0
           ⚠ Case was 7.002 BY COINCIDENCE before. Now a real 7.

▶ WHAT REMAINS UNDER P82: P135 ONLY. P140 IS OTHERWISE CLOSED.
```

---

## THE FIXTURE — THE STANDING REFERENCE SET

⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW OR THE SCREEN.

```
COMPANY   474 · test260805@ · on DEV

⚠⚠ NEW IN S105 — THE FIVE-LEVEL PRODUCT. THIS IS NOW THE PRIMARY
   FIXTURE FOR ANY PACKAGING WORK.

FO-0003-3  testpdt4lvl   formulations.id 3695   batch_qty 5
  fopackaging 5748  Pouch   quantity 1  wgt 0.73   whd 0  Level 1 Pack
  fopackaging 5749  Carton  quantity 4  wgt 2.92   whd 0  Level 1 Pack
  fopackaging 5750  Case    quantity 3  wgt 8.76   whd 0  Level 2 Pack
  fopackaging 5751  Pallet  quantity 7  wgt 61.32  whd 0  Level 3 Pack
  fopackaging 5752  Label   quantity 1  wgt 61.32  whd 1  Level 4 Pack
  batch = 5 pallets = 306.60 Kg
  ⚠ TWO ROWS SHARE "Level 1 Pack". The base row and the first pack
    row. Numbering runs 1,1,2,3,4 — NOT 1,2,3,4,5.
  ⚠ FORKED TWICE. FO-0003 → -2 → -3. Each packing edit forks.
    ▶ EACH FORK RECALCULATED ALL FIVE WEIGHTS CORRECTLY. Confirmed
      S105. The Level 1 weight is the single source and the cascade
      holds. NOT A GAP.

MO-0002  mlomanagement.id 11810
  qty 2 · received_qty 122.64 · received_units 2 · batches 0.4
  lotCode Pdt-260806-1 · Rec-260806-1
  RELEASED — all six, all correct:
    Ginger Powder 122.640 Kg · Pouch 168 · Carton 42
    Case 14 · Pallet 2 · Label 2
  ⚠ WHY THIS FIXTURE WORKS: ratios 4/3/7/1 are all different and
    NONE equals batch_qty 5. Base weight 0.73 is not round.
  ⚠ PALLET AND LABEL STILL COINCIDE with the broken arithmetic at
    every MO quantity — batch_qty 5, five pallets per batch. LEVELS
    1-3 ARE THE ONLY DISCRIMINATORS.

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  pouch  quantity 1  wgt 1.39  whd_flag 0
  fopackaging 5733  case   quantity 6  wgt 8.34  whd_flag 1
  batch = 6 cases = 50.04 Kg
  ⚠⚠ THIS FIXTURE CANNOT PROVE A PACKAGING FIX. batch_qty is 6 AND
    there are six pouches per case. The broken code landed at 7.002
    against a true 7. USE FO-0003-3 INSTEAD.

MO-0001  mlomanagement.id 11809
  qty 7 · received_qty 58.38 · received_units 7 · batches 1.167
  mprrecievelots 84016 Ginger 58.397 · 84017 Pouch 42 · 84018 Case 7
  MR-0006 id 3359 · MR-0007 id 3360 · MR-0008 id 3361 (units 3)

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  pouch wgt 0.32 whd 0 · case quantity 6 wgt 1.92 whd 1
  ⚠ NO PRODUCTION CYCLE ON IT. → P104 for the S45 intermediate test.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
company                  company_name  ← NOT `name`
fopackaging              formulation_id · material_id ·
                         wgt_kgs_per_unit · quantity · whd_flag ·
                         pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW.
                           Declared BOOLEAN in the model, stored
                           TINYINT. Test truthiness, never === 1.
                         ⚠ quantity = how many of the level BELOW.
                           A PACKING RATIO.
                         ⚠ pack_level IS POPULATED — 'Level 1 Pack'
                           etc. S105 briefly concluded it was empty.
                           THAT WAS THE ROW READER HIDING IT. → P152
mlomanagement            qty · received_qty · received_units ·
                         batches · company_id · formula_id ·
                         mlc_status · close_status · lotCode
                         ⚠ batches IS A STORED double holding the
                           ROUNDED figure.
                         ⚠ received_units IS STORED AND CORRECT and
                           is NOT served by WhC_GetMoDetails_SP.
                           → P149
mlcpackaging             quantity · status · mlc_id · pack_level_id
                         ⚠ ONE ROW PER MO. quantity holds the
                           BATCHES figure; pack_level_id points at
                           the fopackaging SHIPPING-UNIT row.
                         ⚠ IT IS NOT A PER-LEVEL REQUIREMENT TABLE.
                           The cascade is computed at READ time and
                           never stored. J5 CONFIRMED, S105.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           MPR_id · qty_allocated · Rec_Lot_id ·
                         material_id   ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id. ⚠ NO UNIT COUNT. → P138
rejectmaterialandproduct ⚠ full column list unchanged since S103.
                         ⚠ `type` returns 'Product'. `status`
                           returns 'Active', NOT a number.
```

---

## THE TWO RELEASE ROUTES — SETTLED S105

```
INGREDIENTS   recipe quantity per batch × number of batches
              Kg-anchored. The physical release is a weighing.
              ⚠ batches is STORED ROUNDED. The resulting variance is
                ACCEPTED — MINTY'S RULING S105. DO NOT CHASE IT.

PACKAGING     MO quantity × the packing cascade
              Unit-anchored. NO weight at any step.
              ⚠ batches PLAYS NO PART.
              ⚠ THEREFORE NO ROUNDING VARIANCE. A fractional
                variance on a packaging line is a DEFECT.

⚠ THE S105 BUG WAS THE INGREDIENT ROUTE APPLIED TO PACKAGING.
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf on both, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE PROCEDURE <name>\G"
  ⚠ NAME THE DATABASE. ⚠ USE \G, NOT ;.
⚠ ~/.my.cnf IS NOT IN GIT AND NOT BACKED UP. → P119

WhC_GetMoDetails_SP    ⚠ FEEDS Edit-Mlc AND the yield dialog.
  Names its columns one by one. Selects received_qty, NOT
  received_units. → P149. UNCHANGED SO FAR ON BOTH BOXES.

WhC_GetMoProductReceivingDetails_SP
  Selects receiveproducts.recieved_qty. NO unit count either.
  ⚠ SO THE `2.000#` ON THAT PANEL IS DERIVED ON THE FRONTEND BY
    DIVIDING. → P151.

WhC_GetMoPackagingConfiguration_SP
  Feeds mlcDetails.packagingConfiguration. Carries wgt_kgs_per_unit
  and whd_flag — the yield dialog reads the shipping-unit weight
  from it. ⚠ NOT INSPECTED IN FULL.

WhC_GetAllRejectedList_SP — CHANGED S104, BOTH BOXES. → JR16.
  ⚠ WhC_GetAllRejectedList_SP('474','Active') IS THE WORKING CALL.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. Built S101. READ-ONLY.

⚠⚠ IT SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
  SELECT CONCAT(...) AS lvl  →  the column simply does not appear.
  ⚠ IT HID pack_level, `batches` AND A COUNT(*) IN S105, and Claude
    drew a WRONG CONCLUSION from the silence.
  ▶ FOR ANYTHING COMPUTED OR ALIASED, USE THE mysql CLIENT. → P152

  node /home/ubuntu/read-rows.js co 474
  node /home/ubuntu/read-rows.js cols <table>
  node /home/ubuntu/read-rows.js sql "SELECT ..."   ⚠ plain columns

⚠ IT SURVIVES A REBOOT. ⚠ IT IS NOT ON PROD.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ⚠ 51e9f4e PENDING. The P140 cascade. Dev-proven.
           Prod is on 05f786c.
FRONTEND   ⚠ 30b2ddd4 PENDING — AND NOT YET BUILT OR ON DEV.
           Prod is serving 0ad1f77cee1d.
DATABASE   nothing pending. Neither box changed in S105.
DOCS       ⚠ RULES 7 PENDING. Not yet committed.
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
P65   promote.sh runs plain scp and ssh with no -4. ⚠ RAN CLEAN S105.
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
      ⚠ PROD 43 UPDATES. Dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
        A reboot is no longer theoretical. REHEARSE ON DEV.
      ⚠ MISSED TEN DAYS RUNNING.
P104  No intermediate fixture on dev. S45 UNTESTED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ ONLY P135 REMAINS IN P82. P140 CLOSED S105.
      ⚠ NEEDS A NEW COLUMN *AND* PROBABLY A PROCEDURE CHANGE.
        JR15 rehearsed the column, JR16 the procedure.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
        rejected-materials.component.ts:65
      ⚠ ADD: start-mlc.component.html:361 — a commented-out
        "Check Material Yield" button. Found S105.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ S105 DID IT TWICE — the cascade block and the weight-only
        Completed box both carry comments saying WHY, and the latter
        names the exact string to restore when P149 lands.
      ▶ THE PATTERN WORKS. Keep doing it.
P119  Back up the database's own code into the repo.
      ⚠ ADD ~/.my.cnf's DERIVATION to the rebuild record.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, Waterline attribute
      absent. ⚠ TRAPS 3 LIVE.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ NOW COVERED BY RULES 7. Same family as the S105 header fix.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE ACROBATICS WATCH ITEM (R2). LOW PRIORITY.
      CONTENTS: fix 6 (/Edit-Mlc, needs a backend change first —
      reverted patch at 34e99c3e, READ IT) and six header-view
      divisions: qty_shipped_su · qty_packing_slip_su · qty_do_su
      qty_misc_release_su · intermediate_prd_su · SOH_su
      ⚠⚠ P150 LIKELY ABSORBS THIS. Every one of those divisions
        exists BECAUSE a stored count was not served.
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
      ⚠ IT IS THE LAST P82 ITEM.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ⚠ CAUSE FOUND S102. RejectMaterialAndProduct.js:51 counts with
        company_id; the callers at :63 and :78 PASS NO ARGUMENT.
      ⚠⚠ S105 CONFIRMED MO NUMBERING IS ALREADY PER-COMPANY —
        FOUR companies each hold an MO-0002. THIS IS MRs ONLY.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY THEY
      ARE NOT. ⚠ DO NOT "FIX" THESE LINES.
P141  ✓ DONE S103. ⚠ DELETE THIS LINE AT S106 CLOSE.
P142  ⚠ THE EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT. ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
P143  ✓ DONE S104, BOTH BOXES. ⚠ DELETE THIS LINE AT S106 CLOSE.
P144  read-rows.js CANNOT PRINT A ROUTINE BODY. ⚠ SUPERSEDED BY
      P152, which is the bigger version of the same problem.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES.
      list 25.020 · details 25.02. ⚠ ASK MINTY. LOW.
P147  NO MATERIAL MR ON DEV. ▶ CREATE ONE. One minute. LOW.
```

```
NEW IN S105

P148  ⚠ WITHDRAWN. Raised mid-session on a misread of
      release-mat-details.component.ts:1095. That line is a
      DUPLICATE-MATERIAL handler, not the main path — the normal
      case takes final_qty as the backend computed it.
      ▶ THE RESIDUAL CONCERN, NARROWED: if one material ever appears
        at TWO packaging levels, that branch fires and uses
        qty x batches, ignoring the cascade. It cannot fire today
        because every level uses a distinct material.
      LOW. Logged so the withdrawal is on the record.

P149  ⚠⚠ received_units IS STORED AND NOT SERVED.
      WhC_GetMoDetails_SP names its columns one by one and selects
      received_qty but not received_units. So the yield dialog's
      QTY Completed shows a WEIGHT ONLY.
      ▶ THE FIX IS ONE COLUMN ADDED TO THE SELECT LIST, on BOTH
        boxes, JR16's sequence. NO PROMOTE PATH.
      ⚠ THE FRONTEND IS ALREADY WRITTEN AND COMMENTED with the exact
        string to restore. Nothing to re-derive.
      ⚠ SAME SHAPE AS P143. THIRD INSTANCE.
      ▶ FIRST REAL JOB OF S106. MEDIUM.

P150  ⚠⚠ THE PROCEDURE SURVEY. MINTY'S PROPOSAL, S105.
      Read every stored procedure's SELECT list and ask: does the
      screen it feeds need a unit column, and is it served?
      ▶ PRODUCES A LIST, NOT A REPAIR. Scope before starting.
      ⚠ 35 routines and 9 views from the S73-S79 sweep.
      ⚠ LIKELY ABSORBS P135 AND P151.
      OWN SITTING, POSSIBLY TWO. MEDIUM.

P151  EDIT-MLC DIVIDES A WEIGHT TO GET A COUNT, IN THREE PLACES.
      edit-mlc.component.ts:298 · :354 (getWdu) · html:258
      ⚠ RULES 7 FORBIDS THIS SHAPE.
      ⚠ IT EXISTS BECAUSE received_units IS NOT SERVED — the same
        blocker as P149. ▶ DO P149 FIRST; this may fall out of it.
      MEDIUM.

P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      A SELECT with CONCAT(...) AS x returned only the plain columns.
      ⚠ IT PRODUCED A CONFIDENT WRONG CONCLUSION IN S105 — that
        pack_level was empty. It is fully populated.
      ▶ EITHER FIX THE READER OR PUT A WARNING IN ITS OWN OUTPUT.
      ⚠ SUPERSEDES P144, which was the narrow version of this.
      MEDIUM — it corrupts evidence, which is worse than being blind.

P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN.
      Sails loads every file in that directory as a model and rejects
      any name containing dots or dashes.
      ⚠ IT HAPPENED IN S105 AND COST ~130 CRASH RESTARTS ON DEV.
      ▶ CONSIDER A ONE-LINE GUARD in the rebuild record, or a note
        in RULES 2. ⚠ ASK MINTY — the default answer on new rules
        is NO, and PLAN's LESSON 1 may be enough.
      LOW.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Deleting MOs risks orphaning lot codes.

CREATED IN S105, company 474 — ⚠ DELIBERATE, KEEP ALL OF IT
  testpdt4lvl  FO-0003 → FO-0003-2 → FO-0003-3  (two forks)
  MO-0002 (id 11810) · full cycle: released, produced, received
  Six materials released against it, including four packaging levels
  ⚠ THIS IS THE ONLY FIXTURE THAT CAN PROVE A PACKAGING CASCADE.
    DO NOT DELETE.
  ⚠ Materials MAT-4 Carton, MAT-5 Pallet, MAT-6 Label were created
    for it.

company 464 — CORRUPTED PLANNED QUANTITIES, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/9/10/11 10.008 · MO-0013 1750.08
  ⚠ Residue from before the S93 fix. NOT a live defect.
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
  ⚠ test0.7 fixture set from S97 (FO-0009, MO-0015/16, SO-0014)

⚠ 50.04 IS NOT 50.004. FO-0001's batch really is 6 × 8.34 = 50.04.
```

---

## PROD FIXTURE

```
⚠ test260703@ IS A SANDBOX COMPANY ON PROD, NOT GLUTENULL.
  FOUR MR ROWS, all pre-dating the S103 column:
    MR-0004 product 20.000 Kg · MR-0003 product 80.000 Kg
    MR-0002 MATERIAL 1.000 Kg ⚠ NO UNIT COUNT, BY DESIGN
    MR-0001 product 20.000 Kg
  ▶ USE IT FOR PROD SCREEN CHECKS. No client data is touched.
  ⚠ IT IS THE ONLY MATERIAL MR EITHER BOX HAS. DO NOT DELETE.

⚠ GLUTENULL (471) STILL HAS ZERO MR ROWS. Unchanged.
⚠ NOTHING WAS CREATED OR CHANGED ON PROD IN S105.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    /tmp/patch-P140-cascade-v2.py          delete
       ~/MLOManagement.js.bak-S105-P140       keep until P149 lands
       ~/MLOManagement.js.bak-S105-P140-attempt2   keep, it is live
MAC    ~/Downloads/patch-P140-headers-fix.py  delete after deploy
       ~/check-mat-yield.component.*.bak-S105-P140*   keep for now
⚠ RULES 6: tidy at the close and ONLY at the close.
```
