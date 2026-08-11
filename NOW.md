# NOW

Last rewritten: S114, 10 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S114 SHIPPED ONE THING, ON BOTH BOXES.
  4910b46d   the release status indicator reads final_qty_kg for products.
             getStockStatus and setMainStatus, frontend only.
  ▶ NOTHING IS PENDING PROMOTION. Application stack and database in step.
  ⚠ THE ONE DIVERGENCE REMAINS mprrecievelots.qty_allocated_units — DEV
    ONLY, DELIBERATELY. It lands on prod with the write path in S115.

⚠⚠ THE BOARD: 38 GREEN · 10 RED · 3 REVIEW, of 51. UNCHANGED.
  ▶ S114 MOVED NO ROW AND WAS NOT MEANT TO. Row 50 was already green
    and was HALF green — see below. 48 IS THE CEILING.

✓✓ THE SESSION'S REAL OUTPUT IS NOT THE COMMIT. IT IS TWO THINGS:
  1  P184 IS NO LONGER A DOCUMENT CLAIM. IT IS A MEASURED DEFECT with
     the line, the arithmetic and the stored wrong value. → below.
  2  ⚠⚠ MINTY REDESIGNED THE UNITS CAPTURE, and the new shape is
     simpler than PLAN's seven-piece framing. → PLAN, and RULINGS.

⚠⚠ WHAT S114 PROVED ABOUT PROOF ITSELF — READ BEFORE CALLING A FIX DONE.
  Claude called the indicator fix "proven" on a screen that showed
  1.793/1.793 GREEN. ⚠ THAT SCREEN COULD NOT HAVE FAILED — the numbers
  are identical before and after; only the COLOUR moves.
  ▶ MINTY REFUSED IT AND ASKED FOR THE BEFORE PICTURE. The old build
    was re-served from its rollback folder and the same screen, same
    numbers, read ORANGE.
  ▶ THAT is the proof. The first version was a result that could not
    have revealed the problem, read as though it had. → LESSONS 1.

---

## STATE
⚠ READ OFF ALL THREE MACHINES AT S114 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺263 · 200 · 162.2mb
          frontend SERVING dev-4910b46d76a4c49eee431e1a9b435a0116fc9031
          frontend checkout c2a52d8e — ⚠⚠ STALE BY NINETEEN SESSIONS.
            HARMLESS UNTIL SOMEBODY READS IT AS LIVE CODE.
          backend HEAD 4d43bd4 · both repos clean
          ⚠ NO BACKEND COMMIT IN S114.
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 UPDATES PENDING · restart required
          ✓ pm2-ubuntu systemd unit INSTALLED AND ENABLED, S112.

PROD      15.157.38.101 · pm2 abletrace-backend ↺343 · 200 · 159.6mb
          TWO LIVE CLIENTS · SERVING prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
          backend HEAD 4d43bd4 · repo clean
          ⚠ frontend checkout reads 9bce0238 — P8, BY DESIGN, and the
            number is recorded here so nobody investigates it. It is
            J62's pencil-edit commit from S61. THE ROLLBACK LABEL IS
            THE ONLY RELIABLE READ OF WHAT IS LIVE.
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING · restart required. TWENTY DAYS. → P102
          ✓ pm2-ubuntu ENABLED — measured S112.

MAC       Mintys-Air-2 · frontend repo CLEAN at 4910b46d
          ⚠ THE ONLY MACHINE THAT EDITS THE FRONTEND.
```

```
✓ BACKENDS MATCH     dev 4d43bd4          prod 4d43bd4
✓ FRONTENDS MATCH    dev 4910b46d...      prod 4910b46d...
⚠⚠ DATABASES DIVERGE BY ONE COLUMN, DELIBERATELY.
   mprrecievelots.qty_allocated_units EXISTS ON DEV, NOT ON PROD.
   ✓ RE-VERIFIED AT THE S114 OPEN — two columns on dev, one on prod.
   ▶ THE MODEL DECLARES IT ON BOTH. Harmless.
   ▶ THE PROD ALTER IS S115's, and it lands with the write path.
✓ Trace_MaterialDetails_SP  MATCHES — 3 received_units both boxes (JR23)
✓ BOTH INTERMEDIATE PROCEDURES MATCH — 3 joins, both new columns. JR22.
✓ THE HEADER VIEW    2 divisions each box (JR20)
✓ THE RECEIVING PROC 1 qty column, 2 joins (JR21)
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = 4910b46d   ✓ BUILT AND DEPLOYED BOTH BOXES
                                     ⚠ dev by push (run #75), prod by
                                       MANUAL DISPATCH (run #76)
          backend  main = 4d43bd4    ✓ unchanged this session
          docs     main = f7fad0b + S114's commit
          ⚠⚠ A BUNDLE FILENAME IS NOT A BUILD IDENTIFIER ACROSS BOXES.
            dev 4910b46d serves 1002.38fb2da9480a8597.js
            prod 4910b46d serves 1002.79e33c32f5de8852.js
            SAME COMMIT, DIFFERENT HASHES — prod builds without source
            maps. ⚠ CLAUDE READ THE UNCHANGED PROD FILENAME AS A FAILED
            DEPLOY. ▶ THE PROOF IS `diff -r artifact /var/www/html`,
            WHICH RETURNS NOTHING WHEN IT IS RIGHT.
          ▶ THE STAMP IS THE DEFENCE. TYPE IT IN FULL. NEVER TAKE THE
            NEWEST BY POSITION. → J117.
          ⚠ BUILD ANNOTATION ON EVERY RUN: Node.js 20 deprecated, forced
            onto Node.js 24. Builds succeed. → P180.
          ⚠ dev artifact 14.4 MB · prod 9.07 MB. NOT A DEFECT.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-4910b46d76a4c49eee431e1a9b435a0116fc9031
          prod  /home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
          ⚠ EACH HOLDS THE BUILD IT REPLACED — BOTH HOLD e1a82e02.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.
          ⚠ BACKEND ROLLBACK is `git reset --hard fc78ce1` then restart.

          DATABASE BACKUPS — ⚠⚠ KEEP ALL OF THESE:
            BOTH Trace_MaterialDetails_SP.bak-S113-{DEV,PROD}.txt
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
          ⚠⚠ NEITHER CLIENT HAS EVER RELEASED AN INTERMEDIATE. That is
            why P184 has banked nothing on prod. → S115's gate.
          ⚠ SANDBOXES ON PROD: 464 test260703@ and 465 test260704b@.
            ⚠⚠ 465 IS THE ONE WITH PRODUCT-SIDE ALLOCATION HISTORY.
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
✓ ALL THREE INTERMEDIATE-BLOCK TEMPLATES ARE SCREEN-PROVEN (S113).
⚠ THREE MORE INTERMEDIATE CONTROLS EXIST AND ARE IN NO DOCUMENT:
    edit-mlc.component.html:223 · edit-mlo.component.html:319 ·
    edit-closed-mlcs.component.html:77 — all <mat-label>. → P182.
```

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ `hostname` AND `git log --oneline -1` AT THE TOP OF EVERY MAC BLOCK.
  ⚠⚠ THE MAC AND THE BOXES DO NOT SHARE A COMMAND VOCABULARY. Two
    commands failed on the Mac in S114 for this reason — `hostname -I`
    and `cat -A`, both GNU-only. BOTH FAILED LOUDLY.
    ▶ THE ONE TO WATCH IS `sed -i`, WHICH EXISTS ON BOTH AND BEHAVES
      DIFFERENTLY. BSD requires an argument to -i; GNU does not.

---

## ⚠⚠ THE MEASUREMENT THAT MATTERS — P184, PROVEN IN S114

```
THE DEFECT, IN api/models/MaterialsProductsReleased.js — THE ADDRESSES
ARE READ, NOT QUOTED FROM A DOCUMENT:
  :239  _ratio = Number(_lot.qty) / Number(_lot.recieved_qty)
  :246  inventory_units −= Number(data.qty_allocated) * _ratio
  :251-254  THE CLAMP DOES THE SAME THING when the lot is short.
  ⚠ PLAN SAID :262 AND :228/:256. ⚠⚠ :228 IS THE MATERIAL CLAMP.
    Patching there would have hit the clean branch.

PROVEN ON dev 474 MO-0006, RELEASED IN S114 FOR THIS PURPOSE:
  typed          1.793 Kg          (auto-filled)
  _ratio         41 ÷ 15.17        = 2.7027027…
  subtracted     1.793 × 2.7027027 = 4.845945945…
  STORED         47 − 4.845945945  = 42.15405405405406
  TRUE ANSWER    47 − 4.846        = 42.154
  ⚠⚠ A WRITE, NOT A DISPLAY. THAT FIGURE IS THE CORE STOCK LINE.

✓ THE CONTROLS WERE EXACT AND THEY BRACKET IT:
    Ginger Powder  9696.983 − 701.190 = 8995.793   EXACT
    Pouch          9750 − 1323        = 8427       EXACT
    receipt        prev_received_qty 2.59 → 4.383  EXACT (Kg + Kg)
  ▶ EVERY LIKE-FOR-LIKE SUM IS EXACT. THE ONLY FIGURE WITH A TAIL IS
    THE ONLY ONE RECONSTRUCTED FROM A WEIGHT.

⚠⚠ THE ROUND-RATIO ROWS PROVED NOTHING, AND THEY WERE CHECKED FIRST.
  IP2 (3700) and IP3 (3702) were released the same afternoon at
  10 Kg/unit. Both reconcile perfectly: 30÷10=3, 70÷10=7. TRAPS 9 —
  at 10:1 the ugly route and the honest route are indistinguishable.
  ▶ ONLY THE 0.37 FIXTURE COULD FAIL, AND IT DID.

⚠ THE WRONG VALUE IS STILL IN THE ROW ON DEV. Left deliberately as the
  before picture. ▶ HEAL IT WHEN THE FIX IS PROVEN, not before.
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
                     ✓ MEASURED S114 — dev 127 rows: 111 material, 16
                       product. NO ORPHANS. ⚠ NOW HAD SAID 113 SINCE
                       S112; FOURTEEN ROWS WERE ADDED IN BETWEEN.
                       ▶ RE-COUNT AT THE GATE. DO NOT CARRY IT FORWARD.
                     ⚠ qty_allocated_units IS 0 ON ALL 127 ROWS.
                       ⚠⚠ ITS DEFAULT IS 0 WHERE qty_allocated's IS NULL.
                         SO AN OMITTED WRITE BANKS A ZERO, INDISTINGUISH-
                         ABLE FROM A REAL ZERO. TRAPS 3's shape.
                         ▶ A ZERO AT THE S115 GATE IS A FAILURE.
                     ✓✓ qty_allocated IS SUMMED AS Kg IN ALL SIX READ
                       SITES AND LEFT AS Kg. READ IN FULL, S113:
                         Formulations.js :1103 :1136 :1190
                           ⚠ NOW SAID :1188. MEASURED :1190 IN S114.
                         MLOManagement.js :1097 :1102 :1107
                       ▶ S115 DOES NOT TOUCH THEM, so long as
                         qty_allocated STAYS KILOGRAMS.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG) ·
                     prev_received_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty`.

mlomanagement        qty (UNITS since S41) · received_qty (KG) ·
                     received_units (UNITS)

subrecipeformulation qty (KG) · ship_qty (UNITS)
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX.
                     ⚠⚠ BOTH ARE STORED AND BOTH ARE SCALED SEPARATELY
                       AT Formulations.js :1157 AND :1159. THEY AGREE
                       TODAY. NOTHING GUARANTEES THEY AGREE TOMORROW.
                       ▶ THAT IS WHAT MINTY'S S114 DESIGN REMOVES.

formulations         inventory (KG) · inventory_units (UNITS) · batch_qty
                     ⚠ batch_qty IS SHIPPING UNITS PER BATCH, served by
                       WhC_GetMoDetails_SP ALIASED as formula_id__batch_qty.

fopackaging          formulation_id ← NOT `formula_id`
                     wgt_kgs_per_unit ON THE whd_flag ROW IS THE ONLY
                     PLACE A UNIT WEIGHT IS HELD ANYWHERE.
                     ⚠⚠ IT IS **NOT** IN SCOPE inside
                       getFormulaByIdForReleaseMaterial's formulation
                       loop. → S115 MUST BRING IT IN. MEASURED S114.

company              company_name  ← NOT `name`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
Trace_MaterialDetails_SP  ✓ JR23, BOTH BOXES. S113.
WhC_GetMoIntermediateProducts_SP   ✓ JR22, BOTH BOXES.
  ⚠⚠ IT ALIASES EVERYTHING. ▶ FEEDS THE INTERMEDIATE PRODUCTS BLOCK.
WhC_GetFormulaIntermediateProducts ✓ JR22, BOTH BOXES.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. undefined, SILENTLY.
  ▶ FEEDS matList / formulaList / packList — THE BATCH MATERIALS BLOCK.
Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20, and → S116.
  ▶ intermediate_prd_su and SOH_su. ⚠ SOH_su IS DEPENDENT.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE.
Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS. → S116.
Trace_ProductOneStepForwardIP_SP · ...ReleaseDetails_SP  → S116.
WhC_GetMoProductReceivingDetails_SP  ✓ receiveproducts.qty. JR21.
WhC_GetMoDetails_SP  ✓ formula_id__batch_qty. ⚠ THE ALIAS IS THE POINT.

⚠ db-definitions-S93.txt IS STALE ON NINE OBJECTS. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 4d43bd4 on both boxes.
FRONTEND   ✓ NOTHING PENDING. 4910b46d on both boxes.
DATABASE   ⚠⚠ THE COLUMN ALTER IS DEV-ONLY AND THAT IS DELIBERATE.
             It lands on prod with the write path in S115.
             ▶ THIS IS NOT A PENDING PROMOTION. It is a sequenced gate.
DOCS       ⚠ S114's OUTPUT PENDING COMMIT:
             NOW.md · PLAN.md · UNITS-BIBLE.txt + .xlsx
             Section_5.md — J124 to merge.
           ⚠⚠ WRITE THE GITHUB DOCS LINE FROM GITHUB AFTER THE PUSH.
```

---

## ⚠⚠ RULINGS MADE IN S114 — RECORDED, NOT PENDING

```
1  ⚠⚠ THE UNITS CAPTURE IS REDESIGNED. MINTY, S114, AND IT SUPERSEDES
   PLAN's SEVEN-PIECE FRAMING AND P188 BOTH.
     "If the operator types units and the Kg is derived, the screen is
      unit-anchored and the Kg is a display."
   ▶ THE REQUIREMENT IS COMPUTED IN UNITS — ship_qty × (MO ÷ batch) —
     AND THE Kg IS DERIVED FROM IT BY MULTIPLYING BY wgt_kgs_per_unit.
     NOT read from the stored qty column.
   ▶ BOTH ARE STORED. NEITHER IS RECONSTRUCTED FROM THE OTHER.
   ⚠⚠ THIS DISSOLVES P188. There is no units-minus-Kg subtraction left
     to design around, because both sides become units.
   ▶ AND IT REMOVES A SECOND STORED FIGURE FROM THE PATH — see the
     schema note on subrecipeformulation.

2  ⚠⚠ MINTY'S OWN FRAMING OF WHY, AND IT IS THE CLEAREST STATEMENT OF
   THIS DEFECT ANYONE HAS MADE:
     A PRODUCT LEAVING TO A CUSTOMER captures a unit count (the DO,
     qtyWdu, fixed S109). THE SAME PRODUCT LEAVING INTO ANOTHER
     PRODUCT'S RECIPE DOES NOT.
   ▶ SAME SHELF, SAME GOODS, SAME PHYSICAL ACT. One path records what
     happened; the other reconstructs it.
   ▶ THEREFORE THE DISPATCH SCREEN IS THE TEMPLATE, NOT AN INVENTION.

3  ✓ MO-0006 WAS SPENT DELIBERATELY, WITH A PREDICTION WRITTEN FIRST.
   ⚠⚠ MO-0004 IS NOW THE LAST UNRELEASED INTERMEDIATE MO.

4  ✓ THE INDICATOR FIX WENT TO PROD THE SAME NIGHT. Preventive, not
   corrective — neither client has intermediates, so no client row can
   reach the patched path. ▶ RECORDED AS PREVENTIVE.

5  ⚠ THE BEFORE PICTURE IS PART OF THE PROOF. Minty rejected a pass
   that could not have failed and asked for the old build to be
   re-served. → LESSONS 1, and it should govern every future screen
   check where only a COLOUR or a FORMAT moves.
```

---

## QUEUE
⚠ New items at the bottom with the next free number. Claude never renumbers.
Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build. ⚠ IT READS 9bce0238.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.  P22  Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod. → P10.
      ⚠ SEEN AGAIN S114 — every IP-0.37 row renders "FO-0004 null".
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
      ⚠ dev 12 updates. prod 46. ⚠⚠ TWENTY DAYS. TWO CLIENTS ON PROD.
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
        material-traceability-details html:113-125 and html:191-216
        Traceability.js — @returnedQty and @mprIDs, computed, never used
      ⚠⚠ NEW S114: MaterialsProductsReleased.js :83-98 — the OLD
        single-release function, same shape as the live V2 loop,
        inventory only, no units. ⚠ IT MUST NOT BE MISTAKEN FOR THE
        LIVE PATH IN S115. The live one is the block from :179 down.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF AN EIGHTH TIME IN S114 — the comment at
        Formulations.js:1159 CALLS ITSELF A STOPGAP, which is what told
        us the S112 workaround was the thing Minty's design removes.
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
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. → S116.
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
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT
      SHARE A COMPANY-ID NAMESPACE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins
      fopackaging with NO whd_flag filter. → S116.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. → S116.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. ▶ THE RETURN PATH.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL. THE SIGN
      IS INVERTED. ⚠⚠ LIVE ON BOTH CLIENTS.
      ✓✓ RE-CONFIRMED S114 BY GREP: :1099 :1132 :1186 declare returnSum
        and NOTHING assigns it; :1125 :1161 :1206 write it out as 0.
        MLOManagement.js:1112 DOES assign it.
      ▶ THE RETURN PATH, and Minty ruled it LAST.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ THE RETURN PATH.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. ▶ OWN SITTING.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. ▶ RETURN PATH. HIGH.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ ROW 48.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. ▶ MINTY'S CALL.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT. LOW.
P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW. LOW.
P174  ⚠ edit-mlc.component.ts:372 WRITES A FORM CONTROL BACK INTO
      mlcDetails.batches. ⚠ STILL NOT INVESTIGATED.
P175  ⚠ getFormulaByIdForReleaseMaterial :1092 gates on
      `typeof x != undefined`. A gate that cannot fail. LOW.
P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` is absent
      from both boxes; S114 used the python3 one-liner twice more.
      ⚠⚠ AND S114 ADDS THE MISSING HALF: THE PROOF OF A DEPLOY IS
        `diff -r <artifact-dir> /var/www/html` RETURNING NOTHING.
        NOT the bundle filenames — those differ between dev and prod
        builds of the SAME COMMIT. ▶ RECORD BOTH IN 3B.4. MEDIUM.
P178  ⚠⚠ RE-COUNTED AT THE S114 CLOSE AND BOTH FIGURES GREW AGAIN:
      DEV 50 dist-dev-* FOLDERS (was 41 at S113). PROD 26 (was 24).
      ⚠ NINE ADDED ON DEV IN ONE DAY.
      ✓ /tmp/*.js IS NOW ZERO ON BOTH BOXES — somebody tidied and did
        not record it. ⚠ THIRD TIME A TIDY LIST WAS COPIED FORWARD
        RATHER THAN READ.
      ▶ PROPOSED RULE, AWAITING MINTY: KEEP THE LAST THREE GENERATIONS
        OF dist-* AND www-html.bak-*, DELETE THE REST, EXECUTED AT
        EVERY CLOSE. ⚠ A RULE SOMEBODY CAN APPLY WITHOUT JUDGEMENT.
        MINTY RULES THE NUMBER.
P179  ⚠ start-mlc.component.html:198 READS `formulations_myCodee` —
      THREE E's. Renders blank, silently. One-character fix. LOW.
P180  ⚠ THE BUILD WORKFLOW WARNS Node.js 20 is deprecated. LOW.
P182  ⚠ THREE MORE INTERMEDIATE CONTROLS IN NO DOCUMENT. MEDIUM.
P184  ⚠⚠ THE RELEASE WRITE PATH DERIVES UNITS FROM A WEIGHT AND
      SUBTRACTS THEM FROM THE CORE STOCK LINE.
      ✓✓ NO LONGER A CLAIM. MEASURED IN S114 — 42.15405405405406
        STORED WHERE 42.154 IS TRUE. → the measurement block above.
      ⚠ THE WRONG VALUE IS STILL IN THE ROW ON DEV, DELIBERATELY.
      ▶ CLOSES AS PART OF S115. HIGH.
P185  ⚠ eval() IS USED TO SUM QUANTITIES ON THE RELEASE SCREEN.
      ⚠⚠ IT IS FIVE SITES, NOT THREE — :239 :322 :399 :439 :456.
      MEASURED S114. ▶ REPLACE WITH reduce IN THE SAME PASS. MEDIUM.
P188  ⚠⚠ DISSOLVED BY MINTY'S S114 DESIGN. If the screen is
      unit-anchored, remainToFill is units minus units and there is no
      basis mismatch to design around. ▶ CLOSES WITH S115.
P189  ⚠ MLOManagement.js :1097 AND :1102 SUM THE SAME MATERIAL TWICE
      UNDER DIFFERENT GUARDS. ⚠ NOT INVESTIGATED. LOW.
P190  ⚠ material-traceability-details.component.ts:171 subtracts two
      VARCHAR strings. Works by coercion. LOW.
```

### NEW IN S114

```
P191  ⚠⚠ THE RELEASE SCREEN HAS A LOT-CODE SCANNER AND IT IS IN NO
      DOCUMENT. release-mat-details.component.ts:591 scanLotCode, with
      a "Scan lot code…" input rendered above every material block.
      ✓ IT IS MATERIALS-ONLY — it reads this.matList[materialIndex]
        directly and guards on recLotList, so it can never see a
        product line. THAT IS WHY ITS final_qty − released_qty AT :599
        IS CORRECT: Kg minus Kg.
      ⚠ Claude flagged it as a fourth basis-mismatch site and WITHDREW
        the alarm on reading it. Recorded so nobody re-raises it.
      ▶ BUT IT IS A REAL FEATURE IN NO MAP. → its own sitting.

P192  ⚠ final_qty IS ALSO BUILT IN THE FRONTEND, FROM `batches`.
      release-mat-details.component.ts :1071 :1083 :1095
        Number(x.qty * this.mlcDetails.batches) + ...
      ⚠⚠ THE STORED ROUNDED COLUMN RULES 7 FORBIDS. The BACKEND was
        fixed in S110 to scale by getFactor(); this screen computes its
        own on some path.
      ⚠ WHICH PATH, AND WHETHER IT EVER WINS, IS UNKNOWN.
      ▶ READ BEFORE S115 TOUCHES final_qty. MEDIUM.

P193  ⚠ released_qty IS ACCUMULATED IN THE FRONTEND AFTER EACH RELEASE.
      release-mat-details.component.ts :683 material · :775 pack ·
      :866 product —  released_qty = released_qty + response.qty
      ⚠⚠ ONCE THE TYPED FIGURE IS A UNIT COUNT, :866 ADDS UNITS INTO A
        Kg RUNNING TOTAL. ▶ IT IS PART OF S115, NOT A SEPARATE JOB.

P194  ⚠ THE oldRecProducts BLOCK ON THE RELEASE SCREEN RENDERS PRIOR
      ALLOCATIONS FROM qty_allocated — KILOGRAMS — read-only.
      release-mat-details.component.html :129-136
      ⚠ A FOURTH DISPLAY SITE ON THAT SCREEN, IN NO DOCUMENT.
      ▶ IT SHOULD SHOW units# (Kg) ONCE THE COLUMN IS POPULATED. LOW.

P195  ⚠ THE PER-LOT ERROR MESSAGE READS remaining_qty IN Kg —
      html:155. Once the box holds units, the message contradicts the
      box above it. ▶ RIDES WITH S115.
```

### ✓ CLOSED IN S114 — DELETE THESE LINES AT S115 CLOSE

```
P186 · P187 · P181   ✓ closed in S113, still listed.
P177 · P183          ✓ closed in S112, still listed.
P160 · P162          ✓ closed in S111, still listed.
P151 · P157          ✓ closed in S110, still listed.
P147 · P161          ✓ closed in S109, still listed.
P104 · P150          ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

⚠⚠ READ THE DIRECTORY AT THE CLOSE. DO NOT COPY THIS LIST FORWARD.
  ⚠⚠ THIS INSTRUCTION WAS AT THE TOP OF S113's LIST AND THE LIST
    UNDERNEATH IT WAS STILL STALE. S114 FOUND SEVEN ZIPS ALREADY
    DELETED AND FIFTEEN /tmp SCRIPTS ALREADY GONE.
    ▶ THE WARNING WAS BEING COPIED FORWARD ALONG WITH THE THING IT
      WARNS ABOUT. COUNT IT, DO NOT DESCRIBE IT.

```
COUNTED AT THE S114 CLOSE:
  MAC    6 dist-*.zip in ~/Downloads
  DEV    50 dist-dev-* folders · 0 /tmp/*.js
  PROD   26 dist-prod-* folders · 0 /tmp/*.js

KEEP, WHATEVER THE RULE:
  dist-dev-4910b46d* · www-html.bak-dev-4910b46d*      LIVE
  dist-prod-4910b46d* · www-html.bak-prod-4910b46d*    LIVE
  www-html.bak-{dev,prod}-e1a82e02*                    ROLLBACK
  ~/mprrecievelots-before-S112-DEV.sql   ⚠⚠ THE ONLY COLUMN ROLLBACK
  ALL *.bak-S106/S109/S110/S111/S113 DATABASE BACKUPS, BOTH BOXES
  ~/mo-0001-before-heal-S93.txt on prod  → P94, decide separately

▶ THE RULE ITSELF IS P178 AND IT IS MINTY'S TO SET.
```

---

## THE LESSONS S114 EARNED

```
1  ⚠⚠ A PASS THAT COULD NOT HAVE FAILED IS NOT A PASS, AND MINTY
   CAUGHT IT. Claude called the indicator fix proven because the screen
   read 1.793/1.793 GREEN. But the NUMBERS are identical before and
   after — only the COLOUR moves — so that screen looks the same
   whether the patch worked or not.
   ▶ THE OLD BUILD WAS RE-SERVED FROM ITS ROLLBACK FOLDER AND THE SAME
     SCREEN READ ORANGE. That is the proof.
   ▶ WHEN A FIX CHANGES A COLOUR, A FORMAT OR A LABEL RATHER THAN A
     NUMBER, THE BEFORE PICTURE IS NOT OPTIONAL. The rollback folder
     makes it a two-minute operation.
   ⚠ FIFTH MIS-SCOPED CHECK THIS CAMPAIGN.

2  ⚠⚠ TWO MORE CHECKS HAD WRONG EXPECTED VALUES WHILE BEING SOUND.
   Claude predicted "+8 insertions" and got +7 — its own arithmetic.
   Claude predicted prod's bundle filenames would match dev's and read
   the difference as a FAILED DEPLOY.
   ▶ SEVENTH AND EIGHTH INSTANCES. SAY WHAT A PASS IS *AND WHY*, AND
     WHEN THE PREDICTION FAILS, SUSPECT THE PREDICTION FIRST.
   ✓ THE REAL PROOF WAS `diff -r`, WHICH RETURNED NOTHING. → P176.

3  ⚠⚠ THE MEASUREMENT THAT MATTERED WAS FREE, AND IT WAS FOUND BY
   COUNTING ROWS RATHER THAN ASSUMING THEM. mprrecievelots was 127, not
   the 113 the documents carried — and two of the fourteen new rows
   were PRODUCT releases Minty had made that afternoon. THE WRITE PATH
   HAD ALREADY RUN, TWICE, AND ITS RESULT WAS SITTING IN A ROW.
   ▶ BEFORE SPENDING A FIXTURE, ASK WHETHER THE EVIDENCE ALREADY EXISTS.

4  ⚠⚠ AND THOSE TWO FREE ROWS PROVED NOTHING, WHICH IS THE OTHER HALF.
   IP2 and IP3 are 10 Kg per unit. Both reconciled perfectly. AT 10:1
   THE DIVISION AND THE STORED READ ARE INDISTINGUISHABLE — TRAPS 9.
   ▶ ONLY THE 0.37 FIXTURE COULD FAIL. IT WAS SPENT DELIBERATELY, WITH
     THE PREDICTION WRITTEN BEFORE THE WRITE, AND IT FAILED EXACTLY AS
     PREDICTED. THAT IS WHAT A FIXTURE IS FOR.

5  ⚠⚠ THE DOMAIN EXPERT REDESIGNED THE JOB AND THE DESIGN IS BETTER.
   Claude carried PLAN's seven-piece framing plus an eighth piece
   (P188). Minty's question — "where does the Kg figure come from?" —
   exposed that final_qty_kg is scaled from a SECOND STORED COLUMN, and
   his answer removes it: compute in units, derive the Kg.
   ▶ P188 DISSOLVES. Two figures that must agree become one and a
     multiplication.
   ⚠ THIRD TIME THIS CAMPAIGN THAT MINTY'S READING BEAT THE PLAN.

6  ⚠ FOUR SITES ON ONE SCREEN WERE IN NO DOCUMENT — the scanner, the
   frontend final_qty, the frontend released_qty accumulation, and the
   oldRecProducts block. THREE WERE FOUND BY READING THE FILE, ONE BY
   READING THE TEMPLATE.
   ▶ P191-P195. ⚠ THEY ARE LISTED, NOT CHASED. That is the discipline
     that stops a session digressing — and it is the answer to why five
     sessions have each found something new.

7  ⚠ "DONE" AND "DEPLOYED" CAME APART. The prod deploy was reported
   complete and had not run — no zip on the box, no backup folder.
   ▶ ONE COMMAND SETTLED IT: `ls -1dt www-html.bak-* | head -1`.
   ⚠ AND THE TIDY WAS STOPPED BECAUSE OF IT. Deleting older builds
     around a deploy that never happened is how a rollback goes missing.
   ▶ VERIFY THE DEPLOY BEFORE TIDYING. ALWAYS THAT ORDER.

8  ⚠ THE MAC IS NOT A LINUX BOX. `hostname -I` and `cat -A` both failed
   on it in one session. Both loud. ▶ THE DANGEROUS ONE IS `sed -i`,
   which exists on both and takes different arguments.
```
