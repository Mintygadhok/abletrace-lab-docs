# PLAN

Written at close of: S113 · for S114.
Disposable. Rewritten whole at every close.

⚠ S113 SHIPPED TWO THINGS. BOTH ON BOTH BOXES.
  PROCEDURE  Trace_MaterialDetails_SP gains mlomanagement.received_units
             in THREE places — the temp table CREATE, the INSERT column
             list, and the SELECT that feeds it. JR23.
  e1a82e02   material traceability MO rows read stored counts, frontend

⚠⚠ THE SCOREBOARD: 38 GREEN · 10 RED · 3 REVIEW, of 51. BALANCE 13.
  ▶ ROWS 45 AND 51 CLOSED. THE ONLY WRONG NUMBER IN THE QUEUE IS GONE.
  ▶ 48 IS THE CEILING.

⚠⚠ READ THIS BEFORE TRUSTING ANY ADDRESS IN THIS FILE.
  S113's targets were named by PLAN and by the bible as :123 :124 :215
  :216. ALL FOUR WERE DEAD — two inside a commented block, two iterating
  an array nothing assigns. THE REAL DEFECT WAS :107/:108, WHICH BOTH
  DOCUMENTS SAID TO LEAVE ALONE.
  ▶ OPEN THE FILE AND MAP THE LOOPS BEFORE WRITING AN ANCHOR. Every
    time. The addresses below are the best available and they are still
    claims.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ALSO CONFIRM S113 HELD, ON EACH BOX:
       git -C ~/abletrace-lab-backend log --oneline -1   expect 4d43bd4
       ls -1dt /home/ubuntu/www-html.bak-* | head -1     expect e1a82e02
       mysql abletracelab_live -e "SHOW CREATE PROCEDURE
         Trace_MaterialDetails_SP\G" | grep -c "received_units"
       ⚠ EXPECT 3, NOT 1. SHOW CREATE PROCEDURE keeps its newlines.
         A VIEW is one line; a PROCEDURE is not. → LESSONS.
   ⚠ DEV ONLY: SHOW COLUMNS FROM mprrecievelots
       expect qty_allocated_units, double, DEFAULT 0
     ⚠⚠ PROD MUST STILL NOT HAVE IT.

2  ⚠ SETTLE P188 FIRST — IT IS THE EIGHTH PIECE AND IT CHANGES THE SHAPE
   OF THE JOB. Read release-mat-details.component.ts:296 and decide
   whether the backend serves released_qty_units or whether final_qty_kg
   stays. ▶ DO NOT START THE CAPTURE BEFORE THIS IS DECIDED.

3  Then THE JOB below.
```

---

# THE JOB · S114 — THE UNITS CAPTURE

⚠⚠ THE CAMPAIGN'S SPINE, AND THE ROOT CAUSE OF FIVE OPEN ROWS.
⚠⚠ IT MOVES NO ROW ON THE BOARD. Nothing on any screen looks different
  afterwards. ITS ENTIRE VALUE IS THAT IT UNBLOCKS ROWS 37-41.
  ▶ RECORDING IT AS "NO PROGRESS" WOULD BE THE MISTAKE. Recording it as
    row movement would be the other one. It is groundwork and the record
    must say so plainly — the same way S112's did.

⚠⚠ IT TOUCHES THE LIVE RELEASE PATH — the one that moves warehouse
  stock. BOTH CLIENTS USE IT DAILY FOR MATERIALS. The PRODUCT branch is
  what changes; the MATERIAL branch must not move.

## WHAT IS WRONG

```
The release screen asks the operator for KILOGRAMS. It always has. So
no unit count is ever captured, and five traceability sites rebuild one
by dividing the Kg by the per-unit weight.

⚠⚠ THE Kg ITSELF IS HONEST. Minty's S112 reading is correct and was
  re-verified: the receipt stores units and derives Kg ONCE
  (41 × 0.37 = 15.17), and every later step is Kg minus Kg
  (15.17 − 2.59 = 12.580). NO DIVISION ANYWHERE IN THAT CHAIN.
  ▶ THE DEFECT IS NOT THE Kg. IT IS EVERY POINT WHERE A UNIT COUNT IS
    REBUILT OUT OF IT. There are exactly two kinds:
      ONE WRITE     P184, inventory_units
      FIVE DISPLAYS rows 37-41
  ▶ MINTY RULED FOR UNITS END TO END, FOR CONSISTENCY, KNOWING THE COST.
    UNITS-BIBLE PART 1 SECTION 6.

PROVEN THREE WAYS IN S112:
  1  THE TEMPLATE  the product block binds recLot.qty and calls
     addQty(...,'product'). NO UNITS FIELD. qtyWdu APPEARS NOWHERE.
  2  THE BACKEND   createReleaseMaterialProductsV2 uses only
     data.qty_allocated and subtracts it from formulations.inventory (Kg).
  3  ⚠⚠ THE ROW, WHICH SETTLED IT. mprrecievelots 84005 and 84008
     allocate 1.12 and 5.56 against a receipt holding ONE unit / 20 Kg.
     YOU CANNOT ALLOCATE 5.56 UNITS OF ONE UNIT. IT IS Kg.
```

## ✓ THE PRECONDITION IS CLEARED — MEASURED IN S113

```
qty_allocated IS READ IN SIX PLACES AND ALL SIX WERE READ IN FULL:
    Formulations.js  :1103 materials · :1136 formulations · :1188 packaging
    MLOManagement.js :1097 · :1102 · :1107
EVERY ONE IS THE SAME STATEMENT:
    sum = sum + <row>.qty_allocated
✓ NO DIVISION. NO wgt_kgs_per_unit. NO UNIT COUNT RECONSTRUCTED.
▶ SO LONG AS qty_allocated STAYS KILOGRAMS, S114 DOES NOT TOUCH THEM.
  Adding a parallel qty_allocated_units column is invisible to all six.
⚠ THIS WAS A DOCUMENT CLAIM UNTIL S113. IT IS NOW A MEASUREMENT.

⚠⚠ AND THE SAME READ CONFIRMED P164 FROM BOTH SIDES. All three
  Formulations.js branches declare returnSum, never assign it, and add
  the return into `sum` — the released total. MLOManagement.js DOES
  assign returnSum. ▶ THE PROOF ONE FILE IS WRONG IS IN THE OTHER FILE.
  ⚠ NOT TOUCHED. Minty ruled the return path goes LAST.
```

## THE FIX

```
a  SCHEMA    ALTER TABLE mprrecievelots ADD COLUMN qty_allocated_units
             double DEFAULT 0;   ⚠⚠ ON PROD. ITS OWN GATE.
             1  BACK UP THE STRUCTURE FIRST, J43's method:
                  grep -v -i "database" ~/.my.cnf > /tmp/dump.cnf
                  chmod 600 /tmp/dump.cnf
                  mysqldump --defaults-file=/tmp/dump.cnf
                    --single-transaction --skip-lock-tables
                    --set-gtid-purged=OFF --no-data abletracelab_live
                    mprrecievelots > ~/mprrecievelots-before-S114-PROD.sql
                ⚠⚠ mysqldump REJECTS the ~/.my.cnf database= line AND THE
                  REDIRECT CREATES THE FILE ANYWAY. IT WROTE A 0-BYTE
                  BACKUP IN S112 AND ONLY THE CHECK CAUGHT IT.
                ▶ VERIFY: non-zero bytes AND grep -c "CREATE TABLE" = 1.
             2  COUNT THE ROWS BY TYPE BEFORE. 3 ALTER. 4 SHOW COLUMNS.
             5  COUNT AGAIN — MUST BE IDENTICAL. 6 rm -f /tmp/dump.cnf.
             ✓ NO BACKFILL. Glutenull 0, Hagensborg 0, sandbox 465 has
               all five. 68 rows, 63 material and 5 product.
             ⚠ RE-RUN THAT COUNT ANYWAY. One query, and the whole
               no-backfill decision rests on it.
             ⚠ THE MODEL ALREADY DECLARES THE ATTRIBUTE ON BOTH BOXES
               (9dac080, S112). TRAPS 3's other half is already done.

b  ⚠⚠ P188 — DECIDE BEFORE WRITING ANYTHING ELSE.
             release-mat-details.component.ts:296
               remainToFill = final_qty − released_qty
             final_qty becomes/is UNITS. released_qty is built by summing
             qty_allocated, WHICH STAYS Kg BY DESIGN.
             ▶ TWO OPTIONS, BOTH DEFENSIBLE:
               (i)  backend serves released_qty_units alongside
                    released_qty, summing the new column. The screen goes
                    fully unit-anchored. MORE WORK, CLEANER END STATE.
               (ii) final_qty_kg stays and that one subtraction remains
                    Kg-anchored. LESS WORK, and the stopgap becomes
                    permanent — which must then be recorded as a
                    decision, not left looking like an oversight.
             ⚠ THIS IS THE S112 REGRESSION'S EXACT SHAPE. Two bases
               subtracted from each other, auto-filled into an input, and
               a guard that turns green on the result.

c  FRONTEND  THE INPUT CAPTURES UNITS, Kg SHOWN DERIVED BESIDE IT.
             ⚠⚠ COPY add-dispatch-v2's qtyWdu — bible row 30, fixed S109,
               PROVEN. The operator types the count and getQty:101
               derives the Kg by MULTIPLYING.
             ⚠⚠ DO NOT INVENT A THIRD PATTERN. TRAPS 2.

d  FRONTEND  THE LOT LINE → 3.000# (30.000 Kg) / 10# (100 Kg)
             ✓ THE 10 IS STORED — receiveproducts.qty, exposed by JR21.
             ⚠⚠ THE REMAINING-UNITS FIGURE MUST BE BUILT, NOT READ.
               prev_received_qty is Kg.
             ▶ MINTY'S RULING, S112: DERIVE IT. DO NOT ADD A COLUMN.
                 remaining_units = qty × (remaining_qty ÷ recieved_qty)
               REASONS, RECORDED:
                 · the source IS unit-anchored — receiveproducts.qty is
                   stored and recieved_qty is derived from it once
                 · it is a DISPLAY figure. Nothing is written from it.
                 · ⚠⚠ prev_received_qty ACCUMULATES FROM MORE THAN THE
                   RELEASE PATH — 474's 2.59 Kg came from a DISPATCH.
                 ▶ TWO RUNNING TOTALS THAT MUST AGREE ARE TWO TOTALS
                   THAT CAN DISAGREE.

e  FRONTEND  THE AUTO-FILL at release-mat-details.component.ts:326-329
             must fill UNITS, not the Kg it fills today.
             ⚠⚠ ANCHOR ON :296 PLUS THE console.log BELOW IT. Line :296
               alone is near-identical to the MATERIAL branch at :215.

f  BACKEND   createReleaseMaterialProductsV2 :262
               qty_allocated_units = the typed count
               qty_allocated       = typed × per-unit weight
             ⚠⚠ qty_allocated STAYS KILOGRAMS. SIX READ SITES DEPEND ON
               IT AND ALL SIX WERE READ IN S113. CHANGING ITS BASIS
               BREAKS ALL SIX SILENTLY. TRAPS 1's shape.
             ✓ THE LOOP ALREADY BRANCHES CORRECTLY:
                 if (!!data.Rec_Lot_id)     MATERIAL — Kg only, LEAVE IT
                 if (!!data.Rec_Product_id) PRODUCT — units belong here
               MATERIALS CANNOT ACCIDENTALLY RECEIVE A UNIT COUNT.

g  BACKEND   THE PARTIAL-ALLOCATION CLAMP. When remaining < requested,
             :228 and :256 OVERWRITE data.qty_allocated with remaining_qty.
             ▶ THE UNIT FIGURE MUST CLAMP IN STEP or the two columns
               disagree ON THE SAME ROW.

h  P184 RIDES HERE — SAME COMMIT.
             the product branch currently does:
               _ratio = _lot.qty ÷ _lot.recieved_qty        units per Kg
               inventory_units −= qty_allocated × _ratio
             ⚠⚠ A WRITE, NOT A DISPLAY. It sets the Core Stock Line.
             ⚠ It wears a multiplication and is ALGEBRAICALLY A DIVISION
               by Kg-per-unit — J83's disguised R2 form.
             ✓ ARITHMETICALLY CORRECT TODAY. No client has ever released
               an intermediate, so nothing wrong has been banked.
             ▶ ONCE THE TYPED COUNT EXISTS, SUBTRACT IT DIRECTLY.

i  P185 RIDES HERE IF THE FILE IS OPEN ANYWAY.
             eval() sums quantities at :322, :439, :456 on
             operator-entered input. Replace with reduce. MEDIUM.
             ⚠ ONLY IF IT DOES NOT ENLARGE THE DIFF ENOUGH TO OBSCURE
               THE CAPTURE. The capture is the job.

j  GATE      DEV FIRST, on 474 MO-0006 — created in S112 for this,
             unreleased, ⚠⚠ AND STILL UNSPENT AFTER S113.
             ⚠⚠ THE PROOF IS THE ROW, NOT THE SCREEN. Nothing displays
               qty_allocated_units until S115.
             ▶ PASS: a fresh product allocation writes a NON-ZERO
               qty_allocated_units matching the units typed, AND
               qty_allocated holds the derived Kg, AND inventory_units
               falls BY EXACTLY THE UNITS TYPED.
             ⚠ A ZERO IS TRAPS 3 FIRING. IT WILL NOT ERROR.
             ⚠ MEASURE THE BASELINE BY QUERY FIRST:
                 formulations 3696 — inventory 17.39, inventory_units 47
                 receiveproducts 11449 — qty 41, recieved_qty 15.17,
                   prev_received_qty 2.59
                 mprrecievelots — 113 rows on dev
             ⚠ RELEASE 4.846 UNITS. That is MO-0006's true requirement
               and it derives to 1.793 Kg.
             PROD: exercise on sandbox 465 — ⚠ NOT 464.
             ▶ PASS ON PROD IS THAT MATERIAL RELEASE STILL WORKS.
```

---

# THEN · S115 — ROWS 37-41 · THE FIVE READ SITES

⚠⚠ CANNOT START BEFORE S114. The column exists on dev and IS EMPTY.
  A read repointed against an unpopulated column shows 0 — WORSE than
  the division it replaces, because a plausible wrong number becomes an
  OBVIOUSLY wrong zero on a client-facing traceability screen.

```
ROW 39  Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT
        divides qty_allocated, AND joins fopackaging with NO whd_flag
        filter. ✓ ITS SIBLING CARRIES THE FILTER, WITH A COMMENT. Copy it.
ROW 40  Trace_ProductOneStepForwardIP_SP   divides qty_allocated
ROW 41  ...ReleaseDetails_SP               divides qty_allocated
ROW 37  Trace_ProductHeaderView  intermediate_prd_su
ROW 38  Trace_ProductHeaderView  SOH_su
        ⚠⚠ 38 DEPENDS ON 37. It subtracts five Kg terms then divides.
          DO 37 FIRST. And SOH is the headline figure anyone reads.

⚠ WHAT THIS LOOKS LIKE TODAY, ON MINTY'S FIXTURE:
    Product Traceability, Pdt-260810-3:
      Qty Used  7# (70.000 Kg)   ⚠⚠ THE 7 IS NOT STORED ANYWHERE.
                                   70 ÷ 10 = 7, computed at render time.
  ▶ ON IP2's ROUND RATIO IT LOOKS FLAWLESS. On IP-0.37 the same code
    produces a float tail. THAT IS TRAPS 9, DEMONSTRATED.

METHOD  JR16's, on each box FROM ITS OWN BACKUP. Short node script,
        ⚠ TWELVE LINES. Anchors asserted EXACTLY ONCE.
        ⚠⚠ AND SAY WHAT EACH CHECK'S PASS VALUE IS *AND WHY*. S113
          predicted 1 where the answer was 3, because it carried a
          view's one-line property onto a procedure. Right answer, wrong
          reasoning, and it could have read as a failure.
VERIFY  SHOW CREATE VIEW Trace_ProductHeaderView\G | grep -o "/" | wc -l
        6 pre-S107 · 3 post-S107 · 2 post-S109 · 0 = P135 COMPLETE.
▶ WHEN THAT READS 0, TRAPS 10 RETIRES AND P82's ARITHMETIC CLOSES.
FRONTEND  every intermediate figure → units# (Kg uom). PART 1 section 6.
▶ AFTER S115: 43 GREEN of 51.
```

---

# THEN — THE REST

```
S116  THE RETURN PATH. rows 20, 42, 43. ⚠ MINTY'S RULING: LAST.
      ⚠⚠ P164's INVERTED SIGN IS LIVE ON BOTH CLIENTS UNTIL THEN.
        ✓ CONFIRMED FROM BOTH SIDES IN S113 — Formulations.js never
          assigns returnSum in any of its three branches; MLOManagement
          does. THE CORRECT SHAPE IS IN THE OTHER FILE.
      ⚠ SURVEY FIRST — P168's cause has never been read. P163's empty
        product-return lot picker and P165's two defects belong here.
S117  THE TAIL.
      row 48  transposed labels on the stock popup
      row 25  one caller of the seven-copy helper
      the helper itself — ⚠⚠ ALL SEVEN CALLERS READ FIRST. SOME OF THE
        DIVISIONS ARE CORRECT. J114: closed-mlcs.html:84 is right and
        :79 is wrong, SAME HELPER, ADJACENT LINES.
      rows 44, 46, 47 — decisions, not fixes. 47 is dead code to delete.
      ▶ 48 = THE CEILING.
THEN  P111 QUICKBOOKS — planning session, no code.
```

## NOT IN S114

```
THE FIVE READ SITES   S115. An empty column reads 0.
THE RETURN PATH       Minty's ruling: last.
P102 THE REBOOT       ✓ UNBLOCKED. ⚠ STILL ITS OWN JOB. Prod has 46
                      updates and NINETEEN DAYS of restart-required.
P115 THE DEAD CODE    ⚠ It grew by three entries in S113 and one of them
                      — the empty-array mat-card — actively misled a
                      session. Worth its own sitting, not a ride-along.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 1, 2 AND 4. ⚠ PART 1 NOW CARRIES SECTIONS 5
  AND 6 — Minty's two S112 rulings, written in at the S113 close.
⚠ ASK MINTY FOR JR15 — the closest precedent by far: column add, model
  attribute, write-path change, and a deliberate decision NOT to touch
  the material side.
⚠ ASK MINTY FOR J12 (the V2 release path is live, the single-release
  function is DEAD), J43 (the mysqldump config trap), J83 (the disguised
  division), and J123.
```

---

## THE LESSONS S113 EARNED

```
1  ⚠⚠ FOUR NAMED FIX SITES WERE ALL DEAD, AND THE LINE BOTH DOCUMENTS
   SAID TO LEAVE ALONE WAS THE DEFECT. :123/:124 sit inside a commented
   <tr>; :191-216 is live markup iterating newList, and every write to
   newList is commented out. The real defect was :107/:108.
   ▶ PATCHING BY THE DOCUMENT WOULD HAVE BUILT AND DEPLOYED CLEAN AND
     CHANGED NOTHING — and the row would have been marked green.
   ▶ "LEAVE THIS ONE ALONE" IS AN ADDRESS TOO, AND IT CAN BE WRONG.

2  ⚠⚠ A LIVE LOOP OVER AN EMPTY ARRAY IS WORSE THAN COMMENTED CODE. The
   comment announces itself; the loop does not. Reachability is about
   what fills the collection, not whether the markup exists.

3  ⚠⚠ A CHECK'S EXPECTED VALUE CAN BE WRONG WHILE THE CHECK IS RIGHT.
   grep -c against SHOW CREATE PROCEDURE returns 3, not 1 — procedures
   keep their newlines, views do not. ▶ SAY WHY A PASS IS THAT NUMBER.

4  ✓✓ A DOCUMENT CLAIM BECAME A MEASUREMENT AND IT COST TEN MINUTES.
   All six qty_allocated read sites are plain Kg sums. ▶ WORTH IT
   PRECISELY BECAUSE THE SAME DOCUMENT HAD JUST BEEN WRONG ABOUT FOUR
   ADDRESSES.

5  ⚠⚠ READING THE PRECONDITION FOUND AN EIGHTH PIECE OF A SEVEN-PIECE
   JOB — P188, released_qty in Kg against final_qty in units. ▶ THAT IS
   WHY S114 WAS NOT STARTED LATE IN A LONG SESSION.

6  ⚠ TRAPS 9 THREE TIMES IN ONE SESSION. MO-0007 at 1:1 cannot move;
   Glutenull at 0.32 lands the division exactly; wduRec changed basis
   invisibly. ▶ ONLY MO-0010 AT 10:1 COULD SHOW THE FIX.

7  ✓ THE FIRST CLIENT-VISIBLE CORRECTION OF THE CAMPAIGN. Every previous
   fix was invisible on prod by design. Glutenull's MO rows read
   "1750 Kg (1750#)" this morning and "1750# (560 Kg)" tonight.
```
