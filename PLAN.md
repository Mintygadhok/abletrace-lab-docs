# PLAN

Written at close of: S101 · for S102.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULING, S101 CLOSE:
  "we can do qb integration start after closing the p82
   (acrobatics)"

⚠ SO THE ORDER IS FIXED. P82 closes, THEN QuickBooks.
  S102 has ONE JOB: the R3 batches round-trip.
  ⚠ EVERYTHING NEEDED TO DO IT IS BELOW. NOTHING TO REDERIVE.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 2ae869c · frontend checkout c2a52d8e · clean
           prod backend 2ae869c · frontend checkout 9bce0238 · clean
           both 200 · dev ↺129 · prod ↺337
   ⚠ NOTHING CHANGED IN S101. If anything differs, STOP.
   ⚠ PROD IS REACHED FROM THE MAC. The pem does not exist on the
     boxes. This went wrong AGAIN in S101 — an ssh from dev to
     prod failed and the prod block silently ran on dev a second
     time. Harmless, read-only, THIRD OCCURRENCE.

2  MEASURE GLUTENULL. ⚠ THIS DECIDES THE SHAPE OF THE JOB.
   See STEP 0 below. One query on prod. Do it BEFORE any code.

3  Then STEP 1. Reproduce on 474.
```

---

## STEP 0 · IS THERE LIVE CLIENT EXPOSURE?

⚠ FIRST THING. It changes whether a heal is needed at all.

```
THE QUESTION, IN PLAIN WORDS
  The defect only appears when an MO is for a number of shipping
  units that is NOT a whole multiple of the batch size. If
  Glutenull has never done that, no client figure was ever wrong
  and this is a code fix with NOTHING to heal.

METHOD
  ⚠ read-rows.js IS NOT ON PROD. scp it from the Mac first:
    the file is at /home/ubuntu/read-rows.js on DEV; a copy
    should be kept on the Mac at ~/Downloads/read-rows.js.
  Then, ON PROD, join mlomanagement to formulations and look for
  any row where qty / batch_qty is not a whole number,
  company_id 471.

WHAT EACH ANSWER MEANS
  ZERO ROWS   ▶ No client exposure. Code fix only, no heal.
              ▶ Say so plainly and move straight to the fix.
  ANY ROWS    ▶ Those MOs have an inflated qty_allocated in
              mprrecievelots. Claude REPORTS how many, whose,
              and by how much. MINTY DECIDES on healing.
              ⚠ RULES 3. It is his data.

⚠ MEASURE, DO NOT ASSUME. Glutenull's FO-0019 is 1750 units at
  240 per batch = 7.29 batches. THAT IS FRACTIONAL. The S93
  comment cites exactly this case. Expect rows to exist.
```

---

## STEP 1 · REPRODUCE

```
On DEV, company 474, product FO-0001 (8.34 Kg/case, batch 6).
Create a THROWAWAY MO for a NON-INTEGER batch count — 7 cases
again, or 5, or 11. NOT 6 and NOT 12.
  ⚠ A WHOLE-NUMBER BATCH COUNT HIDES THIS COMPLETELY. TRAPS 9
    family. This is the single easiest way to waste the session.
Release the material. Read mprrecievelots.qty_allocated.
EXPECT it to be wrong by the same shape: 58.397 for 7 cases.

▶ THE BEFORE-READING IS ALREADY TAKEN. S101, MO-0001:
    entered 7 cases
    correct  7 × 8.34 = 58.38
    actual   1.167 × 50.04 = 58.397
    stored   mprrecievelots id 84016
```

---

## STEP 2 · THE CODE — ALREADY LOCATED, DO NOT RE-GREP

```
THE ROOT, ONE LINE
  add-mlo.component.ts:204
    const batches = Math.round((qty / shippingUnitsPerBatch)
                    * Math.pow(10, this.decimalPlaces))
                    / Math.pow(10, this.decimalPlaces);
  7 ÷ 6 = 1.1666666… → 1.167.

⚠ READ THE COMMENT ABOVE LINE 204 BEFORE TOUCHING ANYTHING.
  Written in S93. It records that the unit count was
  deliberately fixed — which is why qty=7 stores clean — and
  that BATCHES WAS LEFT UNCHANGED ON PURPOSE. It NAMES the
  downstream sites:
      release-mat-details   1071 · 1083 · 1095
      add-mlo               150 · 223
  ▶ A PREVIOUS SESSION DID HALF THIS JOB AND WROTE DOWN WHY IT
    STOPPED. Honour that comment; update it when the fix lands.

⚠ THE COMMENT'S LIST IS INCOMPLETE. S101 found a FOURTH site,
  in add-mlo createMLC (~227-237):
      qty: this.batches * data.qty
      quantity: data.quantity * this.mloForm.get("batches").value
  ▶ THIS ONE WRITES. Not display. The comment does not mention it.
  ⚠ ASSUME THERE MAY BE A FIFTH. Grep the whole frontend for
    `batches` used in a MULTIPLICATION before patching, and
    check the BACKEND too — S101 never ran the backend grep.

THE FIX SHAPE
  ▶ Scale from the UNIT COUNT directly. Never from a rounded
    intermediate.
       material qty = (units / unitsPerBatch) * recipeQtyPerBatch
    computed in ONE expression with NO rounding in the middle,
    rounded ONLY at the final display.
  ▶ `batches` stays as a DISPLAY figure. It may keep its
    rounding. It must stop being an input to any calculation.
  ⚠ DO NOT "fix" this by rounding to more decimal places. That
    moves the error, it does not remove it. R1 is the only safe
    direction: one-way, no round-trip.

⚠ ALL FRONTEND. That means MAC edit → push → GitHub build →
  deploy dev → verify → manual dispatch for prod. RULES 2.
⚠ ASSERT-ANCHORED PYTHON PATCH SCRIPTS, run from /tmp, deleted
  after. Rule 0.2c.
```

---

## STEP 3 · THE YIELD SCREEN — THREE FAULTS, NOT ONE

⚠ FIXING THE ROOT MAY FIX ONLY ONE OF THESE. Check all three
  after patching; do not assume.

```
R3-b  Planned reads 7.002 Ea for BOTH Pouch and Case.
      1.167 × 6 = 7.002. ▶ SHOULD FALL OUT of the STEP 2 fix.

R3-c  The pack-level multiplier is MISSING. Pouch planned should
      be 42 (7 cases × 6 pouches) and shows the same figure as
      Case. ▶ A SEPARATE FAULT. Will NOT be fixed by STEP 2.
      ⚠ Variance currently reads −34.998 Ea — a 35-pouch
        shortfall that never happened.

R3-d  "QTY Planned(Kg)" holds 7, a UNIT COUNT, beside
      "QTY Completed(Kg)" holding 58.38, a real weight.
      ▶ A LABEL FIX. One line. Same family as P131 — consider
        doing both in one commit.

⚠ THIS SCREEN IS CLIENT-FACING AND FOOD-SAFETY. Material yield
  is how a producer proves what went into a lot. It currently
  reports a discrepancy that did not occur. THIS IS THE REASON
  P82 OUTRANKS QUICKBOOKS.
```

---

## STEP 4 · VERIFY — WHAT DONE LOOKS LIKE

```
ON DEV, company 474, a NON-INTEGER batch count:
  mprrecievelots.qty_allocated = units × Kg-per-unit, EXACTLY.
    7 cases → 58.38. NOT 58.397.
  Check Material Yield: Pouch planned 42, Case planned 7,
    variance 0 on all three lines.
  Labels correct on QTY Planned.

⚠ THEN RE-RUN THE WHOLE S101 CYCLE ON 474 AND CONFIRM NOTHING
  ELSE MOVED. The S101 figures are the before-reading:
    MO qty 7 · received_units 7 · received_qty 58.38
    SOH 4# (33.36) · Misc Rel 2# (16.68) · Shipped 1# (8.34)
  ⚠ A FIX WITH NO VISIBLE SYMPTOM STILL NEEDS A BEFORE-READING.
    S100 lesson 4. These are it.

⚠ NOTHING IS DONE UNTIL IT IS VERIFIED ON THE SCREEN.
⚠ Gate dev, then promote, then gate prod SEPARATELY.
```

---

## THEN · P82c · THE MISC RELEASE UNITS COLUMN

⚠ AFTER the R3 fix, and only if the session has room. Otherwise
  it is S103. ⚠ MINTY'S S100 RULE: a schema change on a live
  client's database deserves its own sitting.

```
MEASURED S101, NOT INFERRED
  Entered 2 cases. Screen derived 16.68 Kg correctly.
  rejectmaterialandproduct.id 3360 stored qty_rejected=16.68
  AND NOTHING ELSE. The 2 was discarded silently at the write.
  ⚠ NOT AN R3. Nothing was rounded. THE COLUMN DOES NOT EXIST.

⚠ TWO STEPS, AND BOTH ARE NEEDED. TRAPS 3.
  1  ALTER TABLE rejectmaterialandproduct ADD COLUMN <units>
     double DEFAULT 0;
     ⚠ ON EACH BOX SEPARATELY, against `abletracelab_live`.
       NO PROMOTE PATH for a schema change. Dev first, proven,
       then prod. Gate each box separately.
  2  Declare it in RejectMaterialAndProduct.js attributes.
     ⚠ WITHOUT THIS THE WRITE VANISHES WITH NO ERROR. Proven —
       received_units banked zero silently until declared.
  3  Change the write path to capture the unit count.
  4  Back the column up and log it in Section 5's JR block IN
     THE SAME BREATH. JR is the only record these exist.

MATERIAL  Section 5 — the JR block. ⚠ ASK MINTY FOR IT BY NAME.
          TRAPS entry 3.

NO BACKFILL NEEDED. Measured prod S98: company 464 only, 4 rows,
GLUTENULL ZERO.

VERIFY  Misc release on 474, then READ THE ROW. The count must be
        stored, not zero. ⚠ Read the ROW, not the toast. Then the
        SCREEN.
```

---

## WHEN P82 CLOSES

```
▶ P82 closes as a campaign when R3 and P82c are done.
▶ P135 CONTINUES as a watch item and is NOT part of P82.
  ⚠ S101 MEASURED THE R2 DIVISIONS CLEAN on a non-1:1 fixture —
    SOH, misc release, shipped, DO, PS, all exact. That removes
    the case for urgency. It does not remove the divisions.
▶ THEN P111 QUICKBOOKS. Minty's ruling S101.
  ⚠ PLANNING ONLY, NO CODE. Standing rule, unchanged.
  ⚠ IT NEEDS A NEW COLUMN, so TRAPS 3 will bite there too.
  ⚠ ALSO RAISED BY MINTY S100: food safety records. Not scoped.
    Needs its own sitting to define what is wanted.
```

---

## NOT IN THIS SESSION

```
P102   THE REBOOT. Own sitting. ⚠ VERIFY PM2 STARTS ON BOOT
       FIRST, and prod runs a different OS so dev does not
       rehearse it. ⚠ MISSED FIVE DAYS RUNNING.
P119   Back up the database's own code into the repo.
P108   Retire the J-entries. ⚠ KEEP JR. Own sitting, with Minty.
P100   Five unaccounted companies on dev, not two.
P137 / P138  New in S101. Not ranked.
```

---

## THE LESSONS S101 EARNED

⚠ Kept here deliberately rather than added to RULES. If they
  recur, Claude proposes a rule; the default is still NO.

```
1  MEASURING BEAT INFERRING, AGAIN. Nine sessions of P82 were
   built on code reads. One clean fixture run in one session
   found a REAL defect nobody had suspected, cleared six
   suspects that had been ranked for sessions, and confirmed
   P82c at the row.
   ▶ THE FIXTURE WAS THE WHOLE VALUE. Build one before
     reasoning about a quantity bug, not after.

2  READ THE TABLE BEFORE WRITING THE QUERY. THREE queries failed
   in S101 on guessed column names — `name`, `formula_id`,
   and a child table that did not exist. Each cost a round trip.
   ▶ `cols <table>` FIRST. It takes one command.
   ▶ The schema block is now in NOW so this does not repeat.

3  A COMMENT IN THE CODE SAVED AN HOUR. The S93 note above
   add-mlo:204 named four downstream sites and explained why the
   previous session stopped where it did.
   ▶ THIS IS P118'S BUSINESS CASE, PROVEN.
   ▶ AND ITS LIMIT: the list was INCOMPLETE. A fourth writing
     site was not mentioned. Trust a comment as a lead, verify
     it as a fact.

4  ASK WHAT WAS ENTERED BEFORE CALLING A FIGURE WRONG. Claude
   twice nearly logged a defect — the 8.34/1.92 pack weights,
   and the 240 Kg Ginger Powder — that turned out to be exactly
   what Minty typed. One question resolved both.
   ▶ The screen and the row are two arbiters. WHAT WAS ENTERED
     is a third, and Claude does not hold it.

5  PROD IS REACHED FROM THE MAC. An ssh from dev to prod failed
   and the prod health check silently ran on dev a second time.
   THIRD OCCURRENCE. RULES 2 already says this.

6  STOPPING WAS THE RIGHT CALL. The fix was located with 20
   minutes of grepping and turned out to be five-plus sites
   across two files, one of which writes. Starting that at the
   end of a long session is how the wrong box gets a command.
   ▶ A CLOSE THAT LEAVES NOTHING TO REDERIVE IS WORTH MORE THAN
     A RUSHED PATCH.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ Section 5's JR block ONLY IF P82c is reached.
NOTHING ELSE.
```
