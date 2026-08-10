# PLAN

Written at close of: S111 · for S112.
Disposable. Rewritten whole at every close.

⚠ S111 SHIPPED FIVE THINGS AND ALL FIVE ARE ON BOTH BOXES.
  3b176720  the intermediate requirement and stock, frontend
  e8e8f572  the Batch Materials stock line, frontend — SUPERSEDES 3b176720
  fc78ce1   Formulations.js:1156, BACKEND
  JR22      BOTH intermediate procedures, database, each box separately
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step on all four layers.

⚠⚠ THE SCOREBOARD: 34 GREEN · 0 PART · 10 RED · 4 REVIEW, of 48.
  ▶ THE "PART" STATUS RETIRES. No row wears it.
  ▶ S112's TARGET IS STEP 5 PART ONE — the schema and the write path.

⚠⚠ S112 IS THE FIRST SCHEMA CHANGE ON A LIVE CLIENT DATABASE IN THIS
  CAMPAIGN. Everything before it has been read paths. THIS ONE WRITES.
  ▶ TREAT IT ACCORDINGLY. Its own session, its own gate, nothing else in it.

⚠⚠ MINTY'S RULING, S110, STILL GOVERNS: THE CAMPAIGN FINISHES BEFORE
  QUICKBOOKS. The clients are new and carry almost no data, so schema
  changes are cheap NOW. Step 5's column add touches ZERO client rows today.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   ⚠ ON EACH BOX, also confirm S111 held:
       mysql abletracelab_live -e "SHOW CREATE PROCEDURE
         WhC_GetMoIntermediateProducts_SP\G" | grep -c "subrecipeformulation_ship_qty"
     Expect 1 on each.
       mysql abletracelab_live -e "SHOW CREATE PROCEDURE
         WhC_GetFormulaIntermediateProducts\G" | grep -o "join" | wc -l
     Expect 3 on each.
   ⚠ IF ANY LAYER DIFFERS, STOP AND RECONCILE THE RECORD FIRST.

2  ⚠⚠ P177 FIRST, AND IT IS NOT OPTIONAL. Measure whether prod has a pm2
   systemd unit. DEV DOES NOT — `systemctl is-enabled pm2-ubuntu` returns
   `not-found`, measured S111.
       systemctl is-enabled pm2-ubuntu
   ⚠ READ-ONLY. It changes nothing and it takes ten seconds.
   ▶ IF PROD IS ALSO not-found, P102 IS BLOCKED AND SO IS ANY REBOOT. Say so
     to Minty before anything else, because it is the only thing in the
     queue that can take two live clients offline.

3  ⚠ ROW 49's RULING AND P183. Both are one-sentence answers from Minty and
   both shape the bible. Ask at the open, not at the close.
   Then THE JOB below.
```

---

# THE JOB · S112

## STEP 5, PART ONE — THE SCHEMA AND THE WRITE PATH

⚠⚠ PART TWO — the five read sites — IS S113. DO NOT DO BOTH.
  A repointed read against an unpopulated column reads 0. THAT IS WHY THE
  SCHEMA AND THE WRITE PATH COME FIRST.

### WHAT IT IS

```
mprrecievelots HAS NO UNIT COLUMN. It stores qty_allocated in KILOGRAMS,
and five read sites divide it to reconstruct a unit count.

    ALTER TABLE mprrecievelots ADD COLUMN qty_allocated_units double DEFAULT 0;

⚠⚠ THEN DECLARE IT IN THE WATERLINE MODEL. TRAPS 3 — THE COLUMN ALONE IS
  NOT ENOUGH AND THE WRITE VANISHES WITH NO ERROR. This is the trap that
  PROVED itself: received_units banked 0 silently until it was declared, and
  food_safety_enabled has the column and not the attribute TO THIS DAY.

⚠ THEN the write path: createReleaseMaterialProductsV2.
  → J12: V2 IS LIVE. The single-release function in the same file is DEAD.
    An edit to the dead one is an INVISIBLE NO-OP and it has already cost
    a session once.
```

### THE PRECONDITION, MEASURED S108 — ⚠ RE-MEASURE BEFORE THE ALTER

```
PRODUCT-SIDE ALLOCATIONS ON PROD, by company:
  471 Glutenull 0 · 469 Hagensborg 0 · sandboxes 5
▶ NO BACKFILL. The column starts empty and no client row needs healing.
⚠ THAT WAS MEASURED IN S108, THREE SESSIONS AGO. Re-run it before the
  ALTER — it is one query and the whole no-backfill decision rests on it.
⚠⚠ AND MEASURE IT BY NAMING THE BOX. Dev 471/469 are different companies
  entirely. S110 lost a query to exactly this. → P156.
```

### THE SHAPE OF mprrecievelots — ⚠ READ THIS BEFORE THE ALTER

```
qty_allocated (KG) · MPR_id · Rec_Lot_id · material_id · Rec_Product_id ·
formula_id

⚠⚠ TWO PARALLEL FK PAIRS ON ONE ROW, AND WHICH PAIR IS POPULATED ENCODES
  THE RELEASE TYPE:
      material_id + Rec_Lot_id     = MATERIAL
      formula_id  + Rec_Product_id = PRODUCT
  NOTHING IN THE COLUMN NAMES SAYS SO.
⚠ S108's FIRST MEASUREMENT OF THIS RETURNED ZERO INTERMEDIATES ON EVERY
  COMPANY — because it joined on material_id, which is NULL on every
  intermediate row. THE QUERY COULD NOT HAVE RETURNED A NON-ZERO.
  ▶ RULES 1: a check that cannot return a true pass is not a check.

⚠⚠ MATERIALS ARE Kg-ANCHORED BY RULE. The new column is for PRODUCT rows
  only. Writing a unit count on a material allocation would be a defect,
  exactly as JR15 ruled for the MR screen. ▶ CONFIRM THE WRITE PATH
  BRANCHES ON TYPE BEFORE ADDING THE FIELD TO BOTH.

⚠ returnmpreceivelots IS AN EXACT TWIN, COLUMN FOR COLUMN. It will need the
  same treatment in STEP 6. DO NOT DO IT HERE — but read it, so the two
  are designed consistently rather than discovered separately.
```

### METHOD AND GATE

```
THE ALTER — on each box separately, dev first, gated separately.
  1  BACK UP THE TABLE STRUCTURE FIRST, on each box:
       mysqldump ... mprrecievelots --no-data
     ⚠ ON PROD: --single-transaction --skip-lock-tables --set-gtid-purged=OFF
       WITHOUT skip-lock-tables RDS DENIES THE LOCK AND WRITES A
       HEADER-ONLY FILE THAT LOOKS LIKE A BACKUP. → JR15.
       ▶ CHECK THE BYTE COUNT AND grep -c BEFORE TRUSTING IT.
  2  COUNT THE ROWS BEFORE. Both boxes, by company and by type.
  3  ALTER. ⚠⚠ NAME THE DATABASE: mysql abletracelab_live.
     A bare `mysql` lands in the dormant archive. → P134.
  4  SHOW COLUMNS to read the column back OUT OF THE DATABASE.
  5  COUNT THE ROWS AFTER. They must be identical — an ADD COLUMN with a
     DEFAULT does not lose rows, and proving it costs one query.

THE MODEL ATTRIBUTE — backend, edited and committed ON DEV, pulled on prod.
  ⚠ `git fetch origin` FIRST (P155), then pull, then READ HEAD, THEN restart.
  ⚠ pm2 restart <NAME>, then sleep 15, then curl. ⚠⚠ READ THE MEMORY FIGURE.
    ~21mb means still booting, ~150mb means booted. Proved twice in S111.

THE WRITE PATH — same route. ⚠ ANCHOR ON TEXT, NEVER A LINE NUMBER.
  ⚠⚠ SIX ADDRESSES WERE WRONG IN S111 AND FOUR OF THEM HAD SIMPLY DRIFTED.
    Read the line, then write the anchor from what you read.

GATE  DEV FIRST. Do a real product release on 474 and read the row.
      ⚠⚠ THE PROOF IS THE ROW, NOT THE SCREEN. Nothing displays this column
        until S113, so a screen check would prove nothing either way.
      ▶ THE PASS CONDITION: a fresh product allocation writes a NON-ZERO
        qty_allocated_units matching the units released, AND the Kg column
        still holds what it always did.
      ⚠ A ZERO THERE IS TRAPS 3 FIRING. It will not error.

VERIFY ON PROD:
  ⚠ NEITHER CLIENT HAS PRODUCT-SIDE ALLOCATIONS, so the column is empty on
    every client row BY DESIGN and stays that way until they run an MO with
    an intermediate.
  ▶ THE PASS CONDITION ON PROD IS THAT NOTHING BREAKS AND THE RELEASE SCREEN
    STILL WORKS. Exercise it on sandbox 464.
```

---

## AFTER S112 — THE ORDER, AND THE REASONING

```
S113   STEP 5, PART TWO — the five read sites. FIVE ROWS → 39 GREEN.
       rows 37, 38, 39, 40, 41.
       ▶ P82's ARITHMETIC CLOSES HERE. TRAPS 10 retires with it.
       ⚠ Trace_ProductOneStepBackwardIP_SP has a SECOND defect — no
         whd_flag filter. Its sibling carries one, with a comment. Copy it.
       ⚠ SOH_su is DEPENDENT — it cannot be units-anchored until
         intermediate_prd_su is. Do them in that order.

S114   STEP 6 — SURVEY ONLY. NO CODE. Minty's ruling, S108.
       ⚠⚠ P168's CAUSE HAS NEVER BEEN READ. A second return moves stock, is
         written to the database, and appears NOWHERE on the MO. A material
         movement with no trace on the manufacturing order is a
         TRACEABILITY GAP, IN A TRACEABILITY SYSTEM.
       ⚠ THE SIGN ERROR STAYS LIVE ON BOTH CLIENTS UNTIL S115. Accepted
         knowingly. P164 / P168.
       ⚠ S111 SAW P164's LINE AGAIN — `released_qty = sum` is three lines
         below the line it patched. Still not touched.

S115   STEP 6 — the three fixes. rows 20, 42, 43. → 42 GREEN.

S116   ROW 25 + the seven-copy helper → 43. All seven callers read first.
       ROW 48 the transposed labels → 44. P169.
       ▶ 44 IS THE CEILING — 45 if row 49 is accepted.

THEN   ROWS 44/45/46/47 — decisions, not fixes.
         45 may be correct by design. 47 is dead code to delete.
THEN   P111 QUICKBOOKS — planning session, no code. Minty's call when.
```

---

## IF S112 CLOSES EARLY

```
P177  ⚠⚠ THE pm2 STARTUP UNIT. If prod is also `not-found`, this is the
      highest-value thing available and it unblocks P102.
      ⚠ IT INSTALLS A SYSTEMD UNIT ON A LIVE CLIENT BOX. Own gate.
P181  ⚠ ONE SCREEN CHECK. start-mlc was patched twice in S111 and never
      seen. Production Controller → an MO with an intermediate on 474.
      ▶ CHEAP, AND IT CLOSES A GREEN-BUT-UNPROVEN GAP.
P182  Read the three unlisted Intermediate Products controls.
P179  The myCodee typo. One character.
P174  Read what else consumes mlcDetails.batches after edit-mlc:372.
P115  DELETE THE DEAD CODE. Five named, all proven dead.
P178  Decide a retention rule for the sixteen old build folders on prod.
P170  ⚠ MINTY'S DECISION on healing the pre-JR15 MR rows. ⚠ CHEAPER NOW
      THAN LATER — the same commercial reasoning as P111's ruling.
```

## NOT IN S112

```
STEP 5 PART TWO          its own session. A read against an unpopulated
                         column reads 0.
STEP 6                   survey first, and it is its own session.
THE SEVEN-COPY HELPER    own sitting.
P111 QUICKBOOKS          after the campaign closes. Minty's ruling S110.
P102 THE REBOOT          ⚠⚠ BLOCKED BY P177 UNTIL MEASURED AND FIXED.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠⚠ UNITS-BIBLE.txt — PARTS 2 AND 4. The map and the fixture.
⚠ ASK MINTY FOR JR15 — it is the closest precedent: a column add, a model
  attribute, a write-path change, and a deliberate decision NOT to touch
  the material side.
⚠ ASK MINTY FOR JR16 if any database object needs rebuilding.
⚠ ASK MINTY FOR J12 (the V2 release path) AND J121 if a finding is questioned.
```

---

## THE LESSONS S111 EARNED

```
1  ⚠⚠ AN ADDRESS IS A CLAIM, AND SIX WERE WRONG IN ONE SESSION. Four had
   drifted by about six lines because S110's OWN COMMIT inserted a comment
   and two const lines above them. Two frontend addresses in PLAN were
   wrong, one with a WRONG INSTRUCTION attached.
   ▶ WHEN A COMMIT INSERTS LINES, EVERY ADDRESS BELOW IT IS STALE.
   ▶ ANCHOR ON TEXT, NEVER A LINE NUMBER.

2  ⚠⚠ A HALF-FIXED SCREEN IS WORSE THAN A CONSISTENTLY WRONG ONE. Between
   the two S111 commits, one product's stock read 47 units in one block and
   17.390 Kg in the other, one block apart.
   ▶ CHECK WHETHER A ROW DESCRIBES EVERY SITE THAT SHOWS THAT FIGURE.

3  ⚠⚠ SCOPE BY STRUCTURE WHEN THE SAME LINE IS RIGHT ELSEWHERE. Three loops,
   identical markup, two of them correct. The patch split on the loop
   declarations and asserted counts before, inside and after.
   ▶ THE PROOF IS THE BRACKETING LINES, NOT THE COUNT.

4  ⚠⚠ A CHECK COPIED FROM ONE LAYER TO ANOTHER STOPS BEING A CHECK. JR16's
   DEFINER= rule is true of a FILE and false of a live object. Third
   mis-scoped check this campaign.
   ▶ SAY WHAT A PASS LOOKS LIKE, AND RE-ASK IT WHEN THE LAYER CHANGES.

5  ⚠⚠ THE FRONTEND REPO EXISTS ON BOTH MACHINES. That is the one wrong-box
   case environment does not catch, and a patch there would fail SILENTLY.
   ✓ `hostname -I` caught the other one BY ERRORING on macOS.

6  ⚠⚠ TWO SUPERSEDED ARTIFACTS WERE DOWNLOADED AND ONE WAS OFFERED FOR
   DEPLOYMENT. Reading the stamp caught it. The run number is a free second
   signal — lower is older.

7  ⚠ THE 12-LINE SCRIPT RULE IS NOT A STYLE PREFERENCE. 21 lines hung the
   shell; 11 worked first time. Third truncation in three sessions.

8  ⚠⚠ A PRECONDITION WRITTEN DOWN AND NEVER RUN IS NOT A CONTROL. P102 has
   said "VERIFY PM2 STARTS ON BOOT FIRST" for sessions. The first time
   anyone ran it, it came back negative.
   ▶ IF AN ITEM NAMES A CHECK, RUN THE CHECK BEFORE SCHEDULING THE WORK.

9  ✓ MINTY'S IN-SESSION CALL TO FIX ROW 49 RATHER THAN DEFER IT WAS RIGHT,
   AND THE REASONING TRANSFERS: the column was already served, the templates
   were already open, and deferring would have shipped a self-contradicting
   screen to prod. ▶ WHEN A DISCOVERY MAKES THE CURRENT STATE WORSE THAN
   BOTH THE BEFORE AND THE AFTER, FINISH IT.

10 ✓ THE SPLIT DECISION PAID AGAIN. S110 split rows 32/33/34/36 out of Step
   3 rather than force them; S111 landed all four cleanly in one session
   BECAUSE the reading had already been done.
```
