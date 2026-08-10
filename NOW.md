# NOW

Last rewritten: S112, 10 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S112 SHIPPED FIVE THINGS.
  9dac080   MPRRecieveLots.js — the qty_allocated_units attribute, BACKEND
  4d43bd4   Formulations.js — final_qty_kg, BACKEND
  8bbf2c30  the release screen product block reads final_qty_kg, frontend
  2968c591  the composite units# (Kg uom) on three templates, frontend
  ALTER     mprrecievelots.qty_allocated_units — ⚠⚠ DEV ONLY, DELIBERATELY
  ▶ NOTHING IS PENDING PROMOTION. The application stack is in step.
  ⚠ THE COLUMN IS THE ONE DIVERGENCE AND IT IS INTENTIONAL. It lands on
    prod with the write path in S113, the way JR15 did it.

⚠⚠ THE BOARD: 36 GREEN · 12 RED · 3 REVIEW, of 51. BALANCE 15.
  ▶ THREE ROWS ADDED — 49, 50 and 51 — and row 45 rescoped from review
    to red. 49 and 50 are GREEN; 51 is RED.
  ▶ 47 IS THE CEILING.
  ⚠ S112 CLOSED NO ROW. It laid groundwork, repaired an S111 regression,
    and added two rows that were already satisfied. RECORDING IT AS
    PROGRESS WOULD BE THE MISTAKE THE BIBLE WARNS ABOUT.

⚠⚠ MINTY'S RULINGS, S112 — THEY DECIDE THE REST OF THE CAMPAIGN.
  1  ANY INTERMEDIATE-PRODUCT FIGURE, ANYWHERE INCLUDING TRACEABILITY,
     SHOWS UNITS WITH Kg DERIVED BESIDE IT — units# (Kg uom).
  2  ⚠⚠ THE DISCRIMINATOR IS THE THING, NOT THE BLOCK.
       materials    → Kg ONLY, anywhere
       formulations → units AND Kg — sold, consumed, or both
     ▶ "The same thing appearing as a material line in one recipe and a
       product elsewhere carries units BECAUSE IT IS A PRODUCT, not
       because of where it sits on a screen."
     ✓ IN CODE: does the row carry a formula_id?
     ✓ THE SCHEMA ALREADY AGREES — the release backend branches on
       Rec_Lot_id vs Rec_Product_id. IT IS THE SCREENS THAT DO NOT.
  3  THE RETURN PATH GOES LAST.
  4  DERIVE THE REMAINING-UNITS FIGURE ON THE RELEASE SCREEN. DO NOT ADD
     A PARALLEL COLUMN. ⚠ prev_received_qty accumulates from more than
     the release path — 474's 2.59 Kg came from a DISPATCH — so a second
     running total would diverge silently.
  ⚠ ALL BELONG IN UNITS-BIBLE PART 1 ON MINTY'S INSTRUCTION.

---

## STATE
⚠ READ OFF BOTH BOXES AT S112 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺263 · 200
          frontend SERVING dev-2968c59142dc9144e2f6f0fb9925bcdf43f9e1a1
          frontend checkout c2a52d8e — ⚠⚠ STALE BY SEVENTEEN SESSIONS.
            It shows mlcDetails.batches where the Mac shows getFactor().
            HARMLESS UNTIL SOMEBODY READS IT AS LIVE CODE. It happened
            in S112. → LESSONS.
          backend HEAD 4d43bd4 · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 UPDATES PENDING · restart required
          ✓ pm2-ubuntu systemd unit INSTALLED AND ENABLED, S112.
            dump.pm2 current, 9928 bytes.

PROD      15.157.38.101 · pm2 abletrace-backend ↺343 · 200
          TWO LIVE CLIENTS · SERVING prod-2968c59142dc9144e2f6f0fb9925bcdf43f9e1a1
          backend HEAD 4d43bd4 · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING at S110. NOT RE-READ SINCE. → P102
          ✓ pm2-ubuntu ENABLED — MEASURED S112. It always was.
            ⚠⚠ NOW HAD ASSUMED THE OPPOSITE. See LESSONS.
```

```
✓ BACKENDS MATCH     dev 4d43bd4          prod 4d43bd4
✓ FRONTENDS MATCH    dev 2968c591...      prod 2968c591...
⚠⚠ DATABASES DIVERGE BY ONE COLUMN, DELIBERATELY.
   mprrecievelots.qty_allocated_units EXISTS ON DEV, NOT ON PROD.
   ▶ THE MODEL DECLARES IT ON BOTH. Harmless — Waterline declaring an
     attribute the table lacks, with nothing writing to it.
   ▶ THE PROD ALTER IS S113's, and it lands with the write path.
✓ BOTH INTERMEDIATE PROCEDURES MATCH — 3 joins, both new columns. JR22.
✓ THE HEADER VIEW    2 divisions each box (JR20)
✓ THE RECEIVING PROC 1 qty column, 2 joins (JR21)
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = 2968c591   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = 4d43bd4    ✓ PULLED TO BOTH BOXES
          docs     main = e514c95   ✓ THIS COMMIT
            S111's close set it at a345847. RULES 6 — do not carry a
            number forward, read it.
          ⚠⚠ TEN dist ZIPS IN CIRCULATION, EIGHT SUPERSEDED. Every one is
            green and real:
              30b2ddd4      the J117 regression artifact, status unknown
              bc03b22d ×3   including a macOS " (1)" duplicate
              3b176720      S111's first frontend commit
              e8e8f572 ×2   S111's second
              8bbf2c30 ×2   S112's first — NEVER DEPLOYED
          ▶ THE DEFENCE IS THE STAMP AND NOTHING ELSE. TYPE IT IN FULL.
            NEVER TAKE THE NEWEST BY POSITION. → J117.
          ⚠ BUILD ANNOTATION ON EVERY RUN: Node.js 20 deprecated, forced
            onto Node.js 24. Builds succeed. → P180.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-2968c59142dc9144e2f6f0fb9925bcdf43f9e1a1
          prod  /home/ubuntu/www-html.bak-prod-2968c59142dc9144e2f6f0fb9925bcdf43f9e1a1
          ⚠ EACH HOLDS THE BUILD IT REPLACED. dev's holds 8bbf2c30.
            prod's holds e8e8f572.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.
          ⚠ BACKEND ROLLBACK is `git reset --hard fc78ce1` then restart.

          DATABASE BACKUPS — ⚠⚠ KEEP ALL OF THESE:
            DEV  mprrecievelots-before-S112-DEV.sql  2814 bytes · 1 CREATE
                 ⚠ THE PRE-ALTER STRUCTURE. The only rollback for the column.
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
            469  HAGENSBORG   13 MOs, none run. ZERO release rows.
                              ⚠⚠ batch_qty 1 ON ALL 13. TRAPS 9, permanently.
                              NO INTERMEDIATES.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
          ⚠ SANDBOXES ON PROD: 464 test260703@ and 465 test260704b@.
            ⚠⚠ 465 IS THE ONE WITH PRODUCT-SIDE ALLOCATION HISTORY —
              all five rows. MEASURED S112. ▶ USE 465, NOT 464, TO
              EXERCISE THE RELEASE PATH ON PROD.
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
⚠⚠ THREE TEMPLATES CARRY THE INTERMEDIATE BLOCKS — edit-mlc, edit-mlo
  AND start-mlc. TWO HAVE BEEN SCREEN-PROVEN. start-mlc HAS NOW BEEN
  PATCHED FOUR TIMES ACROSS S111 AND S112 AND NEVER ONCE OPENED. → P181.
⚠ THREE MORE INTERMEDIATE CONTROLS EXIST AND ARE IN NO DOCUMENT:
    edit-mlc.component.html:223 · edit-mlo.component.html:319 ·
    edit-closed-mlcs.component.html:77 — all <mat-label>. → P182.
```

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ `hostname` AND `git log --oneline -1` AT THE TOP OF EVERY MAC BLOCK.
    ⚠⚠ THE FRONTEND REPO EXISTS ON BOTH MACHINES AT THE SAME PATH, AND
      DEV'S COPY IS SEVENTEEN SESSIONS STALE. Reading it as live code is
      the one wrong-box case environment does not catch. IT HAPPENED IN
      S112 AND THE STALE TEXT WAS VISIBLE IN THE OUTPUT.

---

## THE FIXTURES — ⚠ DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE INTERMEDIATE FIXTURE

```
IP-0.37      FO-0004  0.37 Kg/unit  batch_qty 19  inventory_units 47
Parent-0.53  FO-0005  0.53 Kg/unit  batch_qty 13
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units

MO-0003  IP-0.37, 41 units, COMPLETE. ONE RECEIPT.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. STILL THE BEFORE PICTURE.
MO-0005  IP-0.37, 13 units, TWO RECEIPTS of 5 and 8.
MO-0006  ⚠⚠ NEW, S112. Parent-0.53, 7 pallets, CREATED, NOT RELEASED.
         ▶ THIS IS S113's WRITE-PATH FIXTURE. It exists so MO-0004 does
           not have to be spent.
         ⚠ 7 ÷ 13 = 0.538461... — deliberately not a multiple of 13, so
           the rounding stays visible. TRAPS 9.
         ▶ ITS FIGURES, ALL PROVEN S112:
             IP-0.37 required   4.846# (1.793 Kg)   = 9 × 7/13
             IP-0.37 WH Stock  47.000# (17.390 Kg)
             Ginger Powder    701.190 Kg  = 1302.21 × 7/13
             Pouch 1323 · Carton 441 · Case 63 · Pallet 7
         ⚠ RELEASING IT WILL CONSUME 4.846 UNITS, leaving 42.154.
MR-0009  Ginger Powder, 10 Kg, reason Sample. MATERIAL.
DO-0002  IP-0.37, 7 units typed, packing_units STORED AS 7.
         ⚠ ITS 2.59 Kg IS WHY receiveproducts 11449 HAS
           prev_received_qty 2.59 AND THE LOT SHOWS 12.580 / 15.17.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS. TRAPS 9.

⚠⚠ THE CONTROLS, AND S112 ADDED TO THEM:
  Pouch 4347.000 Ea on MO-0004 · 1323.000 Ea on MO-0006
  Ginger Powder — the matList line DIRECTLY ABOVE every intermediate
    patch, reading the SAME property. IT HAS NOT MOVED IN THREE SESSIONS.
  ▶ WHEN A PATCH IS SCOPED TO A BLOCK, THE CONTROLS ARE THE BRACKETING
    LINES. A count proves a string changed; the neighbours prove it
    changed in the right place.
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
                       product, summing exactly. prod 68: 63 and 5.
                       NO OVERLAPS, NO ORPHANS, ON EITHER BOX.
                     ⚠ qty_allocated IS READ AS Kg IN SIX PLACES —
                       Formulations.js :1103 :1136 :1188 and
                       MLOManagement.js :1097 :1102 :1107.
                       ▶ ITS BASIS MUST NOT CHANGE. TRAPS 1's shape.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG) ·
                     prev_received_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty`.
                     ⚠⚠ prev_received_qty IS Kg, WHICH IS WHY THE
                       UNITS-REMAINING FIGURE ON THE RELEASE SCREEN HAS
                       TO BE BUILT RATHER THAN READ. → S113.

subrecipeformulation qty (KG) · ship_qty (UNITS)
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX.

formulations         inventory (KG) · inventory_units (UNITS) · batch_qty
                     ⚠ batch_qty IS SHIPPING UNITS PER BATCH, and
                       WhC_GetMoDetails_SP SERVES IT ALIASED as
                       formula_id__batch_qty.

company              company_name  ← NOT `name`
fopackaging          formulation_id ← NOT `formula_id`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
WhC_GetMoIntermediateProducts_SP   ✓ JR22, BOTH BOXES.
  ▶ SERVES subrecipeformulation_ship_qty AND formulations_inventory_units.
  ⚠⚠ IT ALIASES EVERYTHING. ▶ FEEDS THE INTERMEDIATE PRODUCTS BLOCK.
WhC_GetFormulaIntermediateProducts ✓ JR22, BOTH BOXES.
  ▶ SERVES bare ship_qty AND bare inventory_units. ALSO STILL SERVES
    bare inventory (Kg) — retained deliberately, and S112's composite
    display depends on it.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. undefined, SILENTLY.
  ▶ FEEDS matList / formulaList / packList — THE BATCH MATERIALS BLOCK.

Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20, and → S114.
  ▶ intermediate_prd_su and SOH_su. ⚠ SOH_su IS DEPENDENT on the other.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE.
Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS. → S114.
Trace_ProductOneStepForwardIP_SP · ...ReleaseDetails_SP  → S114.
WhC_GetMoProductReceivingDetails_SP  ✓ receiveproducts.qty. JR21.
WhC_GetMoDetails_SP  ✓ formula_id__batch_qty. ⚠ THE ALIAS IS THE POINT.

⚠ db-definitions-S93.txt IS STALE ON EIGHT OBJECTS. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 4d43bd4 on both boxes.
FRONTEND   ✓ NOTHING PENDING. 2968c591 on both boxes.
DATABASE   ⚠⚠ THE ALTER IS DEV-ONLY AND THAT IS DELIBERATE.
             It lands on prod with the write path in S113.
             ▶ THIS IS NOT A PENDING PROMOTION. It is a sequenced gate.
DOCS       ⚠ S112's OUTPUT PENDING COMMIT:
             NOW.md · PLAN.md · UNITS-BIBLE.txt + .xlsx
             Section_5.md — J122 to merge, header to J122 / S112.
           ⚠⚠ WRITE THE GITHUB DOCS LINE FROM GITHUB AFTER THE PUSH.
```

---

## ⚠⚠ RULINGS MADE IN S112 — RECORDED, NOT PENDING

```
1  ✓ BIBLE ROW 49 STANDS as its own row.
2  ✓ THE Kg SUFFIX — batched with rows 44/48. ⚠⚠ CLOSED ANYWAY as a
   side effect of the composite: unit_name now sits inside the bracket.
   → P183 CLOSES.
3  ✓ DEV'S pm2 STARTUP fixed the same session.
4  ✓ MATERIALS ARE Kg ONLY. Products — sold or intermediate — carry
   units and Kg. ▶ THIS RE-SCOPED ROW 45 from a review item to a job.
5  ✓ UNITS ARE THE ANCHOR END TO END, INCLUDING TRACEABILITY. Every
   intermediate figure renders units# (Kg uom).
   ▶ THIS DECIDES STEP 5 and is the reason S113 exists.
6  ✓ THE RETURN PATH GOES LAST. ⚠⚠ P164's INVERTED SIGN STAYS LIVE ON
   BOTH CLIENTS UNTIL THEN. Accepted knowingly, re-affirmed S112.
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
P86   Cold boot blindness. ⚠ SHARPENED S112 — both boxes now have a pm2
      unit, so this is testable for the first time. Still untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive, AND IT HOLDS ITS
      OWN COPIES OF THE STORED PROCEDURES. → record in 3B.
P102  ⚠⚠ SECURITY. Both boxes report *** System restart required ***.
      ✓ UNBLOCKED S112 — both boxes now have an enabled pm2 unit and a
        current dump. THE PRECONDITION IS MET.
      ⚠ dev 12 updates. prod 46 at S110, NOT RE-READ SINCE.
      ⚠⚠ EIGHTEEN DAYS RUNNING. TWO CLIENTS ON PROD. ▶ OWN JOB, OWN GATE.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠⚠ AFTER THE UNITS CAMPAIGN CLOSES. Minty's ruling S110.
      ⚠ FOUR THINGS WILL MEET IT: TRAPS 3 · J97's multiple invoices ·
        P138 · P137.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ STILL OPEN:
        rejected-materials.component.ts:152-154 getShippingUnits — NO CALLER
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
        PopUps/add-dispatch (v1) — whole component, never opened
        edit-mlc.component.ts:311 lotReceived consumer — commented out
        edit-mlc.component.ts:227 formulaList.push(data3) — commented out
      ⚠⚠ NEW S112: MaterialsProductsReleased.js:52
        createReleaseMaterialProducts — THE OLD RELEASE FUNCTION. Nothing
        calls it; the controller at :10 calls V2. A dead function beside
        a live one with a nearly identical name. J12's decoy shape.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A SIXTH TIME IN S112 — S110's and S111's comments
        above :1156 made the basis question obvious, and S112 added a
        third explaining why final_qty_kg exists.
P119  Back up the database's own code into the repo. ⚠ STALE ON EIGHT.
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
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. → S114.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
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
      ✓ HELD AGAIN IN S112.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT
      SHARE A COMPANY-ID NAMESPACE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins
      fopackaging with NO whd_flag filter. → S114.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. → S114.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. ▶ STEP 6.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL. THE SIGN
      IS INVERTED. ⚠⚠ LIVE ON BOTH CLIENTS.
      ⚠ SEEN AGAIN IN S112 at :1157, three lines below a patched line.
        DELIBERATELY NOT TOUCHED. ▶ STEP 6, and Minty ruled it LAST.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ STEP 6.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. ▶ OWN SITTING.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. ▶ STEP 6. HIGH.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ ROW 48.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. ▶ MINTY'S CALL.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT. LOW.
P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW.
      ⚠ CONFIRMED AGAIN S112 on prod, now reading "0.000# (0.000 )" in
        the composite format. Cosmetic, unchanged in substance. LOW.
P174  ⚠ edit-mlc.component.ts:372 WRITES A FORM CONTROL BACK INTO
      mlcDetails.batches. ⚠ STILL NOT INVESTIGATED.
P175  ⚠ getFormulaByIdForReleaseMaterial :1092 gates on
      `typeof x != undefined`. A gate that cannot fail. LOW.
P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` is absent
      from both boxes; S112 used the python3 one-liner four more times.
      ▶ RECORD IT IN 3B.4. MEDIUM.
P177  ✓ CLOSED S112. pm2-ubuntu installed and enabled on DEV; PROD
      ALREADY HAD IT. ⚠ DELETE THIS LINE AT THE S113 CLOSE.
P178  ⚠ PROD CARRIES SIXTEEN OLD dist-prod-* FOLDERS. Dev similar.
      ▶ DECIDE A RETENTION RULE — keep the last three. LOW.
P179  ⚠ start-mlc.component.html:198 READS `formulations_myCodee` —
      THREE E's. Renders blank, silently. One-character fix. LOW.
P180  ⚠ THE BUILD WORKFLOW WARNS Node.js 20 is deprecated and forced
      onto Node.js 24. ▶ Update the action versions before it stops
      being forced. LOW.
P181  ⚠⚠ start-mlc.component.html HAS NOW BEEN PATCHED FOUR TIMES ACROSS
      S111 AND S112 AND HAS NEVER BEEN SEEN ON A SCREEN.
      ▶ ONE CHECK AT THE S113 OPEN. It is in PLAN's first three actions.
P182  ⚠ THREE MORE INTERMEDIATE CONTROLS IN NO DOCUMENT. MEDIUM.
P183  ✓ CLOSED S112 — the composite put unit_name inside the bracket.
      ⚠ DELETE THIS LINE AT THE S113 CLOSE.
```

### NEW IN S112

```
P184  ⚠⚠ THE RELEASE WRITE PATH DERIVES UNITS FROM A WEIGHT AND
      SUBTRACTS THEM FROM THE CORE STOCK LINE.
      MaterialsProductsReleased.js, product branch:
        _ratio = _lot.qty / _lot.recieved_qty        units per Kg
        inventory_units −= Number(qty_allocated) × _ratio
      ⚠ IT WEARS A MULTIPLICATION AND IS ALGEBRAICALLY A DIVISION BY
        Kg-per-unit — the disguised R2 form J83 warns about.
      ⚠⚠ THIS IS A WRITE, NOT A DISPLAY. It sets formulations.inventory_units,
        PART 1 source 3. A wrong number here is STORED.
      ✓ ARITHMETICALLY CORRECT TODAY — verified S112 against the rows.
      ✓ NO CLIENT HAS EVER RELEASED AN INTERMEDIATE, so nothing wrong
        has been banked.
      ▶ IT CLOSES AS PART OF S113: once the typed unit count exists,
        subtract it directly. HIGH, and it rides with the capture.

P185  ⚠ eval() IS USED TO SUM QUANTITIES ON THE RELEASE SCREEN —
      release-mat-details.component.ts :322, :439, :456.
        eval(list.map(x => x.enable ? (x.qty || 0) : 0).join('+'))
      ⚠ IT WORKS, AND IT IS eval ON OPERATOR-ENTERED INPUT.
      ▶ REPLACE WITH reduce IN THE SAME PASS AS S113, since that code is
        being opened anyway. MEDIUM.

P186  ⚠⚠ A WRONG NUMBER ON MATERIAL TRACEABILITY. ▶ S113. HIGH.
      ⚠⚠ THE ONLY WRONG NUMBER IN THE QUEUE. Everything else open is a
        RIGHT number reached by a WRONG route.
      Material Traceability → Salt → One Step Forward, MO-0010:
          THE SCREEN SAYS   10 Kg (1#)
          THE TRUTH         100 Kg, 10 units — the MO list says so
        ⚠⚠ THE COMPLETED FIGURE ON THE SAME ROW READS 100 Kg (10#) AND
          IS CORRECT. ONE ROW, TWO HALVES, CONTRADICTING EACH OTHER.
      THE CAUSE — ONE NUMBER USED TWICE, WRONG BOTH TIMES:
        mlomanagement.qty = 10  ⚠⚠ UNITS SINCE THE S41 FLIP
          printed raw with the product's UOM  → "10 Kg"  MISLABELLED
          ceil(10 ÷ wgt_kgs_per_unit 10) = 1  → "1#"     A COUNT DIVIDED
        mlomanagement.received_qty = 100  ✓ GENUINELY Kg — so its half
          of the row is right, and that is why nobody noticed.
      ▶ THE SCREEN WAS WRITTEN WHEN qty MEANT KILOGRAMS. S41 CHANGED THE
        COLUMN'S MEANING AND THIS SCREEN NEVER FOLLOWED. J7's shape;
        S43 fixed exactly this in Trace_ProductProdLotView.
      ✓ TRACED END TO END 10 AUG, SEVEN HOPS, ALL READ — component →
        shared service → NgRx effect → HTTP → routes.js:400 →
        TraceabilityController:25 → Traceability.js:360 →
        ⚠⚠ Trace_MaterialDetails_SP, WHICH IS IN NO BIBLE ROW.
      ✓ THE PROCEDURE IS INNOCENT. It hands over two honest columns and
        does no arithmetic. THE DEFECT IS ENTIRELY FRONTEND.
      ⚠ Math.ceil ON ALL SIX SITES — ALWAYS ROUNDS UP.
      ⚠⚠ THE MATERIAL ROWS AT :107/:108 ARE FINE. The original "materials
        show unit counts" alarm was WITHDRAWN — Minty's screens show
        clean Kg throughout. See LESSONS.
```

P187  ✓ NEW FIXTURE, DEV COMPANY 474 — BUILT BY MINTY IN S112 TO THINK
      WITH. KEEP IT.
        IP2  FO-0006-2  Salt 10 Kg/batch · 1 unit/batch · 10 Kg per unit
             MO-0010 made 10# (100 Kg).
        P2   FO-0007-2  Ginger 20 Kg + IP2 2# (20 Kg) · 2 units/batch
             Pouch 5 Kg → Case = 4 Pouch = 20 Kg per case
             MO-0011 made 7# (140 Kg), batches 3.5, 7 units of IP2 used.
      ✓ ONE BATCH OF P2 CONSUMES 2 UNITS OF IP2. Clean one-for-one.
      ⚠⚠ EVERY RATIO IS ROUND. A DIVISION AND A STORED READ PRODUCE
        IDENTICAL NUMBERS. ▶ PERFECT FOR SEEING THE FLOW, USELESS FOR
        PROVING A FIX. 474's IP-0.37 / Parent-0.53 REMAINS THE PROVING
        GROUND. TRAPS 9.
      ⚠ IP2 EXISTS IN TWO VERSIONS — v1 at 1 Kg/unit, v2 at 10 Kg/unit,
        and MO-0007 ran under v1. THAT PAIRING IS USEFUL: at 1:1 the
        division is invisible, at 10:1 it is not.
      ⚠⚠ MO-0007's ROW IS CORRECT AND MUST NOT BE "FIXED". Traceability
        reports what was released AT THE TIME. A screen that re-cast
        history against the current formulation would be the defect.
        ▶ MINTY'S RULING, S112.

### ✓ CLOSED IN S112 — DELETE THESE LINES AT S113 CLOSE

```
P177  ✓ pm2 startup, both boxes confirmed.
P183  ✓ the Kg suffix, closed by the composite.
P160 · P162   ✓ closed in S111, still listed.
P151 · P157   ✓ closed in S110, still listed.
P147 · P161   ✓ closed in S109, still listed.
P104 · P150   ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

⚠⚠ READ THE DIRECTORY AT THE CLOSE. DO NOT COPY THIS LIST FORWARD.
  S110's list was wrong at the S111 open — it named files already gone.

```
MAC    ~/Downloads — TEN dist zips at S112 close:
         dist-dev-2968c591... · dist-prod-2968c591...  ⚠⚠ KEEP, LIVE
         dist-dev-8bbf2c30... · dist-prod-8bbf2c30...  DELETE, superseded
           ⚠ THE PROD ONE WAS NEVER DEPLOYED.
         dist-dev-e8e8f572... · dist-prod-e8e8f572...  DELETE
         dist-dev-3b176720...                          DELETE
         dist-prod-bc03b22d... (1).zip                 DELETE, a duplicate
         dist-dev-bc03b22d... · dist-prod-bc03b22d...  keep one generation
       ⚠ ALSO: UNITS-BIBLE-S110-SUPERSEDED.xlsx, renamed S111 so it
         announces itself. Delete when convenient.
       ⚠⚠ VERIFY BY STAMP, NEVER BY POSITION.

DEV    ~/dist-dev-8bbf2c30* and ~/dist-dev-2968c591*   keep 2968c591 only
       ~/www-html.bak-dev-2968c591*                    ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-dev-8bbf2c30*                    keep one generation
       ~/mprrecievelots-before-S112-DEV.sql            ⚠⚠ KEEP — THE ONLY
                                                         COLUMN ROLLBACK
       ~/*.bak-S111-DEV.txt                            ⚠⚠ KEEP BOTH
       ~/fix-mo-inter-S111.sql · fix-formula-inter-S111.sql   keep
       /tmp/*.js                                       delete

PROD   ~/dist-prod-2968c591*                           keep, live
       ~/dist-prod-8bbf2c30*                           DELETE — never deployed
       ~/www-html.bak-prod-2968c591*                   ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-prod-e8e8f572*                   keep one generation
       ~/*.bak-S111-PROD.txt                           ⚠⚠ KEEP BOTH
       ~/dist-prod-* — SIXTEEN OLD FOLDERS             → P178
       /tmp/*.js · /tmp/dump.cnf                       ⚠⚠ DELETE dump.cnf.
                                                         IT HOLDS THE DB PASSWORD.

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106, S109, S110, S111 OR S112 BACKUPS. They are the
  only rollback for database objects and for the new column.
```

---

## THE LESSONS S112 EARNED

```
1  ⚠⚠ A FIX ON ONE SCREEN BROKE ANOTHER, AND NOTHING IN THE MAP POINTED
   AT IT. S111 made final_qty a unit count. The RELEASE screen reads the
   same property and pairs it with kilogram inputs, so the auto-fill put
   4.846 units into a Kg box and the guard turned GREEN on a release of
   nearly THREE TIMES the requirement.
   ⚠ CLIENT EXPOSURE WAS ZERO — no client has intermediates — but it was
     live code on both boxes for a day.
   ▶ BEFORE CHANGING A SERVED VALUE, GREP EVERY CONSUMER OF IT.
   ▶ THE MAP RECORDS SITES, NOT CONSUMERS. Row 50 exists because of this.

2  ⚠⚠ THE PLAN ASSUMED DATA THAT DOES NOT EXIST. Step 5 was scoped as
   though a unit count were being captured and discarded. IT IS NEVER
   CAPTURED — the release screen asks for kilograms and always has.
   ▶ CONFIRM THE SOURCE OF A VALUE BEFORE PLANNING A WRITE PATH FOR IT.

3  ⚠⚠ MINTY'S ARCHITECTURE CHALLENGE WAS RIGHT AND CHANGED THE JOB. His
   reading — units convert to Kg once at receipt, everything after is Kg
   minus Kg, so the chain is clean — is CORRECT. It would have closed
   five rows as correct-by-design.
   ▶ HE RULED THE OTHER WAY, FOR CONSISTENCY. Both defensible; the ruling
     is what keeps the next mismatch visible.
   ⚠ CLAUDE HAD BEEN TREATING THE Kg-ANCHORED READING AS OBVIOUSLY WRONG.
     IT WAS NOT. RULES: Minty is the domain expert. That is what he is for.

4  ⚠⚠ A 0-BYTE BACKUP WAS WRITTEN AND ONLY THE CHECK CAUGHT IT. mysqldump
   errors on the ~/.my.cnf database= line (J43), but the shell had already
   created the file. grep -c "CREATE TABLE" returned 0.
   ▶ A PLAUSIBLE FILENAME HOLDING NOTHING IS THIS CAMPAIGN'S RECURRING
     HAZARD. Third instance.

5  ⚠⚠ TWO ALARMS RAISED FROM CODE WERE DISPROVEN BY THE SCREEN AND THE
   ROW. (a) "qty_allocated may already be units being subtracted from a
   Kg balance" — disproven by two rows allocating 5.56 against a
   ONE-UNIT receipt. (b) "materials show unit counts on the traceability
   screen" — WITHDRAWN; Minty's screens show clean Kg throughout.
   ▶ BOTH RECORDED AS DISPROVEN, because an unrecorded wrong answer
     becomes the next session's foundation.
   ▶ AND BOTH TIMES THE CODE IMPLIED SOMETHING THE SCREEN DID NOT SHOW.
     READ THE SCREEN BEFORE RAISING THE ALARM.

6  ⚠⚠ FOUR WRONG-BOX INCIDENTS, AND ONE SHOWED ITS OWN DANGER. A missed
   exit put a read on DEV's frontend copy — seventeen sessions stale. It
   showed mlcDetails.batches where the Mac shows getFactor().
   ▶ AN ANCHOR WRITTEN FROM THAT TEXT WOULD HAVE MATCHED NOTHING, OR
     MATCHED AND WRITTEN THE WRONG THING.
   ▶ `hostname` AND `git log --oneline -1` ON EVERY MAC BLOCK.

7  ⚠ A LONG COMMIT MESSAGE TRUNCATED MID-PASTE and left the shell at `>`.
   The first commit had landed; the second had not. Ctrl+C, then a shorter
   message. ▶ THE 12-LINE RULE APPLIES TO COMMIT MESSAGES TOO.

8  ✓ THE GUARDS EARNED THEIR KEEP THREE TIMES IN ONE SESSION — the
   whitespace difference in start-mlc, the 0-byte backup, and the
   two-line remainToFill anchor.
   ▶ SCOPE BY STRUCTURE, ASSERT EXACTLY ONCE, READ THE DIFF, AND LET THE
     BRACKETING LINES BE THE CONTROL.

9  ⚠⚠ P102's PRECONDITION HAD NEVER BEEN RUN, AND THE ANSWER WAS THE
   OPPOSITE OF THE ASSUMPTION. Dev had NO pm2 unit; PROD DID.
   ▶ MEASURE BOTH BOXES. A finding on one is not a finding on the other.
   ✓ Fixed on dev the same session. P102 is unblocked.

10 ✓ THE DECISION TO FINISH THE COMPOSITE IN-SESSION WAS RIGHT, AND THE
   REASONING TRANSFERS: the Kg halves were all already served, the
   templates were already open, and stopping would have meant two prod
   promotions instead of one.
   ▶ WHEN THE PIECES ARE ALREADY IN HAND, FINISHING COSTS LESS THAN
     RESUMING.
```
