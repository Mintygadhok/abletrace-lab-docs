# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE. One fact, one home, decided by how often it changes.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S81 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S80 — the DO → PACKING SLIP WALK. Read-only on the
               app; one DO created on dev and one on prod (see
               RESIDUE below). NO APP CODE TOUCHED.

THIS SESSION   S81 — finish the reads, then BUILD P7. The domain
               call is MADE and the design is settled (see P7).

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5/6) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. Do NOT conclude "it didn't
            commit" from a stale fetch. (Learned S76.)

WHAT S80 DID — do not re-derive any of it.

  ✓ 3A.4 WALKED for real: /Edit-SO → Create DO popup → /Dispatch-orders
    → Create Packing Slip → DO-select popup → /Create-Packslips.
    Fixture test1.39 / FO-0004 at 1.39 Kg per BS Pouch — deliberately
    NOT 1:1, per JT21.
  ✓ P35 SETTLED — UNREACHABLE. → J86.
  ✓ THE P7 DOMAIN CALL IS MADE. Ten fields, listed in P7 below.
  ✓ THE SEQUENCING DECISION IS MADE: bundle, do not split. → P7.
  ✓ THE EXISTING SELECTION LOGIC FOUND AND READ (do-list.component).
    P7 is an EXTENSION of it, not a new build. → J87.
  ✓ qty_shipped VERIFIED UNITS-CLEAN against dev DB → J88.
  ✓ "ACROBATICS" adopted as standing vocabulary → §2 Core #1.
  ✓ add-dispatch (v1) found DEAD → P36.

▶▶ THE NEXT JOB — S81. P7 IS NOW THE TOP PRIORITY (Minty, S80). ◀◀
   1  READ MO-RELEASE GLOBAL SELECT (P6 says do this BEFORE designing;
      it is still unread). /Release-mat-details +
      MaterialsProductsReleased.js
   2  READ editPackslips + InActivatePs whole (PackingSlips.js:180-431).
      Settles the remove-one-DO question and the cancel/return path.
   3  THEN build P7.

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; its STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    packing_units = 0.5 is CORRECT. Do not add an integer guard. → J88.
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  53db203d — DEV + PROD in sync
Backend   d3104ea  — DEV + PROD in sync
Trees clean. Health 200 both boxes. PM2 online both (abletrace-dev /
abletrace-backend). PROD IS HEALTHY.
⚠ VERIFIED LIVE ON BOTH BOXES AT S80 OPEN.

(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  www-html.bak-prod-53db203d4ef4
  www-html.bak-dev-53db203d4ef4

⚠ NO APP CODE TOUCHED IN S73, S75, S76, S77, S78, S79 OR S80 — all
walk / documentation / verification sessions. Boxes have been at these
HEADs since S71.
```

## DEV FIXTURE RESIDUE — ⚠ note before reusing company 464 as a baseline

```
1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
2. MAT-6 missing its Sesame allergen       (S73 → P24)
3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)
4. DO-0010 + PS-0005 created on SO-0009 (test1.39/FO-0004)  (S80)

⚠ ALSO: 464's testpdt260703 runs at 20 Kg per shipping unit and some
  test products run at 1 Kg per unit. A 1:1 ratio makes a division
  INVISIBLE and is what produced J80's false display finding. Do NOT
  verify any units↔Kg path on a 1:1 fixture. USE test1.39 / FO-0004
  (1.39 Kg per BS Pouch) — S80 proved it exposes the arithmetic.
  (JT21 · J83)
```

## ⚠ PROD RESIDUE — S80

```
DO-0006 was created on PROD (trace.mintekfoodsafety.com) against
SO-0004, customer "Jade 3", product testpdt260703 / FO-0001-4,
1# (20 Kg), lot Pdt-260701-1.
⚠ CREATED IN ERROR — the walk was meant to be on dev. Caught and the
  walk moved to dev immediately; nothing further was done on prod.
⚠ The fixture is the 464 sandbox family, so it is almost certainly
  sandbox data — but the company_id was NEVER CONFIRMED. One query
  settles it:
    SELECT id, internalCode, company_id FROM somanagement
    WHERE internalCode='SO-0004';
  → tracked as P37. Recorded here so a future session does not meet
  an unexplained prod DO row and mistake it for client data.
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠⚠ **P7 TAKES PRECEDENCE OVER EVERYTHING ELSE IN THIS LIST.** Minty's call, S80. The DO → packing-slip redesign is the active job: it is designed, the domain call is made, and the code addresses are recorded (J86 · J87 · J88). ⚠ P7 KEEPS ITS NUMBER — **the list is ordered by PRIORITY, and a P-number is a permanent ID, not a position**, exactly as J-numbers are. Do NOT renumber the queue to put it first; Section 5 entries point at these numbers.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING. Only ONE decision has been made (P7 to the front). The queue has not had a full pass since S73 and several items changed shape in S79 and S80. ▶ Minty's, one pass, at session open.
> ⚠ Each line points at its Section-5 entry. EVIDENCE lives there, not here.

**P1  DOCUMENTATION CONVERGENCE — THE FOLD.** ⚠ MINTY-SET, S73.
- ✅ **DONE.** All eight sections (0, 1, 2, 3A, 3B, 4, 5, 6) converted and live in the repo. Section 4 was built S79/S80.
- ⚠ REMAINING: delete the two dead physical files → P20 (old Section J) and P22 (old Section A).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ MINTY-SET, S73. ⚠ A CAMPAIGN, NOT A FIX (re-scoped S79).

⚠ **GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY.** Full evidence in J83. Do NOT re-derive:
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT. Every `_su` field is `<Kg> / wgt_kgs_per_unit`.
  • The Products list (admin-formulation.component.ts:878) divides SEPARATELY, and divides the OLD Kg column.
  • ⚠ SCALE: ~30+ division sites. Many disguise it as `(qty / batch) * (batch / wgt)` — algebraically identical.
  • ⚠ THE CORRECT PATTERN ALREADY EXISTS: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. That is R1. Copy it.

⚠ **S80 ADDED TWO SITES, BOTH IN THE P7 FILES** (→ J88):
  • `create-packslips.component.ts:246` — the disguised divide, wrapped in `Math.round`. ⚠ The round makes it CORRECT TODAY but WRONG IN PRINCIPLE now that fractional units are confirmed by design.
  • `edit-packslips.component.ts:245, 248, 267, 322` — same family.
  ▶ Both are fixed by the SAME one-line change: read the stored `packing_units`, stop dividing. Do it as part of P7, not separately.

▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with its file, line, and the stored units column that should replace it. THEN rank the work.

Sub-items, still valid, sequenced behind the inventory:
1. R5 DISPLAY SWITCH — the campaign above.
2. MO-CREATE round-trip (DEFECT 1): store the entered units, or carry batches at full precision. add-mlo.ts:204-205. ⚠ SEEN LIVE S78: MO-0007 plan reads 50.004#.
3. CLEANUP: DO/MR/intermediate-release subtract stored units instead of Kg×lot-ratio. Add a units column to rejectmaterialandproduct.
4. R6: retire formulations.inventory (old Kg line) once display no longer reads it.

⚠ Touches live-client display. Dev-first, verify-in-DB, promote. [3A.5 · §2 GR5 · J13 · J83 · J88]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 is deleted. It was to be deleted WITH a final snapshot — the only frozen record of the 8.0 DB. ⚠ UNVERIFIED. RDS → Snapshots. [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP (pays back every session).** Browser-side file-size check with a proper message; fold into the alert→toaster conversion. ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]". Fix the top ~10 error paths first. ⚠ S80 NOTE: the scan field must NOT raise a blocking alert on a bad scan — it would stop the operator dead mid-scan. Inline "no match" only. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. Attach a file to a packing slip, confirm it lands. ⚠ Test attach-then-ship or an already-shipped slip — attaching to an unshipped slip loses the file (P7). [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default; only Receiving Ref + Vehicle Condition by hand. ⚠ **STILL NOT READ AT S80 CLOSE:** the MO-Release Global Select mechanism (/Release-mat-details + MaterialsProductsReleased.js). P6 says read it BEFORE designing, and P7 should reuse the same pattern. ⚠ THIS IS THE FIRST JOB OF S81. NOT STARTED. [3A.3]

**P7  PACKING-SLIP REDESIGN — ⚠ DESIGNED S80, READY TO BUILD.**

▶ **THE DOMAIN CALL IS MADE.** Minty narrated the whole design in S80. Full evidence and code addresses in J87. The design:

```
ENTRY          /Dispatch-orders → "Create Packing Slip" opens the
               DO-select popup (it already opens automatically —
               create-packslips ngOnInit line 81).
               ⚠ RENAME it from "Dispatch Orders" to something that
               says what it is: "Select DOs to Move to Packing Slip".
               Its button becomes "MOVE TO PACKING SLIP".

THE GROUPING   Picking ONE DO auto-selects every other DO matching
RULE           ALL THREE:  same LOT CODE · same CUSTOMER · same
               SHIPPING ADDRESS.
               ⚠ LOT CODE IS A HARD BOUNDARY. A different lot is
               NEVER auto-selected, even for the same customer and
               address. REASON (Minty): boxes of the same product
               look identical in the warehouse; reading lot codes
               off them by eye is error-prone. The rule exists so
               the operator never has to distinguish two lots
               visually.

THE FILTER     After the first pick the list FILTERS DOWN to that
               customer + address. Other customers vanish. He then
               works down what remains — other lots, other products,
               other SOs — each pick unambiguous by construction.
               ⚠ The address half of this ALREADY EXISTS
               (do-list.component.ts:69). Lot and customer are not
               in the filter yet.

THE SCAN       He scans the LOT CODE (already printed on the box —
               the finished-product label is generated at START
               PRODUCTION, not here). The scanner is a keyboard; it
               types into the search field, which ALREADY filters on
               lotCode only (filterPredicate :75, :155).
               ⚠ SCAN AND CLICK MUST BE ONE FUNCTION taking a LOT
               CODE, with two thin callers. Click reads the lot off
               the row it was given; scan passes the string straight
               in. That is what keeps them provably identical.
               Relationships: lot→MO is 1:1 · lot→DOs is 1:MANY ·
               DO→lot is 1:1 (a DO NEVER spans two lots).

THE AMBIGUITY  ⚠ Only ever at the FIRST pick, and only when that lot
POPUP          resolves to MORE THAN ONE customer+address pair.
               Popup: "This lot ships to X and Y — which is this
               shipment for?" He picks once; everything after is
               automatic. Probably SCAN-ONLY: on the manual route
               the click IS the choice.

THE SHEET      /Create-Packslips renders the DO as a ROW, not a
               stack of form fields. ⚠ PRESENTATION ONLY — multi-DO
               already works (doList afterClosed :225 loops the
               array and pushes one form row per DO).

THE ROW —      MO Number · Internal DO Number · Customer PO No ·
TEN FIELDS     Product · Product External Code · Pdt Lot Code ·
               Best Before · Order Qty (Units) · Shipped Units (#) ·
               Shipped Qty
  DROPPED      Product Internal Code · System SO No
  TO HEADER    Customer · Delivery Address (already in the header —
               removing them from each row removes duplication, not
               information)
  ⚠ MO and DO numbers KEPT DELIBERATELY (Minty): they are the
    handles the operator needs when a customer phones about a
    shipment.
  ⚠ THE OLD "SLIMMED 8 FIELDS" IS SUPERSEDED, NOT PENDING. The
    count was recorded without its list and the list never existed.
    Do not go looking for it.

PO BARCODE     The DISTINCT SO-External values (customer PO numbers)
               across the moved DOs appear as tabs, one per distinct
               PO, each with a barcode the customer can scan.
               ⚠ THIS GOES INTO THE PRINTED DOCUMENT, not to the
               Zebra. The packing slip is a generated document; the
               ZPL label path is a different surface (§4 print
               language / MoSheetPdfService).

ON SAVE        ⚠ DO NOT navigate back. Stay on the slip. Show the
               packing slip number. Allow more DOs to be moved in.
               ⚠ THIS IS THE PART THAT TOUCHES THE BROKEN BRANCH.

LABELS         ⚠ NOT part of this work. The finished-product label
               (lot code + barcode) is generated at START PRODUCTION.
               By packing-slip time it is already on the box.
```

▶ **SEQUENCING — DECIDED S80: BUNDLE, DO NOT SPLIT.** The opener asked whether the defects and the redesign touch the same lines or just the same file. Answer: **the same lines.** The redesign must re-enable the very branch whose backend is broken, and the acrobatic divides sit in the exact display code being rewritten. Fixing them separately would mean writing a correct backend for a frontend path that is still commented out — untestable end to end. [J86 · J87 · J88]

⚠ **ALSO ABSORBS:** the 3 remaining "Customer SO No" → "Customer PO No" labels · P35 (the editPackslips throw) · the attach-a-doc-to-an-unshipped-slip file loss. ▶ DOMAIN CALL STILL OPEN on that last one: should documents be attachable BEFORE dispatch? Minty's instinct: yes. [J74, J75, J16, J85, J86, J87]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it; does not affect what serves. ⚠ Reading a file from prod's checkout shows code that is NOT LIVE (caused a stale read S70). A diagnosis trap, not an app bug. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** DB column exists; code half does not. ⚠ Without it the toggle write silently does nothing. One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ RULE SET S73. Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Only material/composition change forks a version. Material AND Formulation edit. Also fixes My Code showing literal "null" — ⚠ SEEN AGAIN S80 on the SO line ("External ID: null"). [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Button disabled but screen reachable by URL and saves. ⚠ A disabled button is not a control. Needs a backend guard. Logged S50. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** 11+ old build artifacts back to S61. ⚠ promote.sh deploys whatever zip you name — a stale-zip promote is a real risk. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** Rename "Oats"→"Oats Gluten Free", add an "Oats" material, re-import the 4 failed products (importer dedups by title, re-import safe). [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS — WHERE DO THEY BELONG?** Three blocks parked (Procedures/Documents PDF, HACCP Excel, branding rule). ⚠ MIXED — some file mechanics, some DESIGN/DOMAIN. ▶ MINTY SPLITS: design → Section 4; mechanics → 3A.7 / Section 5. Parked, not lost. [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** Last string-interpolated proc call. id is app-controlled + numeric, risk LOW. Do it when the security pass next touches procs. [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. Every rebuild file lives on the un-backed-up prod box; the Drive copy is not verified current. Also at risk: deploy-frontend.sh, promote.sh, both nginx vhosts. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** Still valid, still in git history. ⚠ Sequenced AFTER the app.abletrace.ca domain switch, per Minty. [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. Safe: edit rows in place, append at end. NOT SAFE: insert mid-sequence; change hazard type on a saved row. ⚠ DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ Known limitation, NOT a regression. Real fix is section-aware capture. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).** Pre-S72 J still sits below the rebuilt one. ⚠ Search it for anything the rebuild missed BEFORE deleting.

**P21  THE OS RESTART — PENDING SINCE S35. ⚠ RE-SCOPED S79, THE REHEARSAL NO LONGER WORKS.** Both boxes still show "System restart required", confirmed again at S80 login on BOTH boxes. ⚠ **THE OLD PLAN IS DEAD** — the boxes run different operating systems (prod 26.04 / kernel 7.0.0; dev 24.04.4 / kernel 6.17.0, verified S79). A clean dev reboot proves nothing about prod. ▶ THE WORK IS NOW: (1) confirm `pm2 save` has been run and `pm2 startup` is enabled ON PROD — `systemctl is-enabled pm2-ubuntu`; (2) reboot prod as its own standalone step with the rollback path ready; (3) reboot dev separately whenever. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).** ⚠ A is folded and its routing record is at the foot of 3B. It is now a duplicate with known-false content. Delete it, do not edit it. ⚠ Read 3B's ROUTING RECORD once before deleting.

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ Mac drifts onto IPv6; dev SG allows one IPv4 /32, so SSH times out unpredictably. Add the Mac's IPv6 /128, or accept `ssh -4` as the standing workaround. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).** ⚠ Removed during S73 testing, not restored. Dev fixture hygiene.

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING SHIPPING UNITS.** ⚠ S76. On /Edit-SO → Create Dispatch Order: a partial number (e.g. ".") makes derived Qty(Kg) show "NaN". Should render BLANK. Display-guard gap. Transient only; no stored-data impact. [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. Editing a material's allergen rewrites the allergen shown on already-shipped lots, company-wide, with no audit trail. Live re-derivation is CORRECT per Minty. ⚠ THE RISK IS THE REVERSE: an allergen genuinely present can be REMOVED by a later edit. ▶ DOMAIN CALL: does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value nobody reads? [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** Display flips to #(Kg) after save; DB correct throughout. Frontend-only. Batch it with the R5 display switch. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED — NO EXPIRY WARNING (minutes).** ⚠ `sudo certbot show_account` → "Email contact: none". ⚠ PROD GETS NO RENEWAL-FAILURE WARNING; a silent failure's first symptom is a browser security warning on a LIVE CLIENT SITE. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`, then confirm. ⚠ Account metadata only — does not reissue the cert. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW WHETHER THEY NEED TO BE.** ⚠ Both instances carry public endpoints. NOT WIDE OPEN — password + SG rule in front — but a larger front door than the architecture needs. ▶ REVIEW: can prod RDS be private-only with EC2 reaching it over the VPC? ⚠ The Mac connects directly today for admin queries; that is what would stop working. Not urgent. [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE (functional, not cosmetic).** Colour should be STATE-DRIVEN: red = no certificate · amber = expired · green = in-date. Currently hardcoded red. ⚠ A permanently-red indicator either trains operators to ignore it, or hides a genuine expiry. App-wide, once. [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ `unattended-upgrades` is active on the live client box. ⚠ AN UBUNTU DEFAULT, NOT A MISCONFIGURATION — but it means PROD CHANGES WITHOUT A DECISION. ▶ REVIEW: (a) confirm scope (`/etc/apt/apt.conf.d/50unattended-upgrades`); (b) decide whether a food-safety box should self-patch silently; (c) if it stays on, document it in 3B.2. ⚠ Do NOT disable it casually. [3B.2 · J84]

**P35  EDITING A PACKING SLIP TO ADD A DISPATCH ORDER THROWS.** ⚠ **REACHABILITY SETTLED S80 — IT IS UNREACHABLE TODAY.** `req.body.DOs` is built only from `shipmentList`, which can only be populated by `addItem()`, whose ONLY caller is commented out in the template (edit-packslips.component.html:198-200). So `DOs` always posts as `[]` and the branch is never entered. It is "would break if used", NOT "does break". ⚠⚠ **BUT P7 RESTORES EXACTLY THAT BUTTON** — add-a-DO-to-an-existing-slip is the feature P7 wants back. The throw and the three bugs behind it (NaN write · same qty_shipped for every DO regardless of `i` · double subtraction on the old Kg line) go LIVE the moment the feature returns. ▶ THEREFORE: fix as part of P7, never as a standalone "quick win". Correct scope: decide whether this branch should update inventory AT ALL (per §2 Core #2 it should not), then either delete the loop and keep `createPackingSlipDOs`, or rewrite all four faults together. [§2 to-verify 5 · J85 · J86 · 3A.4]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** ⚠ NEW S80. `PopUps/add-dispatch/` is declared in edit-sales-order.module.ts (line 20) but **never opened** — the only `matDialog.open` call is `AddDispatchV2Component` (edit-sales-order.component.ts:191), and line 35 shows v1 already commented out of a second list. ⚠ A dead component beside a live one is a JT9 trap: an edit there is an invisible no-op. Delete the folder and the module declaration. ⚠ Grep for other references first. Housekeeping, low risk.

**P37  CONFIRM THE COMPANY OF PROD SO-0004 (one query, minutes).** ⚠ NEW S80. A DO (DO-0006) was created on PROD in error during the S80 walk. The fixture family suggests sandbox company 464, but it was never confirmed. Run: `SELECT id, internalCode, company_id FROM somanagement WHERE internalCode='SO-0004';` on prod. If 464 → harmless test residue, note and close. If anything else → ⚠ real client data was touched and it needs proper handling. [Section 1 PROD RESIDUE block]

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27, and P25/P26 are gone for good. P26 was "Fix A" — a fix for a bug that never existed (J81). P25 has no surviving record. ⚠ P28 CLOSED S79.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
```

**END SECTION 1**
