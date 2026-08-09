# NOW

Last rewritten: S109, 8 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S109 SHIPPED THREE THINGS AND ALL THREE ARE ON BOTH BOXES.
  281e8bd8  four one-line repoints, frontend
  f4c98e91  the dispatch write, frontend
  JR20      Trace_ProductHeaderView, database, each box separately
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step.

⚠⚠ THE UNITS BIBLE MOVED FOR THE FIRST TIME. 28 GREEN · 16 RED ·
  4 REVIEW, of 48. ▶ IT IS MINTY'S DOCUMENT. Part 1 changes only on his
  instruction; Part 2 is the working record and moves as sites are fixed.

---

## STATE
⚠ READ OFF BOTH BOXES AT S109 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺260 · 200
          frontend SERVING dev-f4c98e91cd64
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 51e9f4e · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 8 updates pending · restart required
          ✓ ↺ HELD AT 260 THROUGH S106 TO S109.

PROD      15.157.38.101 · pm2 abletrace-backend ↺340 · 200
          TWO LIVE CLIENTS · SERVING prod-f4c98e91cd64
          backend HEAD 51e9f4e · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 28 updates pending → P102
          ⚠ ↺ HELD AT 340.
```

```
✓ BACKENDS MATCH     dev 51e9f4e            prod 51e9f4e
✓ FRONTENDS MATCH    dev f4c98e91cd64       prod f4c98e91cd64
✓ THE VIEW MATCHES   2 divisions on each box   ⚠ WAS 3. JR20.
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = f4c98e91   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = 51e9f4e
          docs     main = ⚠ WRITE THIS FROM GITHUB AT THE NEXT OPEN.
          ⚠⚠ RUN #56 (30b2ddd4) IS STILL QUEUED — TWO DAYS, AND IT
            REFUSES TO CANCEL. Confirmed on screen S109. The menu offers
            only "Create status badge"; there is no cancel or delete on
            a run that never started. `gh` IS NOT INSTALLED ON THE MAC.
            ▶ NEVER DEPLOY A dist-*-30b2ddd* ZIP. Read the commit stamp
              in the filename, not the position in an ls. → J117.
            ▶ Run id 31123281418 if the API route is ever taken. LOW.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-f4c98e91cd64
          prod  /home/ubuntu/www-html.bak-prod-f4c98e91cd64
          ⚠ EACH HOLDS THE BUILD IT REPLACED, NOT THE ONE IT IS NAMED
            AFTER. dev's holds 281e8bd8; prod's holds a94f39c3.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.

          DATABASE BACKUPS on each box — ⚠⚠ KEEP ALL OF THESE:
            Trace_ProductHeaderView.bak-S109-{DEV,PROD}.txt  ⚠⚠ CURRENT
              6193 bytes · 3 slashes · 22 joins · BYTE-IDENTICAL
            WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt (+ .after-)
          ⚠⚠ THE S107 VIEW BACKUPS ARE NOW TWO GENERATIONS STALE. The
            S109 pair is the rollback. ▶ DELETE THE S107 PAIR — see TIDY.
```

```
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  · prod i-0b54ae374250348e0 · t3.small
```

```
COMPANIES ⚠⚠ TWO LIVE CLIENTS ON PROD.
            471  GLUTENULL1   2 MOs, both complete. 26 release rows.
                              ZERO MR rows. ZERO dispatch orders.
            469  HAGENSBORG   7 MOs created, none run. ZERO release
                              rows. 24 MR rows, ALL MATERIAL, ALL with
                              mlc_id NULL. ZERO dispatch orders.
                              ⚠ Their MOs carry NO intermediates.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
            MEASURED S109. All nine DOs on prod are sandbox.
          ⚠ 464 test260703@ and 465 test260704b@ are SANDBOXES on prod.
            ▶ USE 464 FOR PROD SCREEN CHECKS.

⚠⚠ THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE.
  DEV 469 = test260710@.  PROD 469 = HAGENSBORG.
  Dev also carries 466 "Test Glutenul", which is NOT Glutenull.
  ▶ NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX. → P156

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY BLOCK. It caught two wrong-box
    attempts in S109, both harmless — the pem does not exist on the
    boxes, so a wrong-box ssh FAILS rather than succeeding somewhere
    unintended.
```

---

## THE FIXTURES — ⚠ DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE INTERMEDIATE FIXTURE

```
IP-0.37      FO-0004   0.37 Kg/unit   19 shipping units per batch
             Single level, Internal container. Recipe: Ginger Powder.
Parent-0.53  FO-0005   0.53 Kg/unit   13 shipping units per batch
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units

MO-0003  IP-0.37, 41 units, COMPLETE, lot Pdt-260807-1
         ⚠ ONE RECEIPT. Banked over-release: 15.171 Kg released against
           a true requirement of 15.170.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. IT IS THE BEFORE PICTURE FOR STEP 4.

MO-0005  ⚠⚠ NEW IN S109 AND IT IS THE PRECONDITION FOR STEP 3.
         IP-0.37, 13 units, lot Pdt-260808-1, COMPLETE.
         ▶ TWO RECEIPTS: 5 units (1.850 Kg) and 8 units (2.960 Kg).
           receiveproducts.qty holds 5 and 8 on SEPARATE ROWS.
         ⚠ UNEQUAL DELIBERATELY. If a fix wrongly serves the MO TOTAL,
           both rows read 13 and the error is unmistakable.
         ⚠⚠ WITHOUT THIS, STEP 3a CANNOT BE PROVEN AT ALL.
         ⚠ Batches 0.684 — fractional. A SECOND STEP 4 FIXTURE, free.

MR-0009  ⚠ NEW IN S109. Ginger Powder, 10 Kg, reason Sample. MATERIAL.
         Stock moved 9806.983 → 9796.983 Kg. ▶ P147 CLOSED.
         ⚠ Renders as "10.000 Kg" with NO unit count — correct, it is a
           Material. The type gate on the MR list, working.

DO-0002  ⚠ NEW IN S109. IP-0.37, 7 units typed, qty_to_ship 2.59 Kg,
         packing_units STORED AS 7. ▶ THE ROW 30 PROOF. DO NOT CLEAR.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS, so nearly any MO
  quantity produces a repeating decimal. TRAPS 9: a round ratio hides a
  division entirely. THAT IS WHY THESE NUMBERS.

THE THREE PROOFS STILL VISIBLE ON MO-0004, BEFORE STEP 4:
  1  Plan Quantity 23.000# (2303.910 Kg) vs Ginger Powder req.
     2303.609 Kg — 0.301 Kg APART ON THE SAME PAGE.
  2  IP-0.37 required 5.891 Kg  ⚠ Kg under a units header.
                                  True: 9 × 23/13 = 15.923 units.
  3  WH Stock in # (UOM) 15.170 Kg ⚠ Kg. The warehouse holds 41 units.

⚠⚠ THE CONTROL — Pouch 4347.000 Ea = 23 × 9 × 7 × 3. IT MUST NOT MOVE
  AT ANY STEP. If a packaging figure shifts, THE FIX IS WRONG.
```

### COMPANY 464 · test260703 · on DEV — THE OLDER FIXTURES

```
FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007
  DISPATCH ORDERS IN ALL THREE BUCKET STATES:
    DO-0007  shipped · DO-0010, DO-0011  on packing slip · DO-0016  DO only
  ⚠ DO NOT DELETE DO-0016.
  ⚠ DO-0008 and DO-0009 carry packing_units 0.5 — THE FRACTIONAL
    FIXTURE.

⚠⚠ MO-0002 CARRIES **TWO** 2 Kg GINGER POWDER RETURNS. → P168's proof.
MO-0011  A 2 Kg GINGER POWDER RETURN. → P164's fixture.
  ⚠⚠ DO NOT CLEAR EITHER.

⚠ 464 IS A DIRTY BASELINE — MAT-6 missing its Sesame (S73), MAT-5
  carrying Eggs (S78), FO-0005 fork residue (S77).
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
⚠⚠ THE FULL PICTURE IS IN UNITS-BIBLE.txt PART 1. What follows is only
  what the bible does not cover.

mprrecievelots       qty_allocated (KG) · MPR_id · Rec_Lot_id ·
                     material_id · Rec_Product_id · formula_id
                     ⚠⚠ TWO PARALLEL FK PAIRS ON ONE ROW, AND WHICH
                       PAIR IS POPULATED ENCODES THE RELEASE TYPE.
                       material_id + Rec_Lot_id  = MATERIAL
                       formula_id  + Rec_Product_id = PRODUCT
                     ⚠ NO UNIT COLUMN. → STEP 5.

returnmpreceivelots  ⚠⚠ AN EXACT TWIN OF THE ABOVE, column for column.
                     qty_return (KG) · ReturnMP_id · same four FKs.
                     ⚠ ONE ROW ON EACH BOX. Both material.

rejectmaterialandproduct  qty_rejected (KG) · qty_rejected_units
                     ⚠ `type` returns 'Product' or 'Material' AS WORDS.
                     ⚠ `status` returns 'Active', NOT a number.
                     ⚠⚠ MATERIAL MRs CARRY NO mlc_id. PRODUCT MRs
                       ALWAYS DO. Clean across both prod companies.
                     ⚠⚠ EVERY PRE-S103 ROW HOLDS qty_rejected_units 0.
                       JR20 now reads that column. → P170.

rejectedmaterial · rejectedproduct
                     ⚠ EMPTY ON BOTH BOXES. Pre-merge design. → P109.

⚠ ROW COUNTS, MEASURED S109 — P161 CLOSED:
                          DEV   PROD
    do_receive_products     28      9
    mlodetails              91    129   ⚠ LIVE CLIENT DATA, NO MAP ROW
    forecastsales            0      0   ▶ EMPTY BOTH BOXES. UNBUILT.
  → P171 for the first two.

company              company_name  ← NOT `name`
fopackaging          formulation_id ← NOT `formula_id`
                     ⚠ mlomanagement uses formula_id. TWO SPELLINGS,
                       ONE RELATIONSHIP, CONSTANTLY JOINED. S109 lost a
                       query to this.
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE VIEW <name>\G"

Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. WAS THREE. → JR20.
  ▶ intermediate_prd_su and SOH_su. BOTH BLOCKED ON STEP 5's SCHEMA.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE. The do_products CTE defines
    its own alias `qty_shipped` summing do.qty_to_ship — KG. The real
    column is UNITS. RESOLVE EVERY NAME TO ITS DEFINITION.
  ⚠ P136: it returns DUPLICATE ROWS. Pre-existing, untouched by S109.
  ⚠ ONE CONSUMER: product-traceability-details.component.ts.

WhC_GetMoIntermediateProducts_SP   ⚠ READ IN FULL S109. → PLAN STEP 3b.
  Serves subrecipeformulation.qty (Kg) and formulations.inventory (Kg).
  ▶ NEEDS subrecipeformulation.ship_qty. NO NEW JOIN — already joined.
  ⚠ IT ALIASES EVERYTHING. A frontend build rides with the change.

WhC_GetFormulaIntermediateProducts ⚠ READ IN FULL S109. → PLAN STEP 3c.
  Near-twin: IDENTICAL joins, identical WHERE, same parameter.
  ▶ NEEDS formulations.inventory_units. NO NEW JOIN, NO ALIAS NEEDED.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. 3b returns
    `formulations_inventory`; 3c returns `inventory`. ANY FRONTEND
    CHANGE MUST BE WRITTEN AGAINST THE RIGHT ONE.

WhC_GetMoProductReceivingDetails_SP  ⚠ NO UNIT COUNT. → PLAN STEP 3a.
  ▶ NEEDS receiveproducts.qty — the per-receipt count. MEASURED S109.

Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT.
  Divides qty_allocated, AND joins fopackaging with NO whd_flag filter.
  ✓ ITS SIBLING CARRIES THE FILTER, WITH A COMMENT. Copy it.
  ⚠ @formulationId is SET and NEVER USED.

MLOManagement.js  ⚠⚠ THE ENDPOINT NAME LIES. Route `mlo/getMLCbyId`
  reaches the controller at :38, which calls **getMLCbyIdV3** — the old
  call is COMMENTED OUT at :39. The model holds all three versions:
  V3 at 386 (LIVE), V2 at 424, original at 648. → P115.
  ⚠ V3 returns the proc's first row WHOLE. Every column the proc selects
    reaches the frontend. No column list to maintain.

⚠ db-definitions-S93.txt IS STALE ON FIVE OBJECTS. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 51e9f4e on both boxes.
FRONTEND   ✓ NOTHING PENDING. f4c98e91 on both boxes.
DATABASE   ✓ NOTHING PENDING. JR20 applied to both boxes.
DOCS       ⚠ S109's OUTPUT PENDING COMMIT:
             UNITS-BIBLE.txt + .xlsx        ✓ COPIED TO REPO, VERIFIED
             PLAN.md                        ✓ COPIED TO REPO, VERIFIED
             NOW.md                         this file
             Section_5.md                   ⚠ JR20 + J119 TO MERGE, and
                                              CORRECT ITS OWN HEADER to
                                              J119 / JR20 / S109.
```

---

## QUEUE
⚠ New items at the bottom with the next free number. Claude never
renumbers. Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.  P22  Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod. → P10.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.  P85  Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠ PROD 28 UPDATES. Dev 8.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
      ⚠⚠ FIFTEEN DAYS RUNNING. TWO CLIENTS ON PROD.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ ALSO rejectedmaterial and rejectedproduct — empty on both.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠ FOUR THINGS WILL MEET IT: TRAPS 3 · J97's multiple invoices
        pointing at a child table · P138 · P137.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ NAMED IN S109, ALL THREE PROVEN DEAD:
        rejected-materials.component.ts:152-154 getShippingUnits —
          NO CALLER ANYWHERE. It divides, and the map pointed at it.
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424) —
          the controller calls V3.
      ⚠ ADD edit-mlc getWdu once html:258 goes (STEP 3a).
      ⚠ ADD PopUps/add-dispatch (v1) — whole component, never opened.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A THIRD TIME IN S109 — product-traceability's
        own comment revealed the site was already fixed.
P119  Back up the database's own code into the repo. ⚠ STALE ON FIVE.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, attribute absent. ⚠ TRAPS 3.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ TWO CELLS LEFT OF SIX. qty_misc_release_su DONE S109 (JR20).
      ▶ intermediate_prd_su and SOH_su. BOTH NEED PLAN STEP 5.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
      ⚠⚠ DO NOT "FIX" THESE LINES.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT. ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. ⚠ ASK MINTY. LOW.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P151  EDIT-MLC AND THE YIELD DIALOG.
      ✓ THE YIELD DIALOG — DONE S107.
      ✓ :298 completeUnit — DONE S109, commit 281e8bd8.
      ⚠ html:258 + getWdu → PLAN STEP 3a.
      ⚠ :295 lotReceived is DEAD. → P115.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      ▶ FIX IT OR WARN IN ITS OWN OUTPUT. ⚠ IT CORRUPTS EVIDENCE.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. ⚠ ASK MINTY. LOW.
P155  A Mac push does not update prod's origin/main until something
      fetches. ▶ `git fetch origin` FIRST, ALWAYS. LOW.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT
      SHARE A COMPANY-ID NAMESPACE.
      ▶ ACTIONS: correct 3B, re-scope P100, confirm no third company.
P157  ⚠ WhC_GetMoProductReceivingDetails_SP SERVES NO UNIT COUNT.
      ▶ PLAN STEP 3a. ✓ THE MULTI-RECEIPT FIXTURE NOW EXISTS — 474
        MO-0005. THE BLOCKER IS GONE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins
      fopackaging with NO whd_flag filter. ▶ PLAN STEP 5. MEDIUM.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated.
      ⚠ Four wildcard expansions. ▶ PLAN STEP 5. MEDIUM.
P160  ⚠ THE TWO INTERMEDIATE PROCEDURES SERVE Kg ONLY.
      ✓ BOTH READ IN FULL S109. Neither needs a new join.
      ▶ PLAN STEP 3b/3c. MEDIUM.
P161  ✓ CLOSED S109. Row counts taken on both boxes. forecastsales is
      EMPTY on both — unbuilt scope, off the list. The other two → P171.
P162  ⚠⚠ THE REQUIREMENT MULTIPLIES BY THE STORED ROUNDED `batches`.
      Compute it live. ⚠⚠ SUPERSEDES THE S105 RULING. RULES 7 MUST BE
      REWRITTEN. ⚠⚠ IT MOVES NUMBERS ON A SCREEN BOTH CLIENTS USE
      DAILY. OWN SESSION, OWN GATE. ▶ PLAN STEP 4. HIGH.
      ✓ TWO FIXTURES NOW — 474 MO-0004 (batches 1.769) and MO-0005
        (batches 0.684).
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. PROVEN ON DEV.
      ▶ THE PATH HAS NEVER RUN BECAUSE IT CANNOT BE RUN.
      ▶ PLAN STEP 6. MEDIUM.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL.
      ▶ THE SIGN IS INVERTED. An operator 2 Kg SHORT is told they are
      2 Kg OVER, with the bar full green. ⚠ LIVE ON BOTH CLIENTS.
      ▶ PLAN STEP 6 — NOT fixed early. See P168 for why a half-fix is
        worse. ⚠ ACCEPTED RISK, MINTY'S CALL, MADE KNOWINGLY.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ PLAN STEP 6. MEDIUM.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds
      Kg. ▶ REVIEW, not a confirmed defect. LOW.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER.
      ⚠⚠ CONFIRMED S109 BY READING THE BODY. mfg-lot-codes.ts:124-131
        getWdu computes (qty/batch) × (batch/wgt) — IT DIVIDES WHATEVER
        IT IS HANDED. Feeding it a stored count would print a WRONG
        number where a right one stands today.
      ✓ THE CORRECT SHAPE IS EIGHT LINES BELOW IT — getPlannedKg:133
        takes stored units and multiplies, with an S42 comment.
      ⚠ BIBLE ROW 25 IS ONE OF THE SEVEN CALLERS.
      ▶ OWN SITTING. Read all seven callers, decide each, then edit.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. A second return
      MOVES STOCK, IS WRITTEN TO THE DATABASE, AND NEVER APPEARS on
      the MO or in the release figure.
      ⚠⚠ A MATERIAL MOVEMENT WITH NO TRACE ON THE MANUFACTURING ORDER
        IS A TRACEABILITY GAP, IN A TRACEABILITY SYSTEM.
      ⚠ THE CODE HAS NOT BEEN READ. CAUSE UNKNOWN.
      ▶ PLAN STEP 6. HIGH, AND SURVEYED BEFORE TOUCHED.
```

### NEW IN S109

```
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS.
      On dev 474 IP-0.37 the downstream-MO card reads
        15.170 (41.000 Kg)
      15.170 IS THE KILOGRAMS. 41 IS THE UNIT COUNT. The bare number is
      the weight and the unit count carries the Kg suffix — the app's
      convention everywhere else is units# (Kg).
      ⚠ DISPLAY ONLY. Nothing is stored wrong.
      ▶ BIBLE ROW 48. LOW.
      ⚠ SAME POPUP shows "In Progress 23# (8.51 Kg)" on IP-0.37, and 23
        is MO-0004's quantity — an MO for Parent-0.53, NOT IP-0.37. The
        popup lists DOWNSTREAM MOs by design (J114), so this MAY BE
        CORRECT. ⚠ NOT PROVEN EITHER WAY. One query. DO NOT WRITE IT UP
        AS A DEFECT UNTIL SOMEBODY LOOKS.

P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS NOW READ LOW IN THE VIEW, AND THAT IS
      THE TRADE JR20 MADE KNOWINGLY.
      Any MR row written before JR15 landed in S103 never stored a unit
      count. JR20 reads that column, so those cells read 0 or low where
      the old division was arithmetically CORRECT.
      ▶ PROVEN ON DEV: MO-0001's 41.7 Kg cell went 5 → 3. Two rows on
        mlc_id 11809 — 16.68 Kg with units 0, 25.02 Kg with units 3.
      ▶ VISIBLE IN THE APP TOO: dev MR-0007 renders "0# (16.680 Kg)".
      ✓ NO CLIENT ROW IS AFFECTED. MEASURED ON PROD BEFORE THE WRITE —
        Glutenull has ZERO MR rows; Hagensborg's 24 are ALL Material
        with mlc_id NULL and were already 0. Only sandbox 464 moved.
      ⚠⚠ THE DECISION IS WHETHER TO HEAL THE OLD ROWS, AND HEALING MEANS
        DIVIDING Kg TO RECONSTRUCT UNITS — the exact round-trip this
        campaign exists to remove. ▶ MINTY'S CALL. NOT URGENT: no client
        row, and every row written since S103 stores its count.

P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
      mlodetails.rcp_qty — 91 rows dev, ⚠ 129 ON PROD, LIVE CLIENT DATA
      do_receive_products.qty_to_dispatch — 28 dev, 9 prod
      ▶ READ WHAT THEIR QUANTITY COLUMNS ACTUALLY HOLD, then decide
        whether each earns a bible row. Survey work, not campaign work.
      ⚠ forecastsales was the third and is EMPTY ON BOTH BOXES. Closed.
```

### ✓ CLOSED IN S109 — DELETE THESE LINES AT S110 CLOSE

```
P147  ✓ MATERIAL MR CREATED ON DEV 474. MR-0009, 10 Kg Ginger Powder.
P161  ✓ ROW COUNTS TAKEN ON BOTH BOXES. Residual is P171.
P104 · P150   ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    ~/Trace_ProductHeaderView-S107-DEV*.txt         delete
       ~/Trace_ProductHeaderView.bak-S107-DEV.txt      ⚠ NOW STALE.
                                                       delete — the
                                                       S109 pair is the
                                                       rollback
       ~/Trace_ProductHeaderView.bak-S109-DEV.txt      ⚠⚠ KEEP
       ~/fix-header-view-S109.sql                      keep this session
       ~/fix-modetails-S106.sql                        delete
       ~/MLOManagement.js.bak-S105-P140                delete
       ~/WhC_GetMoDetails_SP.*-S106-DEV.txt            KEEP BOTH
       ~/MLOManagement.js.bak-S105-P140-attempt2       keep, live
PROD   ~/Trace_ProductHeaderView.bak-S107-PROD.txt     ⚠ NOW STALE.
                                                       delete
       ~/Trace_ProductHeaderView.bak-S109-PROD.txt     ⚠⚠ KEEP
       ~/fix-header-view-S109-PROD.sql                 keep this session
       ~/fix-modetails-S106.sql                        delete
       ~/WhC_GetMoDetails_SP.*-S106-PROD.txt           KEEP BOTH
MAC    ~/Downloads  ✓ CLEARED AT THE S109 CLOSE. Four files remain and
                      all are legitimate: PLAN (2).md (the source),
                      QUANTITY-SURVEY-S108.md, RULES-7-DRAFT.md,
                      Section_5_S109_append.md (to merge).
       ⚠⚠ THE S109 LESSON: FOURTEEN superseded copies had accumulated,
         and the NEWEST FILE WAS NOT THE PLAINEST NAME. `PLAN.md` was
         S108's; `PLAN (2).md` was tonight's. AND THE TEXT BIBLE HAD
         NEVER BEEN DOWNLOADED AT ALL — only the spreadsheet — so a
         commit from Downloads would have filed the AUTHORITATIVE file
         at the S108 state while the readable copy said 28.
         ▶ VERIFY BY STAMP, NEVER BY BRACKET NUMBER OR POSITION.

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106 OR S109 .bak FILES. They are the only
  rollback for database objects on a LIVE CLIENT DATABASE.
```
