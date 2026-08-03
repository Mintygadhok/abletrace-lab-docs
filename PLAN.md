# PLAN

Written at close of: S98 · for S99.
Disposable. Rewritten whole at every close.

⚠ EVERY PATH BELOW WAS VERIFIED IN S97 OR S98 WITH `find` + `grep`.
  DO NOT RE-LOCATE THEM. Paths in older documents are stale.
⚠ EVERY SITE BELOW WAS READ IN THE FILE. Read it to write the patch,
  not to confirm the finding.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev frontend SERVING dev-824e0e6d8548 · backend 2ae869c
           prod frontend SERVING prod-c2a52d8e129d · backend 13e3fcd
           both clean · 200
   ⚠ NOTHING WAS PROMOTED IN S95, S96, S97 OR S98.

2  ⚠ MINTY RANKS. Job A is a live client symptom. Jobs B, C and D
   are not. Everything below is scoped and ready; the order is
   Minty's call, not Claude's.
```

---

## JOB A · PROMOTE THE SO STATUS FIX TO PROD

⚠ THE ONLY PENDING ITEM WITH A LIVE CLIENT SYMPTOM.

```
ACTION
  1  On PROD:  git -C ~/abletrace-lab-backend pull
  2            pm2 restart abletrace-backend
  3            sleep 8, then curl → expect 200
  ⚠ BACKEND ONLY. No build, no promote.sh, no artifact.

MATERIAL
  Nothing to paste. Commit 2ae869c is already on GitHub.

ANALYSIS — DONE, DO NOT REDERIVE
  THE DEFECT  api/models/SOManagement.js:193 added DO.qty_shipped
  (UNITS) into a total compared at :201 against product.quantity
  (KILOGRAMS). Under 1 Kg/unit it greens EARLY; over 1 Kg/unit it
  never greens.
  ⚠ GLUTENULL IS ON THE EARLY-GREEN SIDE. Fruits & Nut bars are
    0.32 Kg/unit. An order reads FULLY SHIPPED while stock is
    still owed. This is live on prod today.
  THE FIX  populate packing_id on the DO find, then multiply
  qty_shipped by wgt_kgs_per_unit. Multiply, never divide.
  ⚠ MINTY'S RULING S97: a DO can ship MORE OR LESS than
    authorised, so the status must follow qty_shipped, not
    qty_to_ship. That is what rules out the no-conversion fix.
  ⚠ NOT EXERCISED: the over-1-Kg-per-unit direction. The dev
    fixture is 0.7 Kg/unit. Glutenull's products are all under 1,
    so the untested direction is not the one that matters to them.

VERIFY
  On PROD, open /SO-Management as Glutenull.
  ⚠ EXPECT SOME DOTS TO CHANGE. An order previously reading GREEN
    with stock owed should drop to YELLOW. That is the fix working,
    not a regression.
  ⚠ REGRESSION PAIR: a genuinely complete order must STAY GREEN,
    and an unshipped order must STAY RED.
  ▶ If anything looks wrong: git checkout 13e3fcd on prod's
    backend and pm2 restart. No data is touched by this fix.
```

---

## JOB B · PROMOTE THE THREE FRONTEND FIXES TO PROD

```
ACTION
  1  GitHub Actions → build-frontend.yml → Run workflow →
     target = prod.  ⚠ A PUSH ONLY BUILDS DEV. Prod needs this
     manual dispatch.
  2  Download the dist-prod-<40-char-sha> artifact.
  3  On the MAC:  ~/promote.sh <that zip> prod
     ⚠ It will require typing 'yes'.
  4  Cmd+Q the browser before looking.

MATERIAL
  Commit 824e0e6d is already on GitHub and carries all three.

ANALYSIS — DONE, DO NOT REDERIVE
  ⚠ NO CLIENT SYMPTOM. Measured on prod S98: formulations.inventory
    and inventory_units AGREE on all 27 Glutenull products
    (FO-0019 560 Kg / 1750 units at 0.32; FO-0022 192.48 / 802 at
    0.24; the other 25 are zero). These fixes change the ROUTE, not
    the number.
  ⚠ SO THE VERIFICATION CANNOT BE "the number is right" — it
    already is. What must be checked is that nothing BLANKS.

VERIFY on prod, as Glutenull
  Products list      FO-0019 must read 1750# (560 Kg)
                     FO-0022 must read 802# (192.48 Kg)
                     ⚠ If either reads 0, inventory_units is not
                       reaching that screen. Roll back.
  Closed MOs         Planned and Completed both units-first.
                     ⚠ Compare one MO against MLO-Management for
                       the same product — they must agree.
  Add-MLO            only if Glutenull has a product with an
                     intermediate. If not, this screen cannot be
                     checked on prod and that is fine — say so.
  ▶ Rollback: the path printed by promote.sh, read off the box.
```

---

## JOB C · THE LAST THREE P82 FIXES

⚠ ONE AT A TIME. patch → diff → commit → push → build → promote →
LOOK AT THE SCREEN → next. Finish one before starting the next.
⚠ ALL THREE ARE FRONTEND. Edit on the MAC.

```
FIX 5 · EDIT CLOSED MO
  FILE  app/Layouts/admin-dashboard/mlo-management/closed-mlcs/
        edit-closed-mlcs/edit-closed-mlcs.component.ts   line 136
  NOW   WDU: `${Math.ceil((this.mlcDetails.qty / this.wduUnits)...)}
             ( ${lotReceived} )`
  ⚠ TWO FAULTS ON ONE LINE:
      divides mlcDetails.qty, which is UNITS-STORED. Wrong number.
      prints lotReceived (:126), which rebuilds received_qty by
      dividing. R3.
  ⚠ THIS IS THE ONLY SURVIVOR OF ITS FAMILY. The same WDU line is
    COMMENTED OUT in edit-mlc:311, edit-mlo:260, start-mlc:164.
    Somebody switched five off and missed this one.
  FIX   qty is already units — print it, multiply for Kg.
        lotReceived should read mlomanagement.received_units.
  ⚠ FORMAT: units first, Kg in brackets. Minty's ruling S98.
  VERIFY  open a closed MO on a non-1:1 product. The unit figure
          must match what Closed MOs shows for the same MO.

FIX 6 · EDIT-MLC COMPLETED
  FILE  app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/
        edit-mlc/edit-mlc.component.ts                   line 298
  NOW   completeUnit = Number(received_qty / fopackaging_wgt_kgs_per_unit)
  ⚠ THE ARITHMETIC IS CORRECT — received_qty IS Kg-stored. The
    fault is that mlomanagement.received_units holds this figure
    already, stored since S48. Right number, wrong route, and it
    produces float garbage on awkward weights.
  FIX   read received_units.
  ⚠ IDENTICAL TO JR7e / P91, proven in S95. Same source column,
    same fix.
  ⚠ LINE 295 (lotReceived) IS DEAD — its consumer at :311 is
    commented out. Do not fix it. It belongs to P115.
  VERIFY  gate first: count MOs with received_qty > 0 and
          received_units null or 0. Dev returned ZERO in S98 for
          company 464. Re-run it before patching.

FIX 7 · PRODUCT TRACEABILITY
  FILE  app/Layouts/admin-dashboard/traceability/
        product-traceability/product-traceability.component.ts
        lines 109 AND 161
  NOW   wduRec = Math.round((item.received_qty / ...wgt_kgs_per_unit)...)
  ⚠ Same as fix 6 — Kg-stored source, correct arithmetic,
    received_units already there.
  ⚠ LINES 107 AND 159 ARE CORRECT and sit two lines away — they
    MULTIPLY item.qty to derive Kg. DO NOT TOUCH THEM.
  FIX   read received_units.
  VERIFY  ⚠ NAME THE ROUTE: /Product-Traceability, then a product,
          then its details. S95 asked for "product traceability"
          and got a different screen.
```

---

## JOB D · P82c — THE MISC RELEASE UNITS COLUMN

⚠ MUCH SMALLER THAN THE RECORD SAYS. Re-scoped S98.

```
ACTION
  1  ALTER TABLE rejectmaterialandproduct ADD COLUMN <units> double
     DEFAULT 0;   ⚠ ON EACH BOX SEPARATELY. There is no promote
     path for a schema change.
  2  Declare it in RejectMaterialAndProduct.js attributes.
     ⚠ WITHOUT THIS THE WRITE VANISHES SILENTLY. TRAPS 3.
  3  Change the write path so the unit count is captured.
  4  Back the column up and log it in Section 5's JR block IN THE
     SAME BREATH. JR is the only record these exist.

MATERIAL
  Section 5 — the JR block. NOT OPTIONAL, the job writes to it.
  TRAPS entry 3.

ANALYSIS — DONE, DO NOT REDERIVE
  ⚠ NO BACKFILL IS NEEDED. Measured on prod S98:
      SELECT company_id, COUNT(*) FROM rejectmaterialandproduct
      GROUP BY company_id;  →  464 only, 4 rows. GLUTENULL ZERO.
    So there is no live client data to heal. That was the risky
    half of this job and it is gone.
  ⚠ ADDING THE COLUMN DOES NOT FIX SOH. SOH is computed by
    Trace_ProductHeaderView, and that is P82a. This column is a
    PRECONDITION, not the fix.
  ⚠ Dev's four rows in 464 are the test fixture for the write path.

VERIFY
  Make a misc release on dev, then read the row. The unit count
  must be stored, not zero. ⚠ Read the ROW, not the toast.
```

---

## NOT IN THIS SESSION

```
P82a   Trace_ProductHeaderView repoint. ⚠ THE VIEW HAS NOT BEEN
       READ. Gate queries cannot be written until it is. Needs
       SHOW CREATE VIEW on BOTH boxes first.
P82b   SOH. Blocked behind P82a and P82c.
P82e   Trace_ProductProdLotView selects mm.qty twice. Not read.
P82f   received_qty stores float garbage. Not read.
P82g   /Dispatch-orders shows 0# on shipped DOs. ⚠ THE TEMPLATE
       IS CORRECT — proven with cat -A in S97. ▶ Needs a ROW read
       on packingslips / packingslipdos, NOT another code read.
P102   THE REBOOT. Its own sitting. ⚠ VERIFY PM2 STARTS ON BOOT
       FIRST, and remember prod runs a different OS so dev does
       not rehearse it.
P108   Retire the J-entries. ⚠ KEEP JR. Own sitting, with Minty.
P111   QUICKBOOKS. Planning only, no code.
```

---

## OPEN QUESTIONS CARRIED FORWARD

```
⚠ DEV RESTART COUNT went 33 → 128 between S97 and S98 with
  nothing deployed. Cause unknown. Likely the S97 password
  rotation crash-loop, but that is a READING not a measurement.
  ▶ If it climbs again with nothing deployed, investigate.

⚠ P127 — whether /SO-Management and /Closed-SOs agree on the same
  order. Raised by the S98 fix. One check settles it.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section 5's JR block — ONLY IF JOB D IS SCHEDULED.
NOTHING ELSE.
```
