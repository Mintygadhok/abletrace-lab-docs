# PLAN

Written at close of: S109 · for S110.
Disposable. Rewritten whole at every close.

⚠ S109 SHIPPED THREE THINGS AND ALL THREE ARE ON BOTH BOXES.
  281e8bd8  four repoints, frontend
  f4c98e91  the dispatch write, frontend
  JR20      Trace_ProductHeaderView, database, each box separately
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step.

⚠⚠ THE SCOREBOARD: 28 GREEN · 16 RED · 4 REVIEW, of 48.
  ▶ S110's TARGET IS STEP 3 — ROWS 31, 32, 33 AND 34. Minty's ranking.
  ▶ IT TAKES THE BOARD TO 32 GREEN.

⚠⚠ THE PRECONDITION IS ALREADY BUILT. Do not spend the session making a
  fixture. 474 MO-0005 has TWO RECEIPTS. See STEP 3 FIXTURE below.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ALSO the view at TWO divisions on EACH box:
       mysql abletracelab_live -e "SHOW CREATE VIEW
         Trace_ProductHeaderView\G" | grep -o "/" | wc -l
     Expect 2 on EACH. 3 means JR20 did not survive. 0 means P135 is
     done, which it is not.
   ⚠ IF ANY LAYER DIFFERS, STOP AND RECONCILE THE RECORD FIRST.

2  ⚠ CLOSE ROW 23. It is green in the map and NEVER SEEN ON A SCREEN.
   edit-mlo.ts:251 shipped with the other three repoints.
   ▶ Open 474 MO-0003 through the MLO-Management route and read
     Completed Quantity. EXPECT 41.000# (15.170 Kg).
   ⚠ /MLO-Management REDIRECTED to Mfg-lot-codes under test260805's
     roles in S109. If it redirects again, try a different role, and if
     it still will not open, RECORD IT AS UNREACHABLE AND STOP CHASING
     IT. S109 spent four attempts on this. Ten minutes, then move on.

3  Then STEP 3 below. All four rows together.
```

---

## ⚠ WHY STEP 3 IS FOUR ROWS AND NOT ONE

```
32, 33 AND 34 FEED ONE SCREEN FROM DIFFERENT CODE PATHS.
Edit-Mlc's Intermediate Products block is served by TWO STORED
PROCEDURES; its Batch Materials block is served by a JS CASCADE.
▶ FIXING ONE LEAVES THE SCREEN DISAGREEING WITH ITSELF, WHICH IS WORSE
  THAN LEAVING IT ALONE.
Row 31 is the receiving panel on the SAME screen. It belongs in the
same sitting.

⚠ THIS IS NOT LIKE STEP 1. Those were four independent lines. These
  four are one screen.
```

---

# THE JOB · S110

## STEP 3 · FOUR ROWS. ONE SCREEN. ⚠ A FRONTEND BUILD RIDES WITH IT.

### FIXTURE — ⚠ BUILT IN S109. DO NOT DISTURB.

```
DEV COMPANY 474 · MO-0005 · IP-0.37 · 13 units · lot Pdt-260808-1
  TWO RECEIPTS: 5 units (1.850 Kg) and 8 units (2.960 Kg)
  receiveproducts.qty holds 5 and 8 ON SEPARATE ROWS.
  mlomanagement.received_units totals 13.

⚠⚠ THE TWO ARE UNEQUAL DELIBERATELY. If a fix wrongly serves the MO
  TOTAL to each row, BOTH rows read 13 and the error is unmistakable.
  If it serves the per-receipt count, they read 5 and 8.
  ▶ THAT DISTINCTION IS THE WHOLE TEST AND IT DID NOT EXIST BEFORE S109.

⚠ ROW 31 IS ARITHMETICALLY CORRECT ON THIS FIXTURE TODAY. getWdu
  divides each receipt's OWN Kg — 1.850/0.37 = 5, 2.960/0.37 = 8.
  ▶ THE DEFECT IS THE ROUTE, NOT THE NUMBER. DO NOT EXPECT THE SCREEN
    TO LOOK BROKEN. A changed value here would be a FAILURE.

⚠ Batches on MO-0005 reads 0.684 — fractional, because 13/19 does not
  resolve. That is a SECOND STEP 4 FIXTURE, free. Leave it.
```

### 3a · ROW 31 — THE RECEIVING PANEL

```
WhC_GetMoProductReceivingDetails_SP — ADD receiveproducts.qty
THEN edit-mlc.component.html:258, and DELETE getWdu:354.

⚠⚠ PER-RECEIPT, NOT THE MO TOTAL. mlcDetails.received_units is the
  cumulative figure; putting it here prints the whole MO's number on
  every receipt row. THAT IS WHY THE FIXTURE HAS TWO RECEIPTS.
✓ MEASURED S107: the proc selects id, internalCode, mlc_id,
  mlc_packaging_id, received_at, recieved_qty. NO UNIT COUNT. → P157.
✓ MEASURED S109: receiveproducts.qty holds the per-receipt unit count.
  It is the column to add.
⚠ getWdu's ONLY live caller is html:258. Fixing it makes getWdu DEAD →
  delete in the same pass. P115.
  ⚠ getWdu at edit-mlc.ts:354 is a DIFFERENT function from
    mfg-lot-codes.ts:124. Same name, two files. Do not confuse them.
⚠ edit-mlc.ts:295 lotReceived is DEAD ALREADY (J114). DO NOT PATCH IT.
```

### 3b · ROW 32 — WhC_GetMoIntermediateProducts_SP

```
⚠ READ IN FULL S109. NO GUESSWORK REMAINS.

IT SERVES TODAY:
  fosubrecipe.id, fosubrecipe.formulation_id
  subrecipeformulation.formulation_id AS subrecipeformulation_formulation_id
  subrecipeformulation.qty            AS subrecipeformulation_qty      ⚠ Kg
  formulations.myCode / internalCode / title / uom
  formulations.inventory              AS formulations_inventory        ⚠ Kg
  unitmeasurement.unit_name           AS unit_name
JOINS: fosubrecipe → subrecipeformulation → formulations → unitmeasurement
WHERE: fosubrecipe.formulation_id = formulationId

▶ ADD  subrecipeformulation.ship_qty AS subrecipeformulation_ship_qty
✓ NO NEW JOIN. subrecipeformulation is already joined.
✓ THE COLUMN ALREADY EXISTS AND HOLDS CORRECT DATA — ship_qty since
  2022 (J81).
⚠ THIS PROC ALIASES EVERYTHING. The new column needs an alias too, and
  the frontend must read the NEW NAME. → A BUILD RIDES WITH THIS.
⚠ DEFINER is `admin`@`%`. STRIP IT ON RECREATE (JR16).
```

### 3c · ROW 33 — WhC_GetFormulaIntermediateProducts

```
⚠ READ IN FULL S109. Near-twin of 3b — IDENTICAL joins, identical
  WHERE, same parameter. ONE DIFFERENCE AND IT MATTERS.

IT SERVES TODAY:
  fosubrecipe.formulation_id AS fosubrecipe_formulation_id
  subrecipeformulation.qty                      ⚠ Kg, AND UNALIASED
  subrecipeformulation.formulation_id
  formulations.title / internalCode / myCode / uom / allergen / status_id
  formulations.inventory                        ⚠ Kg, AND UNALIASED
  unitmeasurement.unit_name AS unit_name

▶ ADD  formulations.inventory_units
✓ NO NEW JOIN. NO ALIAS NEEDED — this proc selects bare, so the column
  arrives under its own name. CLEANER THAN 3b.
✓ inventory_units has existed since S46 (JR2).
⚠⚠ THE TWO PROCS ALIAS DIFFERENTLY. 3b returns
  `formulations_inventory`; 3c returns `inventory`. ANY FRONTEND CHANGE
  MUST BE WRITTEN AGAINST THE RIGHT ONE. Confirm which component reads
  which proc BEFORE editing the template.
⚠ DEFINER is `admin`@`%`. STRIP IT ON RECREATE.
```

### 3d · ROW 34 — THE JS CASCADE

```
Formulations.js — serve the unit figure to matList for intermediate
rows. ⚠ NOT READ IN S109. This is the one piece of Step 3 still to be
surveyed. ▶ READ IT FIRST.

⚠⚠ 3b/3c FEED THE Intermediate Products BLOCK. 3d FEEDS THE Batch
  Materials BLOCK. SAME SCREEN, SAME PRODUCT, TWO CODE PATHS.
  ▶ ALL FOUR TOGETHER OR NONE.
```

### METHOD AND GATE

```
DATABASE OBJECTS — JR16's method, on each box from its OWN backup:
  1  SHOW CREATE to a .bak file. Verify line and join counts.
  2  Build the new object ON THE BOX by node script. Anchors asserted
     to appear EXACTLY ONCE. Join count asserted to HOLD.
  3  diff old against new.
  4  Apply. Read back OUT OF THE DATABASE, not off the file.
  5  CALL it, then check the screen.
⚠ NEVER PASTE A PROC BODY INTO A TERMINAL. → JR16.
⚠⚠ KEEP THE SCRIPT SHORT. S109's 35-line heredoc truncated in zsh and
  left the shell hanging. The 12-line rewrite worked first time. Find
  lines BY CONTENT rather than embedding long literals.
⚠ Recreate WITHOUT the definer clause. ⚠ grep "DEFINER=" must return 0;
  grep "DEFINER" returns 1 on a correct file because SQL SECURITY
  DEFINER is a different clause and STAYS.

FRONTEND — edited on the MAC. A push builds dev; prod needs a manual
  dispatch. ⚠ Read the commit stamp in the artifact name. ⚠ Cmd+Q the
  browser, not a hard reload — J66.

GATE  Dev first, all four together, screen-proven. Then prod.
      ⚠ THE PROCS AND THE BUILD MUST LAND TOGETHER ON EACH BOX. A proc
        with a new alias and an old frontend shows nothing; an old proc
        with a new frontend shows undefined.

VERIFY on 474 MO-0005 and MO-0004:
  MO-0005  the two receipt rows read 5 and 8. ⚠ NOT 13 AND 13.
  MO-0004  IP-0.37 required must read 15.923# — a UNIT COUNT under a
           header that says "# (UOM)". It reads 5.891 Kg today.
           WH Stock must read 41# — it reads 15.170 Kg today.
  ⚠⚠ BOTH BLOCKS ON THE SCREEN MUST AGREE WITH EACH OTHER.
  ⚠⚠ THE CONTROL — Pouch 4347.000 Ea on MO-0004 MUST NOT MOVE.
```

---

## AFTER STEP 3 — THE ORDER, AND THE REASONING

```
STEP 4   the requirement calculation. TWO ROWS → 34 green.
         ⚠ OWN SESSION, OWN GATE. It moves numbers on a screen BOTH
           CLIENTS USE DAILY. Glutenull has 26 live allocations.
         ⚠ IT REVERSES MINTY'S S105 RULING AND RULES 7 MUST BE
           REWRITTEN, NOT ANNOTATED. Claude drafts; Minty reads first.
         ✓ TWO FIXTURES NOW: 474 MO-0004 (batches 1.769) and MO-0005
           (batches 0.684).

STEP 5   the schema. FIVE ROWS → 39 green. ▶ P82 CLOSES HERE.
         ⚠ OPEN A SESSION ON IT. Do not arrive at it. Schema change on
           a live client DB + Waterline attribute (TRAPS 3, or every
           write vanishes) + write path + five read sites.
         ✓ NO BACKFILL. Measured S108.

STEP 6   the return path. THREE ROWS → 42 green.
         ⚠⚠ SURVEY FIRST. NOT A FIX LIST. Minty's ruling, S108.
         ⚠ THE SIGN ERROR STAYS LIVE ON BOTH CLIENTS UNTIL THEN.
           Accepted knowingly. P164 / P168.

ROW 46   the seven-copy helper → 43 green. Own sitting, all seven
         callers read first. ⚠ ROW 25 IS ONE OF THEM.

ROW 48   the transposed labels → 44 green. P169.
```

---

## IF S110 CLOSES EARLY

```
P169  ⚠ RAISE IT PROPERLY FIRST — row 48 has no queue number yet.
P171  Read what mlodetails.rcp_qty and do_receive_products.qty_to_dispatch
      actually hold. 129 rows of the first are LIVE CLIENT DATA on prod
      and appear in no map.
P115  DELETE THE DEAD CODE. Three named in S109:
        rejected-materials.ts:152-154 getShippingUnits — no caller
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
      ⚠ V3 IS THE LIVE ONE. The controller proves it.
P102  ⚠ THE REBOOT. Prod 28 updates, dev 8, restart required,
      FIFTEEN DAYS, TWO LIVE CLIENTS. ⚠ S105 PROVED DEV CAN FAIL TO
      BOOT SILENTLY. ▶ VERIFY PM2 STARTS ON BOOT FIRST.
```

## NOT IN S110

```
STEP 4, STEP 5, STEP 6   each needs its own session. See above.
THE SEVEN-COPY HELPER    own sitting.
P111 QUICKBOOKS          planning only, and Minty's call when.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 2 AND 4. The map and the fixture.
⚠ ASK MINTY FOR JR16 AND JR20. Step 3 follows JR16's method exactly,
  and JR20 is the most recent worked example of it.
⚠ ASK MINTY FOR J119 if a Step 3 finding is questioned — it holds the
  procedure reads.
```

---

## THE LESSONS S109 EARNED

```
1  ⚠⚠ A SURVEY CAN BE WRONG IN BOTH DIRECTIONS. S108 warned the map
   would MISS sites. It also MIS-MARKED THREE THAT WERE ALREADY FIXED —
   one of them carrying a comment in the code saying so.
   ▶ THREE OF NINE STEP 1 ITEMS NEEDED NO WORK. READ THE LINE BEFORE
     PATCHING IT.

2  ⚠ AN ADDRESS IS A CLAIM. Row 21 named a dividing function that
   NOTHING CALLS, while the live template three files away was already
   correct AND type-gated. ▶ CONFIRM THE CALLER, NOT JUST THE CODE.

3  ⚠⚠ "ONE-LINE REPOINT" DESCRIBES A CALL SITE AND SAYS NOTHING ABOUT
   WHAT IT CALLS. Row 25 looked identical to three that were repoints.
   It calls a helper that divides, with six other callers, some of which
   pass it the right thing. ▶ READ THE FUNCTION BODY FIRST.

4  ⚠⚠ A ROUND-TRIP IS WORSE THAN A DIVISION AND LOOKS THE SAME.
   Row 30's operator TYPES the unit count; the app derives Kg from it
   correctly, then divides that Kg back to rebuild the count it was
   already given. ▶ ASK WHERE THE NUMBER CAME FROM, NOT JUST WHAT THE
   LINE DOES.

5  ⚠ A GATE THAT CANNOT SHOW THE THING IT IS GATING IS NOT A GATE.
   The first prod MR query filtered to Product and would have hidden
   Hagensborg — the entire reason for the gate. MINTY CAUGHT IT.

6  ⚠ ON PROD, "NOTHING MOVED" WAS THE PASS CONDITION. Glutenull is
   0.32 Kg per unit, so the old division landed exactly and a correct
   fix is INVISIBLE there. The fixtures at 0.37 and 0.7 on dev are the
   only reason any of it was provable. → TRAPS 9, earned again.

7  ⚠ KEEP PASTED SCRIPTS SHORT. A 35-line heredoc truncated in zsh and
   hung the shell. The 12-line rewrite worked first time. ⚠ THIS FAILED
   LOUDLY; JR16's S104 version of the same thing failed SILENTLY and
   nearly killed a stored procedure.
```
