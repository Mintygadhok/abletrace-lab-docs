# SECTION 1 — NOW

> Rewritten WHOLE every session. The DRIVER, not a log.
> ⚠ THE TEST — BOTH DIRECTIONS. If a line does NOT change session to session, it does not belong here (it belongs in 0 / 2 / 3A / 3B / 4). And if a STABLE section needs editing every session, that content belongs HERE.
> Paste order (or repo-pull order): Section 0 → Section 1 (this) → Section 2. Others on demand.
> ⚠ THE #1 DISCIPLINE: keep HISTORY out of NOW. When a story is told, it goes to Section 6. Evidence goes to Section 5B.

---

# ▶▶ S87 HANDOVER — READ THIS BLOCK FIRST, BEFORE ANYTHING ELSE

```
THE GOAL      ▶ MINTY'S CALL, S86: P61 THEN P42. FINISH THE
              SECTION 5 SPLIT. That is the whole session.
              A DOCUMENT SESSION — no code, no boxes, no deploy.
              Everything happens in ~/abletrace-lab-docs on the MAC.
              ⚠ P61 FIRST. The split ABORTED in S86 rather than
                ship a 5A missing five traps. Move them, then cut.
              ▶ S88 IS ALREADY CHOSEN: P3, then P4, then P2.
                ⚠ P3 is minutes; P4 and P2 are CAMPAIGNS. S88's
                goal is START AND MAKE PROGRESS, not close them.

THE PASTE LIST  (rule 10.4 — named by task, not by habit)
    Section_0.md    the rules — ⚠ AND THE THING BEING EDITED:
                    rules 0.3, 9 and 9C must be updated to name
                    5A and 5B. Not just a reference this time.
    Section_1.md    this file, the driver
    Section_5.md    ⚠ THE SUBJECT OF THE WORK. It truncates around
                    J88 — paste the tail separately when the split
                    itself runs.
  ▶ NOT 3B. No boxes, no promote, no rollback points — P42 never
    leaves the Mac. NOT 2, 3A, 4 or 6.

⚠⚠ THE SCRIPT ALREADY EXISTS — DO NOT REWRITE IT FROM SCRATCH.
    ~/Downloads/patch-S86-split-section5.py
  Written and tested in S86. Its anchors are PROVEN: body bytes
  in == out, 104 entries indexed, and both prose lines that mimic
  an entry header were correctly refused. It aborts cleanly if
  either output file already exists.
  ⚠ TWO KNOWN FIXES BEFORE IT RUNS:
    1  carry JT23-JT27 into 5A  (that is P61, do it first)
    2  widen the index pattern — J85 is rejected because its
       title opens with a quote mark. Index should be 105, not 104.
  ⚠ IF THE FILE IS GONE FROM ~/Downloads, say so at open. Claude
    can rebuild it, but knowing it existed saves the rediscovery.

FIRST THREE ACTIONS, IN ORDER
  1  cd ~/abletrace-lab-docs && git pull
     git log -1 --oneline    ▶ expect 95582df or later
     ls -la *.md             ▶ expect Section_5.md at ~190 KB and
                               NO Section_5A/5B (S86 removed the
                               aborted attempt cleanly)
  2  P61 — read the five trap blocks and get their EXACT bounds
     before writing anything. They are at roughly lines 2418,
     2861, 2891, 2912 and 3082, but ⚠ THOSE NUMBERS ARE FROM THE
     PRE-REPAIR FILE. Re-grep; 70afcae changed the line count.
  3  P42 — fix the two script issues, run it, read the index,
     `git rm Section_5.md`, then update rules 0.3, 9, 9C AND the
     paste list in this document.

⚠ NO HEALTH CHECK NEEDED. Rule 1.1 is about the boxes and this
  session does not touch them. Dev and prod were IN SYNC at S86
  close — backend 13e3fcd, frontend 8997acdc on both.

TRAPS THAT COST TIME IN S86 — all avoidable
   · ⚠⚠ THE RAW CDN SERVED A STALE SECTION 1, TWICE, HOURS
     AFTER THE COMMIT LANDED. Claude explained it away both times
     instead of re-fetching. THE TELL: Claude describing the
     PREVIOUS session's plan as though it were today's. That cost
     the first third of S86. ▶ If a section looks older than the
     work you know was done, PASTE IT.
   · ⚠⚠ FOUR HOURS ON FOUR WRONG THEORIES about the cancel
     defect before a ten-minute test settled it. ▶ IF IT IS
     REPRODUCIBLE, REPRODUCE IT FIRST AND READ THE CODE SECOND.
     → J109.
   · ⚠ A DOC PATCH FAILS SILENTLY. Nothing breaks, the file just
     reads fine and is wrong. S86 shipped a commit claiming
     "J109-J112" that actually pasted J109/J110 TWICE and wrote
     neither J111 nor J112. ▶ COUNT THINGS AFTER EVERY DOC PATCH.
   · STUCK PASTE BUFFER and a lingering ":" pager. Control-C,
     then q. If the prompt still misbehaves, OPEN A FRESH
     TERMINAL WINDOW — the only reliable clear. ⚠ IT ALSO EATS
     WHOLE COMMANDS: S86's final `git commit` and `git push`
     both silently failed to run. VERIFY WITH git log, NOT with
     the absence of an error.
   · A URL PASTED INTO THE TERMINAL. URLs go in the BROWSER;
     Claude must never format one inside a command block.
   · git push prompts for a password on dev → P58.
```

---

## ▶ RESUME HERE — S87 START (Claude reads this FIRST, before anything)

```
LAST SESSION   S86 — ⚠⚠ EVERYTHING SHIPPED. SIXTEEN COMMITS
               PROMOTED TO PROD AND VERIFIED LIVE.
               P53 cancel FIXED and PROVEN (44759a9).
               P7 STEP B built (6b269ab3) — create mirrored.
               P56 fixed (13e3fcd) — getPSs id-match.
               P52a: THE PRINTED SLIP IS ITS OWN DOCUMENT
               (ba3bfe9f + 8997acdc).
               ⚠ P7 IS CLOSED. Six sessions of work is on prod.
               P42 STARTED: Section 5 de-duplicated, J111 + J112
               written, split ATTEMPTED AND ABORTED on a real
               finding (see P58).

THIS SESSION   S87 — P61 THEN P42. FINISH THE SECTION 5 SPLIT.
               ▶ MINTY'S CALL, MADE AT S86 CLOSE. The handover
               block above carries the paste list, the script
               location and the two fixes it needs.

               ▶ S88 IS ALSO CHOSEN: P3, then P4, then P2.
                 ⚠ P3 is minutes. P4 (448 alerts) and P2 (~30
                 division sites) are CAMPAIGNS — S88's goal is
                 START AND MAKE PROGRESS, not close them.

               ⚠ THE FULL RE-RANK IS STILL OUTSTANDING. Minty has
                 ranked the next TWO sessions, not the whole list.
                 No full pass since S73 — fourteen sessions.
                 ▶ Raise it again at S89 open.
               ⚠ P13 (Glutenull onboarding) REMAINS THE CLOCK for
                 everything outbound — see the note below.

⚠⚠ THE CLOCK, STATED PLAINLY. Glutenull has NO dispatch orders
   and NO packing slips on prod (queried S86, and Minty confirms
   there is no meaningful client data yet). EVERY outbound defect
   found so far has therefore cost nothing real. THAT ENDS THE DAY
   P13 COMPLETES. After that, a cancel/quantity defect writes
   permanently wrong traceability data for a real food business.
   ▶ Anything outbound-critical should land BEFORE P13, not after.

DOCS REPO IS LIVE — this is the standing paste.
  Repo      Mintygadhok/abletrace-lab-docs   (public)
  Web       https://github.com/Mintygadhok/abletrace-lab-docs
  ⚠⚠ CLAUDE CANNOT BUILD A FETCH URL ITSELF. EVERY SECTION NEEDS
    ITS OWN FULL URL, AS TEXT, IN THE CHAT. Fetching one file does
    NOT unlock the others — TESTED AND DISPROVEN S85.
  ⚠ A REPO URL DOES NOT WORK. A DIRECTORY URL DOES NOT WORK. A
    SCREENSHOT OF A URL DOES NOT WORK. Only full file URLs, as text.

  ▶▶ THE FULL PASTE — ⚠ THIS IS THE DEBUGGING DEFAULT, NOT THE
    UNIVERSAL ONE (rule 10.4). For this session use the SHORT
    LIST in the handover block above. The full set, when needed:

https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_0.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_1.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_2.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_3A.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_3B.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_4.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_5.md
https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/Section_6.md

  ⚠ MATCH THE PASTE SET TO THE SESSION'S SHAPE — do not paste all
    eight by reflex. A PROMOTE needs 0 · 1 · 3B · 5 and nothing
    else: no domain logic, no module map, no design spec, no
    history. That saves roughly half the context for the work.
    A BUILD session needs 2 and 3A. A DOCS session needs 0 and the
    file being edited. ▶ Claude should say which it needs and why,
    at open, rather than being handed everything.

  ⚠⚠ THE CACHE TRAP IS REAL AND IT WAS PROVEN IN S86, TWICE OVER.
    The raw CDN served the S85-CLOSE version of Section_1.md at
    22:40 — nearly two hours after the S86 doc commits landed and
    were pushed. Claude twice reasoned its way to a tidy
    explanation ("it just hadn't been committed yet") and was
    twice wrong. THE FETCH SETTLED IT, NOT THE REASONING. (0.1a.)
    ▶ IF A FETCHED SECTION LOOKS OLDER THAN THE WORK YOU KNOW WAS
      DONE, IT IS STALE. PASTE IT. Do not let Claude explain it away.
    ▶ THE TELL: Claude describing the PREVIOUS session's plan as
      though it were today's. That is what happened at S86 open and
      it cost the first third of the session.

  ⚠⚠ THE TRAP THAT COSTS MOST, AND NO HANDOVER FIXES IT.
    S86 SPENT FOUR HOURS ON FOUR WRONG THEORIES ABOUT THE CANCEL
    DEFECT BEFORE RUNNING A TEN-MINUTE TEST THAT SETTLED IT.
    ▶ IF THE BEHAVIOUR IS REPRODUCIBLE ON A SANDBOX, REPRODUCE IT
      FIRST AND READ THE CODE SECOND. → J109.
    ⚠ IT RE-EARNED ITSELF THE SAME NIGHT: Claude explained the
      stale CDN away TWICE with tidy reasoning instead of fetching
      to check. Both explanations were wrong. The pattern is not
      "Claude lacks information" — it is CLAUDE PREFERRING AN
      EXPLANATION TO A TEST. Minty: when an explanation arrives
      faster than a check, ask for the check.

  ⚠ RULE 1.2 NEEDS AN ORDERING, NOT A NEW RULE: check DEV's HEAD
    before trusting anything in Section 1. Claude checked PROD
    first at S86 open, found it matched the record, and read that
    as the whole record being current. DEV IS WHERE THE WORK LANDS
    — it is the half that goes stale.

  ⚠ THE GITHUB WEB PAGE READS AS README-ONLY when Claude fetches
    it — a rendering artifact, NOT a missing repo. Do not re-raise.

⚠ CARRY FORWARD — settled, do not re-open:
  • "Fix A" does not exist and never did (J81).
  • The allergen snapshot does not exist (J80 + J82).
  • Release does not explode intermediates (J80). Trace does.
  • J80's DISPLAY finding is withdrawn; STOCK-HOP findings stand (J83).
  • Fractional shipping units are PERMITTED BY DESIGN (Minty, S80).
    ⚠ AND ONE HAS NOW REACHED A PACKING SLIP: DO-0009 carries 0.5
      units on PS-0012 and stored correctly. J88's rounding hazard
      is CLOSED BY CONSTRUCTION — slice 3 removed the Math.round
      when it switched to stored packing_units. (S86.)
  • THE PACKING SLIP FLOW (Minty, S82): move DOs → SAVE → shipping
    reference + vehicle condition → SHIP (terminal). → J97.
  • SHIPPED QUANTITY IS NOT AN OPERATOR INPUT (Minty, S84).
  • THE DO ROW IS A READ-ONLY DISPLAY OF THE DISPATCH ORDER.
    Nothing on it is typed. To change what is on the slip, remove
    the DO and add a different one. (Minty, S85.) → P41.
  • THE UNIFORM QUANTITY STRING:  <units># (<Kg> <uom>)
    Units read STORED, Kg DERIVED by multiplying. (Minty, S85.)
  • ⚠ NEW, S86 — SHIPPED BY AND AUTHORIZED BY ARE ONE PERSON: the
    authorised warehouse person who sends the shipment. THE CODE
    ALREADY DOES THIS — finalShipmentUserId is written ONLY when
    isShipping is true, so the app records who actually shipped,
    at the moment of shipping. Nothing to build. (Minty, S86.)
  • ⚠ NEW, S86 — VEHICLE CONDITION NOT BEING SAVED IS ACCEPTED.
    Minty: "not important, we can live with this." → P44 closed
    as WON'T FIX. Do not re-raise it as a defect.
  • ⚠ NEW, S86 — THE PRINTED SLIP'S TOTALS, PAGE FOOTER AND
    BARCODE ARE NOT REQUIRED AT THIS TIME (Minty, S86). These are
    DECISIONS, NOT A BACKLOG. The slip as it stands IS the
    deliverable. ⚠ The barcode keeps ONE live dependency: when it
    is built, its encoding and P6's scanner must be designed
    TOGETHER or they will not meet.
  • ⚠ NEW, S86 — CANCELLING A SHIPPED SLIP IS BLOCKED IN THE
    FRONT END ONLY, AND THAT IS ACCEPTED (Minty, S86). The backend
    would allow it; the button is hidden. Revisit only if it
    becomes important. → P57. DO NOT RE-RAISE AS A DEFECT.
  • ⚠ NEW, S86 — qty_shipped IS 0 OR A REAL QUANTITY, NEVER
    BLANK (Minty, S86). NULL means unknown and hides rows from the
    reconcile oracle. → P62.
  • ⚠ THE RECONCILE ORACLE. A DO's qty_shipped must ALWAYS equal
    the sum of its packingslipdos rows. Block below. Empty = clean.
    ⚠ IT HAS A BLIND SPOT → P62.
```

---

## HEADS — ⚠ verify against the boxes before working (rule 1.2)

```
⚠⚠ DEV AND PROD ARE IN SYNC. First time since S80.

Backend   DEV  13e3fcd      PROD 13e3fcd
Frontend  DEV  8997acdc     PROD 8997acdc  (served)

⚠ THE PROD FRONTEND SERVED BUNDLE WAS NOT INDEPENDENTLY READ.
  promote.sh ran and Minty verified the app in the browser, but
  no one printed the served SHA. A CLAIM, NOT A READING. → P8.

VERIFIED ON PROD AT S86 CLOSE
  backend 13e3fcd · tree clean · pm2 abletrace-backend online
  · curl 1337 = 200 · fast-forward pull, one file changed
  (api/models/PackingSlips.js, +112 −36)
  BROWSER: the new printed packing slip renders correctly, AND
  the traceability PDF still downloads correctly — the regression
  pair for P52a's GLOBAL styles.scss edit. Both clean.

VERIFIED ON DEV AT S86 CLOSE
  backend 13e3fcd · frontend 8997acdc · tree clean · pm2
  abletrace-dev online · curl 200 · company 464 fully reconciled.

⚠ THE REGRESSION PAIR FOR THIS AREA IS NO LONGER J78's.
  J78's apostrophe + pasted-image test belongs to Documents.js,
  and d3104ea (the fix) has been on prod since S85. THE PAIR THAT
  MATTERS NOW IS: any print-CSS change → RE-TEST THE TRACEABILITY
  PDF. styles.scss is global; the packing slip is not the only
  thing that prints.

S86 COMMITS — read from git, not memory
  BACKEND
    44759a9   P53 cancel returns qty from stored PackingSlipDOs
              rows, sequential, destroy AFTER return
    13e3fcd   P56 getPSs matches DO objects by id, not array index
  FRONTEND
    6b269ab3  P7 step B: mirror 4b read-only DO row onto create,
              delete equality-lock validators and dead setShipQty
    ba3bfe9f  P52a printed slip as its own document, print CSS,
              real dates, em-dash blanks
    8997acdc  P52a typography, fixed column widths, spacing
  DOCS
    70afcae   Section 5 de-dup, header corrected, J111 + J112

ROLLBACK POINTS
  PROD backend        git reset --hard d3104ea + pm2 restart
                      abletrace-backend
  PROD frontend       /home/ubuntu/www-html.bak-prod-53db203d4ef4
  DEV frontend build  /home/ubuntu/www-html.bak-dev-8997acdcf4ab
  DEV frontend        /home/ubuntu/www-html.bak-dev-ba3bfe9f53a1
  DEV frontend        /home/ubuntu/www-html.bak-dev-6b269ab3ddf8
  DEV styles.scss     /home/ubuntu/styles.scss.bak-S86-P52a-visual-20260725-231007
  DEV backend         /home/ubuntu/PackingSlips.js.bak-S86-P56-20260725-224535
  DEV backend         /home/ubuntu/PackingSlips.js.bak-S82 · .bak-S81
```

## ⚠ CI — PUSH AUTO-BUILDS DEV. PROD IS A MANUAL DISPATCH.

```
  PUSH to main  → automatically builds DEV. No manual trigger.
  PROD          → deliberate manual dispatch, and ⚠ THE BUTTON IS
                  NOT WHERE IT LOOKS. It does NOT appear on the
                  "All workflows" page. Click "Build Frontend" in
                  the LEFT SIDEBAR first; the heading must change
                  to "Build Frontend". Then "Run workflow" appears
                  on the right, with a TARGET dropdown
                  (prod / dev, defaults to prod). S86 lost ~15
                  minutes hunting for it on the wrong page.
Build time observed: dev ~8-9 min, prod ~3m45s.
⚠ CI warns "Node.js 20 is deprecated" on every build. Housekeeping,
  not our code. Raise it only if a build fails.
⚠ THE ARTIFACT NAME CARRIES THE TARGET AND THE FULL SHA —
    dist-<target>-<full-sha>.zip
  Use the SHA to pick the right zip, never the timestamp. → P12.
⚠ SIZE IS A SANITY CHECK: a prod bundle is ~9 MB, a dev bundle of
  the SAME commit is ~14 MB (prod builds with optimisation). If
  the size looks wrong, the target was wrong.
```

## THE FRONTEND DEPLOY LOOP — exact commands (S86-verified, both targets)

```
1  [DEV]  edit + commit + push          (auto-builds DEV)
2  WEB    github.com/Mintygadhok/abletrace-lab-frontend/actions
          DEV  = the automatic run.  PROD = sidebar → Build
          Frontend → Run workflow → target prod.
3  WEB    open the run, download the artifact
          ⚠ IT DOES NOT ALWAYS DOWNLOAD ON THE FIRST CLICK.
            Check: ls -lt ~/Downloads | head -5
4  [MAC]  ⚠ MATCH BY SHA, NOT BY NAME TYPED FROM A SCREEN.
            ZIP=$(ls -t ~/Downloads/dist-<target>-<sha8>*.zip | head -1)
            echo "MATCH: ${ZIP:-none}"
            [ -n "$ZIP" ] && ~/promote.sh "$ZIP" <target>
5  BROWSER  Cmd+Q ENTIRELY. Not a hard reload. Lazy popup chunks
          survive everything else (J66).

BACKEND DEPLOY — no build, no artifact:
  [BOX]  cd /home/ubuntu/abletrace-lab-backend
         git log -1 --format='%h %s'      # ROLLBACK POINT FIRST
         git pull
         pm2 restart <abletrace-dev | abletrace-backend>
         sleep 8
         curl -s -o /dev/null -w '%{http_code}\n' http://localhost:1337
  ⚠ NEVER pm2 restart all.  ⚠ 000 = still booting, re-run the curl.

⚠ promote.sh lives on the MAC, not on a box.
⚠ ssh/scp always from the MAC:
    ssh -4 -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
    (the -4 is the S73 IPv6 workaround → P23)
```

## ⚠ HANDING PATCH SCRIPTS TO MINTY

```
⚠ PASTING LONG PATCH SCRIPTS INTO THE TERMINAL FAILS. → P46.

FOR A BOX (dev/prod):
    1  Claude writes the patch and hands it over as a FILE (0.2b)
    2  [MAC]  scp -i ~/.ssh/abletrace-lab-key.pem ~/Downloads/<patch>.py ubuntu@16.55.10.205:/tmp/
    3  [DEV]  python3 /tmp/<patch>.py
    4  [DEV]  git --no-pager diff

FOR THE DOCS REPO (it is cloned on the MAC — rule 0.2c):
    1  [MAC]  cd ~/abletrace-lab-docs && git pull
    2  [MAC]  cp ~/Downloads/<patch>.py /tmp/patch.py
               python3 /tmp/patch.py
    3  [MAC]  git diff --stat  then  git diff
    4  [MAC]  git add <named files> && git commit && git push
  ⚠ WORKED TWICE IN S86.

⚠ MINTY MUST DOWNLOAD THE FILE BEFORE THE cp/scp.
⚠ THE BOX LABEL GOES ABOVE THE BLOCK, NEVER INSIDE IT.
⚠ SHORT COMMANDS PASTE FINE. Only long multi-line scripts fail.
⚠ A URL GOES IN THE BROWSER, NEVER INSIDE A COMMAND BLOCK.
  Claude formatting a github URL as a pasteable line sent it into
  the terminal in S86. Give web steps as prose, not as code.
⚠ CHECK THE PROMPT COLOUR BEFORE PASTING (rule 6.2). `ssh` typed
  while ALREADY ON DEV fails — the pem does not exist on the boxes.
⚠ A STUCK "subsh quote>" OR A LINGERING ":" PAGER — Control-C,
  then q. If the prompt still misbehaves, OPEN A FRESH TERMINAL
  WINDOW. It is the only reliable clear. (Section 0 rule 8.)
```

## ⚠ THE STANDING QUERY — build a temp cnf from .env (J43)

```
A bare `mysql` on dev hits a nonexistent local socket. The block
below is ONE PASTE and self-cleans.

⚠ THE RECONCILE ORACLE — run after EVERY quantity change.
  Empty = clean. ⚠ ADD `WHERE d.company_id=464` on dev to scope it;
  on PROD run it UNSCOPED to catch the real client.
  ⚠ THE COALESCE ON d.qty_shipped IS THE S86 FIX → P62. Without
    it a NULL tally is invisible: NULL <> 0 evaluates to NULL, so
    the row is silently dropped and reads as clean.

python3 - <<'EOF'
import re
src = open('/home/ubuntu/abletrace-lab-backend/.env').read()
m = re.search(r'DATABASE_URL=mysql://([^:]+):([^@]+)@([^:/]+)', src)
open('/tmp/q.cnf','w').write("[client]\nuser=%s\npassword=%s\nhost=%s\n" % (m.group(1), m.group(2), m.group(3)))
EOF
chmod 600 /tmp/q.cnf
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "SELECT d.id, d.internalCode, d.company_id, d.qty_shipped AS tally, COALESCE(SUM(p.shipped_qty),0) AS rows_total, COUNT(p.id) AS row_count FROM dispatchorders d LEFT JOIN packingslipdos p ON p.DO_id=d.id GROUP BY d.id, d.internalCode, d.company_id, d.qty_shipped HAVING COALESCE(d.qty_shipped,0) <> COALESCE(SUM(p.shipped_qty),0);"
rm -f /tmp/q.cnf

GENERAL QUERY — same recipe, swap the SQL after the cnf block:
mysql --defaults-file=/tmp/q.cnf abletracelab_live -e "<QUERY>"

⚠ THE JOIN TABLE IS packingslipdos — ALL LOWERCASE. Dev MySQL is
  case-sensitive. "PackingSlipDOs" DOES NOT EXIST. → P48.
⚠ NAME THE DB EXPLICITLY. A bare `mysql` on prod lands in the
  dormant ARCHIVE.
```

## ⚠ IDENTIFIERS — TWO SYSTEMS, AND MIXING THEM COSTS TIME

```
⚠ THE SCREEN SHOWS internalCode.  THE ORACLE RETURNS id.
⚠ NEVER NAME A SLIP OR DO BY DB id IN THIS SECTION. Always the
  internalCode Minty can see. If an id is needed, give both. → JT25.
```

## DEV FIXTURE STATE — ⚠ AS AT S86 CLOSE. RE-QUERY BEFORE TRUSTING.

```
⚠ THIS BLOCK AGES FASTER THAN A SESSION. TREAT IT AS A HINT, NOT
  A FACT — run the oracle and a slip listing before testing.

⚠⚠ COMPANY 464 IS FULLY RECONCILED. Every DO's tally equals the
  sum of its join rows. First time since S83. The S85 "drifted
  four" (DO-0004, 0005, 0010, 0011) are all clean.

SLIPS at S86 close (company 464)
    PS-0025   LIVE — was DO-0010 + DO-0011, CANCELLED in the S86
              proof run. Re-query before reusing.
    PS-0012   LIVE — DO-0009 at 0.5 units ⚠ THE ONLY FRACTIONAL
              DO ON A SLIP. Valuable fixture: it satisfies JT21
              and it is the live proof that J88's rounding hazard
              is gone. ⚠ DO NOT DELETE IT.
    PS-0001 · PS-0002 · PS-0003 · PS-0004   SHIPPED (read-only)

⚠ DO-0006's "unexplained" S85 behaviour is EXPLAINED: it
  reconciles and always did. It was never queried directly. Closed.

STANDING FIXTURE DEFECTS (unrelated to P7)
    1. Ginger Powder MAT-5 carries Eggs        (S78, not reverted)
    2. MAT-6 missing its Sesame allergen       (S73 → P24)
    3. FO-0005 forked to two versions + srf rows 1042/1043  (S77)

⚠ STILL OPEN, LOW PRIORITY: who cancelled PS-0008 and PS-0015.
  packingslips.updatedAt dates it. One query.
```

---

## PENDING WORK — everything outstanding

> ⚠ ONE FLAT LIST. NEW ITEMS APPEND AT THE BOTTOM with the next free number (rule 7.3). Minty re-ranks at open; Claude never renumbers.
> ⚠⚠ THE FULL RE-RANK IS OVERDUE — no full pass since S73, now FOURTEEN sessions. ▶ Minty's, one pass, at S87 open. P7's closure frees the top of the list for the first time in six sessions.

**P61  ⚠⚠ NEW S86 — FIVE TRAPS ARE IN THE WRONG HALF OF SECTION 5, AND RULE 1.4 HAS BEEN READING AN INCOMPLETE SET FOR FIVE SESSIONS.**
```
JT1 - JT22   in the TRAPS block, where they belong
JT23  ~2418  ⚠ inside the ENTRIES half
JT24  ~2861  ⚠ inside the ENTRIES half
JT25  ~2891  ⚠ inside the ENTRIES half
JT26  ~2912  ⚠ inside the ENTRIES half
JT27  ~3082  ⚠ inside the ENTRIES half
```
S82-S86 appended new traps at the BOTTOM OF THE FILE, inside the session-append blocks, instead of into the TRAPS block at the top. ⚠ Rule 1.4 says "read the traps block every session" — and five of twenty-seven are not in it. JT25 (never name a record by DB id) cost time in S85 and was sitting where no one reading the traps block would find it.
⚠ FOUND BY THE P42 SPLIT, WHICH ABORTED RATHER THAN SHIP A 5A MISSING FIVE TRAPS. The split did not cause this; it exposed it. ▶ Move all five into the TRAPS block, whole (rule 7.1), THEN split.
⚠ THE UNDERLYING CAUSE IS PROCESS, NOT TEXT: an append-at-the-bottom habit applied to a file with a structured top. Worth a line in rule 10.

**P42  SPLIT SECTION 5 INTO TRAPS AND LOG. ⚠ IN PROGRESS. BLOCKED BY P61.**
✅ DONE S86: duplicate append block removed, header corrected, J111 + J112 written (70afcae).
▶ REMAINING: (1) P61 first. (2) Run the split — 5A = JT + JR, 5B = J-entries with a generated index. (3) `git rm Section_5.md`. (4) Update rule 0.3, rule 9 and 9C to name both files, and the standing paste above.
```
WHY IT MATTERS, MEASURED S86: Section_5.md is 190 KB. A fetch
DIED AT J88 and fifteen entries were invisible for a whole
session. The JT traps block that rule 1.4 requires EVERY session
is trapped inside the half that truncates.
5A ≈ 21 KB (always fetchable) · 5B ≈ 179 KB (on demand, by number)
```
⚠ THE SPLIT SCRIPT WORKS AND ITS ANCHORS ARE PROVEN — body bytes in == out, 104 entries indexed, both prose decoys correctly refused. Two known fixes needed: carry JT23-JT27 into 5A (P61), and widen the index pattern so **J85 is not rejected** for having a title that opens with a quote mark.
⚠⚠ J-NUMBERS AND JT-NUMBERS ARE PERMANENT. Nothing renumbers.

**P2  UNITS FIXES — ACT ON THE S73 WALK.** ⚠ A CAMPAIGN, NOT A FIX.
⚠ GATE RESOLVED S79 — J13 WAS RIGHT, J80 WAS WRONG ON DISPLAY (J83).
  • Trace_ProductHeaderView is Kg-anchored THROUGHOUT.
  • Products list (admin-formulation.component.ts:878) divides separately.
  • ⚠ SCALE: ~30+ division sites, many disguised as `(qty / batch) * (batch / wgt)`.
  • ⚠ THE CORRECT PATTERN: PopUps/stock-info.component.ts:188 reads inventory_units and MULTIPLIES. Copy it.
⚠ **THE PACKING-SLIP SITES ARE NOW ALL CLOSED.** S82 closed five (897096b4) plus edit's write (db415d74). S85 closed the last two in edit-packslips. S86's step B deleted create's parsing entirely. → J104, J106, J110.
⚠ **S81 ADDED A SITE TO FIND:** `soproducts.quanity_shipped_to_date` accumulates UNITS into a row whose sibling `quantity` column is Kg. → J91.
▶ NEXT ACTION IS AN INVENTORY, NOT A FIX. List every division site with file, line, and the stored units column that should replace it. THEN rank.
[3A.5 · §2 GR5 · J13 · J83 · J88 · J91 · J94 · J95 · J104]

**P3  CONFIRM THE PRE-8.4 FINAL SNAPSHOT EXISTS (minutes).** [3B.3]

**P4  FILE-SIZE GATE + ALERT SWEEP.** ~448 alerts across ~110 files; 5 done. ⚠ Packing-slip alerts surface only the HTTP status; the real message is in pm2 logs. [J79, J29·JT18]

**P5  PS GUARD BROWSER-CHECK (minutes).** [J75]

**P6  PO RECEIVING REDESIGN (major, own session).** Scan-to-find, auto-open, global select, ordered-qty default.
✅ PRECONDITION MET S81 — MO-Release Global Select read. Findings:
```
FILE   src/app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/
       release-mat/release-mat-details/
BACK   MaterialsProductsReleased.js:150 createReleaseMaterialProductsV2
CONTROL  html:35-40 one "Select All" → setAllSelect()
HANDLER  ts:176-192 three blocks setting x.isDirectQty
FIELD    the selection flag is `isDirectQty`, NOT `selected`
⚠ IT IS A SELECT-ALL, NOT A SELECT-MATCHING. No predicate.
⚠ DEAD CODE IN THIS FILE → P38.
```
⚠ **P6 AND P52's BARCODE ARE TWO ENDS OF ONE LOOP.** The barcode Minty's client prints is scanned by the CUSTOMER's PO receiving screen. The encoding must match what P6's scanner searches on. ▶ Design them together or they will not meet.
[3A.3 · J89]

**P8  PROD FRONTEND CHECKOUT LAGS THE SERVED BUILD (minutes).** ⚠ AND S86 ADDED THE OTHER HALF: nobody has ever independently READ the served bundle SHA. ▶ Find the command that prints it, and put it in 3B.5's health check — otherwise every promote ends on a claim. [3B.4]

**P9  FEATURE A — FOOD SAFETY TOGGLE: declare the model attribute.** ⚠ SAME SHAPE AS P54's logo column — a DB column written via `.update().set()` is silently dropped unless declared in the Waterline model. [J47·JT2]

**P10  MASTER-RECORD FIELD UNLOCKS.** ⚠ S82 FOUND THE MECHANISM: FormData stringifies blanks so the four-letter string 'null' reaches the backend. → J98. ⚠ P52a now prints "—" instead, so the SYMPTOM is gone from the customer's document — but the stored data is still the string 'null'. [§2 Master edit map]

**P11  RECEIVE PRODUCT CAN BE SAVED WITH NO MATERIAL RELEASED.** [J24]

**P12  SWEEP MAC ~/Downloads (minutes).** ⚠ WORSE AGAIN S86. ⚠ MITIGATION: the artifact filename carries target + SHA — match on those, never timestamp. [3B.4]

**P13  FINISH GLUTENULL ONBOARDING.** ⚠⚠ THIS IS NOW THE CLOCK FOR EVERY OUTBOUND DEFECT — see the resume block. Until it completes, prod carries no real traceability data and mistakes cost nothing. After it, they cost a client. [§2 Logic C]

**P14  REVIEW THE S53 FOOD-SAFETY DOWNLOAD BLOCKS.** [J36, J37]

**P15  PARAMETERIZE WhC_GetMoProductReceivingDetails_SP.** [J78]

**P16  BACK UP /home/ubuntu OFF THE BOX.** ⚠ THE STANDING RISK — and it now holds the ONLY copies of the S86 backups, including styles.scss. [JR14 · JT20 · 3B.9]

**P17  DEACTIVATE THE TWO OLD-ACCOUNT IAM KEYS.** [J1, J34 · 3B.10]

**P18  HACCP EDIT-CASCADE REWORK.** ⚠ FOOD-SAFETY-CRITICAL. OWN SESSION. [J4 · JT3 · 3A.7]

**P19  TRACEABILITY PDF CUTS A ROW ACROSS A PAGE BREAK (cosmetic).** [J25]

**P20  DELETE THE OLD SECTION J (housekeeping).**

**P21  THE OS RESTART — PENDING SINCE S35.** ⚠ Both boxes still show "System restart required", confirmed again S86 on every login. Prod 26.04 / dev 24.04.4 — a dev reboot rehearses nothing. ▶ (1) confirm `systemctl is-enabled pm2-ubuntu` on PROD; (2) reboot prod standalone with rollback ready; (3) reboot dev separately. [3B.2 · 3B.5 · J84]

**P22  DELETE THE OLD SECTION A (housekeeping).**

**P23  ADD AN IPv6 RULE TO DEV SSH (minutes).** ⚠ `ssh -4` needed again throughout S86. [3B.2]

**P24  RESTORE MAT-6 SESAME ALLERGEN ON DEV (minutes).**

**P27  DO-CREATE POPUP: Qty(Kg) SHOWS "NaN" WHILE TYPING.** [3A.5 row 8 · 3A.4]

**P29  ALLERGEN RECORD IS MUTABLE ON SHIPPED LOTS — DOMAIN DECISION FIRST.** ⚠ FOOD-SAFETY. ▶ Does a shipped lot need an immutable as-declared record? ⚠ ALSO OPEN: does mlomanagement.allergens hold a stored value nobody reads? ⚠ TIES TO P52 — whether allergens print on the customer's slip is the same domain question. [J82 · J80]

**P30  ADD-FORMULATION INTERMEDIATE SUMMARY SHOWS Kg-ONLY DURING ADD (minutes).** [J17]

**P31  PROD SSL CERTIFICATE HAS NO EMAIL REGISTERED (minutes).** ⚠ PROD GETS NO RENEWAL-FAILURE WARNING. FIX: `sudo certbot update_account -m info@abletrace.ca --agree-tos`. [3B.6]

**P32  RDS DATABASES ARE PUBLICLY ACCESSIBLE — REVIEW.** [3B.3]

**P33  CERT-STATUS INDICATOR SHOWS RED REGARDLESS OF STATE.** [§4 status colours]

**P34  PROD INSTALLS ITS OWN UPDATES, UNATTENDED AND UNDOCUMENTED.** ⚠ Dev showed 12 pending at S86. Do NOT disable casually. [3B.2 · J84]

**P36  DELETE THE DEAD add-dispatch (v1) POPUP COMPONENT.** ⚠ CONFIRMED S84: both create and edit open DoListComponent. ⚠ Grep for other references first. [J87]

**P38  DELETE THE DEAD selectOption LOT-PICKER IN release-mat-details.** ⚠ Same JT9/JT22 decoy as P36 and P51, in the exact file P6 will redesign. [J89]

**P39  CHECK THE THREE nestedPop POPULATE ARRAYS IN Formulations.js.** ⚠ FOOD-SAFETY-CRITICAL: JT8. Sites: lines 609, 632, 1063. [§2 to-verify 1 · JT8 · J85]

**P40  REMOVE-ONE-DO FROM A PACKING SLIP.** ⚠ STILL UNTESTED. ⚠ The S86 cancel fix rewrote the deletedDos branch alongside inActivatePS — the previous version passed three parallel arrays as criteria, which Waterline reads as IN clauses that CROSS-MULTIPLY rather than pairing. ▶ Exercise it: remove ONE DO from a slip and run the oracle. [J92 · J96 · J105 · J109]

**P41  WRITE THE SETTLED RULES INTO SECTION 2 — ⚠ NOW SEVEN EDITS, ONE PASS.**
  1. A DO coming off a slip ALWAYS returns its quantity (Minty S81). ⚠ THE CODE NOW IMPLEMENTS IT (S86, 44759a9) — record the rule AND that it is honoured.
  2. The three-step flow (move → save → ship) is settled domain logic (S82).
  3. Shipped quantity is not an operator input (S84).
  4. THE DO ROW IS A READ-ONLY DISPLAY. Nothing typed.
  5. THE UNIFORM QUANTITY STRING: `<units># (<Kg> <uom>)`.
  6. ⚠ NEW S86 — SHIPPED BY AND AUTHORIZED BY ARE ONE PERSON: the authorised warehouse person, recorded automatically at the moment of shipping.
  7. ⚠ NEW S86 — VEHICLE CONDITION IS AN OPERATOR PROMPT, NOT A KEPT RECORD (Minty's ruling, S86).
[J92 · J97 · J104 · J109]

**P43  SHIPPING REFERENCE → MULTIPLE INVOICES, QUICKBOOKS-READY.** ⚠ DESIGN DECIDED, BUILD DEFERRED: a CHILD TABLE, not delimited text. ⚠ OPEN: are invoices raised in QuickBooks BEFORE or AFTER the slip ships? If after, the field must be fillable post-ship — which breaks "Ship is terminal". ⚠ DB CHANGE → rule 4.8. [§2 GR7 vehicle_no · 3A.4 · J97]

**P46  TERMINAL PASTE TRUNCATION — INVESTIGATE, DO NOT KEEP GUESSING.** ⚠ TWO THEORIES DISPROVEN. ⚠ THE WORKAROUND WORKS AND IS THE DEFAULT: files + cp/scp. [Section 0 rule 8]

**P48  NAMING DEFECTS. Cheap individually, expensive in aggregate.**
```
moStartDate               holds a LOT CODE, not a date
sales_order_num           holds the SYSTEM SO   ("System SO No")
sales_order_num_system    holds the CUSTOMER's ref ("Customer PO No")
                          ⚠ the "_system" one is the CUSTOMER's.
shipment_order_units  vs  shipping_order_units
shipment_product_order_qty vs shipping_order_qty
"MO Lot Code" vs "Pdt Lot Code"   SAME THING, two captions
"PackingSlipDOs"          the table is packingslipdos, lowercase
vehicle_no                holds the SHIPPING REFERENCE
```
▶ Rename the CAPTIONS freely (safe). ⚠ Renaming CONTROLS touches form bindings, patchValue keys and the payload — its own careful pass.

**P50  UNDOCUMENTED FOLDER ON THE PROD BOX.** `/home/ubuntu/abletrace-lab-backend-dev` exists on PROD and is NOT a git repository. It appears in no section. ⚠ "Probably inert" is reasoning, not a reading. ▶ One `ls` and a config grep.

**P51  DELETE createEditItem / addEditItem (dead code).** PROVEN unreachable S85 by grep. ⚠ Same JT9/JT22 decoy family as P36 and P38. [J106]

**P52  PRINTED PACKING SLIP — ⚠ BUILT AND ON PROD (S86). WHAT REMAINS IS SMALL.**
✅ The structural fix is DONE: the print view is its own template, split from the editing screen (ba3bfe9f + 8997acdc). → J112.
⚠ NOT REQUIRED AT THIS TIME (Minty, S86 — decisions, not backlog): totals · page footer · barcode.
▶ STILL GENUINELY OPEN:
  · THE BARCODE, if it is ever wanted — ⚠ design WITH P6 or the two ends will not meet.
  · group rows by customer PO?
  · print before shipping? (⚠ S86 provisionally made print always visible.)
  · allergens on the slip — ties P29, a domain question.
  · ⚠ Section 11 of the frozen spec ("P52 IS ITS OWN SESSION") IS NOW WRONG — Minty overruled it in S86. Correct it when the spec folds into Section 4.

**P54  COMPANY LOGO: STORE AND SERVE.** No logo column exists on `company`. ▶ Add `company.logo varchar(255)` + ⚠ **the Waterline model attribute — BOTH, or the write is silently dropped (rule 4.7 / JT2, the same trap as P9)**. ⚠ Retrieval must be at RENDER time (signed URL or base64), NOT the click-to-download path used for ref docs. ⚠ Constrain type and size or a 5MB photo lands in every printed slip. ⚠ DB change → rule 4.8, log the SQL. [J108]

**P55  COMPANY LOGO: SUPER ADMIN CAPTURE.** Add the upload to company CREATE and ⚠ **also to company EDIT — companies rebrand.** ⚠ Backfill: existing companies have none. ⚠ Depends on P54. [J108]

**P57  ✅ CLOSED S86 BY DECISION — NO BACKEND GUARD. NOT A DEFECT.** `inActivatePS` gates on `status_id: 1`, but shipping sets `shipped_flag`, NOT `status_id`, so a shipped slip still satisfies the gate. Only the frontend hides the button. ▶ MINTY'S RULING, S86: "keep it closed in the front end. Will revisit only if felt important at a later date." ⚠ DO NOT RE-RAISE THIS AS A BUG. It is a known and accepted gap. ⚠ THE ONE THING THAT WOULD REOPEN IT: if the cancel endpoint ever becomes reachable other than through that screen — a second caller, an API client, or a script. The ruling assumes the frontend is the only door.

**P58  THE DEV REMOTES DO NOT CARRY THE PAT.** `git push` prompted for a password on every push in S86 — five times. 3B.9 says the token is embedded. ⚠ Minutes. ▶ Reset both remote URLs.

**P59  PROD'S PM2 RESTART COUNTER READS 335 AGAINST DEV'S 33.** Appears in no section. ⚠ "Almost certainly accumulated deploys" is reasoning, not a reading. ⚠ S86 ADDED ONE: the counter went 335 → 336 on the promote, consistent with deploy accumulation, still not a reading of WHY. ▶ One look at `pm2 describe abletrace-backend`.

**P60  ⚠ NEW S86 — THE DO PICKER POPUP TITLE (minutes).** The last remnant of P7. The BUTTON was renamed in S84 and is live; the popup HEADING was never changed.

**P62  ⚠ NEW S86 — qty_shipped MUST NEVER BE NULL. ▶ MINTY'S RULING, S86: "qty shipped should be 0 or shipped qty. should not be blank." DECISION MADE, WORK OUTSTANDING.**
```
THE PROBLEM   NULL means UNKNOWN, not zero. The reconcile oracle's
              HAVING clause compares qty_shipped to the row sum;
              NULL <> 0 evaluates to NULL, not TRUE, so a NULL row
              is DROPPED from the result and reads as CLEAN.
              ⚠ A DO with a NULL tally would be invisible to the
              oracle forever, however wrong it was.
✅ DONE       the oracle in this section now uses
              COALESCE(d.qty_shipped,0) — blanks are caught.
▶ TO DO      1  count NULLs on BOTH boxes before changing anything
                 SELECT COUNT(*) FROM dispatchorders
                 WHERE qty_shipped IS NULL;
              2  heal any that exist to 0
              3  ALTER the column NOT NULL DEFAULT 0
              4  ⚠ CHECK THE WATERLINE MODEL TOO — a schema
                 default does not stop the app writing an explicit
                 null. Same family as JT2 / P9 / P54.
              5  BOTH BOXES. ⚠ DB change → rule 4.8, log the SQL.
⚠ THE SAME QUESTION APPLIES TO soproducts.quanity_shipped_to_date
  and to packingslipdos.shipped_qty — the cancel path decrements
  all three. Check all three while the SQL is open. → J91.
⚠ SAME FAMILY AS J74: safe by accident of the data, not by code.
```

> ⚠ NUMBERING NOTE: the queue jumps P24 → P27; P25/P26 are gone for good. P28 CLOSED S79. P35 CLOSED S84. P37 CLOSED S86. P45 + P49 CLOSED S86 (6b269ab3). P47 folded into P52. P53 CLOSED S86 (44759a9). P56 CLOSED S86 (13e3fcd). P57 CLOSED S86 BY DECISION (no guard — Minty). P1 CLOSED S86 (documentation convergence — only P20/P22 file deletions remain). P7 CLOSED S86 — promoted and verified; only P60 remains. P44 CLOSED S86 as WON'T FIX (Minty's ruling).

---

## BANKED, AWAITING DEPLOYMENT

```
⚠⚠ NOTHING. THE QUEUE IS EMPTY. DEV AND PROD ARE IN SYNC.

S86 promoted all sixteen commits — six backend, ten frontend —
covering P7 slices 1·2·3·4a·4b, step B, the cancel fix, P56, and
the printed packing slip. Backend first, then frontend (J96).
Verified on prod: the new printed slip renders, and the
traceability PDF still downloads (the regression pair for the
global styles.scss edit).

⚠ THE NEXT PROMOTE SET MUST BE READ FROM GIT, NOT FROM THIS
  BLOCK OR FROM MEMORY:
    cd <repo> && git --no-pager log --oneline <prod-sha>..HEAD
  S85 wrote a promote list from memory and got it wrong; S86
  found the record understated the true set by five commits.
  ⚠ USE PROD'S SERVED BUNDLE SHA FOR THE FRONTEND RANGE, NEVER
    ITS CHECKOUT — the checkout lags and gives a wrong range (P8).
```

**END SECTION 1**
