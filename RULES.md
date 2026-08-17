# RULES

Last revised: S125.

TWO PRINCIPLES GOVERN EVERYTHING BELOW. Minty's ruling, S125.
  MEASURE, DON'T STORE.
  REPLACE, DON'T PATCH.
⚠ MEASURE MEANS CHEAPLY. A finding that cost a session and cannot be
  repeated safely stays until the job that needs it is done.
⚠ REPLACE GOVERNS DOCUMENTS, NOT CODE. And it means READ FIRST — a
  document nobody has read is retired or left alone, never rewritten
  blind.

⚠ A NEW RULE IS ADDED ONLY WHEN A REAL FAILURE SHOWS SOMETHING MISSING,
  AND ONLY WITH MINTY'S APPROVAL. The default answer is NO.

```
WHO   Minty: domain expert, sole operator, runs every command.
      Does not read code. Decides on BUSINESS grounds only.
      Claude: IT partner. Codes, reviews, and advises on
      architecture, infrastructure and risk.
      ⚠ CLAUDE GIVES ITS VIEW. MINTY DECIDES. A view withheld is
        a partner not doing the job.
      ⚠ There is no second engineer. If Claude misses it, nobody
        catches it.
      ⚠ IF IT IS NOT WRITTEN DOWN, IT IS LOST.
```

---

## OPEN — paste this block, one box at a time

⚠ Everything below the fence is a COMMAND. Warnings live outside it.

```
git -C ~/abletrace-lab-frontend rev-parse --short HEAD
git -C ~/abletrace-lab-backend rev-parse --short HEAD
git -C ~/abletrace-lab-frontend status --short
git -C ~/abletrace-lab-backend status --short
pm2 status
curl -s -o /dev/null -w "%{http_code}\n" localhost:1337
node -v
```

ON PROD ONLY, add this eighth line. Prod's git checkout LAGS the served
build, so this is the only reliable read of what is actually live:

```
ls -1dt /home/ubuntu/www-html.bak-* | head -1
```

⚠ Expect clean trees, the NAMED process online, and 200.
⚠ THIS CHECK IS THE ARBITER. It measures commits, process, port,
  runtime and dirty trees. NOW does not carry a copy of any of it, so
  there is nothing to reconcile against — what the boxes say is true.
⚠ NOW's STATE says only what no command returns: what is DELIBERATE,
  and what is HALF-DONE. Read it for intent, then treat anything the
  check shows that intent does not explain as a FINDING.
⚠ After any backend restart, sleep 8 before the curl. 000 means Sails is
  still booting, not that it crashed.
⚠ THIS CHECK DOES NOT COMPARE THE DATABASE OR THE HOST OS. A passing
  check is evidence only about what it tests.

---

## 1 · LOOK / ANALYSE

```
1  REPRODUCE FIRST. Make it happen on dev before reading
   anything. It tells you WHAT happens, never WHY — it points
   at which check to run next.

2  THEN THE FOUR ARBITERS
     what it DOES      → the screen
     what was STORED   → the row
     which ROUTE       → the code line
     does it RUN       → grep the caller

⚠ A CHECK MUST BE ABLE TO FAIL. Before running it, say what result
  would distinguish the two answers; if no result could, it is not a
  check. ⚠ And it must not match text the patch itself introduced,
  comments included.
⚠ When a claim can be checked, ask Minty to look before reasoning
  about it.
⚠ A screen proves BEHAVIOUR, never a saved value.
⚠ When ENTERED and STORED disagree, read the save code, not the
  form. A form can send a hidden value instead of the one typed.
⚠ When a measurement and a memory conflict, find a THIRD
  measurement. Do not rebuild the measurement to fit the memory.

BEFORE CHANGING A NUMBER — two greps, both cheap:
  where is this number USED?
  is the same mistake made ELSEWHERE?

BEFORE UNDOING — a revert is a trade, not a fix. Say what the
commit was fixing and name both sides.

AFTER — the commit message IS the record. What changed and WHY,
written as you commit. Never afterwards.

⚠ NOTHING IS DONE UNTIL IT IS VERIFIED ON THE SCREEN. Deployed is
  not proven. Say which it is, every time.

⚠ ASK THE BOX BEFORE ASKING FOR A DOCUMENT. If a command returns
  the answer, run the command.
⚠ IF THE ANSWER IS NOT IN THE APP AND CANNOT BE MEASURED, IT IS IN
  A DOCUMENT. Ask Minty for it BY NAME. The list is in THE FILES.
```

---

## 2 · WHERE

```
Claude writes commands. Minty runs them. Every one.
Claude names the machine in every block.

MAC     Edit. Frontend code, patches, commit, push, promote.sh.
GITHUB  Build. Frontend only. A push builds dev; prod needs a
        manual dispatch.
DEV     Run and prove. Every fix is verified here before it goes
        anywhere.
PROD    The client. Only proven code, only deliberately. Own
        database, own OS — dev does not rehearse everything.

⚠ FRONTEND is edited on the MAC. Dev's copy is overwritten by the
  next deploy.
⚠ BACKEND is edited, committed and pushed on DEV. It has no build
  step — Node runs the source. This asymmetry is DELIBERATE.
⚠ A DATABASE OBJECT reaches neither box by deploying. Run it on
  each box separately, gate each box separately.
⚠ CHECK THE PROMPT COLOUR BEFORE EVERY COMMAND.
  [MAC] cyan · [DEV] green · [PROD] red.
⚠ scp and ssh ALWAYS FROM THE MAC. The pem does not exist on the
  boxes.
⚠ pm2 restart <NAME>, never "all". dev=abletrace-dev,
  prod=abletrace-backend. Then sleep 8, then curl.
⚠ git add <named files>, never ".". No "!" in commit messages.
⚠ After a frontend deploy, Shift+Cmd+R in Chrome. Minty's ruling S106.
⚠ READ THE ROLLBACK PATH OFF THE BOX, never write it from the
  build label. It is the one thing that must be right before it
  is needed.
⚠ A RESTART PROVES NOTHING ABOUT A PULL. Read HEAD after every
  pull, before restarting. S106: prod restarted clean, returned
  200, and was still running the old commit.
```

---

## 3 · HEAL

```
Code fixes the FUTURE. It never reaches rows already saved.

A display fault corrects itself once the code is right. Nothing
to decide.
A wrong value already STORED stays wrong until someone changes it.

▶ CLAUDE QUERIES AND REPORTS: how many rows, whose, and whether
  the true value is recoverable.
▶ MINTY DECIDES whether to heal. It is his data.

⚠ Before any heal: back up the row, scope by id AND company_id,
  and say out loud that it is a live write.
⚠ A FIGURE THAT RECORDS WHAT PHYSICALLY HAPPENED IS NOT A WRONG
  ROW. Minty's ruling S106 on the 0.08 clamshell over-release:
  the release figure is the true record of what was picked, even
  though the instruction that produced it was wrong.
```

---

## 4 · CREDENTIALS

```
Every secret, one line, location only.
⚠ VALUES live in Section H. Minty's alone, never in the repo,
  never in chat.

ON THE BOXES — .env, each box, never in git
  DATABASE_URL      ⚠ dev and prod are DIFFERENT.
                    ⚠ Password must be ALPHANUMERIC ONLY.
  SESSION_SECRET
  S3_ACCESS_KEY     new-account IAM key
  S3_SECRET
  SMTP_USER         ⚠ actually an AWS IAM key ID, not SMTP
  SMTP_PASSWORD     ⚠ actually the IAM secret
  ⚠ dotenv loads at runtime — `pm2 env` does NOT list them.

ON BOTH BOXES
  ~/.my.cnf         DB password, chmod 600.

ON THE MAC
  SSH KEY           ~/.ssh/abletrace-lab-key.pem
                    ⚠ Not on either box. Backup in Drive.

ELSEWHERE
  GITHUB PAT        ⚠⚠ ONE CREDENTIAL, THREE PLACES, SAME STRING.
                      Mac keychain — all Mac pushes
                      dev's BACKEND remote URL
                      Minty's Drive note — the record
                    ⚠ A ROTATION MUST CHANGE ALL THREE.
                    ⚠ Dev's frontend remote is clean.
  AWS CONSOLE       Minty. NEW 208073623096 · OLD 350466202408
  GODADDY           Minty. Both domains registered here.
  ROUTE 53          inside the OLD AWS account.
  ZOHO MAIL         Minty.
  SUPER ADMIN       Minty.

⚠ NEVER let a secret reach the screen or the chat. Generate or
  paste straight into a file.
⚠ ROTATION METHOD is 3B.8. Read it first — a fumble on a live DB
  password locks the app out.
⚠ TWO OLD-ACCOUNT IAM KEYS ARE STILL VALID and in git history,
  deliberately. → P17
⚠ IF THIS LIST IS WRONG, FIX IT IN THE SAME BREATH.
```

---

## 5 · FOR MINTY

```
1  FENCE — every command in its own fenced block. Nothing else
   inside it: no step numbers, no prose, no placeholders.
   ⚠ Copy only from a fence, never from terminal output.
   ⚠ PASTING TERMINAL OUTPUT BACK IN RUNS IT AS COMMANDS. S106:
     it produced a burst of "command not found" AND SILENTLY ATE
     A git pull. The pull never ran and nothing said so.

2  FILE — anything long goes as a downloadable file, never a
   paste. Claude writes the file and presents it.
   ⚠ Copying from the rendered chat copies the OUTPUT, not the
     source.
   ⚠ CLEAR THE DOWNLOADS FIRST. The browser numbers duplicates,
     so the PLAIN filename can be the OLDEST copy. Read the
     stamp and the timestamp before copying anything anywhere.

3  WHAT MINTY DOES NOW — every reply needing action ends with it.
   Plain words, three steps or fewer, nothing after.
   ⚠ Any explanation ends in plain words: what the issue is,
     simply put.
   ⚠ A decision goes there in BOLD, as a BUSINESS question, never
     a technical one.
   ⚠ If nothing is needed, say exactly that.

4  ASK BEFORE ADDING — nothing goes into any document without
   Minty's approval. Claude proposes in plain words: what it
   says, why, and which document holds it.
   ⚠ The default answer is NO.
   ⚠ THE DOCUMENTS BALLOONING IS THE TRAP. It has cost more
     sessions than any bug.

QUEUE — new items at the BOTTOM with the next free number. Claude
never renumbers. ⚠ Ranking is Minty's.
```

---

## 6 · CLOSE

```
⚠ Nothing is closed until it is COMMITTED AND PUSHED.

THE CLOSE PRODUCES THE LAUNCHPAD. Minty's ruling, S125.
  1  ONE JOB, substantial. Named at the SESSION MIDPOINT, not at
     the close — homework then happens as capacity allows.
  2  DO ITS HOMEWORK NOW. Measurements, paths, dependencies,
     prerequisites, rollback. Discovery belongs to this session.
  3  WRITE IT INTO NOW so the next session starts without
     rediscovery and without reopening a previous chat.
       the ACTION    what to do, in order
       the MATERIAL  everything THAT JOB needs, QUOTED IN, in full.
                     ⚠ A POINTER TO ANOTHER DOCUMENT IS A
                       RE-DERIVATION.
                     ⚠ JOB-SCOPED ONLY. Anything not about this job
                       is measured when it is needed.
       the ANALYSIS  the thinking already done
       the VERIFY    what must be seen on screen to call it done
  4  STATE IS INTENT, NOT FACTS. The open check measures commits,
     process, port, runtime and dirty trees. STATE carries only
     what no command returns: what is DELIBERATE, and what is
     HALF-DONE.
  5  DELETE what is finished, temporary or no longer relevant. Do
     not carry it forward and do not file it elsewhere.

THE TEST: can the next session open NOW and start meaningful work?
⚠ Optimise the close for the next session's OPENING OVERHEAD, not
  for a record of the system. NOW is a launchpad, not a database.

⚠ Tidy here and ONLY here — temp files, patch scripts, stale
  downloads. Never at the start of a session.
⚠ CLEAR THE DOWNLOADS AT THE CLOSE. Verify the STAMP after
  copying, before committing.
⚠ COMMIT MESSAGES: TWO OR THREE SENTENCES. What changed and why,
  plus anything a future reader would get wrong without it. The
  detail belongs in the code comment and in NOW, not repeated in
  all three. Minty's ruling S99.
⚠ Do not start work that cannot be recorded.
⚠⚠ REPLACE NOW IN PROJECT KNOWLEDGE AT EVERY CLOSE. NOW goes stale
  the moment it is rewritten, and a stale document that is
  SEARCHABLE is worse than one that is absent. Minty's ruling, S124.
⚠ Claude raises the close; Minty decides.

⚠⚠ CLAUDE SAYS "RESERVE" WHEN ITS GRIP STARTS TO LOOSEN.
  THE SIGNAL IS ONE WORD, IN CAPS, SAID ONCE: RESERVE.
  It fires when Claude notices the early part of the session going
  hazy, or finds itself wanting to re-ask for a number already
  measured. Those are the symptoms and they only appear near the end.

  ⚠ NOT AT EVERY CROSSING. Claude does not raise the close because
    a job finished, because a decision was made, or because a
    natural pause arrived. RESERVE is said when it is GENUINELY THE
    POINT, and it is said plainly rather than as a question.

  ⚠ CLAUDE CANNOT SEE A GAUGE. There is no counter and no
    percentage. The signal is a judgement about symptoms, so it may
    come late.
    ▶ MINTY MAY ASK "WHERE ARE WE" AT ANY POINT and gets an honest
      read — comfortable, or getting thin — without waiting for
      RESERVE.

  ⚠⚠ THE CLOSE IS WORTH MORE THAN THE LAST JOB. A next session
    specified fully beats one more half-finished thing. WHEN RESERVE
    FIRES, STOP TAKING NEW WORK AND SPEND WHAT IS LEFT ON THE CLOSE.
    ▶ MINTY, S117: it is more important to spec out the next session
      fully than to stretch Claude at the fag end.

  ⚠ WHAT MAKES THE RESERVE ARRIVE SOONER: large pastes. A whole
    document, a wide query, a long file dump. Ask for the block,
    not the file.
```

---

## 7 · QUANTITY

```
EVERY UNIT FIGURE ON EVERY SCREEN COMES FROM ONE OF FOUR PLACES.
A UNIT FIGURE FROM NONE OF THEM IS A DEFECT.

1  ING-REQ · THE RECIPE REQUIREMENT
   What an MO needs of an ingredient or an intermediate.
       quantity per batch x (MO shipping units / shipping units per batch)
   Computed LIVE, every time.
   ⚠ NEVER READ mlomanagement.batches. It is this same sum, already
     rounded and stored.
   ⚠ Quantity per batch takes the basis of the thing being consumed —
     UNITS for an intermediate, Kg for an ingredient. The scaling
     factor is always shipping units over shipping units, so it never
     changes the basis.
   LIVES IN  subrecipematerials.qty · subrecipeformulation.ship_qty

2  PK-CASCADE · THE PACKAGING FIGURES
       MO shipping units x the pack ratio at each level
   Level 1 is the single unit and it carries the unit weight. THAT IS
   THE ONE PLACE A UNIT WEIGHT IS HELD ANYWHERE IN THE SYSTEM.
   ⚠ batches plays NO part, so there is NO rounding variance. A
     fractional packaging figure is a defect, not rounding.
   LIVES IN  fopackaging.quantity · pack_level · whd_flag ·
             wgt_kgs_per_unit

3  STOCK ON HAND · THE WAREHOUSE BALANCE
   Two balances, kept separately.
     PRODUCTS AND INTERMEDIATES  formulations.inventory_units, units
       UP    MO completed and received · returned from an MO ·
             a dispatch order cancelled
       DOWN  allocated to a DO · miscellaneous release ·
             released into another product's recipe
     MATERIALS  materials.inventory, Kg
       UP    received from the vendor · returned from an MO
       DOWN  released to an MO · miscellaneous release
   ⚠ STOCK MOVES ONLY AT THE DO, IN BOTH DIRECTIONS.
     stock on hand -> DO                 MOVES
     DO -> packing slip -> shipped       no move
     packing slip -> DO                  no move
     DO cancelled -> stock on hand       MOVES
     Once allocated it is spoken for and a planner must not count it
     as available, even though it is still in the building.

4  PRD-TO-DATE · PRODUCTION TO DATE
   The completed quantity for an MO. mlomanagement.received_units.
   Manufacturing may deliver several times against one MO. Each
   delivery is a received lot, entered IN SHIPPING UNITS with the
   weight derived. NEVER THE REVERSE.
   The completed quantity is the sum of those lots, in shipping units.
   Received lots are internal to the MO. ONE MO, ONE PRODUCT LOT.
   Only ever goes up.
   ⚠ mlomanagement.received_units IS THE MO TOTAL.
     receiveproducts.qty IS ONE RECEIPT. NOT INTERCHANGEABLE — a
     per-receipt row must show its own count.

THE TEST
  Point at any unit number on any screen and say which of the four it
  came from. If the answer is "we divided a weight", THAT IS THE BUG.

WEIGHT IS ALWAYS WORKED OUT FROM UNITS.
UNITS ARE NEVER WORKED OUT FROM WEIGHT.

DISPLAY  three decimal places.
  ⚠ ROUND FOR DISPLAY ONLY. Full precision in the calculation and in
    the database. A rounded figure that is then multiplied carries its
    error forward — which is exactly what the stored batches column
    does.

⚠ THE DIVISION RETURNS A PLAUSIBLE NUMBER EVERY TIME and is invisible
  at a round ratio (TRAPS 9). It does not announce itself.
⚠ A STORED COUNT THAT IS NOT SERVED IS THE USUAL CAUSE. Before
  repairing arithmetic, ask whether the real number is simply not in
  the SELECT list.

⚠ THE FULL MAP — every site that produces a unit figure, aligned and
  misaligned, with its address — IS THE UNITS BIBLE.
  ▶ UNITS-BIBLE.txt in the docs repo. Minty's document.
  ⚠ FROZEN AS AN ARCHIVE AT S117. It describes the app as of the
    campaign's close. Consulted PER ROW, never read at the open.

⚠ MINTY'S RULINGS, S108. THIS SUPERSEDES THE S105 RULING THAT THE
  INGREDIENT ROUNDING VARIANCE IS ACCEPTED.
```

---

## THE FILES

```
⚠⚠ A SESSION OPENS ON TWO. Minty's ruling, S117.

  RULES.md   how we work. Rarely edited.
  NOW.md     the launchpad. Intent, the next job, and the queue.
             Rewritten whole each session — see RULE 6.

⚠⚠ THE GIT REPO IS THE ARBITER. Project knowledge is a MIRROR of it
  and can go stale. When the two disagree, the repo wins. Minty's
  ruling, S124.

ON DEMAND, when the work reaches them:
  TRAPS.md        what fails SILENTLY. Eleven entries. Cut deliberately.
  Bible Part 1    the quantity rules. Minty's.
  3A              the app, module by module.
  3B              boxes, databases, pipeline, DNS, printer.
  Section 5 / JR  the database record. ⚠ Section_5.md IS in git;
                  measured S123. The rest of the record is not.

⚠ NO DEDICATED TIDY-UP SESSION. A document is cleaned by whichever
  session next opens it. Minty's ruling, S117.
⚠ Anything worth keeping must NOT live in NOW. It is rewritten whole.
⚠ DOC EDITS ARE REPLACEMENTS. Pull first, replace the file whole,
  diff, commit, push.
```
