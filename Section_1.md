# SECTION 1 — NOW

> Rewritten WHOLE every session. ~1 page. The DRIVER, not a log.
> ⚠ THE TEST: if a line does NOT change session to session, it does not belong here — it belongs in the stable sections (2 / 3 / 3B).
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5. Only the live driving state stays here.

---

## ▶ RESUME HERE — S79 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S78 (closed clean — the fold's biggest piece landed)
THIS SESSION   S79 — BUILD SECTION 3B. Then finish the repo (4, 6).

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Raw base  https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/refs/heads/main/
  Minty     pastes the raw base + says "pull the docs" (+ the S79 opener).
  Claude    fetches Section_0 + Section_1 + Section_2 = the standing three.
            Others (3A/3B/4/5) fetched by name when the work needs them.
  ⚠ CACHE   the raw URL LAGS SEVERAL MINUTES behind a fresh commit. Minty's
            GitHub WEB VIEW is immediate truth. Do NOT conclude "it didn't
            commit" from a stale fetch. (Learned S76.)

WHAT S78 DID — do not re-derive:
  ✓ BUILT Section_3A.md — all 8 modules. 3A.4/3A.5/3A.7 carry full walked
    content; 3A.1/3A.2/3A.3/3A.6/3A.8 are SKELETON STUBS holding verified
    K1 database facts, with FRONT END / BACK END stamped NOT YET WALKED.
    Decision taken: A-lite (stub the missing tabs, invent nothing).
  ✓ SECTION K RETIRED. All 33 K1 actions + 13 K2 rows mapped and folded.
    K1 action 27 (Material Return) was nearly lost — caught by a coverage
    check, landed as 3A.5 row 11b.
  ✓ REBUILT Section_5.md whole — J82 appended; J9b, J10, J17 replaced;
    JT7 corrected. Verified by count: 20 JT / 14 JR / 75 J, zero lost.
  ✓ CLOSED the allergen conflict by live test → J82. See below.
  ✓ Ownership settled: CLIENT ADMIN owns Procedures + HACCP. Super Admin
    only SEEDS an initial template set. 3A.8 owns the sync mechanism,
    3A.7 owns the library.
  ✓ No app code touched. Boxes unchanged.

▶▶ THE NEXT JOB — SECTION 3B. THIS IS S79. ◀◀
   3B is ARCHITECTURE & INFRASTRUCTURE — what the app RUNS ON, as opposed
   to 3A which is what it DOES. Eleven blocks, listed in Section 0 rule 9B.
   ⚠ ITS FACTS ARE CURRENTLY SCATTERED across: this file's INFRASTRUCTURE
   block, Section 5's JR checklist (JR12/JR13/JR14 especially), and OLD
   SECTION A — which P1(c) retires and which contains KNOWN-FALSE facts.
   METHOD, same as S78 — it worked:
     1. Minty hands Claude SECTION A as a file.
     2. Claude produces a MAPPING FIRST — every A fact → its 3B destination,
        flagging every known-false one. SHOWS THE MAP. Writes nothing.
     3. Minty approves or corrects.
     4. Claude builds Section_3B.md. A RETIRES (→ P22).
   ⚠ KNOWN FALSE IN A TODAY — do not carry these forward:
     Ubuntu 24.04 → really 26.04 · RDS `abletrace` → that is the ARCHIVE,
     live is abletracelab_live · on-box build → DEAD, the box cannot build
     · "two environments" → there are THREE · duplicate SESSION 0 and S66
     blocks · "CURRENT POSITION (S42 close)" → 37 sessions stale.
   ⚠ P28 LANDS HERE: the S77 dev-DB-access trap + temp-cnf recipe currently
     live only in this NOW block. They belong in 3B.3.

⚠ CARRY INTO THE BUILD — corrections already made, do not re-open:
  • "Fix A" does not exist and never did (J81). ⚠ AT 3B BUILD TIME, grep the
    WHOLE repo for "Fix A" — any surviving pointer is dead.
  • The allergen snapshot does not exist (J80 + J82). ⚠ §2 still asserts it
    in TWO places — see the Section 2 fix list below.
  • Release does not explode intermediates (J80). Trace does. Different
    operations.
```

---

## ⚠ SECTION 2 STILL CARRIES THREE STRUCK CLAIMS — fix on next touch

```
These survived the S78 fold because 3A and 5 were the session's targets.
They are FALSE AS WRITTEN and are being read as settled domain law.

§2 Dated Domain Rules, "Edit integrity (S59)"
    reads: "As-made record is immutable (MO stores an allergen snapshot
    at production)." → FALSE. J80 + J82. Reword: allergens re-derive LIVE
    from the current recipe, through to past and produced lots. That is
    Minty's ruling and it is CORRECT — but it must not be described as a
    snapshot.

§2 GR7 schema map
    reads: "mlomanagement.allergens = longtext JSON snapshot."
    ⚠ The column exists. Whether it HOLDS anything is UNTESTED (J82).
    Do NOT reword to "unused" — reword only after someone SELECTs it.

§2 TO BE VERIFIED, item 8
    still states the fork ship_qty bug as "a REAL OPEN BUG" with "Fix =
    Fix A". → FALSE. J81. Rewrite to "CLOSED S77 (J81) — never a bug."
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

⚠ NO APP CODE TOUCHED IN S73, S75, S76, S77 OR S78 — all walk /
documentation / verification sessions. Boxes have been at these HEADs
since S71.
⚠ S78 DID NOT RUN THE HEALTH CHECK — documentation-only session, agreed
at open. Run it at S79 open before any work.
```

## INFRASTRUCTURE — verified in the AWS console S72, unchanged since. ⚠ TRUST THIS BLOCK (Section 3B is being built to hold it permanently; S79).

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
  → P28 (move into 3B.3 when built — that is S79's job).

THE SIZING EVIDENCE (old account 350466202408 — 2 live clients, 2 yrs):
  t3.small app box + db.t3.micro DB carried two real clients for two
  years. PROD SIZING IS FINE — do not upsize.
```

## LAST VERIFICATION (S78) — ALLERGENS: NO SNAPSHOT. CONFIRMED TWICE.

```
The claim that blocked the fold, settled by live test (J82) — and it had
ALREADY been settled by J80 in S73. The strike simply never reached the
other three documents asserting it.

  BASELINE  test260720 (FO-0007), built clean: no allergen. One material,
            Ginger Powder MAT-5, also no allergen. MO-0012 (lot
            Pdt-260721-2) produced and received, 10# = 10#. Allergens EMPTY.
  ACTION    added Eggs to MAT-5. Nothing else.
  AFTER     ⚠ the SAME completed MO-0012 now reads Allergens "Eggs".

VERDICT: allergens re-derive LIVE. No as-made snapshot exists.
⚠ BLAST RADIUS: one material edit rewrote the allergen on ALL SEVEN
products in the company sharing that ingredient, and on their existing
lots. Company-wide, immediate.
⚠ STILL UNTESTED (J80's caveat, still open): does mlomanagement.allergens
hold a stored value nobody reads? One SELECT settles it. → P29.

⚠ DEV FIXTURE RESIDUE — THREE ITEMS NOW. Note before reusing co464:
  1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
  2. MAT-6 missing its Sesame allergen       (S73 → P24)
  3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ Each line points at its Section-5 entry. EVIDENCE lives there, not here.

**P1  DOCUMENTATION CONVERGENCE — THE FOLD.** ⚠ MINTY-SET, S73. Three linked jobs.
- (a) ✅ **DONE S78.** Section 3 + Section K folded into Section_3A.md. K RETIRED.
- (b) REVIEW SECTION 4 (design). ⚠ MINTY-SET. The A23 design pointer lands here in the fold — confirm 4 is current and the incoming design material has a clean home. ⚠ Also absorbs P14's design half.
- (c) FOLD SECTION A into 3B and retire it — **THIS IS S79**. A duplicates the deploy/boxes/health/infra facts. Map every A fact to its new home and SHOW THE MAP BEFORE WRITING. Known-false list is in the resume block above.
- ⚠ STATUS: Sections 0, 1, 2, 3A, 5 are converted and live in the repo. Remaining: 3B, 4, 6.

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ MINTY-SET, S73. Priority order:
1. R5 DISPLAY SWITCH (DEFECT 2, the big one, LIVE on every product screen): read inventory_units / received_units directly instead of Kg÷wgt. Sites: admin-formulation:878; traceability getWduUnits; Trace_ProductHeaderView _su fields; Stock Info popup.
2. MO-CREATE round-trip (DEFECT 1): store the entered units, or carry batches at full precision. add-mlo.ts:204-205. ⚠ SEEN LIVE S78: MO-0007 plan reads 50.004#.
3. CLEANUP: DO/MR/intermediate-release subtract stored units instead of Kg×lot-ratio (remove R2-via-LogicI fragility). Add a units column to rejectmaterialandproduct (MR record is Kg-only). DELETE dead PS block PackingSlips:333-334 (do NOT repair).
4. R6: retire formulations.inventory (old Kg line) once display no longer reads it.
- ⚠ **FIRST, RESOLVE J13 vs J80 — IT SIZES THIS WHOLE ITEM.** J13 says the Products list SOH is a Kg-derived view that will "legitimately disagree" with inventory_units. J80 says it did NOT disagree — every unit move tracked exactly. S78's screenshots agree with J80 (10# / 10 Kg, no float garbage). ⚠ ONE OF THEM IS WRONG. If the display already reads the units line, R5 is much smaller than planned. Read what that column actually reads BEFORE planning.
- ⚠ Touches live-client display. Dev-first, verify-in-DB, promote. [3A.5 · §2 GR5 · J13 · J80]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** abletrace-lab-prod-old1 is deleted. Was to be deleted WITH a final snapshot — the only frozen record of the 8.0 DB. ⚠ UNVERIFIED. RDS → Snapshots.

**P4  FILE-SIZE GATE + ALERT SWEEP (pays back every session).** Browser-side file-size check with a proper message; fold into the alert→toaster conversion. ~448 alerts across ~110 files; 5 done. Every error reads "[object Object]" — a tax on every diagnosis. Fix the top ~10 error paths first. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** Untested code on the live box. Attach a file to a packing slip, confirm it lands. ⚠ Test attach-then-ship or an already-shipped slip — attaching to an unshipped slip loses the file (P7). [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default; only Receiving Ref + Vehicle Condition by hand. ⚠ FIRST read the existing MO-Release Global Select mechanism before designing. NOT STARTED. [3A.3]

**P7  PACKING-SLIP REDESIGN (major, linked to P6).** Slimmed 8-field customer row + unique-PO barcode. Absorbs the 3 remaining "Customer SO No"→"PO No". ⚠ ALSO FIXES: attaching a shipping doc to an UNSHIPPED slip silently loses it. ▶ DOMAIN CALL: should docs attach BEFORE dispatch? Minty's instinct: yes. [J74, J75, J16]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** A git pull tidies it; does not affect what serves. ⚠ Reading a file from prod's checkout shows code that is NOT LIVE (caused a stale read S70). A diagnosis trap, not an app bug. [S66 trap]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** DB column exists; code half does not. ⚠ Without it the toggle write silently does nothing. One line; unblocks Feature A. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ RULE SET S73. Name / Storage Temp / Shelf Life / My Code edit IN PLACE. Only material/composition change forks a version. Material AND Formulation edit. Also fixes My Code showing literal "null". ⚠ Shelf Life already editable — CONFIRM IT SAVES.

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** Button disabled but screen reachable by URL and saves. ⚠ A disabled button is not a control. Needs a backend guard. Logged S50. [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** 11+ old build artifacts back to S61. ⚠ The promote script deploys whatever zip you name — a stale-zip promote is a real risk.

**P13  FINISH GLUTENULL ONBOARDING.** Rename "Oats"→"Oats Gluten Free", add an "Oats" material, re-import the 4 failed products (importer dedups by title, re-import safe).

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS — WHERE DO THEY BELONG?** Three blocks parked (Procedures/Documents PDF, HACCP Excel, branding rule). ⚠ MIXED — some file mechanics, some DESIGN/DOMAIN (HACCP Excel keeps blue, Procedures PDF all-black, neither Mintek-branded; the prominent name on a HACCP plan is the CLIENT). ▶ MINTY SPLITS: design → Section 4; mechanics → 3A.7/Section 5. Parked, not lost. [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** Last string-interpolated proc call. id is app-controlled + numeric, risk LOW. Do it when the security pass next touches procs. [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK. Every rebuild file lives on the un-backed-up prod box; the Drive copy is not verified current. Also at risk: deploy-frontend.sh, promote.sh, dev nginx vhost. [JR14 · JT20]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** Still valid, still in git history. ⚠ Sequenced AFTER the app.abletrace.ca domain switch, per Minty. [J1, J34]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. Safe: edit rows in place, append at end. NOT SAFE: insert mid-sequence; change hazard type on a saved row — either can silently duplicate/drop rows across the three stages. ⚠ DO NOT BUNDLE. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ Known limitation, NOT a regression. Real fix is section-aware capture. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).** Pre-S72 J still sits below the rebuilt one. ⚠ Search it for anything the rebuild missed BEFORE deleting. Until gone, the REBUILT J (Section 5) is the true one; do not append to the old.

**P21  THE OS RESTART — PENDING SINCE S35.** Both boxes "System restart required" (confirmed still showing at S77 login), now Ubuntu 26.04 kernel. ⚠ Its own clean step: verify pm2 resurrects on 26.04 (pm2 save / pm2 startup) BEFORE relying on it, then reboot standalone. ⚠ Do DEV FIRST — true twin now, real rehearsal for prod.

**P22  DELETE THE OLD SECTION A after P1(c) folds it (housekeeping).** ⚠ Only after the map is read and approved. A is deleted, not edited.

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ Mac drifts onto IPv6; dev SG only allows one IPv4 /32, so SSH times out unpredictably. Add the Mac's IPv6 /128 (or accept `ssh -4` as the standing workaround). Stops the recurring lockout.

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).** ⚠ Removed during S73 testing, not restored. Dev fixture hygiene — do before reusing company 464 as a baseline. ⚠ NOW ONE OF THREE residue items; see the S78 verification block above.

**P27  DO-CREATE POPUP: Qty(Kg) shows "NaN" while typing Shipping Units.** ⚠ S76. On /Edit-SO → Create Dispatch Order popup: a partial number (e.g. ".") in Shipping Units makes derived Qty(Kg) show "NaN". Clears when valid. Should render BLANK. Display-guard gap, same family as Defect 2 / P30. Transient only; no stored-data impact. [3A.5 row 8 · 3A.4]

**P28  MOVE THE S77 DEV-DB-ACCESS TRAP INTO A STABLE SECTION.** ⚠ The dotenv-banner-corrupts-a-shell-variable trap + the temp-cnf recipe currently live only in this NOW block. They belong in 3B.3. ⚠ DO IT AS PART OF S79's 3B BUILD.

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ⚠ NEW S78. Editing a material's allergen rewrites the allergen shown on already-completed, already-shipped production lots — company-wide, immediately, with no audit trail of what the record said at ship time. Live re-derivation is CORRECT per Minty (a mis-declaration must be correctable on past data). ⚠ THE RISK IS THE REVERSE DIRECTION: an allergen genuinely present in a shipped lot can be REMOVED from its record by a later edit. ▶ DOMAIN CALL BEFORE ANY CODE: does a shipped lot need an immutable as-declared record alongside the live rollup? ⚠ ALSO OPEN, one query: does mlomanagement.allergens hold a stored value that is never read ("built and orphaned"), or nothing at all ("not built")? Answer that before rewording §2 GR7. [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** ⚠ NEW S78 (the action; the defect was logged S48). Display flips to #(Kg) after save; DB is correct throughout. Frontend-only. ⚠ Parked for "Route 5", never picked up — 30 sessions untracked. Same display-guard family as Defect 2 and P27; batch it with the R5 display switch rather than fixing alone. [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED — NO EXPIRY WARNING (minutes).** ⚠ NEW S79. Prod's Let's Encrypt cert was issued with NO contact email; confirmed via `sudo certbot show_account` → "Email contact: none". ⚠ SO PROD GETS NO RENEWAL-FAILURE WARNING. Auto-renew is scheduled, but if it ever fails silently the first symptom is a browser security warning on a LIVE CLIENT SITE. Dev was deliberately given info@abletrace.ca for exactly this reason — prod is the one that matters and is the one without it. FIX: register a contact email on prod's certbot account (`sudo certbot update_account -m info@abletrace.ca --agree-tos`), then confirm with `show_account`. ⚠ Does not touch the cert itself or reissue anything — account metadata only. [3B.6]

> ⚠ Note: the queue jumps P24 → P27. P25/P26 were assigned in S75 (not carried into this file). Minty reconciles the numbering at re-rank.

---

## BANKED, AWAITING DEPLOYMENT

```
Corrected v2 PDFs (Misc Release + Traceability label fixes).
```
**END SECTION 1**

