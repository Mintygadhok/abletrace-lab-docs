# NOW

Last rewritten: S107, 6 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

⚠⚠ S107 CHANGED BOTH BOXES. The database view AND the frontend.
  ✓ FOR THE FIRST TIME SINCE THE P140 WORK BEGAN, DEV AND PROD ARE
    ALIGNED ON BACKEND, FRONTEND, VIEW AND PROCEDURE.

⚠⚠ A SECOND LIVE CLIENT WAS FOUND. HAGENSBORG, COMPANY 469 ON PROD.
  Every "the client is Glutenull" line in these files was incomplete.
  → P156. READ IT BEFORE PLANNING ANY WRITE TO CLIENT DATA.

---

## STATE
⚠ READ OFF BOTH BOXES AT S107 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺260 · 200
          frontend SERVING dev-a94f39c3b2bf      ← NEW IN S107
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 51e9f4e · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ HELD AT 260 THROUGH S106 AND S107. Nothing restarted.

PROD      15.157.38.101 · pm2 abletrace-backend ↺340 · 200
          TWO LIVE CLIENTS · SERVING prod-a94f39c3b2bf  ← NEW IN S107
          backend HEAD 51e9f4e · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 42 updates pending · restart required → P102
          ⚠ ↺ HELD AT 340. No restart in S107 — a frontend deploy
            does not touch pm2.
```

```
✓ BACKENDS MATCH     dev 51e9f4e        prod 51e9f4e
✓ FRONTENDS MATCH    dev a94f39c3b2bf   prod a94f39c3b2bf
✓ THE VIEW MATCHES   3 divisions on each box
✓ THE PROC MATCHES   received_units served on each box
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES.
  J84: the two boxes run DIFFERENT OPERATING SYSTEMS. Dev is a twin
  of the APP, never of the HOST.
```

```
GITHUB    frontend main = a94f39c3   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = 51e9f4e    (live on both boxes)
          docs     main = ⚠ WRITE THIS FROM GITHUB AT THE NEXT OPEN,
                             NOT FROM THIS LINE. → RULES 6.

          ⚠ RUN #56 (30b2ddd4) IS STILL QUEUED ON GITHUB AND WILL
            NOT CANCEL — "Failed to cancel workflow", twice.
          ⚠⚠ IF IT EVER COMPLETES, ITS ARTIFACT REMOVES THE UNIT
            COUNT FROM QTY Completed. IT IS SUPERSEDED BY a94f39c3.
          ▶ NEVER DEPLOY A dist-*-30b2ddd* ZIP. Read the commit
            stamp in the filename, not the position in an ls.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-a94f39c3b2bf
          prod  /home/ubuntu/www-html.bak-prod-a94f39c3b2bf
          ⚠ EACH HOLDS THE BUILD IT REPLACED, NOT THE ONE IT IS
            NAMED AFTER. Dev's holds 8fa2ed14179d. Prod's holds
            0ad1f77cee1d.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.

          DATABASE BACKUPS, S107, in /home/ubuntu on each box:
            DEV   Trace_ProductHeaderView.bak-S107-DEV.txt
            PROD  Trace_ProductHeaderView.bak-S107-PROD.txt
          ⚠ BOTH VERIFIED BEFORE USE — 5932 bytes, 6 slashes,
            22 joins, 5 selects. The two boxes were BYTE-IDENTICAL.
          ⚠ SHOW CREATE text, NOT runnable as-is. Strip the banner
            and the trailing charset lines, add CREATE OR REPLACE.
            The S107 node script did exactly that; its shape is JR18.

          S106 DATABASE BACKUPS still on both boxes:
            WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt  KEEP
            WhC_GetMoDetails_SP.after-S106-{DEV,PROD}.txt KEEP

          BACKEND BACKUP still on DEV:
            MLOManagement.js.bak-S105-P140-attempt2   keep, it is live
          ⚠⚠ NEVER PUT A BACKUP IN api/models/. TRAPS/P153.
```

```
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small
```

```
COMPANIES ⚠⚠ THERE ARE TWO LIVE CLIENTS ON PROD, NOT ONE.
            471  GLUTENULL1   producing. 2 MOs, both complete.
            469  HAGENSBORG   ⚠ NEW TO THE RECORD, S107.
                              7 MOs CREATED, NONE RUN.
                              24 MR rows. ZERO release allocations.
          ⚠ 464 test260703@ and 465 test260704b@ are SANDBOXES on
            prod. 464 has FOUR MR ROWS including a MATERIAL one.
            ▶ USE 464 FOR PROD SCREEN CHECKS. No client data touched.
          ⚠ 474 = test260805@ ON DEV. THE CLEAN REFERENCE SET.
          ⚠ 464 ON DEV is the older, dirty fixture set — and it is
            the ONLY dev company with dispatch orders in all three
            states. Login test260703.
          ⚠ dev also carries 466, 469, 470, 472, 473 → P100
            ⚠ P100 SAID "dev". 469 IS A REAL CLIENT ON PROD. The
              unaccounted-company problem is not dev-only. → P156.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC — OR RUN LOCALLY ON A PROD TERMINAL.
  NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156.
  ⚠ S107 ISSUED ONE BLOCK WITHOUT IT AND IT RAN ON THE WRONG BOX.
    Harmless — it was a read — but it wrote a file named `-DEV`
    onto PROD. Renamed. → LESSON 5.
```

---

## P135 rows 3, 4, 5 — ✓ CLOSED S107. BOTH BOXES. SCREEN-PROVEN.

```
WHAT IT WAS: Trace_ProductHeaderView derived three unit counts by
dividing a Kg figure by wgt_kgs_per_unit. The stored counts were
sitting on the very rows the view's own CTE was already reading —
just never selected. FOURTH instance of the pattern.

THE CHANGE: three unit sums ADDED to the do_products CTE, three
divisions DELETED. Nothing else. Same 22 joins, same WHERE, same
GROUP BY, same outer SELECT, same aliases and positions.

  qty_shipped_u       ← do.qty_shipped     ⚠ ACTUALLY SHIPPED
  qty_packing_slip_u  ← do.packing_units   ⚠ authorised
  qty_do_u            ← do.packing_units   ⚠ authorised

⚠ THE SHIPPED BUCKET TAKES qty_shipped, NOT packing_units. A DO can
  ship more or less than authorised — Minty's ruling S97, J114. They
  are not interchangeable and merging them is a defect wearing a fix.

⚠ ALIASES UNCHANGED, SO NO FRONTEND CHANGE RODE WITH IT. Same shape
  as JR7e. No build was involved in this half of the work.

METHOD — JR16's, on each box separately, from that box's OWN backup:
  1  SHOW CREATE to a .bak file. Verify 5932 bytes, 6 slashes,
     22 joins, 5 selects.
  2  Build the new object ON THE BOX by node script, four anchors,
     each asserted to appear EXACTLY ONCE.
  3  diff old against new. Join count must hold at 22.
  4  Apply. Read the slash count back OUT OF THE DATABASE.
  5  Query the fixture and compare against the baseline.

PROVEN, DEV, company 464, MO-0007, test1.39 at 1.39 Kg/unit:
  BEFORE  qty_shipped_su 7.000000000000001
  AFTER   qty_shipped_su 7
  qty_do_su 1 · qty_packing_slip_su 2 · SOH_su 40 — ALL UNCHANGED
  ON SCREEN: Qty in DO 1# (1.39 Kg) · Qty in PS 2# (2.78 Kg) ·
             Shipped to Customer 7# (9.73 Kg)

PROVEN, PROD: every figure IDENTICAL to baseline, both MOs.
  ⚠ THAT WAS THE EXPECTED RESULT AND IT IS THE PROOF. Prod's two
    fixtures sit on ROUND ratios (20 and 5 Kg/unit) where the
    division happened to land exactly. The route changed; the
    values could not.
  ⚠ Glutenull's traceability screen renders 0# (0 Kg) cleanly on
    all three repointed cells. JR7e's *ngIf gate does NOT blank
    them at zero — measured, not assumed.

⚠ THE Kg COLUMNS WERE THE CONTROL AND THEY DID NOT MOVE. That is
  what makes this evidence rather than hope. → S106 LESSON 6.
```

## P151 — HALF CLOSED S107. THE YIELD DIALOG. → a94f39c3

```
⚠⚠ THIS WAS NOT THE JOB PLAN DESCRIBED. IT WAS A REGRESSION CAUGHT
  IN THE QUEUE, AND PLAN'S OWN FIRST-THREE-ACTIONS WOULD HAVE
  SHIPPED IT. → LESSON 1.

WHAT WAS FOUND: 30b2ddd4 — pushed 10:29 AM, unbuilt all day — was
titled "round the Planned weight and DROP THE UNIT COUNT FROM
COMPLETED". It removed the count because WhC_GetMoDetails_SP did
not serve received_units and the box printed `undefined#`.
S106 FIXED THE PROCEDURE THAT AFTERNOON, WHICH MADE THE REMOVAL
OBSOLETE BEFORE IT WAS EVER BUILT.
⚠ The deployed build 8fa2ed14 had been showing 7# (58.38 Kg)
  correctly on dev ever since — from the OLDER commit.
▶ DEPLOYING 30b2ddd4 AS QUEUED WOULD HAVE TAKEN A WORKING FIGURE
  OFF THE SCREEN. The Actions outage is the only reason it hadn't.

THE FIX (a94f39c3, one file, +9 −8):
  const completedUnits = this.data.mlcDetails.received_units
  qtyCompleted: `${completedUnits}# (${completedKg} ${this.uom})`
⚠ qtyPlanned UNTOUCHED — 30b2ddd4's rounding fix survives intact.

PROVEN ON DEV after Shift+Cmd+R, company 474, MO-0001:
  QTY Planned    7# (58.38 Kg)   ⚠ not 58.379999999999995
  QTY Completed  7# (58.38 Kg)   ⚠ the restored count
PROVEN ON PROD, Glutenull MO-0001:
  Plan Quantity 1750.000# (560.000 Kg)
  Completed Quantity 1750.000# (560.000 Kg)
  ⚠ THE (Kg)-OVER-A-CASE-COUNT LABELS ARE GONE. That was
    30b2ddd4's contribution and it is why prod was promoted.

⚠ THE COMMENT IN THE CODE PAID FOR ITSELF A SECOND SESSION RUNNING.
  Lines 97-104 named the exact string to restore. Nothing had to be
  re-derived. → P118. THE NEW COMMENT RECORDS WHY IT CAME BACK, so
  nobody re-drops it reading 30b2ddd4's message.
```

## P151 — WHAT IS STILL OPEN, AND IT IS NOT WHAT PLAN SAID

```
⚠⚠ PLAN SAID "THE BLOCKER IS GONE" FOR ALL THREE SITES. IT WAS GONE
  FOR ONE. Measured in S107 by reading the files.

:295  lotReceived      ⚠ DEAD. Consumer at :311 is commented out
                         (J114). NOT P151's. → P115. DO NOT PATCH.
:298  completeUnit     ✓ LIVE, consumed at :310. received_units is
                         served. ▶ REPOINTABLE. NOT YET WRITTEN.
:354  getWdu           ⚠ ONE LIVE CALLER ONLY — html:258. The call
      + html:258         at :309 is commented out. SO THESE ARE ONE
                         SITE, NOT TWO. Fixing html:258 makes getWdu
                         dead → delete it in the same pass (P115).
                       ⚠⚠ BLOCKED. It is a PER-RECEIPT row, not the
                         MO total. Using mlcDetails.received_units
                         here would put the WHOLE MO's figure on
                         EVERY receipt row.
                       ▶ IT NEEDS receiveproducts.qty, and
                         WhC_GetMoProductReceivingDetails_SP DOES
                         NOT SERVE IT. MEASURED S107 — it selects
                         id, internalCode, mlc_id, mlc_packaging_id,
                         received_at, recieved_qty. NO unit count.
                       ▶ FIFTH INSTANCE OF THE PATTERN. It is a
                         PROCEDURE change, not a frontend one. → S108.
```

---

## THE FIXTURE — THE STANDING REFERENCE SET
⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW OR THE SCREEN.

### COMPANY 474 · test260805@ · on DEV — THE CLEAN SET

```
FO-0003-3  testpdt4lvl   formulations.id 3695   batch_qty 5
  fopackaging 5748  Pouch   quantity 1  wgt 0.73   whd 0  Level 1 Pack
  fopackaging 5749  Carton  quantity 4  wgt 2.92   whd 0  Level 1 Pack
  fopackaging 5750  Case    quantity 3  wgt 8.76   whd 0  Level 2 Pack
  fopackaging 5751  Pallet  quantity 7  wgt 61.32  whd 0  Level 3 Pack
  fopackaging 5752  Label   quantity 1  wgt 61.32  whd 1  Level 4 Pack
  batch = 5 pallets = 306.60 Kg
  ⚠ TWO ROWS SHARE "Level 1 Pack". Numbering runs 1,1,2,3,4.
  ⚠ WHY THIS FIXTURE WORKS: ratios 4/3/7/1 are all different and
    NONE equals batch_qty 5. Base weight 0.73 is not round.
  ⚠ PALLET AND LABEL STILL COINCIDE with the broken arithmetic at
    every MO quantity. LEVELS 1-3 ARE THE ONLY DISCRIMINATORS.

MO-0002  mlomanagement.id 11810
  qty 2 · received_qty 122.64 · received_units 2 · batches 0.4
  lotCode Pdt-260806-1 · Rec-260806-1
  RELEASED: Ginger Powder 122.640 Kg · Pouch 168 · Carton 42
            Case 14 · Pallet 2 · Label 2

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  pouch  quantity 1  wgt 1.39  whd_flag 0
  fopackaging 5733  case   quantity 6  wgt 8.34  whd_flag 1
  ⚠⚠ CANNOT PROVE A PACKAGING FIX. batch_qty is 6 AND there are six
    pouches per case. USE FO-0003-3.

MO-0001  mlomanagement.id 11809
  qty 7 · received_qty 58.38 · received_units 7 · batches 1.167
  ⚠ 7 x 8.34 = 58.379999999999995 IN FLOATING POINT. a94f39c3
    rounds it. VERIFIED ON SCREEN S107.
```

### COMPANY 464 · test260703 · on DEV — THE DISPATCH-BUCKET FIXTURE

```
⚠⚠ NEW IN S107 AND IT IS THE ONLY ONE OF ITS KIND ON EITHER BOX.
  FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007.
  DISPATCH ORDERS IN ALL THREE BUCKET STATES:

    DO-0007   9.73 Kg   units 7   shipped_flag 1     SHIPPED
    DO-0010   1.39 Kg   units 1   shipped_flag 0     ON PACKING SLIP
    DO-0011   1.39 Kg   units 1   shipped_flag 0     ON PACKING SLIP
    DO-0016   1.39 Kg   units 1   shipped_flag NULL  DO ONLY
                                  ⚠ CREATED IN S107 FOR THIS PURPOSE

  MO-0007 header view figures, post-fix:
    qty_produced_su 51 · qty_do_su 1 · qty_packing_slip_su 2
    qty_shipped_su 7 · qty_misc_release_su 1
    intermediate_prd_su 0 · SOH_su 40
    ⚠ RECONCILES EXACTLY: 51 − 1 − 2 − 7 − 1 − 0 = 40

⚠ DO NOT DELETE DO-0016. It is the only DO-only row at a non-round
  weight, and the next view change needs the same three buckets.
⚠ 464 IS A DIRTY BASELINE for other purposes — MAT-6 missing its
  Sesame (S73), MAT-5 carrying Eggs (S78), FO-0005 fork residue
  (S77). NONE of it touches dispatch orders.
```

### THE MR FIXTURE — AND WHY IT BLOCKED A ROW

```
DEV, MO-0007:  rejectmaterialandproduct id 3358
               qty_rejected 1.39 · qty_rejected_units 0
⚠⚠ THE COLUMN EXISTS (JR15, S103) AND HOLDS ZERO. The row predates
  the column. Repointing qty_misc_release_su today would turn a
  right-looking 1 into a wrong 0.
▶ THAT IS WHY ROW 1 DID NOT SHIP IN S107. → S108.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
company                  company_name  ← NOT `name`
fopackaging              formulation_id · material_id ·
                         wgt_kgs_per_unit · quantity · whd_flag ·
                         pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW.
                           Declared BOOLEAN, stored TINYINT.
                           Test truthiness, never === 1.
                         ⚠ quantity = how many of the level BELOW.
                         ⚠ pack_level IS POPULATED. → P152
dispatchorders           qty_to_ship (KG) · qty_shipped (UNITS) ·
                         packing_units (UNITS) · packing_id ·
                         status · do_status
                         ⚠⚠ THREE QUANTITY COLUMNS, TWO BASES, ONE
                           ROW. TRAPS 1.
                         ⚠ qty_shipped = ACTUALLY SHIPPED.
                           packing_units = AUTHORISED. Not the same
                           question. Minty's ruling S97.
                         ✓ BOTH NOW SERVED by Trace_ProductHeaderView.
mlomanagement            qty · received_qty · received_units ·
                         batches · company_id · formula_id ·
                         mlc_status · close_status · lotCode
                         ⚠ batches IS A STORED double holding the
                           ROUNDED figure.
                         ✓ received_units STORED, CORRECT, SERVED.
receiveproducts          qty (UNITS, per receipt) · recieved_qty (KG)
                         · received_at · mlc_id · mlc_packaging_id
                         ⚠⚠ qty IS THE PER-RECEIPT UNIT COUNT and it
                           is NOT SERVED by
                           WhC_GetMoProductReceivingDetails_SP.
                           → P151 site 3, S108.
mlcpackaging             quantity · status · mlc_id · pack_level_id
                         ⚠ ONE ROW PER MO. NOT a per-level table.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
mprrecievelots           MPR_id · qty_allocated (KG) · Rec_Lot_id ·
                         Rec_Product_id · material_id
                         ⚠ Capital MPR_id.
                         ⚠⚠ NO UNIT COLUMN. Confirmed S95, still true
                           S107. This is the P135 schema change.
rejectmaterialandproduct qty_rejected (KG) · qty_rejected_units
                         ⚠ THE UNITS COLUMN EXISTS AND IS EMPTY ON
                           EVERY PRE-S103 ROW. 28 of 28 on prod.
                         ⚠ `type` returns 'Product'. `status`
                           returns 'Active', NOT a number.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id. ⚠ NO UNIT COUNT. → P138
```

---

## THE TWO RELEASE ROUTES — SETTLED S105, PROVEN ON PROD S106

```
INGREDIENTS   recipe quantity per batch × number of batches
              Kg-anchored. The physical release is a weighing.
              ⚠ batches is STORED ROUNDED. Variance ACCEPTED.

PACKAGING     MO quantity × the packing cascade
              Unit-anchored. NO weight at any step.
              ⚠ batches PLAYS NO PART. THEREFORE NO ROUNDING VARIANCE.

⚠ A FRACTIONAL *PLANNED* PACKAGING FIGURE IS A DEFECT.
⚠ A FRACTIONAL *CONSUMED* PACKAGING FIGURE MAY BE HISTORY.
  ⚠ SEEN AGAIN ON PROD IN S107: Glutenull MO-0001 released
    Clamshell320 1750.080 Ea. ▶ MINTY'S RULING S106 STANDS: LEAVE IT.
    It records what was physically picked. DO NOT RE-RAISE.
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf on both, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE VIEW <name>\G"
  ⚠ NAME THE DATABASE. ⚠ USE \G, NOT ;.

Trace_ProductHeaderView   ✓ CHANGED S107, BOTH BOXES. → JR18.
  ⚠ 5932 bytes before, ONE LINE. 22 joins. 5 selects.
  ⚠ THREE DIVISIONS REMAIN, all correct arithmetic:
      qty_misc_release_su · intermediate_prd_su · SOH_su
  ⚠ SEVEN _su FIELDS. qty_produced_su was repointed in S100 and
    already reads mm.received_units — the model for the rest.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT PAID FOR ITSELF IN S107. The
    do_products CTE defines its own alias `qty_shipped` which sums
    do.qty_to_ship and is KG. The real column is UNITS. Reading the
    name instead of the definition wires Kg into a units field.
    ▶ RESOLVED TO ITS DEFINITION BEFORE THE EDIT. Keep TRAPS 10
      until the last three divisions go.
  ⚠ P136: it returns DUPLICATE ROWS. Pre-existing, unchanged.
  ⚠ ONE CONSUMER ONLY: product-traceability-details.component.ts
    and api/models/Traceability.js.

WhC_GetMoDetails_SP    ⚠ FEEDS Edit-Mlc AND the yield dialog.
  ✓ CHANGED S106, BOTH BOXES. Selects received_units. → JR17.
  ⚠ 28 lines. ONE select. Eight left outer joins. No branches.

WhC_GetMoProductReceivingDetails_SP
  ⚠⚠ MEASURED S107. Selects id · internalCode · mlc_id ·
    mlc_packaging_id · received_at · recieved_qty. NO UNIT COUNT.
  ▶ THE `2.000#` ON THAT PANEL IS DERIVED BY DIVIDING. → P151 site 3.

WhC_GetMoPackagingConfiguration_SP
  Feeds mlcDetails.packagingConfiguration. ⚠ NOT INSPECTED IN FULL.

WhC_GetAllRejectedList_SP — CHANGED S104, BOTH BOXES. → JR16.
  ⚠ WhC_GetAllRejectedList_SP('474','Active') IS THE WORKING CALL.

⚠ db-definitions-S93.txt IS NOW STALE ON FOUR OBJECTS:
  JR7e's view, JR16's proc, JR17's proc, and JR18's view. → P119.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. Built S101. READ-ONLY.
⚠⚠ IT SILENTLY DROPS COMPUTED COLUMNS AND ALIASES. → P152
  ▶ FOR ANYTHING COMPUTED OR ALIASED, USE THE mysql CLIENT.
  ⚠ Trace_ProductHeaderView IS NOTHING BUT COMPUTED COLUMNS.
    S107 USED THE mysql CLIENT THROUGHOUT.
⚠ IT SURVIVES A REBOOT. ⚠ IT IS NOT ON PROD.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 51e9f4e on both boxes.
FRONTEND   ✓ NOTHING PENDING. a94f39c3 built, deployed and
             SCREEN-PROVEN on both boxes.
           ⚠ RUN #56 (30b2ddd4) IS STILL QUEUED AND SUPERSEDED.
             NEVER DEPLOY ITS ARTIFACT. See GITHUB above.
DATABASE   ✓ NOTHING PENDING. Both boxes changed in S107.
DOCS       ⚠ S107's four files pending commit at close, plus JR17,
             JR18, J117 and the Section 5 header correction.
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
P65   promote.sh runs plain scp and ssh with no -4.
      ⚠ RAN TWICE IN S107, both boxes, no trouble.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES — 466, 469, 470, 472, 473.
      ⚠⚠ SUPERSEDED IN PART BY P156. 469 IS A REAL CLIENT ON PROD.
        The problem is not dev-only and the item understates it.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠ PROD 42 UPDATES. Dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
      ⚠⚠ TWELVE DAYS RUNNING. AND THERE ARE NOW TWO CLIENTS ON PROD.
P104  No intermediate fixture on dev. S45 UNTESTED.
      ⚠ THIS IS NOW A BLOCKER, NOT A NICETY. S108 cannot prove
        intermediate_prd_su without one. → see PLAN.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ ONLY P135 REMAINS IN P82, AND ONLY THREE CELLS OF IT.
      ⚠ NEEDS A NEW COLUMN. TRAPS 3 WILL BITE THERE.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
        rejected-materials.component.ts:65
        start-mlc.component.html:361 — commented-out yield button
      ⚠ ADD getWdu (edit-mlc:354) ONCE html:258 IS REPOINTED. Its
        only live caller is that line. Confirmed S107 by grep.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF TWICE NOW — S106 and again in S107, where
        the comment in check-mat-yield named the exact string to
        restore and nothing had to be re-derived.
      ▶ THE PATTERN WORKS. Keep doing it.
P119  Back up the database's own code into the repo.
      ⚠ db-definitions-S93.txt NOW STALE ON FOUR OBJECTS.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, Waterline attribute
      absent. ⚠ TRAPS 3 LIVE.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ COVERED BY RULES 7. ⚠ Needs a build — which now works.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE LAST P82 ITEM. THREE CELLS LEFT OF SIX.
      ✓ qty_shipped_su · qty_packing_slip_su · qty_do_su — DONE S107.
      ⚠ qty_misc_release_su — column exists, EVERY ROW HOLDS 0.
      ⚠ intermediate_prd_su — NO COLUMN AT ALL. Schema change.
      ⚠ SOH_su — DEPENDENT. Cannot move until the intermediate does.
      ⚠ TRAPS 10 STAYS UNTIL ALL THREE LAND.
      ▶ S108. ⚠ ONE RULING FROM MINTY GATES ALL THREE.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST.
      ⚠ MORE URGENT NOW — TWO CLIENTS SHARE THE NUMBERING.
P138  soproducts STORES NO UNIT COUNT — Kg only.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY THEY
      ARE NOT. ⚠ DO NOT "FIX" THESE LINES.
P142  ⚠ THE EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT. ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
P144  read-rows.js CANNOT PRINT A ROUTINE BODY. ⚠ SUPERSEDED BY P152.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES.
      list 25.020 · details 25.02. ⚠ ASK MINTY. LOW.
P147  NO MATERIAL MR ON DEV. ▶ CREATE ONE. One minute. LOW.
P148  ⚠ WITHDRAWN S105 on a misread. NARROW RESIDUAL only. LOW.
P150  ⚠⚠ THE PROCEDURE SURVEY. MINTY'S PROPOSAL, S105.
      Read every stored procedure's SELECT list and ask: does the
      screen it feeds need a unit column, and is it served?
      ⚠ 35 routines and 9 views.
      ⚠⚠ FIVE CONFIRMED INSTANCES NOW — P143, P149, the three header
        divisions, and WhC_GetMoProductReceivingDetails_SP.
        THE PATTERN IS ESTABLISHED BEYOND ARGUMENT.
      ▶ THE P135 SUBSET IS NEARLY DONE. THE FULL SURVEY IS ITS OWN
        SITTING, POSSIBLY TWO. MEDIUM.
P151  EDIT-MLC AND THE YIELD DIALOG.
      ✓ THE YIELD DIALOG — DONE S107, a94f39c3, BOTH BOXES.
      ⚠ :298 completeUnit — LIVE, repointable, NOT WRITTEN.
      ⚠ html:258 + getWdu — BLOCKED on the receiving procedure.
      ⚠ :295 lotReceived is DEAD. → P115, not here.
      ▶ S108, WITH P135. MEDIUM.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      ▶ EITHER FIX THE READER OR PUT A WARNING IN ITS OWN OUTPUT.
      ⚠ SUPERSEDES P144. MEDIUM — it corrupts evidence.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD.
      ⚠ ACTIONS RETURNED IN S107 AFTER ~13 HOURS. Runs #57 and the
        manual prod dispatch both completed normally.
      ⚠ THE OUTAGE COST NOTHING IN THE END — AND IT ACCIDENTALLY
        PREVENTED A REGRESSION. See LESSON 1.
      ▶ STILL WORTH ASKING. ⚠ ASK MINTY. LOW.
P155  ⚠ A COMMIT PUSHED FROM THE MAC DOES NOT UPDATE PROD'S IDEA OF
      origin/main UNTIL SOMETHING FETCHES.
      ▶ `git fetch origin` FIRST, ALWAYS. LOW.
```

### NEW IN S107

```
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT AND THESE DOCUMENTS
      NAMED ONLY ONE.
      Company 469 on PROD. SEVEN MOs CREATED, NONE RUN. 24 MR rows.
      ZERO release allocations. Real products — Milk Peanut Butter
      Bars, Dark Bars, Milk Cashew Bars, HP Milk Hazelnut and more.
      ⚠ NOW's COMPANIES block named Glutenull as "the client" and
        listed 469 among DEV's unaccounted companies (P100). It is
        a CLIENT ON PROD.
      ⚠ EVERY PIECE OF REASONING THAT SIZED CLIENT EXPOSURE AGAINST
        GLUTENULL ALONE WAS INCOMPLETE — including S107's own, until
        the query was run.
      ▶ WHAT IT CHANGES: the S108 backfill is 28 MR rows across TWO
        clients, not "Glutenull's two MOs". And P137 (global MR
        numbering) now affects two clients sharing one sequence.
      ▶ ACTIONS: correct 3B / the companies record; re-scope P100;
        confirm there is no THIRD company nobody has named.
      ⚠ ASK MINTY whether Hagensborg needs anything else recorded —
        onboarding state, licence status, contact. HIGH.

P157  ⚠ WhC_GetMoProductReceivingDetails_SP SERVES NO UNIT COUNT.
      receiveproducts.qty is the stored per-receipt unit figure
      (3A.5 row 5, J19) and the procedure does not select it, so
      edit-mlc html:258 divides recieved_qty by a weight to rebuild
      it. FIFTH instance of the P143/P149 pattern.
      ▶ ONE COLUMN ADDED TO A SELECT LIST, JR16 method, both boxes.
      ⚠ IT UNBLOCKS P151's LAST SITE. ▶ S108. MEDIUM.
```

### ✓ CLOSED IN S107 — DELETE THESE LINES AT S108 CLOSE

```
P140  ✓ DONE S106. (Was marked for deletion at S107 close.)
P143  ✓ DONE S104, BOTH BOXES. (Same.)
P149  ✓ DONE S106, BOTH BOXES. (Same.)
P135  ⚠ PARTIAL — three of six cells. STAYS OPEN.
P151  ⚠ PARTIAL — the yield dialog only. STAYS OPEN.
```

---

## THE MEASUREMENTS TAKEN FOR S108
⚠ TAKEN IN S107 SO S108 DOES NOT HAVE TO STOP AND TAKE THEM.

```
MR ROWS, PROD, by company — rejectmaterialandproduct
  469  Hagensborg    24 rows   ⚠ ALL 24 NEED A BACKFILL
  464  test260703@    4 rows   sandbox
  471  Glutenull1     0 rows   ✓ NO CLIENT EXPOSURE HERE
  TOTAL 28, and 28 of 28 hold qty_rejected_units 0 or NULL.

RELEASE ALLOCATIONS, PROD, by company — mprrecievelots
  471  Glutenull1    26 rows
  464  test260703@   24 rows
  465  test260704b@  18 rows
  469  Hagensborg     0 rows   ⚠ nothing released yet
  ⚠ THIS IS THE UPPER BOUND, NOT THE BACKFILL SIZE. It counts every
    allocation — ingredients, packaging, everything. The
    INTERMEDIATE subset is what intermediate_prd_su reads and it
    has NOT been measured. It may be zero.

⚠ STILL TO MEASURE AT THE TOP OF S108, both quick:
  1  How many of those allocation rows are INTERMEDIATES — i.e.
     released rows whose material is itself a formulation.
     ▶ IF ZERO FOR BOTH CLIENTS, the intermediate backfill touches
       NO client data and the ruling gets much easier.
  2  Whether a dev intermediate fixture exists at all. P104 says
     no. ⚠ IF NOT, ONE MUST BE BUILT BEFORE THE FIX CAN BE PROVEN —
     TRAPS 9 governs, and that is a job, not a check.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    /tmp/*-S107.js, /tmp/*-readable.txt   gone on reboot, ignore
       ~/Trace_ProductHeaderView-S107-DEV.txt          working copy,
                                                       delete S108
       ~/Trace_ProductHeaderView-S107-DEV-readable.txt same
       ~/Trace_ProductHeaderView.bak-S107-DEV.txt      ⚠⚠ KEEP.
                                                       ROLLBACK.
       ~/fix-modetails-S106.sql                        delete S108
       ~/WhC_GetMoDetails_SP.*-S106-DEV.txt            KEEP BOTH.
       ~/MLOManagement.js.bak-S105-P140                delete S108
       ~/MLOManagement.js.bak-S105-P140-attempt2       keep, live
PROD   ~/Trace_ProductHeaderView.bak-S107-PROD.txt     ⚠⚠ KEEP.
                                                       ROLLBACK.
       ~/fix-modetails-S106.sql                        delete S108
       ~/WhC_GetMoDetails_SP.*-S106-PROD.txt           KEEP BOTH.
MAC    ~/Downloads/dist-dev-a94f39c3*.zip              delete S108
       ~/Downloads/dist-prod-a94f39c3*.zip             delete S108
       ~/Downloads/patch-P140-headers-fix.py           ✓ DELETE NOW,
                                                       30b2ddd4 shipped
       ~/Downloads/RULES.md PLAN.md NOW.md             delete S108
       /tmp/patch-P151-yield.py                        gone on reboot
       ~/check-mat-yield.component.*.bak-S105-P140*    delete S108

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106 OR S107 .bak FILES. They are the only
  rollback for database objects on a LIVE CLIENT DATABASE SERVING
  TWO CLIENTS.
```
