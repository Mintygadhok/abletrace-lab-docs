# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE. One fact, one home, decided by how often it changes.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S83 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S82 — P7 SLICE 3 DONE AND VERIFIED IN THE DB.
               P7 SLICE 4a WRITTEN AND SHIPPED TO DEV BUT
               LARGELY UNTESTED. Four commits, two repos.
THIS SESSION   S83 — TEST 4a FIRST, then slice 4b (the row
               template), then the sequencing change.
               ⚠ DO NOT BUILD BEFORE TESTING. Half of 4a has
               never been exercised even once.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5/6) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. If a fetch looks stale, ask
            Minty to PASTE the section rather than re-fetching.

▶▶ THE NEXT JOB — S83. STEPS 1 AND 2 ONLY (test 4a, fix what it
   breaks). ⚠ STEP 3 ONWARD IS A SEPARATE SESSION — Minty's call
   S82. Do not start the row template in S83. ◀◀

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; its STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    packing_units = 0.5 is CORRECT. → J88. PROVEN LIVE S82 (J94).
  • A DO coming off a packing slip ALWAYS returns its quantity and becomes
    available again — whether one DO or all of them (Minty, S81). → J92.
  • SLICE 2's POPUP BEHAVIOUR IS CORRECT AND PROVEN S82 — do NOT
    re-investigate. Auto-tick keys on lot+customer+address; the LIST
    filters on customer+address only. A same-address DIFFERENT-LOT DO
    stays visible and UNTICKED, which is the intended design. An
    apparent "0 of 0" on reopening the popup was ARITHMETIC, not a
    defect: every DO at that address had been moved. → J99.
  • THE PACKING SLIP FLOW (Minty, S82): move DOs → SAVE (repeatable) →
    enter shipping reference + vehicle condition → SHIP (terminal).
    Cancel available until Ship, never after. → J97.
```

---

## ⚠⚠ P7 — THE SIX STEPS TO FINISH IT. AGREED S82.

```
⚠ THIS IS THE WHOLE REMAINING SHAPE OF P7. Read it before planning a
  session, so no step gets started out of order.

STEP 1  TEST 4a.  ← S83 STARTS HERE
        Six behaviours shipped in S82, none exercised. Detailed as
        T1-T7 in the block below. ⚠ NOTHING NEW IS BUILT UNTIL THIS
        PASSES.

STEP 2  FIX WHAT STEP 1 BREAKS.  ← S83 ENDS HERE (Minty, S82)
        Unknown until tested. Two candidates already logged:
          P44  editPackslips never writes vehicle_condition — and
               SHIP IS NOW GATED ON IT, so an operator can pick a
               condition, ship, and have it discarded.
          P45  no over-ship guard anywhere on the edit screen.

STEP 3  SLICE 4b — THE NEW ROW TEMPLATE.  ⚠ SEPARATE SESSION.
        · ten fields per row; the WHOLE ROW moves as one unit
        · DROP  Product Internal Code · System SO No
        · REMOVE Customer + Delivery Address from the ROW — they
          already exist as header fields, so this is a deletion
        · RESTORE Shipped Units (#) + Shipped Qty on existing-DO
          rows (currently commented out — a behaviour change, not
          just a re-layout)
        · RENAME "Customer SO No" -> "Customer PO No" (TWICE in
          edit-packslips.component.html)
        · popup title -> "Select DOs to Move to Packing Slip"
        · popup button "Save" -> "MOVE TO PACKING SLIP"
        ⚠ THE DATE PICKER MUST SURVIVE. It sits in the header above
          the rows and already behaves correctly. Verify after the
          rebuild; do not assume. (J97.)

STEP 4  SLICE 4b — PO BARCODE TABS.
        One tab per distinct SO-External across the moved DOs, each
        with a scannable barcode, into the PRINTED DOCUMENT (not the
        Zebra).
        ⚠ NOT YET DESIGNED. Decide WHAT THE BARCODE ENCODES before
          any code is written.

STEP 5  SLICE 4c — THE SEQUENCING CHANGE.
        Save · Ready to Ship · Cancel. Pressing Ready to Ship reveals
        the shipping fields and the Ship button.
        ⚠ NEEDS A REAL DB COLUMN — Minty's call S82. A visual-only
          toggle forgets itself on reload. DB change -> rule 4.8:
          not in git, must go in the rebuild block.

STEP 6  PROMOTE TO PROD.
        Only when 1-5 are done and tested end to end.
        ⚠ BACKEND FIRST, THEN FRONTEND. Deployed the other way round,
          SHIP silently stops shipping until the frontend lands (J96).

AFTER P7, NOT PART OF IT
        P43  multiple invoices / QuickBooks child table
        The scan · the ambiguity popup · documents-before-dispatch
```

---

## ⚠⚠ S83 STEP 1 — TEST WHAT S82 SHIPPED. DO THIS BEFORE ANY BUILDING.

```
Everything below is LIVE ON DEV and NEVER EXERCISED. Slice 4a
re-enabled a code path that has not run since it was commented out,
and that path is the one slice 1 (S81) was written to fix.
⚠ VERIFY EVERY QUANTITY IN THE DB, NOT THE TOAST (rule 5.1, JT12).

T1  SAVE STAYS OPEN      Edit a slip, press Save. Must say "Saved",
                         must NOT navigate away, slip still editable.

T2  ADD A SECOND DO      "Add Dispatch order +" → pick a DO → Save.
                         ⚠ NEVER-RUN PATH. This is where S81 slice 1
                           finally gets exercised. Watch for errors.
                         ⚠ Check PackingSlipDOs got a row AND the DO's
                           qty_shipped moved.

T3  REMOVE A DO          Remove a DO row, press Save. The quantity
                         must come back and the DO become available.
                         ⚠ THIS IS P40 / J92 — the whole reason slice 1
                           exists. If this works, P40 closes.

T4  SHIP IS GATED        Blank reference/condition → Ship greyed.
                         Fill both → Ship goes live.
                         ⚠ UNPROVEN: does it ungrey immediately, or
                           only after clicking elsewhere? If the latter,
                           Ship will look permanently dead to an operator.

T5  SHIP                 Terminal. Navigates back. Add-DO and Cancel
                         disappear. shipped_flag = 1, shippingdate and
                         finalShipmentUserId stamped.
                         ⚠ A SAVE must NOT have stamped any of those.

T6  CANCEL BEFORE SHIP   Reverses everything, all DOs return.

T7  REGRESSION           Create a slip WITH reference and condition
                         filled — the original path must still work.
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  DEV  db415d74   ⚠ AHEAD OF PROD — S81 slice 2, S82 slices 3 + 4a
          PROD 53db203d   unchanged
Backend   DEV  083fc96    ⚠ AHEAD OF PROD — S81 slice 1, S82 slice 4a + guard
          PROD d3104ea    unchanged

⚠ THE DIVERGENCE IS DELIBERATE AND EXPECTED. Nothing was promoted to
  prod in S81 or S82. Do NOT "reconcile" by promoting — P7 is mid-build
  and 4a is untested.

S82 COMMITS, in order:
  frontend  897096b4  slice 3, five units sites
  backend   2d22e5a   slice 4a, split save from ship
  frontend  db415d74  slice 4a, Save/Ship buttons + add-DO + editable
  backend   df6d728   null guard (INCOMPLETE — see 083fc96)
  backend   083fc96   corrected: vehicle_no coerces to '' not null

Trees clean both boxes at S82 close. Health 200 both. PM2 online both
(abletrace-dev / abletrace-backend). PROD IS HEALTHY AND UNTOUCHED.

(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  DEV frontend   www-html.bak-dev-db415d74b769     (S82, current)
  PROD frontend  www-html.bak-prod-53db203d4ef4
  DEV backend    /home/ubuntu/PackingSlips.js.bak-S82
  DEV backend    /home/ubuntu/PackingSlips.js.bak-S81
```

## ⚠ CI — PUSH AUTO-BUILDS DEV

```
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → still a deliberate manual dispatch.
Build time observed S82: 4-10 minutes.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S82-verified)

```
1  [DEV]  edit + commit + push
2  WEB    github.com/Mintygadhok/abletrace-lab-frontend/actions
          wait for green
3  WEB    open the run, download the artifact
          ⚠ CONFIRM the filename starts dist-dev- (rule 5.3)
4  [MAC]  ~/promote.sh ~/Downloads/<artifact.zip> dev
5  BROWSER  Cmd+Q ENTIRELY. Not a hard reload. Lazy popup chunks
          survive everything else (J66).

⚠ promote.sh lives on the MAC, not on a box.
⚠ ssh/scp always from the MAC:
    ssh -4 -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
    (the -4 is the S73 IPv6 workaround → P23)
⚠ THE ARTIFACT DOES NOT ALWAYS DOWNLOAD ON THE FIRST CLICK (S82).
  Check with: ls -lt ~/Downloads | head -5
```

## ⚠ HANDING PATCH SCRIPTS TO MINTY — CHANGED S82. READ THIS.

```
⚠ PASTING LONG PATCH SCRIPTS INTO THE TERMINAL FAILED 6+ TIMES IN S82.
  Not once — repeatedly, and in FRESH WINDOWS TOO. Two theories were
  proposed and both were DISPROVEN by the evidence:
    "it is the paste size"      → a fresh window took the same size fine
    "it is stale window state"  → a fresh window ALSO failed
  The failures cut at the SAME CONTENT each time. Cause unknown. → P46.

⚠ THE WORKING METHOD, USE IT BY DEFAULT FOR ANY PATCH SCRIPT:
    1  Claude writes the patch and hands it over as a FILE (rule 0.2b)
    2  [MAC]  scp -i ~/.ssh/abletrace-lab-key.pem ~/Downloads/<patch>.py ubuntu@16.55.10.205:/tmp/
    3  [DEV]  python3 /tmp/<patch>.py
    4  [DEV]  git --no-pager diff
  Short commands paste fine. Only long multi-line scripts fail.

⚠ MINTY ASKED FOR PASTEABLE BLOCKS, NOT DOWNLOAD LINKS (S82) — and he
  is right for COMMANDS. The scp route above keeps the commands short
  and pasteable while the SCRIPT travels as a file. Do not switch
  formats mid-session without saying so.
```

## ⚠ DEV HAS NO ~/.my.cnf — THE DB QUERY RECIPE (J43)

```
A bare `mysql` on dev hits a nonexistent local socket. Build a temp cnf
from .env. This block is one paste and self-cleans:

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "<QUERY>"
rm -f /tmp/q.cnf
```

## DEV FIXTURE RESIDUE — ⚠ note before reusing company 464 as a baseline

```
1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
2. MAT-6 missing its Sesame allergen       (S73 → P24)
3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)
4. DO-0010 + PS-0005 on SO-0009 (test1.39/FO-0004)  (S80)
5. SO-0011 · DO-0011 · PS-0006 (CANCELLED, status_id 2)  (S81)
6. S82 ADDED: PS-0008 carries DO-0008 at 0.5 units — THE PROOF ROW
   for slice 3. PS-0010 carries DO-0004/0005/0006. Plus at least two
   slips created blank-field while chasing the 500.

⚠ THE 0.5-UNIT FIXTURES ARE NOW PARTLY CONSUMED. DO-0008 is on PS-0008.
  DO-0009 (packing_units 0.5, Jade 3, Victoria address) is STILL FREE
  and is the remaining fractional test row.
⚠ NOTE: DO-0008/0009 are 10 Kg at 0.5 units = 20 Kg per unit, on
  FO-0001-4 — NOT the test1.39/FO-0004 fixture the old record named.
```

## ⚠ PROD RESIDUE — S80, STILL OPEN

```
DO-0006 created on PROD in error during the S80 walk (SO-0004,
customer "Jade 3", testpdt260703 / FO-0001-4, 1# (20 Kg), lot
Pdt-260701-1). Almost certainly sandbox company 464 but NEVER
CONFIRMED. One query settles it → P37.
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠⚠ **P7 REMAINS THE ACTIVE JOB.** Slices 1, 2, 3 done. 4a shipped but UNTESTED. 4b and the sequencing change are next.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING — no full pass since S73. ▶ Minty's, one pass, at session open.

**P7  PACKING-SLIP REDESIGN — ⚠ IN BUILD. 1·2·3 DONE. 4a SHIPPED UNTESTED. 4b NEXT.**

```
SLICE 1  ✅ DONE S81 — backend ff5d183. deletedDos returns qty from the
         STORED PackingSlipDOs row. ⚠ STILL UNTESTED — becomes
         reachable only now that 4a re-enabled the buttons. → S83 T3.

SLICE 2  ✅ DONE S81 — frontend 0f4c0344. DO auto-select by
         lot+customer+address. ⚠ REGRESSION RE-CONFIRMED S82: picking
         DO-0008 did NOT tick DO-0004/5/6 (different lot). The CUSTOMER
         half remains unproven — no fixture has two customers at one
         address. → J93.

SLICE 3  ✅ DONE AND VERIFIED S82 — frontend 897096b4. Five sites now
         read the stored packing_units instead of dividing Kg by unit
         weight. PROVEN IN THE DB: PS-0008/DO-0008 carries 0.5 in
         shipped_qty, qty_shipped AND packing_units — all three agree.
         Before the fix a 0.5-unit DO would have shipped 1. → J94.
         ⚠ ONE SITE DELIBERATELY LEFT: edit's save() write. Fixed in
           4a instead, where it could be tested. → J95.

SLICE 4a ⚠ SHIPPED TO DEV S82, LARGELY UNTESTED. Four changes:
         · backend 2d22e5a — editPackslips no longer hardcodes
           shipped_flag. A plain Save does NOT stamp shipped_flag,
           shippingdate or finalShipmentUserId. Ship does. → J96.
         · frontend db415d74 — save() split into save()/ship() via
           submitSlip(isShipping). Save stays on the slip; Ship
           navigates back. sendMail only fires on Ship.
         · frontend db415d74 — shipped_qty now posts the UNIT COUNT,
           not units × weight. Closes J88 on the edit path. → J95.
         · frontend db415d74 — "Add Dispatch order +" un-commented;
           Save button added; Ship gated on both shipping fields;
           reference/condition/storage now editable until shipped;
           create screen no longer REQUIRES the two shipping fields.
         ⚠ THE 500 THAT FOLLOWED, and its fix — J98. Two attempts were
           needed. Do not repeat the first one.
         ▶ ALL OF IT NEEDS TESTING — see the S83 STEP 1 block above.

▶ SLICE 4b — THE ROW TEMPLATE. THE NEXT BUILD.
   THE WHOLE DO ROW MOVES AS ONE UNIT into a new template.
   1  THE ROW — ten fields, replacing the stacked form:
      MO Number · Internal DO Number · Customer PO No · Product ·
      Product External Code · Pdt Lot Code · Best Before ·
      Order Qty (Units) · Shipped Units (#) · Shipped Qty
      DROPPED: Product Internal Code · System SO No
      TO HEADER: Customer · Delivery Address
      ⚠ Customer and Delivery Address ALREADY EXIST as readonly header
        fields. The work is REMOVING them from the row, not adding.
      ⚠ The existing-DO row currently HIDES "Shipped Units (#)" and
        "Shipped Qty" (commented out). The ten-field row RESTORES them.
        That is a behaviour change, not just a re-layout.
      ⚠ MO and DO numbers KEPT DELIBERATELY — the handles an operator
        needs when a customer phones.
   2  PO BARCODE tabs — one per distinct SO-External across the moved
      DOs, each with a scannable barcode. ⚠ Into the PRINTED DOCUMENT,
      not the Zebra.
   3  RENAMES: popup title "Dispatch Orders" → "Select DOs to Move to
      Packing Slip"; its button "Save" → "MOVE TO PACKING SLIP".
   4  ABSORB: the remaining "Customer SO No" → "Customer PO No" labels
      (⚠ TWICE EACH in edit-packslips.component.html — existing block
      and shipment block) · the attach-a-doc-to-an-unshipped-slip
      file loss.
   ⚠ THE DATE PICKER MUST SURVIVE. It sits in the header, above the
     row block, and already behaves correctly: editable and defaulting
     to today before ship, readonly after. Minty flagged it S82 as
     essential. Verify after the rebuild, do not assume. → J97.

▶ SLICE 4c — THE SEQUENCING CHANGE. AFTER 4b. NEEDS A DB COLUMN.
   Minty's flow (S82): move DOs → SAVE (repeatable, each move saved)
   → "Ready to Ship" → shipping reference + vehicle condition appear
   → Ship activates once both are filled → Ship.
   ⚠ MINTY'S CALL S82: do this as its own piece, with a REAL COLUMN
     behind "Ready to Ship", not a visual-only toggle. A visual toggle
     forgets itself on reload.
   ⚠ DB CHANGE → rule 4.8: not in git, must go in the rebuild block.

▶ NOT YET SCOPED — after 4c:
   THE SCAN. doLotCode() (slice 2) is the hook. A scanner is a
   keyboard; it types into the search box, which already filters on
   lot code. Scan and click must be ONE function taking a LOT CODE
   with two thin callers (Minty, S80).
   THE AMBIGUITY POPUP. Only at the FIRST pick, and only when one lot
   resolves to more than one customer+address pair.
   ⚠ DOMAIN CALL STILL OPEN: should documents be attachable to a slip
   BEFORE dispatch? Minty's instinct: yes.
```

[J86 · J87 · J88 · J89 · J90 · J91 · J92 · J93 · J94 · J95 · J96 · J97 · J98]

**P1  DOCUMENTATION CONVERGENCE — ✅ DONE.** All eight sections live in the repo. ⚠ REMAINING: delete the two dead physical files → P20 (old Section J) and P22 (old Section A).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
⚠ GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY (J83). Do NOT re-derive:
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT. Every `_su` field is `<Kg> / wgt_kgs_per_unit`.
  • The Products list (admin-formulation.component.ts:878) divides SEPARATELY, and divides the OLD Kg column.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN EXISTS: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. That is R1. Copy it.
⚠ **THE PACKING-SLIP SITES ARE DONE — S82 closed five of them (897096b4) plus edit's write (db415d74).** Six sites off the list. → J94, J95.
⚠ **S81 ADDED A NEW SITE TO FIND:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. Same mixed-units-on-one-row shape as JT4. Nobody has logged where it is read. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with file, line, and the stored units column that should replace it. THEN rank.
Sub-items behind the inventory: R5 display switch · MO-CREATE round-trip (add-mlo.ts:204-205, MO-0007 plan reads 50.004#) · DO/MR/intermediate-release subtract stored units · retire formulations.inventory.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91 · J94 · J95]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 deleted; was to be deleted WITH a final snapshot. ⚠ UNVERIFIED. RDS → Snapshots. [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]". ⚠ S82 NOTE: the packing-slip alerts DO surface real backend messages (the 500 text came through readable), so this screen is better than the average. ⚠ The scan field must NOT raise a blocking alert on a bad scan. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. ⚠ Test attach-then-ship or an already-shipped slip. [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default.
✅ **PRECONDITION MET S81 — MO-Release Global Select HAS NOW BEEN READ.** Findings:
```
FILE   src/app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/
       release-mat/release-mat-details/  (1243-line .ts, 265-line .html)
BACK   MaterialsProductsReleased.js:150 createReleaseMaterialProductsV2
CONTROL  html:35-40 one "Select All" checkbox → setAllSelect()
HANDLER  ts:176-192 three near-identical blocks (materials, formulas,
         packaging) each setting x.isDirectQty = !!this.selectAll
PER-ROW  html:44 / 114 / 179, each with a guard:
         (released_qty < final_qty) && fill...FromList(...)
FIELD    the selection flag is `isDirectQty`, NOT `selected`
⚠ IT IS A SELECT-ALL, NOT A SELECT-MATCHING. No predicate. What
  transfers to P6/P7 is the SHAPE (one control, a flag per row, a
  fill-handler per list, a guard that skips ineligible rows) — not
  the matching logic, which does not exist here.
⚠ DEAD CODE IN THIS FILE → P38.
```
[3A.3 · J89]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it. ⚠ Reading a frontend file from prod's checkout shows code that is NOT LIVE. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Also fixes My Code showing literal "null" — ⚠ SEEN AGAIN S81 on the packing slip ("Product External Code: null"). ⚠ S82 FOUND THE MECHANISM for the packing-slip case: FormData stringifies blanks so the four-letter string 'null' reaches the backend. Same family. → J98. [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Needs a backend guard. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** ⚠ WORSE AGAIN S82 — now also holds several patch .py files and three dist zips. promote.sh deploys whatever zip you name. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** ⚠ Sequenced AFTER the app.abletrace.ca switch. [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed again S82. The boxes run DIFFERENT operating systems (prod 26.04 / dev 24.04.4), so a dev reboot rehearses nothing. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ `ssh -4` is the standing workaround and was needed throughout S82. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ▶ Does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value nobody reads? [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** Batch with the R5 display switch. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** ⚠ PROD GETS NO RENEWAL-FAILURE WARNING. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ Do NOT disable casually. [3B.2 · J84]

**P35  EDITING A PACKING SLIP TO ADD A DISPATCH ORDER THROWS.** ⚠ **BACKEND FIXED S81 SLICE 1** (loop deleted, ff5d183). ⚠ **THE BUTTON WAS RESTORED S82 SLICE 4a** — so it is NOW REACHABLE and testable for the first time. ▶ S83 T2 closes or re-opens this. [§2 to-verify 5 · J85 · J86 · 3A.4]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** `PopUps/add-dispatch/` declared in edit-sales-order.module.ts:20 but never opened. ⚠ Grep for other references first. [J87]

**P37  CONFIRM THE COMPANY OF PROD SO-0004 (one query, minutes).** ⚠ Run on prod: `SELECT id, internalCode, company_id FROM somanagement WHERE internalCode='SO-0004';` If 464 → harmless. If not → real client data was touched. [Section 1 PROD RESIDUE]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** ⚠ The old "Add +" button and its `mat-select` lot dropdown are COMMENTED OUT in the template (html:94-111, 160-176, 223-240) but `selectOption` is STILL WRITTEN in the .ts (691-700, 810-818, 1066-1091, plus a commented block at 1104-1143). ⚠ Same JT9/JT22 decoy as P36, sitting in the exact file P6 will redesign. [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ FOOD-SAFETY-CRITICAL: JT8 says never two COLLECTION associations in one nestedPop populate array; v0.1.4 silently returns the SECOND one EMPTY. That bug hid missing intermediates once already (S55). Sites: Formulations.js lines 609, 632, 1063. ▶ Read each, confirm no two collections share a populate array. [§2 to-verify 1 · JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP IS UNUSABLE.** ⚠ **THE FRONTEND HALF WAS FIXED S82 SLICE 4a** — /Edit-Packslips now has a Save button that does not ship, so `deletedDos` finally has a commit path. ▶ UNTESTED. S83 T3 closes or re-opens this. [J92 · J96]

**P41  WRITE THE RULE INTO SECTION 2 — a DO coming off a slip always returns its quantity.** ⚠ Minty's decision S81. ⚠ DO NOT add a new standalone rule: §2 Core #2 already says "reverse walks back one bucket at a time, cancel logic already exists there" — TRUE of cancel-whole-slip and quietly FALSE of remove-one. ▶ REISSUE that existing Core #2 sentence WHOLE with the decision folded in (rule 7.1). ⚠ S82 ADDS A SECOND EDIT TO THE SAME SECTION: the three-step flow (move → save → ship) is now settled domain logic and belongs in §2 alongside it. Do both in one pass. [J92 · J97]

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG.** ⚠ DO NOT START UNTIL P7 IS CLOSED — P7 is actively generating J-entries (S82 alone added five) and splitting a file mid-append is the worst moment. Section 5 is ~2000 lines and append-only. WHY: the JT traps block is short and worth reading EVERY session (rule 1.4); the J-entry log is long and rarely needed in full. ▶ THE SPLIT: Section 5A = JT traps + JR rebuild checklist (short, standing paste). Section 5B = the J-entries (fetched by name). ⚠⚠ J-NUMBERS ARE PERMANENT AND MUST NOT CHANGE — they are cross-referenced from Sections 1, 2 and 3A. ⚠ Also update rule 0.3's standing-paste list and rule 9's structure block to name 5A and 5B.

**P43  SHIPPING REFERENCE → MULTIPLE INVOICES, QUICKBOOKS-READY.** ⚠ NEW S82. Today `packingslips.vehicle_no` is ONE text column holding a single reference. Minty needs SEPARATE fields for multiple invoice documents.
⚠ **DESIGN DECIDED, BUILD DEFERRED: a CHILD TABLE (one row per invoice), NOT delimited text.** Reason: all Minty's clients run QuickBooks and the invoice number will likely need to match a QuickBooks record. Delimited text cannot carry a per-invoice external id or sync state, and retrofitting rows later would mean migrating live shipped slips.
⚠ **OPEN QUESTION, ASK FIRST:** are invoices raised in QuickBooks BEFORE or AFTER the slip ships? If after, the field must be fillable post-ship — which breaks "Ship is terminal" (§2 Core #2) and is a DOMAIN decision, not a code one.
⚠ DB CHANGE → rule 4.8: not in git, must go in the rebuild block. [§2 GR7 vehicle_no · 3A.4 · J97]

**P44  editPackslips NEVER WRITES vehicle_condition.** ⚠ NEW S82, but PRE-EXISTING — not caused by S82. The edit PSOBJ sets only `vehicle_no` and `remarks` (plus the ship fields when shipping). So the Vehicle condition dropdown on the edit screen does not persist. ⚠ MATTERS MORE NOW: S82 made that dropdown editable and gated SHIP on it, so an operator can pick a condition, ship, and have it silently discarded. ▶ Add `vehicle_condition` to the edit PSOBJ with the same blank-guard as createPS. [J98]

**P45  NO OVER-SHIP GUARD ON THE EDIT SCREEN.** ⚠ NEW S82. The old code tried to cap `shipped_qty` at the ordered quantity but compared a NUMBER against a DISPLAY STRING (`"10 Kg ( 0.5 # )"`), so the comparison never fired — the guard was dead for its whole life. S82 removed the dead code. ⚠ NOTHING NOW PREVENTS SHIPPING MORE UNITS THAN THE DO AUTHORISES. Food-safety adjacent. ▶ Compare against the stored `packing_units`, not a rendered string. [J95]

**P46  TERMINAL PASTE TRUNCATION — INVESTIGATE, DO NOT KEEP GUESSING.** ⚠ NEW S82. Long patch scripts pasted into the SSH session were truncated or scrambled 6+ times in one session, always cutting at the same content. ⚠ TWO THEORIES WERE PROPOSED AND BOTH DISPROVEN: "paste size" (a fresh window took the same size fine) and "stale window state" (a fresh window also failed). Cause unknown. ⚠ THE WORKAROUND WORKS AND IS NOW THE DEFAULT: hand patch scripts over as FILES, scp them across, run from /tmp (see the handover block above). ▶ When someone has ten minutes: try a large paste in a window that has run only simple commands, then again after a pager command (`git diff`, `less`), and see if it reproduces. Rule 0.1a — look, do not reason. [Section 0 rule 8]

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good (P26 was "Fix A", a fix for a bug that never existed — J81). P28 CLOSED S79.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
P7 slices 1, 2, 3 and 4a — dev only, deliberately NOT promoted to
prod until P7 is whole and tested end to end.
⚠ 4a IS UNTESTED. Promoting now would be a rule 5.5 violation.
```

**END SECTION 1**
