# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST: if a line does NOT change session to session, it does not belong here — it belongs in the stable sections (2 / 3 / 3B).
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 5. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S77 START (Claude reads this FIRST, before anything)

```
DOCS REPO IS LIVE — this is the standing paste now.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (or pastes files).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (Section_3A/3B/4/5) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth; Claude's raw fetch confirms
            once the cache clears. Do NOT conclude "it didn't commit" from a
            stale fetch — wait, or trust the web view. (Learned the hard way S76.)

WHAT IS DONE (S76) — repo build in progress (this is P1):
  ✓ Section_0  rules + new 7.7 (clean-as-you-go) + Section-1-now-in-repo change
  ✓ Section_1  this file (now a repo file, keeps its rewrite-whole discipline)
  ✓ Section_2  core logic / the "bible" — standalone, stable Logic IDs intact
  ✓ SO walk CLOSED → recorded as a tab in the Section 3 workbook (3A.4)
  ✓ Food Safety walked → recorded as a tab in the Section 3 workbook (3A.7)
  (3A.4 + 3A.7 are XLSX TABS, not yet markdown — they convert in the fold below.)

▶▶ THE NEXT JOB — THE BIG ONE. OPEN FRESH. ITS OWN SESSION. ◀◀
   FOLD SECTION 3 (the Excel workbook) + SECTION K TOGETHER, renumber, relink.
   METHOD, IN ORDER — do not skip step 2:
     1. Minty hands Claude: the Section 3 workbook + Section K (as text).
     2. Claude produces a MAPPING FIRST — every K fact → its destination:
          K1 (per-action DB movement) → the DATABASE column of the matching
            3A row (action + its DB footprint together, one home).
          K2 (edit-risk register)     → Section 5 traps.
        Claude SHOWS THE MAP. Writes/merges NOTHING until Minty approves.
     3. Minty approves or corrects the map.
     4. Claude builds merged Section_3A.md (+ Section_3B.md), each row relinked
        UP to Section 2's Logic IDs (→ §2 Logic X) and BACK to Section 1's
        queue. One-way bridge: 3 points to 2, 2 never lists its uses.
     5. K RETIRES (no standalone K section). Then finish the repo: 3B, 4, 5.
   ⚠ This is the MOST CROSS-LINKED section in the whole project — everything
     points at it. The map-approval (step 3) is the guardrail for the entire
     fold. DO NOT RUSH IT. Do it rested, with a working (un-lagged) verify loop.

TWO SMALL CLEANUPS TO FOLD IN when the queue is next rewritten:
  - P27 (below) is new S76 — Minty re-ranks it into position.
  - Section 2's "TO BE VERIFIED item 8" points at a "Fix A" P-item that is NOT
    distinctly in the queue below. Either add Fix A as a P-item or soften §2's
    wording. (Dangling pointer, recorded so it's not lost.)
```

---

## S75 HANDOFF — SO CREATE (verified S75, now folded into Section 3A.4)

```
SO CREATE — verified S75.
  URL          /Add-SO  (from /SO-Management → "Create SO")
  Fields       Customer PO No · Customer* · Shipping Address* ·
               Customer ref-doc upload · product lines · Remarks
  Product line Product · Int.ID(Ext.ID) · Sh.Unit(#) · Quantity · Sh.Pack
  Anchor       CLEAN — Sh.Unit entered in UNITS (10), Kg derived (200Kg).
               Same R1 anchor as the rest of the app.
  Stock        Touches NO stock — new SO = red/No-Shipment until a DO is
               made. Confirmed live (SO-0008).
  Success      alert() "SO Added Successfully"
  SO list      /SO-Management · buttons Create SO / Closed SOs ·
               status shipment-driven (green/amber/red)
  ⚠ S76: SO Details/Edit (/Edit-SO) now ALSO walked — 3A.4 COMPLETE.
```

---

## HEADS — ⚠ verify against the boxes before working (Section 0, rule 1.2)

```
Frontend  53db203d — DEV + PROD in sync
Backend   d3104ea  — DEV + PROD in sync
Trees clean. Health 200 both boxes. PROD IS HEALTHY.
(Prod's frontend CHECKOUT reads 9bce0238 — the S66 lag trap. The
 SERVED bundle is 53db203d. Cosmetic. → P8)

ROLLBACK POINTS:
  www-html.bak-prod-53db203d4ef4
  www-html.bak-dev-53db203d4ef4

⚠ NO APP CODE WAS TOUCHED IN S73. The whole session was the P1 Units
Anchor Reconciliation Walk: a live, read-only forensic walk of the
product quantity flow on DEV (test data only, company 464), plus test
fixtures created on dev. Both boxes are exactly where S71 left them.
⚠ S76 note: S75 + S76 were also walk/documentation sessions — no app
code touched. Boxes still at the HEADs above.
```

## INFRASTRUCTURE — verified in the AWS console S72, unchanged since. ⚠ TRUST THIS BLOCK (Section 3B is being built to hold it permanently; P1).

```
EC2 (new account 208073623096, ca-central-1b):
  abletrace-lab-prod  i-0b54ae374250348e0  t3.small  Running
  abletrace-lab-dev   i-098e2cc59844d9ef3  t3.small  Running
  ⚠ BOTH t3.small (2 GB) — box genuinely cannot build Angular; CI is
    correct. The old "t2.small confirmed" claim was FALSE.

RDS (new account, TWO SEPARATE INSTANCES):
  abletrace-lab-prod          db.t3.micro   Available
  abletrace-lab-dev-s62-dev   db.t3.micro   Available  (shrunk S72)
  ⚠ Dev is now a TRUE TWIN of prod on both boxes. Endpoint unchanged.

⚠ DEV SSH ACCESS (S73 — learned the hard way, do not re-derive):
  Dev SG inbound SSH/22 = 162.156.123.117/32 (Minty's stable HOME
  IPv4). ALWAYS connect with `ssh -4` — the Mac drifts onto IPv6, and
  plain `curl ifconfig.me` reports a PHANTOM address (209.52.x); only
  `curl -4 ifconfig.me` gives the real SSH source. An hour was lost in
  S73 chasing a phantom IP change and overwriting the SG with a wrong
  address. If dev SSH times out: run `curl -4 ifconfig.me`, put THAT
  /32 on the SSH rule, connect with -4. Prod SSH is more permissive so
  prod still connects — that difference is the tell it's a dev-SG issue.
  → P23 (add an IPv6 rule so this stops recurring).

THE SIZING EVIDENCE (old account 350466202408 — 2 live clients, 2 yrs):
  t3.small app box + db.t3.micro DB carried two real clients for two
  years. PROD SIZING IS FINE — do not upsize.
```

## LAST WALK (S73) — P1 UNITS ANCHOR RECONCILIATION: COMPLETE

```
The whole product quantity flow walked end-to-end, code + DB + live
screen at every hop, on BOTH a simple product (test1.39, FO-0004) and
an intermediate-consuming product (Test1.39-IP, FO-0005 → draws
testpdt260703). Full verdict chart lives in the Section 3A.5 STOCK table.

RESULT — thesis PROVEN: the stored units anchor (inventory_units /
received_units) is R1 (clean) at EVERY real stock-moving hop. Two
defects, both isolated, NEITHER corrupts actual traceable stock:
  DEFECT 1 — MO CREATE round-trips the unit count through batches
    (add-mlo.ts:204-205: qty/36 → round → ×36). Stores 50.004 for an
    order of 50. Corrupts the PLAN only; receiving heals the real line
    via the human-entered count. → P2.
  DEFECT 2 — DISPLAY reconstructs units as Kg÷wgt (R3) on every product
    screen (Products list :878; traceability getWduUnits; the
    Trace_ProductHeaderView _su fields). PROVEN producing float garbage
    on live traceability: 51.00000000000001#, 0.27799999999999997#.
    The R5 "display switch" — genuinely unfinished. → P2 (priority).

DEV FIXTURE LEFT IN PLACE (company 464): FO-0004 test1.39 (43#/59.77Kg),
FO-0005 Test1.39-IP, testpdt260703 now 2.222#/44.44Kg, MAT-6 still
missing its Sesame allergen (removed S72, not restored → P24).
⚠ 464 is no longer a clean baseline — note before reusing.
```

## THIS SESSION — where to resume

```
S76 resume state: repo build in progress (P1). Done so far in repo:
Section 0 (+7.7, +Section-1-in-repo), Section 2, Section 1. NEXT in the
repo build: Section 3 + Section K together (the fold), then 3B (infra —
scrub identifiers to H), then 4, then 5.

Bug work still available any time: P2 (units display, priority),
P9/P11 (small guards), P10, P27.
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ Each line points at its Section-5 entry. EVIDENCE lives there, not here.

**P1  DOCUMENTATION CONVERGENCE — FOLD A INTO THE NEW SECTIONS, THEN REVIEW I AND K.** ⚠ MINTY-SET, S73. One documentation session, three linked jobs.
- (a) FOLD SECTION A into the new stable sections, THEN RETIRE A. A and the old G-REF have no clean boundary — A duplicates the deploy/boxes/health/infra facts. Two homes for one fact. A is five sections' worth of material in one pile: boxes/PEM/environments → 3B.2; build/deploy (DEAD, box can't build) → 3B.4; cred pointers/S3/SES → 3B.7/3B.8; DB rules/procs → 2 (GR7) + Section 5; GitHub/domain → 3B.9/old-app; licence logic → 2 (A7); product arch + role/task nav → 2; file maps/NgRx → component maps; Zebra → 3B.7; design pointer → Section 4; triage → 3B.11.
  - ⚠ METHOD: map every A fact to its new home and SHOW THE MAP BEFORE WRITING. Minty approves. Then each affected item reissued WHOLE. A deleted only after the map is read.
  - ⚠ KNOWN FALSE IN A TODAY (do not trust A until done): Ubuntu 24.04 → really 26.04; RDS `abletrace` → that is the ARCHIVE, live is `abletracelab_live`; build/deploy → dead; two environments → there are THREE; "formulations.inventory = Kg" as architecture → it is the remnant (P2's target); duplicate SESSION 0 block; S66 dev block pasted TWICE; "CURRENT POSITION (S42 close)" → 34 sessions stale; three S69 entries → already J71/J72.
  - ⚠ S76 PROGRESS: the repo is now the fold destination. Sections 0, 1, 2 are converted and live. This is P1 advancing — the "new stable sections" the fold targets now physically exist.
- (b) REVIEW SECTION 4 (design). ⚠ MINTY-SET. The A23 design pointer lands here in the fold — confirm 4 is current and the incoming design material has a clean home.
- (c) REVIEW / REFRESH SECTION K. K1 (DB Action Map) + K2 (Edit Risk Register) are stale. ⚠ K1 has no row for document save. K1, GR6 and Section 5 describe overlapping ground — must not drift. ⚠ S76 DECISION: K FOLDS INTO 3A — K1 (per-action DB movement) → the DATABASE column of the matching 3A rows; K2 (edit risk) → Section 5 traps. K retires. To be done when 3 + K are handed together.

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ MINTY-SET, S73. With P1's map. Priority order:
1. R5 DISPLAY SWITCH (DEFECT 2, the big one, LIVE on every product screen): read inventory_units / received_units directly instead of Kg÷wgt. Sites: admin-formulation:878; traceability getWduUnits; Trace_ProductHeaderView _su fields; Stock Info popup.
2. MO-CREATE round-trip (DEFECT 1): store the entered units, or carry batches at full precision. add-mlo.ts:204-205.
3. CLEANUP: DO/MR/intermediate-release subtract stored units instead of Kg×lot-ratio (remove R2-via-LogicI fragility). Add a units column to rejectmaterialandproduct (MR record is Kg-only). DELETE dead PS block PackingSlips:333-334 (do NOT repair).
4. R6: retire formulations.inventory (old Kg line) once display no longer reads it.
- ⚠ Touches live-client display. Dev-first, verify-in-DB, promote. [Section 2 anchor · GR4 · GR5]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 is deleted. Was to be deleted WITH a final snapshot — the only frozen record of the 8.0 DB. ⚠ UNVERIFIED. RDS → Snapshots.

**P4  FILE-SIZE GATE + ALERT SWEEP (pays back every session).** Browser-side file-size check with a proper message; fold into the alert→toaster conversion. ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]" — a tax on every diagnosis. Fix the top ~10 error paths first. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. Attach a file to a packing slip, confirm it lands. ⚠ Test attach-then-ship or an already-shipped slip — attaching to an unshipped slip loses the file (P7). [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default; only Receiving Ref + Vehicle Condition by hand. ⚠ FIRST read the existing MO-Release Global Select mechanism before designing. NOT STARTED.

**P7  PACKING-SLIP REDESIGN (major, linked to P6).** Slimmed 8-field customer row + unique-PO barcode. Absorbs the 3 remaining "Customer SO No"→"PO No". ⚠ ALSO FIXES: attaching a shipping doc to an UNSHIPPED slip silently loses it. ▶ DOMAIN CALL: should docs attach BEFORE dispatch? Minty's instinct: yes. [J74, J75, J16]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it; does not affect what serves. ⚠ Reading a file from prod's checkout shows code that is NOT LIVE (caused a stale read S70). A diagnosis trap, not an app bug. [S66 trap]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** DB column exists; code half does not. ⚠ Without it the toggle write silently does nothing. One line; unblocks Feature A. [J47·JT2·GR10]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ RULE SET S73. Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Only material/composition change forks a version. Material AND Formulation edit. Also fixes My Code showing literal "null". ⚠ Shelf Life already editable — CONFIRM IT SAVES.

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Button disabled but screen reachable by URL and saves. ⚠ A disabled button is not a control. Needs a backend guard. Logged S50. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** 11+ old build artifacts back to S61. ⚠ The promote script deploys whatever zip you name — a stale-zip promote is a real risk.

**P13  FINISH GLUTENULL ONBOARDING.** Rename "Oats"→"Oats Gluten Free", add an "Oats" material, re-import the 4 failed products (importer dedups by title, re-import safe). [GR10]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS — WHERE DO THEY BELONG?** Three blocks parked (Procedures/Documents PDF, HACCP Excel, branding rule). ⚠ MIXED — some file mechanics, some DESIGN/DOMAIN (HACCP Excel keeps blue, Procedures PDF all-black, neither Mintek-branded; the prominent name on a HACCP plan is the CLIENT). ▶ MINTY SPLITS: design → Section 4; mechanics → 3A/Section 5. Parked, not lost. [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** Last string-interpolated proc call. id is app-controlled + numeric, risk LOW. Do it when the security pass next touches procs. [J78·GR10]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. Every rebuild file lives on the un-backed-up prod box; the Drive copy is not verified current. Also at risk: deploy-frontend.sh, promote.sh, dev nginx vhost. [JR14 · JT20]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** Still valid, still in git history. ⚠ Sequenced AFTER the app.abletrace.ca domain switch, per Minty. [J1, J34]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. Safe: edit rows in place, append at end. NOT SAFE: insert mid-sequence; change hazard type on a saved row — either can silently duplicate/drop rows across the three stages. ⚠ DO NOT BUNDLE. Scope in GR10. [J4 · JT3]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ Known limitation, NOT a regression. Real fix is section-aware capture. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).** Pre-S72 J still sits below the rebuilt one. ⚠ Search it for anything the rebuild missed BEFORE deleting. Until gone, the REBUILT J (Section 5) is the true one; do not append to the old.

**P21  THE OS RESTART — PENDING SINCE S35.** Both boxes "System restart required", now Ubuntu 26.04 kernel. ⚠ Its own clean step: verify pm2 resurrects on 26.04 (pm2 save / pm2 startup) BEFORE relying on it, then reboot standalone. ⚠ Do DEV FIRST — true twin now, real rehearsal for prod.

**P22  DELETE THE OLD SECTION A after P1 folds it (housekeeping).** ⚠ Only after P1's map is read and approved. A is deleted, not edited.

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ NEW, S73. Mac drifts onto IPv6; dev SG only allows one IPv4 /32, so SSH times out unpredictably. Add the Mac's IPv6 /128 (or accept `ssh -4` as the standing workaround). Stops the recurring lockout.

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).** ⚠ NEW, S73. Removed during S72 testing, not restored. Dev fixture hygiene — do before reusing company 464 as a baseline.

**P27  DO-CREATE POPUP: Qty(Kg) shows "NaN" while typing Shipping Units.** ⚠ NEW, S76. On /Edit-SO → Create Dispatch Order popup: a partial number (e.g. ".") in Shipping Units makes derived Qty(Kg) show "NaN". Clears when valid. Should render BLANK. Display-guard gap, same family as Defect 2 / 3A.5 row 11. Transient only; no stored-data impact. [3A.5 row 11 · Defect 2 · GR5 R5]

> ⚠ Note: the queue jumps P24 → P27. P25/P26 were assigned in S75 (not in this S74-origin file). Minty reconciles the numbering at re-rank. New items still append at the true bottom.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
```

---

**END SECTION 1**
