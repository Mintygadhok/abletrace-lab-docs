# PLAN

Written at close of: S104 · for S105.
Disposable. Rewritten whole at every close.

⚠ MINTY'S RULINGS, S104:
  "brackets now" — the list matches the ruled format `3# (25.020 Kg)`
  "go this way - 3# (25.02 Kg)" — folded into one field on the
    details screen, not two separate boxes.

⚠⚠ S105 HAS ONE JOB AND IT HAS BEEN DISPLACED TWICE.
  P140 — THE YIELD SCREEN. Minty asked for it at S103 close in
  writing. S103 did not reach it. S104 did not reach it. Both times
  P143 took the session.
  ▶ P143 IS DONE. THERE IS NOTHING LEFT TO DISPLACE IT.
  ⚠ DO NOT OPEN A SECOND JOB UNTIL THE FOUR QUESTIONS ARE ANSWERED.

⚠ THIS IS A MEASUREMENT SPEC, NOT A FIX SPEC. Claude cannot write
  the fix yet and saying so is the point. The screen has not been
  read and the file has not been located. What IS specified is every
  check, with the distinguishing result stated in advance.
  ▶ THE FIX SPEC IS THE OUTPUT OF THIS SECTION, NOT ITS INPUT.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 05f786c · frontend checkout c2a52d8e · clean
                pm2 abletrace-dev ↺130 · 200
                served build dev-0ad1f77cee1d
           prod backend 05f786c · frontend checkout 9bce0238 · clean
                pm2 abletrace-backend ↺338 · 200
                served build prod-0ad1f77cee1d
   ⚠ BOTH FRONTENDS MOVED IN S104. 125014a3ab26 → 0ad1f77cee1d.
     BACKENDS DID NOT MOVE. pm2 counts DID NOT MOVE — 130 and 338,
     same as S104 open.
   ⚠ THE DATABASES ALSO MOVED — WhC_GetAllRejectedList_SP on both.
     A health check does not test that. See JR16.
   If anything differs from the ABOVE, STOP.

   ⚠ PROD: be on the prod terminal and run the block bare, OR ssh
     from the MAC. Never ssh from dev.
     ▶ PUT `hostname -I` AT THE TOP OF THE PROD BLOCK. Prod must
       report 172.31.3.156.

2  Then STEP Y1 — THE BEFORE-READING. ⚠ SCREENSHOT FIRST, NO CODE
   UNTIL IT EXISTS.
```

---

## THE JOB · P140 · THE YIELD SCREEN

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
  S100 lesson 4. And S101's figures are FOUR SESSIONS OLD —
  RE-READ THE SCREEN, do not assume it still shows 7.002.
```

### STEP Y2 · LOCATE THE SCREEN. ⚠ NOT YET KNOWN.

```
⚠ NEITHER THE ROUTE NOR THE COMPONENT PATH HAS BEEN READ. S101 and
  S102 both worked from the screen only. DO NOT GUESS THE FILE —
  S102 lost time twice on plausible-looking wrong files, S103 lost
  two rounds on the wrong MR screens, and J89 records the same on
  release-mat-details.

ON THE MAC:
  grep -rn "Check Material Yield" ~/abletrace-lab-frontend/src
  then find the component and read it WHOLE, not by grep.

⚠ IT WILL BE UNDER .../warehouse/mfg-lot-codes/edit-mlc/ — the
  button lives on Edit-Mlc — but CONFIRM, do not assume.

⚠⚠ AND CHECK WHETHER THE SCREEN FETCHES ITS OWN DATA AT ALL.
  S104's LESSON: edit-reject-product looked like a screen with a
  data source and turned out to subscribe to a BehaviorSubject fed
  by the LIST screen. A component that displays numbers is not
  necessarily a component that FETCHES them.
  ▶ IF IT SUBSCRIBES TO A SERVICE, FIND WHO CALLS .next(). That
    caller is the real source, and the fix may not be in this file.

⚠ ALSO GREP THE BACKEND. The figures may arrive pre-computed from
  a controller or a stored proc, as SO status did (J114). If so the
  frontend is innocent and the fix is elsewhere entirely.
  ▶ IF IT IS A PROC, READ IT FROM EITHER BOX'S mysql CLIENT NOW.
    ⚠ DEV CAN DO THIS SINCE S104 — ~/.my.cnf exists on both boxes.
      mysql abletracelab_live -e "SHOW CREATE PROCEDURE <name>\G"
    ⚠ NAME THE DATABASE. ⚠ USE \G, NOT ;.
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
        cascade is computed at READ time, never stored, and that it
        SILENTLY FALLS BACK TO 1/1/1 if
        WhC_GetFormulaPackagingMaterials stops returning whd_flag
        and pack_level. THAT FALLBACK PRODUCES EXACTLY THIS
        SYMPTOM — every level showing one figure.
    ▶ CHECK THE PROC FIRST:
        mysql abletracelab_live -e "SHOW CREATE PROCEDURE
          WhC_GetFormulaPackagingMaterials\G"
      EXPECT whd_flag and pack_level in the SELECT. If absent, the
      cause is JR6 and the fix is a DATABASE object, not code.
      ⚠ THAT WOULD ALSO MEAN PROD IS AFFECTED. Check both boxes.
      ⚠ AND CHECK BOTH — S104 confirmed one proc was identical on
        both boxes BY READING BOTH. Do not assume it for this one.

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
  ⚠ S104 IS THE REHEARSAL. The exact sequence that worked:
      backup to a file → grep the backup → build the new object ON
      THE BOX from that backup → diff the joins → apply → read it
      back out of the database.
    ⚠ DO NOT PASTE A PROC BODY INTO A TERMINAL. See LESSON 1.
▶ If Q3 finds planned and completed read genuinely different
  sources, the screen needs a design decision from Minty about what
  "planned" should mean — the recipe requirement, or what was
  actually released. THAT IS A DOMAIN QUESTION, NOT A CODE ONE.
  ⚠ ASK. Do not choose.
```

---

## IF P140 CLOSES EARLY — THE SHORT LIST

⚠ ONLY IF. Do not start any of these while the four questions are
open. Ranked by cheapness, not importance.

```
P147  CREATE A MATERIAL MR ON DEV, company 474. One minute. It
      completes the fixture and lets the P143 type gate be proven
      on dev rather than on prod's sandbox.

P146  THE DECIMAL MISMATCH. list 25.020 vs details 25.02.
      ⚠ ASK MINTY. A screen question. One line either way.

P131 + Y4  THE TWO WEIGHT-LABELLED UNIT COUNTS. Same family, one
      commit, if Y4's headers are confirmed.
```

---

## NOT IN S105 — AND WHY

```
P145  THE `returnedqty` DUPLICATE on /Edit-reject-product.
      ⚠ FOUND IN S104 WHILE READING THE FILE FOR P143. NOT
        INVESTIGATED. Two boxes show the same number under two
        different labels, and the save handler writes the released
        quantity FROM the "Returned" box.
      ▶ ⚠ ASK MINTY WHAT "Returned Quantity" IS MEANT TO MEAN
        BEFORE READING ANY CODE. It is a domain question.
      ⚠ IT IS A PRECONDITION OF P142, NOT A FOLLOW-UP.

P142  THE COMMENTED-OUT EDIT BUTTONS. ⚠ S104 RAISED THE STAKES —
      `qty` now holds a formatted string, so re-enabling saving
      could write that string back. `readonly` guards it; that is
      not a fix. ⚠ ASK MINTY whether MR editing should exist.

P137  getInternalCode COUNTS GLOBALLY. ⚠ CAUSE FOUND S102, do not
      re-investigate. ⚠ ASK MINTY FIRST — renumbering affects how
      MRs read to a client. Business question, not a tidy-up.

P102  THE REBOOT. Own sitting. ⚠ MISSED NINE DAYS RUNNING.
      ⚠ PROD 43 UPDATES, DEV 12. ⚠ VERIFY PM2 STARTS ON BOOT FIRST.

P108  REVIEW THE J-ENTRIES WITH MINTY. ⚠ PROMOTED AGAIN BY S104.
      Section_5.md is now 3451 lines — it has grown 680 lines since
      the queue note calling it too big was written. TWO JR entries
      in two sessions. Own sitting. NOT a tidy-up — it protects the
      rebuild path.

P111  QUICKBOOKS. ⚠ P82 IS DOWN TO P135 AND P140.
      PLANNING ONLY, NO CODE.
      ⚠ IT NEEDS A NEW COLUMN AND PROBABLY A PROC CHANGE. S103
        REHEARSED THE COLUMN (JR15). S104 REHEARSED THE PROC
        (JR16). Both sequences are now written down.
```

---

## THE LESSONS S104 EARNED

⚠ Kept here rather than added to RULES. If they recur, Claude
proposes a rule; the default is still NO.

```
1  ⚠⚠ A LONG PASTE INTO SSH SILENTLY LOSES LINES.
   The first attempt at the procedure file was a 35-line heredoc
   with one line over 1000 characters. It arrived MANGLED —
   `ENDOFFILE` welded into the middle of a line, four lines and one
   join gone. The SSH input buffer overflowed and the overflow was
   DISCARDED, not queued.
   ⚠ THE FILE EXISTED AND LOOKED PLAUSIBLE. Only the line count and
     join count exposed it.
   ⚠ RUNNING IT WOULD HAVE DROPPED THE PROCEDURE AND FAILED TO
     RECREATE IT. The MR list on dev would have gone dead.
   ▶ RULES 5.2 ALREADY SAYS ANYTHING LONG GOES AS A FILE. Claude
     pasted anyway. THE RULE WAS RIGHT AND WAS IGNORED.
   ▶ IT HAPPENED A SECOND TIME the same session, on a Python patch
     script with a 30-line triple-quoted string. The terminal hung
     on a `quote>` prompt. TWICE IN ONE SESSION.
   ▶ THE METHOD THAT WORKS: build the object ON THE BOX from its
     own backup with a short script, or hand Minty a FILE to
     download. The long text never travels.

2  AN EXPECTED VALUE MUST COME FROM A FILE, NOT FROM CLAUDE'S EYES.
   Claude counted twelve joins off the screen and told Minty to
   expect twelve. The real number is eleven. The check "failed" and
   cost a round of investigation on a file that was correct.
   ▶ THE FIX WAS TO DIFF AGAINST THE BACKUP, NOT TO COUNT.
   ▶ SAME ROOT CAUSE AS THE FILENAME TYPO LATER THE SAME SESSION —
     a doubled character read off a screenshot. ▶ READ IDENTIFIERS
     OFF THE DISK WITH `ls`, NEVER OFF AN IMAGE.

3  AN EMPTY RESULT IS NOT A BROKEN THING.
   CALL WhC_GetAllRejectedList_SP('474','1') returned nothing and
   looked exactly like a broken procedure. The status column holds
   the WORD 'Active'. The argument was wrong, not the object.
   ▶ SAME SHAPE AS S103's LESSON 5, ONE SESSION LATER. WHEN A CHECK
     RETURNS NOTHING, ESTABLISH WHETHER IT FAILED OR THE ANSWER IS
     EMPTY — BEFORE CONCLUDING ANYTHING.

4  A TOOL THAT "CANNOT" DO SOMETHING MAY JUST BE MISSING A FILE.
   P144 was recorded as read-rows.js being unable to print routine
   bodies. Dev had /usr/bin/mysql the whole time and lacked only
   ~/.my.cnf. A blocked job, a queue item and a workaround all
   traced to one absent config file.
   ▶ BEFORE LOGGING A CAPABILITY GAP, CHECK WHAT IS MERELY ABSENT.

5  A SCREEN THAT DISPLAYS DATA MAY NOT FETCH IT.
   edit-reject-product looked like an independent screen. It
   subscribes to a BehaviorSubject fed by the LIST component. So
   one stored procedure fed both screens, and PLAN's "two
   independent pieces of work" was one piece with two faces.
   ▶ TRACE THE SUBSCRIPTION TO ITS .next() CALLER BEFORE SIZING
     ANY DISPLAY JOB.

6  A FORMAT RULING IS A SPEC AND CLAUDE MISSED HALF OF IT.
   Minty ruled `2# (16.68 Kg)`. Claude built the list WITHOUT the
   brackets and the details WITH them, then shipped both to dev
   before noticing. Two screens, one fact, two formats.
   ▶ CAUGHT ON THE SCREENSHOT, NOT IN REVIEW. Read the ruling back
     against the built thing BEFORE deploying.

7  THE FIXTURE THAT PROVED IT WAS ON THE WRONG BOX.
   Dev could not prove the type gate stays OFF for material rows —
   474 has no material MR. Prod's sandbox company had one, sitting
   between three product rows in the same table.
   ▶ A NEGATIVE CANNOT BE PROVEN WITHOUT A CASE THAT SHOULD FAIL.
     Check the fixture holds one BEFORE building the gate.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
⚠ FOR THE YIELD JOB: Section 5's J5 and J24 entries, and JR6 —
  ASK MINTY FOR THEM BY NAME AT STEP Y2, not at open.
⚠ J5 IS THE ONE THAT MATTERS. It describes the exact failure
  symptom this screen shows.
```
