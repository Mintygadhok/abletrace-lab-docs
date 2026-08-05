# PLAN

Written at close of: S103 · for S104.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S103 CLOSE:
  "2# (16.68 Kg)" — the display format for the MR unit count.
  "glutenull only live client - no data so far in mr" — therefore
    NO FALLBACK AND NO DIVISION for old rows. Show the stored value.
  "carry over the yield actions into next session so we dont
    loose focus on that" — P140 is carried forward INTACT below.
  "jr 15 approved"

⚠ S104 HAS TWO JOBS, IN THIS ORDER:
  A · P143 — THE MR UNIT COUNT DISPLAY. Two screens.
  B · P140 — THE YIELD SCREEN. Carried from S102, never reached.
  ⚠ B IS A MEASUREMENT SPEC, NOT A FIX SPEC. Do not start it until
    A is verified on dev.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 05f786c · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺130 · 200
           prod backend 05f786c · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺338 · 200
                served build prod-125014a3ab26
   ⚠ BOTH BOXES MOVED IN S103. These are NOT S102's numbers.
     Backends 2ae869c → 05f786c. Frontends f53986ca → 125014a3ab26.
     pm2 dev 129 → 130, prod 337 → 338.
     If anything differs from the ABOVE, STOP.

   ⚠ PROD: be on the prod terminal and run the block bare, OR ssh
     from the MAC. Never ssh from dev.
     ▶ PUT `hostname -I` AT THE TOP OF THE PROD BLOCK. Prod must
       report 172.31.3.156. S103 ran this four times without
       incident — it works, keep doing it.

2  Then STEP 1. ⚠ STEP 1 IS A READ AND IT DECIDES THE SIZE OF THE
   WHOLE JOB. Do not write any Angular before it comes back.
```

---

## JOB A · P143 · THE MR UNIT COUNT DISPLAY

⚠ THE WHOLE POINT: S103 added the column, the write path, and
  deployed both boxes. THE NUMBER IS STORED AND NOT ONE SCREEN
  SHOWS IT. Minty raised this at close and it is the visible half
  of work already paid for.

### ⚠ STEP 1 · THE ONE UNRESOLVED QUESTION. READ FIRST, CODE NEVER BEFORE.

```
DOES THE LIST'S STORED PROC RETURN THE NEW COLUMN?

The MR list is fed by WhC_GetAllRejectedList_SP, called at
RejectMaterialAndProduct.js:205 via sendNativeQuery.

▶ DISTINGUISHES:
  If the proc SELECTs r.* or the whole table, the column already
    flows through → THE JOB IS FRONTEND ONLY. Two template edits,
    one build, one deploy each side. Half a session.
  If it names columns explicitly and qty_rejected_units is absent,
    the screen CANNOT display what it never receives → THE JOB
    BECOMES A DATABASE OBJECT on BOTH boxes, gated separately,
    NO PROMOTE PATH, backup first. That is its own sitting and
    the frontend work waits.

⚠ TWO READ METHODS FAILED IN S103. Both returned an EMPTY ROW from
  read-rows.js on dev:
    SHOW CREATE PROCEDURE WhC_GetAllRejectedList_SP
    SELECT ROUTINE_DEFINITION FROM information_schema.ROUTINES ...
  ⚠ DO NOT SIMPLY RETRY THEM ON DEV. That is the third attempt at
    a method that has failed twice. → P144

▶ USE PROD'S mysql CLIENT INSTEAD. Prod has ~/.my.cnf and S102/S103
  both used `mysql abletracelab_live -e "..."` there successfully.
  The proc is the same object on both boxes.

  ON PROD:
    hostname -I
    mysql abletracelab_live -e "SHOW CREATE PROCEDURE WhC_GetAllRejectedList_SP\G"

  ⚠ NAME abletracelab_live EXPLICITLY. A bare mysql on prod lands
    in the dormant `abletrace` archive, which carries its own copy
    of this proc and is NOT maintained.
  ⚠ \G not ; — the definition is long and a table render truncates.

  IF THAT ALSO COMES BACK EMPTY, the fallback is:
    mysql abletracelab_live -e "SELECT ROUTINE_DEFINITION FROM
      information_schema.ROUTINES WHERE
      ROUTINE_NAME='WhC_GetAllRejectedList_SP' AND
      ROUTINE_SCHEMA='abletracelab_live'\G"
  ⚠ SCHEMA-SCOPED. Without the clause it matches the archive copy.

⚠ ALSO CHECK THE DETAILS SCREEN'S SOURCE, which is DIFFERENT.
  edit-reject-product loads from warehouseService.getRejectProduct,
  not from the list proc. Grep for what populates it:
    grep -rn "getRejectProduct" ~/abletrace-lab-frontend/src
  ▶ If it is a Waterline find rather than a proc, the column comes
    through automatically and only the template needs changing.
```

### STEP 2 · THE LIST SCREEN — ONE LINE

```
FILE  src/app/Layouts/admin-dashboard/warehouse/rejected-materials/
      rejected-materials.component.html
      ⚠ FRONTEND IS EDITED ON THE MAC. RULES 2.

LINE 63 AS IT STANDS — read in S103, exact:
    <td mat-cell *matCellDef="let element">
      {{_Number(element.qty_rejected).toFixed(decimalPlaces)}} Kg</td>

THE TARGET FORMAT — MINTY'S RULING S103:
    2# (16.68 Kg)

⚠⚠ THIS SCREEN SHOWS MATERIAL AND PRODUCT MRs TOGETHER. The `type`
   column is rendered at line 29, so both kinds are in one table.
   ▶ THE UNIT COUNT MUST APPEAR ON PRODUCT ROWS ONLY.
   ⚠ MATERIAL REJECT IS Kg-MEASURED BY DESIGN — weighing a rejected
     ingredient IS the physical act. It has no unit count and never
     will. Showing 0# against every material row would be a NEW
     DEFECT, introduced by a display fix.
   ▶ GATE ON  element.type === 'Product'.

⚠ NO FALLBACK. NO DIVISION. Minty's ruling: show the stored value
  as-is. Do NOT compute units from Kg for old rows. That is the R2
  acrobatics pattern this whole campaign removed.
  ⚠ THE RULING IS SAFE BECAUSE GLUTENULL HAS ZERO MR ROWS. The only
    rows that can read 0# are dev fixtures MR-0006 and MR-0007.
    ▶ IF A SECOND CLIENT IS EVER ONBOARDED BEFORE THIS SHIPS,
      RE-ASK MINTY. The ruling depends on the table being empty.
```

### STEP 3 · THE DETAILS SCREEN

```
FILE  .../rejected-materials/edit-reject-product/
      edit-reject-product.component.html   (template)
      edit-reject-product.component.ts     (form + load)

TEMPLATE AS IT STANDS — read in S103, lines 23-26:
    <mat-form-field>
      <mat-label>Quantity(kgs)</mat-label>
        <input matInput type="number" pattern="[0-9]*"
               formControlName="qty" required appInputDecimalPlace>
    </mat-form-field>

THE .ts AS IT STANDS:
  line 44-53  the form declaration — controls are product, qty, mlo,
              remarks, disposition, authorizedBy, returnedqty
  line 54     this.rejectProdForm.disable()  ← the whole form
  line 61-69  patchValue from the loaded record. Note qty AND
              returnedqty BOTH read result.qty_rejected.

▶ ADD a control and a field for the unit count, patched from
  result.qty_rejected_units.
⚠ MINTY DECIDES THE SHAPE: a separate "Shipping Units" field above
  Quantity (mirroring the CREATE screen), or the count folded into
  the existing label as 2# (16.68 Kg). ASK. It is a screen question.

⚠⚠ DO NOT UNCOMMENT LINES 49-56. The Save, Return and Edit buttons
   are inside an HTML comment block. THAT IS WHAT MAKES THIS SCREEN
   READ-ONLY. → P142.
   ⚠ IF THEY ARE EVER RE-ENABLED, THE FORM MUST CARRY THE UNITS
     VALUE FIRST — otherwise a save writes qty_rejected_units back
     to 0 and destroys a correctly stored count, silently.
   ▶ If Minty wants editing restored, THAT IS A SEPARATE JOB and
     the units field is its precondition.
```

### STEP 4 · VERIFY — WHAT DONE LOOKS LIKE

```
⚠ Cmd+Q THE BROWSER after the deploy. A hard reload does not clear
  lazy chunks.

ON DEV, company 474, MR list:
  MR-0008  must read  3# (25.020 Kg)
  MR-0007  must read  0# (16.680 Kg)   ← correct. No count stored.
  ⚠ ANY MATERIAL MR ROW must read Kg ONLY, with no # figure.
    If a material row shows 0#, the type gate is missing.

ON DEV, MR-0008 details screen:
  the unit count 3 visible, in whatever shape Minty chose.

⚠ THEN RE-READ THE ROW AND CONFIRM NOTHING MOVED:
  node /home/ubuntu/read-rows.js sql "SELECT id, internalCode,
    qty_rejected, qty_rejected_units FROM rejectmaterialandproduct
    ORDER BY id DESC LIMIT 3;"
  EXPECT 3361 · 25.02 · 3   UNCHANGED. These screens are READS.
  If any figure moved, something writes that should not — STOP.

⚠ GATE DEV, THEN PROMOTE, THEN GATE PROD SEPARATELY.
⚠ PROD HAS ZERO MR ROWS, so the prod gate is: the list renders,
  it is empty, nothing else broke. DO NOT CREATE A CLIENT ROW to
  test. S103 checked the prod screen WITHOUT SAVING and that is
  the right shape.
```

### ⚠ WHAT WOULD MAKE JOB A BIGGER THAN HALF A SESSION

```
▶ If STEP 1 finds the proc does not return the column, the fix is
  a DATABASE OBJECT on both boxes (a new JR entry), gated
  separately, with no promote path, backup first. THAT IS ITS OWN
  SITTING and the frontend work waits behind it.
▶ If Minty wants editing restored on the details screen (P142),
  that is a third job and NOT part of P143.
```

---

## JOB B · P140 · THE YIELD SCREEN

⚠ CARRIED FORWARD FROM S102 AT MINTY'S EXPLICIT REQUEST, S103 CLOSE:
  "carry over the yield actions into next session so we dont loose
   focus on that". NEVER REACHED IN S103.
⚠ ONLY AFTER P143 IS VERIFIED ON DEV. Otherwise it is S105.
⚠ THIS IS A MEASUREMENT SPEC, NOT A FIX SPEC. Claude cannot write
  the fix yet, and saying so is the point. The screen has not been
  read and the file has not been located. What IS specified is
  every check, with the distinguishing result stated in advance.
  ▶ THE FIX SPEC IS THE OUTPUT OF THIS SECTION, not its input.

### WHY IT IS NOT ALREADY SPECIFIED

```
S101 recorded four faults and concluded the screen was wrong
BECAUSE THE NUMBERS BENEATH IT WERE WRONG.
⚠ S102 MEASURED THOSE NUMBERS. THEY ARE RIGHT.
    mprrecievelots 84017 = 42   (7 cases × 6 pouches)
    mprrecievelots 84018 = 7    (7 cases)
  Both exact, both stored.
▶ SO THE SCREEN IS WRONG ON ITS OWN. It COMPUTES where it should
  READ. That is a different bug from the one recorded, and quite
  possibly a smaller one.
⚠ TWO OF S101's FOUR FAULTS ARE DOUBTFUL AS WRITTEN. Do not carry
  them forward as findings:
    R3-b "planned 7.002 on both lines"  — mechanism UNKNOWN
    R3-c "pack-level multiplier MISSING" — it WORKS. 42 IS 7 × 6.
```

### STEP Y1 · THE BEFORE-READING. ⚠ FIRST, AND NO CODE UNTIL IT EXISTS.

```
ON DEV, company 474, MO-0001 (Edit-Mlc) → Check Material Yield.
SCREENSHOT THE WHOLE PANEL. Every column, all three lines.

⚠ THE BUTTON IS GATED (J24): disabled when mlc_status is 1 or 2.
  MO-0001 is produced, so it should be live. If it is greyed, that
  is a DIFFERENT finding — record it and stop.

WHAT MUST BE CAPTURED, per line — Ginger Powder, Pouch, Case:
    the PLANNED figure · the COMPLETED figure · the VARIANCE
    the exact COLUMN HEADERS, verbatim, including the (Kg)

THE KNOWN-CORRECT COMPARISON SET — from the row, S101/S102:
    Ginger Powder   released 58.397 Kg
    Pouch           released 42 Ea      ⚠ THE SCREEN SHOWED 7.002
    Case            released 7 Ea       ⚠ THE SCREEN SHOWED 7.002
    MO qty 7 · received_units 7 · received_qty 58.38
    batches STORED 1.167 · batch_qty 6 · 6 pouches per case

⚠ A FIX WITH NO VISIBLE SYMPTOM STILL NEEDS A BEFORE-READING.
  S100 lesson 4. And S101's figures are a YEAR-OLD MEMORY by the
  standards of this code — RE-READ THE SCREEN, do not assume it
  still shows 7.002.
```

### STEP Y2 · LOCATE THE SCREEN. ⚠ NOT YET KNOWN.

```
⚠ NEITHER THE ROUTE NOR THE COMPONENT PATH HAS BEEN READ. S101 and
  S102 both worked from the screen only. DO NOT GUESS THE FILE —
  S102 lost time twice on plausible-looking wrong files, S103 lost
  two rounds on the wrong MR screens, and J89 records the same on
  release-mat-details (five levels deep, two wrong guesses).

ON THE MAC:
  grep -rn "Check Material Yield" ~/abletrace-lab-frontend/src
  then find the component and read it WHOLE, not by grep.

⚠ IT WILL BE UNDER .../warehouse/mfg-lot-codes/edit-mlc/ — the
  button lives on Edit-Mlc — but CONFIRM, do not assume.
⚠ ALSO GREP THE BACKEND. The figures may arrive pre-computed from
  a controller or a stored proc, as SO status did (J114). If so
  the frontend is innocent and the fix is elsewhere entirely.
  ⚠ IF IT IS A PROC, READ IT FROM PROD's mysql CLIENT. read-rows.js
    cannot print a routine body (P144, proven twice in S103).
```

### STEP Y3 · THE FOUR QUESTIONS

⚠ RULES 1. Before running any check, state what result would
distinguish the two answers. They are stated here.

```
Q1  WHERE DOES `PLANNED` COME FROM?
    ▶ DISTINGUISHES: if it reads mprrecievelots.qty_allocated, it
      would show 42 and 7 — it does not, so it almost certainly
      does NOT read the release rows.
      If it recomputes from the recipe × batches, expect the
      1.167 fingerprint: 6 × 1.167 = 7.002.
      If it reads mlcpackaging, expect FLAT per-level values (J5).
    ⚠ 7.002 IS THE SIGNATURE. Finding it names the source.

Q2  WHY DO POUCH AND CASE SHOW THE SAME NUMBER?
    ▶ DISTINGUISHES: if BOTH lines multiply the same figure by
      batches and ignore the per-level cascade, they collide at
      7.002 — that is the J5 read-time cascade FAILING.
      ⚠ J5 IS THE ENTRY TO READ FIRST. It records that the packing
        cascade is computed at READ time, never stored, and that
        it SILENTLY FALLS BACK TO 1/1/1 if
        WhC_GetFormulaPackagingMaterials stops returning whd_flag
        and pack_level. THAT FALLBACK PRODUCES EXACTLY THIS
        SYMPTOM — every level showing one figure.
    ▶ CHECK THE PROC FIRST, from PROD's mysql client:
        SHOW CREATE PROCEDURE WhC_GetFormulaPackagingMaterials\G
      EXPECT whd_flag and pack_level in the SELECT. If absent,
      the cause is JR6 and the fix is a DATABASE object, not code.
      ⚠ THAT WOULD ALSO MEAN PROD IS AFFECTED. Check both boxes.

Q3  IS `COMPLETED` READING THE RELEASE ROWS?
    ▶ DISTINGUISHES: Completed showed 58.38 for Ginger Powder in
      S101 while the release row holds 58.397. THOSE DISAGREE.
      58.38 is 7 × 8.34 — the CORRECT figure, arrived at by a
      different route than the stored one.
      ⚠ SO PLANNED AND COMPLETED MAY READ TWO DIFFERENT SOURCES,
        and the variance is the difference between two routes
        rather than between plan and actual. That would make the
        whole variance column meaningless, not merely wrong.
      ▶ THIS IS THE MOST IMPORTANT OF THE FOUR. Establish it
        before proposing anything.

Q4  IS THE VARIANCE COMPUTED OR STORED?
    ▶ DISTINGUISHES: −34.998 is exactly 7.002 − 42. If the screen
      computes planned − completed live, fixing planned fixes the
      variance with no further work. If the variance is stored
      anywhere, it needs a heal decision.
    ⚠ EXPECT COMPUTED. Confirm rather than assume.
```

### STEP Y4 · THE LABEL FAULT — INDEPENDENT, FIX REGARDLESS

```
R3-d  "QTY Planned(Kg)" holds 7, a UNIT COUNT, beside
      "QTY Completed(Kg)" holding 58.38, a real weight.
      Same label, opposite bases, adjacent columns.
▶ A LABEL FIX. ONE LINE. It does not depend on Y1-Y3 and can land
  even if the arithmetic question stays open.
⚠ SAME FAMILY AS P131 (Edit Closed MO line 133 — unit count with a
  weight label). ▶ CONSIDER ONE COMMIT FOR BOTH.
⚠ CONFIRM THE HEADERS VERBATIM FROM THE Y1 SCREENSHOT before
  patching. Do not patch from S101's transcription of them.
```

### STEP Y5 · WHAT DONE LOOKS LIKE

```
ON DEV, company 474, MO-0001:
  Pouch   planned 42 · completed 42 · variance 0
  Case    planned  7 · completed  7 · variance 0
  Ginger  planned and completed on the SAME basis, variance
          explainable — ⚠ 58.397 vs 58.38 is the ACCEPTED batches
          rounding (Minty S102). A ~0.017 Kg variance on the
          ingredient line is CORRECT BEHAVIOUR, not a residual bug.
          ▶ DO NOT CHASE IT. Do not "fix" it to zero.
  Labels correct on both QTY columns.

⚠ THEN RE-READ THE ROWS AND CONFIRM NOTHING MOVED. The screen is a
  READ. If any figure in mprrecievelots or mlomanagement changed,
  something writes that should not — stop and report.

⚠ NO HEAL IS EVER NEEDED HERE. A display fault corrects itself the
  moment the code is right. RULES 3.
⚠ NOT ACTIVATED FOR GLUTENULL (Minty S102). NO CLIENT EXPOSURE, so
  there is no urgency to promote — gate dev properly first.
```

### ⚠ WHAT WOULD MAKE JOB B BIGGER THAN A SESSION

```
▶ If Q2 finds the proc is missing whd_flag / pack_level, the fix is
  a DATABASE object on both boxes (JR6), gated separately, with no
  promote path. That is its own sitting.
▶ If Q3 finds planned and completed read genuinely different
  sources, the screen needs a design decision from Minty about
  what "planned" should mean — the recipe requirement, or what was
  actually released. THAT IS A DOMAIN QUESTION, NOT A CODE ONE.
  ⚠ ASK. Do not choose.
```

---

## NOT IN S104 — AND WHY

```
P142  THE COMMENTED-OUT EDIT BUTTONS on /Edit-reject-product.
      ⚠ TOUCHED BY JOB A's STEP 3 — read it, DO NOT change it.
      Re-enabling editing is a separate job with the units field
      as its precondition. ⚠ ASK MINTY whether he wants MR editing
      restored at all. It may be disabled deliberately.

P137  getInternalCode COUNTS GLOBALLY. ⚠ CAUSE FOUND S102, do not
      re-investigate: RejectMaterialAndProduct.js:51 reads
        count({ company_id: company_id })
      but the callers at :63 and :78 pass NO ARGUMENT.
      ▶ SAME FILE FAMILY AS JOB A. DELIBERATELY SEPARATE COMMIT.
      ⚠ ASK MINTY FIRST — renumbering affects how MRs read to a
        client. Business question, not a tidy-up.

P144  read-rows.js cannot print a routine body. ⚠ JOB A's STEP 1
      WORKS AROUND IT by using prod's mysql client. Fixing the
      reader itself is separate. ▶ If the workaround also fails,
      this becomes urgent.

P102  THE REBOOT. Own sitting. ⚠ MISSED EIGHT DAYS RUNNING.
      ⚠ PROD IS NOW 43 UPDATES, UP FROM 29 AT S102.

P108  REVIEW THE J-ENTRIES WITH MINTY. ⚠ PROMOTED BY S103.
      Section_5.md is 2770+ lines and its header has now gone
      stale TWICE. The JR block is the only record of what is not
      in git and it is buried inside session history.
      Own sitting. NOT a tidy-up — it protects the rebuild path.

P111  QUICKBOOKS. ⚠ P82's ARITHMETIC AND STORAGE ARE BOTH CLOSED.
      Only display work stands between (P143, P135, P140).
      PLANNING ONLY, NO CODE.
      ⚠ IT NEEDS A NEW COLUMN — S103 IS THE REHEARSAL. The exact
        sequence that worked: backup → ALTER → declare in the model
        → write path → restart → READ THE ROW.
```

---

## THE LESSONS S103 EARNED

⚠ Kept here rather than added to RULES. If they recur, Claude
proposes a rule; the default is still NO.

```
1  THE SCREEN OVERTURNED THE CODE READ FOR THE THIRD TIME IN TWO
   SESSIONS. PLAN stated as fact that editing an MR erases the
   count, and named the fix site. Both halves were wrong: the
   handler only writes what it is sent, AND there is no edit
   button because someone commented it out.
   ▶ PLAN'S CONFIDENCE IS NOT EVIDENCE. A close writes down what
     it believes; the next session still has to check.
   ▶ REACHING THE ROW — OR THE SCREEN — IS CHEAP.

2  AN ASSERT THAT FIRES IS THE PATCH WORKING, NOT FAILING.
   The first model patch stopped with "found 3" because
   `qty_rejected:` appears in the attributes block AND in BOTH
   object builders. One of those was REJMATOBJ — the material
   side, which must never gain a units field.
   ▶ THE LOOSE PATTERN WOULD HAVE PATCHED THE WRONG BUILDER AND
     LOOKED FINE. Anchor on the full declaration form, not a
     prefix.

3  A BACKUP THAT LOOKS LIKE A BACKUP. Prod's first mysqldump wrote
   842 bytes — a header and no data — because RDS denies FLUSH
   TABLES WITH READ LOCK and --single-transaction alone does not
   suppress it. The file EXISTED and had a plausible size.
   ▶ CHECK grep -c "INSERT INTO" BEFORE TRUSTING A DUMP. File size
     is not evidence.
   ▶ AND THE GUARD WORKED BECAUSE IT RAN BEFORE THE ALTER.

4  NAME THE ROUTE AND THE URL, NOT THE FEATURE. Two rounds of
   screenshots came from /Rejected-material/product and
   /Edit-reject-product before /Reject-products. Same lesson as
   S102 lesson 3, second occurrence.
   ▶ IF IT RECURS A THIRD TIME IT IS A RULE. Say so then.

5  A TOOL THAT FAILS SILENTLY COSTS A JOB. read-rows.js printed an
   EMPTY ROW for two different routine-body queries. Not an error,
   not "no rows" — a blank. That blocked S103 from sizing P143 and
   is why Job A opens with a read rather than a patch.
   ▶ WHEN A TOOL RETURNS NOTHING, ESTABLISH WHETHER IT FAILED OR
     THE ANSWER IS EMPTY. They are different.

6  THE JOB WAS FOUR PIECES AND ONE WAS UNNECESSARY. Step 4b was a
   quarter of the planned work and did not exist as a problem.
   ▶ A SCOPE THAT SHRINKS ON CONTACT IS A GOOD OUTCOME. Say it
     plainly rather than building the piece anyway.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ NOTHING ELSE NEEDED FOR JOB A.
⚠ FOR JOB B: Section 5's J5 and J24 entries — ASK MINTY FOR THEM
  BY NAME at STEP Y3, not at open.
```
