# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE. One fact, one home, decided by how often it changes.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S80 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S79 — a long one, run across TWO PARALLEL THREADS.
               Both are recorded below. Neither thread saw the other
               while running; this block is the reconciliation.
THIS SESSION   S80 — ⚠ THE FOLD IS COMPLETE. All eight sections are
               built and in the repo. NORMAL WORK RESUMES: re-rank the
               queue, then pick up P-items.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5/6) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. Do NOT conclude "it didn't
            commit" from a stale fetch. (Learned S76.)

WHAT S79 DID — BOTH THREADS. Do not re-derive any of it.

  THREAD A — INFRASTRUCTURE + HISTORY
  ✓ BUILT Section_3B.md — eleven blocks, everything the app runs on.
    ⚠ METHOD CHANGED MID-BUILD AND IT MATTERS: old Section A was found
    TWO-HEADED — its S42-stamped top half contradicted its own appends
    on NINE load-bearing facts, and carried an S61 "correction" that was
    itself the error (t2.small; both boxes are t3.small). SO A'S TOP HALF
    WAS NOT COPIED FORWARD. 3B.2/3B.3/3B.4 were rebuilt from Section 1's
    S72 console-verified facts. A contributed only its S53-onward appends.
    ⚠ Roughly HALF of A was never infrastructure — routed to §2 / 3A / §4.
    The ROUTING RECORD at the foot of 3B says where each piece went.
  ✓ BUILT Section_6.md from old Section C.
  ✓ P31 raised (prod SSL has no contact email).

  THREAD B — CORRECTIONS + THE UNITS GATE
  ✓ §2's THREE STRUCK CLAIMS CORRECTED — Edit integrity (S59), GR7
    mlomanagement, TO-BE-VERIFIED item 8. Plus the CLEANUP PILE's
    t2/t3 line, which was inverted. Section 2 is now clean.
  ✓ §2 GR5 RE-SCOPED — R5 was stamped "IN PROGRESS (the priority fix)".
    It is NOT STARTED and is ~30+ sites, not the 3 it listed.
  ✓ J13 vs J80 GATE RESOLVED against dev → J83. JT21 added.
  ✓ P2 RE-SCOPED WHOLE — from "the priority fix" to a campaign.
  ✓ P32 + P33 raised.

  ✓ NO APP CODE TOUCHED IN EITHER THREAD. All reads. Boxes unchanged.

▶▶ THE NEXT JOB — SECTION 4. THIS IS S80. ◀◀
   The last repo gap. Sections 0, 1, 2, 3A, 3B, 5, 6 are all converted
   and live. Only 4 remains, and it has incoming material waiting:
     · A23's design system (font, palette, tiles, rail) — routed out of
       Section A by 3B's routing record, now homeless until 4 absorbs it
     · P14's design half (HACCP Excel blue, Procedures PDF all-black,
       neither Mintek-branded, client name prominent on a HACCP plan)
     · P33's cert-status colour rule (red/amber/green, state-driven)
   ⚠ Rule 9D governs what 4 may hold: visual and interaction language
     ONLY. A DB change or a queue item that touches a screen does NOT
     belong in 4. Move it on sight.

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81). ⚠ Grep the repo for
    "Fix A" when next in it — any surviving pointer is dead.
  • The allergen snapshot does not exist (J80 + J82). ✅ §2 corrected S79.
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; its STOCK-HOP findings stand (J83).
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  53db203d — DEV + PROD in sync
Backend   d3104ea  — DEV + PROD in sync
Trees clean. Health 200 both boxes. PROD IS HEALTHY.
⚠ VERIFIED LIVE ON DEV AT S79 OPEN. Prod carried from S77.

(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  www-html.bak-prod-53db203d4ef4
  www-html.bak-dev-53db203d4ef4

⚠ NO APP CODE TOUCHED IN S73, S75, S76, S77, S78 OR S79 — all walk /
documentation / verification sessions. Boxes have been at these HEADs
since S71.
```

## DEV FIXTURE RESIDUE — ⚠ note before reusing company 464 as a baseline

```
1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
2. MAT-6 missing its Sesame allergen       (S73 → P24)
3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)

⚠ ALSO: 464's test products run at 1 Kg per shipping unit. That ratio
  makes a division INVISIBLE and is what produced J80's false display
  finding. Do NOT verify any units↔Kg path on a 1:1 fixture. (JT21 · J83)
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ Each line points at its Section-5 entry. EVIDENCE lives there, not here.

**P1  DOCUMENTATION CONVERGENCE — THE FOLD.** ⚠ MINTY-SET, S73. Nearly done.
- (a) ✅ **DONE S78.** Section 3 + Section K → Section_3A.md. K RETIRED.
- (b) **SECTION 4 (design) — THIS IS S80.** The last gap. Incoming material listed in the resume block above. ⚠ Absorbs P14's design half.
- (c) ✅ **DONE S79.** Section A → Section_3B.md. ⚠ A itself not yet deleted → P22.
- ⚠ STATUS: 0, 1, 2, 3A, 3B, 5, 6 converted and live in the repo. Remaining: 4.

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ MINTY-SET, S73. ⚠ RE-SCOPED S79 — THIS IS A CAMPAIGN, NOT A FIX.

⚠ **GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY.** Verified against dev by reading the view and grepping the frontend. Full evidence in J83. Do NOT re-derive:
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT. Every `_su` field is `<Kg> / wgt_kgs_per_unit`. Neither inventory_units nor received_units appears in the view at all.
  • The Products list (admin-formulation.component.ts:878) divides SEPARATELY, and divides the OLD Kg column: `element.inventory / packing?.wgt_kgs_per_unit`.
  • ⚠ SCALE: ~30+ division sites, not the 3 GR5 listed. Many disguise it as `(qty / batch) * (batch / wgt)` — algebraically identical.
  • ⚠ THE CORRECT PATTERN ALREADY EXISTS: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. That is R1. Copy it. Its sibling formulation-edit-stock-info.component.ts:269 still divides — two popups, same figure, one right one wrong.

⚠ **NOT FRONTEND-ONLY.** The view must be rewritten too (§2 "Populate vs proc"). Two inputs have NO units column to read: `rejectmaterialandproduct.qty_rejected` is Kg-only, and `dispatchorders.qty_to_ship` is Kg — though `qty_shipped` and `packing_units` ARE units, so the DO/PS/shipped buckets may be recoverable without a schema change. Misc Release is not.

▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with its file, line, and the stored units column that should replace it. Sites with no source column get flagged for the schema change. THEN rank the work.

Sub-items, still valid, sequenced behind the inventory:
1. R5 DISPLAY SWITCH — the campaign above.
2. MO-CREATE round-trip (DEFECT 1): store the entered units, or carry batches at full precision. add-mlo.ts:204-205. ⚠ SEEN LIVE S78: MO-0007 plan reads 50.004#.
3. CLEANUP: DO/MR/intermediate-release subtract stored units instead of Kg×lot-ratio (removes R2-via-LogicI fragility). Add a units column to rejectmaterialandproduct. DELETE dead PS block PackingSlips:333-334 (do NOT repair).
4. R6: retire formulations.inventory (old Kg line) once display no longer reads it.

⚠ Touches live-client display. Dev-first, verify-in-DB, promote. [3A.5 · §2 GR5 · J13 · J83]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 is deleted. It was to be deleted WITH a final snapshot — the only frozen record of the 8.0 DB. ⚠ UNVERIFIED. RDS → Snapshots. [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP (pays back every session).** Browser-side file-size check with a proper message; fold into the alert→toaster conversion. ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]" — a tax on every diagnosis. Fix the top ~10 error paths first. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. Attach a file to a packing slip, confirm it lands. ⚠ Test attach-then-ship or an already-shipped slip — attaching to an unshipped slip loses the file (P7). [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default; only Receiving Ref + Vehicle Condition by hand. ⚠ FIRST read the existing MO-Release Global Select mechanism before designing. NOT STARTED. [3A.3]

**P7  PACKING-SLIP REDESIGN (major, linked to P6).** Slimmed 8-field customer row + unique-PO barcode. Absorbs the 3 remaining "Customer SO No"→"PO No". ⚠ ALSO FIXES: attaching a shipping doc to an UNSHIPPED slip silently loses it. ▶ DOMAIN CALL: should docs attach BEFORE dispatch? Minty's instinct: yes. [J74, J75, J16]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it; does not affect what serves. ⚠ Reading a file from prod's checkout shows code that is NOT LIVE (caused a stale read S70). A diagnosis trap, not an app bug. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** DB column exists; code half does not. ⚠ Without it the toggle write silently does nothing. One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ RULE SET S73. Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Only material/composition change forks a version. Material AND Formulation edit. Also fixes My Code showing literal "null". ⚠ Shelf Life already editable — CONFIRM IT SAVES. [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Button disabled but screen reachable by URL and saves. ⚠ A disabled button is not a control. Needs a backend guard. Logged S50. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** 11+ old build artifacts back to S61. ⚠ promote.sh deploys whatever zip you name — a stale-zip promote is a real risk. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** Rename "Oats"→"Oats Gluten Free", add an "Oats" material, re-import the 4 failed products (importer dedups by title, re-import safe). [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS — WHERE DO THEY BELONG?** Three blocks parked (Procedures/Documents PDF, HACCP Excel, branding rule). ⚠ MIXED — some file mechanics, some DESIGN/DOMAIN. ▶ MINTY SPLITS: design → Section 4 (with P1b); mechanics → 3A.7 / Section 5. Parked, not lost. [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** Last string-interpolated proc call. id is app-controlled + numeric, risk LOW. Do it when the security pass next touches procs. [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. Every rebuild file lives on the un-backed-up prod box; the Drive copy is not verified current. Also at risk: deploy-frontend.sh, promote.sh, both nginx vhosts. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** Still valid, still in git history. ⚠ Sequenced AFTER the app.abletrace.ca domain switch, per Minty. [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. Safe: edit rows in place, append at end. NOT SAFE: insert mid-sequence; change hazard type on a saved row — either can silently duplicate/drop rows across the three stages. ⚠ DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ Known limitation, NOT a regression. Real fix is section-aware capture. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).** Pre-S72 J still sits below the rebuilt one. ⚠ Search it for anything the rebuild missed BEFORE deleting. Until gone, the REBUILT J (Section 5) is the true one; do not append to the old.

**P21  THE OS RESTART — PENDING SINCE S35. ⚠ RE-SCOPED S79, THE REHEARSAL NO LONGER WORKS.** Both boxes still show "System restart required", confirmed at S79 login. ⚠ **THE OLD PLAN WAS: reboot dev first as a true-twin rehearsal, then prod. THAT PREMISE IS DEAD** — the boxes run different operating systems (prod 26.04 "resolute" / kernel 7.0.0; dev 24.04.4 "noble" / kernel 6.17.0, verified S79). A clean dev reboot proves nothing about prod. ⚠ THE ACTUAL RISK IS UNCHANGED AND IS ON PROD: if pm2 does not resurrect after reboot, the live client's site is down until someone notices. ▶ SO THE WORK IS NOW: (1) confirm `pm2 save` has been run and `pm2 startup` is enabled ON PROD SPECIFICALLY — `systemctl is-enabled pm2-ubuntu` — since that, not the rehearsal, is what actually makes the reboot safe; (2) reboot prod as its own standalone step with the rollback path ready and nothing else in flight; (3) reboot dev separately whenever, it carries no client. ⚠ Dev can still be rebooted first for practice with the PROCEDURE, but do not treat its success as evidence. [3B.2 · 3B.5]

**P22  DELETE THE OLD SECTION A (housekeeping).** ⚠ P1(c) is done — A is folded and its routing record is at the foot of 3B. A is now a duplicate with known-false content. Delete it, do not edit it. ⚠ Read 3B's ROUTING RECORD once before deleting, to confirm nothing was missed.

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ Mac drifts onto IPv6; dev SG allows one IPv4 /32, so SSH times out unpredictably. Add the Mac's IPv6 /128, or accept `ssh -4` as the standing workaround. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).** ⚠ Removed during S73 testing, not restored. Dev fixture hygiene — do before reusing company 464 as a baseline. One of three residue items; see the block above.

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING SHIPPING UNITS.** ⚠ S76. On /Edit-SO → Create Dispatch Order: a partial number (e.g. ".") makes derived Qty(Kg) show "NaN". Clears when valid. Should render BLANK. Display-guard gap, same family as Defect 2 / P30. Transient only; no stored-data impact. [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. Editing a material's allergen rewrites the allergen shown on already-completed, already-shipped lots — company-wide, immediately, with no audit trail of what the record said at ship time. Live re-derivation is CORRECT per Minty (a mis-declaration must be correctable on past data). ⚠ THE RISK IS THE REVERSE DIRECTION: an allergen genuinely present in a shipped lot can be REMOVED by a later edit. ▶ DOMAIN CALL BEFORE ANY CODE: does a shipped lot need an immutable as-declared record alongside the live rollup? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value nobody reads, or nothing at all? Answer before rewording §2 GR7. [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** Display flips to #(Kg) after save; DB is correct throughout. Frontend-only. ⚠ Parked for "Route 5", never picked up — 30 sessions untracked. Same display-guard family as Defect 2 and P27; batch it with the R5 display switch rather than fixing alone. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED — NO EXPIRY WARNING (minutes).** ⚠ Confirmed via `sudo certbot show_account` → "Email contact: none". ⚠ SO PROD GETS NO RENEWAL-FAILURE WARNING. Auto-renew is scheduled, but a silent failure's first symptom is a browser security warning on a LIVE CLIENT SITE. Dev was deliberately given info@abletrace.ca. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`, then confirm with `show_account`. ⚠ Account metadata only — does not touch or reissue the cert. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW WHETHER THEY NEED TO BE.** ⚠ Surfaced S64, was in nobody's queue. Both instances carry public endpoints, so the databases are reachable from the internet rather than only from the app boxes. ⚠ NOT WIDE OPEN — a password and an SG rule sit in front — but it is a larger front door than the architecture needs, on a food-safety system holding a real client's data. ▶ REVIEW: can prod RDS be private-only with EC2 reaching it over the VPC? ⚠ Check what breaks first — the Mac connects directly today for admin queries; that is what would stop working. Not urgent. [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE (functional, not cosmetic).** ⚠ Logged in the design section at S36, never actioned — 43 sessions. Colour should be STATE-DRIVEN: red = no certificate · amber = expired · green = in-date. Currently hardcoded red, so it reads red for every state including in-date. ⚠ WHY THIS IS NOT COSMETIC: a permanently-red indicator either trains operators to ignore it, or hides a genuine expiry. Do it app-wide, once. ⚠ Its colour rule lands in Section 4 with P1(b). [§4 status colours]


**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ NEW S79. `unattended-upgrades` is active on the live client box — prod's apt history shows it running on 2026-07-01 and again 2026-07-22, with no human involved. ⚠ THIS IS AN UBUNTU DEFAULT, NOT A MISCONFIGURATION — it normally installs security patches only, not major releases. But it means PROD CHANGES WITHOUT A DECISION, and that was recorded nowhere. ▶ REVIEW, NOT A FIX: (a) confirm what it is scoped to (`/etc/apt/apt.conf.d/50unattended-upgrades`); (b) decide whether a food-safety system's live box should self-patch silently, or whether patching should be a named step like every other change; (c) if it stays on, document it in 3B.2 so the next unexplained change on prod is not a mystery. ⚠ Do NOT disable it casually — turning it off means security patches stop arriving, which is a worse default. [3B.2 · J84]

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27, and P25/P26 are gone for good. P26 was "Fix A" — a fix for a bug that never existed (J81). P25 has no surviving record. ⚠ P28 CLOSED S79: the dev-DB-access trap now lives permanently in 3B.3.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
```

**END SECTION 1**
