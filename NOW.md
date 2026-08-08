# NOW

Last rewritten: S108, 7 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

⚠⚠ S108 SHIPPED NO CODE. Both boxes are exactly as S107 left them.
  It was a survey session and the survey is COMPLETE — database,
  schema and frontend. 47 sites mapped.

⚠⚠ THERE IS A NEW DOCUMENT. UNITS-BIBLE.txt / .xlsx in the docs repo.
  ▶ IT IS MINTY'S. Part 1 changes only on his instruction.
  ▶ IT REPLACES GUESSING ABOUT WHERE A UNIT FIGURE COMES FROM.

---

## STATE
⚠ READ OFF BOTH BOXES AT S108 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺260 · 200
          frontend SERVING dev-a94f39c3b2bf
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 51e9f4e · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 8 updates pending · restart required
          ✓ ↺ HELD AT 260 THROUGH S106, S107 AND S108.

PROD      15.157.38.101 · pm2 abletrace-backend ↺340 · 200
          TWO LIVE CLIENTS · SERVING prod-a94f39c3b2bf
          backend HEAD 51e9f4e · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 28 updates pending — NOT 42. CORRECTED S108. → P102
          ⚠ ↺ HELD AT 340.
```

```
✓ BACKENDS MATCH     dev 51e9f4e        prod 51e9f4e
✓ FRONTENDS MATCH    dev a94f39c3b2bf   prod a94f39c3b2bf
✓ THE VIEW MATCHES   3 divisions on each box
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = a94f39c3   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = 51e9f4e
          docs     main = ⚠ WRITE THIS FROM GITHUB AT THE NEXT OPEN.
          ⚠ RUN #56 (30b2ddd4) MAY STILL BE QUEUED AND IS SUPERSEDED.
            ▶ NEVER DEPLOY A dist-*-30b2ddd* ZIP. Read the commit stamp
              in the filename, not the position in an ls. → J117.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-a94f39c3b2bf
          prod  /home/ubuntu/www-html.bak-prod-a94f39c3b2bf
          ⚠ EACH HOLDS THE BUILD IT REPLACED, NOT THE ONE IT IS NAMED
            AFTER. ⚠ READ OFF THE BOX AT CLOSE, never from the label.

          DATABASE BACKUPS on each box — ⚠⚠ KEEP ALL OF THESE:
            Trace_ProductHeaderView.bak-S107-{DEV,PROD}.txt
            WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt (+ .after-)
          ⚠ THE S107 VIEW BACKUPS HOLD THE SIX-DIVISION VERSION. The
            live object has three. RE-CAPTURE BEFORE THE NEXT EDIT.
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
                              ZERO MR rows.
            469  HAGENSBORG   7 MOs created, none run. ZERO release
                              rows. 24 MR rows, ALL MATERIAL.
                              ⚠ Their MOs carry NO intermediates.
          ⚠ 464 test260703@ and 465 test260704b@ are SANDBOXES on prod.
            ▶ USE 464 FOR PROD SCREEN CHECKS.

⚠⚠ NEW IN S108 — THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE.
  DEV 469 = test260710@.  PROD 469 = HAGENSBORG.
  Dev also carries 466 "Test Glutenul", which is NOT Glutenull.
  ▶ NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX. → P156

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY BLOCK. It caught TWO
    wrong-box runs in S108, both harmless, both read-only.
```

---

## THE FIXTURES — ⚠ BUILT IN S108. DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE INTERMEDIATE FIXTURE

```
⚠⚠ NEW IN S108 AND IT IS THE ONLY ONE OF ITS KIND ON EITHER BOX.

IP-0.37      FO-0004   0.37 Kg/unit   19 shipping units per batch
             Single level, Internal container. Recipe: Ginger Powder.
Parent-0.53  FO-0005   0.53 Kg/unit   13 shipping units per batch
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units

MO-0003  IP-0.37, 41 units, COMPLETE, lot Pdt-260807-1
         ⚠ Released 15.171 Kg of Ginger Powder against a true
           requirement of 15.170. THE OVER-RELEASE IS BANKED and is
           evidence for the calculation fix.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. IT IS THE BEFORE PICTURE.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS, so nearly any MO
  quantity produces a repeating decimal. TRAPS 9: a round ratio hides
  a division entirely. THAT IS WHY THESE NUMBERS.

THREE PROOFS VISIBLE ON MO-0004 TODAY, BEFORE ANY CODE CHANGE:
  1  Plan Quantity        23.000# (2303.910 Kg)
     Ginger Powder req.            2303.609 Kg
     ⚠ 0.301 Kg APART ON THE SAME PAGE. Same recipe, one uses the MO,
       the other uses the rounded batches 1.769. True factor 23/13.
  2  IP-0.37 required     5.891 Kg  ⚠ Kg under a units header.
                                      True: 9 × 23/13 = 15.923 units.
  3  WH Stock in # (UOM)  15.170 Kg ⚠ Kg. The warehouse holds 41 units.

⚠⚠ THE CONTROL — Pouch 4347.000 Ea = 23 × 9 × 7 × 3, from the MO
  quantity. IT MUST NOT MOVE AT ANY STEP. If a packaging figure
  shifts, THE FIX IS WRONG, NOT THE DATA.

⚠ 474 STILL HAS NO MATERIAL MR. → P147, one minute.
⚠ 474 HAS NO MULTI-RECEIPT MO. Step 4a cannot be proven without one.
```

### COMPANY 464 · test260703 · on DEV — THE OLDER FIXTURES

```
FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007
  DISPATCH ORDERS IN ALL THREE BUCKET STATES:
    DO-0007  shipped · DO-0010, DO-0011  on packing slip · DO-0016  DO only
  ⚠ DO NOT DELETE DO-0016.
  ⚠ DO-0008 and DO-0009 carry packing_units 0.5 — THE FRACTIONAL
    FIXTURE. Step 3 needs them.

⚠⚠ MO-0002 ON 464 NOW CARRIES **TWO** 2 Kg GINGER POWDER RETURNS.
  ▶ IT IS THE PROOF FOR P168 — two returns, one row displayed, the
    release figure moved once. ⚠⚠ DO NOT CLEAR IT.
  ⚠ Its five other materials held steady throughout, which is what
    makes the isolation clean.

MO-0011  ⚠ NEW IN S108. A 2 Kg GINGER POWDER RETURN.
  Ginger Powder 9294.861 → 9296.861 Kg. The material return path is
  PROVEN CORRECT by this.
  ▶ IT IS THE FIXTURE FOR STEP 1, THE returnSum BUG. DO NOT CLEAR IT.

⚠ 464 IS A DIRTY BASELINE — MAT-6 missing its Sesame (S73), MAT-5
  carrying Eggs (S78), FO-0005 fork residue (S77).
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
⚠⚠ THE FULL PICTURE IS NOW IN UNITS-BIBLE.txt PART 1. What follows is
  only what the bible does not cover.

mprrecievelots       qty_allocated (KG) · MPR_id · Rec_Lot_id ·
                     material_id · Rec_Product_id · formula_id
                     ⚠⚠ TWO PARALLEL FK PAIRS ON ONE ROW, AND WHICH
                       PAIR IS POPULATED ENCODES THE RELEASE TYPE.
                       material_id + Rec_Lot_id  = MATERIAL
                       formula_id  + Rec_Product_id = PRODUCT
                       Dev: 95 material, 14 product, NO overlaps.
                     ⚠ NO UNIT COLUMN. → STEP 6.

returnmpreceivelots  ⚠⚠ AN EXACT TWIN OF THE ABOVE, column for column.
                     qty_return (KG) · ReturnMP_id · same four FKs.
                     ⚠ IN NO DOCUMENT UNTIL S108. Twenty sessions of
                       quantity work never named it.
                     ⚠ ONE ROW ON EACH BOX. Both material. NO PRODUCT
                       RETURN HAS EVER BEEN RECORDED ANYWHERE.

rejectmaterialandproduct  qty_rejected (KG) · qty_rejected_units
                     ⚠ `type` returns 'Product' or 'Material'.
                     ⚠ `status` returns 'Active', NOT a number.
                     ⚠⚠ MATERIAL MRs CARRY NO mlc_id. PRODUCT MRs
                       ALWAYS DO. Clean across both prod companies.

rejectedmaterial · rejectedproduct
                     ⚠ EMPTY ON BOTH BOXES. The pre-merge design,
                       superseded by rejectmaterialandproduct.
                     ▶ RETIREMENT QUESTION WITH P109. Not campaign work.

⚠ THREE TABLES STILL UNCOUNTED — do_receive_products.qty_to_dispatch ·
  mlodetails.rcp_qty · forecastsales.quantity. Row counts, minutes.

company              company_name  ← NOT `name`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE VIEW <name>\G"

⚠⚠ THE FULL SURVEY IS IN QUANTITY-SURVEY-S108.md. 35 procedures and
  9 views inventoried. 11 touch a per-unit weight. 12 read in full.
  THREE DIVIDE:
    Trace_ProductHeaderView              3 cells   → STEP 2.9 + STEP 6
    Trace_ProductOneStepBackwardIP_SP    ⚠⚠ NEW S108 → STEP 6
    Trace_ProductOneStepForwardIP_SP     ⚠⚠ NEW S108 → STEP 6

Trace_ProductHeaderView   ⚠ THREE DIVISIONS REMAIN.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE. The do_products CTE defines
    its own alias `qty_shipped` summing do.qty_to_ship — KG. The real
    column is UNITS. RESOLVE EVERY NAME TO ITS DEFINITION.
  ⚠ P136: it returns DUPLICATE ROWS. Pre-existing.
    ⚠ MAY SHARE A CAUSE with the missing whd_flag filters found S108 —
      THREE objects join fopackaging without picking the shipping-unit
      row. NOT PROVEN. Do not write it up as fact.
  ⚠ ONE CONSUMER: product-traceability-details.component.ts.

Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT.
  Divides qty_allocated, AND joins fopackaging with NO whd_flag filter.
  ✓ ITS SIBLING CARRIES THE FILTER, WITH A COMMENT. Copy it.
  ⚠ @formulationId is SET and NEVER USED.

WhC_GetMoDetails_SP  ✓ received_units PRESENT. JR17 CONFIRMED S108.
WhC_GetMoPackagingConfiguration_SP  ✓ READ IN FULL S108. CLEAN.
  ⚠ NOW PREVIOUSLY SAID "NEVER INSPECTED IN FULL". CORRECTED.

⚠ db-definitions-S93.txt IS STALE ON FOUR OBJECTS. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 51e9f4e on both boxes.
FRONTEND   ✓ NOTHING PENDING. a94f39c3 on both boxes.
DATABASE   ✓ NOTHING PENDING.
DOCS       ⚠ S108's OUTPUT PENDING COMMIT:
             UNITS-BIBLE.txt + .xlsx        ⚠ NEW FILES
             QUANTITY-SURVEY-S108.md        the evidence
             CORRECTION-PLAN.md             the phase reasoning
             RULES.md                       ⚠ RULE 7 REWRITE
             NOW.md · PLAN.md               rewritten whole
             Section_5.md                   J118
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
P64   Product label prints "null" for Ext ID twice, on prod.
      ⚠ SEEN TWICE AGAIN IN S108. → P10 family.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.  P85  Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES — 466, 469, 470, 472, 473.
      ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠ PROD 28 UPDATES — CORRECTED S108, was recorded as 42. Dev 8.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
      ⚠⚠ FOURTEEN DAYS RUNNING. TWO CLIENTS ON PROD.
P104  ⚠ CORRECTED S108. It said NO INTERMEDIATE FIXTURE EXISTS ON DEV.
      FOURTEEN LINKS EXIST. What was missing was a USABLE one — and
      474 NOW HAS ONE. ▶ THIS ITEM IS CLOSED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ ALSO rejectedmaterial and rejectedproduct — empty on both.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠ FOUR THINGS WILL MEET IT: TRAPS 3 on the new column · J97's
        multiple invoices pointing at a child table · P138 · P137.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS. ⚠ ADD getWdu once html:258 goes.
      ⚠ ADD PopUps/add-dispatch (v1) — whole component, never opened.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE. ✓ PAID FOR ITSELF TWICE.
P119  Back up the database's own code into the repo. ⚠ STALE ON FOUR.
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
P135  ⚠ THE LAST P82 ITEM. THREE CELLS LEFT OF SIX.
      ⚠ SCOPE CORRECTED S108: qty_misc_release_su is a straight
        repoint plus a type guard — NOT a backfill. The backfill
        question is CLOSED by measurement.
      ▶ PLAN STEPS 1.9 AND 5.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
      ⚠ TWO CLIENTS SHARE ONE SEQUENCE, and P111 will read those
        numbers.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
      ⚠⚠ DO NOT "FIX" THESE LINES.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT. ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
      ▶ FOURTH INSTANCE of a screen that looks operable with no
        working path behind it — J86, J92, PLAN step 7a, this.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. ⚠ ASK MINTY. LOW.
P147  NO MATERIAL MR ON DEV COMPANY 474. ▶ CREATE ONE. One minute.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P150  ⚠⚠ THE SURVEY. ✓ DONE S108 — DATABASE, SCHEMA AND FRONTEND.
      ▶ THE OUTPUT IS UNITS-BIBLE.txt AND QUANTITY-SURVEY-S108.md.
      ▶ THIS ITEM IS CLOSED.
P151  EDIT-MLC AND THE YIELD DIALOG.
      ✓ THE YIELD DIALOG — DONE S107.
      ⚠ :298 completeUnit → PLAN STEP 1.2
      ⚠ html:258 + getWdu → PLAN STEP 3a
      ⚠ :295 lotReceived is DEAD. → P115.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      ▶ FIX IT OR WARN IN ITS OWN OUTPUT. ⚠ IT CORRUPTS EVIDENCE.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. ⚠ ASK MINTY. LOW.
P155  A Mac push does not update prod's origin/main until something
      fetches. ▶ `git fetch origin` FIRST, ALWAYS. LOW.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT.
      ⚠⚠ WIDENED S108: THE TWO BOXES DO NOT SHARE A COMPANY-ID
        NAMESPACE. Dev 469 = test260710@. Prod 469 = HAGENSBORG. Dev
        466 = "Test Glutenul", which is not Glutenull.
      ▶ NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX.
      ▶ ACTIONS: correct 3B, re-scope P100, confirm no third company.
P157  ⚠ WhC_GetMoProductReceivingDetails_SP SERVES NO UNIT COUNT.
      ▶ PLAN STEP 3a. ⚠ NEEDS A MULTI-RECEIPT MO TO PROVE.
```

### NEW IN S108

```
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES qty_allocated,
      AND joins fopackaging with NO whd_flag filter. On a multi-level
      product it divides by an ARBITRARY packaging row and returns
      DUPLICATE ROWS. ✓ Its sibling carries the filter WITH A COMMENT.
      ⚠ @formulationId SET and NEVER USED.
      ▶ PLAN STEP 5c. MEDIUM.

P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated while
      selecting receiveproducts.qty THREE LINES AWAY.
      ⚠ Four wildcard expansions (f.*, mpr.*, rp.*, mpr1.*). Column
        names will collide. Recorded, not urgent.
      ▶ PLAN STEP 5c. MEDIUM.

P160  ⚠ WhC_GetMoIntermediateProducts_SP AND
      WhC_GetFormulaIntermediateProducts serve Kg only. ship_qty and
      inventory_units SIT UNSELECTED.
      ⚠⚠ THE Edit-Mlc SCREEN SHOWS THE INTERMEDIATE TWICE FROM TWO
        CODE PATHS — these procedures AND the JS cascade. FIXING ONE
        LEAVES THE SCREEN DISAGREEING WITH ITSELF.
      ✓ NO SCHEMA CHANGE. Both columns exist and hold correct data.
      ▶ PLAN STEP 3b/3c/3d. MEDIUM.

P161  ⚠ THREE UNCOUNTED QUANTITY TABLES — do_receive_products ·
      mlodetails · forecastsales. ▶ Row counts. Minutes. LOW.

P162  ⚠⚠ THE INGREDIENT REQUIREMENT MULTIPLIES BY THE STORED ROUNDED
      `batches` COLUMN. Minty's ruling S108: compute it live.
      ⚠⚠ SUPERSEDES THE S105 RULING. RULES 7 MUST BE REWRITTEN.
      ⚠⚠ IT MOVES NUMBERS ON A SCREEN BOTH CLIENTS USE DAILY.
        OWN SESSION, OWN GATE. ▶ PLAN STEP 4. HIGH.

P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. PROVEN ON DEV.
      3.32 Kg demonstrably in store; the picker offered nothing.
      ▶ THE PATH HAS NEVER RUN BECAUSE IT CANNOT BE RUN.
      ▶ PLAN STEP 6.3. ⚠ ONE GREP CONFIRMS THE CANDIDATE. MEDIUM.

P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL.
      Three branches. returnSum declared and never assigned.
      ⚠⚠ PROVEN ON DEV S108 WITH A CONTROL. 464 MO-0002: one 2 Kg
        return moved Ginger Powder from 122.640/122.640 to
        124.640/122.640 while FIVE OTHER MATERIALS HELD STEADY.
        Released 122.640, returned 2, so 120.640 is in the batch —
        THE SCREEN SAYS 124.640.
      ▶ THE SIGN IS INVERTED. An operator 2 Kg SHORT is told they are
        2 Kg OVER, on the screen where the release decision is made,
        with the bar full green.
      ⚠ LIVE ON BOTH CLIENTS. ✓ MLOManagement.js ~:1116 does the same
        job correctly.
      ▶ PLAN STEP 6 — ⚠ MINTY MOVED THIS TO THE RETURN CAMPAIGN. It is
        NOT fixed early. See P168 for why a half-fix is worse.

P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS, SEPARATE COMMITS.
      (a) :68 adds a product return back to formulations.inventory
          (Kg) and NEVER TOUCHES inventory_units. The unit balance
          would only ever DECREASE. ⚠ UNTESTED — a code reading.
      (b) `status` is written and NEVER DECLARED in the model, then
          FILTERED ON. ⚠ SECOND LIVE INSTANCE OF TRAPS 3.
      ▶ PLAN STEP 6.4/6.5. MEDIUM.

P166  ⚠ do-details.component.ts:30,54 — a form field NAMED ship_qty
      holds qty_to_ship, WHICH IS Kg. The name says units, the content
      is weight. Same shape as TRAPS 10, in the frontend.
      ⚠ MAY ONLY EVER DISPLAY. ▶ REVIEW, not a confirmed defect. LOW.

P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. (qty/batch) × (batch/wgt)
      in SEVEN files.
      ⚠⚠ NOT A BULK REPOINT. Each caller passes a DIFFERENT source and
        SOME DIVISIONS ARE CORRECT. J114: closed-mlcs.html:84 is right
        while :79 is wrong, same helper, adjacent lines.
      ▶ OWN SITTING. Read all seven callers, decide each, then edit.
      MEDIUM.
```

P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. A SECOND RETURN
      AGAINST THE SAME MATERIAL AND LOT MOVES STOCK, IS WRITTEN TO THE
      DATABASE, AND NEVER APPEARS on the MO or in the release figure.
      ▶ PROVEN ON DEV S108, AFTER A HARD REFRESH:
        returnmpreceivelots 634 and 635, both 2 Kg, material 8119,
        lot 11217, mlc_id 11810 — BOTH ROWS PRESENT. Stock moved
        twice, 9807.792 → 9811.792. THE MO SHOWS ONE ROW AND THE
        RELEASE FIGURE MOVED ONCE.
      ⚠⚠ A MATERIAL MOVEMENT WITH NO TRACE ON THE MANUFACTURING ORDER
        IS A TRACEABILITY GAP, IN A TRACEABILITY SYSTEM. On a recall
        that 2 Kg cannot be accounted for.
      ⚠ IT INTERACTS WITH P164 — the sign error is VISIBLE, this is
        INVISIBLE. Anyone checking the numbers finds the first and
        never suspects the second.
      ⚠⚠ THIS IS WHY MINTY MOVED THE WHOLE RETURN PATH TO LAST. Fix
        P164 alone and the screen reads 120.640 — closer to the truth
        and STILL WRONG, because this return is not counted. IT WOULD
        THEN LOOK CORRECT.
      ⚠ THE CODE HAS NOT BEEN READ. CAUSE UNKNOWN.
      ▶ PLAN STEP 6.2. HIGH, AND SURVEYED BEFORE TOUCHED.

### ✓ CLOSED IN S108 — DELETE THESE LINES AT S109 CLOSE

```
P104  ✓ CORRECTED AND CLOSED. 474 now has a usable fixture.
P150  ✓ THE SURVEY IS DONE. Output is the UNITS BIBLE.
P140 · P143 · P149   ✓ done in earlier sessions, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    ~/Trace_ProductHeaderView-S107-DEV*.txt         delete
       ~/fix-modetails-S106.sql                        delete
       ~/MLOManagement.js.bak-S105-P140                delete
       ~/Trace_ProductHeaderView.bak-S107-DEV.txt      ⚠⚠ KEEP
       ~/WhC_GetMoDetails_SP.*-S106-DEV.txt            KEEP BOTH
       ~/MLOManagement.js.bak-S105-P140-attempt2       keep, live
PROD   ~/Trace_ProductHeaderView.bak-S107-PROD.txt     ⚠⚠ KEEP
       ~/fix-modetails-S106.sql                        delete
       ~/WhC_GetMoDetails_SP.*-S106-PROD.txt           KEEP BOTH
MAC    ~/Downloads/dist-*-a94f39c3*.zip                delete
       ~/Downloads/RULES.md PLAN.md NOW.md             delete

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106 OR S107 .bak FILES. They are the only
  rollback for database objects on a LIVE CLIENT DATABASE.
```
