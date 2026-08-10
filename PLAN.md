# PLAN

Written at close of: S112 · for S113.
Disposable. Rewritten whole at every close.

⚠ S112 SHIPPED FIVE THINGS. ALL ON BOTH BOXES EXCEPT THE COLUMN.
  9dac080   MPRRecieveLots.js — the qty_allocated_units attribute, BACKEND
  4d43bd4   Formulations.js — final_qty_kg, BACKEND
  8bbf2c30  the release screen reads final_qty_kg, frontend
  2968c591  the composite units# (Kg uom) on three templates, frontend
  ALTER     mprrecievelots.qty_allocated_units — ⚠⚠ DEV ONLY, deliberately.
            It lands on prod with the write path, the way JR15 did it.

⚠⚠ THE SCOREBOARD: 36 GREEN · 12 RED · 3 REVIEW, of 51. BALANCE 15.
  ▶ 47 IS THE CEILING.

⚠⚠ MINTY'S RULINGS, S112 — THEY DECIDE THE REST OF THE CAMPAIGN.
  1  UNITS ARE THE ANCHOR END TO END, INCLUDING TRACEABILITY. Every
     intermediate figure renders  <units># (<Kg> <uom>)  — J104's format.
  2  ⚠⚠ THE DISCRIMINATOR IS THE THING, NOT THE BLOCK.
       materials    → Kg ONLY, no unit count, anywhere
       formulations → units AND Kg — sold, consumed as an intermediate,
                      or both
     ▶ "The same thing appearing as a material line in one recipe and a
       product elsewhere carries units BECAUSE IT IS A PRODUCT, not
       because of where it sits on a screen." — Minty, S112.
     ✓ IN CODE THE TEST IS: does the row carry a formula_id?
     ✓ AND THE SCHEMA ALREADY AGREES — the release backend branches on
       Rec_Lot_id vs Rec_Product_id. THE RULE AND THE DATA MODEL MATCH.
       IT IS THE SCREENS THAT DO NOT.
  3  THE RETURN PATH GOES LAST.
  ⚠ ALL THREE BELONG IN UNITS-BIBLE PART 1 ON MINTY'S INSTRUCTION.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ALSO CONFIRM S112 HELD, ON EACH BOX:
       git -C ~/abletrace-lab-backend log --oneline -1   expect 4d43bd4
       ls -1dt /home/ubuntu/www-html.bak-* | head -1     expect 2968c591
   ⚠ DEV ONLY: SHOW COLUMNS FROM mprrecievelots
       expect qty_allocated_units, double, DEFAULT 0
     ⚠⚠ PROD MUST NOT HAVE IT YET.

2  ⚠ P181 — ONE SCREEN CHECK, OVERDUE. start-mlc.component.html has been
   patched FOUR TIMES across S111 and S112 and NEVER OPENED.
   Production Controller → 474 MO-0006.
   ▶ EXPECT IP-0.37  4.846# (1.793 Kg)  and  47.000# (17.390 Kg).

3  Then THE JOB below.
```

---

# THE JOB · S113

## ITEM 1 — THE WRONG NUMBER ON MATERIAL TRACEABILITY

⚠⚠ THIS IS THE ONLY WRONG NUMBER IN THE WHOLE QUEUE. Every other open
  item is a RIGHT number reached by a WRONG route. This one is simply
  incorrect, on a screen an auditor reads.

⚠ IT IS SELF-CONTAINED and touches nothing the release capture touches.
⚠ IT WAS TRACED END TO END ON 10 AUGUST — seven hops, every one READ,
  the column NAMED. That knowledge is at its freshest right now.

### WHAT IS WRONG — MEASURED, NOT INFERRED

```
Material Traceability → Salt → One Step Forward, row MO-0010:
      THE SCREEN SAYS    10 Kg (1#)
      THE TRUTH          100 Kg, 10 units    ← the MO list says so
      ⚠⚠ THE COMPLETED FIGURE ON THE SAME ROW READS 100 Kg (10#) AND IS
        CORRECT. ONE ROW, TWO HALVES, CONTRADICTING EACH OTHER.

THE CAUSE — ONE NUMBER, USED TWICE, WRONG BOTH TIMES:
  mlomanagement.qty = 10   ⚠⚠ SHIPPING UNITS SINCE THE S41 FLIP
    printed raw with the product's UOM   → "10 Kg"   ⚠ MISLABELLED
    ceil(10 ÷ wgt_kgs_per_unit 10) = 1   → "1#"      ⚠⚠ A COUNT DIVIDED
                                                        BY Kg-PER-UNIT
  mlomanagement.received_qty = 100   ✓ GENUINELY Kg
    printed raw → "100 Kg"  ✓ · ceil(100 ÷ 10) = 10  ✓ right number,
                                                        wrong route
▶ THE SCREEN WAS WRITTEN WHEN qty MEANT KILOGRAMS. S41 CHANGED THE
  COLUMN'S MEANING AND THIS SCREEN NEVER FOLLOWED. Its neighbour still
  holds Kg, so HALF THE ROW KEPT WORKING — which is why nobody noticed.
⚠ THIS IS J7's SHAPE. S43 fixed exactly this in Trace_ProductProdLotView.
```

### THE FULL TRACE — ALL SEVEN HOPS READ, 10 AUG

```
material-traceability-details.component.ts:162
    traceabilityService.currentMatTraArr.subscribe → result.mlcArray
material-traceability.component.ts:193
    traceabilityService.currentMatTraArray(result)
    ⚠ A SHARED SERVICE, NOT A DIRECT CALL. Two hops, not one.
store/effects/traceability.effects.ts:56-59   ⚠ LOWERCASE `store`
    → traceabilityService.getMaterialTraceability(payload)
Services/Traceability/traceability.service.ts:59   ⚠ CAPITALISED
    apiService.get('traceability/getMaterialTraceability/:id/:mat/:co')
config/routes.js:400  → "Traceability.getMaterialTraceability"
TraceabilityController.js:25  → Traceability.getMaterialTraceability
    ✓ NO V2 DECOY HERE. Checked — twice this session there was one.
api/models/Traceability.js:360
    CALL Trace_MaterialDetails_SP(recLotId, materialId, companyId)

⚠⚠ THE PROCEDURE IS IN NO BIBLE ROW. Rows 37-41 name five procedures;
  THIS IS A SIXTH, feeding a whole traceability screen. → the fourth
  unmapped site found in S112.
```

### ✓ THE PROCEDURE IS INNOCENT — THE DEFECT IS ENTIRELY FRONTEND

```
Trace_MaterialDetails_SP hands over TWO HONEST COLUMNS:
    mlomanagement.qty            UNITS
    mlomanagement.received_qty   KILOGRAMS
  plus wgt_kgs_per_unit from fopackaging via mlcpackaging.
▶ IT DOES NO ARITHMETIC ON THEM. The frontend divides both.
```

### THE FIX

```
a  PROCEDURE  Trace_MaterialDetails_SP — ADD mlomanagement.received_units
              to BOTH the temp_table INSERT and the final SELECT.
              ⚠ JR16 METHOD, on each box FROM ITS OWN BACKUP.
              ⚠ THE TEMP TABLE IS DECLARED WITH ITS COLUMNS — the new one
                must be added in THREE places: the CREATE, the INSERT
                column list, and the SELECT that feeds it.
              ⚠⚠ NEVER PASTE A PROCEDURE BODY THROUGH SSH.

b  .ts :169   qty IS ALREADY UNITS. STOP DIVIDING.
              wduTotal = qty            ← print it
              qtyKg    = qty × wgt_kgs_per_unit

c  .ts :170   received units = THE STORED received_units. STOP DIVIDING.
              wduRec  = element.received_units
              ⚠ received_qty stays as the Kg half.

d  BOTH       ⚠⚠ Math.ceil GOES. It ALWAYS ROUNDS UP — 10.1 Kg at 2 Kg
              per unit displays 6 where 5.05 is true.

e  TEMPLATE   :123 :124 :215 :216 → units# (Kg uom), J104's frozen format.
              ⚠ THESE FOUR CARRY item.formula_id.uom — they are PRODUCT
                rows and they take units BY MINTY'S RULING 2.

f  TEMPLATE   :107 :108 — ⚠⚠ LEAVE THEM ALONE. They are MATERIAL rows
              (item.unit_name, no formula_id) and they already read Kg
              only — CONFIRMED ON MINTY'S OWN SCREENS, 10 AUG.
              ▶ THE ORIGINAL "materials show units" ALARM WAS WITHDRAWN.
                See LESSONS.

g  GATE       Material Traceability → Salt → MO-0010 reads
                MO Qty      10# (100 Kg)     ⚠ was 10 Kg (1#)
                Completed   10# (100 Kg)     ⚠ was 100 Kg (10#)
              ⚠⚠ CONTROL: THE MO-0007 ROW MUST NOT MOVE. It ran under
                IP2 VERSION 1 and reporting version 1's figures is
                CORRECT — a traceability screen that re-cast history
                against the current formulation would be the defect.
                ▶ MINTY'S RULING, S112.
              ⚠ CONTROL: the material figures — 10000 received, 200
                released, 9800 SOH — MUST NOT MOVE and MUST NOT GAIN
                A "#".
```

### THE FIXTURE

```
DEV company 474, IP2 / P2 — ⚠⚠ BUILT BY MINTY IN S112. KEEP IT.
  IP2  FO-0006-2  Salt 10 Kg/batch · 1 unit/batch · 10 Kg per unit
                  Internal container. MO-0010 made 10# (100 Kg).
  P2   FO-0007-2  Ginger 20 Kg + IP2 2# (20 Kg) · 2 units/batch
                  Pouch 5 Kg → Case = 4 Pouch = 20 Kg per case
                  MO-0011 made 7# (140 Kg), batches 3.5.
  ✓ ONE BATCH OF P2 CONSUMES 2 UNITS OF IP2. Clean one-for-one.
  ⚠⚠ EVERY RATIO IS ROUND. 70 ÷ 10 = 7 EXACTLY. A DIVISION AND A STORED
    READ PRODUCE IDENTICAL NUMBERS HERE.
    ▶ PERFECT FOR SEEING THE FLOW. USELESS FOR PROVING A FIX.
    ▶ 474's IP-0.37 / Parent-0.53 at 19 and 13, both prime, REMAINS THE
      PROVING GROUND. TRAPS 9.
  ⚠ IP2 EXISTS IN TWO VERSIONS — v1 at 1 Kg/unit, v2 at 10 Kg/unit.
    MO-0007 ran under v1. THAT PAIRING IS ITSELF USEFUL: at 1:1 the
    division is invisible, at 10:1 it is not.
```

---

# THEN · S114 — ITEM 3 + ITEM 5 · THE UNITS CAPTURE

⚠⚠ THE ROOT CAUSE OF ITEM 4, AND THE CAMPAIGN'S SPINE.
⚠⚠ IT TOUCHES THE LIVE RELEASE PATH — the one that moves warehouse
  stock. BOTH CLIENTS USE IT DAILY FOR MATERIALS. The PRODUCT branch is
  what changes; the MATERIAL branch must not move.

### WHAT IS WRONG

```
On MO-0011 the IP2 line reads 70.000/70.000 Kg with NO unit count, and
its lot line reads 30.000 / 100 Kg. ⚠⚠ EVERY OTHER IP2 FIGURE ON THAT
MO CARRIES UNITS — the requirement 7.000# (70.000 Kg), the stock
3.000# (30.000 Kg), the receipt 140.000 Kg / 7.000#.
▶ ONLY THE RECORD OF WHAT PHYSICALLY LEFT THE WAREHOUSE DOES NOT.
```

### PROVEN THREE WAYS IN S112

```
1  THE TEMPLATE  the product block's input binds recLot.qty and calls
   addQty(...,'product'). NO UNITS FIELD. qtyWdu APPEARS NOWHERE.
2  THE BACKEND   createReleaseMaterialProductsV2 uses only
   data.qty_allocated and subtracts it from formulations.inventory (Kg).
3  ⚠⚠ THE ROW, WHICH SETTLED IT. mprrecievelots 84005 and 84008 allocate
   1.12 and 5.56 against a receipt holding ONE unit / 20 Kg.
   YOU CANNOT ALLOCATE 5.56 UNITS OF ONE UNIT. IT IS Kg.
   ✓ AND 84001 + 84004 = 5.56 + 4.44 = 10.00 Kg exactly, same receipt.
```

### THE FIX

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
             ✓ NO BACKFILL. RE-MEASURED S112 ON PROD: Glutenull 0,
               Hagensborg 0, sandbox 465 has all five. 68 rows total,
               63 material and 5 product, summing exactly.
             ⚠ RE-RUN THAT COUNT ANYWAY. It is one query and the whole
               no-backfill decision rests on it.

b  FRONTEND  THE LOT LINE → 3.000# (30.000 Kg) / 10# (100 Kg)
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
                   A parallel units column would have to be incremented
                   everywhere that one is, and every missed site is a
                   SILENT DIVERGENCE.
                 ▶ TWO RUNNING TOTALS THAT MUST AGREE ARE TWO TOTALS
                   THAT CAN DISAGREE.

c  FRONTEND  THE INPUT CAPTURES UNITS, Kg SHOWN DERIVED BESIDE IT.
             ⚠⚠ COPY add-dispatch-v2's qtyWdu — bible row 30, fixed S109,
               PROVEN. The operator types the count and getQty:101
               derives the Kg by MULTIPLYING.
             ⚠⚠ DO NOT INVENT A THIRD PATTERN. TRAPS 2.

d  FRONTEND  THE AUTO-FILL at release-mat-details.component.ts:326-329
             must fill UNITS, not the Kg it fills today.
             ⚠ remainToFill at :296 goes BACK to final_qty once
               released_qty is units too. ▶ THE S112 STOPGAP RETIRES AND
               final_qty_kg MAY BECOME UNUSED. DECIDE THEN — DO NOT
               DELETE IT IN THE SAME COMMIT.
             ⚠⚠ ANCHOR ON :296 PLUS THE console.log BELOW IT. Line :296
               alone is near-identical to the MATERIAL branch at :215.

e  BACKEND   createReleaseMaterialProductsV2 :262
               qty_allocated_units = the typed count
               qty_allocated       = typed × per-unit weight
             ⚠⚠ qty_allocated STAYS KILOGRAMS. It is read as Kg in SIX
               PLACES — Formulations.js :1103 :1136 :1188 and
               MLOManagement.js :1097 :1102 :1107. CHANGING ITS BASIS
               BREAKS ALL SIX SILENTLY. TRAPS 1's shape.
             ✓ THE LOOP ALREADY BRANCHES CORRECTLY:
                 if (!!data.Rec_Lot_id)     MATERIAL — Kg only, LEAVE IT
                 if (!!data.Rec_Product_id) PRODUCT — units belong here
               MATERIALS CANNOT ACCIDENTALLY RECEIVE A UNIT COUNT.

f  BACKEND   THE PARTIAL-ALLOCATION CLAMP. When remaining < requested,
             :228 and :256 OVERWRITE data.qty_allocated with remaining_qty.
             ▶ THE UNIT FIGURE MUST CLAMP IN STEP or the two columns
               disagree ON THE SAME ROW.

g  ITEM 5 RIDES HERE — SAME COMMIT.
             the product branch currently does:
               _ratio = _lot.qty ÷ _lot.recieved_qty        units per Kg
               inventory_units −= qty_allocated × _ratio
             ⚠⚠ A WRITE, NOT A DISPLAY. It sets the Core Stock Line.
             ⚠ It wears a multiplication and is ALGEBRAICALLY A DIVISION
               by Kg-per-unit — J83's disguised R2 form.
             ✓ ARITHMETICALLY CORRECT TODAY. No client has ever released
               an intermediate, so nothing wrong has been banked.
             ▶ ONCE THE TYPED COUNT EXISTS, SUBTRACT IT DIRECTLY. → P184.

h  GATE      DEV FIRST, on 474 MO-0006 — created in S112 for this,
             unreleased.
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
             PROD: exercise on sandbox 465 — ⚠ NOT 464. Measured S112.
             ▶ PASS ON PROD IS THAT MATERIAL RELEASE STILL WORKS.
```

---

# THEN · S115 — ITEM 4 · THE FIVE READ SITES

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

⚠ WHAT THIS LOOKS LIKE TODAY, SEEN ON MINTY'S FIXTURE 10 AUG:
    Product Traceability, Pdt-260810-3:
      Qty Used  7# (70.000 Kg)   ⚠⚠ THE 7 IS NOT STORED ANYWHERE.
                                   70 ÷ 10 = 7, computed at render time.
      Stock on Hand  7# (140 Kg) ⚠ SOH_su, same shape.
  ▶ ON IP2's ROUND RATIO IT LOOKS FLAWLESS. On IP-0.37 the same code
    produces a float tail. THAT IS TRAPS 9, DEMONSTRATED.

METHOD  JR16's, on each box FROM ITS OWN BACKUP. Short node script,
        ⚠ TWELVE LINES. Anchors asserted EXACTLY ONCE. Slash count
        asserted to FALL by the expected number, join count to HOLD.
VERIFY  SHOW CREATE VIEW Trace_ProductHeaderView\G | grep -o "/" | wc -l
        6 pre-S107 · 3 post-S107 · 2 post-S109 · 0 = P135 COMPLETE.
▶ WHEN THAT READS 0, TRAPS 10 RETIRES AND P82's ARITHMETIC CLOSES.
FRONTEND  every intermediate figure → units# (Kg uom). Minty's ruling 1.
▶ AFTER S115: 43 GREEN of 51.
```

---

# THEN — THE REST

```
S116  ITEM 6 · THE RETURN PATH. rows 20, 42, 43. ⚠ MINTY'S RULING: LAST.
      ⚠⚠ P164's INVERTED SIGN IS LIVE ON BOTH CLIENTS UNTIL THEN.
        Accepted knowingly, re-affirmed S112.
      ⚠ SURVEY FIRST — P168's cause has never been read. P163's empty
        product-return lot picker and P165's two defects belong here.
S117  ITEM 7 · THE TAIL.
      row 48  transposed labels on the stock popup
      row 25  one caller of the seven-copy helper
      the helper itself — ⚠⚠ ALL SEVEN CALLERS READ FIRST. SOME OF THE
        DIVISIONS ARE CORRECT. J114: closed-mlcs.html:84 is right and
        :79 is wrong, SAME HELPER, ADJACENT LINES.
      rows 44, 46, 47 — decisions, not fixes. 47 is dead code to delete.
      ▶ 47 = THE CEILING.
THEN  P111 QUICKBOOKS — planning session, no code.
```

## NOT IN S113

```
THE UNITS CAPTURE     S114. It deserves a session that starts fresh, not
                      one that starts after half a job.
THE FIVE READ SITES   S115. An empty column reads 0.
THE RETURN PATH       Minty's ruling: last.
P102 THE REBOOT       ✓ UNBLOCKED — both boxes now have a pm2 unit.
                      ⚠ STILL ITS OWN JOB. Prod has 46 updates.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 1, 2 AND 4.
⚠ ASK MINTY FOR JR16 — S113 rebuilds a procedure and S115 rebuilds five.
⚠ ASK MINTY FOR JR15 for S114 — the closest precedent: column add, model
  attribute, write-path change, and a deliberate decision NOT to touch
  the material side.
⚠ ASK MINTY FOR J12 (the V2 release path is live, the single-release
  function is DEAD), J43 (the mysqldump config trap), and J122.
```

---

## THE LESSONS S112 EARNED

```
1  ⚠⚠ THE MAP RECORDS SITES. IT DOES NOT RECORD CONSUMERS. S111 changed
   what Formulations.js:1156 SERVES. Rows 34 and 36 name that line and
   both were proven. NEITHER MENTIONS THAT A SECOND SCREEN READS THE
   SAME PROPERTY — and that screen pairs it with kilogram inputs, so the
   auto-fill put 4.846 units into a Kg box and the guard TURNED GREEN on
   a release of nearly THREE TIMES the requirement.
   ▶ BEFORE CHANGING A SERVED VALUE, GREP EVERY CONSUMER OF IT.

2  ⚠⚠ A ROW NAMED AFTER A SCREEN DOES NOT COVER EVERYTHING THE SCREEN
   RENDERS. FOUR INSTANCES NOW:
     row 33  named one figure; there were two, in two blocks   → row 49
     row 34  named one screen; the value fed two               → row 50
     row 45  named "material traceability"; the screen renders MO rows
             for products too                                  → S113
     Trace_MaterialDetails_SP — ⚠⚠ IN NO ROW AT ALL, and it feeds a
             whole traceability screen                         → S113
   ▶ WHEN A ROW IS NAMED FOR A SCREEN, LIST WHAT THE SCREEN ACTUALLY
     SHOWS — AND WHAT FEEDS IT — BEFORE TRUSTING THE NAME.

3  ⚠⚠ A PLAN CAN ASSUME DATA THAT DOES NOT EXIST. Step 5 was scoped as
   though a unit count were arriving and being discarded. IT IS NEVER
   CAPTURED. ▶ CONFIRM THE SOURCE OF A VALUE BEFORE PLANNING A WRITE
   PATH FOR IT.

4  ⚠⚠ THE DOMAIN EXPERT'S CHALLENGE WAS SOUNDER THAN THE ASSUMPTION IT
   CHALLENGED. Minty read the release chain and found it clean: units
   convert to Kg ONCE at receipt, everything after is Kg minus Kg. THAT
   WOULD HAVE CLOSED ROWS 37-41 AS CORRECT-BY-DESIGN. He then ruled the
   OTHER WAY, for consistency, knowing the cost.
   ⚠ CLAUDE HAD TREATED THE Kg-ANCHORED READING AS OBVIOUSLY WRONG.
     IT WAS NOT. RULES: Minty is the domain expert.

5  ⚠⚠ TWO ALARMS RAISED FROM CODE WERE DISPROVEN BY THE SCREEN AND THE
   ROW. (a) "qty_allocated may already be units being subtracted from a
   Kg balance" — disproven by two rows allocating 5.56 against a
   one-unit receipt. (b) "materials show unit counts on the traceability
   screen" — WITHDRAWN; Minty's screens show clean Kg throughout.
   ▶ BOTH RECORDED AS DISPROVEN. An unrecorded wrong answer becomes the
     next session's foundation.
   ▶ AND BOTH TIMES THE CODE IMPLIED SOMETHING THE SCREEN DID NOT SHOW.
     READ THE SCREEN BEFORE RAISING THE ALARM.

6  ⚠⚠ FOUR WRONG-BOX INCIDENTS, AND ONE SHOWED ITS OWN DANGER. A missed
   exit put a read on DEV's frontend copy — SEVENTEEN SESSIONS STALE. It
   printed mlcDetails.batches where the Mac shows getFactor(). AN ANCHOR
   WRITTEN FROM THAT TEXT WOULD HAVE MATCHED NOTHING — OR MATCHED AND
   WRITTEN THE WRONG THING.
   ▶ `hostname` AND `git log --oneline -1` ON EVERY MAC BLOCK.

7  ⚠ A LONG COMMIT MESSAGE TRUNCATED MID-PASTE and left zsh at `>`. The
   first commit had landed; the second had not. FOURTH TRUNCATION IN
   FOUR SESSIONS, and the first that was a single long line rather than
   a heredoc. ▶ THE 12-LINE RULE APPLIES TO COMMIT MESSAGES TOO.

8  ✓ THE GUARDS EARNED THEIR KEEP THREE TIMES IN ONE SESSION — the
   one-character whitespace difference in start-mlc, a 0-BYTE BACKUP
   that ls made look real, and the two-line remainToFill anchor.
   ▶ SCOPE BY STRUCTURE, ASSERT EXACTLY ONCE, READ THE DIFF, AND LET THE
     BRACKETING LINES BE THE CONTROL.

9  ⚠⚠ P102's PRECONDITION HAD NEVER BEEN RUN AND THE ANSWER WAS THE
   OPPOSITE OF THE ASSUMPTION. Dev had NO pm2 unit; PROD DID. NOW had
   recorded the reverse. ▶ MEASURE BOTH BOXES.

10 ✓ FINISHING THE COMPOSITE IN-SESSION WAS RIGHT, AND THE REASONING
   TRANSFERS: the Kg halves were already served, the templates were
   already open, and stopping would have meant TWO prod promotions
   instead of one. ▶ WHEN THE PIECES ARE IN HAND, FINISHING COSTS LESS
   THAN RESUMING.
```
