# S93 OPENING NOTE — paste this as your first message

⚠ THIS NOTE WAS WRITTEN AT S92 CLOSE, AFTER NOW.md.
  Unlike S92's note, it does not predate the record. But the rule
  still holds: WHERE THIS AND NOW.md DISAGREE, NOW.md WINS.

⚠ BEFORE S93: COMMIT THESE TO THE DOCS REPO. They were produced in
  S92's chat and DO NOT PERSIST.
  · NOW.md                                    (rewritten, replaces old)
  · TRAPS-additions-S92.md                    (append into TRAPS.md)
  · S93-opening-note.md                       (this file)
  · AbleTrace - Zebra Printer Installation Guide.docx

---

## THE ONE THING S93 IS FOR

```
P82 — THE ACROBATICS SWEEP. Minty's #1, set S92.
Resolve the whole units/Kg divide sweep. Not a survey — a resolution.

Everything else is below the line. The printer is done except for
mechanical tail work (P84) and Windows (P85), and neither should be
allowed to eat this session.
```

---

## PASTE LIST — ⚠ SECTION 2 IS NOT OPTIONAL

```
RULES.md
NOW.md
TRAPS.md
SECTION 2      ⚠ READ AT S92 CLOSE. IT IS THE MOST IMPORTANT FILE
               FOR THIS WORK. Every hit in the sweep reduces to one
               question — IS THIS FIELD UNITS-STORED? — and that is
               §2 Core #1. Without it, every judgment is a guess and
               the session produces confident wrong answers.
SECTION 3A     the module map. 3A.5 is the stock spine and carries the
               hop table with per-hop verdicts and the two stock lines.
SECTION 3B     3B.3 only — the temp .my.cnf recipe. Needed for Phase 3
               because dev has NO ~/.my.cnf and a bare mysql hits a
               nonexistent socket.

⚠ IF SECTION 2 IS NOT PASTED, SAY SO AND STOP. Do not sweep on
  inference about which fields are units-stored. S73 tested seven such
  claims against the live app: five were false, and three of those
  were already stamped "Confirmed" in the docs.
```

---

## FIRST THREE ACTIONS — in this order, no substitutions

```
1  HEALTH CHECK, BOTH BOXES.
   Six corrected commands at the FOOT OF TRAPS.md (the RULES OPEN
   block is still not pasteable — P68, third session).
   ⚠ Paste them as ONE block per box. In S92 the trailing command
     dropped off twice; send single lines if it recurs.
   ⚠ Read prod's SERVED build from the backup directory, not the
     checkout. Expect: dev 275c0250 / prod serving prod-275c025039d7 /
     both backends 13e3fcd.
   ⚠ COMPARE AGAINST NOW's STATE BLOCK. If they differ, STOP and
     reconcile the record before any work.

2  COMMIT THE MAP OFF DEV.
   /home/ubuntu/acrobatics-map-S91.txt — 157 lines, and /home/ubuntu
   is NOT BACKED UP (P16). This has been "commit it early" for two
   sessions running. Do it before anything can go wrong.
   ⚠ scp -4 from the MAC (the pem does not exist on either box).

3  STRIKE edit-formulation.component.ts.
   13 hits, 27% of the whole map, and almost certainly legitimate —
   it is where per-unit weight is SET, so reading wgt_kgs_per_unit is
   correct there. Confirm ONCE on screen, strike it, and stop it
   distorting every estimate for the rest of the sweep.
   ▶ Leaves ~141 hits across 47 files.
```

---

## ⚠ READ THIS BEFORE TOUCHING THE DEFECT LIST

```
NOW.md's OPEN DEFECTS list was CORRECTED at S92 close. It had carried
a claim that Section 3A struck in S78:

  "version fork copies qty (Kg) but writes ship_qty 0 for
   intermediates. Fix the fork handler in Formulations.js."

THIS IS FALSE AND WAS NEVER TRUE. → J81. The fork carries ship_qty
forward correctly. Create and fork share ONE handler,
methodForCreateFormula, present since 2022.

⚠ THERE ARE TWO OPEN DEFECTS IN THIS FAMILY, NOT THREE.
⚠ "Fix A before Fix B" sequencing is VOID — Fix A does not exist.
⚠ SECTION 2 IS CLEAN — its TO BE VERIFIED item 8 already records
  this as closed and calls "Fix A" a dead name. ONLY SECTION 5 STILL
  NEEDS THE GREP. → P88
```

---

## ⚠ WHAT SECTION 2 CONTRIBUTES — read before planning the sweep

```
Section 2 was read at S92 close. FIVE things it holds that the earlier
brief did not:

1  ⚠ A WORKING REFERENCE IMPLEMENTATION ALREADY EXISTS.
   PopUps/stock-info.component.ts:188 reads inventory_units and
   MULTIPLIES to derive Kg. That is R1, done correctly, in this
   codebase, today. → GR5
   ▶ READ IT FIRST. Every fix in this sweep copies that pattern.
     Do not invent one.

2  ⚠ R5 IS NOT A SWITCH. IT IS A CAMPAIGN OF ~30+ SITES, measured
   S79 against dev. GR5 says so explicitly and calls the old C/D/E
   list "a fraction of it, kept only as the starting thread."
   ▶ Scope accordingly. This is not a one-line change.

3  ⚠ A Math.round() AROUND AN ACROBATIC HIDES IT, DOES NOT FIX IT.
   It will still be wrong on a fractional shipping unit — and
   FRACTIONAL SHIPPING UNITS ARE PERMITTED BY DESIGN. → J88
   ▶ A clean-looking integer is NOT evidence the route is R1.

4  THE DISGUISED FORM IS ALREADY NAMED: (qty / batch) × (batch / wgt)
   is algebraically the same divide. → J83
   ▶ GR5's instruction: grep wgt_kgs_per_unit and READ EVERY HIT FOR
     A `/`. That is the whole search, stated in one line.

5  ⚠ P88 IS HALF-ANSWERED. Section 2's TO BE VERIFIED item 8 already
   records J81 as closed, names "Fix A" a DEAD NAME, and says any
   surviving pointer is dead. SECTION 2 IS CLEAN.
   ▶ Only SECTION 5 still needs the J81 / "Fix A" grep.
```

---

## ⚠ SETTLE THIS ON THE BOX BEFORE PHASE 3 — TWO DOCUMENTS DISAGREE

```
ON Trace_ProductHeaderView:

  3A.5 row 7   "R5(D) — trace reads received_units directly
                (ALREADY PRESENT IN THE VIEW)"
  §2 GR5       "THE VIEW ITSELF IS Kg-ANCHORED: every _su field is
                <Kg> / wgt_kgs_per_unit. NEITHER inventory_units NOR
                received_units APPEARS IN IT AT ALL."

BOTH CANNOT BE TRUE. Section 2 is LATER (measured S79 against dev;
3A was folded S78) so it probably wins — but that is reasoning, and
this is one command away.

⚠ IT CHANGES THE SIZE OF PHASE 3. If the columns are present, the fix
  is swapping which column the view selects. If they are absent, the
  view must be ALTERED to carry them — and it lives in RDS, NOT in
  git, so it also needs a Section 5 JR entry or it is lost on rebuild.

▶ ON DEV, after building the temp .my.cnf (3B.3):
    SHOW CREATE VIEW Trace_ProductHeaderView;
  Read whether inventory_units and received_units appear.
  ⚠ Name the database. A bare mysql on prod lands in the archive.
▶ Whichever is wrong, say so out loud and correct it at session close.
```

---

## THE METHOD — the only judgment that matters

```
For every hit, three questions. Stop at the first NO.

  Q1  IS IT A DIVISION?
      Reading wgt_kgs_per_unit is CORRECT wherever Kg is DERIVED
      (units × weight = R1). Multiplication is never the bug.
      NO → legitimate, strike it.

  Q2  IS THE DIVIDED FIELD UNITS-STORED?      → §2 Core #1
      NO → dividing a Kg field is legitimate.

  Q3  WHICH PATTERN?
      PATTERN X   qty / wgt                         → REAL BUG
      PATTERN Y   (qty / batch_qty) × (batch_qty / wgt)
                  batch_qty cancels                 → usually harmless

  Q4  ⚠ IS THERE A Math.round() AROUND IT?
      A rounding wrapper MASKS an acrobatic, it does not fix it. The
      result is still wrong on a fractional shipping unit, and those
      are PERMITTED BY DESIGN. → J88
      A clean integer on screen is NOT evidence of R1.

⚠ S43 DISPROVED "the rest are all Pattern Y". It found genuine bugs in
  the lot-code list path AND in a stored proc.
⚠ VERIFY EACH ON SCREEN. DO NOT BLANKET-EDIT. (rule LOOK)
⚠ THE FINGERPRINT (3B.11): a clean fraction on screen — 0.5128…# — is
  a units-stored field being divided. Ugly decimals are the tell.
⚠ NEVER VERIFY WITH A 1:1 FIXTURE (TRAPS). A weight ratio of exactly 1
  makes division invisible. Pick a product whose wgt_kgs_per_unit is
  not 1, and ideally not round.
```

---

## THE FOUR PHASES

```
PHASE 0   Map committed. Health check clean. edit-formulation struck.

PHASE 1   THE 34 REMAINING .ts FILES. Apply Q1/Q2/Q3.
            6  edit-mlc · edit-packslips · add-new-formulation
            5  select-material · mlo-list · edit-quantity-info ·
               add-dispatch-v2 · production-controller ·
               admin-formulation
            4  add-dispatch · mfg-lot-codes · receive-product ·
               product-traceability · material-traceability-details ·
               start-mlc · edit-sales-order · mlo-management · edit-mlo

PHASE 2   ⚠ THE 14 HTML TEMPLATES. Suspected in S41, NEVER CHECKED.
          MOST LIKELY PLACE FOR SURVIVORS. Templates cannot be
          reasoned about — they must be SEEN ON SCREEN.

PHASE 3   ⚠ DB VIEWS AND STORED PROCS. Backend api shows only ONE hit,
          but S43 proved real bugs live where NO FILE GREP REACHES.
          Needs the temp .my.cnf build (3B.3).
          Known target: Trace_ProductHeaderView — its _su fields
          compute Kg ÷ wgt. RDS only, NOT in git.
          ⚠ Name the database explicitly. A bare mysql on prod lands
            in the dormant archive.

PHASE 4   THE TWO OPEN DEFECTS. They ARE this family.
```

---

## THE TWO OPEN DEFECTS

```
DEFECT 1  MO CREATE stores 50.004 instead of 50 (want 10 → 10.008).
          Round-trips through Batches, a starred form field.
          Seen live S78: MO-0007 reads 50.004#.
          add-mlo.ts:204-205 · mlomanagement.qty
          3A.5 row 2 — the ONLY RED row in the hop table.
          ⚠ WRITE PATH. Higher risk.

DEFECT 2  DISPLAY rebuilds units as Kg ÷ weight → float garbage
          (stored 51, displays 51.00000000000001).
          THE STORED VALUE IS CLEAN. Display-only.
          admin-formulation:878 · getWduUnits ·
          Trace_ProductHeaderView _su fields
          FIX = R5 DISPLAY SWITCH: read inventory_units and
          received_units directly, stop dividing.
          ⚠ 3A.5 CALLS THIS "THE priority fix".
          ⚠ BUT §2 GR5 MEASURED IT AT ~30+ SITES (S79, against dev).
            It is a CAMPAIGN, not a switch. Scope it as such.
          ▶ COPY PopUps/stock-info.component.ts:188 — the one place
            that already does it correctly (reads inventory_units,
            multiplies to derive Kg).

⚠ SEQUENCING ARGUMENT — FOR MINTY TO RULE ON, NOT CLAUDE:
  Defect 2 and the sweep are LARGELY THE SAME WORK. The sweep finds
  divisions; R5 is the fix for the display divisions. Doing R5 first
  may clear a large share of the 48 files in one pass, and being
  display-only its blast radius is small. Defect 1 is a write path.
  ▶ ASK MINTY TO RANK AT SESSION OPEN. Do not choose.
```

---

## STANDING CONSTRAINTS THAT APPLY ALL SESSION

```
⚠ LIVE CLIENT. Prod carries Glutenull. Only 464 and 465 are sandbox.
  Always act by company_id.
⚠ DEV ONLY. Edit on dev. Never hand-edit prod. Never promote
  unverified code.
⚠ PATCHES AS FILES. Long scripts fail when pasted. scp -4 to /tmp/,
  run from there. Assert every anchor. NEVER assert on a string the
  patch itself introduces.
⚠ THE RECONCILE ORACLE runs after every quantity change: every DO's
  qty_shipped equals the sum of its packingslipdos rows.
⚠ DEV IS NOT A HOST REHEARSAL. prod 26.04, dev 24.04 (3B.2).
  Application layer only.
⚠ A COMMITTED .sql IS DOCUMENTATION, NOT AN APPLIED MIGRATION.
⚠ RAW GITHUB URLS SERVE STALE CONTENT. The web view is immediate
  truth. Test it, do not argue it.
⚠ THE COMMIT MESSAGE IS THE RECORD. What changed and WHY, written at
  the moment of committing. No "!" — bash eats it.
```

---

## BELOW THE LINE — do not let these eat the session

```
P84   Zebra Printer Installation guide into the app. MECHANICAL:
      export PDF → commit to src/assets/docs/help-guides/ → ONE entry
      in the guides array in client-guides.component.ts → push (builds
      DEV) → verify → manual dispatch → promote.
      ⚠ Still open: WHERE THE CARD SITS in the array. Minty's call.
      ⚠ No template edit needed — the template iterates the array.

P86   Cold boot blindness, still untested. Full restart on the second
      Mac, wait 2 minutes, load localhost:9101/available without
      touching Browser Print. RECORD WHETHER THAT MAC IS DIRECT USB
      OR ON A HUB — without it the answer means nothing.

P85   Windows guide. Needs a Windows machine walked the same way.

P58   Dev remotes still prompt for the PAT. Five-minute fix, costs a
      manual paste at the worst possible moment every time.

P64   Label prints "null" for Ext ID twice, on prod. ⚠ LIKELY A
      DISPLAY-GUARD BUG (P10/P27/Defect 2 family), NOT a label bug —
      3A.4 records the same literal "null" in the SO chain. Patching
      the ZPL would MASK it. Belongs with P82's family, arguably.
```

---

## WHAT S92 ACTUALLY DID — one paragraph, for context only

```
Health check clean on both boxes, prod's served build verified from
the backup directory rather than the checkout. The printer client
procedure was written to house style and then VALIDATED BY A REAL
WALK on a second Mac treated as a new client — which found the
download path was wrong, that Browser Print sits under Software and
not Drivers, and above all that THERE ARE THREE PERMISSION BARRIERS
AND S91 HAD DOCUMENTED ONE. The guides screen was found to be
array-driven, so a ninth guide is one array entry plus a PDF. P77 was
tested for the first time and did not reproduce. Four new queue items,
five new TRAPS entries, and one false claim struck from NOW.
```
