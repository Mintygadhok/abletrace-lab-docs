# PLAN

Written at close of: S100 · for S101.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULING, REVISED AFTER THE S100 CLOSE. THIS SUPERSEDES
  THE EARLIER RANKING:

  "run the new account and 2 pdts 1.39 and 0.32 kg each first
   and see if all figures are reading right. if yes - move
   straight to working on the QB integration next session."

⚠ SO THE SESSION HAS ONE JOB AND A GATE.
  JOB A is the fixture run. What comes after DEPENDS ON WHAT IT
  FINDS. P82c and P82b are NO LONGER SCHEDULED — they are
  contingent. See THE GATE.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 2ae869c · frontend checkout c2a52d8e · clean
           prod backend 2ae869c · frontend checkout 9bce0238 · clean
           both 200
   ⚠ BACKENDS AND FRONTENDS BOTH MATCH. Serving f53986ca.
   ⚠ THE DATABASES DO NOT. Dev's Trace_ProductHeaderView has
     qty_produced_su repointed; prod's still divides. DELIBERATE,
     recorded in NOW's STATE block. Do not "fix" it.

2  Start JOB A. Minty creates the company and drives the app.
   Claude reads the stored row after each step.
```

---

## JOB A · THE CLEAN FIXTURE RUN

⚠ THE WHOLE SESSION, UNLESS IT FINDS SOMETHING.
⚠ MINTY DRIVES THE APP. Claude reads rows and says whether
  entered and stored agree.

```
WHY, IN PLAIN WORDS
  Dev carries old test rows with wrong numbers baked in from a
  bug fixed months ago — 50.004, 10.008, 1750.08. Four times
  across S99 and S100, session minutes went on deciding whether
  an odd figure was a live defect or old residue.
  A clean set means ANY odd figure from now on is REAL.
  ▶ And it answers the bigger question directly: are the figures
    reading right, end to end, today? Everything else in P82 was
    inferred from a code read. This MEASURES it.

SETUP
  Company     260804, on DEV.
  Product 1   1.39 Kg per unit.  ⚠ The standing ratio. Every fix
              this session was proven against it.
  Product 2   0.32 Kg per unit.  ⚠ Mirrors Glutenull's FO-0019,
              which holds 1750 units / 560 Kg on prod.
  ⚠ NEITHER IS 1:1. A weight ratio of exactly 1 makes a division
    INVISIBLE — 10 / 1 = 10 whether the code divides or reads
    the stored value. TRAPS 9. It has already produced a
    confident wrong conclusion that stood a whole session.
  ⚠ 1.39 and 0.32 both look clean in decimal and are NOT clean
    in binary. That is the point — a float artefact stands out
    against a figure that ought to be tidy.

THE CYCLE — run it on BOTH products
  MO   create → release material → receive product → close
  SO   create → dispatch order → packing slip → ship → close
  ⚠ INCLUDE A MISCELLANEOUS RELEASE somewhere in the MO cycle.
    We already know the unit count will NOT be stored — the
    column does not exist (P82c). Do it anyway, so we see
    exactly what the screen does. That is a MEASUREMENT, not
    a surprise.

THE METHOD — this is what makes it a reference set
  ⚠ WRITE DOWN EVERY NUMBER AS ENTERED, before pressing save.
  ⚠ After each step, Claude reads the STORED ROW.
  ⚠ ENTERED AND STORED MUST AGREE AT EVERY HOP. Where they
    disagree, read the SAVE CODE, not the form — a form can send
    a hidden value instead of the one typed.
  ⚠ A screen proves BEHAVIOUR, never a saved value. Both are
    needed at every hop.

THEN CHECK EVERY SCREEN THAT SHOWS A QUANTITY
  Products list             units# (Kg)
  MLO-Management            planned and received
  Closed MOs                planned and completed, + Excel export
  Edit Closed MO            the Shipping Units line
  Product Traceability      list AND details, BOTH search paths
                            ⚠ NAME THE URL. /Product-traceability
                              then /Product-traceability-details.
                            ⚠ The product dropdown and the lot
                              code box are DIFFERENT code paths.
  Dispatch Orders           Qty Shipped and Qty Plan
                            ⚠ 0# before shipping is CORRECT. A
                              packing slip means READY to ship.
  Shipped PS                after shipping, the figure must appear
  Stock on Hand             on the traceability details page
  Add-MLO                   only if an intermediate is involved

  ⚠ Every figure must reconcile: units x Kg-per-unit = the Kg
    figure, EXACTLY. Not approximately.
  ⚠ Note anything that does NOT. Do not chase it mid-run — write
    it down and finish the cycle first.

VERIFY / WHAT DONE LOOKS LIKE
  Every stored figure a clean number. No 10.008. No
  15.290000000000001. Every screen reconciling.
  ▶ Record company, product, MO and SO numbers in NOW as THE
    standing test set.

  ⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs
    risks orphaning lot codes, receipts and traceability links.
```

---

## THE GATE

⚠ MINTY'S RULING. What happens next depends on JOB A's result.

```
IF EVERY FIGURE READS RIGHT
  ▶ P82 IS DONE IN PRACTICE. P82c and P82b stay in the queue but
    stop being priorities — nothing is producing a wrong number
    anywhere.
  ▶ NEXT SESSION IS QUICKBOOKS (P111). Planning only, no code.
  ▶ Say so plainly in the close, and rank QB first in the next
    PLAN.

IF SOMETHING READS WRONG
  ▶ THAT becomes the job, and it is a REAL defect rather than a
    suspicion from a code read. Fix it properly: reproduce, four
    arbiters, gate, patch, verify, promote.
  ▶ QuickBooks waits. A wrong figure in front of a client
    outranks a new integration.
  ▶ LOOK IN P135 FIRST. If the wrong figure is on a screen or
    view listed there, the diagnosis is already written down.

⚠ EITHER WAY, THE MISC RELEASE UNIT COUNT WILL BE MISSING. That
  is P82c and it is already known. It does not by itself fail the
  gate — Minty decides whether it matters enough to fix before
  QuickBooks.
```

---

## IF RULED IN · P82c · THE MISC RELEASE UNITS COLUMN

⚠ NOT SCHEDULED. Only if JOB A shows it matters, or Minty rules
  it in mid-session.

```
WHAT THIS IS, IN PLAIN WORDS
  When stock is released for miscellaneous reasons, the app saves
  the weight. It does not save how many units. There is nowhere
  to put it — the column does not exist.

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
     ⚠ Dev first, proven, then prod. Gate each box separately.
  2  Declare it in RejectMaterialAndProduct.js attributes.
  3  Change the write path so the unit count is captured.
  4  Back the column up and log it in Section 5's JR block IN THE
     SAME BREATH. JR is the only record these exist.

MATERIAL
  Section 5 — the JR block. ⚠ ASK MINTY FOR IT BY NAME.
  TRAPS entry 3.

ANALYSIS — DONE, DO NOT REDERIVE
  ⚠ NO BACKFILL IS NEEDED. Measured on prod S98:
      rejectmaterialandproduct → company 464 only, 4 rows.
      GLUTENULL ZERO. No live client data to heal.
  ⚠ ADDING THE COLUMN DOES NOT FIX SOH. That is P82b.

VERIFY
  Misc release in company 260804, then READ THE ROW. The unit
  count must be stored, not zero.
  ⚠ Read the ROW, not the toast. A toast proves the click, not
    the write. Then read the SCREEN.
```

---

## IF RULED IN · P82b · STOCK ON HAND

⚠ NOT SCHEDULED. Blocked behind P82c, and only if JOB A shows a
  wrong SOH figure.

```
WHAT THIS IS, IN PLAIN WORDS
  Stock on Hand is worked out inside a piece of database code
  called Trace_ProductHeaderView. It takes the weight produced,
  subtracts everything that left, then divides by the weight of
  one unit to get a unit count. The app already stores most of
  those counts.

⚠ THE TRAP, IN PLAIN WORDS. TRAPS 10.
  Inside that database code, someone gave a WEIGHT figure the
  name "qty_shipped". There is ALSO a real column in the database
  called "qty_shipped" that holds a UNIT COUNT.
  Same name. One is weight, one is units, a few lines apart.
  ▶ Anything swapped by NAME puts a weight where units belong.
    The arithmetic will look sensible and be wrong.
  ▶ RESOLVE EVERY NAME TO ITS DEFINITION FIRST. An alias is not
    a column and a CTE is not a table.

ANALYSIS — DONE IN S100, DO NOT REDERIVE
  ⚠ THE VIEW HAS BEEN READ. 5756 bytes, from dev. Seven divisions
    by fop.wgt_kgs_per_unit:
      qty_produced_su      ✓ ALREADY REPOINTED ON DEV (S100)
      qty_shipped_su       ⚠ CTE sums do.qty_to_ship = KG. The
                             units column is do.qty_shipped.
                             Measured: never NULL, 26 active rows.
      qty_packing_slip_su  ⚠ same CTE, same Kg source
      qty_do_su            ⚠ same CTE, same Kg source
      intermediate_prd_su  sums mpr.qty_allocated (Kg — P93)
      qty_misc_release_su  ▶ what P82c unblocks
      SOH_su               the whole subtraction, divided
  ⚠ 0.5 IS A VALID SHIPPING UNIT. Minty's ruling S100. A
    fractional figure in a units column is NOT a divided weight.
    Claude got this wrong in S100. Do not re-raise it.
  ⚠ PROD'S COPY HAS NEVER BEEN READ. SHOW CREATE VIEW on prod
    before changing anything there. Do not assume the boxes hold
    the same definition.

⚠ MINTY'S RULE, S100: if this is not straightforward it goes to
  P135 and we stop. It is a view change on a live client's
  database, with no build and no promote path, and a wrong figure
  has never been seen on this screen.

BEFORE-READING, taken on dev in S100 — company 464, test1.39,
Pdt-260718-1. THESE MUST NOT MOVE unless we intend them to:
    Qty Produced   51# (70.89 Kg)
    Stock on Hand  41# (56.99 Kg)
    Qty in PS       2# (2.78 Kg)
    Shipped         7# (9.73 Kg)
    Qty Misc Rel    1# (1.39 Kg)
```

---

## HOW TO REACH THE DATABASE FROM A SCRIPT

⚠ LEARNED S100 THE HARD WAY. Saves twenty minutes, and JOB A
  needs it at every hop.

```
dotenvx IS NOT AVAILABLE AS A COMMAND ON DEV. `npx dotenvx`
tries to fetch from the network and fails. node_modules/.bin has
no dotenvx.

THE DRIVER IS  node_modules/mysql   — NOT mysql2.

▶ THE METHOD THAT WORKS: a script file that reads .env itself.
  Write it as a FILE and scp it from the Mac. Do NOT paste long
  blocks into the terminal — two pastes truncated mid-heredoc in
  S100 and ran a half-written file.

  const fs = require('fs');
  const base = '/home/ubuntu/abletrace-lab-backend';
  const l = fs.readFileSync(base + '/.env','utf8').split('\n')
    .find(function(x){ return x.indexOf('DATABASE_URL') === 0; });
  const u = new URL(l.slice(l.indexOf('=')+1).trim()
    .replace(/^["']/,'').replace(/["']$/,''));
  const mysql = require(base + '/node_modules/mysql');

⚠ ALWAYS PRINT THE DATABASE NAME the script connected to. P134:
  a query against the wrong database RETURNS ROWS, not an error.
⚠ NO SECRET REACHES THE SCREEN with this method.
⚠ FOR JOB A: write ONE script that reads all the relevant rows
  for a given MO or SO, so each hop is one command rather than
  five. Build it early — it gets used a dozen times.
```

---

## AFTER THE GATE · P111 · QUICKBOOKS

⚠ NOT THIS SESSION. This is the destination, if JOB A comes back
  clean.

```
MINTY, S100: move straight to the QB integration.

⚠ PLANNING ONLY, NO CODE. That has been the standing rule on
  P111 since it was raised and it has not changed.
⚠ IT NEEDS A NEW COLUMN, so TRAPS 3 will bite: a column added to
  the database is silently ignored unless the model declares it.
  Both steps or the write vanishes with no error.
⚠ ALSO RAISED BY MINTY S100: food safety records. Not yet
  scoped. Needs its own sitting to define what is actually
  wanted before any work starts.
```

---

## NOT IN THIS SESSION

```
P135   The acrobatics watch item. ⚠ DO NOT OPEN IT. It exists so
       that when a wrong figure appears, the answer is already
       written down. If JOB A finds one, LOOK HERE FIRST.
P102   THE REBOOT. Own sitting. ⚠ VERIFY PM2 STARTS ON BOOT
       FIRST, and prod runs a different OS so dev does not
       rehearse it. ⚠ MISSED FOUR DAYS RUNNING.
P119   Back up the database's own code into the repo.
       ⚠ MORE URGENT NOW — a view differs between the boxes and
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
   wrong box in S100 — two health checks on dev instead of prod,
   and an rm on PROD instead of the Mac. All harmless, all
   read-only or no-match. The promote was not. RULES section 2
   already says this. It was not followed. Again.

2  DO NOT PASTE LONG BLOCKS INTO THE TERMINAL. Two heredocs
   truncated mid-file and ran as half-written scripts. RULES 5.2
   already says anything long goes as a FILE. Claude did not
   follow its own rule until it had failed twice.

3  ASK WHAT THE BUSINESS RULE IS BEFORE CALLING SOMETHING A
   DEFECT. Claude read 0.5 in a units column as a divided weight
   and nearly logged a queue item for it — half a shipping unit
   is legitimate. Claude also nearly kept P82g open — a packing
   slip means ready to ship, not shipped.
   ▶ BOTH WERE ANSWERED BY ONE QUESTION TO MINTY.
   ▶ The screen and the row are two arbiters. The BUSINESS RULE
     is a third, and Claude does not hold it.

4  A FIX WITH NO VISIBLE SYMPTOM STILL NEEDS A BEFORE-READING.
   Fix 7 changed no number anywhere. The before-reading is the
   only thing that made "unchanged" mean something.

5  NAME WHICH SCREEN A ROUTE SERVES BEFORE CLAIMING IT IS
   BLOCKED. Claude declared fix 7 blocked behind P82a having
   assumed the wrong view served it. One grep of the route
   showed a different view entirely, which carried the column.
   ▶ Cost: a near-miss deferral of a job that was ready to do.

6  MEASURE BEFORE SCHEDULING. Three P82 sub-items were closed in
   S100 by LOOKING — P82e, P82f, P82g. None needed code. Two had
   sat in the queue for sessions on the strength of a code read
   alone.
   ▶ THIS IS WHY JOB A IS THE WHOLE SESSION.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ Section 5's JR block ONLY IF P82c gets ruled in mid-session.
NOTHING ELSE.
```
