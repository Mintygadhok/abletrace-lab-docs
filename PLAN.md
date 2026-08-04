# PLAN

Written at close of: S102 · for S103.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S102 CLOSE:
  "small rounding changes not of concern - go ahead with your changes
   without worrying about glutenul, data"
  "material yield not yet activated with glutenull"
  "batch is automatically calculated in create mo - operator can change
   the no of shipping units but not how many batches"

⚠ S103 HAS ONE JOB: P82c — THE MR UNITS COLUMN.
  ⚠ EVERY FILE, LINE AND VALUE IS BELOW. NOTHING TO REDERIVE.
  ⚠ NO INVESTIGATION BRANCHES. The finding work is DONE.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 2ae869c · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺129 · 200
           prod backend 2ae869c · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺337 · 200
                served build f53986ca39e9
   ⚠ NOTHING CHANGED IN S102. No commits, no deploys, no schema.
     If anything differs, STOP.
   ⚠ ↺129 ON DEV HAS NOW HELD FOUR SESSIONS.

   ⚠ PROD IS REACHED FROM THE MAC — BUT S102 PROVED THE SAFE FORM.
     Minty was already ON a prod terminal and ran the check LOCALLY.
     That is fine and is the simplest path. An ssh FROM DEV is what
     fails silently (three occurrences S99-S101).
     ▶ EITHER be on the prod terminal and run the block bare, OR
       ssh from the MAC. Never ssh from dev.
     ▶ PUT `hostname -I` AT THE TOP OF THE PROD BLOCK. Prod must
       report 172.31.3.156. This caught nothing in S102 only because
       it was there.

2  Then STEP 1. No measuring first — STEP 0 was done in S102.
```

---

## STEP 0 · ALREADY DONE IN S102. DO NOT RE-RUN.

```
GLUTENULL EXPOSURE — MEASURED ON PROD, company 471
  MO-0001  qty 1750 · batch_qty 240 · batches_stored 7.292
           true 7.291667 · inflated by 0.0000046 (~0.005%)
  MO-0002  qty 802 · batch_qty 400 · batches_stored 2.005
           true 2.005 — EXACT. Nothing lost. Terminates at 3 dp.
  ⚠ FRACTIONAL IS NOT THE TEST. NON-TERMINATING IS. The S102 query
    was wider than the defect and caught MO-0002 harmlessly.

MINTY'S RULING S102: no heal, no prod data work, yield screen not
activated for Glutenull. ▶ THE HEALING QUESTION IS CLOSED. Do not
re-open it.

MR BACKFILL — none needed. Measured prod S98: company 464 only,
4 rows, GLUTENULL ZERO.
```

---

## STEP 1 · THE DATABASE COLUMN — DEV FIRST

```
⚠ RUN AGAINST abletracelab_live EXPLICITLY. Both boxes carry a
  dormant `abletrace` archive and a bare `mysql` lands in it (J43).
⚠ DEV HAS NO ~/.my.cnf. Build it from .env, or use read-rows.js to
  VERIFY (it is read-only — it cannot run the ALTER).

THE STATEMENT
  ALTER TABLE rejectmaterialandproduct
    ADD COLUMN qty_rejected_units double DEFAULT 0;

WHY double, not int — fractional shipping units are PERMITTED BY
DESIGN (J88, Minty S80). packing_units 0.5 exists on dev today.
An int column would silently truncate.

WHY THIS NAME — it sits beside qty_rejected so the pair reads
obviously. Minty to confirm at open if he wants another.

VERIFY
  node /home/ubuntu/read-rows.js cols rejectmaterialandproduct
  EXPECT a line: qty_rejected_units  double
```

---

## STEP 2 · THE MODEL DECLARATION — ⚠ WITHOUT THIS THE WRITE VANISHES

```
FILE  ~/abletrace-lab-backend/api/models/RejectMaterialAndProduct.js
      ⚠ BACKEND IS EDITED ON DEV. No build step. RULES 2.

THE ATTRIBUTES BLOCK — READ IN FULL, S102. This is what is there:
    internalCode: { type: 'string' },
    user_id: { model: 'User' },
    company_id: { model: 'Company' },
    type: { type: 'string' },
    material_id: { model: "Materials" },
    recievedlot_id: { model: "RecievedLots" },
    formula_id: { model: "Formulations" },
    receiveProduct_id: { model: "ReceiveProducts" },
    mlc_id: { model: "MLOManagement" },
    qty_rejected: { type: "number" },          ← ANCHOR HERE
    remarks_reasons: { model: "MiscellaneousReason" },
    disposition: { type: "string" },
    disposition_authorized_by: { model: "User" },
    status: { type: "string" }

THE EDIT — one line, directly after qty_rejected:
    qty_rejected_units: { type: "number" },

⚠ TRAPS 3. THIS IS NOT OPTIONAL AND IT IS NOT A BUG FIX. Sails
  DISCARDS any value whose column is not declared here, with NO
  ERROR and a 200 response. PROVEN TWICE:
    received_units banked 0 silently until declared (J20)
    food_safety_enabled HAS the column and NOT the attribute TO
    THIS DAY — that toggle write vanishes right now (P129)
⚠ SO THE ORDER IS: column, THEN declaration, THEN write path.
  Skipping step 2 produces a clean-looking success and an empty
  column.

⚠ pm2 restart abletrace-dev, then sleep 8, then curl. Never "all".
```

---

## STEP 3 · THE BACKEND WRITE OBJECT

```
SAME FILE. There are TWO object builders sharing ONE function:

  create_Rejected_Mat      ~line 58   builds REJMATOBJ
  create_Rejected_Product  ~line 76   builds REJPRODOBJ   ← THIS ONE
  createNewRecord          ~line 95   the shared writer

REJPRODOBJ AS IT STANDS (read S102):
    internalCode: await RejectMaterialAndProduct.getInternalCode(),
    company_id: req.body.company_id,
    user_id: req.body.user_id,
    receiveProduct_id: req.body.receiveProduct_id,
    formula_id: req.body.formula_id,
    type: "Product",
    qty_rejected: req.body.qty_rejected,        ← ANCHOR HERE
    disposition: req.body.disposition,
    disposition_authorized_by: req.body.disposition_authorized_by,
    remarks_reasons: req.body.remarks_reasons,
    status: "Active",
    mlc_id: req.body.mlc_id,

THE EDIT — one line after qty_rejected:
    qty_rejected_units: req.body.qty_rejected_units,

⚠⚠ DO NOT TOUCH REJMATOBJ. Material reject is Kg-MEASURED by
  design — weighing a rejected ingredient IS the physical act. This
  is the ingredient side of the two-layer rule and it is CORRECT.
  Adding units there would be a defect, not a fix.
```

---

## STEP 4 · THE FRONTEND — TWO SCREENS, NOT ONE

⚠ FRONTEND IS EDITED ON THE MAC. Dev's checkout is stale at
  c2a52d8e and is overwritten by the next deploy. RULES 2.
⚠ MAC edit → push → GitHub build → deploy dev → verify → SEPARATE
  manual dispatch for prod.

### 4a · THE CREATE SCREEN — the count is already in the form

```
SCREEN  /Reject-products     ⚠ NOTE THE PLURAL. /Reject-product
        (singular) IS A DIFFERENT PAGE. So is /Return-material,
        which is Return Material/Product and NOT this.
        Route: left rail → Miscellaneous Release → new MR.

FILE    src/app/Layouts/admin-dashboard/warehouse/
        rejected-materials/reject-product/reject-product.component.ts

MEASURED ON SCREEN S102 — this is why the fix is small:
    Shipping Units*   1      ← TYPED. Underlined, spinner, focused.
    Quantity (Kg)*    8.34   ← DERIVED, greyed, no spinner. 1 × 8.34.
  ▶ THE UNIT COUNT IS THE OPERATOR'S INPUT. It exists in the form.
    The app derives Kg, saves the Kg, and DISCARDS the count.

THE WRITE, line 299 as it stands:
    qty_rejected: this.rejectProductForm.get('qty').value,

▶ THE FIX: add the units value alongside it.
  ⚠ THE CONTROL NAME IS NOT YET KNOWN. `qty` is the Kg box. The
    Shipping Units box has its own control and S102 did not read
    its name. ▶ FIRST ACTION IN 4a: read the form declaration and
    the template, find the Shipping Units formControlName, THEN
    patch. One read, on the MAC:
      grep -n "FormControl\|formControlName\|Shipping" <ts> <html>

⚠ LINE 347 IS NOT THE FIX SITE AND MUST NOT BE COPIED:
    maxWdu = Math.round((this.qty_rejected / wduUnits) * 10^3) / 10^3
  That is a VALIDATOR CEILING built by dividing Kg. It is R2. It is
  not what the operator typed. ▶ SEND THE TYPED CONTROL VALUE, never
  a derived one. R1 only.
```

### 4b · THE EDIT SCREEN — ⚠ EASY TO MISS, AND IT SILENTLY ERASES

```
SCREEN  /Edit-reject-product
FILE    .../rejected-materials/edit-reject-product/
        edit-reject-product.component.ts

MEASURED ON SCREEN S102 — the form carries KG ONLY:
    Quantity(kgs)*          16.68
    Returned Quantity(kgs)* 16.68
  NO units box anywhere on it.

THE WRITE, line 123:
    qty_rejected: this.rejectProdForm.get('returnedqty').value,

⚠⚠ IF THIS SCREEN IS LEFT ALONE, EDITING AN MR BLANKS THE COUNT.
  The record is written with no qty_rejected_units, so the column
  reverts to its 0 default and the stored count is lost — silently,
  on a record that already had it.
  ▶ THE EDIT SCREEN NEEDS THE FIELD TOO. Minimum: carry the existing
    value through untouched. Better: a Shipping Units box mirroring
    create, with Kg derived.
  ⚠ MINTY DECIDES which. It is a screen-design question, not a
    code one. ASK BEFORE BUILDING.

ALSO ON THIS SCREEN, lines 57-68: it loads `qty` and `returnedqty`
BOTH from result.qty_rejected. Whatever is built must load the units
value the same way.
```

---

## STEP 5 · VERIFY — WHAT DONE LOOKS LIKE

```
⚠ READ THE ROW, NOT THE TOAST. A green success message proves
  nothing when the failure mode is a silent discard (JT12).

ON DEV, company 474, product FO-0001 (8.34 Kg per case):
  1  Create a NEW misc release. Enter Shipping Units = 3.
     Screen must derive Quantity 25.02 Kg.
  2  READ THE ROW:
       node /home/ubuntu/read-rows.js sql "SELECT id, internalCode,
         qty_rejected, qty_rejected_units FROM
         rejectmaterialandproduct ORDER BY id DESC LIMIT 3;"
     EXPECT  qty_rejected 25.02 · qty_rejected_units 3
     ⚠ A ZERO IN THE UNITS COLUMN MEANS STEP 2 WAS MISSED. That is
       the exact signature of the undeclared-attribute trap.
  3  EDIT that MR, change nothing, save. READ THE ROW AGAIN.
     qty_rejected_units MUST STILL BE 3. If it is 0, step 4b failed.
  4  Traceability page: Misc Rel must still read correctly.

THE BEFORE-READING — S101/S102, company 474:
  rejectmaterialandproduct id 3360 · MR-0007
  entered 2 cases · qty_rejected 16.68 · units DISCARDED
  ⚠ THIS ROW STAYS AS IT IS. It is the evidence. No backfill.

⚠ NOTHING IS DONE UNTIL IT IS VERIFIED ON THE SCREEN AND IN THE ROW.
⚠ Gate dev, then promote, then gate prod SEPARATELY. A schema change
  has NO PROMOTE PATH — run the ALTER on prod directly.
```

---

## STEP 6 · THE RECORD — ⚠ DO NOT SKIP. JR IS THE ONLY COPY.

```
⚠ A COLUMN ADDED BY HAND EXISTS IN THE DATABASE AND NOWHERE ELSE.
  If a box is rebuilt from git, it does not come back, and every
  read silently reverts to dividing. JR exists for exactly this.

JR15 — rejectmaterialandproduct.qty_rejected_units  [J116, S103]
  ALTER TABLE rejectmaterialandproduct
    ADD COLUMN qty_rejected_units double DEFAULT 0;
  ⚠ ALSO declare in RejectMaterialAndProduct.js attributes or the
    write silently drops (TRAPS 3).
  Backup: take one BEFORE the ALTER, both boxes.

J116 — the session entry.
  ⚠ SECTION 5's HEADER IS WRONG AND HAS BEEN FOR THREE SESSIONS.
    It says "Highest is J113 — the next one is J114" and "Last
    appended: S95". BOTH J114 AND J115 EXIST (S97 append).
    ▶ THE NEXT FREE NUMBER IS J116. Highest trap is JT27.
    ▶ FIX THE HEADER IN THE SAME COMMIT. S85, S86 and S95 all
      asked and it was not done.

MATERIAL  Section 5 — the JR block. ⚠ ASK MINTY FOR IT BY NAME.
```

---

## THEN · P140 · THE YIELD SCREEN

⚠ ONLY AFTER P82c IS VERIFIED ON DEV. Otherwise it is S104.
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
⚠ TWO OF S101's FOUR FAULTS ARE NOW DOUBTFUL AS WRITTEN. Do not
  carry them forward as findings:
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
  S102 lost time twice on plausible-looking wrong files, and J89
  records the same on release-mat-details (five levels deep, two
  wrong guesses).

ON THE MAC:
  grep -rn "Check Material Yield" ~/abletrace-lab-frontend/src
  then find the component and read it WHOLE, not by grep.

⚠ IT WILL BE UNDER .../warehouse/mfg-lot-codes/edit-mlc/ — the
  button lives on Edit-Mlc — but CONFIRM, do not assume.
⚠ ALSO GREP THE BACKEND. The figures may arrive pre-computed from
  a controller or a stored proc, as SO status did (J114). If so
  the frontend is innocent and the fix is elsewhere entirely.
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
    ▶ CHECK THE PROC FIRST, on dev:
        SHOW CREATE PROCEDURE WhC_GetFormulaPackagingMaterials
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

### ⚠ WHAT WOULD MAKE THIS BIGGER THAN A SESSION

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

## NOT IN S103 — AND WHY

```
P137  getInternalCode COUNTS GLOBALLY. ⚠ CAUSE FOUND S102, do not
      re-investigate: RejectMaterialAndProduct.js:51 reads
        count({ company_id: company_id })
      but the callers at :63 and :78 pass NO ARGUMENT, so
      company_id is undefined and the count is app-wide. That is
      why a brand-new company produced MR-0007.
      ▶ SAME FILE AS S103's JOB. DELIBERATELY SEPARATE COMMIT —
        two changes to one file in one sitting makes a rollback
        ambiguous. Do it after, or next session.
      ⚠ AND ASK MINTY FIRST: renumbering affects how MRs read to a
        client. It is a business question, not a tidy-up.

P140  THE YIELD SCREEN. ⚠ NOW SPECIFIED — see "THEN · P140" above.
      Reached ONLY if P82c is verified on dev with room to spare.
      Otherwise it is S104 and the spec carries forward unchanged.

P102  THE REBOOT. Own sitting. ⚠ MISSED SIX DAYS RUNNING.
P111  QUICKBOOKS. ⚠ P82's ARITHMETIC IS EFFECTIVELY CLOSED (see
      NOW). Once P82c lands, this is next. PLANNING ONLY, NO CODE.
      ⚠ IT NEEDS A NEW COLUMN — TRAPS 3 will bite there too, and
        S103 is the rehearsal for it.
```

---

## THE LESSONS S102 EARNED

⚠ Kept here rather than added to RULES. If they recur, Claude
proposes a rule; the default is still NO.

```
1  THE SCREEN OVERTURNED THE CODE READ, TWICE IN ONE SESSION.
   Claude read add-mlo:150 as multiplying packaging by the rounded
   batches figure and called it a defect. The ROW said 42 and 7,
   exact. Claude read fopackaging's whd_flag filter as proving the
   pouch was never recorded. The RELEASE held both pouch and case.
   ▶ BOTH WERE CONFIDENT CODE READS AND BOTH WERE WRONG. Minty
     read the screen and was right both times.
   ▶ REACHING THE ROW IS CHEAP. Do it before naming a defect.

2  MINTY'S DISTINCTION WAS SHARPER THAN CLAUDE'S. Claude was
   scoping one fix across nine multiplication sites. Minty split
   it: ingredients legitimately scale by batches; packaging must
   scale by shipping units and never round-trip. That is the
   correct domain line and it made the job smaller AND revealed
   the code was already doing it.
   ▶ ASK WHAT THE NUMBER MEANS BEFORE ASKING IF IT IS RIGHT.

3  A WRONG SCREEN ANSWERS A DIFFERENT QUESTION. Two rounds of
   screenshots came from /Edit-reject-product and /Return-material
   before /Reject-products. Both looked plausible and neither
   could settle the question asked.
   ▶ NAME THE ROUTE AND THE URL, not just the feature. Same
     family as JT25 — name things the way Minty sees them.

4  A FAILURE THAT ANNOUNCES ITSELF IS A GOOD FAILURE. The prod ssh
   refused loudly because the pem was not on the box — the fourth
   encounter with this and the FIRST that did not silently run on
   dev. The block was written to fail rather than fall through.
   ▶ PREFER THE COMMAND SHAPE THAT CANNOT SUCCEED WRONGLY.

5  FRACTIONAL IS NOT THE SAME AS NON-TERMINATING. The Glutenull
   exposure query caught two rows and only one had lost anything.
   802 / 400 = 2.005 exactly. A test built on "is it fractional"
   is wider than the defect and produces false alarms.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ Section 5's JR block — NEEDED THIS SESSION, at STEP 6.
NOTHING ELSE.
```
