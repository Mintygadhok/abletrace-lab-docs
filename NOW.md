# NOW

Last rewritten: S104, 5 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

⚠ S104 CHANGED BOTH BOXES — a DATABASE OBJECT and the FRONTEND.
  Everything below was verified at the row, on the box, or on the
  screen before close. Nothing is recorded from memory.

---

## STATE

⚠ READ OFF BOTH BOXES AT S104 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺130 · 200
          frontend SERVING dev-0ad1f77cee1d
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 05f786c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ⚠ ↺ DID NOT MOVE IN S104. Held at 130. This session changed
            a database object and the frontend. SAILS WAS NEVER
            RESTARTED AND NEVER NEEDED TO BE.

PROD      15.157.38.101 · pm2 abletrace-backend ↺338 · 200
          Glutenull live · SERVING prod-0ad1f77cee1d
          backend HEAD 05f786c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 43 updates pending · restart required → P102
          ⚠ ↺ DID NOT MOVE IN S104. Held at 338.

✓ BACKENDS MATCH.  05f786c on both. UNTOUCHED THIS SESSION.
✓ FRONTENDS MATCH. 0ad1f77cee1d on both.
✓ DATABASES MATCH. qty_rejected_units on both (JR15, S103) AND
                   WhC_GetAllRejectedList_SP returns it on both
                   (JR16, S104).

GITHUB    frontend main = 0ad1f77c (P143 brackets)
          backend  main = 05f786c  (unchanged since S103)
          docs     main = eab4b59  (JR16)

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-0ad1f77cee1d
          prod  /home/ubuntu/www-html.bak-prod-0ad1f77cee1d
          ⚠ BOTH HOLD 125014a3ab26 — a backup dir holds the build it
            REPLACED, not the one it is named after.
          ⚠ READ OFF BOTH BOXES AT CLOSE, not written from the label.

          PROCEDURE BACKUPS, S104, before the change — KEEP THESE:
            dev  /home/ubuntu/WhC_GetAllRejectedList_SP.bak-S104-DEV.txt
            prod /home/ubuntu/WhC_GetAllRejectedList_SP.bak-S104-PROD.txt
          Both 3414 bytes. Both verified by grep, not by file size.
          ⚠ THEY ARE `SHOW CREATE` TEXT, NOT RUNNABLE SCRIPTS. To
            restore, take the body and add the DELIMITER $$ wrapper.

          COLUMN BACKUPS, S103 — still on the boxes:
            dev  /home/ubuntu/rejectmaterialandproduct-before-S103.sql
            prod /home/ubuntu/rejectmaterialandproduct-before-S103-PROD.sql

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small

COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ 474 = test260805@ ON DEV. THE CLEAN REFERENCE SET.
          ⚠ test260703@ IS A SANDBOX COMPANY ON PROD and it carries
            FOUR MR ROWS including a MATERIAL one. S104 gated the
            prod screen there. ▶ USE IT INSTEAD OF GLUTENULL for any
            prod screen check. NO CLIENT DATA IS TOUCHED.
          ⚠ dev also carries 466, 469, 470, 472, 473 — unaccounted.
            → P100 IS BIGGER THAN RECORDED. Five, not two.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name backwards.
          Plus the dormant `abletrace` archive (P101, P109).
          ⚠ THE ARCHIVE HOLDS ITS OWN COPY OF EVERY PROCEDURE AND IS
            NOT MAINTAINED. NAME THE DATABASE ON EVERY mysql CALL.
            A bare `mysql` lands in the wrong one.
          → P134

⚠ PROD IS REACHED FROM THE MAC — OR RUN LOCALLY ON A PROD TERMINAL.
  NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY PROD BLOCK. Prod must
    report 172.31.3.156.
```

---

## P143 — ⚠ DONE. BOTH BOXES. VERIFIED ON SCREEN.

```
THE JOB: the MR unit count was stored (S103) and displayed nowhere.

⚠ THE SIZING QUESTION FROM S103 IS ANSWERED, AND IT WAS THE
  EXPENSIVE ANSWER. WhC_GetAllRejectedList_SP NAMES ITS COLUMNS ONE
  BY ONE. qty_rejected_units was not among them. The screen could not
  display what it never received.

⚠⚠ AND BOTH SCREENS DEPEND ON THAT ONE PROCEDURE.
   PLAN treated the list and the details screen as two independent
   pieces of work. THEY ARE ONE PIECE WITH TWO FACES:
     edit-reject-product FETCHES NOTHING. It subscribes to a
     BehaviorSubject in warehouse.service.ts. The only live caller of
     changeEditRejectProd is rejected-materials.component.ts:84,
     which hands over the row the LIST already had.
   ▶ THERE WAS NEVER A FRONTEND-ONLY VERSION OF THIS JOB.

THE FIX, IN FOUR PIECES — ALL BUILT, ALL ON BOTH BOXES

1  THE PROCEDURE — qty_rejected_units added to the SELECT list,
   immediately after qty_rejected. NOTHING ELSE CHANGED. Same 11
   joins, same WHERE, same ORDER BY. → JR16.
   Applied dev then prod, each read back out of its own database.

2  rejected-materials.component.html:63 — the list cell.
   f92dc0ec, brackets in 0ad1f77c.
   ⚠ GATED ON element.type === 'Product'. BOTH brackets carry their
     own gate so a material row cannot pick up a stray ")".

3  edit-reject-product.component.html:25 — Quantity changed from a
   NUMBER input to READ-ONLY TEXT. It now holds a formatted string.
   f92dc0ec.

4  edit-reject-product.component.ts — qty patched as
     result.qty_rejected_units + '# (' + result.qty_rejected + ' Kg)'
   with a THREE-LINE COMMENT IN THE CODE saying why (→ P118).
   f92dc0ec.

⚠ WHY 3 AND 4 ARE SAFE: the save handler at line 123 writes
  qty_rejected from the `returnedqty` control, NOT from `qty`. The
  formatted string is never written back.
  ⚠ THAT IS LUCK, NOT DESIGN. `readonly` was added as a second
    guard. IF P142 IS EVER ACTIONED, RE-READ THIS FIRST.

GATED ON DEV, company 474 — SEEN ON SCREEN:
  list     MR-0008  3# (25.020 Kg)
           MR-0007  0# (16.680 Kg)
  details  MR-0008  Quantity(kgs) = 3# (25.02 Kg)

GATED ON PROD, company test260703@ — SEEN ON SCREEN:
  MR-0004  0# (20.000 Kg)   product, pre-column row
  MR-0003  0# (80.000 Kg)   product, pre-column row
  MR-0002  1.000 Kg         ⚠⚠ MATERIAL — NO # FIGURE AT ALL
  MR-0001  0# (20.000 Kg)   product, pre-column row

⚠⚠ MR-0002 IS THE PROOF THE TYPE GATE FIRES CORRECTLY. Dev could
   not provide it — 474 holds no material MR. Prod's sandbox did.
   A material row sitting between product rows in the SAME table,
   showing weight alone. THE GATE IS LOAD-BEARING AND IT WORKS.

⚠ 0# IS CORRECT ON PRE-COLUMN ROWS. Minty's ruling: no fallback, no
  division, show the stored value as-is. Those rows have no count.

RE-READ AFTER THE DEV DEPLOY — NOTHING MOVED:
  3361 · 25.02 · 3   3360 · 16.68 · 0   3359 · 1.39 · 0
  ▶ THE SCREENS ARE READS AND THEY BEHAVED LIKE READS.

⚠ NOTHING WAS WRITTEN ON EITHER BOX IN S104. No rows created, no
  rows edited. A procedure and three template files, nothing else.
```

### ⚠ ONE THING LEFT OPEN

```
THE TWO SCREENS DISAGREE ON DECIMAL PLACES.
  list     3# (25.020 Kg)   — applies toFixed(decimalPlaces)
  details  3# (25.02 Kg)    — prints the stored value raw
Both honest. Neither wrong. NOT RULED ON. → P146
```

---

## THE FIXTURE — THE STANDING REFERENCE SET

⚠ EVERY FIGURE BELOW WAS READ FROM THE ROW OR THE SCREEN.
⚠ USE THIS INSTEAD OF COMPANY 464. It is clean; 464 is not.
⚠ NOTHING HERE IS 1:1. TRAPS 9 is satisfied by construction.

```
COMPANY   474 · test260805@ · on DEV

FO-0001  testpdt1.39   formulations.id 3690   batch_qty 6
  fopackaging 5732  material_id 8120  pouch  quantity 1  wgt 1.39
                    whd_flag 0
  fopackaging 5733  material_id 8121  case   quantity 6  wgt 8.34
                    whd_flag 1  ← THE ANCHOR
  batch = 6 cases = 50.04 Kg
  ⚠ NOT FORKED. Original version. The control.

⚠ WHAT `quantity` MEANS ON THESE ROWS (confirmed S102).
  The CASE row's quantity=6 means SIX POUCHES PER CASE. A PACKING
  RATIO, not a batch figure. 6 × 1.39 = 8.34 EXACTLY.
  ⚠ DO NOT READ IT AS "6 cases per batch".

FO-0002-2  testpdt0.32  formulations.id 3692  batch_qty 40
  fopackaging 5736  pouch  quantity 1  wgt 0.32  whd_flag 0
  fopackaging 5737  case   quantity 6  wgt 1.92  whd_flag 1
  batch = 40 cases = 76.8 Kg
  ⚠ FORKED ONCE from FO-0002 (id 3691, status_id 2). Clean fork.
  ⚠ NOT A TEST OF S45 — that bug is about INTERMEDIATES. This used
    a Sub Recipe. S45 REMAINS UNTESTED. → P104

THE CYCLE THAT WAS RUN, all on FO-0001
  MO-0001   mlomanagement.id 11809
            qty 7 · received_qty 58.38 · received_units 7
            batches 1.167 (STORED)
            lotCode Pdt-260804-1 · Rec-260804-1
  MPR       materialsproductsreleased.id 11602  (HEADER ONLY)
    mprrecievelots 84016  material 8119  qty_allocated 58.397
    mprrecievelots 84017  material 8120  qty_allocated 42   ✓ pouches
    mprrecievelots 84018  material 8121  qty_allocated 7    ✓ cases
  SO-0001   somanagement.id 2515
    soproducts 6920  quantity 33.36  FO-0001    (4 cases)
    soproducts 6919  quantity 7.68   FO-0002-2  (4 cases)
  DO-0001 · PS-0001 · shipped 1# (8.34 Kg)
  MR-0006   id 3359  qty_rejected 1.39   units 0 — before the fix
  MR-0007   id 3360  qty_rejected 16.68  units 0 — THE BEFORE-ROW
  MR-0008   id 3361  qty_rejected 25.02  units 3 — ⚠ THE AFTER-ROW

⚠ ALL THREE MR ROWS IN 474 ARE type='Product'. THERE IS NO MATERIAL
  MR ON DEV. That is why S104's type gate had to be proven on prod's
  sandbox instead. ▶ MAKING ONE ON DEV IS STILL WORTH DOING. → P147

⚠ THE `status` COLUMN HOLDS THE WORD `Active`, NOT 1.
  ⚠ S104 CALLED THE PROCEDURE WITH '1' AND GOT AN EMPTY RESULT THAT
    LOOKED EXACTLY LIKE A BROKEN PROCEDURE.
  ▶ WhC_GetAllRejectedList_SP('474','Active') IS THE WORKING CALL.

⚠ MR-0008 SHIFTS THE TRACEABILITY ARITHMETIC. 3 more cases are now
  released against MO-0001. Anyone re-reading the old 7 − 1 − 2 = 4
  line will not reconcile. RE-READ THE SCREEN.
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
company                  company_name  ← NOT `name`
                         also address (J108), food_safety_enabled
fopackaging              formulation_id · material_id ·
                         wgt_kgs_per_unit · quantity · whd_flag ·
                         pack_level
                         ⚠ whd_flag=1 IS THE SHIPPING UNIT ROW
                         ⚠ quantity ON THE CASE ROW = pouches per
                           case. A PACKING RATIO.
mlomanagement            qty · received_qty · received_units ·
                         batches · company_id · formula_id ·
                         mlc_status · close_status · lotCode
                         ⚠ batches IS A STORED double and holds the
                           ROUNDED figure. NOT display-only.
formulations             company_id · batch_qty · inventory ·
                         inventory_units · SOH_actual · status_id
materialsproductsreleased  HEADER ONLY. No quantities at all.
mprrecievelots           THE CHILD. MPR_id · qty_allocated ·
                         Rec_Lot_id · material_id
                         ⚠ Capital MPR_id.
soproducts               quantity (KG) · SO_id · formula_id
                         ⚠ NO company_id COLUMN.
                         ⚠ NO UNIT COUNT STORED. → P138
rejectmaterialandproduct createdAt · updatedAt · id · internalCode ·
                         type · qty_rejected (KG) · remarks_reasons ·
                         disposition · disposition_authorized_by ·
                         status · user_id · company_id · material_id ·
                         recievedlot_id · formula_id ·
                         receiveProduct_id · mlc_id ·
                         qty_rejected_units  ⚠ JR15, S103
                         ⚠ FULL COLUMN LIST, read off the box S103.
                         ⚠ `type` RETURNS THE LITERAL WORD 'Product'.
                         ⚠ `status` RETURNS 'Active', NOT A NUMBER.
```

---

## DATABASE OBJECTS — WHAT S104 LEARNED ABOUT READING THEM

```
⚠ DEV CAN READ ROUTINE BODIES NOW. It always could — it was missing
  a credentials file, not a tool.
    /usr/bin/mysql was installed the whole time.
    /home/ubuntu/.my.cnf built in S104 from .env, chmod 600.
  ▶ mysql abletracelab_live -e "SHOW CREATE PROCEDURE <name>\G"
  ⚠ NAME THE DATABASE. ⚠ USE \G, NOT ; — a table render truncates.

⚠ ~/.my.cnf NOW EXISTS ON BOTH BOXES. NOT IN GIT, NOT BACKED UP.
  A box rebuild loses it. The rebuild step is: parse DATABASE_URL
  out of .env and write host/port/user/password/database. → P119

WhC_GetAllRejectedList_SP — CHANGED S104, BOTH BOXES. → JR16.
  Takes (companyId VARCHAR, statusVal VARCHAR).
  14 columns off rejectmaterialandproduct (13 before S104), plus
  joined titles, and ELEVEN left outer joins.
  ⚠ ELEVEN, NOT TWELVE. Confirmed by diff against the backup.
  ⚠ IT ALREADY RETURNED fopackaging.wgt_kgs_per_unit BEFORE S104.
    The ingredients for an R2 division are being served to this
    screen. NOT A DEFECT. Worth knowing. → P135
  ⚠ THE OBJECT WAS IDENTICAL ON BOTH BOXES — CONFIRMED by reading
    both, not assumed. DO NOT ASSUME IT FOR THE NEXT OBJECT.
```

---

## THE ROW READER

```
/home/ubuntu/read-rows.js on DEV. Built S101.
Reads .env itself. Driver is node_modules/mysql (NOT mysql2).
READ-ONLY — refuses anything that is not SELECT/SHOW/DESCRIBE.
PRINTS THE DATABASE NAME EVERY RUN (P134).

  node /home/ubuntu/read-rows.js co 474
  node /home/ubuntu/read-rows.js cols rejectmaterialandproduct
  node /home/ubuntu/read-rows.js sql "SELECT ..."

⚠ IT STILL CANNOT PRINT A ROUTINE BODY. Unchanged, and now
  IRRELEVANT — use the mysql client for routines. → P144, LOW.
⚠ IT SURVIVES A REBOOT (not in /tmp).
⚠ IT IS NOT ON PROD. Prod uses mysql directly.
```

---

## P82 — WHERE IT STANDS AFTER S104

⚠ MINTY'S RULING S101: EVERYTHING QUANTITY-RELATED STAYS UNDER P82.
⚠ ARITHMETIC CLOSED. STORAGE CLOSED. DISPLAY IS NEARLY CLOSED.

```
R2  ACROBATICS. ▶ MEASURED CLEAN S101 against a non-1:1 fixture.
    Still present, still low priority. → P135
R3  ROUND-TRIP. ▶ MEASURED, RULED ON, CLOSED S102.
P82c STORAGE. ▶ DONE S103, both boxes.
P143 DISPLAY.  ▶ DONE S104, both boxes, gated on screen.
▶ WHAT REMAINS UNDER P82: P135 (the watch item, low) and P140
  (the yield screen). NOTHING ELSE.
```

### DONE, all on PROD, all verified on screen

```
fix 1  SOManagement.js:182-206              2ae869c   (S98)
fix 2  admin-formulation.component.ts:878   a52e4bfc  (S98)
fix 3  add-mlo.component.html:87            b8e7248b  (S98)
fix 4  closed-mlcs.component.html:79/84     824e0e6d  (S98)
fix 5  edit-closed-mlcs.component.ts:126/136 770d3c4f (S99)
fix 7  product-traceability.component.ts:109,161
                                            f53986ca  (S100)
P82c   column + attribute + create write    05f786c / 125014a3 (S103)
P143   proc + both screens        JR16 / f92dc0ec / 0ad1f77c (S104)
CLOSED S100: P82e no defect · P82f absorbed · P82g stale
CLOSED S102: R3 packaging — NO DEFECT · R3 ingredients — ACCEPTED
CLOSED S103: P82c storage — DONE, both boxes
CLOSED S104: P143 display — DONE, both boxes, type gate PROVEN
```

⚠ FIX 7 LINE 161 IS STILL NOT PROVEN ON SCREEN. The lot-code search
  table has NO Completed Qty column. Deployed and safe, unproven.
  UNCHANGED SINCE S100. Do not record it as resolved.

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending. Both on 05f786c.
FRONTEND   nothing pending. Both on 0ad1f77cee1d.
DATABASE   nothing pending. Column AND procedure on both.
DOCS       nothing pending. main = eab4b59.
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
      ⚠ ALSO packing slip, Closed MOs Excel, Closed MOs screen.
P65   promote.sh runs plain scp and ssh with no -4.
      ⚠ RAN CLEAN THREE TIMES IN S104. LOW.
P66   3B.4 rollback points stale. ▶ DELETE them.
      ⚠ STILL SAYS 275c025039d7. THREE DEPLOYS STALER AFTER S104.
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
      ⚠ PROD 43 UPDATES. Dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1 THROUGH 9 AUG. NINE DAYS RUNNING. RESCHEDULE.
P104  No intermediate fixture on dev. 474 has none. S45 UNTESTED.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
      ⚠ Section_5.md IS NOW 3451 LINES. The queue recorded 2770 as
        recently as S103. IT HAS GROWN 680 LINES AND THE NOTE SAYING
        IT IS TOO BIG IS ITSELF OUT OF DATE.
      ⚠ TWO JR ENTRIES IN TWO SESSIONS (JR15, JR16). The block that
        is the only record of what is not in git keeps growing, and
        it is buried inside session history.
      ▶ PROMOTED AGAIN. It protects the rebuild path.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
      ⚠ IT IS A LIVE HAZARD, NOT CLUTTER — every mysql call now has
        to name the database explicitly to avoid landing in it.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ MINTY S101: STARTS AFTER P82 CLOSES.
      ⚠ ONLY P135 AND P140 REMAIN IN P82.
      ⚠ IT NEEDS A NEW COLUMN *AND* PROBABLY A PROCEDURE CHANGE.
        S103 REHEARSED THE COLUMN (JR15). S104 REHEARSED THE
        PROCEDURE (JR16). ▶ BOTH SEQUENCES ARE WRITTEN DOWN NOW.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 · closed-so.component.ts:165
        edit-mlc:295 · edit-mlo:245 · start-mlc:151
        add-dispatch.component.ts:72
      ⚠ ADD: rejected-materials.component.ts:65 — a commented-out
        changeEditRejectProd call beside the live one at :84.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ S104 DID IT ONCE — a three-line comment on the P143 patch in
        edit-reject-product.component.ts explaining why `qty` holds a
        string. ▶ THE PATTERN WORKS. Keep doing it.
      ⚠ P142's commented-out button block still has no note.
P119  Back up the database's own code into the repo.
      ⚠ ADD ~/.my.cnf's DERIVATION to the rebuild record. The file
        must never be committed; the method must be.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
      ⚠ THIS IS TRAPS 3 LIVE, TODAY. S103 proved the fix shape.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
      ⚠ SAME FAMILY AS P82 R3-d. Consider fixing together.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ THE ACROBATICS WATCH ITEM (R2). LOW PRIORITY.
      ▶ MEASURED CLEAN S101 against a non-1:1 fixture.
      CONTENTS: fix 6 (/Edit-Mlc, needs a backend change first —
      reverted patch is in history at 34e99c3e, READ IT rather
      than rewriting) and six header-view divisions:
        qty_shipped_su · qty_packing_slip_su · qty_do_su
        qty_misc_release_su · intermediate_prd_su · SOH_su
      ⚠ P82c AND P143 HAVE FULLY UNBLOCKED qty_misc_release_su.
        There is a stored column AND a proc that returns it.
      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS. Pre-existing.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY.
      ⚠ CAUSE FOUND S102 — DO NOT RE-INVESTIGATE.
        RejectMaterialAndProduct.js:51 counts with company_id, but
        the callers at :63 and :78 PASS NO ARGUMENT.
      ▶ ONE-LINE FIX. ⚠ ASK MINTY FIRST — renumbering changes how
        MRs read to a client. Business question, not a tidy-up.
P138  soproducts STORES NO UNIT COUNT — Kg only. R2 by construction.
      ⚠ READS CORRECTLY TODAY. Logged, not scheduled.
P139  ⚠ add-mlo:150 AND :228 LOOK LIKE DEFECTS AND THE ROWS SAY THEY
      ARE NOT. ▶ THE REAL PACKAGING WRITE PATH WAS NOT FOUND.
      ⚠ DO NOT "FIX" THESE LINES. The output is correct. LOW.
P140  THE YIELD SCREEN IS WRONG ON ITS OWN.
      ⚠⚠ NOT REACHED IN S103. NOT REACHED IN S104. THE SPEC HAS BEEN
        CARRIED FORWARD TWICE, UNTOUCHED, BOTH TIMES DISPLACED BY
        P143.
      ⚠ MINTY ASKED FOR IT EXPLICITLY AT S103 CLOSE: "carry over the
        yield actions into next session so we dont loose focus on
        that". ▶ IT GOES FIRST IN S105. P143 IS NO LONGER THERE TO
        DISPLACE IT.
      S101 blamed the numbers beneath it. S102 measured those and
      they are RIGHT (42 and 7). So the screen COMPUTES rather than
      READS. A different bug from the one recorded, possibly smaller.
      ⚠ NOT ACTIVATED FOR GLUTENULL. No client exposure.
      ⚠ NO HEAL EVER NEEDED — a display fault corrects itself.
      MEDIUM. It reports a discrepancy that did not occur.
P141  SECTION 5's HEADER. ✓ DONE S103. ⚠ DELETE THIS LINE AT S105
      CLOSE — it has served its one session.
P142  ⚠ THE EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE
      COMMENTED OUT, WITH NO NOTE SAYING WHY.
      edit-reject-product.component.html lines 49-56.
      ⚠ S104 CHANGED WHAT RE-ENABLING WOULD DO. `qty` now holds a
        FORMATTED STRING. A save could write that string back, or
        write returnedqty over the released quantity, or both.
        ▶ `readonly` WAS ADDED AS A GUARD. IT IS NOT A FIX.
      ⚠ P145 IS A PRECONDITION OF THIS, NOT A FOLLOW-UP.
      ▶ ⚠ ASK MINTY — should MR editing be restored at all?
      MEDIUM. Nothing is wrong today. It is wrong the moment
      someone tidies it.
P143  ⚠ THE MR UNIT COUNT DISPLAY. ✓ DONE S104. BOTH BOXES. GATED ON
      SCREEN ON BOTH, INCLUDING THE TYPE GATE PROVEN NEGATIVE ON A
      REAL MATERIAL ROW.
      ⚠ KEPT AS A CLOSED ITEM FOR ONE SESSION. Delete at S105 close.
P144  read-rows.js CANNOT PRINT A ROUTINE BODY.
      ⚠ THE S103 BLOCKAGE IS GONE. Cause found S104: dev had no
        ~/.my.cnf. The mysql client was installed all along.
      ▶ THE READER ITSELF IS STILL BLIND. Nothing depends on it.
      LOW.
```

```
NEW IN S104

P145  ⚠ /Edit-reject-product SHOWS THE SAME NUMBER TWICE, UNDER TWO
      DIFFERENT LABELS. "Quantity(kgs)" (line 24) and "Returned
      Quantity(kgs)" (line 46) are BOTH patched from
      result.qty_rejected.
      ⚠ AND THE SAVE HANDLER AT :123 WRITES qty_rejected FROM
        returnedqty. So the "Returned" box is the one that would
        overwrite the released quantity.
      ▶ WHAT SHOULD "Returned Quantity" MEAN? A DOMAIN QUESTION.
        ⚠ ASK MINTY BEFORE READING ANY CODE.
      ⚠ HARMLESS TODAY — the screen is read-only (P142).
      ⚠ BECOMES A DATA-CORRUPTION RISK IF P142 IS ACTIONED FIRST.
      MEDIUM.

P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES.
      list     3# (25.020 Kg)  — toFixed(decimalPlaces)
      details  3# (25.02 Kg)   — the stored value, raw
      ▶ Both honest. ⚠ ASK MINTY whether they should match.
      A screen question, not a technical one. LOW.

P147  NO MATERIAL MR ON DEV. Company 474 holds three product MRs and
      no material one, so S104 could not prove the type gate
      negative on dev and had to use prod's sandbox company.
      ▶ CREATE ONE. It costs a minute and completes the fixture.
      LOW.
```

---

## DEV FIXTURE RESIDUE

```
⚠ COMPANY 474 IS THE REFERENCE SET. 464 IS RESIDUE.
⚠ THE OLD ROWS STAY. Not deleted, just not used. Deleting MOs risks
  orphaning lot codes, receipts and traceability links.

⚠ NOTHING WAS CREATED ON EITHER BOX IN S104.

company 474 — ⚠ DELIBERATE, KEEP IT
  MR-0008 (id 3361) qty_rejected 25.02 · qty_rejected_units 3
  ⚠ THE P82c PROOF ROW AND THE P143 PROOF ROW. Do not delete.
  ⚠ It changes MO-0001's release arithmetic. See the fixture block.

company 464 — CORRUPTED PLANNED QUANTITIES, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/9/10/11 10.008 · MO-0013 1750.08
  ⚠ Residue from before the S93 fix. DO NOT read as a live defect.
  ⚠ MO-0019 exists on dev and was never recorded. Harmless.
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
  ⚠ test0.7 fixture set from S97 (FO-0009, MO-0015/16, SO-0014)

⚠ 50.04 IS NOT 50.004. FO-0001's batch really is 6 × 8.34 = 50.04.
  Coincidence of digits with the old corruption. DO NOT CONFUSE.
```

---

## PROD FIXTURE — NEW RECORD, S104

```
⚠ test260703@ IS A SANDBOX COMPANY ON PROD, NOT GLUTENULL.
  It carries FOUR MR ROWS, all pre-dating the S103 column:
    MR-0004  product  20.000 Kg   units 0
    MR-0003  product  80.000 Kg   units 0
    MR-0002  MATERIAL  1.000 Kg   ⚠ NO UNIT COUNT, BY DESIGN
    MR-0001  product  20.000 Kg   units 0
  ▶ USE IT FOR PROD SCREEN CHECKS. No client data is touched.
  ⚠ IT IS THE ONLY MATERIAL MR EITHER BOX HAS. It is what proved
    P143's type gate. DO NOT DELETE IT.

⚠ GLUTENULL (471) STILL HAS ZERO MR ROWS. Unchanged. Nothing was
  created for it in S103 or S104.
```
