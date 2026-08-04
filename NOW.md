# NOW

Last rewritten: S100, 3 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

---

## STATE

⚠ MEASURED AT CLOSE OF S100, both boxes, not from memory.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺129 · 200
          frontend SERVING dev-f53986ca39e9
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 2ae869c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ STILL 129. Held two sessions.

PROD      15.157.38.101 · pm2 abletrace-backend ↺337 · 200
          Glutenull live · SERVING prod-f53986ca39e9
          backend HEAD 2ae869c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 29 updates pending · restart required

✓ BACKENDS MATCH.  2ae869c on both.
✓ FRONTENDS MATCH. f53986ca on both. THE GAP IS CLOSED.

⚠ THE DATABASES DO NOT MATCH. See DATABASES below.

GITHUB    frontend main = f53986ca (P82 fix 7)

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-f53986ca39e9
          prod  /home/ubuntu/www-html.bak-prod-f53986ca39e9
          ⚠ A backup dir holds the build it REPLACED.

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
          ⚠ SEPARATE GROUPS. Both boxes KEY-ONLY.

CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small
COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100
          ⚠ 260804 TO BE CREATED IN S101. See JOB A.

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — DEAD, name is
          backwards from the truth. Plus the dormant `abletrace`
          archive (P101, P109).
          ⚠ A query against the wrong one RETURNS ROWS, not an
            error. → P134

✓ THE BOXES MATCH AT THE DATABASE LAYER.
   Trace_ProductHeaderView on BOTH boxes has qty_produced_su
   repointed to mm.received_units. Six divisions remain on each.
   ⚠ APPLIED TO PROD TOO, late in S100, on Minty's ruling:
     "I will be more comfortable if both dev and prod are same
      in all respects."
   ▶ PROD'S DEFINITION WAS READ FIRST and matched dev's
     pre-change shape EXACTLY — 5756 bytes, 7 divisions, same
     target line. The boxes were identical before the change.
   ▶ ROLLBACK, prod: /home/ubuntu/phv-prod-before-repoint-S100.sql
     ⚠ NOT in /tmp. It survives a reboot. Recreate the view
       from that file to undo.
   ▶ Dev's pre-change copy was /tmp/phv-dev-before-repoint.sql
     and will NOT survive a reboot. Prod's file is the record.
```

---

## DONE IN S100

```
PROMOTED TO PROD — the five-commit backlog, cleared
  a52e4bfc  Products list stock on hand
  b8e7248b  Add-MLO warehouse stock
  824e0e6d  Closed MOs planned/completed qty + Excel
  9b9cf05d  Closed-SOs status dot
  770d3c4f  P82 fix 5
  Built from 2e22e0a1, served as prod-2e22e0a1841c.
  ✓ VERIFIED ON PROD, as Glutenull:
      Products list  FO-0019 1750# (560 Kg)  · 0.320 Kg/unit ✓
                     FO-0022  802# (192.48 Kg) · 0.240 Kg/unit ✓
      ⚠ Closed SOs and Closed MOs COULD NOT BE CHECKED as
        Glutenull — it has NO sales orders and NO closed MOs.
        Checked instead on prod company 464 (testpdt260703).
      Closed MOs (464)  MO-0001 planned 10#(200 Kg)
                                 completed 20#(400 Kg) ✓
      Edit Closed MO    Shipping Units 10# (200 Ea) ( 20 ) ✓

PROMOTED TO PROD — fix 7
  f53986ca  P82 fix 7. product-traceability.component.ts
            lines 109 AND 161 now read item.received_units.
            Served as prod-f53986ca39e9 on both boxes.
  ✓ GATES PROVEN SEPARATELY BEFORE PATCHING:
      line 109  route GetMLCsByFormulaId → Trace_ProductProdLotView,
                which SELECTS mm.received_units twice (as
                received_qty_su and as received_units). View read
                from the box.
      line 161  route GetMLCByInternalCode → Traceability.js:384,
                a plain MLOManagement.find() with populates.
                A Waterline find returns every declared attribute.
  ✓ VERIFIED dev: /Product-traceability test1.39 MO-0007
      Completed 51# (70.89 Kg) — unchanged, before and after.
      Details Qty Produced 51# (70.89 Kg), SOH 41# (56.99 Kg).
  ✓ VERIFIED prod company 464: MO-0004 1#(20 Kg)/1#(20 Kg),
      MO-0003 1#(20 Kg)/2#(40 Kg). Nothing blank, nothing zero.
  ⚠ LINE 161's FIELD IS NOT DISPLAYED on the lot-code search
    screen — that table has no Completed Qty column. The route
    renders and nothing broke, but the patched value could not
    be seen. Deployed and safe, NOT proven on screen.
  ⚠ NO NUMBER CHANGED ANYWHERE. That was the pass condition.
    The proof of the fix is the code and the gate, not the screen.
    The screen proves only that nothing broke.

DATABASE — DEV ONLY
  Trace_ProductHeaderView · qty_produced_su repointed
    FROM (mm.received_qty / fop.wgt_kgs_per_unit)
    TO    mm.received_units
  Divisions 7 → 6. The other six untouched.
  ✓ VERIFIED by row: MO-0007 qty_produced_su 51, SOH_su 41,
    SOH 56.99 — identical to before.
  ✓ VERIFIED on screen, dev details page, unchanged.
  ✓ THEN APPLIED TO PROD, same session, after Minty's ruling
    that the boxes must match. Prod's definition was READ FIRST
    and was byte-identical to dev's pre-change copy.
  ✓ VERIFIED BY ROW on prod, before and after, companies 471
    and 464. NOT ONE FIGURE MOVED:
      Glutenull MO-0001  qty_produced 560     su 1750
      Glutenull MO-0002  qty_produced 192.48  su  802
    1750 x 0.32 = 560 and 802 x 0.24 = 192.48, both exact.
  ✓ VERIFIED ON SCREEN on prod as the CLIENT'S OWN USER
    (Arshita / Glutenull1), /MLO-Management: both MOs read
    planned and completed identical, units-first, nothing blank.
  ⚠ Before the repoint, qty_produced_su for MO-0001 came from
    560 / 0.32, which in floating point is 1749.9999999999998.
    It read 1750 only because the view rounds to 3 places. It
    now reads 1750 because that is what is STORED.
```

---

## MEASURED IN S100 — findings, not jobs

```
THE HEADER VIEW HAS NOW BEEN READ. Both views have.
  Trace_ProductHeaderView   — 5756 bytes, read from dev.
  Trace_ProductProdLotView  — 1071 bytes, read from dev.
  ⚠ Neither has been read on PROD.

TRAPS 10 CONFIRMED BY SIGHT, not inference.
  Inside the do_products CTE:
    sum(case when ps.shipped_flag then do.qty_to_ship else 0 end)
        AS qty_shipped        ← THIS IS KG
  The real dispatchorders.qty_shipped is UNITS.
  ⚠ qty_packing_slip and qty_do sum the same Kg column.

0.5 IS A VALID SHIPPING UNIT. MINTY'S RULING S100.
  ⚠ A fractional figure in a units column is NOT evidence of a
    divided weight. Claude read 0.5 in dispatchorders.qty_shipped
    as a mixed-basis defect and was WRONG. Every row in the
    sample reconciles: 10 Kg at 20 Kg/unit IS 0.5 units.
  ▶ DO NOT RE-RAISE THIS.

A PACKING SLIP MEANS READY TO SHIP, NOT SHIPPED.
  MINTY'S RULING S100. Shipped slips appear on the Shipped PS
  screen. So 0# Qty Shipped on a DO that holds a packing slip
  is CORRECT. → this closes P82g.

dispatchorders.qty_shipped IS NEVER NULL.
  26 active rows, 0 nulls, 12 zeros (correctly unshipped).
  ⚠ Relevant to P62.

mlomanagement received_qty vs received_units ARE CONSISTENT.
  15 rows checked. received_qty / received_units lands exactly
  on a real per-unit weight every time (1.39, 0.737, 0.4, 5,
  8, 0.1). ⚠ Including MO-0009, where received_qty holds
  15.290000000000001 and 15.29 / 11 = 1.39.

Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
  MO-0007 came back twice from a direct SELECT. The join chain
  (mlcpackaging, receiveproducts, materialsproductsreleased,
  returnmaterialproduct) multiplies. Pre-existing, NOT caused
  by the repoint. The screen shows one row, so something
  downstream dedupes. → P136

dotenvx IS NOT INSTALLED ON DEV as a command.
  RULES says values load at runtime — true for how pm2 starts
  the app, but `npx dotenvx` fails and node_modules/.bin has
  no dotenvx. ▶ To reach the DB from a script, read .env
  directly. The driver is node_modules/mysql (NOT mysql2).
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending.
FRONTEND   nothing pending. Both boxes on f53986ca.
DATABASE   nothing pending. The qty_produced_su repoint is on
           BOTH boxes as of the S100 close.
           ⚠ There is still NO PROMOTE PATH for a database
             object. Each box is changed separately, every time.
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
P62   qty_shipped must never be NULL.
      ⚠ MEASURED S100 — it never is, on 26 active rows.
P64   Product label prints "null" for Ext ID twice, on prod.
      ⚠ ALSO on the PACKING SLIP, the Closed MOs Excel export,
        and the Closed MOs SCREEN (seen S100, prod, company 464).
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them, do not update.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries companies 466 and 469, unaccounted.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      Prod 29 updates, dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1, 2, 3 AND 4 AUG. RESCHEDULE.
P104  No 1.39 intermediate fixture on dev.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY and retire what is covered.
      KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ▶ RAISED BY MINTY S100 AS AN IMPORTANT NEXT ITEM.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 evalFinalStateElement
        closed-so.component.ts:165 evalFinalStateElement
        edit-mlc:295 · edit-mlo:245 · start-mlc:151 (lotReceived)
        add-dispatch.component.ts:72 (v1 popup, never opened)
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  Mark the deliberate code in the code.
P119  Back up the database's own code into the repo.
      ⚠ MORE URGENT AFTER S100 — a view has now been changed on
        one box and not the other. There is no record of the
        database's code anywhere in git.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
      Fold into whichever session next touches Company.js.
P130  EXCEL EXPORTS — the Closed MOs one was fixed S98. The others
      are UNCHECKED. ▶ grep downloadExcel across src.
P131  EDIT CLOSED MO LINE 133 — a unit count printed with the
      WEIGHT label, beside a Kg figure with NO label.
        quantity: qty + " " + uom + " (" + received_qty + ")"
      ⚠ CONFIRMED ON PROD S100, company 464: MO-0001 renders
        "10 Kg (400)". The 10 is a UNIT COUNT wearing a Kg label.
      ⚠ Was previously seen on dev only. Now seen on the live box.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
      soproducts.product_status · soproducts.status ·
      somanagement.status_id. ▶ DECIDE: write them or remove them.
P133  do_status NEVER ADVANCES. ▶ DECIDE: write it or remove it.
      ⚠ TRAPS 8 IS RETAINED UNTIL P133 IS FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
```

```
NEW IN S100

P135  ⚠ THE ACROBATICS WATCH ITEM. LOW PRIORITY, DELIBERATE.
      MINTY'S RULING S100: these are places where the app works
      a figure out by dividing, instead of reading the count it
      already stores. EVERY ONE OF THEM IS CORRECT TODAY.
      ▶ REVISIT ONLY WHEN A WRONG FIGURE ACTUALLY APPEARS.
        Then come here first — the answer is probably in this list.

      WHAT IS IN IT
        fix 6   /Edit-Mlc completed quantity. Frontend line is
                right; the BACKEND ROUTE does not return
                received_units. Needs a backend change first.
                ▶ The reverted patch is in history at 34e99c3e.
                  Read it rather than rewriting it.
                ⚠ /Edit-Mlc and /Edit-MLO ARE DIFFERENT SCREENS
                  with nearly the same name. Name the URL.
        Trace_ProductHeaderView, six remaining divisions:
          qty_shipped_su · qty_packing_slip_su · qty_do_su
          qty_misc_release_su · intermediate_prd_su · SOH_su
        ⚠ qty_produced_su was repointed on BOTH boxes in S100
          and is NOT part of this list. Six divisions remain.

      WHY IT IS LOW PRIORITY, IN PLAIN WORDS
        Every figure on the screen is right today. The view
        rounds to 3 decimals, and the float error is around
        15 decimal places down — so it cannot break the number
        at these scales. The real risk is different: if the
        stored weight and the stored unit count ever disagree,
        the view reports the weight-derived one and HIDES the
        disagreement. No evidence that has ever happened.

      ⚠ TRAPS 10 STAYS UNTIL THIS LANDS. It protects the job:
        inside the view a CTE names a KG sum `qty_shipped`,
        while the real column of that name holds UNITS.
        Repointing by name wires Kg into a units field.

P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
      MO-0007 came back twice from a direct SELECT. The join
      chain multiplies. The screen shows one row, so something
      downstream dedupes — but a report or export reading the
      view directly would double-count.
      ⚠ PRE-EXISTING. Not caused by the S100 repoint.
```

```
CLOSED IN S100

P82e  Trace_ProductProdLotView "selects mm.qty twice."
      ▶ THE VIEW WAS READ. It does select mm.qty twice, as
        qty_su and qty — redundant, not wrong. It also selects
        received_qty and received_units, correctly separated.
        NO DEFECT. ▶ CLOSED.
      ⚠ ONE THING NOTED: `qty_su` is Kg wearing a `_su` name.
        Same trap family as TRAPS 10, second view. Not acted on.

P82f  received_qty stores float garbage in saved rows.
      ▶ CLOSED BY MINTY'S RULING S100. Prod was measured clean
        in S99. The bad rows are DEV FIXTURE RESIDUE only.
        Healing test data buys nothing. A fresh clean company
        (260804) replaces them as the reference set.
      ▶ ABSORBED INTO JOB A.

P82g  /Dispatch-orders shows 0# on shipped DOs.
      ▶ CLOSED. STALE. MINTY'S RULING S100: a packing slip
        means READY to ship, not shipped. Shipped slips appear
        on the Shipped PS screen.
      ▶ MEASURED: every 0# on /Dispatch-orders sits against a
        DO that has not shipped. Every row on Shipped PS holds
        a real figure — 7# (9.730 Kg), 2# (1.400 Kg), all
        reconciling. NO DEFECT.
```

---

## P82 — WHERE IT STANDS

```
⚠ P82 WAS NEVER ONE BUG. It is one PATTERN found in nine places
  across four layers: frontend code, database views, a missing
  column, and already-saved rows. That is why it felt endless.
  MINTY, S100: "appears endless... we must get out of this."

DONE, all verified on screen, all on PROD:
  fix 1  SOManagement.js:182-206              2ae869c   (S98)
  fix 2  admin-formulation.component.ts:878   a52e4bfc  (S98)
  fix 3  add-mlo.component.html:87            b8e7248b  (S98)
  fix 4  closed-mlcs.component.html:79/84     824e0e6d  (S98)
  fix 5  edit-closed-mlcs.component.ts:126/136 770d3c4f (S99)
  fix 7  product-traceability.component.ts:109,161
                                              f53986ca  (S100)

DROPPED OR CLOSED IN S100:
  P82e  no defect · P82f  absorbed into Job A · P82g  stale

MOVED TO WATCH — P135, low priority:
  fix 6, and six of the seven header-view divisions.

⚠ ONE ACTIVE JOB REMAINS:
  P82c  the misc release units column.  → S101 JOB B
  P82b  SOH. Follows P82c. It is a VIEW change, so if it is
        not straightforward it belongs in P135 by Minty's rule.

▶ WHEN P82c AND P82b ARE DONE, P82 CLOSES AS A CAMPAIGN.
  P135 continues as a watch item and is NOT part of P82.
```

---

## DEV FIXTURE RESIDUE

```
company 464
  test0.7 (FO-0009)   0.7 Kg/unit, single pack level. KEEP.
  test1.39 (FO-0004)  1.39 Kg/unit. THE STANDING FIXTURE until
                      260804 replaces it. Never verify on 1:1.
  MO-0007             51 units, 70.89 Kg. THE fix 7 / P82a
                      reference row. KEEP.
  MO-0018             created S99, stores 10 not 10.008.
                      Clean-path evidence. KEEP.
  MO-0015/0016/0017 · DO-0013/0014 · PS-0028/0029

CORRUPTED PLANNED QUANTITIES — DEV ONLY, NOT BEING HEALED
  MO-0007 50.004 · MO-0008/0009/0010/0011 10.008 · MO-0013 1750.08
  ⚠ Residue from before a fix that landed between MO-0013 and
    MO-0014. ▶ NOT WORTH HEALING — Minty's ruling S100. Company
    260804 becomes the clean reference set instead.
  ⚠ DO NOT read these as a live defect next session.

  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
```
