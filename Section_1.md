# SECTION 1 — NOW

> Rewritten WHOLE every session. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5.

---

# ▶▶ S87 HANDOVER — READ THIS BLOCK FIRST, BEFORE ANYTHING ELSE

```
THE GOAL      PROMOTE 16 COMMITS TO PROD. That is the whole session.
              ⚠ NOT the barcode. NOT P42. Both come after.

⚠ PASTE ONLY THESE FOUR — not all eight
    Section_0.md    the rules
    Section_1.md    this file, the driver
    Section_3B.md   boxes · promote commands · rollback points
    Section_5.md    ⚠ truncates at J88; fine for a promote, the JT
                    trap block is inside the readable part. Only
                    paste the tail if something goes wrong.
  ▶ SKIP 2, 3A, 4 and 6. A promote needs no domain logic, no module
    map, no design spec and no history. Saves roughly half the
    context for the work itself.

FIRST THREE ACTIONS, IN ORDER
  1  Health-check BOTH boxes (rule 1.1). ⚠ Read the promote range
     FROM GIT, never from this document, and use prod's SERVED
     bundle (53db203d), never its checkout (9bce0238) → P8.
  2  Run the reconcile oracle on PROD, UNSCOPED. It was empty at
     S86 open and must still be empty before anything deploys.
  3  BACKEND FIRST, THEN FRONTEND, no pause between (J96).

THE REGRESSION PAIR (rule 5.2 / J78)
     Document save with BOTH an apostrophe AND a pasted image.

AFTER DEPLOYING
     Prod oracle again, unscoped. Then create a slip, save it,
     cancel it, and confirm the quantity returns. ⚠ That is the S86
     cancel fix landing on real infrastructure for the first time.

⚠ MECHANICAL TRAPS THAT COST S86 TIME — all avoidable
   · STUCK PASTE BUFFER replaying old scrollback. BIT TWICE. Only
     closing the terminal window and opening a fresh one clears it.
   · ssh typed while ALREADY ON DEV — the pem does not exist on the
     boxes. Check the prompt colour before pasting (rule 6.2).
   · A github URL pasted into the terminal. URLs go in the BROWSER;
     Claude must never format one inside a command block.
   · git push prompts for a password on dev — the PAT is missing
     from the remote → P58.

⚠⚠ THE TRAP THAT COST MOST, AND NO HANDOVER FIXES IT
   S86 spent four hours on FOUR WRONG THEORIES about the cancel
   defect before running a ten-minute test that settled it. Rule
   0.1a. IF THE BEHAVIOUR IS REPRODUCIBLE ON A SANDBOX, REPRODUCE
   IT FIRST AND READ THE CODE SECOND. → J109.
```

---

## ▶ RESUME — what S86 actually did

```
⚠⚠ FIVE COMMITS, ALL PROVEN IN THE DB OR THE PRINT PREVIEW.

  1  P53 CANCEL FIXED (44759a9, backend). Reproduced on demand,
     fixed, re-proven on a reconciled baseline. Cancel now returns
     every DO's quantity from the STORED join rows.
  2  P7 STEP B (6b269ab3, frontend). The 4b read-only row mirrored
     onto CREATE. P45 and P49 closed with it.
  3  P56 (13e3fcd, backend). getPSs matched DO objects BY ARRAY
     INDEX and was PROVEN MISMATCHED on a live slip. Now matches
     by id. ⚠ This was S83's "D3", logged in a handover and left
     without a queue number for three sessions.
  4  P52a (ba3bfe9f, frontend). ⚠ THE PRINTED PACKING SLIP IS NOW
     ITS OWN DOCUMENT, split from the editing screen.
  5  P52a typography (8997acdc, frontend). Fixed column widths,
     larger type, proper spacing.

⚠ COMPANY 464 IS FULLY RECONCILED — first time since S83.
⚠ NOTHING IS ON PROD. All five are dev-only.

⚠⚠ SCOPE CHANGED MID-SESSION, AND THE RECORD MUST SAY SO. The
   frozen P52 spec's section 11 reads "NOT PART OF P7 ... P52 IS
   ITS OWN SESSION." MINTY OVERRULED THAT IN S86: the printed slip
   IS P7's endpoint — it is the thing he has been trying to build
   for six sessions, and the field work was scaffolding for it.
   ▶ Section 11 of the frozen spec is now WRONG. Correct it when
     the spec folds into Section 4.
```

## DOCS REPO — the standing paste

```
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  ⚠⚠ CLAUDE CANNOT BUILD A FETCH URL ITSELF. EVERY SECTION NEEDS
    ITS OWN FULL URL, AS TEXT, IN THE CHAT. Fetching one file does
    NOT unlock the others — TESTED AND DISPROVEN S85, again S86.
  ⚠ A repo URL does not work. A directory URL does not work. A
    screenshot of a URL does not work. Only full file URLs, as text.

https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_0.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_1.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_2.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_3A.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_3B.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_4.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_5.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_6.md

  ⚠ PASTE ONLY WHAT THE TASK NEEDS (rule 10.4). The eight-line
    paste is the DEBUGGING default, not the universal one.

  ⚠⚠ SECTION 5 CANNOT BE FETCHED IN FULL — MEASURED S86. 2711
    lines / 158 KB; the fetch TRUNCATES MID-J88, twice, at the same
    byte. A SIZE LIMIT, NOT A CACHE — retrying changes nothing.
    Claude gets the whole JT block, the whole JR block, and J1–J88.
    ⚠ J89 ONWARDS MUST BE PASTED BY MINTY.
    ▶ THIS IS THE STRONGEST ARGUMENT FOR P42.
  ⚠ SECTION 0 RULES 0.3 AND 9C STILL CARRY THE OLD, WRONG
    INSTRUCTION ("give Claude the repo URL"). Not patched in S86 —
    the session went to code. ▶ Still outstanding.
  ⚠ CACHE  the raw URL can lag a fresh commit. Minty's web view is
    immediate truth. If a fetch looks stale, paste the section.
```

## ⚠ CARRY FORWARD — settled, do not re-open

```
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; STOCK-HOP findings stand.
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    Re-proven S85 and again S86 — DO-0009 carried 0.5 cleanly
    through every change made today.
  • THE PACKING SLIP FLOW (Minty, S82): move DOs → SAVE → shipping
    reference + vehicle condition → SHIP (terminal). → J97.
  • SHIPPED QUANTITY IS NOT AN OPERATOR INPUT (Minty, S84).
  • THE DO ROW IS A READ-ONLY DISPLAY OF THE DISPATCH ORDER
    (Minty, S85). ▶ Belongs in Section 2 — fold with P41.
  • THE UNIFORM QUANTITY STRING: <units># (<Kg> <uom>). Units read
    STORED, Kg DERIVED by multiplying.
  • ⚠ THE RECONCILE ORACLE. A DO's qty_shipped must ALWAYS equal
    the sum of its packingslipdos rows. Block below. Empty = clean.
```

---

## ⚠ P7 — BUILD COMPLETE INCLUDING THE PRINTED SLIP. ONLY THE PROMOTE REMAINS.

```
DONE AND PROVEN
  SLICE 1   backend ff5d183 — remove-one-DO returns qty per DO.
            ⚠ STILL UNTESTED end to end → P40.
  SLICE 2   auto-select by lot+customer+address. Proven 4x.
            ⚠ The CUSTOMER half is still unproven (J93).
  SLICE 3   stored packing_units instead of dividing Kg. S82.
  SLICE 4a  Save/Ship split. S82–S84.
  SLICE 4b  unified READ-ONLY DO row on EDIT. S85, 453f1f44. J104.
  STEP A    ⚠ CANCEL FIXED. S86, 44759a9. → J109.
  STEP B    ⚠ CREATE MIRRORED. S86, 6b269ab3. → J110. Closes P45+P49.
  P56       ⚠ id-match in getPSs. S86, 13e3fcd. → J111. Had to
            precede the printed slip: a mis-stitched row would put
            the WRONG LOT CODE on a customer's document.
  P52a      ⚠ THE PRINTED DOCUMENT. S86, ba3bfe9f + 8997acdc.
            → J112. Verified in Chrome's print preview.

STEP C  ⚠ PROMOTE. THE ONLY THING LEFT IN P7.

STILL OPEN INSIDE P52 — not blocking the promote
        · THE BARCODE. Design frozen, NOT BUILT. Minty's call S86:
          structure first, barcode second. P47 folded into P52.
        · OPEN 2 group rows by PO · OPEN 3 print before ship
          (⚠ S86 PROVISIONALLY MADE PRINT ALWAYS VISIBLE so the
          document could be seen without shipping terminally —
          ONE *ngIf TO REVERT, Minty's call) · OPEN 4 allergens.
        · TOTALS and PAGE FOOTER — cut "for the time being" (S85).
        · ⚠ DATE FORMAT DISAGREEMENT: Minty's mockup shows
          "24 July 2026"; the frozen spec §7 says "01 Jul 2027".
          S86 followed the SPEC (abbreviated). ▶ Minty to confirm.
        · LOGO — no column exists → P54. Slot is reserved and
          renders as an empty bordered square until then.
        · ⚠ CHROME'S OWN HEADERS/FOOTERS (date, page title, URL)
          print by default and CANNOT be removed with CSS. They are
          switched off under More settings in the print dialog.
          ▶ Worth telling any client who prints these.

STILL INSIDE P7, SMALL
        · The DO picker POPUP TITLE still says "Dispatch Orders".
        · P44 vehicle_condition never written on edit.
          ▶ RIDE ALONG OR SEPARATE: asked S85 AND S86, STILL
            UNANSWERED. Minty's call.

CUT FROM P7 — DO NOT REINSTATE
        · Slice 4c / the sequencing change (S84).
```

---

## HEADS — ⚠ verify against the boxes before working (rule 1.2)

```
Frontend  DEV  8997acdc   ⚠ AHEAD OF PROD — 10 commits
          PROD 53db203d   served bundle
Backend   DEV  13e3fcd    ⚠ AHEAD OF PROD — 6 commits
          PROD d3104ea

⚠ BOTH BOXES HEALTH-CHECKED S86 AND CLEAN.
  DEV   trees clean · pm2 abletrace-dev online · curl 200
  PROD  backend d3104ea · tree clean · pm2 online · curl 200.
        Frontend CHECKOUT reads 9bce0238 — the S66 lag trap,
        expected, cosmetic → P8.
  ⚠ PROD'S SERVED BUNDLE STILL HAS NOT BEEN INDEPENDENTLY READ.
    Still a claim, not a reading. Carried since S85.

S86 COMMITS
  backend   44759a9  P53 cancel returns qty from stored rows
            13e3fcd  P56 getPSs matches DO objects by id
  frontend  6b269ab3 P7 step B, create row + validators deleted
            ba3bfe9f P52a printed slip as its own document
            8997acdc P52a typography and fixed column widths

ROLLBACK POINTS
  DEV frontend build  /home/ubuntu/www-html.bak-dev-<sha>
  DEV backend cancel  /home/ubuntu/PackingSlips.js.bak-S86-cancel-20260725-211209
  DEV backend P56     /home/ubuntu/PackingSlips.js.bak-S86-P56-20260725-224535
  DEV step B          /home/ubuntu/create-packslips.component.{html,ts}.bak-S86-stepB-20260725-220420
  DEV P52a            /home/ubuntu/P52a.{html,ts,styles-scss}.bak-S86-<stamp>
  DEV P52a visual     /home/ubuntu/styles.scss.bak-S86-P52a-visual-20260725-231007
  or                  git revert <sha>
  PROD frontend       www-html.bak-prod-53db203d4ef4
```

## ⚠ CI — PUSH AUTO-BUILDS DEV

```
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → deliberate manual dispatch.
⚠ THE ARTIFACT NAME CARRIES THE COMMIT SHA — dist-dev-<full-sha>.zip
  Match on the SHA, never the timestamp. → P12.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S86-verified, used 3x)

```
1  [DEV]  edit + commit + push
2  BROWSER  github.com/Mintygadhok/abletrace-lab-frontend/actions
           wait for green (~8 min)
3  BROWSER  open the run, download the artifact
4  [MAC]  ZIP=$(ls -t ~/Downloads/dist-dev-<sha8>*.zip | head -1)
          echo "MATCH: ${ZIP:-none}"
          [ -n "$ZIP" ] && ~/promote.sh "$ZIP" dev
5  BROWSER  Cmd+Q ENTIRELY. Not a hard reload (J66).

⚠ promote.sh lives on the MAC, not on a box.
⚠ ssh/scp always from the MAC:
    ssh -4 -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
    (the -4 is the S73 IPv6 workaround → P23. ⚠ S86: scp worked
     WITHOUT -4 — the drift is intermittent, not constant.)
⚠ A BACKEND CHANGE NEEDS pm2 restart + sleep 8 + curl. A FRONTEND
  change needs a CI build. Do not confuse the two.
```

## ⚠ HANDING PATCH SCRIPTS TO MINTY — the scp route

```
⚠ PASTING LONG PATCH SCRIPTS INTO THE TERMINAL FAILS. → P46.
⚠ THE WORKING METHOD — used FOUR TIMES in S86, no failures:
    1  Claude writes the patch and hands it over as a FILE (0.2b)
    2  [MAC]  scp -i ~/.ssh/abletrace-lab-key.pem ~/Downloads/<patch>.py ubuntu@16.55.10.205:/tmp/
    3  [DEV]  python3 /tmp/<patch>.py
    4  [DEV]  git --no-pager diff
⚠ MINTY MUST DOWNLOAD THE FILE BEFORE THE scp.
⚠ THE BOX LABEL GOES ABOVE THE BLOCK, NEVER INSIDE IT.
⚠ AND CHECK WHICH BOX THE PROMPT SAYS (rule 6.2).
```

## ⚠ THE STANDING QUERIES — build a temp cnf from .env (J43)

```
A bare `mysql` on dev hits a nonexistent local socket. This block
is ONE PASTE and self-cleans.

⚠ THE RECONCILE ORACLE — run after EVERY quantity change.
  Empty = clean. ⚠ Add `WHERE d.company_id=464` to scope it on dev;
  on PROD run it UNSCOPED to catch the real client.

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "SELECT d.id, d.internalCode, d.company_id, d.qty_shipped AS tally, COALESCE(SUM(p.shipped_qty),0) AS rows_total, COUNT(p.id) AS row_count FROM dispatchorders d LEFT JOIN packingslipdos p ON p.DO_id=d.id GROUP BY d.id, d.internalCode, d.company_id, d.qty_shipped HAVING d.qty_shipped <> COALESCE(SUM(p.shipped_qty),0);"
rm -f /tmp/q.cnf

⚠ ON PROD ~/.my.cnf EXISTS — no temp cnf needed. But it points at
  the ARCHIVE, so NAME THE DB:  mysql abletracelab_live -e "<QUERY>"
⚠ THE JOIN TABLE IS packingslipdos — ALL LOWERCASE. → P48.
⚠ `rows` IS A RESERVED WORD in MySQL 8. Alias it row_count. (S86.)
```

## ⚠ IDENTIFIERS — TWO SYSTEMS

```
⚠ THE SCREEN SHOWS internalCode.  THE ORACLE RETURNS id.
⚠ NEVER NAME A SLIP OR DO BY DB id IN THIS SECTION. → JT25.

  id ↔ code, company 464, confirmed S86:
    10910 = DO-0004 · 10911 = DO-0005 · 10924 = DO-0010
    10925 = DO-0011 · 10926 = DO-0012
```

## DEV FIXTURE STATE — ⚠ AS AT S86 CLOSE. RE-QUERY BEFORE TRUSTING.

```
⚠⚠ COMPANY 464 IS FULLY RECONCILED. Oracle empty at S86 close,
  confirmed three times including after an edit-screen save.
  ⚠ THE S85 DRIFT IS HEALED — DO-0004, DO-0005, DO-0010 and
    DO-0011 all reset to the sum of their own join rows AFTER the
    fix was proven, not before. That ordering was deliberate:
    they were the reproduction.

SLIPS at S86 close (company 464)
    PS-0025   LIVE — DO-0010, DO-0011, both 1 unit. THE PRINT
              FIXTURE. ⚠ NOT SHIPPED — keep it that way.
    PS-0024   live, created during step B verification
    PS-0021 · PS-0020   cancelled during the S86 proofs
    PS-0001..0004 · PS-0012   older, untouched all session
    ⚠ PS-0012 / DO-0009 carries 0.5 units — THE FRACTIONAL
      FIXTURE. Survived every S86 change. KEEP IT.

⚠ CLOSED S86: DO-0006's "unexplained" behaviour (J105). It simply
  reconciles. Not an anomaly. Nothing to chase.
⚠ CLOSED S86: "who cancelled PS-0008 and PS-0015" is retired. Never
  answered, not load-bearing, and cancel now destroys its own
  evidence by design. Do not re-open.

STANDING FIXTURE DEFECTS (unrelated to P7)
    1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
    2. MAT-6 missing its Sesame allergen       (S73 → P24)
    3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)
```

---

## PENDING WORK — everything outstanding, in priority order

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠ THE FULL RE-RANK IS STILL OUTSTANDING — no full pass since S73, now FOURTEEN sessions. ▶ Minty's, one pass, at session open.

**P7  PACKING-SLIP REDESIGN — ⚠ BUILD COMPLETE. ONLY STEP C (PROMOTE) REMAINS. See the P7 block above.**

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG. ⚠ MINTY'S #3 PRIORITY, AFTER THE PROMOTE.** ▶ 5A = JT traps + JR rebuild checklist. 5B = J-entries. ⚠⚠ J-NUMBERS ARE PERMANENT. ⚠ Also update rule 0.3 and rule 9. ⚠ **S86 MADE THIS URGENT, NOT COSMETIC:** at 2711 lines / 158 KB the file EXCEEDS WHAT CLAUDE CAN FETCH — everything past J88 is invisible unless Minty pastes it. Measured, not estimated.

**P1  DOCUMENTATION CONVERGENCE — ✅ DONE.** ⚠ REMAINING: delete the two dead physical files → P20 and P22.

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT.
  • Products list (admin-formulation.component.ts:878) divides separately.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. Copy it.
⚠ **THE PACKING-SLIP SITES ARE ALL CLOSED** — S82 (five), S85 (two), S86 (create's save path now reads the stored unit count, J110).
⚠ **S86 SITE — THE DISPATCH ORDERS LIST.** `/Dispatch-orders` renders shipped quantity as `0 Kg(0#)` while the DB holds 1. ⚠ DISPLAY ONLY — verified against the DB the same minute. Pre-existing.
⚠ **S81 SITE:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91 · J104 · J110]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** ✅ PRECONDITION MET S81. ⚠ P6 AND P52's BARCODE ARE TWO ENDS OF ONE LOOP — design them together or they will not meet. [3A.3 · J89]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** ⚠ Confirmed again S86. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ FormData stringifies blanks so the string 'null' reaches the backend → J98. ⚠ STILL VISIBLE S86 — "Customer PO No" shows the literal word `null` on the EDIT SCREEN. ⚠ The printed document guards it with an em dash regardless (J112); the screen does not.

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK — it now holds SIX S86 backups and nothing else does. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** ⚠ RELATED TO P52 — S86's print CSS now carries `page-break-inside: avoid` on table rows, which is the pattern P19 needs. [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed on every S86 login. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ S86: `scp` connected WITHOUT `-4`, so the drift is intermittent. Keep using `-4`. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ⚠ TIES TO P52 OPEN 4. [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** [3B.2 · J84]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** [J87]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ FOOD-SAFETY-CRITICAL: JT8. Lines 609, 632, 1063. [JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP — ⚠ STILL UNTESTED.** ⚠ S86: the deletedDos branch (ff5d183) was NOT touched by the cancel fix and already reads the stored join row, so it is PROBABLY correct — ⚠ a reading of the code, NOT a test. ▶ Exercise it once: remove one DO from a saved slip, Save (not Ship), confirm the tally returns. [J92 · J105 · J109]

**P41  WRITE THE SETTLED RULES INTO SECTION 2 — ⚠ FIVE EDITS, ONE PASS.**
  1. A DO coming off a slip ALWAYS returns its quantity. ⚠ REISSUE §2 Core #2's sentence WHOLE. ⚠ S86: the code NOW IMPLEMENTS THIS — record the rule, and note it was not implemented until 44759a9.
  2. The three-step flow (move → save → ship) is settled domain logic (S82).
  3. Shipped quantity is not an operator input (S84).
  4. THE DO ROW IS A READ-ONLY DISPLAY. Nothing typed.
  5. THE UNIFORM QUANTITY STRING: `<units># (<Kg> <uom>)`.
[J92 · J97 · J104 · J109]

**P43  SHIPPING REFERENCE → MULTIPLE INVOICES, QUICKBOOKS-READY.** ⚠ DESIGN DECIDED, BUILD DEFERRED: a CHILD TABLE, not delimited text. ⚠ DB CHANGE → rule 4.8. [J97]

**P44  editPackslips NEVER WRITES vehicle_condition.** ⚠ An operator can pick a condition, ship, and have it silently discarded. ▶ Asked S85 AND S86, STILL UNANSWERED. [J98]

**P46  TERMINAL PASTE TRUNCATION — INVESTIGATE, DO NOT KEEP GUESSING.** ⚠ TWO THEORIES DISPROVEN. THE WORKAROUND WORKS: files + scp, four for four in S86. ⚠ SEPARATE BUT RELATED, BIT TWICE IN S86: a STUCK PASTE BUFFER replaying old scrollback — only a fresh terminal window clears it.

**P48  NAMING DEFECTS. Cheap individually, expensive in aggregate.**
```
moStartDate               holds a LOT CODE, not a date
sales_order_num           holds the SYSTEM SO   ("System SO No")
sales_order_num_system    holds the CUSTOMER's ref ("Customer PO No")
shipment_order_units  vs  shipping_order_units
"MO Lot Code" vs "Pdt Lot Code"   SAME THING, two captions
"PackingSlipDOs"          the table is packingslipdos, lowercase
vehicle_no                holds the SHIPPING REFERENCE
```
▶ Rename the CAPTIONS freely (safe). ⚠ Renaming CONTROLS touches form bindings, patchValue keys and the payload.

**P50  UNDOCUMENTED FOLDER ON THE PROD BOX.** `/home/ubuntu/abletrace-lab-backend-dev` exists on PROD and is NOT a git repository. ▶ One `ls` and a config grep during the S87 promote, while on the box.

**P51  DELETE createEditItem / addEditItem (dead code).** PROVEN unreachable S85. [J106]

**P52  PRINTED PACKING SLIP — ⚠ STRUCTURE BUILT S86. BARCODE OUTSTANDING.**
✅ **DONE:** the document is split from the editing screen, with its own markup and print CSS. Letterhead · slip number · Ship to / Shipping date · five-column two-line table · shipping reference · remarks · Shipped by printed / Received by blank. Real dates, em-dash blanks, fixed column widths. → J112.
⚠ **REMAINING:** the barcode (Code 128, one per unique customer PO, first occurrence, two row heights, tall rows must not split a page). ⚠ Depends on OPEN 5 — the free-text PO matching problem, shared with P6.
⚠ **DECISIONS STILL OPEN:** OPEN 2 grouping · OPEN 3 print-before-ship (provisionally YES in S86, one *ngIf to revert) · OPEN 4 allergens · the date-format disagreement between the mockup and the spec.
⚠ **THE FROZEN SPEC'S SECTION 11 IS NOW WRONG** — it says P52 is not part of P7. Minty overruled that in S86.

**P54  COMPANY LOGO: STORE AND SERVE.** ▶ Add `company.logo varchar(255)` + ⚠ **the Waterline model attribute — BOTH, or the write is silently dropped (rule 4.7 / JT2)**. ⚠ The print template already reserves the slot. ⚠ DB change → rule 4.8. [J108]
⚠ **S86 CONFIRMED `company.address` REACHES THE LOGIN SESSION** — the letterhead renders it live. That half of J108 is settled.

**P55  COMPANY LOGO: SUPER ADMIN CAPTURE.** Upload on company CREATE and EDIT. ⚠ Depends on P54.

**P56  ✅ CLOSED S86 (13e3fcd).** getPSs matched DO objects by array index; proven mismatched on PS-0020. Now matches by id. → J111.

**P57  CANCEL IS NOT BLOCKED AFTER SHIP AT THE BACKEND.** `inActivatePS` gates on `status_id: 1`, but shipping sets `shipped_flag`, NOT `status_id` — so a shipped slip still satisfies the gate. Only the frontend hides the button. ⚠ §2 says ship is TERMINAL. ▶ DOMAIN QUESTION FOR MINTY: should the backend refuse? If yes it is a one-line guard.

**P58  THE DEV REMOTES DO NOT CARRY THE PAT.** `git push` prompted for a password on every push in S86 — five times. 3B.9 says the token is embedded. ⚠ Minutes. ▶ Reset both remote URLs.

**P59  PROD'S PM2 RESTART COUNTER READS 335 AGAINST DEV'S 33.** Appears in no section. ⚠ "Almost certainly accumulated deploys" is reasoning, not a reading. ▶ One look at `pm2 describe abletrace-backend` during the S87 promote.

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good. P28 CLOSED S79. P35 CLOSED S84. P37 CLOSED S86 (prod SO-0004 is company 464 — sandbox). P45 + P49 CLOSED S86 (6b269ab3). P47 folded into P52. P53 CLOSED S86 (44759a9). P56 CLOSED S86 (13e3fcd).

---

## BANKED, AWAITING DEPLOYMENT

```
⚠ THE PROMOTE SET — 16 COMMITS. ⚠ RE-READ FROM GIT AT S87 OPEN,
  NOT FROM THIS LIST:
    git log --oneline <prod>..<dev>   on both repos

    FRONTEND  53db203d..8997acdc   (10)
      0f4c0344  S81 slice 2  DO-select popup, auto-select group
      897096b4  S82 slice 3  read stored packing_units (5 sites)
      db415d74  S82 slice 4a Save/Ship split, re-enable add-DO
      b324bcea  S83          cancel PS reads per-slip qty
      d223d6ed  S84 D2       edit doList loops the picker array
      c3d463c9  S84          shipped units pre-fill (fixes the 500)
      453f1f44  S85 slice 4b unified read-only DO row on EDIT
      6b269ab3  S86 step B   same row on CREATE, validators deleted
      ba3bfe9f  S86 P52a     printed slip as its own document
      8997acdc  S86 P52a     typography and fixed column widths

    BACKEND   d3104ea..13e3fcd    (6)
      ff5d183   S81 slice 1  deletedDos returns qty per DO
      2d22e5a   S82 slice 4a split save from ship in editPackslips
      df6d728   S82          vehicle_no null coercion
      083fc96   S82          vehicle_no blank -> empty string
      44759a9   S86 P53      cancel returns qty from stored rows
      13e3fcd   S86 P56      getPSs matches DO objects by id

  ⚠ USE PROD'S SERVED BUNDLE SHA (53db203d), NEVER ITS CHECKOUT
    (9bce0238). The checkout lags and gives a wrong range. → P8.
  ⚠ ORDER: BACKEND FIRST, THEN FRONTEND (J96). Between the two
    deploys the Ship button saves without shipping — harmless for
    minutes on dev, a live defect on prod. Do not pause between.
  ⚠ REGRESSION PAIR (rule 5.2 / J78): document save with BOTH an
    apostrophe AND a pasted image.
  ⚠ AFTER PROMOTING: run the reconcile oracle on PROD UNSCOPED.
    It was EMPTY at S86 open and must still be empty.

⚠⚠ THE S85 PROMOTION BLOCK IS LIFTED. P53 is fixed and proven.

⚠ PROD EXPOSURE, MEASURED S86: Glutenull has ZERO PACKING SLIPS.
  Only companies 464 and 465 have any. The cancel defect never
  touched real client data and NO DATA HEAL IS NEEDED ON PROD —
  the fix is forward-only.
```

**END SECTION 1**
