# NOW

Last rewritten: S106, 6 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠⚠ S106 CHANGED BOTH BOXES. Backend AND both databases.
  THE BACKENDS NOW MATCH AGAIN. The frontends still do not.

---

## STATE

⚠ READ OFF BOTH BOXES AT S106 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺260 · 200
          frontend SERVING dev-8fa2ed14179d
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 51e9f4e · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ HELD AT 260 ALL SESSION. The S105 crash loop is dead
            and stayed dead. Nothing was restarted on dev in S106.

PROD      15.157.38.101 · pm2 abletrace-backend ↺340 · 200
          Glutenull live · SERVING prod-0ad1f77cee1d
          backend HEAD 51e9f4e · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 42 updates pending · restart required → P102
            ⚠ NOW SAID 43 AT S105. The box says 42. Corrected.
          ⚠ ↺ WENT 338 → 340. TWO RESTARTS, BOTH DELIBERATE.
            339 = the restart that ran BEFORE the pull had landed.
            340 = the real one, after HEAD read 51e9f4e.
            ▶ SEE LESSON 1. Neither was a crash.

✓ THE BACKENDS NOW MATCH.   dev 51e9f4e   prod 51e9f4e
⚠ THE FRONTENDS DO NOT.     dev 8fa2ed14179d   prod 0ad1f77cee1d
  That gap is P140's header fix, live on dev, still waiting on prod.
  ▶ IT CLEARS WHEN GITHUB ACTIONS COMES BACK. Not before.

⚠⚠ BOTH DATABASES CHANGED IN S106.
  WhC_GetMoDetails_SP now selects received_units on BOTH boxes.
  Applied separately, read back separately, on each box. → JR17.

GITHUB    frontend main = 30b2ddd4  ⚠⚠ PUSHED, STILL NOT BUILT
          backend  main = 51e9f4e   (now live on both boxes)
          docs     main = 5b2cb9e   ⚠ RULES 7 IS COMMITTED.
            ⚠ S105's NOW claimed it was pending and named eab4b59.
              IT WAS ALREADY PUSHED. The record was written before
              the push and never corrected. → LESSON 4.

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-8fa2ed14179d
          prod  /home/ubuntu/www-html.bak-prod-0ad1f77cee1d
          ⚠ THE DEV ONE HOLDS 0ad1f77cee1d — a backup dir holds the
            build it REPLACED, not the one it is named after.
          ⚠ READ OFF THE BOX AT CLOSE, not written from the label.

          DATABASE BACKUPS, S106, in /home/ubuntu on each box:
            DEV   WhC_GetMoDetails_SP.bak-S106-DEV.txt    (before)
                  WhC_GetMoDetails_SP.after-S106-DEV.txt  (after)
                  fix-modetails-S106.sql                  (applied)
            PROD  WhC_GetMoDetails_SP.bak-S106-PROD.txt   (before)
                  WhC_GetMoDetails_SP.after-S106-PROD.txt (after)
                  fix-modetails-S106.sql                  (applied)
          ⚠ THE .bak FILES ARE SHOW CREATE TEXT, NOT RUNNABLE.
            To restore, take the body and add the DELIMITER wrapper.
            Same shape as JR16.
          ⚠ BOTH VERIFIED COMPLETE BEFORE USE — 28 lines, BEGIN 1,
            END 1, joins 8.

          BACKEND BACKUPS still on DEV in /home/ubuntu:
            MLOManagement.js.bak-S105-P140           (attempt 1)
            MLOManagement.js.bak-S105-P140-attempt2  (the live one)
          ⚠⚠ NEVER PUT A BACKUP IN api/models/. TRAPS/P153.

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small

COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ 474 = test260805@ ON DEV. THE CLEAN REFERENCE SET.
          ⚠ test260703@ IS A SANDBOX COMPANY ON PROD with FOUR MR
            ROWS including a MATERIAL one. ▶ USE IT for prod screen
            checks. NO CLIENT DATA IS TOUCHED.
          ⚠ dev also carries 466, 469, 470, 472, 473 → P100

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          ⚠ NAME THE DATABASE ON EVERY mysql CALL. → P134

⚠ PROD IS REACHED FROM THE MAC — OR RUN LOCALLY ON A PROD TERMINAL.
  NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156.
```

---

## P149 — ✓ CLOSED S106. BOTH BOXES. SCREEN-PROVEN.

```
WHAT IT WAS: mlomanagement.received_units is stored and correct, and
WhC_GetMoDetails_SP — which names its columns one by one — did not
select it. So the yield dialog could not show a count it never got.

THE CHANGE: one column added to the SELECT list, immediately after
received_qty. NOTHING ELSE. Definer clause dropped on recreate.

  `mlomanagement`.`received_units`,

METHOD — JR16's, followed exactly, on each box separately:
  1  SHOW CREATE to a .bak file in /home/ubuntu. Verify it captured
     the BODY — 28 lines, BEGIN 1, END 1, joins 8.
  2  Build the new object ON THE BOX from its OWN backup, with a
     short node script carrying four guards.
  3  diff old against new: EXACTLY TWO lines must differ — the
     CREATE line and the select-list line. Join count must hold at 8.
  4  Apply. Read it back OUT OF THE DATABASE, not off the file.
  5  CALL it and look at the result.
▶ NO PROC TEXT EVER TRAVELLED THROUGH SSH. → JR17.

PROVEN, DEV, company 474:
  MO-0001  received_qty 58.38   received_units 7   FO-0001
  MO-0002  received_qty 122.64  received_units 2   FO-0003-3
  ON SCREEN:  QTY Completed  7# (58.38 Kg)

PROVEN, PROD:
  procedure read back: received_units 1 · joins 8 · 28 lines
  CALL returns cleanly. MO detail screen and yield dialog both open.
  ⚠ NO VISIBLE CHANGE ON PROD YET — prod's frontend cannot read the
    new column until 30b2ddd4 builds. The column is served and waiting.

⚠⚠ NO BUILD WAS NEEDED ON DEV. PLAN SAID OTHERWISE AND WAS WRONG.
  8fa2ed14 was already deployed and already reading received_units —
  it was printing `undefined#` because nothing was being served.
  The moment the column arrived, the number appeared.
  ▶ THE PROCEDURE WAS THE WHOLE BLOCKER. → LESSON 3.
```

---

## P140 — ✓ CLOSED. NOW ON PROD TOO.

```
Backend 51e9f4e promoted to prod in S106 and PROVEN ON SCREEN.

SEEN ON PROD, before and after, Fruits & Nut Breakfast Bars FO-0019:
  BEFORE  Clamshell320  Planned 1750.08 Ea  Consumed 1750.08  var 0
  AFTER   Clamshell320  Planned 1750    Ea  Consumed 1750.08  var -0.08

  Buckwheat Granola Bar FO-0022:
          Clamshell240  Planned 802 Ea  Consumed 802 Ea  var 0

⚠ EVERY INGREDIENT LINE UNMOVED. Agave, Almond Sliced, Water,
  Xanthan Gum, Sunflower Seeds all identical before and after.
  ▶ THAT IS THE CONTROL. It proves only the packaging route changed.

⚠⚠ THE -0.08 IS NOT A NEW DEFECT. READ THIS BEFORE RE-RAISING IT.
  Planned is now correct at 1750. Consumed 1750.08 is a TRUE RECORD
  of what was physically released, back when the broken code told the
  operator to release 1750.08.
  ⚠ THE OLD BUG MADE PLANNED WRONG IN EXACTLY THE SAME WAY AS
    CONSUMED, so the variance read 0 AND THE BUG HID ITSELF.
  ▶ MINTY'S RULING S106: LEAVE IT. The release figure records what
    was picked. Changing it would make the record less true.
  ⚠ DO NOT HEAL. DO NOT RE-RAISE.
```

---

## THE FIXTURE — THE STANDING REFERENCE SET

⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW OR THE SCREEN.

```
COMPANY   474 · test260805@ · on DEV

FO-0003-3  testpdt4lvl   formulations.id 3695   batch_qty 5
  fopackaging 5748  Pouch   quantity 1  wgt 0.73   whd 0  Level 1 Pack
  fopackaging 5749  Carton  quantity 4  wgt 2.92   whd 0  Level 1 Pack
  fopackaging 5750  Case    quantity 3  wgt 8.76   whd 0  Level 2 Pack
  fopackaging 5751  Pallet  quantity 7  wgt 61.32  whd 0  Level 3 Pack
  fopackaging 5752  Label   quantity 1  wgt 61.32  whd 1  Level 4 Pack
  batch = 5 pallets = 306.60 Kg
  ⚠ TWO ROWS SHARE "Level 1 Pack". Numbering runs 1,1,2,3,4.
  ⚠ FORKED TWICE. FO-0003 → -2 → -3. Each packing edit forks.
    ▶ EACH FORK RECALCULATED ALL FIVE WEIGHTS CORRECTLY. NOT A GAP.

MO-0002  mlomanagement.id 11810
  qty 2 · received_qty 122.64 · received_units 2 · batches 0.4
  lotCode Pdt-260806-1 · Rec-260806-1
  RELEASED — all six, all correct:
    Ginger Powder 122.640 Kg · Pouch 168 · Carton 42
    Case 14 · Pallet 2 · Label 2
  ⚠ WHY THIS FIXTURE WORKS: ratios 4/3/7/1 are all different and
    NONE equals batch_qty 5. Base weight 0.73 is not round.
  ⚠ PALLET AND LABEL STILL COINCIDE with the broken arithmetic at
    every MO quantity. LEVELS 1-3 ARE THE ONLY DISCRIMINATORS.

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  pouch  quantity 1  wgt 1.39  whd_flag 0
  fopackaging 5733  case   quantity 6  wgt 8.34  whd_flag 1
  batch = 6 cases = 50.04 Kg
  ⚠⚠ THIS FIXTURE CANNOT PROVE A PACKAGING FIX. batch_qty is 6 AND
    there are six pouches per case. USE FO-0003-3 INSTEAD.

MO-0001  mlomanagement.id 11809
  qty 7 · received_qty 58.38 · received_units 7 · batches 1.167
  mprrecievelots 84016 Ginger 58.397 · 84017 Pouch 42 · 84018 Case 7
  MR-0006 id 3359 · MR-0007 id 3360 · MR-0008 id 3361 (units 3)
  ⚠ 7 x 8.34 = 58.379999999999995 IN FLOATING POINT, not 58.38.
    That is why QTY Planned reads long on dev. 30b2ddd4 rounds it.

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  pouch wgt 0.32 whd 0 · case quantity 6 wgt 1.92 whd 1
  ⚠ NO PRODUCTION CYCLE ON IT. → P104 for the S45 intermediate test.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
company                  company_name  ← NOT `name`
fopackaging              formulation_id · material_id ·
                         wgt_kgs_per_unit · quantity · whd_flag ·
                         pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW.
                           Declared BOOLEAN, stored TINYINT.
                           Test truthiness, never === 1.
                         ⚠ quantity = how many of the level BELOW.
                           A PACKING RATIO.
                         ⚠ pack_level IS POPULATED. → P152
mlomanagement            qty · received_qty · received_units ·
                         batches · company_id · formula_id ·
                         mlc_status · close_status · lotCode
                         ⚠ batches IS A STORED double holding the
                           ROUNDED figure.
                         ✓ received_units IS STORED, CORRECT, AND
                           NOW SERVED by WhC_GetMoDetails_SP.
                           Fixed S106 on both boxes.
mlcpackaging             quantity · status · mlc_id · pack_level_id
                         ⚠ ONE ROW PER MO. quantity holds the
                           BATCHES figure; pack_level_id points at
                           the fopackaging SHIPPING-UNIT row.
                         ⚠ NOT A PER-LEVEL REQUIREMENT TABLE. The
                           cascade is computed at READ time and
                           never stored. J5 CONFIRMED, S105.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           MPR_id · qty_allocated · Rec_Lot_id ·
                         material_id   ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id. ⚠ NO UNIT COUNT. → P138
rejectmaterialandproduct ⚠ full column list unchanged since S103.
                         ⚠ `type` returns 'Product'. `status`
                           returns 'Active', NOT a number.
```

---

## THE TWO RELEASE ROUTES — SETTLED S105, PROVEN ON PROD S106

```
INGREDIENTS   recipe quantity per batch × number of batches
              Kg-anchored. The physical release is a weighing.
              ⚠ batches is STORED ROUNDED. Variance ACCEPTED.

PACKAGING     MO quantity × the packing cascade
              Unit-anchored. NO weight at any step.
              ⚠ batches PLAYS NO PART. THEREFORE NO ROUNDING
                VARIANCE on a Planned figure.

⚠ A FRACTIONAL *PLANNED* PACKAGING FIGURE IS A DEFECT.
⚠ A FRACTIONAL *CONSUMED* PACKAGING FIGURE MAY BE HISTORY — what a
  person actually released under the old code. See P140 above.
  ▶ THE DISTINCTION IS NEW IN S106 AND IT MATTERS.
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf on both, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE PROCEDURE <name>\G"
  ⚠ NAME THE DATABASE. ⚠ USE \G, NOT ;.
⚠ ~/.my.cnf IS NOT IN GIT AND NOT BACKED UP. → P119

WhC_GetMoDetails_SP    ⚠ FEEDS Edit-Mlc AND the yield dialog.
  ✓ CHANGED S106, BOTH BOXES. Now selects received_units. → JR17.
  ⚠ 28 lines. ONE select. Eight left outer joins. No branches.
  ⚠ Recreated WITHOUT the definer clause. It was `admin`@`%`.
    JR16: RDS can refuse an explicit definer on recreate.

WhC_GetMoProductReceivingDetails_SP
  Selects receiveproducts.recieved_qty. NO unit count either.
  ⚠ SO THE `2.000#` ON THAT PANEL IS DERIVED ON THE FRONTEND BY
    DIVIDING. → P151.

WhC_GetMoPackagingConfiguration_SP
  Feeds mlcDetails.packagingConfiguration. Carries wgt_kgs_per_unit
  and whd_flag. ⚠ NOT INSPECTED IN FULL.

WhC_GetAllRejectedList_SP — CHANGED S104, BOTH BOXES. → JR16.
  ⚠ WhC_GetAllRejectedList_SP('474','Active') IS THE WORKING CALL.

⚠ db-definitions-S93.txt IS NOW STALE ON THREE OBJECTS:
  JR7e's view, JR16's proc, and now JR17's. → P119.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. Built S101. READ-ONLY.

⚠⚠ IT SILENTLY DROPS COMPUTED COLUMNS AND ALIASES. → P152
  ▶ FOR ANYTHING COMPUTED OR ALIASED, USE THE mysql CLIENT.

  node /home/ubuntu/read-rows.js co 474
  node /home/ubuntu/read-rows.js cols <table>
  node /home/ubuntu/read-rows.js sql "SELECT ..."   ⚠ plain columns

⚠ IT SURVIVES A REBOOT. ⚠ IT IS NOT ON PROD.
⚠ S106 USED THE mysql CLIENT THROUGHOUT AND HAD NO TROUBLE.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. 51e9f4e is on both boxes.
FRONTEND   ⚠⚠ 30b2ddd4 PENDING — PUSHED, NOT BUILT, NOT ON EITHER BOX.
           GITHUB ACTIONS HAD A MAJOR OUTAGE ON 6 AUG — 6h29m and
           still running at S106 close. Run #56 queued at 10:29 and
           NEVER STARTED. A re-run at midday queued too.
           ⚠ NOTHING IS WRONG WITH THE COMMIT. Runs #52-#55 all
             completed in under ten minutes.
           ▶ MINTY'S RULING S106: WAIT FOR GITHUB. No workaround.
           ⚠ WHAT IT FIXES: the Planned box rounding
             (58.379999999999995 → 58.38) on dev, AND prod's header
             labels, which still read QTY Planned(Kg) 802 — a case
             count under a Kg label.
DATABASE   ✓ NOTHING PENDING. Both boxes changed in S106.
DOCS       ⚠ S106's four files pending commit at close.
```

---

## QUEUE

⚠ New items at the bottom with the next free number. Claude never
renumbers. Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod.
P65   promote.sh runs plain scp and ssh with no -4.
      ⚠ NOT RUN IN S106 — no frontend deploy happened.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. FIVE — 466, 469, 470,
      472, 473.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠ PROD 42 UPDATES. Dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST.
      ⚠⚠ S105 PROVED DEV CAN FAIL TO BOOT AND CRASH-LOOP SILENTLY.
      ⚠ MISSED ELEVEN DAYS RUNNING.
P104  No intermediate fixture on dev. S45 UNTESTED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ ONLY P135 REMAINS IN P82. P140 AND P149 BOTH CLOSED.
      ⚠ NEEDS A NEW COLUMN *AND* PROBABLY A PROCEDURE CHANGE.
        JR15 rehearsed the column, JR16 and JR17 the procedure.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
        rejected-materials.component.ts:65
        start-mlc.component.html:361 — commented-out yield button
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ S105 DID IT TWICE and S106 PROVED THE VALUE — the comment
        naming the exact string to restore meant P149's frontend
        needed NO re-derivation at all. It was already right.
      ▶ THE PATTERN WORKS. Keep doing it.
P119  Back up the database's own code into the repo.
      ⚠ ADD ~/.my.cnf's DERIVATION to the rebuild record.
      ⚠ db-definitions-S93.txt NOW STALE ON THREE OBJECTS.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, Waterline attribute
      absent. ⚠ TRAPS 3 LIVE.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ COVERED BY RULES 7. Same family as the S105 header fix.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE ACROBATICS WATCH ITEM (R2). ⚠ IT IS THE LAST P82 ITEM.
      CONTENTS: fix 6 (/Edit-Mlc, needs a backend change first —
      reverted patch at 34e99c3e, READ IT) and six header-view
      divisions: qty_shipped_su · qty_packing_slip_su · qty_do_su
      qty_misc_release_su · intermediate_prd_su · SOH_su
      ⚠ S95 SCOPING: two repointable, three leave, one needs a
        schema change.
      ⚠⚠ S106 STRENGTHENED THE CASE THAT P150 ABSORBS THIS. P149
        was the third time a division existed only because a stored
        count was not served. ▶ ASK THE SURVEY QUESTION FIRST.
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
      ▶ SCOPING SITTING IS S107. MINTY'S RULING S106.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ⚠ RejectMaterialAndProduct.js:51 counts with company_id; the
        callers at :63 and :78 PASS NO ARGUMENT.
      ⚠ MO NUMBERING IS ALREADY PER-COMPANY. THIS IS MRs ONLY.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY THEY
      ARE NOT. ⚠ DO NOT "FIX" THESE LINES.
P142  ⚠ THE EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT. ⚠ P145 IS A PRECONDITION. ⚠ ASK MINTY.
P144  read-rows.js CANNOT PRINT A ROUTINE BODY. ⚠ SUPERSEDED BY P152.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE.
      ⚠ ASK MINTY WHAT "Returned Quantity" MEANS BEFORE READING CODE.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES.
      list 25.020 · details 25.02. ⚠ ASK MINTY. LOW.
P147  NO MATERIAL MR ON DEV. ▶ CREATE ONE. One minute. LOW.
P148  ⚠ WITHDRAWN S105 on a misread. Logged so the withdrawal is on
      the record. ⚠ NARROW RESIDUAL: if one material ever appears at
      TWO packaging levels, release-mat-details:1095 fires and uses
      qty x batches, ignoring the cascade. Cannot fire today. LOW.
P150  ⚠⚠ THE PROCEDURE SURVEY. MINTY'S PROPOSAL, S105.
      Read every stored procedure's SELECT list and ask: does the
      screen it feeds need a unit column, and is it served?
      ▶ PRODUCES A LIST, NOT A REPAIR.
      ⚠ 35 routines and 9 views from the S73-S79 sweep.
      ⚠⚠ THREE CONFIRMED INSTANCES NOW — P143, P149, and every
        division in P135/P151. THE PATTERN IS ESTABLISHED, NOT
        SUSPECTED.
      ▶ S107 STARTS WITH THE P135 SUBSET OF THIS. MEDIUM.
P151  EDIT-MLC DIVIDES A WEIGHT TO GET A COUNT, IN THREE PLACES.
      edit-mlc.component.ts:298 · :354 (getWdu) · html:258
      ⚠ RULES 7 FORBIDS THIS SHAPE.
      ⚠⚠ THE BLOCKER IS GONE. received_units IS NOW SERVED BY
        WhC_GetMoDetails_SP ON BOTH BOXES, and Edit-Mlc is fed by
        that exact procedure. ▶ THESE THREE CAN NOW BE REPOINTED.
      ⚠ IT IS A FRONTEND CHANGE AND THE BUILD IS DOWN.
      ▶ S107, WITH P135. MEDIUM.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
      ▶ EITHER FIX THE READER OR PUT A WARNING IN ITS OWN OUTPUT.
      ⚠ SUPERSEDES P144. MEDIUM — it corrupts evidence.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN.
      ⚠ COST ~130 CRASH RESTARTS ON DEV IN S105.
      ▶ CONSIDER A ONE-LINE GUARD, or a note in RULES 2. ⚠ ASK MINTY.
      LOW.
```

```
NEW IN S106

P154  ⚠ GITHUB ACTIONS CAN STOP FOR MOST OF A DAY AND WE HAVE NO
      SECOND ROUTE TO A FRONTEND BUILD.
      6 Aug 2026: MAJOR OUTAGE, 6h29m and still open at close. Two
      queued runs, neither started. The frontend was UNDEPLOYABLE
      for the whole session.
      ⚠ THE BACKEND AND THE DATABASE WERE UNAFFECTED — both of
        S106's client-facing fixes landed DURING the outage.
      ▶ THE QUESTION FOR MINTY: is a local build path worth having?
        The Mac has the source. ⚠ IT IS NOT FREE — a second build
        route is a second thing that can drift.
      ⚠ ASK MINTY. Do not build it on assumption. LOW-MEDIUM.

P155  ⚠ A COMMIT PUSHED FROM THE MAC DOES NOT UPDATE PROD'S IDEA OF
      origin/main UNTIL SOMETHING FETCHES.
      S106: prod's `git log` showed origin/main at 05f786c while
      GitHub held 51e9f4e. Not a fault — just stale. But it means a
      `git log` on prod CANNOT be used to check what is on GitHub.
      ▶ `git fetch origin` FIRST, ALWAYS, before reading origin/main.
      LOW. Logged because it looked alarming for a moment.
```

```
✓ CLOSED IN S106 — DELETE THESE LINES AT S107 CLOSE

P140  ✓ DONE. Backend cascade fix on BOTH boxes, screen-proven on
      prod. The -0.08 residue is RULED: leave it.
P141  ✓ DONE S103. (Was already marked for deletion at S106 close.)
P143  ✓ DONE S104, BOTH BOXES. (Same.)
P149  ✓ DONE S106, BOTH BOXES, SCREEN-PROVEN ON DEV. → JR17.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Deleting MOs risks orphaning lot codes.
⚠ NOTHING WAS CREATED OR DELETED ON DEV IN S106. Only the procedure
  changed.

company 474 — ⚠ DELIBERATE, KEEP ALL OF IT
  testpdt4lvl  FO-0003 → FO-0003-2 → FO-0003-3  (two forks)
  MO-0002 (id 11810) · full cycle: released, produced, received
  Six materials released against it, including four packaging levels
  ⚠ THIS IS THE ONLY FIXTURE THAT CAN PROVE A PACKAGING CASCADE.
    DO NOT DELETE.
  ⚠ Materials MAT-4 Carton, MAT-5 Pallet, MAT-6 Label were created
    for it.

company 464 — CORRUPTED PLANNED QUANTITIES, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/9/10/11 10.008 · MO-0013 1750.08
  ⚠ Residue from before the S93 fix. NOT a live defect.
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
  ⚠ test0.7 fixture set from S97 (FO-0009, MO-0015/16, SO-0014)

⚠ 50.04 IS NOT 50.004. FO-0001's batch really is 6 × 8.34 = 50.04.
```

---

## PROD FIXTURE

```
⚠ test260703@ IS A SANDBOX COMPANY ON PROD, NOT GLUTENULL.
  FOUR MR ROWS, all pre-dating the S103 column:
    MR-0004 product 20.000 Kg · MR-0003 product 80.000 Kg
    MR-0002 MATERIAL 1.000 Kg ⚠ NO UNIT COUNT, BY DESIGN
    MR-0001 product 20.000 Kg
  ▶ USE IT FOR PROD SCREEN CHECKS. No client data is touched.
  ⚠ IT IS THE ONLY MATERIAL MR EITHER BOX HAS. DO NOT DELETE.

⚠ GLUTENULL (471) STILL HAS ZERO MR ROWS.

⚠ GLUTENULL PRODUCTS SEEN IN S106 — the first real look at client
  data this campaign. FOR REFERENCE ONLY, NOTHING WAS CHANGED:
    FO-0019 Fruits & Nut Breakfast Bars · Clamshell320 · 1750 planned
    FO-0022 Buckwheat Granola Bar        · Clamshell240 ·  802 planned
  ⚠ BOTH ARE MULTI-INGREDIENT REAL RECIPES — 10 and 16 lines.
  ⚠ THEIR HEADER BOXES STILL READ (Kg) OVER A CASE COUNT. That is
    the frontend gap and it is what 30b2ddd4 fixes.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

```
DEV    /tmp/build-modetails-S106.js            gone on reboot, ignore
       ~/fix-modetails-S106.sql                keep until S107 close
       ~/WhC_GetMoDetails_SP.*-S106-DEV.txt    KEEP BOTH. Rollback.
       ~/MLOManagement.js.bak-S105-P140        delete — P140 is closed
       ~/MLOManagement.js.bak-S105-P140-attempt2   keep, it is live
PROD   /tmp/build-modetails-S106.js            gone on reboot, ignore
       ~/fix-modetails-S106.sql                keep until S107 close
       ~/WhC_GetMoDetails_SP.*-S106-PROD.txt   KEEP BOTH. Rollback.
MAC    ~/Downloads/patch-P140-headers-fix.py   delete after 30b2ddd4
                                               finally deploys
       ~/check-mat-yield.component.*.bak-S105-P140*   keep for now
⚠ RULES 6: tidy at the close and ONLY at the close.
⚠ DO NOT DELETE THE S106 .bak FILES. They are the only rollback for
  a procedure change on a LIVE CLIENT DATABASE.
```
