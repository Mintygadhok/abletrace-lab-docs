# PLAN

Written at close of: S107 · for S108.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S107:
  "leave them and move on" — Glutenull's small footprint does not
    by itself justify a backfill. The decision is still to be made.
  "we have to get on top of this" — the campaign has run long.
    S108 IS THE CLOSING SESSION FOR P82. Plan it that way.
  "p151 now" — and it is the reason a regression was caught before
    it shipped. See LESSON 1.
  PROD PROMOTION APPROVED for both the view change and a94f39c3.

⚠⚠ S108 CLOSES P82. Three cells, one column, one procedure, two
  frontend sites. ▶ IT IS A FULL SITTING. Do not start it late.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 51e9f4e · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺260 · 200
                served build dev-a94f39c3b2bf
           prod backend 51e9f4e · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺340 · 200
                served build prod-a94f39c3b2bf
   ✓ BOTH BOXES SHOULD MATCH ON ALL FOUR LAYERS. That is new.
   ⚠ ALSO CHECK the view is still at three divisions on EACH box:
       mysql abletracelab_live -e "SHOW CREATE VIEW
         Trace_ProductHeaderView\G" | grep -o "/" | wc -l
     Expect 3 on EACH. ⚠ Run on each separately.
   ⚠ IF ANY LAYER DIFFERS, STOP AND RECONCILE THE RECORD FIRST.

2  ⚠ READ P156 IN NOW BEFORE ANY PLANNING. There are TWO live
   clients on prod. Every exposure figure in this plan is sized
   against both, not against Glutenull alone.

3  Then the two measurements below, then Minty's ruling, then work.
```

---

## THE JOB · S108 · CLOSE P82

### ⚠⚠ THE ONE RULING THAT GATES EVERYTHING. ASK IT FIRST.

```
DO WE BACKFILL HISTORICAL UNIT COUNTS BY DIVIDING THE STORED Kg?

  YES  → all three remaining cells repoint this session. P82 closes.
         ⚠ IT WRITES DIVIDED FIGURES PERMANENTLY INTO CLIENT ROWS.
           That is the Route 3 round-trip this whole campaign
           exists to eliminate — done once, deliberately, to make
           the display correct from here on.
  NO   → the column and the write path still go in, so NEW activity
         is anchored. The three cells keep dividing until real
         counts accumulate. P135 STAYS OPEN BUT STOPS GROWING.

⚠ BOTH ANSWERS ARE DEFENSIBLE. It is a business call about the
  record, not a technical one.
⚠ THE EXPOSURE, MEASURED IN S107:
    MR rows needing backfill    28 — Hagensborg 24, sandbox 4,
                                Glutenull 0
    Intermediate rows           ⚠ NOT MEASURED. Possibly zero.
⚠ HAGENSBORG'S MOs ARE CREATED BUT NOT RUN, so their 24 rows have a
  history that is still fresh enough to check by eye.
▶ ASK THE QUESTION, THEN DO WHAT IS RULED. Do not assume yes.
```

### STEP 1 · TWO MEASUREMENTS, BEFORE THE RULING

```
A  HOW MANY ALLOCATION ROWS ARE INTERMEDIATES?
   intermediate_prd_su reads mprrecievelots rows where the released
   item is itself a formulation. Of Glutenull's 26 and the
   sandboxes' 42, how many are that?
   ⚠ IF ZERO FOR BOTH CLIENTS, the intermediate backfill touches NO
     client data and half the ruling evaporates.

B  DOES A DEV INTERMEDIATE FIXTURE EXIST?
   ⚠ P104 SAYS NO AND IT HAS SAID SO SINCE S45.
   ⚠⚠ IF IT DOES NOT, ONE MUST BE BUILT BEFORE intermediate_prd_su
     CAN BE PROVEN. TRAPS 9 governs every test in this campaign and
     an unproven view change does not go to a live client box.
   ▶ THAT IS A JOB, NOT A CHECK. If it is needed, it goes first and
     the session is shaped around it.

⚠ BOTH ARE READ-ONLY. Take them at the open.
```

### STEP 2 · THE SCHEMA CHANGE — `mprrecievelots`

```
ALTER TABLE mprrecievelots ADD COLUMN qty_allocated_units
  double DEFAULT 0;

⚠⚠ TRAPS 3: THE COLUMN ALONE IS NOT ENOUGH. It must ALSO be
  declared in the Waterline model attributes or every write is
  SILENTLY DROPPED with no error. That is J18/J20 exactly —
  received_units banked 0 for sessions until it was declared.
  ▶ BOTH, IN THE SAME BREATH, OR THE COLUMN IS DECORATION.
⚠ DOUBLE, NOT INT. Fractional shipping units are permitted by
  design (J88, Minty's ruling S80).
⚠ OWN BACKUP. OWN GATE. EACH BOX SEPARATELY. A schema change does
  not travel by deploying.
⚠ PROD DUMP NEEDS --single-transaction --skip-lock-tables
  --set-gtid-purged=OFF. Without skip-lock-tables RDS writes a
  header-only file that LOOKS like a backup. Check
  grep -c "INSERT INTO" before trusting it. → JR15.
```

### STEP 3 · THE WRITE PATH

```
MaterialsProductsReleased → createReleaseMaterialProductsV2
⚠⚠ V2 IS THE LIVE PATH. JT9 / J12. The older single-release
  function sits in the SAME FILE and editing it is an INVISIBLE
  NO-OP. It cost S46 real time — units appeared not to subtract
  because the wrong path was patched.
Backend commit, push, pull on each box, pm2 restart.
⚠ READ HEAD AFTER THE PULL, BEFORE RESTARTING. RULES 2. S106: prod
  restarted clean, returned 200, and was still on the old commit.
⚠ git fetch origin FIRST before reading origin/main. → P155.
```

### STEP 4 · THE PROCEDURE — `WhC_GetMoProductReceivingDetails_SP`

```
ADD receiveproducts.qty TO THE SELECT LIST. NOTHING ELSE.
⚠ MEASURED IN S107: it serves id, internalCode, mlc_id,
  mlc_packaging_id, received_at, recieved_qty. NO unit count.
▶ FIFTH INSTANCE OF THE PATTERN. → P157.
▶ IT UNBLOCKS P151's LAST SITE.
JR16 METHOD, on each box, from that box's OWN backup:
  SHOW CREATE to .bak · verify line and join counts · build by node
  script with anchor assertions · diff · apply · read back out of
  the DATABASE · CALL it.
⚠ NEVER PASTE A PROC BODY INTO A TERMINAL. SSH input buffer
  overflow discards the overflow silently. → JR16.
⚠ Recreate WITHOUT the definer clause. RDS can refuse one.
```

### STEP 5 · THE VIEW — one edit, three cells

```
qty_misc_release_su  → the mr CTE currently sums rmp.qty_rejected.
                       Point it at qty_rejected_units.
                       ⚠ EVERY EXISTING ROW HOLDS 0. Without the
                         backfill this turns a right-looking figure
                         into a wrong one. GATED ON THE RULING.
intermediate_prd_su  → the new mprrecievelots column.
SOH_su               → subtract the five UNIT terms. No division.
                       ⚠ CANNOT MOVE UNTIL THE OTHER TWO DO. It
                         subtracts both of them.

⚠ ROLLBACK IS ALREADY ON BOTH BOXES:
    Trace_ProductHeaderView.bak-S107-{DEV,PROD}.txt
  ⚠ THOSE HOLD THE PRE-S107 VIEW WITH SIX DIVISIONS. Re-capture a
    fresh backup at the top of S108 — the live object has changed.

⚠⚠ TRAPS 10 STILL APPLIES. Resolve every name inside the view to
  its DEFINITION before trusting it. An alias is not a column and a
  CTE is not a table. It paid for itself in S107.

▶ THE ACCEPTANCE TEST IS ARITHMETIC:
    grep -o "/" | wc -l  MUST RETURN 0 ON BOTH BOXES.
  ⚠ THE VIEW CURRENTLY RETURNS 3. When it returns 0, every one of
    the seven _su fields reads a stored count and P135 is done.
```

### STEP 6 · P151's REMAINDER — frontend

```
edit-mlc.component.ts:298   completeUnit → mlcDetails.received_units
                            ⚠ LIVE, consumed at :310. Simple.
                            ⚠ :295 lotReceived is DEAD (J114).
                              LEAVE IT. It is P115's.
edit-mlc html:258 + getWdu  → the row's own count, from step 4.
                            ⚠⚠ PER-RECEIPT, NOT the MO total. Using
                              received_units here puts the WHOLE
                              MO's figure on EVERY receipt row.
                            ⚠ getWdu has ONE live caller — this
                              line. Fixing it makes getWdu dead.
                              ▶ DELETE IT in the same pass. → P115.
⚠ FRONTEND IS EDITED ON THE MAC. A push builds dev; prod needs a
  manual dispatch. Both worked normally in S107.
```

### WHAT DONE LOOKS LIKE

```
Trace_ProductHeaderView returns ZERO divisions on BOTH boxes.
All seven _su fields read stored counts.
Screen-proven on a NON-1:1 fixture AND on both clients.
The receiving panel shows a real per-receipt unit count.

▶ P135 CLOSES · P82 CLOSES · TRAPS 10 RETIRES · P111 UNBLOCKS.

⚠ IF THE RULING IS NO ON BACKFILL: steps 2, 3, 4 and 6 STILL RUN.
  Only step 5's two repoints wait. P82 closes on new activity
  rather than immediately. THAT IS A LEGITIMATE OUTCOME, NOT A
  FAILURE, and it should be recorded as a decision, not a slip.
```

---

## IF S108 CLOSES EARLY — THE SHORT LIST

⚠ Ranked by cheapness, not importance.

```
P147  CREATE A MATERIAL MR ON DEV, company 474. One minute.
P131  EDIT CLOSED MO LINE 133 — a unit count with a WEIGHT label.
      ⚠ COVERED BY RULES 7. One line. The build works again.
P146  THE DECIMAL MISMATCH. list 25.020 vs details 25.02. ⚠ ASK MINTY.
P152  PUT A WARNING IN read-rows.js's OWN OUTPUT. It corrupts
      evidence, which is worse than being blind.
P137  MR NUMBERING IS GLOBAL. ⚠ MORE URGENT WITH TWO CLIENTS.
      ⚠ ASK MINTY FIRST — renumbering changes how MRs read.
```

---

## NOT IN S108 — AND WHY

```
P150  ⚠⚠ THE FULL PROCEDURE SURVEY. 35 routines, 9 views.
      ⚠ FIVE CONFIRMED INSTANCES NOW. The pattern is not in doubt.
      ▶ OWN SITTING, POSSIBLY TWO. AFTER P82 CLOSES.

P156  ⚠⚠ HAGENSBORG. The DOCUMENTATION half is its own sitting —
      correcting 3B, re-scoping P100, confirming no third company.
      ⚠ BUT READ IT AT THE OPEN. It sizes everything in step 1.

P102  THE REBOOT. Own sitting. ⚠ TWELVE DAYS RUNNING.
      ⚠⚠ AND THERE ARE NOW TWO CLIENTS ON PROD, WHICH RAISES THE
        COST OF BOTH DOING IT AND NOT DOING IT.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.

P111  QUICKBOOKS. PLANNING ONLY, NO CODE.
      ▶ IT UNBLOCKS THE MOMENT S108 CLOSES.

P108  REVIEW THE J-ENTRIES WITH MINTY. Own sitting.

P145 / P142  THE MR SCREENS. ⚠ ASK MINTY WHAT "Returned Quantity"
      MEANS before reading any code.
```

---

## THE LESSONS S107 EARNED

```
1  ⚠⚠ A WORKAROUND BECOMES A DEFECT THE MOMENT THE CAUSE IS FIXED,
   AND NOTHING ANNOUNCES THE CHANGEOVER.
   30b2ddd4 removed a unit count because the procedure did not
   serve it. S106 fixed the procedure that afternoon. The commit
   sat in a queue, unbuilt, still carrying "drop the count".
   ⚠ PLAN'S OWN FIRST-THREE-ACTIONS SAID: WHEN ACTIONS RETURNS,
     DEPLOY IT TO DEV, THEN CONSIDER PROD. Following that
     instruction would have taken a working figure off the screen.
   ⚠ THE GITHUB OUTAGE — the obstacle of the whole previous
     session — IS THE ONLY REASON IT HAD NOT ALREADY HAPPENED.
   ⚠ AND IT WAS ONLY FOUND BECAUSE MINTY SAID "p151 now" RATHER
     THAN DEFERRING IT. Reading the file found it; no amount of
     reading the plan would have.
   ▶ BEFORE DEPLOYING ANY COMMIT WRITTEN BEFORE A FIX LANDED, READ
     WHAT IT ACTUALLY DOES. A commit message describing a
     workaround is a warning label.

2  A COMMENT NAMING THE EXACT RESTORE STRING PAID FOR ITSELF A
   SECOND SESSION RUNNING. → P118.
   check-mat-yield carried `${completedUnits}# (${completedKg}
   ${this.uom})` inside a comment explaining why it was disabled.
   S107 needed to re-derive NOTHING.
   ▶ THE NEW COMMENT RECORDS WHY IT CAME BACK, so nobody reads
     30b2ddd4's message and re-drops it. KEEP DOING THIS.

3  ⚠⚠ THE RECORD NAMED ONE CLIENT AND THERE ARE TWO.
   Hagensborg, 24 MR rows, seven MOs, real products — and listed
   in NOW only as an unaccounted company ON DEV.
   ⚠ IT WAS FOUND BY A ROUTINE GROUP-BY THAT DID NOT HAVE TO
     INCLUDE company_name AND DID.
   ⚠ EVERY EXPOSURE FIGURE REASONED IN THAT SESSION — INCLUDING
     CLAUDE'S — WAS WRONG UNTIL THAT QUERY RAN. "Glutenull has two
     MOs, so the backfill is small" was built on a record, not a
     measurement.
   ▶ WHEN SIZING A WRITE TO CLIENT DATA, GROUP BY THE OWNER. Never
     take the client list from a document.

4  ⚠ A DOCUMENT'S SCOPING CAN GO STALE BECAUSE SOMETHING ELSE WAS
   FIXED.
   S95 scoped the six divisions as "two repointable, three leave,
   one needs a schema change". By S107 it was FOUR repointable —
   because JR15 added qty_rejected_units in S103, and because
   nobody had checked what else sat on the dispatchorders row.
   ⚠ THE SCOPING WAS NOT WRONG WHEN WRITTEN. It aged.
   ▶ RE-ASK A SCOPE BEFORE BUILDING FROM IT, especially where the
     campaign has been adding columns.

5  ⚠ A PROD BLOCK WITHOUT `hostname -I` RAN ON THE WRONG BOX.
   A read, so no harm — but it wrote a file named `-DEV` onto
   PROD, and a mislabelled backup on a live client box is exactly
   the thing that must be right before it is needed.
   ⚠ IT ALSO PROVED SOMETHING USEFUL BY ACCIDENT: the two boxes'
     views were BYTE-IDENTICAL, 5932 bytes.
   ▶ RULES 2 ALREADY REQUIRES THE LINE. Claude omitted it. The
     rule is not the problem; following it is.

6  A FIXTURE THAT EXERCISES ONLY SOME STATES PROVES ONLY THOSE
   STATES.
   Dev had dispatch orders in two of three bucket states at a
   non-round weight. ONE new DO — a minute's work in the app —
   made MO-0007 exercise all three at 1.39 Kg/unit.
   ▶ BUILD THE MISSING STATE BEFORE THE FIX, NOT AFTER. It cost
     one minute and it is why three cells could be proven instead
     of two.

7  THE EXPECTED RESULT ON PROD WAS "NOTHING CHANGES", AND THAT WAS
   THE PROOF.
   Both prod fixtures sit on ROUND ratios where the division lands
   exactly. Predicting no change, then seeing no change, is
   evidence the route changed safely.
   ⚠ IT IS ALSO A WARNING: prod cannot currently reveal a division
     defect at all. Its data is too round. THE DEV FIXTURE IS THE
     ONLY PLACE THIS CAMPAIGN CAN BE TESTED.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ FOR THE VIEW WORK: TRAPS 10 IS STILL LOAD-BEARING.
⚠ ASK MINTY FOR JR15 (the column-add rehearsal), JR16 and JR17
  (the procedure method) — steps 2 and 4 both follow them exactly.
⚠ ASK MINTY FOR SECTION 3A.5 rows 3, 11 and 12 before touching the
  release write path.
⚠ P156 IS IN NOW AND IT CHANGES THE SIZE OF THE JOB. READ IT FIRST.
```
