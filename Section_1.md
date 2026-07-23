# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE. One fact, one home, decided by how often it changes.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S82 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S81 — P7 BUILD BEGUN. Slices 1 and 2 written,
               committed, and slice 2 deployed + verified on dev.
               FIRST APP CODE SHIPPED SINCE S71.
THIS SESSION   S82 — SLICE 3 then SLICE 4. Everything needed is
               below. Do NOT re-derive any of it.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5/6) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. Do NOT conclude "it didn't
            commit" from a stale fetch. (Learned S76. Bit again S81 — four
            turns lost. If a fetch looks stale, ask Minty to PASTE the
            section rather than re-fetching; re-fetching returns the same
            cached copy.)

▶▶ THE NEXT JOB — S82. P7 SLICE 3, THEN SLICE 4. ◀◀
   Both are fully specified in the P7 block below, with file paths,
   line numbers and the exact change. START WRITING THE PATCH — the
   reading is done.

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; its STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    packing_units = 0.5 is CORRECT. Do not add an integer guard. → J88.
  • A DO coming off a packing slip ALWAYS returns its quantity and becomes
    available again — whether one DO or all of them (Minty, S81). Cancel-
    whole-slip already does this correctly; remove-one does not. → J92.
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  DEV  0f4c0344   ⚠ AHEAD OF PROD — S81 slice 2
          PROD 53db203d   unchanged
Backend   DEV  ff5d183    ⚠ AHEAD OF PROD — S81 slice 1
          PROD d3104ea    unchanged

⚠ THE DIVERGENCE IS DELIBERATE AND EXPECTED. S81 shipped P7 slices 1
  and 2 to DEV ONLY. Nothing was promoted to prod. Do NOT "reconcile"
  by promoting — P7 is mid-build and slice 1 is dormant until slice 4.

Trees clean both boxes at S81 close. Health 200 both. PM2 online both
(abletrace-dev / abletrace-backend). PROD IS HEALTHY.

(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  DEV frontend   www-html.bak-dev-0f4c0344a4d1     (S81, current)
  PROD frontend  www-html.bak-prod-53db203d4ef4
  DEV backend    /home/ubuntu/PackingSlips.js.bak-S81
  DEV frontend   /home/ubuntu/do-list.component.ts.bak-S81
```

## ⚠ CI HAS CHANGED — PUSH NOW AUTO-BUILDS DEV (corrected S81)

```
The old record described a manual workflow_dispatch with a prod|dev
target input. THAT IS STALE. The workflow was changed ~S79/S80:
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → still a deliberate manual dispatch.
So: git push, then just WATCH the Actions tab. Do not press Build
Frontend manually — that starts a redundant second run.
Build time observed: 6-10 minutes.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S81-verified)

```
1  [DEV]  edit + commit + push
2  WEB    github.com/Mintygadhok/abletrace-lab-frontend/actions
          wait for green (6-10 min)
3  WEB    open the run, download the artifact
          ⚠ CONFIRM the filename starts dist-dev- (rule 5.3)
4  [MAC]  ~/promote.sh ~/Downloads/<artifact.zip> dev
5  BROWSER  Cmd+Q ENTIRELY. Not a hard reload. Lazy popup chunks
          survive everything else (J66).

⚠ promote.sh lives on the MAC, not on a box. Usage:
    ./promote.sh <artifact.zip> <dev|prod>
⚠ ssh/scp always from the MAC:
    ssh -4 -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
    (the -4 is the S73 IPv6 workaround → P23)
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
5. S81 ADDED: SO-0011 · DO-0011 · PS-0006 (CANCELLED, status_id 2).
   DO-0011 is live and unallocated — a ready-made fixture for the
   slice 3 units test. FO-0004 SOH 41# (56.99 Kg).

⚠ THE GOOD FIXTURE FOR ANY UNITS WORK: test1.39 / FO-0004, 1.39 Kg per
  BS Pouch. NOT 1:1, so a division cannot hide (JT21). Use it.
⚠ FRACTIONAL FIXTURES: DO-0008 and DO-0009 both carry packing_units
  0.5 with qty_shipped 0. These are THE test rows for slice 3 — a
  0.5-unit DO has never reached a packing slip, which is the only
  reason the Math.round bug has not bitten.
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
> ⚠⚠ **P7 REMAINS THE ACTIVE JOB.** Slices 1 and 2 are DONE. Slices 3 and 4 are next and are fully specified below.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING — no full pass since S73. ▶ Minty's, one pass, at session open.

**P7  PACKING-SLIP REDESIGN — ⚠ IN BUILD. SLICES 1-2 DONE, 3-4 NEXT.**

```
SLICE 1  ✅ DONE S81 — backend, commit ff5d183 (dev only)
         Deleted the throwing inventory loop in editPackslips
         (PackingSlips.js ~line 330). Rewrote the deletedDos branch
         (~line 340) to return qty_shipped + quanity_shipped_to_date
         per DO, reading the STORED PackingSlipDOs.shipped_qty.
         ⚠ DORMANT AND UNTESTED — the buttons that reach it do not
         exist yet. Slice 4 makes it live. Test it THEN.

SLICE 2  ✅ DONE S81 — frontend, commit 0f4c0344, deployed to dev
         do-list.component.ts. Added doLotCode / doMatchKey /
         doFilterKey helpers. getSelectedDo now auto-selects every
         DO matching lot+customer+address; list filters on
         customer+address.
         VERIFIED LIVE: ticking DO-0004 auto-ticked DO-0005 and
         DO-0006 (same lot/customer/address, DIFFERENT SO — correct);
         DO-0008 stayed unticked (different lot). List 6 rows → 4.
         ⚠ THE CUSTOMER HALF IS UNPROVEN. No dev fixture has two
         different customers sharing one address, so address alone
         would have produced the same result. Not a defect — an
         evidence gap. → J93.

▶ SLICE 3 — THE UNITS FIX. START HERE IN S82.
   THE CHANGE: read the STORED packing_units instead of dividing.
   FILE 1  create-packslips.component.ts:246
           builds units as (qty_to_ship / batch_qty) * (batch_qty /
           wgt_kgs_per_unit) wrapped in Math.round — algebraically
           just qty_to_ship ÷ wgt. That is R2 acrobatics (§2 Core #1).
           ⚠ response.packing_units — the STORED figure — is ALREADY
           on the same object and used at :247. Read it, delete the
           division.
   FILE 2  edit-packslips.component.ts:245, 248, 267, 322 — same
           family. ⚠ AND :506-507 posts shipped_qty as
           shipping_order_units × wt_per_unit, which is Kg, not units.
           The two screens disagree about what the field means (J88).
           Settle both to the stored unit count.
   ⚠ WHY IT MATTERS: Math.round makes it correct TODAY only because
     no fractional DO has reached a slip. A 0.5-unit DO would round
     to 0 or 1 and SHIP A DIFFERENT QUANTITY THAN THE DO AUTHORISES.
   TEST: put DO-0008 or DO-0009 (packing_units 0.5) on a packing slip.
     Before the fix it rounds. After, the slip must carry 0.5.
     Verify in the DB, not the toast (JT12).

▶ SLICE 4 — THE SHEET AND THE BUTTONS. Makes slice 1 live.
   1  RE-ENABLE the add-DO button:
      edit-packslips.component.html:198-200 — currently COMMENTED
      OUT. It is the only caller of addItem() (ts:348), which is the
      only thing that populates shipmentList, which is the only
      source of req.body.DOs. (J86)
   2  ⚠ ADD A SAVE BUTTON. FOUND S81: /Edit-Packslips has only SHIP
      and CANCEL. No Save. So removeoldItem() fills deletedDOs but
      the ONLY way to post it is Ship — which also sets
      shipped_flag: true, terminally (J16). Remove-one-DO is
      therefore unusable today, not merely broken. → J92.
      A commit path that does NOT ship is required.
   3  THE ROW — ten fields, replacing the stacked form:
      MO Number · Internal DO Number · Customer PO No · Product ·
      Product External Code · Pdt Lot Code · Best Before ·
      Order Qty (Units) · Shipped Units (#) · Shipped Qty
      DROPPED: Product Internal Code · System SO No
      TO HEADER: Customer · Delivery Address
      ⚠ MO and DO numbers KEPT DELIBERATELY — the handles an
      operator needs when a customer phones.
      ⚠ Multi-DO already works (create-packslips :225 loops the
      array). This is PRESENTATION ONLY.
   4  PO BARCODE tabs — one per distinct SO-External across the
      moved DOs, each with a scannable barcode. ⚠ Into the PRINTED
      DOCUMENT, not the Zebra.
   5  ON SAVE: stay on the slip, show the PS number, allow more DOs
      to be moved in. Do NOT navigate back.
   6  RENAMES: popup title "Dispatch Orders" → "Select DOs to Move to
      Packing Slip"; its button "Save" → "MOVE TO PACKING SLIP".
      ⚠ Minty flagged the button wording again S81.
   7  ABSORB: the 3 remaining "Customer SO No" → "Customer PO No"
      labels · P35 (the editPackslips throw — already fixed by
      slice 1, verify when reachable) · the attach-a-doc-to-an-
      unshipped-slip file loss.

▶ NOT YET SCOPED — after slice 4:
   THE SCAN. doLotCode() (slice 2) is the hook. A scanner is a
   keyboard; it types into the search box, which already filters on
   lot code. Scan and click must be ONE function taking a LOT CODE
   with two thin callers (Minty, S80).
   THE AMBIGUITY POPUP. Only at the FIRST pick, and only when one lot
   resolves to more than one customer+address pair.
   ⚠ DOMAIN CALL STILL OPEN: should documents be attachable to a slip
   BEFORE dispatch? Minty's instinct: yes.
```

[J86 · J87 · J88 · J89 · J90 · J91 · J92 · J93]

**P1  DOCUMENTATION CONVERGENCE — ✅ DONE.** All eight sections live in the repo. ⚠ REMAINING: delete the two dead physical files → P20 (old Section J) and P22 (old Section A).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
⚠ GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY (J83). Do NOT re-derive:
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT. Every `_su` field is `<Kg> / wgt_kgs_per_unit`.
  • The Products list (admin-formulation.component.ts:878) divides SEPARATELY, and divides the OLD Kg column.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN EXISTS: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. That is R1. Copy it.
⚠ **THE TWO PACKING-SLIP SITES ARE NOW P7 SLICE 3** — do not fix them separately.
⚠ **S81 ADDED A NEW SITE TO FIND:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. Same mixed-units-on-one-row shape as JT4. Nobody has logged where it is read. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with file, line, and the stored units column that should replace it. THEN rank.
Sub-items behind the inventory: R5 display switch · MO-CREATE round-trip (add-mlo.ts:204-205, MO-0007 plan reads 50.004#) · DO/MR/intermediate-release subtract stored units · retire formulations.inventory.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 deleted; was to be deleted WITH a final snapshot. ⚠ UNVERIFIED. RDS → Snapshots. [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]". ⚠ The scan field must NOT raise a blocking alert on a bad scan. [J79, J29·JT18]

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

**P10  MASTER-RECORD FIELD UNLOCKS.** Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Also fixes My Code showing literal "null" — ⚠ SEEN AGAIN S81 on the packing slip ("Product External Code: null"). [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Needs a backend guard. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** ⚠ CONFIRMED WORSE S81 — now also holds several patch .py files and multiple dist zips. promote.sh deploys whatever zip you name. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** ⚠ Sequenced AFTER the app.abletrace.ca switch. [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed again S81. The boxes run DIFFERENT operating systems (prod 26.04 / dev 24.04.4), so a dev reboot rehearses nothing. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ `ssh -4` is the standing workaround and was needed throughout S81. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ▶ Does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value nobody reads? [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** Batch with the R5 display switch. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** ⚠ PROD GETS NO RENEWAL-FAILURE WARNING. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ Do NOT disable casually. [3B.2 · J84]

**P35  EDITING A PACKING SLIP TO ADD A DISPATCH ORDER THROWS.** ⚠ **THE BACKEND HALF WAS FIXED IN S81 SLICE 1** (loop deleted, commit ff5d183). Still UNREACHABLE and therefore UNTESTED. ▶ Verify when slice 4 restores the button; do not close until then. [§2 to-verify 5 · J85 · J86 · 3A.4]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** `PopUps/add-dispatch/` declared in edit-sales-order.module.ts:20 but never opened. ⚠ Grep for other references first. [J87]

**P37  CONFIRM THE COMPANY OF PROD SO-0004 (one query, minutes).** ⚠ Run on prod: `SELECT id, internalCode, company_id FROM somanagement WHERE internalCode='SO-0004';` If 464 → harmless. If not → real client data was touched. [Section 1 PROD RESIDUE]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** ⚠ NEW S81. The old "Add +" button and its `mat-select` lot dropdown are COMMENTED OUT in the template (html:94-111, 160-176, 223-240) but `selectOption` is STILL WRITTEN in the .ts (691-700, 810-818, 1066-1091, plus a commented block at 1104-1143). ⚠ Same JT9/JT22 decoy as P36, sitting in the exact file P6 will redesign — an edit there is an invisible no-op. Delete the dead template blocks and the orphaned .ts writes. [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ NEW S81, but the finding is older — it was left as a closing note inside J85 and tracked nowhere. ⚠ FOOD-SAFETY-CRITICAL: JT8 says never two COLLECTION associations in one nestedPop populate array; v0.1.4 silently returns the SECOND one EMPTY. That bug hid missing intermediates once already (S55). Sites: Formulations.js lines 609, 632, 1063. ▶ Read each, confirm no two collections share a populate array. [§2 to-verify 1 · JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP IS UNUSABLE.** ⚠ NEW S81. Backend FIXED in slice 1. The FRONTEND has no commit path: /Edit-Packslips offers only SHIP and CANCEL, and `save()` sets `shipped_flag: true` unconditionally — so the only way to post `deletedDos` is to ship the slip. ▶ Owned by P7 slice 4 (needs a Save that does not ship). Logged separately so the defect has its own record. [J92]

**P41  WRITE THE RULE INTO SECTION 2 — a DO coming off a slip always returns its quantity.** ⚠ NEW S81. Minty's decision. ⚠ DO NOT add a new standalone rule: §2 Core #2 already says "reverse walks back one bucket at a time, cancel logic already exists there" — a sentence that is TRUE of cancel-whole-slip and quietly FALSE of remove-one, which is part of why this sat broken. ▶ REISSUE that existing Core #2 sentence WHOLE with the decision folded in (rule 7.1). Two rules for one hop is how a document goes two-headed (9E). [J92]

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG.** ⚠ NEW S81. ⚠ DO NOT
START UNTIL P7 IS CLOSED — P7 is actively generating J-entries
(slices 3 and 4 will add more), and splitting a file mid-append is
the worst moment. Section 5 is ~2000 lines and append-only, so it
only ever grows. WHY: the JT traps block is short and worth reading
EVERY session (rule 1.4); the J-entry log is long and rarely needed
in full. Loading both costs context that buys nothing most sessions.
▶ THE SPLIT: Section 5A = JT traps + JR rebuild checklist (short,
standing paste). Section 5B = the J-entries (fetched by name, e.g.
"send me J78"). ⚠⚠ J-NUMBERS ARE PERMANENT AND MUST NOT CHANGE —
they are cross-referenced from Sections 1, 2 and 3A (J88 alone is
cited in four places). A split that renumbers anything breaks every
pointer in the repo. ⚠ Also update rule 0.3's standing-paste list
and rule 9's structure block to name 5A and 5B.
> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good (P26 was "Fix A", a fix for a bug that never existed — J81). P28 CLOSED S79.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
P7 slices 1 and 2 — dev only, deliberately NOT promoted to prod
until P7 is whole and tested end to end.
```

**END SECTION 1**
