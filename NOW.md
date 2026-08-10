# NOW

Last rewritten: S113, 10 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S113 SHIPPED TWO THINGS. BOTH ON BOTH BOXES.
  PROCEDURE  Trace_MaterialDetails_SP — gains mlomanagement.received_units
             in THREE places. JR23. Each box from its own backup.
  e1a82e02   material traceability MO rows read stored counts, frontend
  ▶ NOTHING IS PENDING PROMOTION. Application stack and database in step.
  ⚠ THE ONE DIVERGENCE REMAINS mprrecievelots.qty_allocated_units — DEV
    ONLY, DELIBERATELY. It lands on prod with the write path in S114.

⚠⚠ THE BOARD: 38 GREEN · 10 RED · 3 REVIEW, of 51. BALANCE 13.
  ▶ ROWS 45 AND 51 CLOSED. ⚠⚠ ROW 45 WAS THE ONLY WRONG NUMBER IN THE
    QUEUE. Everything still open is a RIGHT number reached by a WRONG
    route.
  ▶ 48 IS THE CEILING.
  ✓ FIRST SESSION OF THIS CAMPAIGN TO CORRECT A FIGURE A CLIENT COULD
    HAVE READ WRONGLY. Every previous fix was invisible on prod by
    design. Glutenull's MO rows read "1750 Kg (1750#)" this morning.

⚠⚠ WHAT S113 PROVED ABOUT THE PLAN ITSELF — READ BEFORE TRUSTING A ROW.
  PLAN AND THE BIBLE BOTH NAMED FOUR FIX SITES. ALL FOUR WERE DEAD.
    :123 :124   inside a commented-out <tr> block
    :215 :216   a live mat-card iterating newList — AND NOTHING EVER
                ASSIGNS newList. Every write to it is commented out.
  AND THE LINE BOTH DOCUMENTS SAID TO LEAVE ALONE — :107/:108 — WAS THE
  DEFECT. It renders the MO row and it printed "10 Kg (1#)".
  ▶ PATCHING BY THE DOCUMENT WOULD HAVE BUILT CLEAN, DEPLOYED CLEAN AND
    CHANGED NOTHING. J117's shape, and the addresses have been corrected
    in the bible in this same close.

---

## STATE
⚠ READ OFF BOTH BOXES AT S113 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺263 · 200 · 162.9mb
          frontend SERVING dev-e1a82e028903ec317399de1bf2dc8be14a2f1030
          frontend checkout c2a52d8e — ⚠⚠ STALE BY EIGHTEEN SESSIONS.
            HARMLESS UNTIL SOMEBODY READS IT AS LIVE CODE. It happened
            in S112. → LESSONS.
          backend HEAD 4d43bd4 · both repos clean
          ⚠ NO BACKEND COMMIT IN S113.
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 UPDATES PENDING · restart required
          ✓ pm2-ubuntu systemd unit INSTALLED AND ENABLED, S112.

PROD      15.157.38.101 · pm2 abletrace-backend ↺343 · 200 · 157.3mb
          TWO LIVE CLIENTS · SERVING prod-e1a82e028903ec317399de1bf2dc8be14a2f1030
          backend HEAD 4d43bd4 · repo clean
          ⚠ frontend checkout is not read at this path — P8, by design.
            THE ROLLBACK LABEL IS THE ONLY RELIABLE READ OF WHAT IS LIVE.
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING · restart required. NINETEEN DAYS. → P102
          ✓ pm2-ubuntu ENABLED — measured S112.
```

```
✓ BACKENDS MATCH     dev 4d43bd4          prod 4d43bd4
✓ FRONTENDS MATCH    dev e1a82e02...      prod e1a82e02...
⚠⚠ DATABASES DIVERGE BY ONE COLUMN, DELIBERATELY.
   mprrecievelots.qty_allocated_units EXISTS ON DEV, NOT ON PROD.
   ✓ RE-VERIFIED AT THE S113 OPEN — one row on dev, EMPTY SET on prod.
   ▶ THE MODEL DECLARES IT ON BOTH. Harmless.
   ▶ THE PROD ALTER IS S114's, and it lands with the write path.
✓ Trace_MaterialDetails_SP  MATCHES — 3 received_units, 10 joins (JR23)
✓ BOTH INTERMEDIATE PROCEDURES MATCH — 3 joins, both new columns. JR22.
✓ THE HEADER VIEW    2 divisions each box (JR20)
✓ THE RECEIVING PROC 1 qty column, 2 joins (JR21)
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = e1a82e02   ✓ BUILT AND DEPLOYED BOTH BOXES
                                     ⚠ dev by push, prod by MANUAL DISPATCH
          backend  main = 4d43bd4    ✓ unchanged this session
          docs     main = f7fad0b
            ⚠ RULES 6 — do not carry a number forward, read it.
          ⚠⚠ TWELVE dist ZIPS IN CIRCULATION, TEN SUPERSEDED. Every one is
            green and real. → the tidy list.
          ▶ THE DEFENCE IS THE STAMP AND NOTHING ELSE. TYPE IT IN FULL.
            NEVER TAKE THE NEWEST BY POSITION. → J117.
          ⚠ BUILD ANNOTATION ON EVERY RUN: Node.js 20 deprecated, forced
            onto Node.js 24. Builds succeed. → P180.
          ⚠ THE PROD ARTIFACT IS 9.07 MB, THE DEV ONE 14.4 MB. Prod builds
            without source maps. NOT A DEFECT — record it so nobody reads
            the size difference as a truncated download.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-e1a82e028903ec317399de1bf2dc8be14a2f1030
          prod  /home/ubuntu/www-html.bak-prod-e1a82e028903ec317399de1bf2dc8be14a2f1030
          ⚠ EACH HOLDS THE BUILD IT REPLACED — BOTH HOLD 2968c591.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.
          ⚠ BACKEND ROLLBACK is `git reset --hard fc78ce1` then restart.

          DATABASE BACKUPS — ⚠⚠ KEEP ALL OF THESE:
            BOTH Trace_MaterialDetails_SP.bak-S113-{DEV,PROD}.txt
                 ⚠ 4675 bytes, 2 CREATE, 10 joins, 0 slashes — BYTE-
                   IDENTICAL ACROSS THE BOXES BEFORE THE CHANGE.
            DEV  mprrecievelots-before-S112-DEV.sql  ⚠⚠ THE ONLY COLUMN
                 ROLLBACK.
            BOTH WhC_GetMoIntermediateProducts_SP.bak-S111-{DEV,PROD}.txt
                 WhC_GetFormulaIntermediateProducts.bak-S111-{DEV,PROD}.txt
                 WhC_GetMoProductReceivingDetails_SP.bak-S110-{DEV,PROD}.txt
                 Trace_ProductHeaderView.bak-S109-{DEV,PROD}.txt
                 WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt
          ⚠ ALL SHOW CREATE TEXT ARE NOT RUNNABLE. A restore needs the
            DELIMITER $$ wrapper. → JR16.
```

```
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3 · prod i-0b54ae374250348e0 · t3.small
```

```
COMPANIES ⚠⚠ TWO LIVE CLIENTS ON PROD.
            471  GLUTENULL1   2 MOs, both complete. 26 release rows.
                              batch_qty 240 and 400. NO INTERMEDIATES.
                              ⚠ 0.32 and 0.24 Kg per unit — ROUND RATIOS.
            469  HAGENSBORG   13 MOs, none run. ZERO release rows.
                              ⚠⚠ batch_qty 1 ON ALL 13. TRAPS 9, permanently.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
          ⚠ SANDBOXES ON PROD: 464 test260703@ and 465 test260704b@.
            ⚠⚠ 465 IS THE ONE WITH PRODUCT-SIDE ALLOCATION HISTORY.
              ▶ USE 465, NOT 464, TO EXERCISE THE RELEASE PATH ON PROD.
          ⚠⚠ THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE. → P156

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each.
          ⚠⚠ THE ARCHIVE HOLDS ITS OWN COPIES OF THE STORED PROCEDURES.
            → P101, and NAME THE SCHEMA in every information_schema
            query or every routine returns twice. → P134.
```

## THE ROLES AND WHO OWNS WHICH SCREEN

```
  SALES CONTROLLER       CREATES the MO      /MLO-Management → /Edit-MLO
  WAREHOUSE CONTROLLER   RELEASES · RECEIVES · yield · returns
                                             /Mfg-lot-codes → /Edit-Mlc
  PRODUCTION CONTROLLER  STARTS production · RELEASES the lot code
                                             /Start-mlc

⚠ THE ROUTE NAMES LIE ABOUT THE TASK. There is no "edit MO" operation.
✓ ALL THREE INTERMEDIATE-BLOCK TEMPLATES ARE NOW SCREEN-PROVEN.
  start-mlc WAS OPENED IN S113 ON 474 MO-0011 — P181 CLOSED after four
  patches across two sessions with no screen check.
⚠ THREE MORE INTERMEDIATE CONTROLS EXIST AND ARE IN NO DOCUMENT:
    edit-mlc.component.html:223 · edit-mlo.component.html:319 ·
    edit-closed-mlcs.component.html:77 — all <mat-label>. → P182.
```

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ `hostname` AND `git log --oneline -1` AT THE TOP OF EVERY MAC BLOCK.
    ⚠⚠ THE FRONTEND REPO EXISTS ON BOTH MACHINES AT THE SAME PATH, AND
      DEV'S COPY IS EIGHTEEN SESSIONS STALE.

---

## THE FIXTURES — ⚠ DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE PROVING GROUND

```
IP-0.37      FO-0004  0.37 Kg/unit  batch_qty 19  inventory_units 47
Parent-0.53  FO-0005  0.53 Kg/unit  batch_qty 13
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units

MO-0003  IP-0.37, 41 units, COMPLETE. ONE RECEIPT.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. STILL THE BEFORE PICTURE.
MO-0005  IP-0.37, 13 units, TWO RECEIPTS of 5 and 8.
MO-0006  ⚠⚠ Parent-0.53, 7 pallets, CREATED, NOT RELEASED.
         ▶ THIS IS S114's WRITE-PATH FIXTURE. It exists so MO-0004 does
           not have to be spent. ⚠⚠ IT WAS NOT SPENT IN S113 — Minty
           asked and the answer was no; MO-0011 served the screen check
           instead, at no cost.
         ⚠ 7 ÷ 13 = 0.538461... — deliberately not a multiple of 13.
         ▶ ITS FIGURES, RE-PROVEN ON SCREEN S113 (start-mlc AND edit-mlc):
             IP-0.37 required   4.846# (1.793 Kg)
             IP-0.37 WH Stock  47.000# (17.390 Kg)
             Ginger Powder    701.190 Kg  ·  Pouch 1323 · Carton 441 ·
             Case 63 · Pallet 7
         ⚠ RELEASING IT WILL CONSUME 4.846 UNITS, leaving 42.154.
MR-0009  Ginger Powder, 10 Kg, reason Sample. MATERIAL.
DO-0002  IP-0.37, 7 units typed, packing_units STORED AS 7.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS. TRAPS 9.
```

### COMPANY 474 — THE IP2 / P2 / IP3 SET · ⚠ BUILT BY MINTY, S112

```
IP2   FO-0006-2  Salt 10 Kg/batch · 1 unit/batch · 10 Kg per unit
      MO-0007 ran under IP2 VERSION 1 at 1 Kg/unit — 100# (100 Kg).
      MO-0010 ran under VERSION 2 at 10 Kg/unit — 10# (100 Kg).
P2    FO-0007-2  Ginger 20 Kg + IP2 2# · 2 units/batch
      Pouch 5 Kg → Case = 4 Pouch = 20 Kg per case
      MO-0011 made 7# (140 Kg), batches 3.5.
IP3   FO-0008   MO-0012 made 10# (100 Kg). ⚠⚠ FOUND IN S113 BY CALLING
      THE PROCEDURE — it renders on the same screen as MO-0010 and
      carried the same defect. IT WAS IN NO DOCUMENT.
Salt  MAT-8, material id 8126. Receive lot 11222. ⚠ THE ONLY SALT LOT.
      10000 Kg received · 300 released · 9700 SOH.

⚠⚠ EVERY RATIO IS ROUND. A DIVISION AND A STORED READ PRODUCE IDENTICAL
  NUMBERS. ▶ USEFUL FOR SEEING THE FLOW, USELESS FOR PROVING A FIX.
⚠⚠ MO-0007 AT 1 Kg/unit IS TRAPS 9 IN ITS PUREST FORM — qty 100,
  received_qty 100, received_units 100, ALL THREE IDENTICAL. It CANNOT
  MOVE whatever the code does. THAT IS WHY IT IS THE CONTROL: it proves
  history was not re-cast, and proves nothing about the fix.
⚠⚠ MO-0007's ROW IS CORRECT AND MUST NOT BE "FIXED". Traceability
  reports what was released AT THE TIME. ▶ MINTY'S RULING, S112.
```

### COMPANY 464 · test260703 · on DEV — THE OLDER FIXTURES

```
FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007
  DOs in all three bucket states. ⚠ DO NOT DELETE DO-0016.
  ⚠ DO-0008 and DO-0009 carry packing_units 0.5 — THE FRACTIONAL FIXTURE.
⚠⚠ MO-0002 CARRIES **TWO** 2 Kg GINGER POWDER RETURNS. → P168's proof.
MO-0011  A 2 Kg GINGER POWDER RETURN. → P164's fixture.
  ⚠⚠ DO NOT CLEAR EITHER.
⚠ 464 IS A DIRTY BASELINE — MAT-6 missing Sesame, MAT-5 carrying Eggs,
  FO-0005 fork residue.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
⚠⚠ THE FULL PICTURE IS IN UNITS-BIBLE.txt PART 1.

mprrecievelots       qty_allocated (KG) · qty_allocated_units (⚠ DEV ONLY)
                     MPR_id · Rec_Lot_id · material_id · Rec_Product_id ·
                     formula_id
                     ⚠⚠ TWO PARALLEL FK PAIRS, AND WHICH IS POPULATED
                       ENCODES THE RELEASE TYPE:
                         material_id + Rec_Lot_id     = MATERIAL
                         formula_id  + Rec_Product_id = PRODUCT
                     ✓ MEASURED S112 — dev 113 rows: 99 material, 14
                       product. prod 68: 63 and 5. NO ORPHANS.
                     ✓✓ qty_allocated IS SUMMED AS Kg IN ALL SIX READ
                       SITES AND LEFT AS Kg. READ IN FULL, S113:
                         Formulations.js :1103 :1136 :1188
                         MLOManagement.js :1097 :1102 :1107
                       Every one is `sum = sum + qty_allocated`. NO
                       DIVISION, no wgt_kgs_per_unit, no unit count
                       reconstructed. ▶ S114 DOES NOT TOUCH THEM, so
                       long as qty_allocated STAYS KILOGRAMS.
                     ⚠ THIS WAS A DOCUMENT CLAIM UNTIL S113. IT IS NOW
                       A MEASUREMENT.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG) ·
                     prev_received_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty`.
                     ⚠⚠ prev_received_qty IS Kg, WHICH IS WHY THE
                       UNITS-REMAINING FIGURE HAS TO BE BUILT RATHER
                       THAN READ. → S114.

mlomanagement        qty (UNITS since S41) · received_qty (KG) ·
                     received_units (UNITS)
                     ⚠⚠ qty AND received_qty SIT SIDE BY SIDE IN OPPOSITE
                       BASES. That is what broke material traceability
                       for two years — half the row kept working.

subrecipeformulation qty (KG) · ship_qty (UNITS)
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX.

formulations         inventory (KG) · inventory_units (UNITS) · batch_qty
                     ⚠ batch_qty IS SHIPPING UNITS PER BATCH, served by
                       WhC_GetMoDetails_SP ALIASED as formula_id__batch_qty.

company              company_name  ← NOT `name`
fopackaging          formulation_id ← NOT `formula_id`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
Trace_MaterialDetails_SP  ✓ JR23, BOTH BOXES. NEW IN S113.
  ▶ SERVES mlomanagement.received_units. Three insertion points: the temp
    table CREATE, the INSERT column list, and the SELECT that feeds it.
  ✓ THE FINAL SELECT IS `temp_table.*` — so a column added to the temp
    table reaches the caller automatically. NOTHING TO ADD AT THE OUTPUT.
  ⚠⚠ EVERY temp_table COLUMN IS VARCHAR(100). qty AND received_qty ARRIVE
    AT THE FRONTEND AS STRINGS. Multiplication coerces; ADDITION WOULD
    CONCATENATE. Number() is not optional in that component.
  ⚠ IT HAS ZERO SLASHES AND ALWAYS DID. The slash count is NOT a usable
    gate for this object — the join count (10) is.
  ⚠ @returnedQty AND @mprIDs ARE COMPUTED AND NEVER USED. → P115.
  ⚠ The final SELECT drives FROM temp_qty_allocated left join temp_table
    with no aggregation — two allocations on one lot would render the MO
    twice. P136's shape, NOT INVESTIGATED.

WhC_GetMoIntermediateProducts_SP   ✓ JR22, BOTH BOXES.
  ▶ SERVES subrecipeformulation_ship_qty AND formulations_inventory_units.
  ⚠⚠ IT ALIASES EVERYTHING. ▶ FEEDS THE INTERMEDIATE PRODUCTS BLOCK.
WhC_GetFormulaIntermediateProducts ✓ JR22, BOTH BOXES.
  ▶ SERVES bare ship_qty AND bare inventory_units.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. undefined, SILENTLY.
  ▶ FEEDS matList / formulaList / packList — THE BATCH MATERIALS BLOCK.

Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20, and → S115.
  ▶ intermediate_prd_su and SOH_su. ⚠ SOH_su IS DEPENDENT on the other.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE.
Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS. → S115.
Trace_ProductOneStepForwardIP_SP · ...ReleaseDetails_SP  → S115.
WhC_GetMoProductReceivingDetails_SP  ✓ receiveproducts.qty. JR21.
WhC_GetMoDetails_SP  ✓ formula_id__batch_qty. ⚠ THE ALIAS IS THE POINT.

⚠ db-definitions-S93.txt IS STALE ON NINE OBJECTS. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 4d43bd4 on both boxes.
FRONTEND   ✓ NOTHING PENDING. e1a82e02 on both boxes.
DATABASE   ✓ Trace_MaterialDetails_SP ON BOTH BOXES.
           ⚠⚠ THE COLUMN ALTER IS DEV-ONLY AND THAT IS DELIBERATE.
             It lands on prod with the write path in S114.
             ▶ THIS IS NOT A PENDING PROMOTION. It is a sequenced gate.
DOCS       ⚠ S113's OUTPUT PENDING COMMIT:
             NOW.md · PLAN.md · UNITS-BIBLE.txt + .xlsx
             Section_5.md — J123 and JR23 to merge.
           ⚠⚠ WRITE THE GITHUB DOCS LINE FROM GITHUB AFTER THE PUSH.
```

---

## ⚠⚠ RULINGS MADE IN S113 — RECORDED, NOT PENDING

```
1  ✓✓ UNITS-BIBLE PART 1 MAY NOW BE EDITED BY CLAUDE, ON MINTY'S EXPRESS
   PERMISSION SOUGHT EACH TIME. The default answer is still NO. This
   AMENDS the standing rule that Claude never edits Part 1.
   ▶ THE TWO S112 RULINGS WERE WRITTEN INTO PART 1 AT THIS CLOSE, as
     sections 5 and 6, with Minty approving the exact wording first.
2  ✓ THE MATERIAL TRACEABILITY MO ROW TAKES UNITS. It carries a
   formula_id, therefore it is a PRODUCT row, therefore units# (Kg uom).
   ▶ Minty's own discriminator, applied.
3  ✓ THE DEAD MARKUP IS LOGGED, NOT DELETED. Deleting in the same commit
   as a fix makes a large diff where a small one would do, and if
   something regresses nobody can tell which half caused it. → P115.
4  ✓ THE PROCEDURE WENT TO PROD IN-SESSION, before the frontend was
   screen-proven. Additive, no deployed code read the new column, and
   the method and anchors were fresh. ▶ S112's lesson 10, applied.
5  ✓ MO-0006 WAS NOT SPENT. MO-0011 — released, received, complete —
   served the start-mlc screen check at no cost.
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
      ⚠ SEEN AGAIN S113 — every IP-0.37 row renders "FO-0004 null".
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.  P85  Windows printer guide.
P86   Cold boot blindness. ⚠ Both boxes now have a pm2 unit. Untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive, AND IT HOLDS ITS
      OWN COPIES OF THE STORED PROCEDURES. → record in 3B.
P102  ⚠⚠ SECURITY. Both boxes report *** System restart required ***.
      ✓ UNBLOCKED S112 — both boxes have an enabled pm2 unit.
      ⚠ dev 12 updates. prod 46. ⚠⚠ NINETEEN DAYS. TWO CLIENTS ON PROD.
      ▶ OWN JOB, OWN GATE.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠⚠ AFTER THE UNITS CAMPAIGN CLOSES. Minty's ruling S110.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ STILL OPEN:
        rejected-materials.component.ts:152-154 getShippingUnits — NO CALLER
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
        PopUps/add-dispatch (v1) — whole component, never opened
        edit-mlc.component.ts:311 lotReceived consumer — commented out
        edit-mlc.component.ts:227 formulaList.push(data3) — commented out
        MaterialsProductsReleased.js:52 createReleaseMaterialProducts
      ⚠⚠ NEW S113, ALL IN material-traceability-details:
        html:113-125  a whole commented-out <tr> block
        html:191-216  a LIVE mat-card iterating newList — and every
                      write to newList in the .ts is commented out, so
                      it can never render. ⚠⚠ THE MORE DANGEROUS OF THE
                      TWO: it LOOKS live and PLAN sent us to patch it.
        Traceability.js — @returnedQty and @mprIDs inside
                      Trace_MaterialDetails_SP, computed, never used.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A SEVENTH TIME IN S113 — the S110/S111/S112
        comments above :1156 made the basis question obvious again, and
        S113 added one explaining why qty is not divided.
P119  Back up the database's own code into the repo. ⚠ STALE ON NINE.
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
      ⚠⚠ NAME THE SCHEMA in every information_schema query too.
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. → S115.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
      ⚠ THE SAME SHAPE EXISTS IN Trace_MaterialDetails_SP's final SELECT.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE COMMENTED OUT.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE. ⚠ ASK MINTY.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. LOW.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. LOW.
P155  A Mac push does not update prod's origin until something fetches.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT
      SHARE A COMPANY-ID NAMESPACE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins
      fopackaging with NO whd_flag filter. → S115.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. → S115.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. ▶ STEP 6.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL. THE SIGN
      IS INVERTED. ⚠⚠ LIVE ON BOTH CLIENTS.
      ✓✓ CONFIRMED FROM BOTH SIDES IN S113. All three branches of
        Formulations.js (:1103 :1136 :1188 regions) declare returnSum,
        never assign it, and add the return into `sum`. MLOManagement.js
        at :1112 DOES assign returnSum. ▶ THE PROOF THAT ONE FILE IS
        WRONG IS SITTING IN THE OTHER FILE.
      ▶ STEP 6, and Minty ruled it LAST.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ STEP 6.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. ▶ OWN SITTING.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. ▶ STEP 6. HIGH.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ ROW 48.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. ▶ MINTY'S CALL.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT. LOW.
      ⚠ SEEN LIVE S113 on the release screen — two lot lines read
        "Pdt-260808-1 ( Rec-260809-1 = ... )" identically, separable
        only by their quantities.
P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW. LOW.
P174  ⚠ edit-mlc.component.ts:372 WRITES A FORM CONTROL BACK INTO
      mlcDetails.batches. ⚠ STILL NOT INVESTIGATED.
P175  ⚠ getFormulaByIdForReleaseMaterial :1092 gates on
      `typeof x != undefined`. A gate that cannot fail. LOW.
P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` is absent
      from both boxes; S113 used the python3 one-liner twice more.
      ▶ RECORD IT IN 3B.4. MEDIUM.
P178  ⚠⚠ COUNTED AT THE S113 CLOSE, AND BOTH FIGURES WERE
      UNDERSTATED: PROD CARRIES 24 dist-prod-* FOLDERS AND DEV CARRIES
      41, back to fa980dfd. NOW had said sixteen and "dev similar",
      measured at S111.
      ⚠ DEV ALSO CARRIES SIX www-html.bak-dev-* backups where the
        rollback line implies two.
      ▶ THIS NEEDS A RETENTION RULE, NOT AN AD-HOC SWEEP. Deleting 65
        folders on a judgement call at the end of a session is how a
        rollback goes missing. MINTY RULES THE RULE.
      ▶ DECIDE A RETENTION RULE — keep the last three. LOW.
P179  ⚠ start-mlc.component.html:198 READS `formulations_myCodee` —
      THREE E's. Renders blank, silently. One-character fix. LOW.
      ⚠ DID NOT FIRE ON MO-0011's SCREEN CHECK. Still open.
P180  ⚠ THE BUILD WORKFLOW WARNS Node.js 20 is deprecated and forced
      onto Node.js 24. ▶ Update the action versions. LOW.
P182  ⚠ THREE MORE INTERMEDIATE CONTROLS IN NO DOCUMENT. MEDIUM.
P184  ⚠⚠ THE RELEASE WRITE PATH DERIVES UNITS FROM A WEIGHT AND
      SUBTRACTS THEM FROM THE CORE STOCK LINE.
        _ratio = _lot.qty / _lot.recieved_qty        units per Kg
        inventory_units −= Number(qty_allocated) × _ratio
      ⚠ IT WEARS A MULTIPLICATION AND IS ALGEBRAICALLY A DIVISION.
      ⚠⚠ THIS IS A WRITE, NOT A DISPLAY. A wrong number here is STORED.
      ✓ ARITHMETICALLY CORRECT TODAY. NO CLIENT HAS EVER RELEASED AN
        INTERMEDIATE, so nothing wrong has been banked.
      ▶ CLOSES AS PART OF S114. HIGH.
P185  ⚠ eval() IS USED TO SUM QUANTITIES ON THE RELEASE SCREEN —
      release-mat-details.component.ts :322, :439, :456.
      ▶ REPLACE WITH reduce IN THE SAME PASS AS S114. MEDIUM.
```

### NEW IN S113

```
P188  ⚠⚠ AFTER THE UNITS CAPTURE, released_qty WILL STILL BE KILOGRAMS
      WHILE final_qty IS A UNIT COUNT — THE EXACT BASIS MISMATCH THAT
      CAUSED THE S112 REGRESSION.
      release-mat-details.component.ts:296
        remainToFill = final_qty − released_qty
      released_qty is built by summing mprrecievelots.qty_allocated,
      which STAYS Kg by design (six read sites depend on it).
      ▶ SO remainToFill CANNOT SIMPLY GO BACK TO final_qty IN S114.
        EITHER the backend serves a released_qty_units alongside, OR
        final_qty_kg stays and the screen remains Kg-anchored on that
        one subtraction.
      ⚠⚠ THIS IS AN EIGHTH PIECE IN WHAT PLAN SCOPED AS A SEVEN-PIECE
        JOB, AND IT IS WHY S114 WAS NOT STARTED IN S113. → S114.

P189  ⚠ MLOManagement.js :1097 AND :1102 SUM THE SAME MATERIAL TWICE
      UNDER DIFFERENT GUARDS — one gates on item.qty, the other on
      item.quantity, and both add data.qty_allocated for the same
      material_id match.
      ⚠ IF A ROW EVER CARRIED BOTH PROPERTIES IT WOULD DOUBLE-COUNT.
      ⚠ NOT INVESTIGATED. Whether any row carries both is UNKNOWN.
      ▶ One query settles it. LOW until then.

P190  ⚠ material-traceability-details.component.ts:171
        element.releasedQty = (element.qty_allocated - element.qty_returned)
      BOTH ARE VARCHAR STRINGS from the temp table. Subtraction coerces,
      so it works. ⚠ A "+" THERE WOULD SILENTLY CONCATENATE.
      ▶ Wrap in Number() when that file is next opened. LOW.
```

### ✓ CLOSED IN S113 — DELETE THESE LINES AT S114 CLOSE

```
P181  ✓ start-mlc SCREEN-PROVEN on 474 MO-0011. Four patches, first look.
P186  ✓ THE WRONG NUMBER ON MATERIAL TRACEABILITY. Both boxes, both
      screens. ⚠⚠ THE ONLY WRONG NUMBER IN THE QUEUE, AND IT IS GONE.
P187  ✓ absorbed — the IP2/P2/IP3 fixture is recorded under FIXTURES.
P177 · P183   ✓ closed in S112, still listed.
P160 · P162   ✓ closed in S111, still listed.
P151 · P157   ✓ closed in S110, still listed.
P147 · P161   ✓ closed in S109, still listed.
P104 · P150   ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

⚠⚠ READ THE DIRECTORY AT THE CLOSE. DO NOT COPY THIS LIST FORWARD.
  ⚠ THIS LIST WAS READ OFF BOTH BOXES AND THE MAC AT THE S113 CLOSE.

```
MAC    ~/Downloads — TWELVE dist zips at S113 close:
         dist-dev-e1a82e02... · dist-prod-e1a82e02...  ⚠⚠ KEEP, LIVE
         dist-dev-2968c591... · dist-prod-2968c591...  keep one generation
         dist-dev-8bbf2c30... · dist-prod-8bbf2c30...  DELETE
         dist-dev-e8e8f572... · dist-prod-e8e8f572...  DELETE
         dist-dev-3b176720...                          DELETE
         dist-prod-bc03b22d... (1).zip                 DELETE, a duplicate
         dist-dev-bc03b22d... · dist-prod-bc03b22d...  DELETE
       ⚠ ALSO: UNITS-BIBLE-S110-SUPERSEDED.xlsx, and the "(1)/(2)"
         duplicate downloads of NOW / PLAN / UNITS-BIBLE / Section_5.
       ⚠⚠ VERIFY BY STAMP, NEVER BY POSITION.

DEV    ~/dist-dev-e1a82e02*                       keep, live
       ~/dist-dev-2968c591*                       keep one generation
       ~/www-html.bak-dev-e1a82e02*               ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-dev-2968c591*               keep one generation
       ~/Trace_MaterialDetails_SP.bak-S113-DEV.txt  ⚠⚠ KEEP
       ~/mprrecievelots-before-S112-DEV.sql       ⚠⚠ KEEP — THE ONLY
                                                    COLUMN ROLLBACK
       ~/*.bak-S111-DEV.txt                       ⚠⚠ KEEP BOTH
       ~/fix-matdetails-S113.sql                  keep with its backup
       /tmp/*.js  — FIFTEEN, back to S106         delete all
         ⚠ INCLUDING /tmp/p1.js and /tmp/p2.js, which share names with
           S113's Mac scripts and are NOT them. Same-named files on two
           machines. → LESSONS.

PROD   ~/dist-prod-e1a82e02*                      keep, live
       ~/www-html.bak-prod-e1a82e02*              ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-prod-2968c591*              keep one generation
       ~/Trace_MaterialDetails_SP.bak-S113-PROD.txt  ⚠⚠ KEEP
       ~/*.bak-S111-PROD.txt                      ⚠⚠ KEEP BOTH
       ~/dist-prod-* — SIXTEEN OLD FOLDERS        → P178
       ~/mo-0001-before-heal-S93.txt              → P94
       /tmp/*.js — NINE                           delete all
       ✓ /tmp/dump.cnf IS ABSENT. It was deleted at the S112 close.
         ▶ COMES OFF THIS LIST.

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106, S109, S110, S111, S112 OR S113 BACKUPS.
```

---

## THE LESSONS S113 EARNED

```
1  ⚠⚠ THE DOCUMENT NAMED FOUR FIX SITES AND ALL FOUR WERE DEAD, WHILE
   THE LINE IT SAID TO LEAVE ALONE WAS THE DEFECT. Two of the four sat
   inside a commented block; the other two iterate an array that nothing
   assigns — every write to newList in the .ts is commented out.
   ▶ PATCHING BY THE DOCUMENT WOULD HAVE BUILT CLEAN, DEPLOYED CLEAN AND
     CHANGED NOTHING, and the row would have been marked green.
   ▶ AN ADDRESS IS A CLAIM, AND SO IS "LEAVE THIS ONE ALONE". Both were
     wrong in the same entry. The addresses are corrected in the bible.
   ⚠ THE ONLY REASON IT WAS CAUGHT: the file was read before it was
     patched, and the loops were mapped before an anchor was written.

2  ⚠⚠ A LIVE *ngFor OVER AN EMPTY ARRAY IS MORE DANGEROUS THAN COMMENTED
   CODE. The commented block announces itself. The mat-card at :191 is
   real markup, in the rendered template, and it renders nothing forever
   because newList is only ever assigned inside comments.
   ▶ REACHABILITY IS ABOUT THE DATA, NOT ONLY THE MARKUP. Grep what
     fills the collection, not just whether the loop exists. J86's
     lesson, one layer deeper.

3  ⚠⚠ A CHECK'S EXPECTED VALUE CAN BE WRONG WITHOUT THE CHECK BEING
   WRONG. Claude predicted grep -c "received_units" would return 1
   against SHOW CREATE, reasoning from JR18's note that a view is one
   line. IT RETURNED 3 — SHOW CREATE PROCEDURE preserves newlines.
   ▶ THE RIGHT ANSWER FOR THE RIGHT REASON, AND IT COULD HAVE BEEN READ
     AS A FAILURE. Say what a pass looks like AND why, and re-derive it
     when the object type changes. Fourth mis-scoped check this campaign.

4  ✓✓ THE PRECONDITION WAS A DOCUMENT CLAIM AND IS NOW A MEASUREMENT.
   NOW said qty_allocated is read as Kg in six places. Nobody had read
   them. All six were read in S113 and all six are `sum = sum +
   qty_allocated` — no division anywhere.
   ▶ S114's WRITE PATH IS UNOBSTRUCTED, AND THAT IS KNOWN RATHER THAN
     ASSUMED. ⚠ It was worth ten minutes precisely because the same
     document had just been wrong about four addresses.

5  ⚠⚠ READING THE PRECONDITION FOUND AN EIGHTH PIECE OF A SEVEN-PIECE
   JOB. released_qty stays Kg while final_qty is units — the same basis
   mismatch that turned the guard green on a 170% over-release in S112.
   ▶ P188. And it is the reason S114 was deferred rather than started
     late in a long session.

6  ✓ THE PROCEDURE WENT TO PROD BEFORE THE SCREEN WAS PROVEN, AND THAT
   WAS RIGHT. It is additive, no deployed code read the new column, and
   the anchors were fresh. ▶ WHEN THE PIECES ARE IN HAND, FINISHING
   COSTS LESS THAN RESUMING — S112's lesson 10, applied deliberately.

7  ⚠ A PATH WRITTEN FROM A DOCUMENT'S SHORTHAND WAS WRONG. PLAN names
   the component file but not its directory; the details component sits
   one level deeper than the obvious guess. `find` settled it in seconds.
   ▶ NEVER TYPE A PATH FROM MEMORY OF WHAT A DOCUMENT IMPLIED.

8  ⚠ TRAPS 9 APPEARED THREE TIMES IN ONE SESSION AND EACH TIME IT
   MATTERED. MO-0007 at 1 Kg/unit has qty, received_qty and
   received_units ALL EQUAL TO 100 — it cannot move whatever the code
   does, which is exactly what makes it the control and useless as
   proof. Glutenull at 0.32 and 0.24 lands the old division exactly, so
   the prod fix is invisible in the numbers. And wduRec changed basis
   with no visible change at all.
   ▶ ONLY MO-0010 AT 10:1 SHOWED THE FIX. Pick the fixture that can fail.

9  ⚠⚠ EVERY COLUMN OF A TEMP TABLE HERE IS VARCHAR(100), SO NUMBERS
   ARRIVE AS STRINGS. Multiplication coerces silently and works;
   addition would concatenate silently and not. Number() went in for
   that reason and the adjacent releasedQty line is still unguarded.
   → P190.

10 ⚠ SAME-NAMED SCRIPTS EXIST ON TWO MACHINES. /tmp/p1.js and /tmp/p2.js
   are on DEV from an earlier session; tonight's p1.js and p2.js ran on
   the MAC. Harmless this time — the diff proved which ran — but it is
   the /tmp version of the frontend-repo-on-both-machines hazard.
   ▶ THE DIFF IS THE PROOF, NOT THE FILENAME.
```
