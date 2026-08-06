# PLAN

Written at close of: S106 · for S107.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S106 — ALL FOUR:
  "leave it" — the 0.08 clamshell over-release on prod FO-0019 is the
    TRUE RECORD of what was physically picked. Not a wrong row.
  "rule wording ok" — RULES 2 now says Shift+Cmd+R, not Cmd+Q.
  "front end to wait till git gets going" — no workaround for the
    Actions outage. 30b2ddd4 waits.
  "scope it properly - p82/135/151 in next session" — S107 IS A
    SCOPING SITTING. It produces a list, not a repair.

⚠⚠ S107 IS NOT A FIXING SESSION. Say so at the open and mean it.
  The temptation will be to repair the first division that looks easy.
  ▶ THE WHOLE POINT IS TO FIND OUT WHICH ONES SHOULD NOT EXIST AT ALL.

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 51e9f4e · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺260 · 200
                served build dev-8fa2ed14179d
           prod backend 51e9f4e · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺340 · 200
                served build prod-0ad1f77cee1d
   ✓ THE BACKENDS NOW MATCH. That is new since S105.
   ⚠ THE FRONTENDS STILL DO NOT. dev 8fa2ed14179d, prod 0ad1f77cee1d.
     DELIBERATE. It clears only when Actions comes back.
   ⚠ ALSO CHECK: both databases serve received_units.
       mysql abletracelab_live -e "SHOW CREATE PROCEDURE
         WhC_GetMoDetails_SP\G" | grep -c received_units
     Expect 1 on EACH box. ⚠ Run on each separately.

2  CHECK GITHUB ACTIONS. githubstatus.com first, then the run page.
   ⚠ AT S106 CLOSE IT WAS A MAJOR OUTAGE — 6h29m and still open.
   IF IT IS BACK AND #56 HAS GONE GREEN on 30b2ddd4:
     ls -1t ~/Downloads/dist-dev-*.zip | head -1
     cd ~/Downloads && ~/promote.sh <that filename> dev
   ⚠ READ THE FILENAME OFF THE ls, NOT OFF A SCREENSHOT.
   ⚠ Shift+Cmd+R after the deploy.
   VERIFY on dev, company 474:
     MO-0001  QTY Planned  7# (58.38 Kg)   ⚠ NOT 58.379999999999995
     MO-0002  QTY Planned  2# (122.64 Kg)
   ▶ THEN CONSIDER PROD. It fixes the (Kg)-over-a-case-count labels
     Glutenull is still seeing. ⚠ ASK MINTY before promoting.
   IF IT IS STILL DOWN: leave it, say so once, move on. Do not
   re-run a third time. Do not debug our code.

3  Then the scoping sitting. It is specified below.
```

---

## THE JOB · S107 · SCOPE P135 AND P151

### WHY THIS IS A SURVEY AND NOT A REPAIR

```
THREE TIMES NOW, A DIVISION EXISTED ONLY BECAUSE A STORED COUNT WAS
NOT BEING SERVED.

  P143  S104  WhC_GetAllRejectedList_SP did not select
              qty_rejected_units. The MR screens divided.
  P149  S106  WhC_GetMoDetails_SP did not select received_units.
              The yield dialog printed undefined#, and Edit-Mlc
              divided in three places to cover for it.
  P135  ????  six divisions in Trace_ProductHeaderView. UNTESTED
              AGAINST THIS QUESTION.

⚠ THE PATTERN IS ESTABLISHED, NOT SUSPECTED. Two confirmed, both
  fixed by adding ONE COLUMN to a SELECT list.

▶ SO THE FIRST QUESTION FOR EACH OF THE SIX IS NOT "how do I fix this
  arithmetic". IT IS:
      IS THERE A STORED COLUMN HOLDING THE REAL COUNT,
      AND IS THE VIEW SIMPLY NOT SELECTING IT?

⚠ IF THE ANSWER IS YES, THE DIVISION DOES NOT NEED REPAIRING. IT
  NEEDS DELETING, and the column needs serving.
```

### THE SIX DIVISIONS — Trace_ProductHeaderView

```
qty_shipped_su          qty_packing_slip_su
qty_do_su               qty_misc_release_su
intermediate_prd_su     SOH_su

⚠ S95 SCOPING SAID: two repointable, three leave, one needs a schema
  change. ▶ THAT SCOPING PREDATES THE P143/P149 PATTERN. RE-ASK IT.

FOR EACH ONE, RECORD FOUR THINGS AND NOTHING ELSE:
  1  what the division currently is — the exact line
  2  which table and column the WEIGHT comes from
  3  whether a STORED UNIT COUNT exists anywhere for that quantity
  4  if yes, is it in the view's SELECT list? if no, is there a
     column that COULD hold it?

▶ THE OUTPUT IS A SIX-ROW TABLE. Not a patch. Not a commit.
```

### ⚠⚠ TRAPS 10 SITS DIRECTLY ON THIS JOB. READ IT FIRST.

```
Inside Trace_ProductHeaderView, the do_products CTE defines:
    sum(case when ps.shipped_flag then do.qty_to_ship else 0 end)
        AS qty_shipped              ⚠ THIS IS KG

The real column dispatchorders.qty_shipped is UNITS.
SAME NAME. OPPOSITE BASIS. A FEW LINES APART.

⚠ ANYONE REPOINTING qty_shipped_su BY READING THE CTE NAME WILL WIRE
  KG INTO A UNITS FIELD, and it will look plausible at every fixture.
▶ RESOLVE EVERY NAME TO ITS DEFINITION BEFORE TRUSTING IT.
  An alias is not a column and a CTE is not a table.
⚠ NOT YET BITTEN. Logged S95 before anyone built it. Keep it that way.
```

### P151 — THE BLOCKER IS GONE

```
edit-mlc.component.ts:298 · :354 (getWdu) · html:258
All three divide a weight to get a count. RULES 7 forbids it.

⚠⚠ THEY EXISTED BECAUSE received_units WAS NOT SERVED. IT IS NOW.
  WhC_GetMoDetails_SP feeds Edit-Mlc. S106 added the column to it on
  BOTH boxes and proved the value arrives:
      MO-0001 received_units 7 · MO-0002 received_units 2

▶ SO THESE THREE CAN BE REPOINTED AT this.data.mlcDetails.received_units
  EXACTLY AS check-mat-yield.component.ts already does.
⚠ COPY THE SHAPE THAT IS ALREADY WORKING. Do not invent a fourth.
⚠ IT IS A FRONTEND CHANGE. IT NEEDS A BUILD. If Actions is still
  down, WRITE IT AND COMMIT IT — do not wait to start.
⚠ ALSO READ 34e99c3e, the reverted patch behind fix 6. It may already
  contain half of this.
```

### WHAT DONE LOOKS LIKE

```
A SIX-ROW TABLE for P135, each row answering the four questions.
A RULING FROM MINTY on which of the six are worth doing and in what
  order — ⚠ THAT IS A BUSINESS CALL, not a technical one.
P151 EITHER WRITTEN AND COMMITTED, OR SCOPED IF THE VIEW WORK RUNS LONG.

⚠ NO SCHEMA CHANGE IN S107. If one of the six needs a new column,
  that is a separate sitting with its own backup and its own gate.
⚠ NOTHING GOES TO PROD IN S107 UNLESS MINTY RULES SO.
```

---

## IF THE SCOPING CLOSES EARLY — THE SHORT LIST

⚠ Ranked by cheapness, not importance.

```
P147  CREATE A MATERIAL MR ON DEV, company 474. One minute.
P146  THE DECIMAL MISMATCH. list 25.020 vs details 25.02. ⚠ ASK MINTY.
P131  EDIT CLOSED MO LINE 133 — a unit count with a WEIGHT label.
      ⚠ COVERED BY RULES 7. One line. ⚠ Needs a build.
P152  PUT A WARNING IN read-rows.js's OWN OUTPUT. It corrupts
      evidence, which is worse than being blind.
```

---

## NOT IN S107 — AND WHY

```
P150  ⚠⚠ THE FULL PROCEDURE SURVEY. 35 routines, 9 views.
      S107 does the P135 SUBSET of this question, not the whole thing.
      ▶ IF THE SUBSET GOES WELL, THE FULL SURVEY IS THE SESSION AFTER.
      OWN SITTING. Possibly two.

P154  ⚠ NEW. A SECOND BUILD ROUTE FOR THE FRONTEND.
      GitHub Actions was out for most of 6 Aug and the frontend was
      undeployable all session. The Mac has the source.
      ⚠ ASK MINTY WHETHER IT IS WORTH HAVING. It is not free — a
        second route is a second thing that can drift out of step.
      ▶ DO NOT BUILD IT ON ASSUMPTION.

P111  QUICKBOOKS. PLANNING ONLY, NO CODE.
      ⚠ P82 NOW HAS ONLY P135 LEFT. ▶ IT IS CLOSE.

P102  THE REBOOT. Own sitting. ⚠ MISSED ELEVEN DAYS RUNNING.
      ⚠ PROD 42 UPDATES, DEV 12. ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.

P108  REVIEW THE J-ENTRIES WITH MINTY. Own sitting.

P145 / P142  THE MR SCREENS. ⚠ ASK MINTY WHAT "Returned Quantity"
      MEANS before reading any code.

P137  MR NUMBERING. ⚠ ASK MINTY FIRST — renumbering changes how MRs
      read to a client.
```

---

## THE LESSONS S106 EARNED

⚠ Two of these went into RULES. The rest stay here.

```
1  ⚠⚠ A RESTART PROVES NOTHING ABOUT A PULL. → RULES 2.
   Prod was restarted, reported ↺339 online and HTTP 200, and was
   STILL RUNNING 05f786c. Everything looked like a successful
   promotion. Only reading HEAD caught it.
   ⚠ THE PULL HAD NEVER RUN AT ALL — it was swallowed when terminal
     output got pasted back in as input.
   ▶ READ HEAD AFTER EVERY PULL, BEFORE RESTARTING.

2  ⚠ PASTING TERMINAL OUTPUT BACK IN RUNS IT AS COMMANDS. → RULES 5.
   It produced a burst of "command not found", an EXIT CODE 127 that
   looked alarming and meant nothing, and — the real damage — it ate
   a git pull silently.
   ⚠ 127 IS THE SHELL SAYING "no such command". It is never our SQL.
   ▶ COPY ONLY FROM A FENCE. Scrollback is not a source.

3  PLAN WAS CONFIDENTLY WRONG ABOUT WHAT WAS BLOCKING P149.
   It said the header fix needed the build. It did not. 8fa2ed14 was
   ALREADY DEPLOYED and already reading received_units — printing
   `undefined#` because nothing was served. The moment the column
   arrived, the number appeared. NO BUILD WAS INVOLVED.
   ⚠ PLAN EVEN NAMED `undefined#` AND EXPLAINED IT AS SOMETHING THE
     DEPLOY WOULD REMOVE. The evidence was in the document.
   ▶ WHEN A DOCUMENT EXPLAINS A SYMPTOM, CHECK THE EXPLANATION IS
     STILL TRUE. A stale explanation reads exactly like a fresh one.

4  A RECORD WRITTEN BEFORE THE ACTION IS A RECORD OF AN INTENTION.
   NOW said docs main was eab4b59 with RULES 7 pending. GitHub said
   5b2cb9e with RULES 7 committed an hour before the session opened.
   The close had written what it was ABOUT to do and never corrected
   it. → RULES 6.

5  ⚠⚠ A BUG CAN HIDE ITSELF BY BREAKING BOTH SIDES OF A COMPARISON.
   On prod, Planned and Consumed were BOTH 1750.08. The variance read
   0 and the screen looked perfectly healthy. Fixing Planned to 1750
   made a real historical over-release visible for the first time.
   ⚠ THE CLEAN VARIANCE WAS THE EVIDENCE THAT SOMETHING WAS WRONG,
     and it read as evidence that everything was right.
   ▶ A DERIVED CHECK CANNOT VALIDATE THE THING IT IS DERIVED FROM.
   ⚠ CANDIDATE FOR TRAPS. NOT ADDED — Minty has not ruled. It fails
     silently and it puts a wrong number in front of a client, which
     is the test. ▶ RAISE IT ONCE IN S107 AND ACCEPT THE ANSWER.

6  THE FIXTURE THAT MATTERED WAS THE CLIENT'S OWN DATA.
   Two Glutenull products with 10 and 16 real ingredient lines proved
   the cascade fix in a way the dev fixtures could not — the
   ingredient lines were the CONTROL. Every one unmoved, while the
   packaging line changed.
   ▶ WHEN A FIX IS MEANT TO TOUCH ONE ROUTE, PROVE THE OTHER ROUTE
     DID NOT MOVE. That is what makes it evidence rather than hope.

7  THE COMMENT LEFT IN THE CODE PAID FOR ITSELF. → P118.
   check-mat-yield.component.ts carried the exact string to restore.
   S106 needed to re-derive NOTHING. The frontend was already right
   and had been for a day.
   ▶ KEEP DOING IT.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ FOR THE SCOPING: TRAPS 10 IS LOAD-BEARING. Read it before touching
  Trace_ProductHeaderView.
⚠ ASK MINTY FOR 34e99c3e — the reverted Edit-Mlc patch behind fix 6.
⚠ ASK MINTY FOR JR17 if the S106 procedure change needs revisiting.
⚠ RULES 2 AND 5 BOTH CHANGED IN S106. Read them.
```
