# NOW

Last rewritten: S110, 9 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S110 SHIPPED FOUR THINGS AND ALL FOUR ARE ON BOTH BOXES.
  0dad104d  the receiving panel repoint, frontend
  bc03b22d  getFactor in three components, frontend
  9230789   both final_qty lines, BACKEND — ⚠ first backend change since S109
  JR21      WhC_GetMoProductReceivingDetails_SP, database, each box separately
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step.

⚠⚠ THE BOARD MOVED BY TWO, NOT FOUR. 30 GREEN · 3 PART · 11 RED · 4 REVIEW,
  of 48. ▶ CLAUDE CLAIMED 32 MID-SESSION AND WAS WRONG. See LESSONS.
  ▶ 44 IS THE CEILING, NOT 48 — rows 44/45/46/47 are review items that close
    as decisions, not fixes.

---

## STATE
⚠ READ OFF BOTH BOXES AT S110 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺261 · 200
          frontend SERVING dev-bc03b22dc375
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 9230789 · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 8 updates pending · restart required
          ⚠ ↺ MOVED 260 → 261. The P162 backend restart.

PROD      15.157.38.101 · pm2 abletrace-backend ↺341 · 200
          TWO LIVE CLIENTS · SERVING prod-bc03b22dc375
          backend HEAD 9230789 · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING — WAS 28 AT S109. → P102
          ⚠ ↺ MOVED 340 → 341. The P162 backend restart.
```

```
✓ BACKENDS MATCH     dev 9230789           prod 9230789
✓ FRONTENDS MATCH    dev bc03b22dc375      prod bc03b22dc375
✓ THE VIEW MATCHES   2 divisions on each box
✓ THE RECEIVING PROC MATCHES — 1 qty column, 2 joins, each box. JR21.
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = bc03b22d   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = 9230789    ✓ PULLED TO BOTH BOXES
          docs     main = 20536b9   ✓ S110 CLOSE COMMITTED
          ⚠ RUN #56 (30b2ddd4) NO LONGER APPEARS IN THE FIRST PAGE OF THE
            ACTIONS LIST. Whether it was cleared or merely aged off is
            UNKNOWN — do not record it as gone.
            ▶ NEVER DEPLOY A dist-*-30b2ddd* ZIP. → J117.
          ⚠ THE DEFENCE IS UNCHANGED AND IT IS THE ONLY ONE THAT MATTERS:
            READ THE COMMIT STAMP IN THE ARTIFACT FILENAME. TYPE IT IN FULL.
            NEVER TAKE THE NEWEST BY POSITION.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-bc03b22dc375ba51bd81b18ffb4299b36aa34ab8
          prod  /home/ubuntu/www-html.bak-prod-bc03b22dc375ba51bd81b18ffb4299b36aa34ab8
          ⚠ EACH HOLDS THE BUILD IT REPLACED, NOT THE ONE IT IS NAMED
            AFTER. BOTH HOLD 0dad104d.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.
          ⚠ BACKEND ROLLBACK is `git reset --hard 51e9f4e` then restart.
            There is no build artifact for the backend.

          DATABASE BACKUPS on each box — ⚠⚠ KEEP ALL OF THESE:
            WhC_GetMoProductReceivingDetails_SP.bak-S110-{DEV,PROD}.txt
              ⚠⚠ CURRENT. 956 bytes · 2 joins · BYTE-IDENTICAL across boxes
            Trace_ProductHeaderView.bak-S109-{DEV,PROD}.txt  ⚠⚠ CURRENT
              6193 bytes · 3 slashes · 22 joins · BYTE-IDENTICAL
            WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt (+ .after-)
          ⚠ ALL ARE SHOW CREATE TEXT, NOT RUNNABLE. A restore needs the
            DELIMITER $$ wrapper added. → JR16.
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
                              MO-0001 1750# @0.32 Kg · MO-0002 802# @0.24 Kg
                              ⚠ batch_qty 240 and 400.
            469  HAGENSBORG   ⚠⚠ THIRTEEN MOs, NOT SEVEN. Re-measured S110.
                              None run. ZERO release rows. 24 MR rows, ALL
                              MATERIAL, ALL with mlc_id NULL. ZERO DOs.
                              ⚠⚠ batch_qty IS 1 ON EVERY ONE OF THE 13.
                                A 1:1 ratio. THEY CAN NEVER DEMONSTRATE A
                                QUANTITY FIX. → TRAPS 9.
                              ⚠ Their MOs carry NO intermediates.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
          ⚠ 464 test260703@ and 465 test260704b@ are SANDBOXES on prod.
            ▶ USE 464 FOR PROD SCREEN CHECKS.
          ⚠⚠ S110 CHECKED PROD THROUGH GLUTENULL'S OWN LOGIN, not a sandbox.
            Stronger evidence. Keep doing it where the figure is a client's.

⚠⚠ THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE.
  DEV 469 = test260710@.  PROD 469 = HAGENSBORG.
  Dev also carries 466 "Test Glutenul", which is NOT Glutenull.
  ▶ NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX. → P156
  ⚠ S110 LOST A QUERY TO THIS — read dev 471/469 believing it was the
    client exposure. Caught before it mattered. NAME THE BOX.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY BLOCK.
  ⚠⚠ FOUR WRONG-BOX COMMAND ATTEMPTS IN S110, ALL FAILED SAFELY — no mysql
    on the Mac, no ~/Downloads on prod, no backend repo on the Mac. ONE WROTE
    A 0-BYTE FILE NAMED LIKE A BACKUP. ▶ SAFE-BY-ENVIRONMENT IS NOT A
    CONTROL. See LESSONS.
```

---

## THE FIXTURES — ⚠ DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE INTERMEDIATE FIXTURE

```
IP-0.37      FO-0004   0.37 Kg/unit   batch_qty 19   inventory_units 47
             ⚠ 47, NOT 41. Moved S109: 41 + 13 received − 7 to DO-0002.
Parent-0.53  FO-0005   0.53 Kg/unit   batch_qty 13
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units
             ⚠ subrecipeformulation id 1044: qty 3.33 Kg, ship_qty 9 units.
               MEASURED S110. BOTH POPULATED AND CORRECT.

MO-0003  IP-0.37, 41 units, COMPLETE, lot Pdt-260807-1. ONE RECEIPT.
         ✓ Ginger Powder requirement now 15.170 Kg, matching what was
           received. THE BANKED OVER-RELEASE IS GONE. P162.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. IT IS THE BEFORE PICTURE FOR S111.
MO-0005  IP-0.37, 13 units, lot Pdt-260808-1, COMPLETE.
         ▶ TWO RECEIPTS: 5 units (1.850 Kg) and 8 units (2.960 Kg),
           receiveproducts ids 11450 and 11451, mlc_id 11813.
         ⚠⚠ BOTH ROWS CARRY THE SAME internalCode Rec-260809-1. The receipt
           code is NOT unique per receipt. They are told apart ONLY by
           quantity. → P172.
         ⚠⚠ WITHOUT THIS, ROW 31 COULD NOT HAVE BEEN PROVEN AT ALL.
MR-0009  Ginger Powder, 10 Kg, reason Sample. MATERIAL.
DO-0002  IP-0.37, 7 units typed, packing_units STORED AS 7. ROW 30's PROOF.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS. TRAPS 9.

THE PROOFS ON MO-0004 — ⚠ TWO OF THREE ARE NOW CLOSED:
  1  ✓ CLOSED S110. Plan Quantity 23.000# (2303.910 Kg) and the Ginger
     Powder requirement BOTH read 2303.910 Kg. The 0.301 Kg gap on one page
     is gone.
  2  ⚠ STILL OPEN. IP-0.37 required reads 5.892 Kg — Kg under a header
     saying "# (UOM)". TRUE FIGURE 9 × 23/13 = 15.923 UNITS. → S111 row 32.
     ⚠ 5.892, NOT 5.891 — the rounding half was fixed S110.
  3  ⚠ STILL OPEN. WH Stock in # (UOM) reads 17.390 Kg. The warehouse holds
     47 units. → S111 row 33.

⚠⚠ THE CONTROL — Pouch 4347.000 Ea = 23 × 9 × 7 × 3. IT DID NOT MOVE IN
  S110 AND MUST NOT MOVE IN S111. Carton 1449 · Case 207 · Pallet 23.
```

### COMPANY 464 · test260703 · on DEV — THE OLDER FIXTURES

```
FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007
  DISPATCH ORDERS IN ALL THREE BUCKET STATES:
    DO-0007 shipped · DO-0010, DO-0011 on packing slip · DO-0016 DO only
  ⚠ DO NOT DELETE DO-0016.
  ⚠ DO-0008 and DO-0009 carry packing_units 0.5 — THE FRACTIONAL FIXTURE.

⚠⚠ MO-0002 CARRIES **TWO** 2 Kg GINGER POWDER RETURNS. → P168's proof.
MO-0011  A 2 Kg GINGER POWDER RETURN. → P164's fixture.
  ⚠⚠ DO NOT CLEAR EITHER.

⚠ 464 IS A DIRTY BASELINE — MAT-6 missing its Sesame (S73), MAT-5 carrying
  Eggs (S78), FO-0005 fork residue (S77).
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
⚠⚠ THE FULL PICTURE IS IN UNITS-BIBLE.txt PART 1. What follows is only what
  the bible does not cover.

formulations.batch_qty  ⚠⚠ SHIPPING UNITS PER BATCH. MEASURED S110 AND IT IS
                     THE COLUMN THE LIVE REQUIREMENT NEEDS.
                     dev 474: FO-0004 = 19, FO-0005 = 13.
                     prod: Glutenull 240 and 400; Hagensborg 1 on all 13.
                     ▶ SERVED BY WhC_GetMoDetails_SP AS
                       `formula_id__batch_qty` — ⚠⚠ ALIASED, NOT BARE.
                       mlcDetails.batch_qty IS UNDEFINED. TRAPS 10's shape.

subrecipeformulation  qty (KG) · ship_qty (UNITS) · sub_recipe_id ·
                     formulation_id
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX. Measured
                       S110 — dev 15 rows, prod 10 rows, bad = 0.
                     ▶ S111 NEEDS NO HEAL. Measured, not assumed.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty` IN THE SCHEMA.
                     ⚠ internalCode IS NOT UNIQUE PER RECEIPT. → P172.

mprrecievelots       qty_allocated (KG) · MPR_id · Rec_Lot_id ·
                     material_id · Rec_Product_id · formula_id
                     ⚠⚠ TWO PARALLEL FK PAIRS ON ONE ROW, AND WHICH PAIR IS
                       POPULATED ENCODES THE RELEASE TYPE.
                       material_id + Rec_Lot_id     = MATERIAL
                       formula_id  + Rec_Product_id = PRODUCT
                     ⚠ NO UNIT COLUMN. → STEP 5.

returnmpreceivelots  ⚠⚠ AN EXACT TWIN OF THE ABOVE, column for column.
                     qty_return (KG) · ReturnMP_id · same four FKs.
                     ⚠ ONE ROW ON EACH BOX. Both material.

rejectmaterialandproduct  qty_rejected (KG) · qty_rejected_units
                     ⚠ `type` returns 'Product' or 'Material' AS WORDS.
                     ⚠ `status` returns 'Active', NOT a number.
                     ⚠⚠ MATERIAL MRs CARRY NO mlc_id. PRODUCT MRs ALWAYS DO.
                     ⚠⚠ EVERY PRE-S103 ROW HOLDS qty_rejected_units 0. → P170.

rejectedmaterial · rejectedproduct
                     ⚠ EMPTY ON BOTH BOXES. Pre-merge design. → P109.

⚠ ROW COUNTS, MEASURED S109:
                          DEV   PROD
    do_receive_products     28      9
    mlodetails              91    129   ⚠ LIVE CLIENT DATA, NO MAP ROW
    forecastsales            0      0   ▶ EMPTY BOTH BOXES. UNBUILT.
  → P171 for the first two.

company              company_name  ← NOT `name`
fopackaging          formulation_id ← NOT `formula_id`
                     ⚠ mlomanagement uses formula_id. TWO SPELLINGS.
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE VIEW <name>\G"

WhC_GetMoProductReceivingDetails_SP  ✓ SERVES receiveproducts.qty. JR21.
  956 → 986 bytes. 2 joins, unchanged. Definer stripped.
  ⚠ It STILL selects fopackaging.wgt_kgs_per_unit. Left deliberately —
    minimum change, and removing it alters the row shape for no benefit.

Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20.
  ▶ intermediate_prd_su and SOH_su. BOTH BLOCKED ON STEP 5's SCHEMA.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE. The do_products CTE defines its own
    alias `qty_shipped` summing do.qty_to_ship — KG. The real column is
    UNITS. RESOLVE EVERY NAME TO ITS DEFINITION.
  ⚠ P136: it returns DUPLICATE ROWS. Pre-existing.
  ⚠ ONE CONSUMER: product-traceability-details.component.ts.

WhC_GetMoIntermediateProducts_SP   ⚠ READ IN FULL S109. → S111.
  ▶ NEEDS subrecipeformulation.ship_qty AS subrecipeformulation_ship_qty.
  ⚠ IT ALIASES EVERYTHING. A frontend build rides with the change.
  ⚠ CALLER: MLOManagement.js:393. The :621 copy is COMMENTED OUT.

WhC_GetFormulaIntermediateProducts ⚠ READ IN FULL S109. → S111.
  ▶ NEEDS formulations.inventory_units. NO NEW JOIN, NO ALIAS NEEDED.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. 3b returns
    `formulations_inventory`; 3c returns `inventory`.
  ⚠ CALLER: Formulations.js:1083, inside getFormulaByIdForReleaseMaterial
    at :1079 — ⚠⚠ THE SAME FUNCTION THAT BUILDS BATCH MATERIALS.

WhC_GetMoDetails_SP  ✓ SERVES formula_id__batch_qty. Measured S110 by
  CALLING it, not by reading SHOW CREATE. ⚠ THE ALIAS IS THE POINT.

Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT.
  Divides qty_allocated, AND joins fopackaging with NO whd_flag filter.
  ✓ ITS SIBLING CARRIES THE FILTER, WITH A COMMENT. Copy it.

MLOManagement.js  ⚠⚠ THE ENDPOINT NAME LIES. Route `mlo/getMLCbyId` reaches
  the controller at :38, which calls **getMLCbyIdV3**. → P115.

⚠ db-definitions-S93.txt IS STALE ON SIX OBJECTS NOW. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 9230789 on both boxes.
FRONTEND   ✓ NOTHING PENDING. bc03b22d on both boxes.
DATABASE   ✓ NOTHING PENDING. JR21 applied to both boxes.
DOCS       ⚠ S110's OUTPUT PENDING COMMIT:
             NOW.md                         this file
             PLAN.md
             UNITS-BIBLE.txt + .xlsx        ⚠ SEE THE NOTE IN PLAN
             Section_5.md                   J120 + JR21 TO MERGE, and
                                              CORRECT ITS OWN HEADER to
                                              J120 / JR21 / S110.
```

---

## QUEUE
⚠ New items at the bottom with the next free number. Claude never renumbers.
Ranking is Minty's.

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
P102  ⚠⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠⚠ PROD NOW 46 UPDATES, WAS 28 AT S109. Dev 8.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
      ⚠⚠ SIXTEEN DAYS RUNNING. TWO CLIENTS ON PROD.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠⚠ MINTY'S RULING S110: IT STARTS AFTER THE UNITS CAMPAIGN CLOSES,
        NOT IN PARALLEL. THE REASON IS COMMERCIAL — the clients are new and
        carry almost no data, so schema and anchor changes are cheap NOW and
        get harder as they build history. ▶ FINISH THE BIBLE FIRST.
      ⚠ FOUR THINGS WILL MEET IT: TRAPS 3 · J97's multiple invoices · P138 ·
        P137.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ✓ edit-mlc getWdu DELETED S110 — html:258 was its only live caller.
      ⚠ STILL OPEN:
        rejected-materials.component.ts:152-154 getShippingUnits — NO CALLER
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
        PopUps/add-dispatch (v1) — whole component, never opened
        edit-mlc.component.ts:311 lotReceived consumer — commented out
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A FOURTH TIME IN S110 — the S42 comment beside
        getPlannedKg, and line 1195's own shape, showed the correct pattern
        twice without anyone deriving it.
P119  Back up the database's own code into the repo. ⚠ STALE ON SIX.
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
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. STEP 5.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
      ⚠⚠ DO NOT "FIX" THESE LINES.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE COMMENTED OUT.
      ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. ⚠ ASK MINTY. LOW.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P151  ✓ CLOSED S110. THE YIELD DIALOG (S107), :298 completeUnit (S109) AND
      html:258 + getWdu (S110). ALL THREE SITES DONE.
      ⚠ DELETE THIS LINE AT THE S111 CLOSE.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      ▶ FIX IT OR WARN IN ITS OWN OUTPUT. ⚠ IT CORRUPTS EVIDENCE.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. ⚠ ASK MINTY. LOW.
P155  A Mac push does not update prod's origin until something fetches.
      ✓ HELD IN S110 — `git fetch origin` first, then the pull, then HEAD
        read BEFORE the restart. All three steps earned their place.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT SHARE
      A COMPANY-ID NAMESPACE.
      ⚠ RE-MEASURED S110: HAGENSBORG HAS 13 MOs, NOT 7. The record was
        stale by six. ▶ actions unchanged: correct 3B, re-scope P100.
P157  ✓ CLOSED S110. WhC_GetMoProductReceivingDetails_SP now serves
      receiveproducts.qty on both boxes. JR21.
      ⚠ DELETE THIS LINE AT THE S111 CLOSE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins fopackaging
      with NO whd_flag filter. ▶ STEP 5. MEDIUM.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. ▶ STEP 5.
P160  ⚠ THE TWO INTERMEDIATE PROCEDURES SERVE Kg ONLY.
      ✓ BOTH READ IN FULL S109. Neither needs a new join.
      ▶ S111. HIGH — IT IS NOW THE WHOLE OF THE NEXT SESSION.
P161  ✓ CLOSED S109. Residual is P171.
P162  ✓ CLOSED S110 — THE ROUNDING HALF, ON BOTH BOXES.
      Both final_qty lines and three frontend templates now compute
      MO units ÷ batch_qty live. The stored `batches` column is READ BY
      NOTHING that calculates.
      ⚠⚠ THE BASIS HALF IS NOT CLOSED. The intermediate requirement still
        reads subrecipeformulation.qty (Kg) where RULES 7 says ship_qty.
        ▶ THAT IS S111, ROWS 32 / 34 / 36.
      ✓ MINTY'S RULING S110: the number change is ACCEPTED. Past MOs show a
        requirement differing slightly from what was released; THE RELEASE
        ROWS STAND as the record of what physically happened (S106 ruling).
      ✓ RULES 7 NEEDED NO REWRITE — the S108 version already states the
        live calculation. PLAN's "RULES 7 MUST BE REWRITTEN" was satisfied
        before S110 opened. ⚠ DO NOT RE-RAISE IT.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. PROVEN ON DEV.
      ▶ THE PATH HAS NEVER RUN BECAUSE IT CANNOT BE RUN. ▶ STEP 6.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL.
      ▶ THE SIGN IS INVERTED. ⚠ LIVE ON BOTH CLIENTS.
      ⚠ SEEN AGAIN IN S110 while reading :1108 — `returnSum` is declared and
        never assigned, and the return loop adds to `sum`. NOT TOUCHED.
      ⚠ ACCEPTED RISK, MINTY'S CALL, MADE KNOWINGLY. ▶ STEP 6.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ STEP 6. MEDIUM.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
      ▶ REVIEW, not a confirmed defect. LOW.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. mfg-lot-codes.ts:124-131 getWdu
      DIVIDES WHATEVER IT IS HANDED. ⚠ BIBLE ROW 25 IS ONE OF THE SEVEN.
      ▶ OWN SITTING. Read all seven callers, decide each, then edit.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. A second return MOVES
      STOCK, IS WRITTEN TO THE DATABASE, AND NEVER APPEARS on the MO.
      ⚠⚠ A MATERIAL MOVEMENT WITH NO TRACE ON THE MANUFACTURING ORDER IS A
        TRACEABILITY GAP, IN A TRACEABILITY SYSTEM.
      ⚠ THE CODE HAS NOT BEEN READ. ▶ STEP 6. HIGH, SURVEYED FIRST.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ BIBLE ROW 48. LOW.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. THE TRADE JR20 MADE
      KNOWINGLY. ✓ NO CLIENT ROW AFFECTED.
      ⚠⚠ THE DECISION IS WHETHER TO HEAL, AND HEALING MEANS DIVIDING Kg.
      ▶ MINTY'S CALL. ⚠ CHEAPER NOW THAN LATER — see P111's ruling.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
      mlodetails.rcp_qty — 91 dev, ⚠ 129 ON PROD, LIVE CLIENT DATA
      do_receive_products.qty_to_dispatch — 28 dev, 9 prod
      ▶ Survey work, not campaign work.
```

### NEW IN S110

```
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT.
      474 MO-0005's two receipts BOTH carry Rec-260809-1. On the receiving
      panel they are distinguishable ONLY by quantity and timestamp.
      ⚠ NOT A DEFECT IN THE UNIT FIGURES — row 31 is proven correct. It is a
        readability question on a client-facing panel.
      ▶ ASK MINTY WHETHER A RECEIPT NEEDS ITS OWN CODE. LOW.

P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW when a
      product has no intermediates. Seen on dev 474 MO-0005 and on prod
      Glutenull MO-0001 and MO-0002.
      ⚠ DISPLAY ONLY. An empty block would be correct. LOW.

P174  ⚠ edit-mlc.component.ts:372 WRITES BACK INTO mlcDetails:
        this.mlcDetails.batches = this.mlcFormdetails.controls.batches.value
      An operator-editable value overwrites a derived, stored figure on the
      object the screen reads.
      ⚠ HARMLESS TO S110's FIX — getFactor reads qty and batch_qty, not
        batches. ⚠ NOT INVESTIGATED. ▶ READ WHAT ELSE CONSUMES IT. MEDIUM.

P175  ⚠ getFormulaByIdForReleaseMaterial :1092 reads
        `if (typeof req.body.mlc_id != undefined)`
      `typeof` returns a STRING, so the gate is ALWAYS TRUE. A gate that
      cannot fail is not a gate. ⚠ Harmless today. LOW.

P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` IS NOT
      INSTALLED ON DEV — S110 extracted with a python3 one-liner instead.
      JR14 records deploy-frontend.sh but not the extraction step, and
      deploy-frontend.sh takes a DIRECTORY, not a zip.
      ⚠ HOW S109's BUILD WAS EXTRACTED IS UNKNOWN. A step nobody wrote down
        is a step that gets improvised. ▶ RECORD IT IN 3B.4. MEDIUM.
```

### ✓ CLOSED IN S110 — DELETE THESE LINES AT S111 CLOSE

```
P151  ✓ ALL THREE SITES DONE.
P157  ✓ THE PROC SERVES receiveproducts.qty ON BOTH BOXES.
P147 · P161   ✓ closed in S109, still listed.
P104 · P150   ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    ~/Trace_ProductHeaderView-S107-DEV*.txt              delete
       ~/Trace_ProductHeaderView.bak-S107-DEV.txt           delete, stale
       ~/Trace_ProductHeaderView.bak-S109-DEV.txt           ⚠⚠ KEEP
       ~/WhC_GetMoProductReceivingDetails_SP.bak-S110-DEV.txt ⚠⚠ KEEP
       ~/fix-recv-S110.sql                                  keep this session
       ~/fix-header-view-S109.sql                           delete
       ~/fix-modetails-S106.sql                             delete
       ~/MLOManagement.js.bak-S105-P140                     delete
       ~/WhC_GetMoDetails_SP.*-S106-DEV.txt                 KEEP BOTH
       ~/dist-dev-0dad104d*.zip AND ITS UNZIPPED FOLDER     delete
       ~/dist-dev-bc03b22d*.zip AND ITS UNZIPPED FOLDER     keep, live
       ~/www-html.bak-dev-f4c98e91cd64                      delete
       ~/www-html.bak-dev-0dad104d*                         delete
       ~/www-html.bak-dev-bc03b22d*                         ⚠⚠ KEEP — LIVE
                                                             ROLLBACK
PROD   ~/Trace_ProductHeaderView.bak-S107-PROD.txt          delete, stale
       ~/Trace_ProductHeaderView.bak-S109-PROD.txt          ⚠⚠ KEEP
       ~/WhC_GetMoProductReceivingDetails_SP.bak-S110-PROD.txt ⚠⚠ KEEP
       ~/fix-recv-S110-PROD.sql                             keep this session
       ~/fix-header-view-S109-PROD.sql                      delete
       ~/fix-modetails-S106.sql                             delete
       ~/WhC_GetMoDetails_SP.*-S106-PROD.txt                KEEP BOTH
       ~/dist-prod-0dad104d*.zip AND ITS UNZIPPED FOLDER    delete
       ~/dist-prod-bc03b22d*.zip AND ITS UNZIPPED FOLDER    keep, live
       ~/www-html.bak-prod-f4c98e91cd64                     delete
       ~/www-html.bak-prod-0dad104d*                        delete
       ~/www-html.bak-prod-bc03b22d*                        ⚠⚠ KEEP — LIVE
                                                             ROLLBACK
MAC    ~/Downloads — SIX dist zips. Keep the bc03b22d PAIR. Delete the
       f4c98e91 pair and the 0dad104d pair.
       ⚠ Also the S109 leftovers: QUANTITY-SURVEY-S108.md, RULES-7-DRAFT.md,
         Section_5_S109_append.md — ⚠ CONFIRM THE S109 APPEND WAS MERGED
         BEFORE DELETING IT.
       ⚠⚠ VERIFY BY STAMP, NEVER BY BRACKET NUMBER OR POSITION. → S109's
         lesson: the newest file did not have the plainest name.

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106, S109 OR S110 .bak FILES. They are the only
  rollback for database objects on a LIVE CLIENT DATABASE.
```
