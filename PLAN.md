# PLAN

Written at close of: S115 · for S116.
Disposable. Rewritten whole at every close.

══════════════════════════════════════════════════════════════════════
⚠⚠ MINTY'S RULING, S115 — READ THIS BEFORE ANYTHING ELSE
══════════════════════════════════════════════════════════════════════

    "I want the intermediate product released as UNITS into the MO, so
     it comes out as a UNIT from stock on hand. That's a clean
     reduction. After that, whatever Kg figures are there for the
     subsequent steps, we can leave them."

▶ S116 IS THE LAST SESSION OF THE UNITS CAMPAIGN.
▶ ITS ONE JOB IS THE CLEAN REDUCTION. Type units, stock falls by
  exactly that count, no float tail.
▶ EVERYTHING DOWNSTREAM — rows 37-41, the traceability Kg figures, the
  display mismatches — IS PARKED. Not abandoned; PARKED, behind the
  reboot, the return path and QuickBooks.

⚠⚠ WHY THE CAMPAIGN STOPS HERE AND NOT SOONER, AND NOT LATER:
    S116 stops a WRONG VALUE BEING WRITTEN. rows 37-41 fix numbers
    being SHOWN. A wrong write compounds forever; a wrong display is
    fixable any afternoon.
  ▶ THE BOARD WILL READ 38 GREEN OF 51 AND THAT IS A DELIBERATE STOP,
    NOT AN UNFINISHED ONE. Say so in the record.

⚠ TWO SESSIONS HAVE NOW MOVED NO ROW — S114 and S115. Both were
  groundwork and both were necessary, but the rate is the rate.
  MINTY NAMED IT. THE ANSWER IS TO FINISH THE WRITE AND STOP.

══════════════════════════════════════════════════════════════════════

⚠⚠ EVERY ADDRESS BELOW WAS READ OFF THE OBJECT OR THE FILE IN S115.
  ⚠ AND THE PREVIOUS PLAN'S ONE UNVERIFIED ADDRESS — the unit weight
    "in reach" in the packaging cascade — WAS WRONG. Two greps
    disproved it. ▶ ANCHOR ON TEXT. CONFIRM BEFORE BUILDING FROM IT.

⚠ ONE JOB. If something surfaces mid-job it is WRITTEN DOWN AND
  SKIPPED, unless it blocks the job. ✓ IT HELD IN S115 — P196 was
  found, numbered and left alone.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ THE EXPECTED VALUES HAVE CHANGED SINCE S114:
       dev  backend HEAD   expect 2c2da8b
       prod backend HEAD   expect 4d43bd4
       ⚠⚠ THEY ARE MEANT TO DIFFER. Dev is ONE AHEAD, deliberately.
       ls -1dt /home/ubuntu/www-html.bak-* | head -1  expect 4910b46d BOTH
   ⚠⚠ BOTH BOXES:
       SHOW COLUMNS FROM mprrecievelots LIKE 'qty_allocated%'
       expect TWO ROWS ON EACH. The divergence closed in S115.

2  Then THE JOB. ⚠ NO SURVEY. The reading was done in S115.
```

---

# THE JOB · S116 — THE CLEAN REDUCTION

## WHAT IT LOOKS LIKE WHEN IT IS DONE

```
THE OPERATOR TYPES     1.957            units
THE SCREEN SHOWS       1.957# (43.700 Kg)   Kg DERIVED, a display
THE ROW BANKS          qty_allocated_units 1.957
                       qty_allocated       43.700   ⚠ STAYS KILOGRAMS
STOCK ON HAND FALLS    41 → 39.043      EXACTLY. NO TAIL.
```

⚠⚠ THAT LAST LINE IS THE ENTIRE POINT. formulations.inventory_units is
  the Core Stock Line. Today it receives a figure reconstructed by
  dividing, and the tail compounds on every subsequent release.

## ✓ WHAT IS ALREADY DONE — DO NOT REDO IT

```
(a) ✓ THE REQUIREMENT'S Kg IS DERIVED FROM THE UNIT FIGURE.
      Commit 2c2da8b, DEV ONLY. Formulations.js.
      final_qty_kg = final_qty × the intermediate's OWN wgt_kgs_per_unit,
      fetched by calling WhC_GetFormulaPackagingMaterials once per
      intermediate and reading the whd_flag row.
      ⚠⚠ THE WEIGHT IS NOT IN Formulations.js AND NEVER WAS. grep -i
        "wgt" and "kgs" BOTH RETURN ZERO. The three procedures at the
        head of the function all take the PARENT's formula_id.
      ✓ PROVEN ON 474 MO-0015: 43.700 where the old route gives 43.689.

(h) ✓ THE PROD COLUMN LANDED. mprrecievelots.qty_allocated_units now
      exists on BOTH boxes. 68 rows on prod, 137 on dev, all zero.
      ⚠ The Waterline attribute has been declared on both since 9dac080.
```

## ⚠⚠ THE ORDER IS FORCED. DO NOT RESEQUENCE IT.

```
b1  the PROCEDURE serves the unit column          ← must precede b2
b2  the BACKEND sums it into released_qty_units   ← must precede d
c   the INPUT captures units                      ┐ THESE TWO MOVE
d   the AUTO-FILL fills units                     ┘ AS ONE PIECE
e   the frontend accumulator
f   the WRITE banks both figures
g   P184 dies — inventory_units falls by the typed count

⚠⚠ (c) AND (d) CANNOT BE SPLIT. Units in the box with a Kg auto-fill IS
  THE S112 REGRESSION — it offered 4.846 into a Kg input and the guard
  turned GREEN on a 170% over-release. That is the shape to avoid.
⚠ AND (b2) BEFORE (d), because the auto-fill needs to know how many
  units have already been released.
```

## THE PIECES

```
b1 DATABASE · JR24 · THE PROCEDURE SERVES THE UNIT COLUMN
   WhC_GetMoMaterialProductReleaseDetails_SP, EACH BOX SEPARATELY.
   ✓ READ IN FULL S115. ONE SELECT. 8 joins. Column list explicit, one
     per line. `mprrecievelots` IS THE DRIVING TABLE — the column is
     ALREADY IN SCOPE. ⚠ NO NEW JOIN.
   THE ANCHOR, unique in the body:
       `mprrecievelots`.`qty_allocated`,
   ONE LINE ADDED IMMEDIATELY AFTER IT:
       `mprrecievelots`.`qty_allocated_units`,
   ⚠ THE PROC SELECTS BARE — no aliases anywhere. The column arrives
     under its own name. CONFIRMED BY CALL, S115.
   METHOD: JR16's, on each box FROM ITS OWN BACKUP. Node script,
     ⚠ TWELVE LINES. Anchor asserted EXACTLY ONCE.
   ⚠⚠ SAY WHAT EACH PASS VALUE IS *AND WHY*:
     grep -o "qty_allocated" | wc -l   → 2   ⚠ WAS 1, AND IT IS TWO NOT
       THREE: `qty_allocated` is a SUBSTRING of `qty_allocated_units`,
       and grep -o takes the longest non-overlapping match per
       position, so the new line contributes ONE.
       ▶ IF IT READS 3, THE ANCHOR MATCHED SOMETHING ELSE. STOP.
     grep -o "join" | wc -l            → 8   UNCHANGED
     CALL ...('11612') on dev → qty_allocated_units IN THE HEADER ROW,
       0 in every cell.
   ⚠ 11612 IS MO-0014's MPR, verified S115. ⚠⚠ MPR_id IS NOT A COLUMN
     ON mlomanagement — a query assumed it was and errored.

b2 BACKEND · THE RELEASED TOTAL GAINS A UNIT SIBLING
   Formulations.js, getFormulaByIdForReleaseMaterial, FORMULATION
   BRANCH ONLY.
     sum = sum + mpreceiveLots.qty_allocated     Kg, UNCHANGED
     formulation['released_qty'] = sum           UNCHANGED
   ▶ ADD a parallel sum of qty_allocated_units → released_qty_units.
   ⚠⚠ THE MATERIAL AND PACKAGING BRANCHES DO NOT GET THIS. Materials
     are Kg-anchored BY RULE.
   ⚠ EVERY EXISTING ROW SUMS TO ZERO. A part-released MO reads as
     unreleased on the units side until the write lands. ✓ DEV ONLY —
     no client has a product allocation, re-measured S115.
   ⚠⚠ DO NOT WRITE THIS BEFORE b1. Without the procedure change the sum
     reads undefined and banks NaN, SILENTLY. TRAPS 3.

c  FRONTEND · THE INPUT CAPTURES UNITS
   release-mat-details.component.html, THE formulaList BLOCK (:113-160)
     :148  [(value)]="recLot.qty"  (keyup)="addQty(...,'product')"
   ⚠ ONE FIELD. NOTHING HIDDEN. Confirmed by reading the template S114.
   ▶ THE OPERATOR TYPES THE COUNT; THE Kg RENDERS BESIDE IT, DERIVED BY
     MULTIPLYING. ⚠⚠ COPY add-dispatch-v2's qtyWdu / getQty:101.
     BIBLE ROW 30, FIXED S109, PROVEN. DO NOT INVENT A THIRD PATTERN —
     TRAPS 2.
   ⚠ THE LOT LINE AT :146 CARRIES remaining_qty AND qty_recieved, BOTH
     Kg. ▶ THE UNIT FIGURE IS DERIVED FOR DISPLAY, NOT ADDED AS A
     STORED COLUMN. MINTY'S S112 RULING:
       remaining_units = qty × (remaining_qty ÷ recieved_qty)
     ⚠⚠ receiveproducts.qty IS THE STORED COUNT AND JR21 SERVES IT.

d  FRONTEND · THE AUTO-FILL FILLS UNITS
   release-mat-details.component.ts :296 and :313-329
     remainToFill = final_qty − released_qty
   ▶ ONCE BOTH ARE UNITS THIS IS UNITS MINUS UNITS. P188 DISSOLVES.
   ⚠⚠ ANCHOR ON :296 PLUS THE console.log BELOW IT. Line :296 alone is
     near-identical to the MATERIAL branch at :215.
   ⚠⚠ AUTO-FILL IS CRITICAL — MINTY, S114. IT IS NOT OPTIONAL AND
     CANNOT BE DROPPED TO SIMPLIFY THE JOB.

e  FRONTEND · THE ACCUMULATOR — P193
     :866  formulaList[i].released_qty = released_qty + response.qty
   ⚠⚠ ONCE response.qty IS A UNIT COUNT THIS ADDS UNITS INTO A Kg
     TOTAL. ▶ PART OF THIS JOB, NOT A SEPARATE ONE.
   ⚠ :683 MATERIAL AND :775 PACK ARE CORRECT. LEAVE THEM.

f  BACKEND · THE WRITE
   MaterialsProductsReleased.js, PRODUCT BRANCH ONLY.
     qty_allocated_units = the typed count
     qty_allocated       = typed × wgt_kgs_per_unit
   ⚠⚠ qty_allocated STAYS KILOGRAMS. SIX READ SITES DEPEND ON IT —
     Formulations.js :1103 :1136 :1190 and MLOManagement.js :1097 :1102
     :1107. ALL READ IN FULL S113, ALL PLAIN Kg SUMS. Changing its
     basis breaks all six SILENTLY. TRAPS 1's shape.
   ⚠⚠ FIRST ACTION ON THIS PIECE — grep, DO NOT ASSUME:
       grep -n -i "wgt" api/models/MaterialsProductsReleased.js
       grep -n -i "kgs" api/models/MaterialsProductsReleased.js
     S115 PROVED THE WEIGHT ABSENT FROM Formulations.js WHERE FOUR
     DOCUMENTS SAID IT WAS PRESENT. ▶ IF ABSENT HERE TOO, THE ROUTE IS
     THE SAME SECOND CALL TO WhC_GetFormulaPackagingMaterials, AND
     S115a IS THE WORKED EXAMPLE — for...of before the loop, NOT inside
     .map(), and a loop variable that does not shadow an existing one.

g  BACKEND · P184 DIES HERE — THIS IS THE CLEAN REDUCTION
     :239  _ratio = Number(_lot.qty) / Number(_lot.recieved_qty)  GOES
     :246  inventory_units −= THE TYPED COUNT
     :251-254  THE CLAMP DOES THE SAME
   ▶ CHECK _ratio HAS NO OTHER CONSUMER BEFORE DELETING IT.
   ⚠ THE CLAMP MUST CLAMP BOTH COLUMNS IN STEP or the two disagree ON
     THE SAME ROW.
   ⚠⚠ THE LIVE PATH IS createReleaseMaterialProductsV2, THE BLOCK FROM
     :179. THERE IS A DEAD TWIN AT :83-98 — same shape, inventory only,
     no units. J12. PATCHING IT IS AN INVISIBLE NO-OP. → P115.
   ⚠⚠ PLAN ONCE SAID :262 AND :228/:256. :228 IS THE **MATERIAL**
     CLAMP. Patching there hits the branch that is measurably clean.
```

## ⚠ IF THE SESSION RUNS SHORT — WHERE TO STOP

```
▶ b1 + b2 IS A CLEAN STOPPING POINT. The procedure and the backend sum
  can land, be verified, and committed, with the frontend untouched.
  Nothing changes on any screen and nothing is half-shipped.
⚠⚠ c + d + e + f + g CANNOT BE SPLIT. The input, the auto-fill, the
  accumulator and the write are ONE PIECE. Landing any subset puts
  units into a Kg field somewhere. THAT IS THE S112 REGRESSION.
▶ SO: EITHER STOP AFTER b2, OR FINISH THE WHOLE OF c-g.
```

## THE GATE

```
✓✓ THE FIXTURE EXISTS AND IT CAN FAIL. BUILT BY MINTY, S115, DEV 474.

  IP4  FO-0010  batch_qty 17
       Pouch 0.29 · Carton 7 Pouch 2.03 · Case 11 Carton 22.33
       ⚠⚠ THE whd_flag ROW IS THE CASE AT 22.33 — 77× THE LEVEL 1
         WEIGHT. A wrong-row read is unmissable.
       MO-0014, 41 cases, PRODUCED AND RECEIVED. inventory_units 41.

  P4   FO-0011  batch_qty 23
       Pouch 0.41 · Carton 5 Pouch 2.05 · Case 13 Carton 26.65
       Recipe: Salt 500 Kg + IP4 5 UNITS
       ⚠⚠ MO-0015, 9 cases, CREATED AND UNRELEASED. THAT IS THE GATE.
       __f = 9 ÷ 23 = 0.391304347…
       IP4 required = 5 × __f = 1.957 units, 43.700 Kg

  ⚠ 17, 23, 11, 13, 5, 7 — ALL PRIME OR COPRIME. TRAPS 9 cannot hide.
  ⚠⚠ MO-0004 WAS NOT SPENT. Still the last unreleased intermediate MO
    of the ORIGINAL set, still the S110 before picture. LEAVE IT.

BASELINE BY QUERY BEFORE ANY WRITE:
  formulations 3704 (IP4)  — inventory_units, expect 41
  formulations 3696 (IP-0.37) — inventory_units 42.15405405405406
    ⚠ THE S114 RESIDUE, LEFT DELIBERATELY. HEAL AFTER THE FIX PROVES.
  mprrecievelots — RE-COUNT. 137 dev / 68 prod at the S115 close.
    ⚠⚠ IT WAS 127 AT S114 AND TEN WERE ADDED BUILDING THE FIXTURE.
      DO NOT CARRY THE NUMBER FORWARD.

▶ THEN RELEASE IP4 INTO MO-0015 AND ALL FIVE MUST HOLD:
  1  qty_allocated_units IS NON-ZERO AND MATCHES THE UNITS TYPED
  2  qty_allocated HOLDS THE DERIVED Kg — typed × 22.33
  3  ⚠⚠ formulations 3704 inventory_units FALLS BY EXACTLY THE UNITS
     TYPED. 41 − 1.957 = 39.043 EXACTLY. NO FLOAT TAIL.
     ▶ THIS IS THE ONE THAT MATTERS. IT IS MINTY'S WHOLE REQUIREMENT.
  4  THE CONTROL DOES NOT MOVE: Salt, Kg only, no "#" anywhere.
  5  THE PACKAGING CONTROLS DO NOT MOVE: Pouch 585 · Carton 117 · Case 9

⚠⚠ A ZERO IN qty_allocated_units IS TRAPS 3 FIRING AND IT WILL NOT
  ERROR. The column's DEFAULT is 0 where qty_allocated's is NULL, so an
  omitted write is INDISTINGUISHABLE from a real zero.
⚠⚠ DO NOT VERIFY ON A ROUND RATIO. IP2 and IP3 at 10 Kg/unit
  reconciled perfectly in S114 WHILE THE DEFECT WAS LIVE.
⚠ P196 WILL STILL SHOW 43.689 vs 43.700 ON THE MO DETAIL SCREEN.
  THAT IS EXPECTED AND IS NOT A GATE FAILURE.

PROD: exercise the MATERIAL path on sandbox 465 — ⚠ NOT 464.
▶ PASS ON PROD IS THAT MATERIAL RELEASE STILL WORKS AND NO CLIENT
  FIGURE MOVES. Neither client has intermediates.
⚠⚠ THE BACKEND PROMOTION CARRIES 2c2da8b WITH IT. Dev is one commit
  ahead. NOW's backend line will move by TWO commits, not one. Say it
  out loud at the promote.
⚠⚠ AND THE PROCEDURE GOES TO PROD SEPARATELY. A database object does
  not travel with a deploy. JR24 runs on each box.
```

## AFTER THE GATE — THE HEAL

```
⚠ formulations 3696 holds 42.15405405405406 where 42.154 is true.
  MINTY DECIDES WHETHER TO HEAL IT. It is dev data, so the answer is
  probably yes and it is one UPDATE.
▶ CLAUDE QUERIES AND REPORTS. MINTY DECIDES. RULES 3.
⚠ HEAL AFTER THE FIX IS PROVEN, NEVER BEFORE — it is the before
  picture until then.
```

---

# ⚠⚠ WHAT HAPPENS AFTER S116 — THE CAMPAIGN STOPS

```
MINTY'S RULING S115: the clean reduction is the requirement. The Kg
figures on the subsequent steps can stay as they are.

▶ THE BOARD WILL READ 38 GREEN · 10 RED · 3 REVIEW, OF 51, AND THAT IS
  A DELIBERATE STOP. The record must say so plainly — "unfinished"
  would be as wrong as "complete".

WHAT IS PARKED, AND WHY IT IS SAFE TO PARK:
  ROWS 37-41  the five read sites. DISPLAY ONLY. A wrong number on a
              traceability screen is fixable any afternoon; it does not
              compound and it does not corrupt a stored balance.
              ⚠ THEY ARE NOW UNBLOCKED — the column will be populated —
                so they can be picked up whenever.
  P196        the two intermediate blocks disagree by 0.011 Kg.
              ⚠ MINTY'S RULING: display only.
  P135/TRAPS 10  retire with rows 37-38, whenever those happen.

▶ THE QUEUE REOPENS. IN MINTY'S ORDER, NOT CLAUDE'S. The candidates,
  ranked as Claude sees them, FOR MINTY TO REORDER:
  1  ⚠⚠ P102 THE REBOOT. prod 46 updates, TWENTY-ONE DAYS, TWO LIVE
     CLIENTS. dev 22, TEN OF THEM SECURITY, up from 12 in one session.
     ▶ IT IS GETTING HEAVIER AND IT IS THE ONLY ITEM ON THIS LIST THAT
       IS A SECURITY EXPOSURE.
  2  ⚠⚠ THE RETURN PATH. P164's INVERTED SIGN IS LIVE ON BOTH CLIENTS —
     returning material makes the screen show MORE released.
     ⚠ IT HAS NEVER BEEN READ. BUDGET IT AS A SURVEY, NOT A FIX. The
       last time anyone opened a return screen (S108) it found two
       defects in ten minutes.
  3  P111 QUICKBOOKS. Minty's S110 ruling was "after the units campaign
     closes". IT CLOSES WITH S116. ⚠ ONE FULL PLANNING SESSION, NO CODE.
     ⚠ AND IT NEEDS A NEW COLUMN — TRAPS 3 will bite there.
  4  P178's RETENTION RULE, first execution.
  5  ROWS 37-41 and P196, whenever they earn a slot.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 1, 2 AND 4.
⚠ ASK MINTY FOR:
    JR16  the build-on-the-box method
    JR21  THE CLOSEST PRECEDENT BY FAR — one column added to a SELECT
          list on a procedure that already had the table in scope
    J125  S115's entry — the weight's real location, and why
    J124  S114's entry — the P184 measurement
    J12   the V2 release path is live; :83-98 is DEAD
    J43   the mysqldump config trap
```

---

## THE LESSONS S115 EARNED

```
1  ⚠⚠ "IN REACH, NOT FREE" WAS A GUESS, AND TWO GREPS DISPROVED IT.
   The unit weight is not in Formulations.js at all. The claim was
   written from the SHAPE of the code — there is a packaging cascade,
   packaging carries weights, therefore it must be there.
   ▶ A CLAIM ABOUT WHAT A FILE CONTAINS COSTS ONE GREP.

2  ⚠⚠ NO EXISTING FIXTURE COULD HAVE PROVEN THE FIX, AND A QUERY SAID
   SO BEFORE ANYTHING WAS BUILT. All 18 intermediate rows on dev have
   qty ÷ ship_qty EXACTLY equal to the packaging weight.
   ▶ ASK WHETHER THE EVIDENCE CAN EXIST BEFORE ASKING FOR A FIXTURE.
   ▶ AND SAY OUT LOUD WHEN A CHECK CANNOT FAIL — the MO-0004 screen was
     called unprovable BEFORE it was opened.

3  ⚠⚠ SPLIT BY RISK, NOT BY CATEGORY. Claude proposed deferring the
   whole "database half". Minty split it: the COLUMN is inert (nothing
   reads it), the PROCEDURE is not (a wrong one breaks a live screen).
   The column landed safely at the end of a long session.

4  ⚠ THE PATCH SCRIPT PUT ITS BACKUP IN api/models/ — P153's exact
   hazard, created by the tool meant to make the change safe.
   ▶ BACKUPS TO /home/ubuntu. NEVER BESIDE THE FILE.

5  ⚠ COUNTING THE WRONG PATTERN IS WORSE THAN NOT COUNTING. S114 read
   zero .js files in /tmp as evidence of a tidy. There were 57 .py.

6  ⚠⚠ TERMINAL OUTPUT WAS PASTED BACK INTO THE SHELL. Every line failed
   as "command not found" and nothing was deleted — CONFIRMED BY COUNT.
   ⚠ S106 RECORDS THE SAME PASTE SILENTLY EATING A git pull. THE BURST
     IS NOT THE DANGER; WHAT IT SWALLOWS IS. RULES 5.1.

7  ⚠ NAME THE MO NUMBER AND THE PAGE. Two screenshots were of MO-0014
   when the check needed MO-0015, which sits on page two of a ten-row
   list. A screenshot of the wrong screen cannot fail the check either.

8  ⚠⚠ MINTY ASKED WHY THE CAMPAIGN FELT ENDLESS AND HE WAS RIGHT TO.
   Two sessions moved no row. The answer was not to defend the rate but
   to FIND THE STOPPING POINT — and the stopping point is the clean
   reduction, because that is the last thing that WRITES.
   ▶ WHEN A CAMPAIGN GROWS, ASK WHAT THE MINIMUM IS THAT MUST BE TRUE.
```
