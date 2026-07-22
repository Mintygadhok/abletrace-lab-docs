# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST: if a line does NOT change session to session, it does not belong here — it belongs in the stable sections (2 / 3 / 3B).
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S78 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S77 (closed clean, early and deliberately)
THIS SESSION   S78 — THE P1 FOLD. Section 3 + Section K. Its own run.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the S78 opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. Do NOT conclude "it didn't
            commit" from a stale fetch. (Learned S76.)

WHAT S77 DID — do not re-derive:
  ✓ CLOSED the one conflict that would have corrupted the fold: the
    "version-fork drops ship_qty→0" claim. Tested LIVE on dev + read the
    code + 4 yrs of operator experience. NOT A BUG, never was. → J81.
  ✓ Produced the K→3A/5 MAPPING (fold method step 2). DRAFTED, NOT APPROVED.
  ✓ Confirmed NO further verification is needed to fold.
  ✓ No app code touched. Boxes unchanged.

▶▶ THE NEXT JOB — THE BIG ONE. THIS IS S78. ◀◀
   FOLD SECTION 3 (the Excel workbook) + SECTION K TOGETHER, renumber, relink.
   METHOD, IN ORDER — do not skip step 2:
     1. Minty hands Claude: the Section 3 workbook + Section K (as files).
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
     fold. DO NOT RUSH IT.

⚠ FIRST DECISION OF S78 — answer BEFORE building:
  Most of K1 points at 3A tabs that DO NOT EXIST YET (3A.1 Materials, 3A.2
  Products/Formulations, 3A.3 PO/Receiving, 3A.6 Traceability, 3A.8 Super
  Admin). Only 3A.4, 3A.5, 3A.7 are walked. Options:
    (A)      stub all missing tabs, park K facts in them
    (A-lite) skeleton stubs only, no invented screen/back-end detail  ← rec.
    (B)      fold only what has a live home; park the rest, K does NOT retire
  The method says "K retires" — that argues A or A-lite.

⚠ CORRECTIONS TO CARRY INTO THE BUILD (from J81 — do NOT pre-edit the old
  workbook; bake these in as the new sections are built):
  • K1 action 12 — strike "this IS the S45 bug (real, OPEN)"
  • K1 action 14 — strike "only the FORK is the bug"; the whole ruled-out
    framing needs rewriting, not one cell
  • 3A.5 row 1, cols 7+8 — strike "fork must copy ship_qty fwd" /
    "S45 fork ship_qty=0"
  • §2 TO-BE-VERIFIED item 8 — rewrite to "CLOSED S77 (J81)"
  • J9b — its "Fix A landed S46/S47" history is doubtful (Formulations.js:901
    predates S46 by ~4 yrs). Point it at J81.
  • No "Fix A" P-item is needed — the fix was never needed.
  • AT FOLD TIME: grep the WHOLE repo for "Fix A" to catch any pointer hiding
    in Section 6 / old A / old J before it re-seeds the struck claim.
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

⚠ NO APP CODE TOUCHED IN S73, S75, S76 OR S77 — all walk/documentation/
verification sessions. Boxes have been at these HEADs since S71.
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
  ⚠ Dev is a TRUE TWIN of prod on both boxes. Endpoint unchanged.
  ⚠ LIVE DB NAME = abletracelab_live. A bare `mysql` on prod lands in the
    dormant ARCHIVE. Name it explicitly, always.

⚠ DEV SSH ACCESS (S73 — learned the hard way, do not re-derive):
  Dev SG inbound SSH/22 = 162.156.123.117/32 (Minty's stable HOME IPv4).
  ALWAYS connect with `ssh -4` — the Mac drifts onto IPv6, and plain
  `curl ifconfig.me` reports a PHANTOM address; only `curl -4 ifconfig.me`
  gives the real SSH source. If dev SSH times out: run `curl -4 ifconfig.me`,
  put THAT /32 on the SSH rule, connect with -4. Prod SSH is more permissive
  so prod still connects — that difference is the tell it's a dev-SG issue.
  → P23 (add an IPv6 rule so this stops recurring).

⚠ DEV DB ACCESS (S77 — cost 3 retries, not yet in a stable section):
  Dev has NO ~/.my.cnf; build a temp cnf from .env, chmod 600, rm after.
  ⚠ dotenv PRINTS A BANNER TO STDOUT ("◇ injected env…"). NEVER capture a
  node -e output into a shell variable — the banner lands in the variable
  and corrupts it. Hardcode `abletracelab_live`, or silence with 2>/dev/null.

THE SIZING EVIDENCE (old account 350466202408 — 2 live clients, 2 yrs):
  t3.small app box + db.t3.micro DB carried two real clients for two
  years. PROD SIZING IS FINE — do not upsize.
```

## LAST VERIFICATION (S77) — FORK ship_qty: CLOSED, NOT A BUG

```
The one conflict blocking the fold, settled three ways (J81):
  1. LIVE (dev co464): added intermediate @7u to FO-0005 → forked to
     FO-0005-2 → srf rows 1042 (ship=7) + 1043 (ship=1). BOTH carried
     forward. Zero 0-values.
  2. CODE: Formulations.js:901 `ship_qty: formula.ship_qty`. Fork and
     pure-add share ONE handler (methodForCreateFormula). git blame:
     present since commit 2e21c0f, 2022-07-05 — ~4 years.
  3. OPERATOR: Minty has never seen a ship_qty=0 in 4 years of live use.
VERDICT: the "S45 fork bug" was a MISREAD written down as fact and copied
forward. Same failure family as J80. No fix needed, no P-item needed.

⚠ DEV FIXTURE CHANGED (S77 residue): co464 FO-0005 is now TWO versions
(v1 status2 / FO-0005-2 v2 status1) + srf rows 1042/1043. Deliberate test
residue, left in place. 464 was already a dirty baseline; this adds to it.
Also still outstanding from S73: MAT-6 missing its Sesame allergen (→ P24).
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ Each line points at its Section-5 entry. EVIDENCE lives there, not here.

**P1  DOCUMENTATION CONVERGENCE — THE FOLD (this is S78's job).** ⚠ MINTY-SET, S73. Three linked jobs.
- (a) FOLD SECTION 3 + SECTION K into the new stable sections, THEN RETIRE K and A. Method + first decision + carried corrections are in the RESUME block above.
- (b) REVIEW SECTION 4 (design). ⚠ MINTY-SET. The A23 design pointer lands here in the fold — confirm 4 is current and the incoming design material has a clean home.
- (c) FOLD SECTION A and retire it. A duplicates the deploy/boxes/health/infra facts — two homes for one fact. Map every A fact to its new home and SHOW THE MAP BEFORE WRITING. ⚠ KNOWN FALSE IN A TODAY: Ubuntu 24.04 → really 26.04; RDS `abletrace` → that is the ARCHIVE, live is `abletracelab_live`; build/deploy → dead (box can't build); two environments → there are THREE; duplicate SESSION 0 and S66 blocks; "CURRENT POSITION (S42 close)" → 36 sessions stale.
- ⚠ S77 PROGRESS: Sections 0, 1, 2 are converted and live in the repo. The fold's destination physically exists. The one blocking conflict is closed (J81).

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ MINTY-SET, S73. With P1's map. Priority order:
1. R5 DISPLAY SWITCH (DEFECT 2, the big one, LIVE on every product screen): read inventory_units / received_units directly instead of Kg÷wgt. Sites: admin-formulation:878; traceability getWduUnits; Trace_ProductHeaderView _su fields; Stock Info popup.
2. MO-CREATE round-trip (DEFECT 1): store the entered units, or carry batches at full precision. add-mlo.ts:204-205.
3. CLEANUP: DO/MR/intermediate-release subtract stored units instead of Kg×lot-ratio (remove R2-via-LogicI fragility). Add a units column to rejectmaterialandproduct (MR record is Kg-only). DELETE dead PS block PackingSlips:333-334 (do NOT repair).
4. R6: retire formulations.inventory (old Kg line) once display no longer reads it.
- ⚠ Touches live-client display. Dev-first, verify-in-DB, promote. [Section 2 anchor · GR5]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 is deleted. Was to be deleted WITH a final snapshot — the only frozen record of the 8.0 DB. ⚠ UNVERIFIED. RDS → Snapshots.

**P4  FILE-SIZE GATE + ALERT SWEEP (pays back every session).** Browser-side file-size check with a proper message; fold into the alert→toaster conversion. ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]" — a tax on every diagnosis. Fix the top ~10 error paths first. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. Attach a file to a packing slip, confirm it lands. ⚠ Test attach-then-ship or an already-shipped slip — attaching to an unshipped slip loses the file (P7). [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default; only Receiving Ref + Vehicle Condition by hand. ⚠ FIRST read the existing MO-Release Global Select mechanism before designing. NOT STARTED.

**P7  PACKING-SLIP REDESIGN (major, linked to P6).** Slimmed 8-field customer row + unique-PO barcode. Absorbs the 3 remaining "Customer SO No"→"PO No". ⚠ ALSO FIXES: attaching a shipping doc to an UNSHIPPED slip silently loses it. ▶ DOMAIN CALL: should docs attach BEFORE dispatch? Minty's instinct: yes. [J74, J75, J16]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it; does not affect what serves. ⚠ Reading a file from prod's checkout shows code that is NOT LIVE (caused a stale read S70). A diagnosis trap, not an app bug. [S66 trap]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** DB column exists; code half does not. ⚠ Without it the toggle write silently does nothing. One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ RULE SET S73. Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Only material/composition change forks a version. Material AND Formulation edit. Also fixes My Code showing literal "null". ⚠ Shelf Life already editable — CONFIRM IT SAVES.

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Button disabled but screen reachable by URL and saves. ⚠ A disabled button is not a control. Needs a backend guard. Logged S50. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** 11+ old build artifacts back to S61. ⚠ The promote script deploys whatever zip you name — a stale-zip promote is a real risk.

**P13  FINISH GLUTENULL ONBOARDING.** Rename "Oats"→"Oats Gluten Free", add an "Oats" material, re-import the 4 failed products (importer dedups by title, re-import safe).

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS — WHERE DO THEY BELONG?** Three blocks parked (Procedures/Documents PDF, HACCP Excel, branding rule). ⚠ MIXED — some file mechanics, some DESIGN/DOMAIN (HACCP Excel keeps blue, Procedures PDF all-black, neither Mintek-branded; the prominent name on a HACCP plan is the CLIENT). ▶ MINTY SPLITS: design → Section 4; mechanics → 3A/Section 5. Parked, not lost. [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** Last string-interpolated proc call. id is app-controlled + numeric, risk LOW. Do it when the security pass next touches procs. [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. Every rebuild file lives on the un-backed-up prod box; the Drive copy is not verified current. Also at risk: deploy-frontend.sh, promote.sh, dev nginx vhost. [JR14 · JT20]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** Still valid, still in git history. ⚠ Sequenced AFTER the app.abletrace.ca domain switch, per Minty. [J1, J34]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. Safe: edit rows in place, append at end. NOT SAFE: insert mid-sequence; change hazard type on a saved row — either can silently duplicate/drop rows across the three stages. ⚠ DO NOT BUNDLE. [J4 · JT3]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ Known limitation, NOT a regression. Real fix is section-aware capture. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).** Pre-S72 J still sits below the rebuilt one. ⚠ Search it for anything the rebuild missed BEFORE deleting. Until gone, the REBUILT J (Section 5) is the true one; do not append to the old.

**P21  THE OS RESTART — PENDING SINCE S35.** Both boxes "System restart required" (confirmed still showing at S77 login), now Ubuntu 26.04 kernel. ⚠ Its own clean step: verify pm2 resurrects on 26.04 (pm2 save / pm2 startup) BEFORE relying on it, then reboot standalone. ⚠ Do DEV FIRST — true twin now, real rehearsal for prod.

**P22  DELETE THE OLD SECTION A after P1 folds it (housekeeping).** ⚠ Only after P1's map is read and approved. A is deleted, not edited.

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ Mac drifts onto IPv6; dev SG only allows one IPv4 /32, so SSH times out unpredictably. Add the Mac's IPv6 /128 (or accept `ssh -4` as the standing workaround). Stops the recurring lockout.

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).** ⚠ Removed during S72 testing, not restored. Dev fixture hygiene — do before reusing company 464 as a baseline.

**P27  DO-CREATE POPUP: Qty(Kg) shows "NaN" while typing Shipping Units.** ⚠ S76. On /Edit-SO → Create Dispatch Order popup: a partial number (e.g. ".") in Shipping Units makes derived Qty(Kg) show "NaN". Clears when valid. Should render BLANK. Display-guard gap, same family as Defect 2 / 3A.5 row 11. Transient only; no stored-data impact. [3A.5 row 11 · Defect 2 · GR5 R5]

**P28  MOVE THE S77 DEV-DB-ACCESS TRAP INTO A STABLE SECTION.** ⚠ NEW, S77. The dotenv-banner-corrupts-a-shell-variable trap + the temp-cnf recipe currently live only in this NOW block. They belong in 3B.3 (databases/access) or Section 0's terminal traps. Do it when 3B is built.

> ⚠ Note: the queue jumps P24 → P27. P25/P26 were assigned in S75 (not carried into this file). Minty reconciles the numbering at re-rank.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
```

---

**END SECTION 1**
