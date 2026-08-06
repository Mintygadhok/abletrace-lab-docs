# PLAN

Written at close of: S105 · for S106.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S105 — ALL FOUR MATTER:
  "we can go with this method ie 1.167 times the batch qty for materials"
    — the ingredient rounding variance is ACCEPTED. Do not chase it.
  "the packing units for the mo to be derived from the formulation unit
    configuration (not wt/unit weight)"
    — became RULES 7.
  "unit wt must come from the original formulation - single point"
  "i feel it is part of my basic code logic and therefore needs to be
    referred to as bible" — RULES, not TRAPS.

⚠⚠ S105 DID NOT FINISH ONE THING AND IT IS NOT ITS FAULT.
  The frontend commit 30b2ddd4 is pushed and NOT BUILT. GitHub Actions
  queued for 10+ minutes and then served its own error page. A GitHub
  outage, not our code.
  ▶ THAT IS ACTION 2 BELOW. It is five minutes of work.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 51e9f4e · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺260 · 200
                served build dev-8fa2ed14179d
           prod backend 05f786c · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺338 · 200
                served build prod-0ad1f77cee1d
   ⚠⚠ THE BOXES NO LONGER MATCH. THIS IS DELIBERATE, NOT A FAULT.
      backend  dev 51e9f4e   prod 05f786c
      frontend dev 8fa2ed14179d   prod 0ad1f77cee1d
      Do NOT "reconcile" them. Nothing went to prod in S105.
   ⚠ dev's pm2 count moved 130 → 260 in S105. See LESSON 1.

2  BUILD AND DEPLOY 30b2ddd4. ⚠ FIRST REAL ACTION.
   Check github.com/Mintygadhok/abletrace-lab-frontend/actions for a
   green run on 30b2ddd4. If it never ran, re-run it from the Actions UI.
   Then download the dist-dev artifact and:
     ls -1t ~/Downloads/dist-dev-*.zip | head -1
     cd ~/Downloads && ~/promote.sh <that filename> dev
   ⚠ READ THE FILENAME OFF THE ls, NOT OFF A SCREENSHOT.
   ⚠ Cmd+Q the browser, not a reload.
   VERIFY on dev, company 474:
     MO-0001  QTY Planned  7# (58.38 Kg)   QTY Completed  58.38 Kg
     MO-0002  QTY Planned  2# (122.64 Kg)  QTY Completed  122.64 Kg
   ⚠ Completed shows WEIGHT ONLY, deliberately. See P149.
   ⚠ The `undefined#` currently on dev is what this deploy removes.

3  Then P149 — the procedure change. It is fully specified below.
```

---

## THE JOB · P149 · received_units IS NOT SERVED

### WHAT IS ALREADY KNOWN — DO NOT RE-INVESTIGATE

```
THE COLUMN EXISTS AND IS CORRECT.
  mlomanagement.received_units = 7 on MO-0001, 2 on MO-0002.
  Read at the row, S105, with the mysql client.

THE PROCEDURE DOES NOT SELECT IT.
  WhC_GetMoDetails_SP names its columns one by one. It selects
  received_qty and stops. CONFIRMED S105 by grepping SHOW CREATE.

▶ SO THE SCREEN CANNOT SHOW A UNIT COUNT IT NEVER RECEIVES.
  This is the SAME SHAPE as P143 (S104). Third instance. See LESSON 3.

⚠ THE FRONTEND IS ALREADY WRITTEN AND WAITING.
  check-mat-yield.component.ts carries a comment naming the EXACT
  string to restore:
    `${completedUnits}# (${completedKg} ${this.uom})`
  and the const it needs:
    const completedUnits = this.data.mlcDetails.received_units
  ▶ NOTHING NEEDS TO BE RE-DERIVED. Read the comment in the code.
```

### THE SEQUENCE — S104 REHEARSED IT, JR16 RECORDS IT

```
⚠ A DATABASE OBJECT REACHES NEITHER BOX BY DEPLOYING. Run it on each
  box separately, gate each box separately. NO PROMOTE PATH.

1  BACK UP FIRST, on each box, to /home/ubuntu:
     mysql abletracelab_live -e "SHOW CREATE PROCEDURE
       WhC_GetMoDetails_SP\G" > ~/WhC_GetMoDetails_SP.bak-S106-DEV.txt
   ⚠ NAME THE DATABASE. ⚠ USE \G.
   ⚠ ⚠ NEVER WRITE A BACKUP INTO api/models/. See LESSON 1.

2  GREP THE BACKUP to confirm it captured the body, not just a header.

3  BUILD THE NEW OBJECT ON THE BOX from that backup with a short
   script. ⚠ DO NOT PASTE A PROC BODY INTO A TERMINAL (S104 LESSON 1).

4  The change is ONE COLUMN added to the SELECT list:
     `mlomanagement`.`received_units`
   immediately after `mlomanagement`.`received_qty`. NOTHING ELSE.

5  Apply, then READ IT BACK OUT OF THE DATABASE.

6  ⚠ CHECK BOTH BOXES BY READING BOTH. S104 confirmed one proc was
   identical on both boxes by reading both. Do not assume it here.

7  Then restore the frontend line from the comment, build, deploy dev.
```

### WHAT DONE LOOKS LIKE

```
ON DEV, company 474:
  MO-0001  QTY Completed  7# (58.38 Kg)
  MO-0002  QTY Completed  2# (122.64 Kg)
⚠ NO HEAL. The column is already populated and correct.
⚠ NOT PROMOTED TO PROD in the same sitting unless Minty rules so.
```

---

## IF P149 CLOSES EARLY — THE SHORT LIST

⚠ Ranked by cheapness, not importance.

```
P147  CREATE A MATERIAL MR ON DEV, company 474. One minute.
P146  THE DECIMAL MISMATCH. list 25.020 vs details 25.02. ⚠ ASK MINTY.
P131  EDIT CLOSED MO LINE 133 — a unit count with a WEIGHT label.
      ⚠ NOW COVERED BY RULES 7. Same family as the header boxes fixed
        in S105. One line.
```

---

## NOT IN S106 — AND WHY

```
P150  ⚠⚠ THE PROCEDURE SURVEY. MINTY RAISED IT S105 AND IT IS BIG.
      Read every stored procedure's SELECT list and ask: does the
      screen it feeds need a unit column, and is it served?
      ▶ IT PRODUCES A LIST, NOT A REPAIR. Scope it before starting.
      ⚠ IT LIKELY ABSORBS P135 — the six header-view divisions and
        Edit-Mlc's three all exist BECAUSE the count was not served.
      ⚠ 35 routines and 9 views recorded in the S73-S79 sweep.
      OWN SITTING. Possibly two.

P151  EDIT-MLC DIVIDES A WEIGHT TO GET A COUNT. THREE PLACES.
      edit-mlc.component.ts:298 · :354 (getWdu) · html:258
      ⚠ FOUND S105 WHILE READING FOR P140. NOT INVESTIGATED.
      ⚠ RULES 7 FORBIDS THIS SHAPE. But the fix needs received_units
        served first — SAME BLOCKER AS P149.
      ▶ DO P149 FIRST. This may fall out of it.

P145  THE `returnedqty` DUPLICATE on /Edit-reject-product.
      ⚠ ASK MINTY WHAT "Returned Quantity" MEANS before reading code.
      ⚠ PRECONDITION OF P142, not a follow-up.

P142  THE COMMENTED-OUT EDIT BUTTONS. ⚠ ASK MINTY whether MR editing
      should exist at all.

P137  getInternalCode COUNTS GLOBALLY — MR NUMBERING ONLY.
      ⚠ S105 CONFIRMED MO NUMBERING IS ALREADY PER-COMPANY. Four
        companies each hold an MO-0002. The defect is MRs, not MOs.
      ⚠ ASK MINTY FIRST — renumbering changes how MRs read to a client.

P102  THE REBOOT. Own sitting. ⚠ MISSED TEN DAYS RUNNING.
      ⚠ PROD 43 UPDATES, DEV 12. ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
        A reboot is no longer a theoretical risk. Rehearse on dev.

P108  REVIEW THE J-ENTRIES WITH MINTY. Own sitting.

P111  QUICKBOOKS. PLANNING ONLY, NO CODE.
      ⚠ P82 NOW HAS ONLY P135 LEFT. P140 IS DONE.
```

---

## THE LESSONS S105 EARNED

⚠ Kept here rather than added to RULES. RULES 7 was added; that was
the one thing that earned it.

```
1  ⚠⚠ A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN.
   The patch script wrote MLOManagement.js.bak-S105-P140 NEXT TO the
   file it backed up. Sails loads EVERY file in api/models/ as a model
   and rejects any name with dots or dashes.
   ⚠ DEV CRASH-LOOPED ~130 TIMES. pm2 ↺ went 130 → 259.
   ⚠ RESTORING THE ORIGINAL FILE DID NOT HELP — the backup was still
     sitting there. The fix was `mv` of the backup, nothing else.
   ▶ BACKUPS GO TO /home/ubuntu. NEVER into an application directory.
   ⚠ RULES 2 ALREADY IMPLIES THIS. It was not written down explicitly
     and it cost an hour.

2  CLAUDE MISDIAGNOSED IT CONFIDENTLY AND WAS WRONG.
   The error said "invalid name". Claude's new variables began with
   `__`. Claude concluded it was them and said so.
   ⚠ THE FILE PARSED CLEAN. `node --check` passed. The same error
     persisted AFTER the restore — which should have ended the theory
     immediately and did not.
   ▶ LIST THE DIRECTORY BEFORE THEORISING ABOUT A LOADER ERROR.
   ▶ SAME ROOT AS S104 LESSON 2: an expectation formed from a
     plausible match rather than a measurement.

3  read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
   `SELECT CONCAT(...) AS lvl, LENGTH(x) AS len` returned ONLY the id.
   ⚠ CLAUDE CONCLUDED pack_level WAS EMPTY AND BUILT SEVERAL TURNS ON
     IT — including a detour toward dividing by weight. The column was
     FULLY POPULATED. The mysql client showed it immediately.
   ⚠ IT ALSO HID `batches` and a COUNT(*) earlier the same session.
   ▶ FOR ANYTHING COMPUTED, USE THE mysql CLIENT. → P152

4  A FIXTURE MUST DIFFER FROM ITS OWN ARITHMETIC.
   FO-0001 has batch_qty 6 AND six pouches per case. The broken code
   multiplied batch_qty by batches and landed at 7.002 — close enough
   to 7 that one line looked almost right.
   ▶ THE FIVE-LEVEL FIXTURE EXPOSED IT IN ONE READING. Ratios 4/3/7/1,
     none equal to batch_qty 5, base weight 0.73.
   ⚠ EVEN THEN, Pallet and Label still coincide at every MO quantity
     because batch_qty is 5 and there are 5 pallets per batch. Levels
     1-3 are the only discriminators.

5  A GUARD THAT IS TOO BROAD IS ITS OWN BUG.
   The v2 script refused because api/models/ contains `.gitkeep` — a
   legitimate file Sails ignores. Then the headers-fix script refused
   because Claude's own COMMENT contained the string it was checking
   for.
   ▶ BOTH REFUSALS WERE CORRECT BEHAVIOUR AND BOTH WERE WRONG CHECKS.
     Write the guard against the thing that actually breaks.

6  THE CI IS NOT OURS AND CAN SIMPLY STOP.
   30b2ddd4 queued 10+ minutes and never started. GitHub then served
   its own error page for the cancel request.
   ▶ NOTHING WAS WRONG WITH THE COMMIT. Do not debug the code when
     the platform is down. Check githubstatus.com and close.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ FOR P149: JR16 in Section 5 — the S104 procedure-change record.
  ASK MINTY FOR IT BY NAME AT STEP 1, not at open.
⚠ RULES 7 IS NEW. Read it before touching any quantity.
```
