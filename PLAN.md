# PLAN

Written at close of: S100 · for S101.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULING AT THE S100 CLOSE:
  "next session we do 82c followed by 82b. no digression —
   focused, complete. and I create 260804."

⚠ THREE JOBS. NOTHING ELSE. No new investigation branches.
  If something odd turns up, it goes in the QUEUE and is not
  chased. That is the whole point of this session.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 2ae869c · frontend checkout c2a52d8e · clean
           prod backend 2ae869c · frontend checkout 9bce0238 · clean
           both 200
   ⚠ BACKENDS AND FRONTENDS BOTH MATCH NOW. Serving f53986ca.
   ⚠ THE DATABASES DO NOT. Dev's Trace_ProductHeaderView has
     qty_produced_su repointed; prod's still divides. Deliberate,
     recorded in NOW. Do not "fix" it.

2  Minty creates company 260804. JOB A. It comes first because
   JOB B needs somewhere clean to test the write.
```

---

## JOB A · THE CLEAN FIXTURE COMPANY  (Minty creates it)

⚠ RANKED FIRST. ⚠ MINTY DOES THIS IN THE APP. Claude watches
  the stored rows after each step.

```
WHY, IN PLAIN WORDS
  Dev carries old test rows with wrong numbers baked in from a
  bug fixed months ago — 50.004, 10.008, 1750.08. Twice in S99
  and twice again in S100 a session minute went on deciding
  whether an odd figure was a live defect or old residue.
  A clean set means any odd figure from now on is REAL.
  ▶ This also replaces the old P82f heal. Minty's ruling S100:
    healing test data buys nothing, so build clean instead.

ACTION
  1  Create company 260804 on DEV.
  2  Create ONE product at 1.39 Kg per unit.
     ⚠ NOT a round weight and NOT 1:1. A ratio of 1 makes a
       division invisible — it has already produced a confident
       wrong conclusion that stood for a session (TRAPS 9).
  3  One MO through the full cycle: create → release → receive
     → close.
  4  One SO through the full cycle: create → dispatch → ship
     → close.
  ⚠ WRITE DOWN EVERY NUMBER AS ENTERED. After each step Claude
    reads the stored row. Entered and stored must agree at
    every hop. That is what makes this a reference set rather
    than just more test data.
  5  Record the company, product, MO and SO numbers in NOW as
    THE standing test set.

  ⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs
    risks orphaning lot codes, receipts and traceability links.

VERIFY
  Every stored figure a whole, clean number. No 10.008. No
  15.290000000000001.
```

---

## JOB B · P82c · THE MISC RELEASE UNITS COLUMN

⚠ RANKED SECOND. ⚠ THE LAST ACTIVE JOB IN P82.

```
WHAT THIS IS, IN PLAIN WORDS
  When stock is released for miscellaneous reasons, the app
  saves the weight. It does not save how many units. There is
  nowhere to put it — the column does not exist.

⚠ TWO STEPS, AND BOTH ARE NEEDED. TRAPS 3.
  Step one: add the column to the database.
  Step two: tell the app the column exists, in the model.
  If only step one is done, the app carries on as though the
  column is not there. It saves nothing into it and gives NO
  ERROR. This has already happened once — received_units banked
  zero silently until it was declared.

ACTION
  1  ALTER TABLE rejectmaterialandproduct ADD COLUMN <units>
     double DEFAULT 0;
     ⚠ ON EACH BOX SEPARATELY, against `abletracelab_live`.
       There is NO promote path for a schema change.
     ⚠ Gate each box separately. Dev first, proven, then prod.
  2  Declare it in RejectMaterialAndProduct.js attributes.
     ⚠ WITHOUT THIS THE WRITE VANISHES SILENTLY. TRAPS 3.
  3  Change the write path so the unit count is captured.
  4  Back the column up and log it in Section 5's JR block IN
     THE SAME BREATH. JR is the only record these exist.

MATERIAL
  Section 5 — the JR block. NOT OPTIONAL, the job writes to it.
  ⚠ ASK MINTY FOR IT BY NAME AT SESSION OPEN.
  TRAPS entry 3.

ANALYSIS — DONE, DO NOT REDERIVE
  ⚠ NO BACKFILL IS NEEDED. Measured on prod S98:
      SELECT company_id, COUNT(*) FROM rejectmaterialandproduct
      GROUP BY company_id;  →  464 only, 4 rows. GLUTENULL ZERO.
    There is no live client data to heal. That was the risky
    half of this job and it is gone.
  ⚠ Dev's four rows in 464 are the test fixture for the write
    path. Company 260804 gives a clean one.
  ⚠ ADDING THE COLUMN DOES NOT FIX SOH. That is JOB C.

VERIFY
  Make a misc release on dev in company 260804, then READ THE
  ROW. The unit count must be stored, not zero.
  ⚠ Read the ROW, not the toast. A toast proves the click,
    not the write.
  ⚠ Then read it again on the SCREEN.
```

---

## JOB C · P82b · STOCK ON HAND

⚠ RANKED THIRD. ⚠ ONLY AFTER JOB B. It is blocked behind the
  column existing.

```
WHAT THIS IS, IN PLAIN WORDS
  Stock on Hand is worked out inside a piece of database code
  called Trace_ProductHeaderView. It takes the weight produced,
  subtracts everything that left, then divides by the weight of
  one unit to get a unit count. The app already stores most of
  those counts.

⚠ THE TRAP, IN PLAIN WORDS. TRAPS 10.
  Inside that database code, someone gave a WEIGHT figure the
  name "qty_shipped". There is also a real column in the
  database called "qty_shipped" that holds a UNIT COUNT.
  Same name. One is weight, one is units, a few lines apart.
  ▶ If anything is swapped by NAME, a weight lands where units
    belong. The arithmetic will look sensible and be wrong.
  ▶ RESOLVE EVERY NAME TO ITS DEFINITION BEFORE TRUSTING IT.
    An alias is not a column and a CTE is not a table.

ANALYSIS — DONE IN S100, DO NOT REDERIVE
  ⚠ THE VIEW HAS BEEN READ. 5756 bytes, from dev. Seven
    divisions by fop.wgt_kgs_per_unit:
      qty_produced_su      ✓ ALREADY REPOINTED ON DEV (S100)
      qty_shipped_su       ⚠ CTE sums do.qty_to_ship = KG.
                             The units column is do.qty_shipped.
                             Measured: never NULL, 26 active rows.
      qty_packing_slip_su  ⚠ same CTE, same Kg source
      qty_do_su            ⚠ same CTE, same Kg source
      intermediate_prd_su  sums mpr.qty_allocated (Kg — P93)
      qty_misc_release_su  ▶ THIS IS WHAT JOB B UNBLOCKS
      SOH_su               the whole subtraction, divided
  ⚠ 0.5 IS A VALID SHIPPING UNIT. Minty's ruling S100. A
    fractional figure in a units column is NOT a divided weight.
    Claude got this wrong in S100. Do not re-raise it.

⚠ PROD'S COPY OF THE VIEW HAS NEVER BEEN READ.
  ▶ SHOW CREATE VIEW on PROD before changing anything there.
    Do not assume the two boxes hold the same definition.

⚠ MINTY'S RULE, S100: if this turns out not to be straight-
  forward, it goes to P135 and we stop. It is a view change on
  a live client's database with no build and no promote path.
  A wrong figure has never been seen on this screen.

VERIFY
  ⚠ TAKE THE BEFORE-READING FIRST and write the numbers down.
    On dev today, company 464, test1.39, Pdt-260718-1:
      Qty Produced   51# (70.89 Kg)
      Stock on Hand  41# (56.99 Kg)
      Qty in PS       2# (2.78 Kg)
      Shipped         7# (9.73 Kg)
      Qty Misc Rel    1# (1.39 Kg)
    ▶ These MUST NOT MOVE unless we intend them to.
  ⚠ Then the same on company 260804, which will be clean.
```

---

## HOW TO REACH THE DATABASE FROM A SCRIPT

⚠ LEARNED S100 THE HARD WAY. Saves twenty minutes.

```
dotenvx IS NOT AVAILABLE AS A COMMAND ON DEV. `npx dotenvx`
tries to fetch from the network and fails. node_modules/.bin
has no dotenvx.

THE DRIVER IS  node_modules/mysql   — NOT mysql2.

▶ THE METHOD THAT WORKS: a script file that reads .env itself.
  Write it as a FILE and scp it. Do NOT paste long blocks into
  the terminal — two pastes truncated mid-heredoc in S100 and
  ran a half-written file.

  const fs = require('fs');
  const base = '/home/ubuntu/abletrace-lab-backend';
  const l = fs.readFileSync(base + '/.env','utf8').split('\n')
    .find(function(x){ return x.indexOf('DATABASE_URL') === 0; });
  const u = new URL(l.slice(l.indexOf('=')+1).trim()
    .replace(/^["']/,'').replace(/["']$/,''));
  const mysql = require(base + '/node_modules/mysql');

⚠ ALWAYS PRINT THE DATABASE NAME the script connected to.
  P134: a query against the wrong database RETURNS ROWS, not
  an error.
⚠ NO SECRET REACHES THE SCREEN with this method.
```

---

## NOT IN THIS SESSION

```
P111   QUICKBOOKS. ⚠ MINTY RAISED THIS AS IMPORTANT AT THE S100
       CLOSE, alongside food safety records. Planning session
       only, NO CODE. Its own sitting. ⚠ It needs a new column,
       so TRAPS 3 will bite there.
FOOD SAFETY RECORDS. ⚠ Raised by Minty S100 as important.
       Not yet scoped. Needs its own sitting to define what is
       actually wanted before any work.
P135   The acrobatics watch item. ⚠ DO NOT OPEN IT. It exists
       so that when a wrong figure appears, the answer is
       already written down.
P102   THE REBOOT. Own sitting. ⚠ VERIFY PM2 STARTS ON BOOT
       FIRST, and prod runs a different OS so dev does not
       rehearse it. ⚠ MISSED FOUR DAYS RUNNING.
P119   Back up the database's own code into the repo.
       ⚠ MORE URGENT NOW — a view differs between boxes and
         there is no record of it in git.
P108   Retire the J-entries. ⚠ KEEP JR. Own sitting, with Minty.
P131/132/133/134/136  Not ranked.
```

---

## THE LESSONS S100 EARNED

⚠ Kept here deliberately rather than added to RULES. If they
  recur, Claude proposes a rule; the default is still NO.

```
1  CHECK THE PROMPT BEFORE EVERY BLOCK. THREE blocks ran on the
   wrong box in S100 — two health checks on dev instead of
   prod, and an rm on PROD instead of the Mac. All harmless,
   all read-only or no-match. The promote was not. RULES
   section 2 already says this. It was not followed. Again.

2  DO NOT PASTE LONG BLOCKS INTO THE TERMINAL. Two heredocs
   truncated mid-file and ran as half-written scripts. RULES
   5.2 already says anything long goes as a FILE. Claude did
   not follow its own rule until it had failed twice.

3  ASK WHAT THE BUSINESS RULE IS BEFORE CALLING SOMETHING A
   DEFECT. Claude read 0.5 in a units column as a divided
   weight and nearly logged a queue item for it. Half a
   shipping unit is legitimate. Claude also nearly kept P82g
   open — a packing slip means ready to ship, not shipped.
   ▶ BOTH WERE ANSWERED BY ONE QUESTION TO MINTY.
   ▶ The screen and the row are two arbiters. The BUSINESS
     RULE is a third, and Claude does not hold it.

4  A FIX WITH NO VISIBLE SYMPTOM STILL NEEDS A BEFORE-READING.
   Fix 7 changed no number anywhere. The before-reading is the
   only thing that made "unchanged" mean something.

5  NAME WHICH SCREEN A ROUTE SERVES BEFORE CLAIMING IT IS
   BLOCKED. Claude declared fix 7 blocked behind P82a having
   assumed the wrong view served it. One grep of the route
   showed a different view entirely, which carried the column.
   ▶ Cost: a near-miss deferral of a job that was ready to do.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section 5's JR block — JOB B WRITES TO IT. NOT OPTIONAL.
NOTHING ELSE.
```
