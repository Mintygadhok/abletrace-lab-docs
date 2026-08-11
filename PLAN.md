# PLAN

Written at close of: S114 · for S115.
Disposable. Rewritten whole at every close.

⚠ S114 SHIPPED ONE COMMIT — 4910b46d, both boxes. The release status
  indicator reads final_qty_kg for products.
⚠⚠ THE SCOREBOARD IS UNCHANGED: 38 GREEN · 10 RED · 3 REVIEW, of 51.
  48 IS THE CEILING.

⚠⚠ READ THIS FIRST, BEFORE ANY ADDRESS BELOW.
  EVERY ADDRESS IN THIS FILE WAS READ OFF THE FILE IN S114, NOT COPIED
  FROM A MAP. That is the difference between this plan and the five
  before it. ⚠ IT DOES NOT MAKE THEM PERMANENT — a commit that inserts
  lines invalidates every line number below it. ▶ ANCHOR ON TEXT.

⚠⚠ AND THE STANDING INSTRUCTION FOR THIS SESSION, MINTY'S, S114:
  S115 DOES ONE JOB. If something surfaces mid-job it is WRITTEN DOWN
  AND SKIPPED, not chased — unless it blocks the job itself.
  ▶ FIVE SESSIONS HAVE EACH OPENED ON A PLAN AND DISCOVERED SOMETHING.
    The discovery is not the problem; CHASING IT IS.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ALSO CONFIRM S114 HELD, ON EACH BOX:
       git -C ~/abletrace-lab-backend log --oneline -1   expect 4d43bd4
       ls -1dt /home/ubuntu/www-html.bak-* | head -1     expect 4910b46d
   ⚠ DEV ONLY: SHOW COLUMNS FROM mprrecievelots LIKE 'qty_allocated%'
       expect TWO ROWS. ⚠⚠ PROD MUST STILL SHOW ONE.

2  Then THE JOB. ⚠ NO SURVEY FIRST. The reading was done in S114.
```

---

# THE JOB · S115 — THE UNITS CAPTURE

⚠⚠ MINTY'S DESIGN, S114, AND IT REPLACES THE SEVEN-PIECE FRAMING THAT
  S112–S114 CARRIED:

    "If the operator types units and the Kg is derived, the screen is
     unit-anchored and the Kg is a display."

⚠⚠ AND HIS FRAMING OF WHY IT IS A DEFECT AT ALL — the clearest
  statement anyone has made of it:

    A PRODUCT LEAVING TO A CUSTOMER captures a unit count. THE SAME
    PRODUCT LEAVING INTO ANOTHER PRODUCT'S RECIPE DOES NOT.
    Same shelf, same goods, same physical act.

  ▶ THEREFORE add-dispatch-v2 IS THE TEMPLATE, NOT AN INVENTION.
    Bible row 30, fixed S109, PROVEN. ⚠⚠ DO NOT INVENT A THIRD
    PATTERN. TRAPS 2.

## ⚠⚠ IT MOVES NO ROW ON THE BOARD, AND THAT IS NOT A FAILURE

```
Nothing on any screen looks different afterwards except the release
quantity box. ITS ENTIRE VALUE IS THAT IT UNBLOCKS ROWS 37-41 AND
KILLS P184.
▶ RECORDING IT AS "NO PROGRESS" WOULD BE THE MISTAKE. Recording it as
  row movement would be the other one. It is groundwork and the record
  must say so plainly.
```

## ⚠⚠ IT TOUCHES THE LIVE RELEASE PATH

```
BOTH CLIENTS USE IT DAILY FOR MATERIALS. THE PRODUCT BRANCH IS WHAT
CHANGES; THE MATERIAL BRANCH MUST NOT MOVE.
✓ THE BACKEND ALREADY BRANCHES CORRECTLY:
    if (!!data.Rec_Lot_id)     MATERIAL — Kg only, LEAVE IT
    if (!!data.Rec_Product_id) PRODUCT — units belong here
  MATERIALS CANNOT ACCIDENTALLY RECEIVE A UNIT COUNT.
✓ AND THE MATERIAL PATH IS MEASURED CLEAN, S114:
    Ginger 9696.983 − 701.190 = 8995.793 EXACT
    Pouch  9750 − 1323 = 8427 EXACT
```

## THE DEFECT, MEASURED — NOT A CLAIM

```
api/models/MaterialsProductsReleased.js, THE LIVE V2 LOOP FROM :179:
  :239  _ratio = Number(_lot.qty) / Number(_lot.recieved_qty)
  :246  inventory_units −= Number(data.qty_allocated) * _ratio
  :251-254  THE CLAMP REPEATS IT when the lot is short

PROVEN ON dev 474 MO-0006, RELEASED IN S114:
  41 ÷ 15.17 = 2.7027027…  ·  1.793 × that = 4.845945945…
  47 − 4.845945945 = 42.15405405405406      ⚠⚠ STORED
  TRUE: 47 − 4.846 = 42.154
⚠⚠ A WRITE, NOT A DISPLAY. IT IS THE CORE STOCK LINE.
⚠ THE WRONG VALUE IS STILL IN formulations id 3696 ON DEV, LEFT AS THE
  BEFORE PICTURE. ▶ HEAL IT AFTER THE FIX IS PROVEN.

⚠⚠ PLAN PREVIOUSLY SAID :262 AND :228/:256. :228 IS THE **MATERIAL**
  CLAMP. Patching there would have hit the clean branch.
⚠⚠ AND THERE IS A DEAD TWIN AT :83-98 — the old single-release
  function, same shape, inventory only. J12. → P115.
  ▶ THE LIVE PATH IS createReleaseMaterialProductsV2, FROM :179.
```

## THE FIX — IN ORDER

```
a  BACKEND · THE REQUIREMENT BECOMES UNIT-ANCHORED
   api/models/Formulations.js, getFormulaByIdForReleaseMaterial
     :1157  final_qty    = Number(ship_qty) × __f        UNITS  ✓ EXISTS
     :1159  final_qty_kg = Number(qty)      × __f        Kg     ⚠ CHANGES
   ▶ MINTY'S DESIGN: final_qty_kg = final_qty × wgt_kgs_per_unit.
     DERIVED FROM THE UNIT FIGURE, NOT FROM THE STORED qty COLUMN.
   ⚠⚠ THE ONE THING THAT NEEDS BRINGING IN: wgt_kgs_per_unit IS **NOT**
     IN SCOPE IN THAT LOOP. MEASURED S114 — the block reads ship_qty,
     qty, batch_qty and the return sums, and nothing else.
     ▶ IT IS SERVED TO THE PACKAGING CASCADE FURTHER DOWN THE SAME
       FUNCTION (:1201 region, fopackaging). IN REACH, NOT FREE.
     ⚠ IT LIVES ON THE whd_flag ROW OF fopackaging. RESOLVE IT THERE.
   ✓ THEY AGREE TODAY — 4.846 × 0.37 = 1.793 and qty × __f = 1.793.
     ▶ SO A CORRECT CHANGE MOVES NOTHING. THAT IS THE REGRESSION TEST.
   ⚠ THE COMMENT AT :1159 ALREADY CALLS ITSELF "STOPGAP UNTIL THE UNITS
     CAPTURE LANDS". Replace the comment in the same edit. → P118.

b  BACKEND · THE RELEASED TOTAL GAINS A UNIT SIBLING
     :1136  sum = sum + mpreceiveLots.qty_allocated      Kg
     :1160  formulation['released_qty'] = sum
   ▶ ADD A PARALLEL SUM OF qty_allocated_units AND SET
     formulation['released_qty_units'] AT :1161.
   ⚠ THREE LINES. Measured S114 — it is one variable in one branch.
   ⚠⚠ :1124 AND :1205 ARE THE MATERIAL AND PACKAGING BRANCHES. DO NOT
     TOUCH THEM.
   ⚠ PAST ROWS HOLD 0, SO A PART-RELEASED MO WILL READ AS UNRELEASED.
     ✓ DEV TEST DATA ONLY — NO CLIENT HAS A PRODUCT ALLOCATION.
       MEASURED S112 AND RE-COUNTED S114.

c  FRONTEND · THE INPUT CAPTURES UNITS
   release-mat-details.component.html, THE formulaList BLOCK (:113-160)
     :148  [(value)]="recLot.qty"  (keyup)="addQty(...,'product')"
   ⚠ ONE FIELD. NOTHING HIDDEN. Confirmed by reading the template S114.
   ▶ THE OPERATOR TYPES THE COUNT; THE Kg RENDERS BESIDE IT, DERIVED BY
     MULTIPLYING. COPY add-dispatch-v2's qtyWdu / getQty:101.
   ⚠ THE LOT LINE AT :146 ALREADY CARRIES remaining_qty AND
     qty_recieved — BOTH Kg. ▶ THE UNIT FIGURE IS DERIVED, NOT ADDED
     AS A COLUMN. MINTY'S S112 RULING STANDS:
       remaining_units = qty × (remaining_qty ÷ recieved_qty)
     ⚠⚠ receiveproducts.qty IS THE STORED COUNT AND JR21 SERVES IT.

d  FRONTEND · THE AUTO-FILL FILLS UNITS
   release-mat-details.component.ts :296 and :313-329
     remainToFill = final_qty − released_qty
   ▶ ONCE BOTH ARE UNITS THIS IS UNITS MINUS UNITS AND P188 DISSOLVES.
   ⚠⚠ ANCHOR ON :296 PLUS THE console.log BELOW IT. Line :296 alone is
     near-identical to the MATERIAL branch at :215.
   ⚠⚠ AUTO-FILL IS CRITICAL — MINTY, S114. IT IS NOT OPTIONAL AND IT
     CANNOT BE DROPPED TO SIMPLIFY THE JOB.
   ⚠⚠ THIS IS THE S112 REGRESSION'S EXACT SHAPE. Two bases subtracted,
     auto-filled into an input, and a guard that turns green on the
     result. IT MUST MOVE AS ONE PIECE WITH (c).

e  FRONTEND · THE ACCUMULATOR — P193
     :866  formulaList[i].released_qty = released_qty + response.qty
   ⚠⚠ ONCE response.qty IS A UNIT COUNT THIS ADDS UNITS INTO A Kg
     TOTAL. ▶ PART OF THIS JOB, NOT A SEPARATE ONE.
   ⚠ :683 MATERIAL AND :775 PACK ARE CORRECT. LEAVE THEM.

f  BACKEND · THE WRITE
   MaterialsProductsReleased.js, product branch only
     qty_allocated_units = the typed count
     qty_allocated       = typed × wgt_kgs_per_unit
   ⚠⚠ qty_allocated STAYS KILOGRAMS. SIX READ SITES DEPEND ON IT —
     Formulations.js :1103 :1136 :1190 and MLOManagement.js :1097 :1102
     :1107, ALL READ IN FULL IN S113, ALL PLAIN Kg SUMS.
     CHANGING ITS BASIS BREAKS ALL SIX SILENTLY. TRAPS 1's shape.

g  BACKEND · P184 DIES HERE
     :246  inventory_units −= THE TYPED COUNT
     :253  THE CLAMP DOES THE SAME
   ▶ _ratio AT :239 GOES. It has no other consumer — check before
     deleting.
   ⚠ THE CLAMP MUST CLAMP BOTH COLUMNS IN STEP or the two disagree ON
     THE SAME ROW.

h  SCHEMA · PROD, ITS OWN GATE, LAST
     ALTER TABLE mprrecievelots ADD COLUMN qty_allocated_units
       double DEFAULT 0;
     1  BACK UP THE STRUCTURE FIRST, J43's method:
          grep -v -i "database" ~/.my.cnf > /tmp/dump.cnf
          chmod 600 /tmp/dump.cnf
          mysqldump --defaults-file=/tmp/dump.cnf --single-transaction
            --skip-lock-tables --set-gtid-purged=OFF --no-data
            abletracelab_live mprrecievelots
            > ~/mprrecievelots-before-S115-PROD.sql
        ⚠⚠ mysqldump REJECTS the ~/.my.cnf database= line AND THE
          REDIRECT CREATES THE FILE ANYWAY. IT WROTE A 0-BYTE BACKUP IN
          S112 AND ONLY THE CHECK CAUGHT IT.
        ▶ VERIFY: non-zero bytes AND grep -c "CREATE TABLE" = 1.
     2  COUNT THE ROWS BY TYPE BEFORE. 3 ALTER. 4 SHOW COLUMNS.
     5  COUNT AGAIN — MUST BE IDENTICAL. 6 rm -f /tmp/dump.cnf.
     ⚠⚠ RE-COUNT. DO NOT CARRY THE NUMBER FORWARD. S114 found dev at
       127 where the documents said 113 — FOURTEEN ROWS ADDED IN TWO
       DAYS AND NOBODY RE-MEASURED.
     ✓ NO BACKFILL. Glutenull 0, Hagensborg 0.
     ⚠ THE MODEL ALREADY DECLARES THE ATTRIBUTE ON BOTH BOXES (9dac080).

i  P185 RIDES HERE IF THE FILE IS OPEN ANYWAY.
   eval() sums quantities at :239 :322 :399 :439 :456 — ⚠ FIVE SITES,
   NOT THE THREE THE QUEUE SAYS. Measured S114. Replace with reduce.
   ⚠ ONLY IF IT DOES NOT ENLARGE THE DIFF ENOUGH TO OBSCURE THE
     CAPTURE. THE CAPTURE IS THE JOB.
```

## THE GATE

```
DEV FIRST, ON 474 MO-0004.
⚠⚠ IT IS THE LAST UNRELEASED INTERMEDIATE MO. MO-0006 WAS SPENT IN
  S114 TO MEASURE P184. THERE IS NO THIRD.
  ▶ CONSIDER ASKING MINTY TO BUILD A FRESH FIXTURE FIRST — a new
    intermediate at an awkward ratio (NOT 1:1, NOT round), a parent
    that consumes it, an MO created and left unreleased. TEN MINUTES,
    AND IT PROTECTS MO-0004.

MEASURE THE BASELINE BY QUERY FIRST:
  formulations 3696 — inventory 15.597000000000001, inventory_units
    42.15405405405406  ⚠ THE S114 RESIDUE. Heal AFTER the fix proves.
  mprrecievelots — RE-COUNT. It was 127 at the S114 close.

PASS, AND ALL FOUR MUST HOLD:
  1  a fresh product allocation writes a NON-ZERO qty_allocated_units
     MATCHING THE UNITS TYPED
  2  qty_allocated holds the derived Kg
  3  inventory_units falls BY EXACTLY THE UNITS TYPED — ⚠⚠ NO FLOAT
     TAIL. THAT IS THE WHOLE POINT.
  4  ⚠ THE CONTROLS DO NOT MOVE: Ginger Powder and Pouch, the lines
     that bracket the intermediate on every block.

⚠⚠ A ZERO IN qty_allocated_units IS TRAPS 3 FIRING AND IT WILL NOT
  ERROR. The column's DEFAULT IS 0, so an omitted write is
  indistinguishable from a real zero.
⚠ AND DO NOT VERIFY ON A ROUND RATIO. IP2 and IP3 at 10 Kg/unit
  reconciled perfectly in S114 WHILE THE DEFECT WAS LIVE.

PROD: exercise the MATERIAL path on sandbox 465 — ⚠ NOT 464.
▶ PASS ON PROD IS THAT MATERIAL RELEASE STILL WORKS AND NO CLIENT
  FIGURE MOVES. Neither client has intermediates.
```

## ⚠ NOT IN S115 — WRITE DOWN, DO NOT CHASE

```
P192  final_qty rebuilt from `batches` at :1071 :1083 :1095, FRONTEND.
      ⚠ READ IT IF S115 TOUCHES final_qty — otherwise leave it.
P194  the oldRecProducts read-only block, Kg. LOW.
P195  the per-lot error message reads remaining_qty in Kg.
      ⚠ IT WILL CONTRADICT THE BOX. Small, rides with (c) if trivial.
P191  the lot-code scanner. ✓ MATERIALS ONLY, CORRECT. Its own sitting.
THE FIVE READ SITES   S116. An empty column reads 0.
THE RETURN PATH       Minty's ruling: LAST. ⚠ AND IT HAS NEVER BEEN
                      READ. ▶ BUDGET IT AS A SURVEY, NOT A FIX.
P102 THE REBOOT       ⚠ prod: 46 updates, TWENTY DAYS. OWN JOB.
P178 THE RETENTION RULE  ⚠ AWAITING MINTY'S NUMBER.
```

---

# THEN · S116 — ROWS 37-41 · THE FIVE READ SITES

⚠⚠ CANNOT START BEFORE S115. A read repointed against an unpopulated
  column shows 0 — WORSE than the division it replaces, because a
  plausible wrong number becomes an OBVIOUSLY wrong zero on a
  client-facing traceability screen.

```
ROW 39  Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT
        divides qty_allocated, AND joins fopackaging with NO whd_flag
        filter. ✓ ITS SIBLING CARRIES THE FILTER, WITH A COMMENT. Copy it.
ROW 40  Trace_ProductOneStepForwardIP_SP   divides qty_allocated
ROW 41  ...ReleaseDetails_SP               divides qty_allocated
ROW 37  Trace_ProductHeaderView  intermediate_prd_su
ROW 38  Trace_ProductHeaderView  SOH_su
        ⚠⚠ 38 DEPENDS ON 37. DO 37 FIRST. SOH is the headline figure.

METHOD  JR16's, on each box FROM ITS OWN BACKUP. Short node script,
        ⚠ TWELVE LINES. Anchors asserted EXACTLY ONCE.
        ⚠⚠ SAY WHAT EACH CHECK'S PASS VALUE IS *AND WHY*.
VERIFY  SHOW CREATE VIEW Trace_ProductHeaderView\G | grep -o "/" | wc -l
        2 post-S109 · 0 = P135 COMPLETE.
▶ WHEN THAT READS 0, TRAPS 10 RETIRES AND P82's ARITHMETIC CLOSES.
FRONTEND  every intermediate figure → units# (Kg uom). PART 1 section 6.
▶ AFTER S116: 43 GREEN of 51.

⚠ HONEST EXPECTATION: S114 FOUND FOUR UNMAPPED SITES IN ONE SCREEN.
  EXPECT ONE OR TWO SURPRISES HERE TOO. ▶ THEY GET WRITTEN DOWN AND
  SKIPPED. That is the difference between a session that closes and a
  session that digresses.
```

---

# THEN — THE REST

```
S117  THE RETURN PATH. rows 20, 42, 43. ⚠ MINTY'S RULING: LAST.
      ⚠⚠ P164's INVERTED SIGN IS LIVE ON BOTH CLIENTS UNTIL THEN.
      ⚠⚠ BUDGET IT AS A SURVEY. It has NEVER been read, and the last
        time anyone opened a return screen (S108) it found two defects
        in ten minutes. A session scoped as a fix WILL disappoint.
S118  THE TAIL. row 48 transposed labels · row 25 the helper caller.
      rows 44, 46, 47 — decisions, not fixes.
      ▶ 48 = THE CEILING.
THEN  P111 QUICKBOOKS — planning session, no code.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 1, 2 AND 4.
⚠ ASK MINTY FOR JR15 — the closest precedent by far: column add, model
  attribute, write-path change, and a deliberate decision NOT to touch
  the material side.
⚠ ASK MINTY FOR J12 (the V2 release path is live, the single-release
  function at :83-98 is DEAD), J43 (the mysqldump config trap), J83
  (the disguised division), and J124 (S114's entry).
```

---

## THE LESSONS S114 EARNED

```
1  ⚠⚠ A PASS THAT COULD NOT HAVE FAILED IS NOT A PASS. The indicator
   fix changes a COLOUR, not a number, so the after-screen looks the
   same either way. MINTY REFUSED IT AND ASKED FOR THE BEFORE PICTURE;
   the old build was re-served and read ORANGE.
   ▶ WHEN A FIX MOVES A COLOUR, A FORMAT OR A LABEL, THE ROLLBACK
     FOLDER IS THE PROOF AND IT IS TWO MINUTES.

2  ⚠⚠ CHECK BEFORE YOU SPEND. mprrecievelots was 127, not 113 — and two
   of the new rows were PRODUCT releases from that afternoon, so the
   write path had already run and its result was readable for free.
   ▶ ASK WHETHER THE EVIDENCE EXISTS BEFORE SPENDING A FIXTURE.

3  ⚠⚠ AND THOSE FREE ROWS PROVED NOTHING — 10 Kg/unit, TRAPS 9. Only
   the 0.37 fixture could fail and it did, exactly as predicted.
   ▶ PICK THE FIXTURE THAT CAN FAIL. WRITE THE PREDICTION FIRST.

4  ⚠⚠ THE DOMAIN EXPERT REDESIGNED THE JOB AND IT GOT SIMPLER. "Where
   does the Kg figure come from?" exposed a second stored column being
   scaled in parallel. ▶ P188 DISSOLVED.

5  ⚠ "DONE" AND "DEPLOYED" CAME APART, and one command caught it.
   ▶ VERIFY THE DEPLOY BEFORE TIDYING. ALWAYS THAT ORDER.

6  ⚠ TWO PREDICTIONS WERE WRONG WHILE THE CHECKS WERE SOUND — a diff
   line count, and prod's bundle filenames, which DIFFER FROM DEV'S FOR
   THE SAME COMMIT. ▶ THE DEPLOY PROOF IS `diff -r`, NOT A FILENAME.
```
