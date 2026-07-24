# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE. One fact, one home, decided by how often it changes.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S85 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S84 — TWO FIXES SHIPPED AND PROVEN IN THE DB.
               D2 (add-a-DO threw) FIXED. The 500 on Save FOUND
               AND FIXED. D1 (create double-count) DISPROVEN.
               P7 SCOPE CUT DOWN by three Minty decisions.
THIS SESSION   S85 — STEP 3: verify CANCEL end to end on clean
               fixtures. Then slice 4b, the row template.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5/6) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. If a fetch looks stale, ask
            Minty to PASTE the section rather than re-fetching.

▶▶ THE NEXT JOB — S85. CANCEL VERIFICATION FIRST (one clean run,
   30 minutes), THEN slice 4b. ⚠ Do not start 4b until cancel is
   proven — it is the last untrusted quantity path. ◀◀

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; its STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    packing_units = 0.5 is CORRECT. → J88. PROVEN LIVE S82 (J94).
  • A DO coming off a packing slip ALWAYS returns its quantity and becomes
    available again — whether one DO or all of them (Minty, S81). → J92.
  • SLICE 2's POPUP BEHAVIOUR IS CORRECT. Auto-tick keys on lot+customer+
    address; the LIST filters on customer+address only. → J99.
    ⚠ RE-PROVEN LIVE S84 on a fresh build: clicking DO-0004 auto-ticked
      DO-0005/0006 (same lot) and left DO-0008 (different lot) untouched.
  • THE PACKING SLIP FLOW (Minty, S82): move DOs → SAVE → enter shipping
    reference + vehicle condition → SHIP (terminal). Cancel available
    until Ship, never after. → J97.
  • ⚠ NEW, S84 — SHIPPED QUANTITY IS NOT AN OPERATOR INPUT. It is the
    DO's quantity, carried through unchanged. No partial ship, no
    over-ship. To change what goes out: CANCEL the DO and raise a fresh
    one. (Minty, S84.) The OLD APP confirms it — its packing slip row
    has no Shipped Units / Shipped Qty fields at all, only Order Qty.
    ▶ Belongs in Section 2 — fold with P41.
  • ⚠ NEW, S84 — THE RECONCILE ORACLE. A DO's qty_shipped must ALWAYS
    equal the sum of its packingslipdos rows. One query tests it (block
    below). Run it after every quantity change. Empty = clean.
```

---

## ⚠⚠ P7 — WHAT IS LEFT. REVISED S84.

```
⚠ P7 LOST TWO STEPS IN S84 AND IS NOW TWO SESSIONS FROM DONE.

STEP 1  ✅ DONE S84 — test 4a. D2 fixed, the 500 fixed, D1 disproven.

STEP 2  ✅ DONE S84 — see the S84 RESULTS block below.

STEP 3  ⚠ CANCEL VERIFICATION.  ← S85 STARTS HERE
        One clean run on reconciled fixtures. Create a slip with two
        or more DOs → cancel it → EVERY DO returns its exact per-slip
        quantity and the oracle stays empty.
        ⚠ THIS IS NOW THE PRIME SUSPECT — see the S84 RESULTS block.

STEP 4  SLICE 4b — THE ROW TEMPLATE. The main remaining build.
        THE WHOLE DO ROW MOVES AS ONE UNIT into a new template.

        ⚠ THE TEN FIELDS, IN ORDER — this IS the spec:
           1  MO Number                moNumber
           2  Internal DO Number       internal_dispatch_order_num
           3  Customer PO No           sales_order_num_system  ⚠ rename
           4  Product                  product
           5  Product External Code    productExternalCode
           6  Pdt Lot Code             moStartDate   ⚠ misnamed, P48
           7  Best Before              bestBefore
           8  Order Qty (Units)        shipment_product_order_qty
           9  Shipped Units (#)        shipping_order_units  READ-ONLY
          10  Shipped Qty              shipping_order_qty    READ-ONLY
        ⚠ ALL TEN ARE CARRIED BY THE PICKER ALREADY — proven S84 by
          reading create's patchValue. No backend change needed.
        ⚠ MO and DO numbers KEPT DELIBERATELY — the handles an
          operator needs when a customer phones.

        · DROP  Product Internal Code · System SO No
        · REMOVE Customer + Delivery Address from the ROW — they
          already exist as header fields. ⚠ HALF DONE ALREADY:
          both are COMMENTED OUT on the existing-DO row (html 42-58).
        · RESTORE Shipped Units (#) + Shipped Qty on existing-DO rows
          (commented out, html 102-112) — ⚠ AS READ-ONLY DISPLAY,
          not inputs (Minty, S84).
        · RENAME "Customer SO No" -> "Customer PO No"
          ⚠ THE CONTROL IS sales_order_num_system, NOT sales_order_num.
            The names lie; the LABELS are right. → P48.
        · ADD a QUANTITY to the DO picker, stacked under Pdt Lot Code
          (Minty, S84 — no mirroring, the modal is narrow on his screen)
        ⚠ THE DATE PICKER MUST SURVIVE. Verify after the rebuild. (J97.)
        ⚠ POPUP BUTTON ALREADY RENAMED S84 — "MOVE TO PACKING SLIP",
          live and verified. Only the popup TITLE is still outstanding.

STEP 5  PROMOTE TO PROD.
        ⚠ BACKEND FIRST, THEN FRONTEND. Deployed the other way round,
          SHIP silently stops shipping until the frontend lands (J96).

CUT FROM P7 IN S84 — MINTY'S DECISIONS, DO NOT REINSTATE
        · SLICE 4c / the sequencing change — CUT. 4a already delivers
          the flow (add → Save → shipping fields → Ship). "Ready to
          Ship" was a second name for what the screen does.
          ⚠ This removed the only DB column left in P7.
        · THE PO BARCODE — OUT of P7, held as its own feature. → P47.
          It was never designed; nobody had decided what it encodes.

AFTER P7, NOT PART OF IT
        P43  multiple invoices / QuickBooks child table
        The scan · the ambiguity popup · documents-before-dispatch
```

---

## ⚠⚠ S84 RESULTS — READ BEFORE TOUCHING THE QUANTITY PATHS

```
D2  ✅ FIXED AND PROVEN.  commit d223d6ed
    The picker ALWAYS closes with an ARRAY — do-list.component.ts
    addFirstItem() (:50-52) and save() (:54-55) BOTH close with
    selectedItem, declared [] at :24.
    ⚠ THE S83 HANDOVER WAS WRONG on the reason: it claimed
      addFirstItem returns an OBJECT and only tick+Save returns an
      array. BOTH return arrays; BOTH gestures were broken.
    Fix = mirror create's result.forEach, patch at (index + i), push
    a row for each DO beyond the first.
    PROVEN: added DO-0012 to a saved slip, row populated, no throw.

THE 500 ON SAVE  ✅ FOUND AND FIXED.  commit c3d463c9
    NEW defect, surfaced only because D2 unblocked the path.
    Sails: "shipped_qty ... Specified value (a string: '') doesn't
    match the expected type: 'number'".
    The handler patched shipping_order_units: '' and nobody typed it.
    Fix = pre-fill from response.packing_units (Minty's rule above).
    PROVEN: PS 2397 wrote three join rows, shipped_qty 1 each.

D1  ⚠ DISPROVEN ON THE CREATE PATH. DO NOT RE-DERIVE.
    Clean experiment S84, reconciled fixtures, fresh build:
      clicked DO-0004        -> shipped_qty 1, tally 1  CORRECT
      auto-ticked DO-0005    -> shipped_qty 1, tally 1  CORRECT
      auto-ticked DO-0006    -> shipped_qty 1, tally 1  CORRECT
    The clicked DO incremented ONCE, exactly like the auto-ticked
    ones. The S83 claim that the clicked DO double-counts on create
    IS NOT REPRODUCIBLE.
    ⚠ WHY S83 SAW IT: its evidence was gathered on DIRTY fixtures,
      after cancels, with no baseline. Same trap as the S75 lesson.

⚠ THE REMAINING SUSPECT IS CANCEL, NOT CREATE.
    Every DO whose history is create-only reconciles.
    The ONE bad number left belongs to DO-0010 (tally 2, rows 1) —
    and DO-0010's history includes a CANCEL.
    ⚠ UNEXPLAINED: DO-0011 went through the SAME cancel on the SAME
      slip and came out CORRECT. Why one and not the other is the
      open question. → S85 STEP 3.
    ⚠ CANCEL DOES DELETE ITS JOIN ROWS — the packingslipdos id
      sequence has gaps exactly where the cancelled slips were. What
      it does with the DO's own tally is the untrusted half.
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  DEV  c3d463c9   ⚠ AHEAD OF PROD — S81 s2, S82 s3+4a, S83 cancel,
                            S84 D2 + pre-fill
          PROD 53db203d   ⚠ NOT VERIFIED SINCE S82 — see below
Backend   DEV  083fc96    ⚠ AHEAD OF PROD — S81 s1, S82 s4a + guard
          PROD d3104ea    ⚠ NOT VERIFIED SINCE S82 — see below

⚠ PROD WAS NOT HEALTH-CHECKED IN S83 OR S84. Nothing was promoted in
  S81/S82/S83/S84 so it SHOULD be untouched — but that is an
  expectation, not a reading. ▶ CHECK PROD FIRST THING IN S85
  (rule 1.1 wants BOTH boxes named).

⚠ THE DIVERGENCE IS DELIBERATE. Do NOT "reconcile" by promoting —
  P7 is mid-build.

S84 COMMITS, in order:
  frontend  d223d6ed  D2: edit doList loops the picker array;
                      picker button -> MOVE TO PACKING SLIP
  frontend  c3d463c9  shipped units pre-fill from the DO quantity
                      (fixes the 500 on Save)

Dev tree clean at S84 close. Dev health 200. PM2 online (abletrace-dev).

(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  DEV frontend   www-html.bak-dev-<prior>          (pre-S84 promote)
  PROD frontend  www-html.bak-prod-53db203d4ef4
  DEV frontend .ts  /home/ubuntu/edit-packslips.component.ts.bak-S84-*
                    /home/ubuntu/edit-packslips.component.ts.bak-S84b-*
  DEV backend    /home/ubuntu/PackingSlips.js.bak-S82
  DEV backend    /home/ubuntu/PackingSlips.js.bak-S81
```

## ⚠ CI — PUSH AUTO-BUILDS DEV

```
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → still a deliberate manual dispatch.
Build time observed S84: 8-9 minutes.
⚠ CI warns "Node.js 20 is deprecated" on every build. Housekeeping,
  not our code. Not yet queued — raise it if a build ever fails.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S84-verified)

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
⚠ NAME THE RIGHT ZIP. S84 ended with THREE dist-dev- zips in
  ~/Downloads and promote.sh deploys whatever you name — an older
  one silently undoes the newest fix. → P12.
⚠ THE ARTIFACT DOES NOT ALWAYS DOWNLOAD ON THE FIRST CLICK (S82/S84).
  Check with: ls -lt ~/Downloads | head -5
```

## ⚠ HANDING PATCH SCRIPTS TO MINTY — the scp route. WORKED AGAIN S84.

```
⚠ PASTING LONG PATCH SCRIPTS INTO THE TERMINAL FAILS. Cause unknown,
  two theories disproven S82. → P46.

⚠ THE WORKING METHOD, USE IT BY DEFAULT FOR ANY PATCH SCRIPT:
    1  Claude writes the patch and hands it over as a FILE (rule 0.2b)
    2  [MAC]  scp -i ~/.ssh/abletrace-lab-key.pem ~/Downloads/<patch>.py ubuntu@16.55.10.205:/tmp/
    3  [DEV]  python3 /tmp/<patch>.py
    4  [DEV]  git --no-pager diff
  Two patches went through cleanly this way in S84.

⚠ MINTY MUST DOWNLOAD THE FILE BEFORE THE scp. S84 lost a round trip
  to "No such file or directory" — the link had been shared but never
  clicked. Confirm with: ls -lt ~/Downloads | head -3

⚠ THE BOX LABEL GOES ABOVE THE BLOCK, NEVER INSIDE IT. S84: a "[DEV]"
  line pasted inside a command block ran as a command and failed.

⚠ SHORT COMMANDS PASTE FINE. Only long multi-line scripts fail.
```

## ⚠ THE TWO STANDING QUERIES — build a temp cnf from .env (J43)

```
A bare `mysql` on dev hits a nonexistent local socket. Both blocks
below are ONE PASTE each and self-clean.

⚠ THE RECONCILE ORACLE — run after EVERY quantity change. Empty = clean.

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "SELECT d.id, d.internalCode, d.qty_shipped AS tally, COALESCE(SUM(p.shipped_qty),0) AS notes FROM dispatchorders d LEFT JOIN packingslipdos p ON p.DO_id=d.id GROUP BY d.id, d.internalCode, d.qty_shipped HAVING d.qty_shipped <> COALESCE(SUM(p.shipped_qty),0);"
rm -f /tmp/q.cnf

GENERAL QUERY — same recipe, swap the SQL:

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "<QUERY>"
rm -f /tmp/q.cnf

⚠ THE JOIN TABLE IS packingslipdos — ALL LOWERCASE. Dev MySQL is
  case-sensitive on table names. The S83 handover wrote
  "PackingSlipDOs" and that name DOES NOT EXIST. → P48.
```

## DEV FIXTURE RESIDUE — ⚠ RECONCILED S84. This is the clean baseline.

```
⚠ THE ORACLE WAS RUN AND CAME BACK EMPTY EXCEPT DO-0010 (see below).
  Everything else in every company reconciles.

1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
2. MAT-6 missing its Sesame allergen       (S73 → P24)
3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)

4. S84 RESET — four DO tallies corrected to match their join rows:
     DO-0004 3->0 · DO-0005 3->0 · DO-0010 4->1 · DO-0011 2->1
   ⚠ DO-0010 has since drifted AGAIN to 2 (rows say 1). LEFT AS IS
     DELIBERATELY — it is the live evidence for the cancel bug.
     Do NOT reset it until S85 STEP 3 has read it.

5. LIVE SLIPS at S84 close (all company 464, none shipped):
     PS 2389  DO-0008 @ 0.5     the fractional proof row (J94)
     PS 2393  DO-0009 @ 0.5     the second fractional row
     PS 2397  DO-0010, DO-0011, DO-0012 @ 1 each
     PS 2398  DO-0004, DO-0005, DO-0006 @ 1 each   (the D1 experiment)

6. FREE DOs in 464 at S84 close:  DO-0007 · DO-0008(no) — ⚠ RE-QUERY
   BEFORE TESTING rather than trusting this line; it ages fastest.

7. Eight slips are CANCELLED (status_id 2): PS-0005 · 0006 · 0007 ·
   0009 · 0010 · 0011 · 0013 · 0014. All have NO join rows.
   ⚠ CORRECTED S84: the old record said PS-0010 CARRIES DO-0004/5/6.
     It was cancelled; those DOs are free. The record was stale.

⚠ CORRECTED S84: the old record said DO-0009 was "STILL FREE and the
  remaining fractional test row". It sits on PS 2393. Not free.
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
> ⚠⚠ **P7 REMAINS THE ACTIVE JOB.** Slices 1, 2, 3, 4a DONE and PROVEN. Cancel verification then 4b.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING — no full pass since S73. ▶ Minty's, one pass, at session open.

**P7  PACKING-SLIP REDESIGN — ⚠ IN BUILD. 1·2·3·4a DONE AND PROVEN. CANCEL VERIFY, THEN 4b.**

```
SLICE 1  ✅ DONE S81 — backend ff5d183. deletedDos returns qty from the
         STORED PackingSlipDOs row. ⚠ STILL NOT INDEPENDENTLY VERIFIED.
         → S85 STEP 3.

SLICE 2  ✅ DONE S81 — frontend 0f4c0344. DO auto-select by
         lot+customer+address. ⚠ RE-PROVEN LIVE S84 on a fresh build.
         The CUSTOMER half remains unproven — no fixture has two
         customers at one address. → J93.

SLICE 3  ✅ DONE AND VERIFIED S82 — frontend 897096b4. Five sites read
         stored packing_units instead of dividing Kg by unit weight.
         → J94. ⚠ ONE SITE LEFT: edit's save() write. Fixed in 4a. → J95.

SLICE 4a ✅ DONE AND PROVEN S84. Shipped S82 (2d22e5a, db415d74,
         083fc96), tested S83-S84.
         · Save no longer stamps shipped_flag / shippingdate /
           finalShipmentUserId. Ship does. → J96.
         · shipped_qty posts the UNIT COUNT, not units x weight. → J95.
         · "Add Dispatch order +" restored, Save button added, Ship
           gated on both shipping fields.
         ⚠ TWO DEFECTS FOUND BEHIND IT AND BOTH FIXED S84 — D2 and the
           500 on Save. See the S84 RESULTS block.

SLICE 4b ▶ THE ROW TEMPLATE. THE NEXT BUILD. Detail in the P7 block
         above (STEP 4). Smaller than it was — the barcode is out, the
         Customer/Address removal is half done, the popup button is
         already renamed, and Shipped Units/Qty become READ-ONLY
         display rather than validated inputs.
```

[J86 · J87 · J88 · J89 · J90 · J91 · J92 · J93 · J94 · J95 · J96 · J97 · J98 · J99]

**P1  DOCUMENTATION CONVERGENCE — ✅ DONE.** All eight sections live in the repo. ⚠ REMAINING: delete the two dead physical files → P20 (old Section J) and P22 (old Section A).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
⚠ GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY (J83). Do NOT re-derive:
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT. Every `_su` field is `<Kg> / wgt_kgs_per_unit`.
  • The Products list (admin-formulation.component.ts:878) divides SEPARATELY, and divides the OLD Kg column.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN EXISTS: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. That is R1. Copy it.
⚠ **THE PACKING-SLIP SITES ARE DONE** — S82 closed five (897096b4) plus edit's write (db415d74). → J94, J95.
⚠ **S84 FOUND TWO MORE, IN THE FILE WE WERE ALREADY IN:**
  edit-packslips.component.ts:245 and :299 both compute
  `qty_to_ship / wgt_kgs_per_unit` — Kg divided by weight to rebuild a
  unit count. R2, textbook acrobatics. On a 0.5-unit DO this produces
  float garbage. ⚠ AND THE TWO ROW BUILDERS DISAGREE: :274 seeds the
  field from `shipment_order_units` (the stored count) while :329 seeds
  it from that division. Same field, two sources, one file.
⚠ **S81 ADDED A SITE TO FIND:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with file, line, and the stored units column that should replace it. THEN rank.
Sub-items behind the inventory: R5 display switch · MO-CREATE round-trip (add-mlo.ts:204-205) · DO/MR/intermediate-release subtract stored units · retire formulations.inventory.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91 · J94 · J95]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 deleted; was to be deleted WITH a final snapshot. ⚠ UNVERIFIED. RDS → Snapshots. [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. ⚠ S84 NOTE: the packing-slip alerts surface only the HTTP status ("500 Internal Server Error") — the real message was in pm2 logs. The alert is not useless but it is not diagnostic. [J79, J29·JT18]

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
  transfers to P6/P7 is the SHAPE — not the matching logic.
⚠ DEAD CODE IN THIS FILE → P38.
```
[3A.3 · J89]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it. ⚠ Reading a frontend file from prod's checkout shows code that is NOT LIVE. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Also fixes My Code showing literal "null". ⚠ S82 FOUND THE MECHANISM: FormData stringifies blanks so the four-letter string 'null' reaches the backend. → J98. ⚠ SEEN AGAIN S84 on the packing slip row ("Product External Code" blank/null). [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Needs a backend guard. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** ⚠ WORSE AGAIN S84 — now holds THREE dist-dev zips and four patch .py files. promote.sh deploys whatever zip you name; an older one silently undoes the newest fix. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** ⚠ Sequenced AFTER the app.abletrace.ca switch. [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed again S84 on every dev login. The boxes run DIFFERENT operating systems (prod 26.04 / dev 24.04.4), so a dev reboot rehearses nothing. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ `ssh -4` is the standing workaround and was needed throughout S84. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ▶ Does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value nobody reads? [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** Batch with the R5 display switch. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** ⚠ PROD GETS NO RENEWAL-FAILURE WARNING. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ Do NOT disable casually. [3B.2 · J84]

**P35  ✅ CLOSED S84 — EDITING A PACKING SLIP TO ADD A DISPATCH ORDER NO LONGER THROWS.** Backend fixed S81 (ff5d183), button restored S82 (4a), the array-shape throw fixed S84 (d223d6ed), and the 500 behind it fixed S84 (c3d463c9). PROVEN: DO-0012 added to a saved slip, join row written, quantity correct. ▶ DELETE THIS LINE at S85 open once Section 5 carries the stamped entry (rule 7.6). [§2 to-verify 5 · J85 · J86 · 3A.4]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** `PopUps/add-dispatch/` declared in edit-sales-order.module.ts:20 but never opened. ⚠ CONFIRMED S84: both create and edit open DoListComponent (create :213, edit :466). Neither touches add-dispatch or add-dispatch-v2. ⚠ Grep for other references first. [J87]

**P37  CONFIRM THE COMPANY OF PROD SO-0004 (one query, minutes).** ⚠ Run on prod: `SELECT id, internalCode, company_id FROM somanagement WHERE internalCode='SO-0004';` If 464 → harmless. If not → real client data was touched. [Section 1 PROD RESIDUE]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** ⚠ Commented out in the template (html:94-111, 160-176, 223-240) but `selectOption` is STILL WRITTEN in the .ts (691-700, 810-818, 1066-1091, plus a commented block at 1104-1143). ⚠ Same JT9/JT22 decoy as P36, in the exact file P6 will redesign. [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ FOOD-SAFETY-CRITICAL: JT8 says never two COLLECTION associations in one nestedPop populate array. Sites: Formulations.js lines 609, 632, 1063. ▶ Read each, confirm no two collections share a populate array. [§2 to-verify 1 · JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP.** ⚠ The frontend half was fixed S82 (4a) and the backend half S81 (ff5d183). ⚠ STILL UNTESTED — S84 tested ADD, not REMOVE. ▶ Fold into S85 STEP 3; the cancel run exercises the same deletedDos path. [J92 · J96]

**P41  WRITE THE SETTLED RULES INTO SECTION 2 — ⚠ NOW THREE EDITS, ONE PASS.**
  1. A DO coming off a slip ALWAYS returns its quantity (Minty S81). ⚠ DO NOT add a standalone rule: §2 Core #2 already says "reverse walks back one bucket at a time, cancel logic already exists there" — true of cancel-whole-slip, quietly FALSE of remove-one. ▶ REISSUE that sentence WHOLE with the decision folded in (rule 7.1).
  2. The three-step flow (move → save → ship) is settled domain logic (S82).
  3. ⚠ NEW S84 — SHIPPED QUANTITY IS NOT AN OPERATOR INPUT. It is the DO's quantity carried through; to change it, cancel the DO and raise a fresh one. The OLD APP corroborates: its packing slip row has no Shipped Units / Shipped Qty fields at all.
[J92 · J97]

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG.** ⚠ DO NOT START UNTIL P7 IS CLOSED — P7 is actively generating J-entries and splitting a file mid-append is the worst moment. ▶ THE SPLIT: Section 5A = JT traps + JR rebuild checklist (short, standing paste). Section 5B = the J-entries (fetched by name). ⚠⚠ J-NUMBERS ARE PERMANENT. ⚠ Also update rule 0.3's standing-paste list and rule 9's structure block.

**P43  SHIPPING REFERENCE → MULTIPLE INVOICES, QUICKBOOKS-READY.** Today `packingslips.vehicle_no` is ONE text column holding a single reference. Minty needs SEPARATE fields for multiple invoice documents.
⚠ **DESIGN DECIDED, BUILD DEFERRED: a CHILD TABLE (one row per invoice), NOT delimited text.** All Minty's clients run QuickBooks and the invoice number will likely need to match a QuickBooks record.
⚠ **OPEN QUESTION, ASK FIRST:** are invoices raised in QuickBooks BEFORE or AFTER the slip ships? If after, the field must be fillable post-ship — which breaks "Ship is terminal" and is a DOMAIN decision.
⚠ DB CHANGE → rule 4.8. [§2 GR7 vehicle_no · 3A.4 · J97]

**P44  editPackslips NEVER WRITES vehicle_condition.** ⚠ PRE-EXISTING, not caused by S82. The edit PSOBJ sets only `vehicle_no` and `remarks` (plus the ship fields when shipping). ⚠ MATTERS MORE NOW: 4a made that dropdown editable and gated SHIP on it, so an operator can pick a condition, ship, and have it silently discarded. ▶ Add `vehicle_condition` to the edit PSOBJ with the same blank-guard as createPS. [J98]

**P45  ⚠ REISSUED S84 — THE RECORD WAS BACKWARDS. THE FRAGILE GUARD IS ON CREATE, NOT EDIT.**
The old text said edit had no over-ship guard and that a dead string-parsing guard had been deleted. Both wrong.
```
EDIT    HAS a guard, and it is the CORRECT kind:
        Validators.max(shipment_order_units) — a raw stored number,
        no parsing. (edit-packslips.component.ts ~:514)
CREATE  STILL PARSES A DISPLAY STRING by position:
        :169  caps qtyShip at   shipment_product_order_qty.split(' ')[0]
        :265  min AND max at    ...split(' ')[3]   <- an EQUALITY LOCK
        :296  reads             ...split(' ')[0]
```
⚠ THE EQUALITY LOCK AT :265 IS MINTY'S RULE, WRITTEN IN CODE — shipped units must equal ordered units exactly. Someone built it deliberately.
⚠ AND S82's SLICE 3 BROKE IT. Create's string was flipped from "20.000 Kg ( 1 # )" to "1 # ( 20.000 Kg )", so [3] now returns the Kg figure. On a 1-unit DO the lock demands the units box equal 20.000. Nobody touched that line, so nobody could have seen it. → P49.
▶ **THE FIX IS NOW SMALLER THAN THE PROBLEM.** Under the read-only rule the field is never typed, so the parsing and both validators can be DELETED rather than repaired. Do it in 4b.
⚠ STILL UNPROVEN: whether edit applies its guard to rows on LOAD or only to rows added via the popup; and whether an invalid form actually blocks Save. [J95]

**P46  TERMINAL PASTE TRUNCATION — INVESTIGATE, DO NOT KEEP GUESSING.** Long patch scripts pasted into the SSH session were truncated or scrambled 6+ times in S82, always cutting at the same content. ⚠ TWO THEORIES PROPOSED AND BOTH DISPROVEN: "paste size" and "stale window state". ⚠ SEEN AGAIN S84 — a long multi-statement mysql block scrambled its last two lines mid-paste. ⚠ THE WORKAROUND WORKS AND IS THE DEFAULT: hand scripts over as FILES, scp them across, run from /tmp. ▶ When someone has ten minutes: try a large paste in a fresh window that has run only simple commands, then again after a pager command. Rule 0.1a. [Section 0 rule 8]

**P47  ⚠ NEW S84 — PO BARCODE ON THE PRINTED PACKING SLIP.** Removed from P7 scope (Minty, S84) and held as its own feature. One tab per distinct SO-External across the moved DOs, each with a scannable barcode, into the PRINTED DOCUMENT — not the Zebra. ⚠ **NOT DESIGNED. DECIDE WHAT THE BARCODE ENCODES BEFORE ANY CODE IS WRITTEN.** That decision is the whole blocker; it is a five-minute domain call, not a build.

**P48  ⚠ NEW S84 — NAMING DEFECTS. Cheap individually, expensive in aggregate — every one of them is a wrong-field-read waiting to happen.**
```
moStartDate               holds a LOT CODE, not a date
sales_order_num           holds the SYSTEM SO   (labelled "System SO No")
sales_order_num_system    holds the CUSTOMER's ref ("Customer SO No")
                          ⚠ the "_system" one is the CUSTOMER's. Renaming
                            the wrong control puts the system SO on the
                            customer's document.
shipment_order_units  vs  shipping_order_units
shipment_product_order_qty vs shipping_order_qty
                          four controls differing by shipment/shipping
"MO Lot Code" (DO screen) vs "Pdt Lot Code" (everywhere else)
                          SAME THING, two captions (Minty confirmed S84)
"PackingSlipDOs"          the table is packingslipdos, all lowercase.
                          Dev MySQL is case-sensitive; the docs' name
                          does not exist and any copied SQL fails.
```
▶ Rename the CAPTIONS freely (safe). ⚠ Renaming CONTROLS touches form bindings, patchValue keys and the payload — treat as its own careful pass, not a tidy-up.

**P49  ⚠ NEW S84 — THE QUANTITY STRING IS BUILT TWO WAYS, AND IT BROKE A VALIDATOR.**
```
CREATE   `${packing_units} # ( ${qty_to_ship} ${unit} )`  ->  "1 # ( 20.000 Kg )"
EDIT     `${qty_to_ship} ${unit} ( ${packing_units} # )`  ->  "20.000 Kg ( 1 # )"
```
Same form control, opposite order. CREATE reads numbers back out of that string BY POSITION (P45), so flipping the format silently changed what three lines enforce. ⚠ **A COMMIT THAT TOUCHED DISPLAY CHANGED WHAT A VALIDATOR ENFORCES, IN CODE NOBODY OPENED.** ⚠ NOT PROVEN: git blame has not been run; S82 slice 3 is the plausible author, not a confirmed one. ▶ Fix by deleting the parsing (see P45), and make both screens build the string identically.

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good (P26 was "Fix A", a fix for a bug that never existed — J81). P28 CLOSED S79. P35 CLOSED S84.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
P7 slices 1, 2, 3, 4a + the S83 cancel fix + the S84 D2 and pre-fill
fixes — dev only, deliberately NOT promoted to prod until P7 is whole
and tested end to end.
⚠ CANCEL IS STILL UNVERIFIED. Promoting now would be a rule 5.5
  violation.
```

**END SECTION 1**
