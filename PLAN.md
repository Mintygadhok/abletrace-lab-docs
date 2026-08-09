# PLAN

Written at close of: S110 · for S111.
Disposable. Rewritten whole at every close.

⚠ S110 SHIPPED FOUR THINGS AND ALL FOUR ARE ON BOTH BOXES.
  0dad104d  the receiving panel repoint, frontend
  bc03b22d  getFactor in three components, frontend
  9230789   both final_qty lines, BACKEND
  JR21      WhC_GetMoProductReceivingDetails_SP, database, each box
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step.

⚠⚠ THE SCOREBOARD: 30 GREEN · 3 PART · 11 RED · 4 REVIEW, of 48.
  ▶ 44 IS THE CEILING. Rows 44/45/46/47 close as DECISIONS, not fixes.
  ▶ S111's TARGET IS ROWS 32, 33, 34 AND 36. IT TAKES THE BOARD TO 34.

⚠⚠ MINTY'S RULING, S110 — WHY THE CAMPAIGN FINISHES BEFORE QUICKBOOKS.
  The clients are NEW and carry almost no data. Schema and anchor changes
  are cheap now and get harder as they build history. Step 5's column add
  touches ZERO client rows TODAY — measured S108. Once Glutenull runs more
  MOs and Hagensborg starts producing, the same change means dividing
  kilograms to reconstruct units on live rows, which is the exact
  round-trip this campaign exists to remove.
  ▶ P111 QUICKBOOKS STARTS AFTER THE BIBLE CLOSES. NOT IN PARALLEL.

⚠⚠ THE PRECONDITION IS ALREADY MEASURED. subrecipeformulation.ship_qty is
  populated on EVERY row of BOTH boxes — dev 15, prod 10, zero null or zero.
  ▶ S111 NEEDS NO HEAL. Do not spend the session proving it again.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ALSO, on EACH box:
       mysql abletracelab_live -e "SHOW CREATE PROCEDURE
         WhC_GetMoProductReceivingDetails_SP\G" | grep -o "join" | wc -l
     Expect 2 on each, and the proc must contain receiveproducts`.`qty.
   ⚠ AND the view at TWO divisions on EACH box, as at S109.
   ⚠ IF ANY LAYER DIFFERS, STOP AND RECONCILE THE RECORD FIRST.

2  ⚠ CONFIRM WHICH BLOCK READS WHICH PROCEDURE. Ten minutes, and it is the
   one thing that can waste the session.
   ▶ S110's reading suggests the pairing is the OPPOSITE of what earlier
     plans implied:
       Intermediate Products  ← WhC_GetMoIntermediateProducts_SP
                                via MLOManagement.js:393
       Batch Materials        ← WhC_GetFormulaIntermediateProducts
                                via Formulations.js:1083, inside
                                getFormulaByIdForReleaseMaterial at :1079
   ⚠ NOT PROVEN. Confirm before editing any template.
   ⚠⚠ THE TWO PROCS ALIAS DIFFERENTLY. One returns `formulations_inventory`,
     the other returns bare `inventory`. WRITING AGAINST THE WRONG ONE
     SHOWS undefined.

3  Then THE JOB below. All four rows together.
```

---

# THE JOB · S111

## FOUR ROWS. TWO PROCEDURES. ONE BUILD.

### WHAT IS ALREADY DONE, AND WHAT IS NOT

```
⚠⚠ READ THIS FIRST OR THE SCREEN WILL MISLEAD YOU.

S110 FIXED THE ROUNDING ON ROWS 32, 34 AND 36. It did NOT fix the basis.
  The requirement now scales by MO units ÷ batch_qty, computed live.
  The figure it scales is STILL subrecipeformulation.qty — KILOGRAMS.
▶ SO THE SCREEN SHOWS 5.892 Kg WHERE IT SHOULD SHOW 15.923 UNITS.
  5.892 is the CORRECT KILOGRAM figure. It is the wrong BASIS.
⚠ DO NOT READ "5.892 changed from 5.891" AS EVIDENCE THE ROW IS FIXED.
```

### THE FOUR ROWS

```
32  MO detail intermediate qty     PART → OK
33  MO detail intermediate stock   XX   → OK
34  MO detail Batch Materials      PART → OK
36  Intermediate requirement       PART → OK
```

⚠⚠ 32 AND 33 ARE ADJACENT LINES — 172 and 173 — IN THE SAME FOUR TEMPLATES.
  Doing one without the other leaves the requirement right and the stock
  wrong, one line apart, on one screen. ALL FOUR TOGETHER OR NONE.

### A · WhC_GetMoIntermediateProducts_SP

```
▶ ADD  subrecipeformulation.ship_qty AS subrecipeformulation_ship_qty
✓ NO NEW JOIN. subrecipeformulation is already joined.
✓ THE COLUMN EXISTS AND HOLDS CORRECT DATA — ship_qty since 2022 (J81),
  and ZERO null-or-zero rows on either box (measured S110).
⚠ THIS PROC ALIASES EVERYTHING. The new column needs an alias too, and the
  frontend must read the NEW NAME. → A BUILD RIDES WITH THIS.
⚠ DEFINER is `admin`@`%`. STRIP IT ON RECREATE (JR16).
⚠ ONE LIVE CALLER: MLOManagement.js:393. The :621 copy is COMMENTED OUT.
```

### B · WhC_GetFormulaIntermediateProducts

```
▶ ADD  formulations.inventory_units
✓ NO NEW JOIN. NO ALIAS NEEDED — this proc selects bare.
✓ inventory_units has existed since S46 (JR2).
⚠ ONE LIVE CALLER: Formulations.js:1083.
⚠ DEFINER is `admin`@`%`. STRIP IT ON RECREATE.
```

### C · THE FRONTEND

```
FOUR SITES for the requirement, THREE of them identical:
  edit-mlc.component.html:172
  edit-mlo.component.html:172
  start-mlc.component.html:200
    → all three read (item2?.subrecipeformulation_qty || 0) * getFactor()
    → must become the SHIP_QTY alias * getFactor()
  edit-mlo.component.ts:551
    ⚠⚠ NOT TOUCHED IN S110 AND IT IS DIFFERENT. It reads (d.batches || 0)
      where `d` is the FORM, not the MO. The form has no qty and no
      batch_qty. ▶ IT MUST READ this.mlcDetails, NOT d.
    ⚠ IT FEEDS THE EXPORT, NOT THE SCREEN. Still wrong. Fix it here.

FOUR SITES for the stock, the line BELOW each of the above:
  ...html:173 / :201  → {{getQty(item2?.formulations_inventory)}}
  edit-mlo.component.ts:552
  ⚠⚠ CONFIRM THE ALIAS PER FILE. One proc returns formulations_inventory,
    the other returns inventory. THE NAME DEPENDS ON WHICH PROC FEEDS THAT
    BLOCK, AND THAT IS ACTION 2.

⚠ getFactor() ALREADY EXISTS in all three components. Do not add it again.
```

### D · THE BACKEND

```
Formulations.js:1150 — formulation['final_qty'] must scale the SHIP_QTY,
  not formulation.qty.
⚠ THE PROC FEEDS THIS. Once B serves inventory_units and A serves ship_qty,
  read the right property here.
⚠ :1120 (materials) IS CORRECT AND FINISHED. Ingredients are Kg-anchored BY
  RULE. DO NOT TOUCH IT.
⚠ :1195 (packaging) IS CORRECT AND WAS ALWAYS CORRECT. It multiplies by
  mlcDetails.qty. DO NOT TOUCH IT — it is the control.
```

### METHOD AND GATE

```
DATABASE OBJECTS — JR16's method, on each box from its OWN backup:
  1  SHOW CREATE to a .bak file. Verify bytes and join count.
  2  Build the new object ON THE BOX by node script. Anchors asserted to
     appear EXACTLY ONCE. Join count asserted to HOLD.
  3  diff old against new.
  4  Apply. Read back OUT OF THE DATABASE, not off the file.
  5  CALL it, then check the screen.
⚠ NEVER PASTE A PROC BODY INTO A TERMINAL. → JR16.
⚠⚠ KEEP THE SCRIPT SHORT. 12 lines worked twice in S110. A 35-line heredoc
  truncated in zsh in S109 and hung the shell; JR16's S104 version of the
  same thing truncated SILENTLY and nearly killed a procedure.

FRONTEND — edited on the MAC. A push builds dev; prod needs a MANUAL
  DISPATCH — Actions → Build Frontend → Run workflow → target prod.
  ⚠ Read the commit stamp in the artifact name and TYPE IT IN FULL.
  ⚠ `unzip` IS NOT INSTALLED ON THE BOXES. Extract with:
      python3 -c "import zipfile;zipfile.ZipFile('X.zip').extractall('X')"
  ⚠ deploy-frontend.sh takes a LABEL, not a zip, and prepends `dist-`.
  ⚠ Cmd+Q the browser, not a hard reload — J66.
  ⚠ 248 files on a dev build, 127 on prod. Prod carries no source maps.

BACKEND — edited, committed and pushed ON DEV. Pulled on prod.
  ⚠ `git fetch origin` FIRST (P155), then pull, then READ HEAD, THEN
    restart. A restart proves nothing about a pull.
  ⚠ pm2 restart <NAME>, then sleep, then curl. ⚠⚠ 8 SECONDS WAS NOT ENOUGH
    ON PROD IN S110 — the curl returned 000 on a healthy boot. Read the
    MEMORY figure: ~21mb means still booting, ~150mb means booted.

GATE  Dev first, all four rows together, screen-proven. Then prod.
      ⚠⚠ THE PROCS AND THE BUILD MUST LAND TOGETHER ON EACH BOX.

VERIFY on 474 MO-0004:
  IP-0.37 Qty required   MUST READ 15.923 (a UNIT COUNT)
                         ⚠ it reads 5.892 Kg today
  IP-0.37 WH Stock       MUST READ 47 (a UNIT COUNT)
                         ⚠ it reads 17.390 Kg today
                         ⚠⚠ 47, NOT 41. Stock moved in S109.
  ⚠⚠ BOTH BLOCKS ON THE SCREEN MUST AGREE WITH EACH OTHER.
  ⚠⚠ THE CONTROL — Pouch 4347.000 Ea MUST NOT MOVE. Carton 1449 ·
     Case 207 · Pallet 23.
  ⚠ Ginger Powder 2303.910 Kg MUST NOT MOVE — it was fixed in S110 and
    matches Plan Quantity. A change there means the fix reached too far.

VERIFY on PROD:
  ⚠ NEITHER CLIENT HAS INTERMEDIATES, so both blocks are empty on every
    client MO. THE CHANGE IS INVISIBLE THERE BY DESIGN.
  ▶ THE PASS CONDITION ON PROD IS THAT NOTHING MOVES, and that the
    Intermediate Products block still renders without error.
  ⚠ Check Glutenull MO-0002 as the control — 802 ÷ 400 = 2.005 exactly, so
    it is arithmetically incapable of moving.
```

---

## AFTER S111 — THE ORDER, AND THE REASONING

```
S112   STEP 5, PART ONE — the schema and the write path.
       ⚠⚠ ALTER TABLE mprrecievelots ADD qty_allocated_units
       ⚠⚠ THEN DECLARE IT IN THE WATERLINE MODEL. TRAPS 3 — the column
         alone is not enough and the write vanishes with NO ERROR.
       ⚠ THEN the write path: createReleaseMaterialProductsV2 (J12 — V2 is
         live, the single-release function is DEAD).
       ✓ NO BACKFILL. Measured S108: product-side allocations are ZERO on
         both clients.
       ⚠ ON A LIVE CLIENT DATABASE. Own session, own gate.

S113   STEP 5, PART TWO — the five read sites. FIVE ROWS → 39 GREEN.
       ▶ P82's ARITHMETIC CLOSES HERE. TRAPS 10 retires with it.
       ⚠ A repointed read against an unpopulated column reads 0. THAT IS
         WHY THE SCHEMA AND WRITE PATH COME FIRST.
       ⚠ Trace_ProductOneStepBackwardIP_SP has a SECOND defect — no
         whd_flag filter. Its sibling carries one, with a comment.

S114   STEP 6 — SURVEY ONLY. NO CODE. Minty's ruling, S108.
       ⚠⚠ P168's CAUSE HAS NEVER BEEN READ. A second return moves stock,
         is written to the database, and appears NOWHERE on the MO.
       ⚠ THE SIGN ERROR STAYS LIVE ON BOTH CLIENTS UNTIL S115. Accepted
         knowingly. P164 / P168.

S115   STEP 6 — the three fixes. → 42 GREEN.

S116   ROW 25 + the seven-copy helper → 43. All seven callers read first.
       ROW 48 the transposed labels → 44. P169.
       ▶ 44 IS THE CEILING.

THEN   ROWS 44/45/46/47 — decisions, not fixes.
         45 may be correct by design. 47 is dead code to delete.
THEN   P111 QUICKBOOKS — planning session, no code. Minty's call when.
```

---

## IF S111 CLOSES EARLY

```
P176  ⚠ WRITE THE DEPLOY PROCEDURE DOWN PROPERLY. `unzip` is absent from
      the boxes and JR14 does not say so. A step nobody records is a step
      that gets improvised. → 3B.4.
P174  Read what else consumes mlcDetails.batches after edit-mlc:372
      overwrites it from a form control.
P115  DELETE THE DEAD CODE. Four named, all proven dead.
P171  Read what mlodetails.rcp_qty and do_receive_products.qty_to_dispatch
      actually hold. 129 rows of the first are LIVE CLIENT DATA on prod.
P170  ⚠ MINTY'S DECISION on healing the pre-JR15 MR rows. ⚠ CHEAPER NOW
      THAN LATER — the same commercial reasoning as P111's ruling.
P102  ⚠⚠ THE REBOOT. PROD IS NOW 46 UPDATES, dev 8, restart required,
      SIXTEEN DAYS, TWO LIVE CLIENTS. ⚠ S105 PROVED DEV CAN FAIL TO BOOT
      SILENTLY. ▶ VERIFY PM2 STARTS ON BOOT FIRST.
```

## NOT IN S111

```
STEP 5, STEP 6           each needs its own session. See above.
THE SEVEN-COPY HELPER    own sitting.
P111 QUICKBOOKS          after the campaign closes. Minty's ruling S110.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 2 AND 4. The map and the fixture.
⚠ ASK MINTY FOR JR16 AND JR21. S111 follows JR16's method exactly, and JR21
  is the most recent worked example of it — same shape, one column.
⚠ ASK MINTY FOR J119 AND J120 if a finding is questioned.
```

---

## THE LESSONS S110 EARNED

```
1  ⚠⚠ CLAUDE OVERSTATED THE BOARD BY TWO ROWS AND CORRECTED IT ONLY WHEN
   BUILDING THE SPREADSHEET FORCED A ROW-BY-ROW CHECK AGAINST THE RULE.
   Mid-session it claimed 32 green. The true figure is 30, with three rows
   PART — the rounding fixed, the basis not.
   ▶ A ROW IS GREEN WHEN IT SATISFIES THE RULE, NOT WHEN IT WAS TOUCHED.
   ▶ CHECK EACH ROW AGAINST PART 1, NOT AGAINST THE SESSION'S OWN SUMMARY.

2  ⚠⚠ AN ADDRESS IS A CLAIM, AND PLAN'S OWN ADDRESS WAS WRONG AGAIN.
   PLAN said row 34 was "Formulations.js — serve matList". matList is in
   methodForCreateFormula, the create-and-fork WRITE path. The real line is
   in getFormulaByIdForReleaseMaterial, ~450 lines away. Patching where
   PLAN pointed would have built clean, deployed clean and changed nothing.
   ▶ FOURTH TIME THIS CAMPAIGN. READ THE LINE BEFORE PATCHING IT.

3  ⚠⚠ A PROCEDURE'S ALIAS IS NOT ITS COLUMN NAME, AND THE DIFFERENCE IS
   SILENT. WhC_GetMoDetails_SP serves batch_qty as `formula_id__batch_qty`.
   Writing mlcDetails.batch_qty would have given undefined, and
   qty × undefined is NaN — written into a client-facing requirement.
   ▶ CALL THE PROC AND READ THE HEADER. SHOW CREATE tells you what it says;
     the CALL tells you what the columns are named on the wire.

4  ⚠⚠ FOUR WRONG-BOX COMMAND ATTEMPTS, ALL FAILED SAFELY — and that is luck
   of environment, not a control. No mysql on the Mac, no ~/Downloads on
   prod, no backend repo on the Mac. ONE WROTE A 0-BYTE FILE NAMED LIKE A
   BACKUP, which is exactly the S109 Downloads hazard in a new place.
   ▶ AN ALTER TYPED AT THE WRONG PROMPT DOES NOT FAIL SAFELY. Step 5's
     first live command is on the clients' database.
   ▶ `hostname -I` AT THE TOP OF EVERY BLOCK. CHECK THE PROMPT COLOUR.

5  ⚠ A CHECK WHOSE PASS CONDITION WAS NEVER DEFINED IS NOT A CHECK.
   Claude added a bare `curl localhost` to the deploy verification and read
   its 404 as a failure. RULES curls localhost:1337. The 404 was an
   unmatched nginx vhost on a perfectly good deploy.
   ▶ SAY WHAT A PASS LOOKS LIKE BEFORE RUNNING THE CHECK. Same family as
     RULES 1.

6  ⚠ 8 SECONDS IS NOT ALWAYS ENOUGH AFTER A RESTART. Prod returned 000 on a
   healthy boot; the pm2 MEMORY figure told the truth — 21mb still booting,
   158mb booted. ▶ READ THE MEMORY, NOT JUST THE STATUS.

7  ⚠⚠ A ONE-LINE FIX CAN BE HALF A FIX AND LOOK WHOLE. P162 changed 5.891
   to 5.892 on screen. The number moved, the arithmetic improved, and the
   BASIS IS STILL WRONG. A moving number is not proof of a closed row.

8  ✓ THE SPLIT DECISION PAID. Step 3 was planned as four rows and turned out
   to be one row plus three that belonged to Step 4. Reading first cost an
   hour and saved shipping a half-fix as a whole one.
```
