# NOW — S120 close, 15 Aug 2026

**State, next job, queue. Nothing else.**

⚠⚠ **A SESSION OPENS ON TWO FILES: RULES AND THIS ONE.** *(Minty, S117)*
Everything else is consulted ON DEMAND, when the work touches it:
**BUSINESS LOGIC** (Bible Part 1) · **3B** infrastructure · **3A** the app ·
**Section 5 / JR** the database record · **TRAPS** (10, an 11th drafted below).
▶ NO DEDICATED TIDY-UP SESSION. A document is cleaned when it is next
opened, by the session that opens it. *(Minty, S117)*

**What does not go here:** lessons, narrative, retrospectives, proof
write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment
beside the code. If it fits none of those it goes nowhere.

---

## STATE

```
DEV   16.55.10.205 (private 172.31.1.196)  Ubuntu 24.04.4 LTS
      ⭑ Node v24.19.0 at /usr/bin/node · npm 11.17.0 · pm2 7.0.3
        apt package `nodejs 24.19.0-1nodesource1`
        repo deb.nodesource.com/node_24.x nodistro main
      backend 99852bf  pm2 abletrace-dev  online  ↺0  200  REBOOTED 13:09 UTC
      frontend serving 4910b46d · checkout c2a52d8e (stale, harmless)
PROD  15.157.38.101  Ubuntu 26.04 LTS
      ⚠⚠ NOT READ THIS SESSION OR THE LAST TWO. Values below are S118's.
      ⚠⚠ **PROD IS STILL ON NODE 18.** The boxes now DIFFER. → P210
      backend 99852bf  pm2 abletrace-backend
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   ⚠ NOT READ THIS SESSION. Carried: frontend repo clean at 4910b46d.
      S121 opens on the Mac and measures it.
```

⚠⚠ **DEV'S BACKEND TREE IS NO LONGER CLEAN AND THAT IS DELIBERATE.**
The OPEN check will show `?? node_modules.old-node18/`. It is the 303 MB
Node-18 package tree, kept as the rollback. **DO NOT STOP AND
INVESTIGATE IT. DO NOT COMMIT IT. DO NOT DELETE IT YET.**
▶ Delete at the close of S122 if dev has been stable — Minty's call.

⚠ **KERNEL AFTER THE REBOOT WAS NOT MEASURED.** Was 7.0.0-1010-aws before.
A reboot can activate a pending kernel. Unmeasured, not assumed. → 3B

**No code changed this session. No commits. Nothing to promote.**
The only artefacts are documents.

⚠ **DEV DATA CHANGED — a real 50 Kg release was made as the write test.**
Any session comparing against S119's figures will see a difference and
it is not a fault:
```
Ginger Powder, lot Mat-260804-3        S119 close    NOW
  SOH                                  7769.322 Kg   7719.322 Kg
  Qty Released                         2220.678 Kg   2270.678 Kg
  Qty Received / Misc Release          10000 / 10.000  unchanged
MO-0014 material release rows          4             5 (916.471, 10, 100, 200, 50)
MO-0014 planned & completed            41# (915.53 Kg) — UNCHANGED, still the fixture
```

---

## PENDING PROMOTION

Nothing in code. **But the boxes are no longer level on the engine:**
dev Node 24, prod Node 18. Deliberate, and it is P210.

---

## P202b — WHAT WAS DONE. Measured S120, do not re-derive.

```
VERDICT: DEV RUNS NODE 24.19.0. PROVEN ON SCREEN, INCLUDING A WRITE,
         AND PROVEN AGAIN THROUGH A REBOOT.

THE ROUTE THAT WAS TAKEN, in order, all on dev:
  1 read the engine and the rollback string
  2 copied the repo line to /home/ubuntu/nodesource.list.bak-S120
  3 pm2 stop abletrace-dev
  4 sed node_18.x → node_24.x in /etc/apt/sources.list.d/nodesource.list
  5 apt update · apt-cache policy nodejs → candidate 24.19.0-1nodesource1
  6 apt install -y nodejs        ⚠ SEE THE TRAP BELOW
  7 mv node_modules node_modules.old-node18 ; npm install
  8 pm2 start · pm2 save · systemctl daemon-reload · reboot

⚠⚠ **THE FINDING OF THE SESSION — apt RESTARTED THE APP BY ITSELF.**
  `apt install nodejs` triggered needrestart, which ran
  `systemctl restart pm2-ubuntu.service`. That service runs
  `pm2 resurrect`. The app we had DELIBERATELY STOPPED came straight
  back up, mid-upgrade, on the new engine, against the OLD
  node_modules, pointed at dev's live database. Nothing announced it.
  pm2 read `online` and ↺0 as though all were well.
  ▶ Drafted as TRAPS 11 below. ▶ It is a STEP in P210, not a footnote.

MEASURED, NODE 24, ON THE REAL INSTALL (not a scratch copy):
  npm install       exit 0 · 990 packages · 19s · npm 11.17.0
  EBADENGINE        NONE
  gyp / native      NONE
  package-lock.json NOT rewritten — git status showed only the
                    untracked rollback folder. Confirms S119 holds
                    under npm 11.
  grunt 1.0.4       runs as a child process of the app. Not a blocker.
  pm2 status        online, ↺ steady at 0 across two reads 8s apart
  curl              200

⚠ **npm 11 BLOCKS PACKAGE INSTALL SCRIPTS BY DEFAULT.** npm 10 ran them.
  Only `core-js@2.6.12` is affected here and its postinstall is a
  wrapped no-op, so nothing broke. **DO NOT APPROVE IT.** Recorded
  because a package whose postinstall actually builds something WOULD
  silently not build. → 3B

THE WRITE TEST — predicted BEFORE the release, then measured.
50 Kg of Ginger Powder, lot Mat-260804-3, released against MO-0014:
                        predicted     actual
  Material SOH          7719.322 Kg   7719.322 Kg   ✓ exact, no float tail
  Qty Released          2270.678 Kg   2270.678 Kg   ✓
  Qty Received / Misc   unchanged     unchanged     ✓
  MO-0014 plan & compl  41# (915.53)  41# (915.53)  ✓
  One Step Forward      a 5th row     5th row, 50 Kg ✓
  Header ties: 10000 − 2270.678 − 10 = 7719.322.

THE REBOOT — predicted, then measured. Came back with node v24.19.0 at
/usr/bin/node, abletrace-dev online ↺0, curl 200, MO-0014 at
41# (915.53 Kg) on screen after Shift+Cmd+R. **Resurrect works on the
new engine, unattended.**

⚠ **P206 CONFIRMED UNCHANGED.** The MO release panel still shows one row
  where traceability shows five. Pre-existing, untouched by the upgrade.

⚠ **WHAT THIS DOES NOT PROVE.** Dev is 24.04, prod is 26.04. The package
  layer transfers. **HOST behaviour does not.** Same ruling as S118/S119.
```

---

## THE NEXT JOB — S121

**P209 — GITHUB BUILDER TO NODE 24. THIS JOB ONLY.**

⚠⚠ **THE ROAD, RULED BY MINTY AT THE S120 CLOSE. DO NOT RE-ORDER IT.**
```
  S121  P209 — builder to Node 24            ← this session
  S122  3B pass + TRAPS 11                   → P211
  S123  Claude project workspace setup       → P212
        ── dev runs a week on Node 24 ──
  S124+ P210 — PROD to Node 24
```
▶ **WHY 3B COMES AFTER, NOT BEFORE.** P209 GENERATES the three facts 3B
is missing — the pin's file and line, the deploy procedure, and the
Mac's frontend repo path. Writing 3B first means writing it twice. The
dependency runs one way: **P209 feeds 3B; 3B does not feed P209.**
Everything P209 needs from 3B is already quoted into MATERIAL below.
▶ **WHY THE PROJECT SETUP COMES THIRD.** Uploading a stale 3B makes the
staleness permanent AND searchable — worse than today, where the errors
are at least known. Correct the documents, then upload them.

**WHY IT MATTERS, IN PLAIN WORDS.** The frontend is not built on either
box — a t3.small has too little memory for it. GitHub spins up a
temporary machine, compiles Angular into files, and vanishes. That
machine is pinned to Node 18. Dev's runtime is now 24, so the pin and
the boxes no longer agree. Minty ruled at S119 that they agree on
purpose. This closes that gap.

⚠⚠ **THIS IS NOT A DEV-ONLY SESSION AND S120 WAS.** The builder makes
the frontend for BOTH boxes — dev on a push, prod on a manual dispatch.
Changing it changes how prod's NEXT frontend build is made. Nothing
reaches prod until Minty dispatches, so it is not dangerous. But do not
call the session dev-only.

```
ACTION

0  OPEN CHECK, dev. ⚠ EXPECT `?? node_modules.old-node18/` — it is the
   rollback, it is meant to be there, do not investigate it.
   Prod: not touched, not read, unless Minty says otherwise.

1  ⚠⚠ **READ FOUR THINGS OFF THE MAC BEFORE CHANGING ANYTHING.** All
   four are cheap, and NONE of them exists in any document. This step
   is why the job can be executed at all.
     (a) WHERE THE FRONTEND REPO IS. **The Mac path is not recorded** —
         only dev's (~/abletrace-lab-frontend). Minty knows it; it gets
         written into 3B this session.
     (b) THE NODE PIN. 3B.4 says it exists and says why, but names no
         file and no line.
           ls -la .github/workflows/
           grep -rn "node-version\|setup-node\|NODE_OPTIONS" .github/workflows/
     (c) ⚠⚠ **THE ANGULAR VERSION AND ITS engines BLOCK. READ THIS
         BEFORE TOUCHING THE PIN.** This codebase is old — grunt 1.0.4,
         eslint 5, core-js 2. **Old Angular CLI declares a MAXIMUM
         supported Node.** If Angular refuses 24, the build fails and no
         amount of watching the run will fix it.
           grep -n "\"@angular/core\"\|\"@angular/cli\"" package.json
           grep -A6 "\"engines\"" package.json
         ▶ IF ANGULAR CAPS BELOW 24, STOP AND ASK MINTY. It becomes a
           business decision, not a fix — see ANALYSIS.
     (d) **THE DEPLOY PROCEDURE — read promote.sh.** P154/P176 have been
         open for many sessions because the steps live only in Minty's
         head. Claude writes the commands and cannot write commands it
         does not have.
           cat promote.sh
         ▶ **THIS IS THE THING THAT CLOSES P154/P176.** Read it, write
           the steps into NOW and 3B as they are run.

2  CHANGE THE PIN to 24. One clear single-purpose commit.
   Frontend is edited ON THE MAC. RULES §2. `git add` by named file.

3  PUSH. A push builds dev. Watch the run to completion.
   ⚠ **THE BUILD IS THE TEST.** Angular's toolchain is where a Node
     change bites, not the app code.
   ⚠ If it fails on memory, NODE_OPTIONS is the knob — see MATERIAL.

4  DEPLOY TO DEV, using what step 1(d) revealed. **WRITE THE STEPS DOWN
   AS THEY ARE RUN.**
   ⚠ READ THE ROLLBACK PATH OFF THE BOX FIRST. RULES §2. The recorded
     one is S91-era and unverified. → P66

5  PROVE IT ON SCREEN. Shift+Cmd+R, then:
   MO-0014 must read **41# (915.53 Kg)** · one release screen · one report.

6  PROD IS NOT DISPATCHED. The new builder's output reaches prod only at
   the next deliberate prod deploy, which is a separate decision.

7  ⚠ **3B IS NOT THIS SESSION.** Record what step 1 measured into NOW at
   the close — the pin's file and line, the deploy steps, the Mac repo
   path. S122 writes them into 3B, once, complete.
   ▶ **P200** (no `min` on the sales-order quantity) may be bolted on if
     this finishes clean — that session already builds and deploys the
     frontend, so it is nearly free. Minty's call at the box.

MATERIAL — quoted in, nothing to look up

  MAC   cyan prompt. The only machine that edits the frontend.
        ⚠ Repo path NOT RECORDED — step 1(a).
        ⚠ **THE ssh COMMAND ITSELF IS NOT RECORDED ANYWHERE EITHER.**
          Only the pem path is: ~/.ssh/abletrace-lab-key.pem
          Minty uses his own; it gets written into 3B this session.
  DEV   16.55.10.205 · green · pm2 abletrace-dev · Node v24.19.0
        backend ~/abletrace-lab-backend at 99852bf
  PROD  15.157.38.101 · red · NOT TOUCHED. **Still Node 18.**
    ⚠ **DEV IS 16.55.10.205. PROD IS 15.157.38.101.** One digit apart at
      the front. S119 landed on prod by mistyping it. Read the prompt
      colour before every command.
  Every block opens with `hostname -I`.
  After any restart: sleep 8, THEN curl.

  THE CI, quoted from 3B.4 (read S118):
    Runner ~7 GB · NODE_OPTIONS=--max-old-space-size=4096 · ~9 minutes ·
    artifact named dist-<target>-<full 40-char sha>.
    CI exists because the EC2 t3.small CANNOT build Angular — RAM
    ceiling. That is why the frontend is built on GitHub, not on a box.
    Dev's frontend copy is overwritten by the next deploy and is not a
    source of truth.
    Rollback: `www-html.bak-dev-4910b46d*` on dev (holds e1a82e02).
    ⚠ S91-era and UNVERIFIED → P66. **Read it off the box.**

  FIXTURE FIGURES for the on-screen proof:
    MO-0014 · lot Pdt-260811-1 · IP4 · **41# (915.53 Kg)** plan and completed
    Ginger Powder Mat-260804-3 · **SOH 7719.322 Kg** · Released 2270.678 Kg
    ⚠ These are POST-S120. S119's figures were 7769.322 / 2220.678.

  TARGET: Node 24. ⚠ DO NOT TARGET 26 — Current, not LTS.

  ROLLBACK for this job: revert the pin commit and push. The builder is
  stateless; the previous build artefact still exists on dev.

ANALYSIS — already done, do not re-derive

  · **THE BUILDER IS NOT THE RUNTIME.** GitHub's machine compiles files
    and vanishes; the app never meets it. So this CANNOT break S120's
    upgrade. It also gets no free ride from S120's proof — different
    machine, different job, own failure mode.
  · **PARITY IS SETTLED — MINTY, S119, RE-CONFIRMED S120.** 3B.4 says the
    builder is pinned "to match" the boxes. That intent STANDS. The
    wording is not deleted; it is DATED:
      *CI pins Node to match the boxes. 18 → 24, S120/S121. Parity is
       deliberate, re-confirmed S119.*
    ⚠ The alternative — let them drift and delete the claim — was
      offered and NOT taken. Do not re-derive it.
    ⚠ **3B's SENTENCE IS TEMPORARILY FALSE RIGHT NOW** (dev 24, builder
      18). Expected. It closes here.
  · ⚠⚠ **THE REAL RISK IS ANGULAR, NOT NODE.** setup-node will happily
    install 24. Whether this Angular version will RUN on 24 is the open
    question, and it is answerable in two minutes at step 1(c). If
    Angular caps below 24, the choices are: pin the builder to the
    highest Node Angular accepts and accept a documented gap; or leave
    the pin at 18 and upgrade Angular first, which is a much larger job.
    **Both break the parity ruling, so both go to Minty as a business
    question.** Do not pick one.
  · A different Node compiling the same Angular source SHOULD produce
    equivalent output. "Should" is not a measurement. Step 5 exists
    because a bad frontend build looks fine until one screen does not.
  · **110 npm vulnerabilities (33 critical)** are real, unrelated, and
    not this job. → P208

VERIFY

  CI run green · dev serving the new build · on screen after
  Shift+Cmd+R: MO-0014 at **41# (915.53 Kg)**, one release screen, one
  report · **and the deploy steps written down**, which closes P154/P176.
  ⚠ NOTHING IS DONE UNTIL IT IS SEEN ON THE SCREEN.
```

---

## TRAPS 11 — DRAFTED AND APPROVED BY MINTY, S120. **STILL TO BE WRITTEN INTO TRAPS.md.**

Carried here in full so it cannot be lost. It was not applied at the
S120 close because that needs the TRAPS file pulled in whole, and a
large paste is the thing that shortens a session. **S122 applies it,
with the 3B pass — P211.**

```
apt install nodejs RESTARTS pm2 AND THE APP COMES BACK UNATTENDED.

apt's needrestart sees the pm2 service linked to the Node binary it has
just replaced and runs `systemctl restart pm2-ubuntu.service`. That
service's job is `pm2 resurrect`, which restores whatever dump.pm2
holds. A deliberately stopped app therefore restarts MID-UPGRADE, on
the new engine, against the OLD node_modules, pointed at the live
database. Nothing announces it — pm2 reads `online` with ↺0 as though
all were well.
Measured S120, dev. On prod this is two clients' app coming back up
without instruction.
▶ AFTER `apt install nodejs`, READ `pm2 status` BEFORE ANYTHING ELSE.
  Stop the app again before reinstalling packages.
```

---

## A PROPOSAL FOR RULES — MINTY RULES, DEFAULT IS NO

**No new RULES line is proposed from S120's findings.** The needrestart
behaviour is a TRAPS entry and is classified as one. The missing ssh
command and repo paths are MATERIAL gaps for 3B. Neither is a rule.

**One line is proposed, and only one.** The OPEN check does not read the
engine. Until today that did not matter because both boxes ran the same
Node. **They now differ — dev 24, prod 18** — and will differ until P210
lands. A session could easily forget which box is which.

  Proposed addition to the OPEN block: `node -v`

  What it says: read the engine at every open.
  Why: the boxes diverged today and the check cannot currently see it.
  Which document: RULES, the OPEN block.
  ▶ Costs one line of output. ▶ Minty decides. The default is NO.

---

## THE JOB AFTER — S122. **P211 — 3B'S PASS + TRAPS 11.**

Owed since S118. It goes here, not earlier, because P209 produces three
of its entries. **One pass, written once, complete.**

**VERIFY:** 3B carries a true Node record for both boxes, TRAPS has 11
entries, and nothing in either file contradicts NOW or RULES.

Named exactly, not left as a search.

**New from S120:**
- **THE NODE RECORD.** Dev: `/usr/bin/node`, apt package
  `nodejs 24.19.0-1nodesource1`, repo `node_24.x`, npm 11.17.0, no nvm.
  Rollback file at `/home/ubuntu/nodesource.list.bak-S120` (holds the
  node_18.x line). **PROD IS UNMEASURED AND STILL ON 18 — SAY SO.**
- **THE ROUTE, for P210:** change the repo line, `apt update`,
  `apt install -y nodejs`. APT REPLACES, IT DOES NOT ADD.
- **needrestart restarts pm2** — cross-reference TRAPS 11.
- **npm 11 blocks install scripts by default.** core-js@2.6.12 only,
  a no-op, do not approve.
- **pm2-ubuntu.service** at `/etc/systemd/system/`, enabled, runs
  `pm2 resurrect`. Proven through the S120 reboot on Node 24.
- **THE ssh COMMAND IS NOT RECORDED ANYWHERE.** Write it down.
- **THE MAC'S FRONTEND REPO PATH IS NOT RECORDED.** Write it down.
- **Kernel after the S120 reboot was not measured.** Was 7.0.0-1010-aws.
- Two tarball folders remain at `/home/ubuntu/node-v2*-linux-x64`.
  No longer needed — deletable whenever Minty says.

**Carried from S119, still owed:**
- **3B.2 CONTRADICTS ITSELF ON THE REBOOT.** It warns "rebooting dev does
  NOT rehearse rebooting prod", then four lines later says "⚠ DO DEV
  FIRST — it is a true twin, so it is a real rehearsal." **Delete the
  second.** Dev-first is right for a different reason: dev has no clients.
- **3B.2 kernel lines are stale** (prod 7.0.0-1004 / dev 6.17.0-1017).
- **Delete the "SYSTEM RESTART REQUIRED — PENDING SINCE S35" note.**
  Done S118, both boxes.
- **3B.8 says dotenvx; it is dotenv.** Proven on screen S119. RULES §4 is
  already corrected; 3B.8 is not.
- **3B.4's rollback points read `www-html.bak-{prod,dev}-275c025039d7`
  (S91).** Both boxes are now at **4910b46d**. → P66
- **3B.2 calls the reboot P21; NOW called it P102.** Minty's call which
  number survives.
- ⚠ **3B.4 step 4 says Cmd+Q the browser; RULES §2 says Shift+Cmd+R**
  (Minty, S106). RULES is later and is the authority.
- **Add dev's private address 172.31.1.196** beside the public one.
- Strip incident language. Delete the build-history header and the
  ROUTING RECORD.

---

## THE JOB AFTER THAT — S123. **P212 — CLAUDE PROJECT WORKSPACE.**

**WHAT IT IS, IN PLAIN WORDS.** A Claude Project is a workspace with two
extra parts: an INSTRUCTIONS field that is loaded into every chat
automatically, and a KNOWLEDGE base of uploaded files Claude can search
without them being pasted. **It removes the two large pastes at every
open.** RULES and NOW are ~35K characters between them, and RULES §6
names large pastes as the thing that shortens a session.

⚠ **WHAT IT DOES NOT FIX.** The close still has to be written — that is
the expensive part, not the paste. NOW is still rewritten whole. **And
it invents nothing that was never recorded.** Estimated gain: 10–15
minutes and real context back at every open; 10–20% on a whole session.
▶ **The larger win is quality, not speed.** 3B kept being deferred partly
because opening it cost a paste. Searchable, it stops being deferred.

```
ACTION

1  Create ONE project, "AbleTrace". Not several — the work crosses
   backend, frontend, database and infrastructure constantly, and a
   split guarantees the missing half is the one needed.

2  RULES → the INSTRUCTIONS field.
   ⚠ There is a length cap and RULES may exceed it. If it overflows:
     put RULES in KNOWLEDGE as a file, and make the instruction
     "read RULES.md in full at the open." Weaker, still workable.

3  KNOWLEDGE — upload, in this order:
     3A · 3B · Section 5/JR · TRAPS · Bible Part 1 · Bible archive · NOW
   ⚠ Section 5/JR is NOT IN GIT. Uploading it is the only copy that
     will exist in two places. Good, but note it.

4  ADD TWO LINES TO RULES:
     (a) **The git repo is the arbiter. Project knowledge is a MIRROR,
         refreshed from it.** Prevents two copies drifting — the exact
         trap the method exists to avoid.
     (b) To §6 CLOSE: **replace NOW in project knowledge.** Makes the
         refresh a ritual rather than something to remember.

5  Test it: start a chat and ask for something that lives only in 3B.
   If it comes back right, the wiring works.

ANALYSIS

  · ⚠ **MEMORY IS PER-PROJECT AND ISOLATED.** Moving in starts a fresh
    memory space. Not a blocker — the documents have always been the
    real memory — but it is a one-time transition cost.
  · Knowledge auto-switches to search (RAG) as it grows, which is
    literally the "consulted on demand" rule in software.
  · ⚠ Do NOT upload before S122. A stale 3B uploaded is stale AND
    searchable — Claude would retrieve it confidently and be
    confidently wrong. Today the errors are at least known.
```

---

## QUEUE — Minty ranks. New items at the bottom, never renumbered.

**Top candidates**

- **P209** GitHub builder to Node 24. → THE NEXT JOB, above.
  ⚠ Not dev-only: the builder makes prod's frontend too.
  ⚠⚠ Three facts it needs exist in NO document — the Mac repo path, the
    pin's file and line, and the deploy procedure. **MEASURE, DO NOT
    GUESS.** Carried here as well as in the job block, because NOW is
    rewritten whole and a job block dies with the job.
- **P210** **PROD TO NODE 24.** Prod is still on 18, unpatched since
  April 2025. Dev has proven the package layer end to end.
  ⚠ **NOT BEFORE DEV HAS RUN ON 24 FOR AT LEAST A WEEK.** Minty's pace.
  ⚠ Prod is Ubuntu 26.04; dev is 24.04. **The host does not transfer.**
  ⚠ **PROD'S INSTALL METHOD IS UNMEASURED.** Almost certainly NodeSource
    apt like dev. Measure it, do not assume.
  ⚠⚠ **needrestart WILL RESTART THE APP MID-UPGRADE** — TRAPS 11. On
    prod that is Glutenull and Hagensborg coming back up unattended.
    This is a STEP in the runbook, not a warning at the end of it.
  ⚠ Two clients' data. Own session, nothing else in it.
- **P211** 3B's pass + TRAPS 11. → THE JOB AFTER, above. Owed since
  S118. Sits after P209 because P209 writes three of its entries.
- **P212** Claude project workspace. → THE JOB AFTER THAT, above.
  ⚠ Not before P211 — uploading a stale 3B makes it permanently wrong
  and searchable.
- **P206** **MO material release panel shows ONE release per material,
  not each distinct release.** MO-0014 traceability now lists five
  Ginger Powder releases (916.471, 10, 100, 200, 50 Kg); the MO's own
  Material/Products Release Details panel shows a single row of 916.471
  — and is not summing them either. **PRE-EXISTING, re-confirmed S120
  after the upgrade — not a Node finding.**
  ⚠ A warehouse controller reading that MO cannot see what was actually
  consumed. Find which query feeds the panel; suspect a join collapse
  or a missing aggregate. Raised by Minty.
- **Return path** — P163, **P164 (inverted sign, live on both clients)**,
  P165, P168, rows 20/42/43. Budget as a survey; never read end to end.
  ⚠ `PackingSlips.js:267` and `:419` subtract `currentToDate - returnQty`
  with **no floor** — the same negative-balance exposure Minty ruled
  against in S116, on the return path. Measured S117.
- **P111** QuickBooks. Precondition met — the units write path is closed
  and promoted. One planning session, no code. Needs a new column
  (TRAPS 3).
- **P203** Neither box has ESM Apps enabled; 17 updates pending on dev,
  36 on prod. Measured S118. ⚠ Dev's figure will have changed — S120 ran
  `apt update` and upgraded nodejs only, leaving 17 others.
- **P205** PM2 differs between boxes: **dev 7.0.3, prod 7.0.1**.
  Installed GLOBALLY, outside package-lock's control, so it drifts
  independently. Both resurrected correctly through the S118 reboot;
  dev again through S120's.
  ⚠ package.json declares `pm2 ^5.3.0` and neither box runs 5.x.
- **P204** 3B cites queue numbers not in this file — P1(b), P3, P4, P12,
  P16, P21, P23, P28, P74, P76, P77. **Settle before ranking by number.**
- **P207** Waterline warns at every boot: null `description` on
  `companyuserrole` and `roles`, null `createdAt`/`updatedAt` on
  `company`. Old data against newer model definitions. Harmless in
  itself — but it floods the error log, and **a real error would be
  buried in it**. That is the only reason it matters. Measured S119.
- **P208** `npm install` reports **110 vulnerabilities, 33 critical**,
  unchanged under Node 24 and npm 11. Unrelated to the engine. Not yet
  read in detail — `npm audit` names them. Re-measured S120.

**Units campaign leftovers** — board 38 green of 51, a deliberate stop.
⚠ The Bible is **frozen as an archive at S117**. Consulted per row.

- **Rows 37-41** unblocked; the column is populated. Row 41 is cheapest
  and most visible — release details shows Kg with no unit count.
  ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
- **P196** two intermediate blocks disagree by 0.011 Kg (0.004 on the
  IP4 fixture). Display only.
- **P135** two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
- **P198** `formulations.inventory` (the Kg line) carries float tails.
  ⚠ The Kg line has **no floor and no rounding** — only `inventory_units`
  gets `Math.round` and `Math.max(0,…)`. Low.
  ⚠ MO-0005 displays `4.8100000000000005 Kg` on material traceability.
    Stored history, not new.

**Open, unranked**

P8 prod frontend checkout lags · P17 two old IAM keys live · P20/P22
delete old section files · P64 product label prints "null" · P65
promote.sh no -4 · P66 stale rollback points · P84/P85 printer guides ·
P86 cold boot untested · P88 dead "Fix A" pointers · P90 two false claims
in 3A · P94 stray heal file on prod · P101/P109 dormant archive holds its
own procedures · P106 old map file · P108 review J-entries · P114 closed
vs in-progress MOs · **P115 delete dead code** (below) · P116/P117
file-read handling · P118 comment deliberate code *(working — keep)* ·
P119 db definitions stale on ten objects · P120 material barcode ·
P121-P123 client guide gaps · P124 SO status compares units to Kg,
**live** · P129 food safety toggle has no attribute · P130 Excel exports
unchecked · P131 unit count with weight label · P132 dead status columns ·
P133 do_status never advances · P134 schema naming · P136 view returns
duplicates · P137 MR numbering global · P138 soproducts has no unit count
⚠ **and no company_id — scope any heal through SO_id → somanagement
(measured S117)** · P139 not defects · P142 MR buttons commented out ·
P145/P146 MR screen quirks · P148 narrow residual · P152 read-rows drops
columns · P153 .bak in api/models · **P154/P176 deploy procedure not
written down — CLOSES INSIDE P209** · P155 Mac push and prod origin ·
P156 company-id namespaces differ · P158/P159 IP trace procedures divide ·
P166 field named ship_qty holds Kg · P167 seven-copy helper · P169
transposed labels · P170 pre-JR15 MR rows read low · P171 unmapped
quantity tables · P172 receipt code not unique · P173 nameless 0.000 row ·
P174 form control written into batches · P175 gate that cannot fail ·
P178 retention rule · P179 `formulations_myCodee` typo · P182
undocumented controls · P185 eval() on release screen, five sites · P189
possible double-count · P190 VARCHAR subtraction · P191 lot scanner
undocumented · P192 final_qty from `batches` (fires only on duplicate
rows) · P194/P195 Kg displays, correct under the S116 ruling

- **P200** Negative quantity accepted on the add-sales-order screen.
  `add-sales-order.component.html:84` has no `min`; `.ts:245` and `:249`
  have no `Validators.min(0)`. Fix both. Frontend — needs a build and
  deploy. ⚠ Check the sibling quantity-entry screens before closing.
  ▶ **Cheap to bolt onto P209** — that session already builds and
    deploys the frontend. Minty's call.
- **P201** Acrobatics at `add-sales-order.component.ts:393`.
  `(quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit)` — batch_qty
  cancels, so it divides a weight to make a unit count. Assigns
  `shippingUnit`, not `quantity`. ⚠ **Not the cause of P199.**
  ⚠ Reachability unmeasured — confirm what calls it before fixing.

**P115 dead code:** `rejected-materials.ts:152-154` · `MLOManagement.js`
getMLCbyId/V2 · `PopUps/add-dispatch` v1 · `edit-mlc.ts:311,227` ·
`MaterialsProductsReleased.js:52` and `:83-98` (the dead release twin) ·
`material-traceability-details.html:113-125, 191-216` · `Traceability.js`
@returnedQty/@mprIDs

---

## CLOSED — delete these lines at the next close

**P202b** (dev upgraded to Node 24.19.0, S120: installed, lifted, served
200, wrote a 50 Kg release to the exact predicted figures, and
resurrected on 24 through a reboot — all seen on screen) · P202 · P102 ·
P177 · P180 · P199 · P184 · P188 · P197 · P187 · P186 · P181 · P183 ·
P160 · P162 · P151 · P157 · P147 · P161 · P104 · P150

---

## SETTLED DECISIONS — do not re-open

- **A session opens on RULES and NOW only.** Everything else on demand.
  No dedicated documents session — a file is cleaned when next opened.
  *(Minty, S117)*
- **A reboot is its own step.** Never mid-work, never both boxes at once.
  Dev first, standalone; prod only if dev resurrects cleanly.
  *(Proven S118 and again S120.)*
- **Dev does not rehearse prod's OS.** 24.04 against 26.04. State the
  verdict out loud before relying on a dev result. *(S118, held S119, S120.)*
- **Dev runs on a new engine for a while before prod is asked to.**
  *(Minty, S120.)*
- **THE ROAD IS P209 → P211 (3B+TRAPS) → P212 (project) → week → P210
  (prod).** A document is corrected only after the job that generates
  its content, and uploaded to project knowledge only after it is
  correct. *(Minty, S120 — do not re-order.)*
- **Release input stays kilograms.** The unit count is derived once at
  the write, rounded to three decimals, and the same figure is banked in
  the row and subtracted from stock. *(Minty, S116)*
- **~0.001 variance on a multi-release lot is accepted.** SOH is
  reconciled against physical count monthly. The cumulative fix was
  offered and rejected on domain grounds — do not re-derive it.
  *(Minty, S116)*
- **Stock must never go negative.** `Math.max(0,…)` on both branches.
- **Return path goes last.** *(Minty, S112)*
- **Materials are Kg only; anything carrying a formula_id carries
  units.** *(Minty, S112 — Bible Part 1 §5)*
- **Traceability reports what was released at the time.** *(Minty, S112)*
- **CI's Node stays in step with the boxes.** The builder is independent
  of the runtime and need not match — but Minty rules that it DOES, on
  purpose. 18 → 24, dev runtime first (S120, done), builder second
  (S121). 3B.4's "to match" wording stays; it gets a date and a version.
  *(Minty, S119, re-confirmed S120)*

---

## ONE CORRECTION TO CARRY

Bible PART 4 records the IP4 lot ratio as `0.04478498…`. The true figure
is `41 ÷ 915.53 = 0.0447828…`. It changed no result — 1.957 either way —
but it is wrong where a future session would copy it.
