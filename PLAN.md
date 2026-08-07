# PLAN

Written at close of: S108 · for S109.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S108:
  "full picture before any more fixing" — the survey ran. IT IS DONE.
    Database, schema and frontend. 47 sites mapped.
  THE FOUR SOURCES — ING-REQ · PK-CASCADE · STOCK ON HAND ·
    PRD-TO-DATE. Now the UNITS BIBLE. ⚠ MINTY'S DOCUMENT.
  INTERMEDIATE REQUIREMENT = qty per batch × (MO units ÷ units per
    batch), computed live. Fractional preserved. 3 decimals on display.
  INGREDIENT REQUIREMENT — same live computation. ⚠ SUPERSEDES S105.

⚠⚠ S109 IS A BUILDING SESSION. The survey is finished; do not re-open
  it. Steps 1 and 2 need nothing built first.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 51e9f4e · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺260 · 200
                served build dev-a94f39c3b2bf
           prod backend 51e9f4e · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺340 · 200
                served build prod-a94f39c3b2bf
   ⚠ ALSO the view at three divisions on EACH box:
       mysql abletracelab_live -e "SHOW CREATE VIEW
         Trace_ProductHeaderView\G" | grep -o "/" | wc -l
     Expect 3 on EACH. ⚠ Run on each separately.
   ⚠ IF ANY LAYER DIFFERS, STOP AND RECONCILE THE RECORD FIRST.

2  ⚠ READ THE UNITS BIBLE PART 4 — the fixture and the three proofs.
   Everything in this plan is verified against MO-0004 on company 474.
   ⚠⚠ DO NOT RELEASE MO-0004. IT IS THE BEFORE PICTURE.

3  Then STEP 1 below. It is the only item that is wrong on both live
   clients today.
```
---

## ⚠ THE ONE DEPENDENCY THAT SHAPES THE ORDER

```
P82 CLOSES WHEN Trace_ProductHeaderView RETURNS ZERO DIVISIONS.
IT RETURNS 3.

SOH_su SUBTRACTS intermediate_prd_su. THE VIEW CANNOT REACH ZERO
WITHOUT THE mprrecievelots COLUMN (STEP 6).

▶ EVERYTHING ELSE IS INDEPENDENT. Steps 1, 2, 3 and 5 stand alone and
  can ship in any order. Step 4 needs its own fixture. Step 7 gates
  nothing.
⚠ SO STEP 6 IS THE ONLY THING BETWEEN HERE AND P82 CLOSING.
```

---

# THE JOB · S109

## STEP 1 · THE returnSum BUG. ⚠ LIVE ON BOTH CLIENTS.

```
FILE     api/models/Formulations.js — getFormulaByIdForReleaseMaterial
SITES    three branches: materials ~:1108, intermediates ~:1141,
         packaging ~:1189. IDENTICAL SHAPE IN ALL THREE.

WHAT IT DOES
    let sum = 0; let returnSum = 0;
    ...release...  sum = sum + qty_allocated;
    ...return...   sum = sum + qty_return;    ⚠⚠ ADDED TO sum
    released_qty  = sum          ⚠ INCLUDES RETURNS
    returned_qty  = returnSum    ⚠ DECLARED, NEVER ASSIGNED = 0
    remaining_qty = sum - 0
▶ RETURNING MATERIAL MAKES THE SCREEN SHOW MORE RELEASED, NOT LESS.

THE FIX — COPY THE WORKING VERSION, DO NOT INVENT ONE
    api/models/MLOManagement.js ~:1116 does the identical job:
        returnSum = returnSum + data.qty_return;
        item['consumed_qty'] = sum - returnSum;
    ⚠ SAME TWO QUANTITIES, ONE FILE RIGHT AND ONE WRONG.

⚠ BEFORE ANY PATCH — ONE GREP:
    grep -rn "released_qty\|remaining_qty\|returned_qty" \
      src/app --include=*.html
  WHICH COMPONENT CONSUMES THESE? If an operator uses "remaining" to
  decide how much more to release, this is worse than cosmetic.

FIXTURE  ✓ ALREADY EXISTS. Company 464, MO-0011, the 2 Kg Ginger
         Powder return created S108. ⚠ DO NOT CLEAR IT.
VERIFY   Released Qty goes DOWN by 2 Kg, not up. Returned Qty shows 2.
         ⚠ Check all THREE branches — material, intermediate, packaging.
BACKEND  Edited, committed and pushed ON DEV. No build step.
         ⚠ READ HEAD AFTER THE PULL, BEFORE RESTARTING. RULES 2.
         ⚠ git fetch origin FIRST. → P155.
         ⚠ pm2 restart abletrace-dev, then sleep 8, then curl.
```

## STEP 2 · NINE ONE-LINE REPOINTS. ONE BUILD. NO BACKEND CHANGE.

```
⚠ THE MODEL IS ALREADY IN THE CODEBASE:
    stock-info.component.ts:188
      inventory_units                → the # count, READ STORED
      inventory_units × wduKgPerUnit → the Kg, DERIVED
  ▶ COPY THAT SHAPE. DO NOT INVENT A THIRD.

  2.1  rejected-materials.component.ts:154   ⚠ THE MR SITE
       qty_rejected / wgt → element.qty_rejected_units
       ✓ SERVED BY WhC_GetAllRejectedList_SP SINCE S104. JR16.

  2.2  edit-mlc.component.ts:298     received_qty / wgt
  2.3  edit-mlo.component.ts:251     → mlcDetails.received_units
  2.4  start-mlc.component.ts:155
       ✓ SERVED BY WhC_GetMoDetails_SP SINCE S106. JR17.
       ⚠ P151 RECORDS ONLY edit-mlc. 2.3 AND 2.4 ARE IN NO DOCUMENT —
         found by the S108 survey.
       ⚠ edit-mlc:295 lotReceived is DEAD (J114). DO NOT PATCH IT.

  2.5  mfg-lot-codes.component.html:69
       getWdu(element, received_qty) → element.received_units
       ⚠ CONFIRM THE LIST PROC SERVES IT. One grep before writing.

  2.6  product-traceability.component.ts:109
       received_qty / wgt → item.received_units
       ✓ Trace_ProductProdLotView SERVES IT. JR7d, S51.

  2.7  admin-formulation.component.ts:878    ⚠ THE PRODUCTS LIST
       inventory / wgt → inventory_units
       ⚠ VERIFY THE READ PATH FIRST — this list comes through Waterline,
         not a stored proc. inventory_units IS a declared attribute
         (JR2) so it SHOULD ride the populate. CONFIRM, DO NOT ASSUME.

  2.8  formulation-edit-stock-info.component.ts:269
       (inventory/batchQty) × (batchQty/wduKgPerUnit) → inventory_units
       ✓ ITS SIBLING stock-info.ts:188 IS CORRECT. COPY IT LINE FOR LINE.
       ⚠ ONLY THE In Store LINE IS WRONG in that file. :143-243 are
         already right. DO NOT TOUCH THEM.

  2.9  Trace_ProductHeaderView — qty_misc_release_su
       → rmp.qty_rejected_units, ⚠ AND ADD A TYPE GUARD
       ⚠ The mr CTE has NO type filter. Material MRs carry no mlc_id so
         they group out today — SAFE BY DATA, NOT BY CODE (J74).
       ✓ NO BACKFILL. Hagensborg's 24 MR rows are ALL MATERIAL and must
         stay at zero per JR15. MEASURED S108. QUESTION CLOSED.
       ⚠ THIS ONE IS A DATABASE OBJECT — each box separately, JR16
         method, own backup. It does NOT ride the frontend build.

⚠⚠ NOT IN THIS STEP — the seven-copy helper (BIBLE #46). It looks like
  a bulk repoint and is NOT. Each caller passes a different source and
  SOME DIVISIONS ARE CORRECT. J114: closed-mlcs.html:84 is right while
  :79 is wrong, same helper, adjacent lines. ▶ OWN SITTING.

GATE     one build, deploy dev, verify, then prod.
         ⚠ FRONTEND IS EDITED ON THE MAC. A push builds dev; prod needs
           a manual dispatch. ⚠ Shift+Cmd+R after deploy.
         ⚠ READ THE COMMIT STAMP IN THE ARTIFACT NAME, not the position
           in an ls. → J117.
FIXTURE  464 / test1.39 at 1.39 Kg/unit for the unit sites.
         474 / MO-0003 and MO-0004 for the rest.
VERIFY   ⚠⚠ EVERY FIGURE UNCHANGED IN VALUE AND FREE OF FLOAT GARBAGE.
         A CHANGED VALUE IS A FAILURE, NOT A FIX — these all return the
         arithmetically right number today.
         ▶ THE Kg COLUMN IS THE CONTROL. → S106 LESSON 6.
```

## STEP 3 · THE DISPATCH WRITE. OWN GATE.

```
add-dispatch-v2.component.ts:194
    packing_units: Math.round(((qtyToShip / batch_qty)
                               × (batch_qty / wgt)) ...)
▶ IT DIVIDES TO PRODUCE packing_units AND WRITES IT TO THE ROW.
  EVERY OTHER SITE SHOWS A WRONG NUMBER. THIS ONE STORES ONE — and
  Trace_ProductHeaderView reads that column for TWO cells (JR18).
⚠ J88: clean today only because Math.round lands on the right integer.
  A FRACTIONAL DO WOULD ROUND WRONG AND SILENTLY SHIP A DIFFERENT
  QUANTITY THAN AUTHORISED. Fractional DOs are permitted by design.
  ⚠ DO-0008 and DO-0009 on dev carry packing_units 0.5. USE THEM.
⚠ IT IS A WRITE. Before-and-after ROW comparison, NOT a screen check.
⚠ OWN COMMIT. It can be reverted alone.
```

## STEP 4 · FOUR PROCEDURE CHANGES.

```
4a  WhC_GetMoProductReceivingDetails_SP — ADD receiveproducts.qty
    THEN edit-mlc.component.html:258 + getWdu:354
    ⚠⚠ PER-RECEIPT, NOT THE MO TOTAL. Using received_units here puts
      the WHOLE MO's figure on EVERY receipt row.
    ⚠ getWdu's ONLY live caller is html:258. Fixing it makes getWdu
      DEAD → delete in the same pass. P115.
    ⚠ MEASURED S107: the proc selects id, internalCode, mlc_id,
      mlc_packaging_id, received_at, recieved_qty. NO unit count.
    FIXTURE ⚠ NEEDS A MULTI-RECEIPT MO to prove per-receipt vs total.
      474 MO-0003 has ONE receipt of 41. ▶ BUILD A SECOND MO WITH TWO
      RECEIPTS, or the fix cannot be distinguished from the bug.

4b  WhC_GetMoIntermediateProducts_SP   — ADD subrecipeformulation.ship_qty
4c  WhC_GetFormulaIntermediateProducts — ADD ship_qty AND inventory_units
4d  Formulations.js JS cascade — serve the unit figure to matList
    ⚠⚠ 4b/4c FEED THE Intermediate Products BLOCK. 4d FEEDS THE Batch
      Materials BLOCK. SAME SCREEN, SAME PRODUCT, TWO CODE PATHS.
      FIXING ONE LEAVES THE SCREEN DISAGREEING WITH ITSELF, WHICH IS
      WORSE THAN LEAVING IT ALONE. ▶ ALL THREE TOGETHER.
    ✓ BOTH COLUMNS ALREADY EXIST AND HOLD CORRECT DATA — ship_qty
      since 2022 (J81), inventory_units since S46 (JR2).
    ⚠ AN ALIAS CHANGE RIDES WITH THIS, so a FRONTEND BUILD is involved.
      Unlike JR7e and JR18.

METHOD  JR16's, on each box from its OWN backup:
  1  SHOW CREATE to a .bak file. Verify line and join counts.
  2  Build the new object ON THE BOX by node script. Anchors asserted
     to appear EXACTLY ONCE.
  3  diff old against new. Join count must hold.
  4  Apply. Read back OUT OF THE DATABASE, not off the file.
  5  CALL it, then check the screen.
⚠ NEVER PASTE A PROC BODY INTO A TERMINAL. SSH input buffer overflow
  discards the overflow SILENTLY. → JR16.
⚠ Recreate WITHOUT the definer clause. RDS can refuse one.

VERIFY  MO-0004 must show IP-0.37 as 15.923# (5.892 Kg) and WH Stock
        as 41# (15.170 Kg). ⚠ AND BOTH BLOCKS MUST AGREE.
```

## STEP 5 · THE REQUIREMENT CALCULATION. ⚠ OWN SESSION.

```
Formulations.js — replace mlcDetails.batches with a live computation.
    quantity per batch × (MO shipping units ÷ shipping units per batch)
✓ PACKAGING ALREADY DOES THIS TEN LINES AWAY IN THE SAME FILE:
    pack['final_qty'] = cascadeQty × mlcDetails.qty
  ▶ THE PRECEDENT EXISTS. Materials and intermediates use batches;
    packaging uses the MO. Make all three consistent.
⚠ FRACTIONAL RESULTS ARE CORRECT. Round to three decimals FOR DISPLAY
  ONLY. Full precision in the calculation and in storage.

⚠⚠ THIS MOVES NUMBERS ON A SCREEN BOTH CLIENTS USE DAILY. Glutenull
  has 26 live allocations. OWN SESSION, OWN GATE, OWN COMMIT.
⚠⚠ IT REVERSES MINTY'S S105 RULING, AND RULES 7 STATES THAT RULING IN
  PLAIN WORDS. RULES 7 MUST BE REWRITTEN, NOT ANNOTATED.
  ▶ CLAUDE DRAFTS THE WORDING. MINTY READS IT BEFORE ANY EDIT.
⚠ PAST MOs WILL SHOW A REQUIREMENT DIFFERING SLIGHTLY FROM WHAT WAS
  RELEASED. THE RELEASE ROWS STAND — Minty's S106 ruling, a figure
  recording what physically happened is not a wrong row.
  ⚠ 474 MO-0003 ALREADY CARRIES ONE: released 15.171 Kg against a true
    requirement of 15.170. SOMEBODY WILL NOTICE AND ASK.

VERIFY  MO-0004's Ginger Powder must read 2303.910 Kg — IDENTICAL to
        the Plan Quantity. It reads 2303.609 today.
```

## STEP 6 · THE SCHEMA. ▶ P82 CLOSES HERE.

```
6a  ALTER TABLE mprrecievelots      ADD qty_allocated_units double DEFAULT 0;
    ALTER TABLE returnmpreceivelots ADD qty_return_units    double DEFAULT 0;
    ⚠⚠ TRAPS 3 — DECLARE IN THE WATERLINE ATTRIBUTES IN THE SAME BREATH
      or every write is SILENTLY DROPPED. J18/J20: received_units
      banked 0 for sessions until declared.
    ⚠ BOTH TABLES TOGETHER. Release unit-anchored + return Kg-only =
      the two sides of one movement in different bases.
    ⚠ DOUBLE, NOT INT. Fractional units are permitted. J88.
    ⚠ OWN BACKUP PER BOX. Prod dump needs --single-transaction
      --skip-lock-tables --set-gtid-purged=OFF, then
      grep -c "INSERT INTO" BEFORE TRUSTING IT. JR15.
    ✓ NO BACKFILL. Zero product-side allocations on either live client,
      zero product returns on either box. MEASURED S108.

6b  WRITE PATH — createReleaseMaterialProductsV2
    ⚠⚠ V2 IS THE LIVE PATH. J12 / JT9. The older single function in the
      SAME FILE is an INVISIBLE NO-OP. It cost S46 real time.

6c  THE READS
    Trace_ProductOneStepBackwardIP_SP  repoint ⚠ AND COPY THE MISSING
      whd_flag FILTER FROM ITS SIBLING. Its packaging join has none, so
      on a multi-level product it divides by an arbitrary row AND
      returns duplicates. The forward proc carries the filter WITH A
      COMMENT explaining it.
      ⚠ @formulationId is SET and NEVER USED. Decide, do not leave.
    Trace_ProductOneStepForwardIP_SP   repoint
    ...ReleaseDetails_SP               add the column
    ...ReturnDetails_SP                add the column

6d  Trace_ProductHeaderView
    intermediate_prd_su → the new column
    SOH_su              → subtract the five UNIT terms. No division.
    ⚠⚠ TRAPS 10 LIVES IN THIS OBJECT. The do_products CTE defines its
      own alias `qty_shipped` summing do.qty_to_ship — KG. The real
      column is UNITS. RESOLVE EVERY NAME TO ITS DEFINITION.
    ⚠ RE-CAPTURE A FRESH BACKUP. The S107 .bak files hold the
      SIX-division version; the live object has three.

▶ ACCEPTANCE, AND IT IS THE WHOLE GATE:
    mysql abletracelab_live -e "SHOW CREATE VIEW
      Trace_ProductHeaderView\G" | grep -o "/" | wc -l
  MUST RETURN 0 ON BOTH BOXES.
  ⚠ grep -c COUNTS LINES AND THIS OBJECT IS ONE LINE.
▶ P135 CLOSES · P82 CLOSES · TRAPS 10 RETIRES · P111 UNBLOCKS.
```

## STEP 7 · THE RETURN PATH. GATES NOTHING.

```
7a  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY — PROVEN ON DEV S108.
    3.32 Kg demonstrably in store on receiveproducts row 11425
    (recieved_qty 20, prev_received_qty 16.68). Picker offered nothing.
    ▶ THE PATH HAS NEVER RUN BECAUSE IT CANNOT BE RUN.
    CANDIDATE  return-mat.component.ts — recProductList declared [];
      getReceiveProductByFormulaIdSuccess IMPORTED at :17 and
      apparently NEVER SUBSCRIBED, while getRecLotsByMaterialID IS
      (:161, :248).
    ⚠ NOT PROVEN. ONE GREP CONFIRMS:
        grep -n "getReceiveProductByFormulaId\|recProductList" \
          <path>/return-mat/return-mat.component.ts
      IF recProductList IS NEVER ASSIGNED → the subscription is missing.
      IF IT IS ASSIGNED → the defect is upstream, in the action, the
        effect, or the backend. READ THAT CHAIN BEFORE PATCHING.
    ✓ release-mat-details DOES release intermediates from lots, so a
      WORKING REFERENCE EXISTS. Copy it rather than invent.

7b  ReturnMaterialProduct.js:68 — a product return adds back to
    formulations.inventory (Kg) and NEVER TOUCHES inventory_units.
    ▶ The unit balance would only ever DECREASE.
    ⚠⚠ UNTESTED. A CODE READING. Prove it once 7a lands. The prediction
      is on the record: inventory UP, inventory_units UNCHANGED.

7c  TRAPS 3 on the same file — `status` is written in RMPOBJ, the model
    DECLARES NO status ATTRIBUTE, so Waterline discards it. Then
    getReturnMaterialProducts FILTERS ON status:"Active".
    ▶ A filter on a value the write never stores.
    ⚠ SEPARATE COMMIT from 7b. Different subject. J96's ordering hazard.

7d  The return form takes WEIGHTS ONLY — measured on screen S108,
    Minty confirmed. Needs a FORM FIELD, not just a column.
```

---

## WHAT DONE LOOKS LIKE

```
UNITS BIBLE scoreboard moves 19 → 29 after step 2.
Returning material makes Released Qty go DOWN.
Both Edit-Mlc blocks show units# (Kg) AND AGREE WITH EACH OTHER.
MO-0004's Ginger Powder reads 2303.910 Kg, matching Plan Quantity.
Trace_ProductHeaderView returns ZERO divisions on BOTH boxes.

⚠ THE CONTROL AT EVERY STEP: Pouch 4347.000 Ea on MO-0004 MUST NOT
  MOVE. If a packaging figure shifts, THE FIX IS WRONG, NOT THE DATA.
```

## IF S109 CLOSES EARLY

```
P147  CREATE A MATERIAL MR ON DEV COMPANY 474. One minute.
P131  EDIT CLOSED MO LINE 133 — a unit count with a WEIGHT label.
      ⚠ COVERED BY RULES 7. One line.
NEW   Row counts on three uncounted tables — do_receive_products ·
      mlodetails · forecastsales. Minutes.
P152  PUT A WARNING IN read-rows.js's OWN OUTPUT. It corrupts evidence.
```

## NOT IN S109

```
THE SEVEN-COPY HELPER  ⚠ own sitting. Read all seven callers first.
P102 THE REBOOT        ⚠ own sitting. Prod 28 updates, dev 8, restart
                         required, thirteen days, TWO LIVE CLIENTS.
                       ⚠ S105 PROVED DEV CAN FAIL TO BOOT SILENTLY.
                       ▶ WORTH DOING BEFORE P111.
P156 HAGENSBORG        the documentation half.
                       ⚠ S108 FOUND MORE: dev's 469 is test260710@,
                         prod's 469 is HAGENSBORG. THE TWO BOXES DO NOT
                         SHARE A COMPANY-ID NAMESPACE. No company id can
                         be reasoned about without naming the box.
P111 QUICKBOOKS        planning only, no code. ⚠ Four things will meet
                       it: TRAPS 3 on the new column · J97's multiple
                       invoices pointing at a child table · soproducts
                       storing no unit count (P138) · MR numbering
                       global across two clients (P137).
                       ▶ WHEN IT STARTS IS MINTY'S CALL.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 2 AND 4. The map and the fixture.
⚠ ASK MINTY FOR JR15, JR16 and JR17 — steps 4 and 6 follow them exactly.
⚠ ASK MINTY FOR SECTION 3A.5 rows 3, 11 and 12 before touching the
  release write path.
⚠ QUANTITY-SURVEY-S108.md holds the evidence behind every item here.
  CORRECTION-PLAN.md holds the phase reasoning. Neither is needed to
  execute; both are there if a finding is questioned.
```

---

## THE LESSONS S108 EARNED

```
1  ⚠⚠ THE SURVEY FOUND IN ONE DAY WHAT TWENTY SESSIONS OF ACCIDENTS
   DID NOT. All six previous instances of this pattern were found while
   working on something else. The first systematic sweep found two more
   IN THE FIRST TWO OBJECTS IT OPENED.
   ▶ THE SIX FIXED BEFORE S108 WERE NOT THE WHOLE PROBLEM. THEY WERE
     THE ONES THAT HAPPENED TO BE IN FRONT OF SOMEONE.

2  ⚠⚠ THE TWO WORST FINDINGS CAME FROM ONE TEST, NOT FROM READING.
   The unreachable picker and the returnSum bug both surfaced from a
   ten-minute return on dev. Neither would have come from code reading.
   ▶ RULES 1 IS RIGHT. REPRODUCE FIRST. J109 cost four hours learning
     this; S108 earned it back in ten minutes.

3  ⚠ A SWEEP IS ONLY AS GOOD AS ITS PATTERN, AND A CONTROL CAN PASS
   WHILE THE PATTERN IS WRONG.
   The first division sweep required whitespace after the slash and
   missed `qty_allocated/fo2.wgt_kgs_per_unit`. It reported a dividing
   object as CLEAN. The control — a known 3-division view — PASSED
   ANYWAY, because the pattern matched what it was built on.
   ▶ A CONTROL PROVES THE PATTERN MATCHES WHAT ITS AUTHOR IMAGINED.
     IT PROVES NOTHING ABOUT SHAPES HE DID NOT. OVER-REPORT BY DESIGN.

4  ⚠ THREE SWEEPS, THREE DIFFERENT ANSWERS: 49 files, then 56, then 19
   more that mention no weight at all. Each pass found what the last
   one could not see.
   ▶ SAY WHAT A SWEEP CANNOT SEE, IN THE SAME BREATH AS ITS RESULT.

5  ⚠⚠ CLAUDE DECIDED A SCOPE BOUNDARY THAT WAS MINTY'S TO DECIDE.
   After the frontend file list came back Claude wrote "we do not need
   to survey all 49" and moved on. MINTY CAUGHT IT.
   ▶ A BOUNDARY IS A RECOMMENDATION, NOT A STEP. Put it to Minty.

6  ⚠ MEASUREMENT CLOSED THREE QUESTIONS THAT REASONING HAD GOT WRONG.
   The MR backfill (Hagensborg's rows are ALL MATERIAL), the
   intermediate backfill (zero client rows), and the product-return
   backfill (zero rows anywhere). Claude's S107 position paper had
   argued the first one at length and had it WRONG.
   ▶ MEASURE BEFORE ARGUING. A ruling that measurement can dissolve
     should never reach Minty as a ruling.

7  A FIXTURE BUILT TO EXPOSE A BUG EXPOSED IT BEFORE ANY CODE CHANGED.
   474's MO-0004 shows Plan Quantity 2303.910 Kg and Ginger Powder
   2303.609 Kg — 0.301 apart, on the same page, from the same recipe.
   ▶ 19 AND 13 ARE PRIME AND SHARE NO FACTORS. THAT IS WHY. Choose
     fixture numbers that cannot resolve cleanly.
```
