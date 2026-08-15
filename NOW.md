# NOW — S119 close, 15 Aug 2026

**State, next job, queue. Nothing else.**

⚠⚠ **A SESSION OPENS ON TWO FILES: RULES AND THIS ONE.** *(Minty, S117)*
Everything else is consulted ON DEMAND, when the work touches it:
**BUSINESS LOGIC** (Bible Part 1) · **3B** infrastructure · **3A** the app ·
**Section 5 / JR** the database record · **TRAPS** (10).
▶ NO DEDICATED TIDY-UP SESSION. A document is cleaned when it is next
opened, by the session that opens it. *(Minty, S117)*

**What does not go here:** lessons, narrative, retrospectives, proof
write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment
beside the code. If it fits none of those it goes nowhere.

---

## STATE

```
DEV   16.55.10.205  Ubuntu 24.04.4 LTS  kernel 7.0.0-1010-aws  Node v18.20.8
      backend 99852bf  pm2 abletrace-dev  online  ↺0 (reset at close)  200  clean
      frontend serving 4910b46d · checkout c2a52d8e (stale, harmless)
PROD  15.157.38.101  Ubuntu 26.04 LTS    kernel 7.0.0-1010-aws  Node v18.20.8
      ⚠ NOT READ THIS SESSION. Values carried from the S118 close.
      backend 99852bf  pm2 abletrace-backend
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   frontend repo clean at 4910b46d — the only machine that edits it
```

**No code changed this session.** P202 was a survey: nothing installed to
the system, nothing upgraded, nothing switched. Dev ends exactly as it
opened — verified on screen, MO-0014 reading 41# (915.53 Kg).

⚠ **PROD WAS NOT TOUCHED AND NOT READ.** The job block said dev only and
that was held to. The prod line above is S118's, not a fresh measurement.
S120 opens on prod's own OPEN check before relying on it.

⚠ **`hostname -I` ON DEV RETURNS 172.31.1.196**, the private address. This
file records the public one, 16.55.10.205. Both are dev. Noted so a
future session does not read a mismatch where there is none. → 3B

---

## PENDING PROMOTION

Nothing. Backend, frontend and database are all level across both boxes.

---

## P202 — WHAT THE SURVEY FOUND. Measured S119, do not re-derive.

```
VERDICT: NODE 24 PASSES ON DEV, AT THE PACKAGE LAYER, INCLUDING A WRITE.
         NODE 22 WAS NOT LIFTED — it became unnecessary once 24 passed.

HOW NODE IS INSTALLED ON DEV — step 1's answer, and it is the one that
shapes the upgrade:
  /usr/bin/node · dpkg package `nodejs 18.20.8-1nodesource1` ·
  repo /etc/apt/sources.list.d/ pinned to deb.nodesource.com/node_18.x ·
  NO nvm.
  ⚠⚠ **APT REPLACES, IT DOES NOT ADD.** There is no way to apt-install a
    second Node alongside. Point the repo at 24 and the default flips
    system-wide the instant apt runs — and S118 proved pm2 resurrects
    unattended, so a flipped default reaches the app without anyone
    touching it. That is WHY S119 used tarballs instead.
  ▶ **THE UPGRADE ROUTE IS THEREFORE: change the repo line from
    node_18.x to node_24.x, then apt. One command, and it is a
    REPLACEMENT, not an addition.**
  ⚠ **PROD'S INSTALL METHOD IS UNMEASURED.** Almost certainly the same.
    Not assumed. S120 measures it.

INSTALLED ALONGSIDE, AND STILL ON THE BOX — plain folders, nothing
registered with the system, deletable at any time:
  /home/ubuntu/node-v24.19.0-linux-x64/bin/node
  /home/ubuntu/node-v22.23.2-linux-x64/bin/node
  Kept deliberately: S120 wants them. `/usr/bin/node` never moved —
  verified before and after every step.

MEASURED, NODE 24, IN A SCRATCH COPY:
  npm install         exit 0 · 990 packages · 17s · npm 11.17.0
  EBADENGINE          NONE. Nothing declared itself incompatible.
  gyp / native build  NONE. Confirms S118: no native modules.
  **grunt 1.0.4**     INSTALLED AND RAN. It was named the likeliest
                      blocker; sails-hook-grunt runs at lift and the
                      lift succeeded. **IT IS NOT A BLOCKER.**
  Sails lift          `Server lifted` · v1.5.8 · port 1337
  curl                200
  package-lock.json   NOT rewritten by the install (git status clean),
                      so the 22 and 24 runs are genuinely comparable.

MEASURED, NODE 22: npm install exit 0, no engine complaints, npm 10.9.8.
  **NOT LIFTED.** 24 passing made it moot. If 24 ever fails in the wild,
  22's install is known good and the lift is ten minutes.

THE WRITE TEST — the strongest evidence taken. Predicted BEFORE the
release, then measured. 200 Kg of Ginger Powder, lot Mat-260804-3,
released against MO-0014 through the app on Node 24:
                        predicted     actual
  Material SOH          7769.322 Kg   7769.322 Kg   ✓
  Qty Released          2220.678 Kg   2220.678 Kg   ✓
  Qty Received / Misc   unchanged     unchanged     ✓
  MO-0014 plan & compl  unchanged     unchanged     ✓
  One Step Forward      new 200 row   new 200 row   ✓
  Every figure landed. The release path wrote correctly under Node 24.

⚠ **`migrate: "safe"` — config/models.js:53, `alter` commented at :55.**
  Measured before lifting. A lift touches no tables. This is why the
  scratch copy could safely point at dev's live database.

⚠ **THE BOOT WARNINGS ARE NOT NODE'S.** Waterline complains about null
  `description` (companyuserrole, roles) and null createdAt/updatedAt
  (company). Old data against newer model definitions. Prints identically
  on 18; pm2 just hides it in a log. → P207

⚠ **WHAT THIS DOES NOT PROVE.** Dev is 24.04, prod is 26.04. The package
  layer transfers (identical lock, identical versions — S118). **HOST
  behaviour does not.** Same ruling as S118 and S119.
```

---

## THE NEXT JOB — S120

**P202b — UPGRADE DEV TO NODE 24. DEV ONLY. PROD IS NOT TOUCHED.**

**WHY IT MATTERS, IN PLAIN WORDS.** Node is the engine the app runs on.
Both boxes run Node 18, which stopped getting security fixes in April
2025 — sixteen months ago. People still find holes in it; nobody patches
them. S119 proved the app runs correctly on Node 24, including a real
release that wrote the exact figures predicted in advance. This session
makes that the engine dev actually uses. **Prod follows in its own
session, once dev has run on 24 for a while.**

**WHY DEV ALONE, AND WHY NOT BOTH TODAY.** Prod is a different operating
system and carries two clients' data. A dev result is evidence about the
packages, not about prod's host. Dev also gets to run for days before
prod is asked to. Nothing about this is urgent enough to skip that.

```
ACTION — DEV ONLY. PROD IS NOT TOUCHED AT ANY POINT.

1  OPEN CHECK, then read the engine and confirm the two tarball folders
   survived the week.
     hostname -I
     node -v ; which node
     ls -d /home/ubuntu/node-v2*-linux-x64
   ⚠ If the folders are gone, re-fetch them — the commands are in
     MATERIAL below.

2  BACK UP THE ROLLBACK ROUTE BEFORE CHANGING ANYTHING.
     dpkg -l | grep -i nodejs
     cat /etc/apt/sources.list.d/*node*
   ⚠ **WRITE THE EXACT PACKAGE VERSION STRING DOWN.** It is
     `18.20.8-1nodesource1` as of S119. That string IS the rollback.

3  STOP THE APP FIRST. `pm2 stop abletrace-dev`, confirm stopped.
   ⚠ Do not upgrade an engine underneath a running process.

4  SWITCH THE REPO AND UPGRADE.
     The NodeSource line changes node_18.x → node_24.x, then
     `sudo apt update` and `sudo apt install -y nodejs`.
   ⚠⚠ THIS REPLACES NODE 18. It is not reversible by undo — only by
     reinstalling 18 from the same repo route. That is the rollback.
   Then: `node -v` must read v24.x and `which node` must read
   /usr/bin/node.

5  REINSTALL THE APP'S PACKAGES AGAINST THE NEW ENGINE.
     cd ~/abletrace-lab-backend ; rm -rf node_modules ; npm install
   ⚠ `package-lock.json` IS IN GIT and must NOT be committed if npm
     rewrites it. Check `git status` after. S119 measured that it does
     NOT get rewritten — if it does this time, that is a finding.

6  START AND PROVE IT.
     pm2 start abletrace-dev ; sleep 8 ; pm2 status ; curl … 1337
   ⚠ ↺ MUST STAY PUT. A CLIMBING ↺ IS A CRASH LOOP, NOT A SLOW BOOT.
     Read it twice, eight seconds apart, before believing it.

7  WALK THE PATHS ON THE BROWSER. Shift+Cmd+R first.
   Log in · MO-0014 must read **41# (915.53 Kg)** · release some
   material and check SOH moves by exactly what was released ·
   material traceability · one report.

8  SAVE THE STARTUP DEFINITION. `pm2 save`, so a reboot brings the app
   up on 24 and not on a stale definition.
   ⚠ Then REBOOT DEV and prove it resurrects on 24 unattended. S118
     proved resurrect works; this proves it works on the new engine.
     ▶ Minty's call whether the reboot is this session or its own.

MATERIAL — quoted in, nothing to look up

  DEV   16.55.10.205 · green prompt · pm2 name abletrace-dev
        Ubuntu 24.04.4 LTS · Node v18.20.8 at /usr/bin/node
        backend repo ~/abletrace-lab-backend at 99852bf
        apt package `nodejs 18.20.8-1nodesource1`
        repo deb.nodesource.com/node_18.x nodistro main
        signed-by /usr/share/keyrings/nodesource.gpg
  PROD  15.157.38.101 · red prompt · NOT TOUCHED THIS SESSION.
  ssh and scp ALWAYS from the Mac; the pem exists nowhere else.
    ⚠ **DEV IS 16.55.10.205. PROD IS 15.157.38.101.** One digit apart at
      the front. S119 landed on prod by mistyping it. Read the prompt
      colour before every command.
  Every block opens with `hostname -I`.
  Backend is edited, committed and pushed ON DEV — no build step.
  After any restart: sleep 8, THEN curl.

  TARGET VERSIONS, measured S119 (14–15 Aug 2026):
    Node 24.19.0  Active LTS   ← the target
    Node 22.23.2  Maintenance  ← the fallback, install proven, lift not
    ⚠ DO NOT TARGET 26. Current, not LTS.
    Tarball re-fetch if the folders are gone:
      cd /home/ubuntu
      curl -fsSLO https://nodejs.org/dist/latest-v24.x/node-v24.19.0-linux-x64.tar.gz
      tar -xzf node-v24.19.0-linux-x64.tar.gz

  ROLLBACK — the real one, because this session DOES change the box:
    Repo line back to node_18.x, `sudo apt update`, then
    `sudo apt install -y nodejs=18.20.8-1nodesource1`.
    Then rm -rf node_modules and npm install again on 18.
    ⚠ **NO ECOSYSTEM FILE EXISTS** (S118). pm2 definition is in
      dump.pm2; `pm2 resurrect` restores it. If pm2 loses the process:
      pm2 start /home/ubuntu/abletrace-lab-backend/app.js --name abletrace-dev

ANALYSIS — already done, do not re-derive

  · **THE FOUR SUSPECTS ARE ANSWERED.** grunt 1.0.4 installs AND runs on
    24 — it was the likeliest blocker and it is not one. eslint 5.16.0 is
    devDependency only, cannot reach the running app. aws-sdk v2 warns at
    boot on every version including 18. nested-pop 0.1.4 is untouched by
    the engine. **NO NAMED BLOCKER SURVIVES.**
  · The scratch copy pointed at dev's live database and wrote to it —
    deliberately, because `migrate: "safe"` was measured first. The S120
    upgrade writes to the same database from the same code. No new risk.
  · **110 npm vulnerabilities (33 critical) reported on both engines.**
    Real, unrelated to Node, and NOT this job. → P208
  · The upgrade is one session if clean. S119 removed the reason to
    expect otherwise.
  · ⚠ **NODE 18 LIVES IN THREE PLACES.** 3B.4 records the GitHub Actions
    frontend build pinning Node 18 "to match" the boxes. The Angular
    build engine is INDEPENDENT of the app's runtime, so it does NOT
    block this. **SETTLED S119, MINTY: PARITY IS KEPT ON PURPOSE — dev
    runtime to 24 first, then the builder to 24 (P209).** The "to match"
    wording therefore STAYS. It needs a date and a version, not deletion:
      *CI pins Node to match the boxes. 18 → 24, S120/S121. Parity is
       deliberate, re-confirmed S119.*
    ▶ Do not re-open this as a question. It was asked and answered.
  · **SETTLED S118, RE-CONFIRMED S119 ON SCREEN: IT IS `dotenv`, NOT
    `dotenvx`.** The lift printed dotenv's own "◇ injected env (9)"
    banner. **RULES §4 and 3B.8 both carry the wrong name.** Correct
    both. Changes no command; makes the credentials record true.

VERIFY

  Dev running Node 24, pm2 abletrace-dev online with a STEADY ↺, curl
  200, and on the browser: MO-0014 at 41# (915.53 Kg), plus a release
  whose SOH movement equals exactly what was released.
  ⚠ NOTHING IS DONE UNTIL IT IS SEEN ON THE SCREEN.
```

---

## THE JOB AFTER — S121, AND IT MAY BE PULLED INTO S120

**P209 — GITHUB BUILDER TO NODE 24.** Written out here so that IF S120
finishes fast and clean, this can be started the same day WITHOUT opening
3B. Minty decides at the box, not in advance.

**WHY IT IS SEPARATE.** The builder is not the runtime. GitHub Actions
spins up a temporary machine, compiles Angular into files, and vanishes.
The app never meets it. So it CANNOT break the backend upgrade — but it
also gets no free ride from S120's proof, because it is a different
machine doing a different job with its own failure mode.

⚠⚠ **THIS IS NOT A DEV-ONLY JOB, AND S120 IS.** The builder produces the
frontend for BOTH boxes — dev on a push, prod on a manual dispatch.
Changing it changes how PROD's next frontend build is made. Nothing
reaches prod until Minty dispatches, so it is not dangerous. But do not
call the session dev-only once this is in scope.

```
ACTION

1  MEASURE WHERE THE PIN IS. **NOT RECORDED ANYWHERE — 3B.4 states the
   Node 18 pin exists and WHY, but not the file or the line.** This is a
   genuine measurement. On the MAC, in the frontend repo:
     ls -la .github/workflows/
     grep -rn "node-version\|setup-node\|NODE_OPTIONS" .github/workflows/
   ⚠ Expect a `uses: actions/setup-node` block with a version. That
     version string is the whole job.

2  CHANGE THE PIN to 24, on a branch or with a clear single-purpose
   commit. Frontend is edited ON THE MAC. RULES §2.

3  BUILD. A push builds dev. Watch the run to completion.
   ⚠ **THE BUILD IS THE TEST.** Angular's toolchain is where a Node
     change would bite, not the app code.
   ⚠ If it fails on memory, the NODE_OPTIONS line below is the knob.

4  DEPLOY TO DEV AND PROVE IT ON SCREEN. Shift+Cmd+R, then MO-0014 must
   read **41# (915.53 Kg)**, plus one release screen and one report.
   ⚠⚠ **THE DEPLOY PROCEDURE IS NOT WRITTEN DOWN — P154/P176, still
     open.** Minty runs promote.sh from the Mac and knows the steps;
     Claude does not have them quoted. **WRITE THEM DOWN WHILE DOING
     THEM.** That closes P154/P176 as a by-product.

5  PROD IS NOT DISPATCHED. The new builder's output reaches prod only at
   the next deliberate prod deploy, which is a separate decision.

MATERIAL — what IS recorded, quoted from 3B.4 (read S118)

  Runner ~7 GB · NODE_OPTIONS=--max-old-space-size=4096 · ~9 minutes ·
  artifact named dist-<target>-<full 40-char sha>.
  CI exists because the EC2 t3.small CANNOT build Angular — RAM ceiling.
  That is why the frontend is built on GitHub and not on the box.
  Frontend repo lives on the MAC and on GitHub. Dev's copy is
  overwritten by the next deploy and is not a source of truth.
  Rollback: `www-html.bak-dev-4910b46d*` on dev (holds e1a82e02).
  ⚠ These backup paths are S91-era and UNVERIFIED. → P66. **Read the
    rollback path off the box before relying on it.** RULES §2.

ANALYSIS

  · **PARITY IS SETTLED — MINTY, S119.** 3B.4 says the builder is pinned
    to 18 "to match" the boxes. That intent STANDS: dev runtime to 24
    (S120), then the builder to 24 (this job). The wording is not
    deleted; it is DATED and given its new number:
      *CI pins Node to match the boxes. 18 → 24, S120/S121. Parity is
       deliberate, re-confirmed S119.*
    ⚠ The alternative — let them drift and delete the claim — was
      offered and NOT taken. Do not re-derive it.
    ⚠ **UNTIL THIS JOB LANDS, 3B's SENTENCE IS TEMPORARILY FALSE** (box
      24, builder 18). That gap is expected and closes here.
  · A different Node compiling the same Angular source SHOULD produce
    equivalent output. "Should" is not a measurement. Step 4 exists
    because a bad frontend build looks fine until one screen does not.
  · Small job, own failure mode. That is why it is written separately
    rather than bolted onto S120's verify.
```

---

**3B'S PASS IS STILL OWED.** S118 measured but did not open it; S119 did
not open it either. **S120 opens 3B for the Node record — it gets its
pass then, by that session.** Named exactly, not left as a search:
- **ADD THE NODE INSTALL METHOD** — NodeSource apt, `/usr/bin/node`,
  package `nodejs 18.20.8-1nodesource1`, repo `node_18.x`, no nvm.
  Measured S119, dev. **Prod unmeasured — say so.** Date the v18.20.8
  line to S118, and record the new version once S120 lands.
- **3B.2 CONTRADICTS ITSELF ON THE REBOOT.** The OS block warns
  "rebooting dev does NOT rehearse rebooting prod", then four lines later
  says "⚠ DO DEV FIRST — it is a true twin, so it is a real rehearsal."
  **Delete the second.** Dev-first is right for a different reason: dev
  is the box with no clients.
- **3B.2 kernel lines are stale.** Records prod 7.0.0-1004 / dev
  6.17.0-1017. Both are now **7.0.0-1010-aws** (S118).
- **Delete the whole "SYSTEM RESTART REQUIRED — PENDING SINCE S35"
  note.** Done S118, both boxes.
- **Record that pm2 resurrect is PROVEN**, both boxes, S118.
- **3B.8 says dotenvx; it is dotenv.** Proven on screen S119.
- **3B.4's rollback points read `www-html.bak-{prod,dev}-275c025039d7`
  (S91).** Both boxes are now at **4910b46d**. → P66
- **3B.2 calls the reboot P21; NOW called it P102.** One job, two
  numbers. Note which survives — Minty's call.
- ⚠ **3B.4 step 4 says Cmd+Q the browser; RULES §2 says Shift+Cmd+R**
  (Minty's ruling, S106). RULES is later and is the authority.
- **Add dev's private address 172.31.1.196** beside the public
  16.55.10.205, so `hostname -I` output is never read as a mismatch.
- Strip incident language. Delete the build-history header and the
  ROUTING RECORD.

---

## QUEUE — Minty ranks. New items at the bottom, never renumbered.

**Top candidates**

- **P202b** Upgrade dev to Node 24. → THE NEXT JOB, above.
- **P209** GitHub builder to Node 24. Parity with the boxes is
  deliberate — settled S119, do not re-open. → THE JOB AFTER, above.
  May be pulled into S120 if it finishes clean.
  ⚠ Not dev-only: the builder makes prod's frontend too.
  ⚠⚠ **TWO FACTS THIS JOB NEEDS DO NOT EXIST IN ANY DOCUMENT. MEASURE
    AND RECORD THEM, DO NOT GUESS.** Carried here in the QUEUE, not only
    in the job block, because NOW is rewritten whole and a job block
    dies with the job.
      (a) **WHERE THE NODE PIN LIVES.** 3B.4 says the CI pins Node 18
          and says why, but names no file and no line. Measure on the
          Mac: `grep -rn "node-version\|setup-node" .github/workflows/`
          ▶ RECORD THE FILE AND LINE IN 3B.4.
      (b) **THE FRONTEND DEPLOY PROCEDURE — P154/P176, still open.**
          Minty runs promote.sh and knows the steps; they are written
          down nowhere. P209 cannot be proved without a deploy.
          ▶ WRITE THE STEPS DOWN WHILE RUNNING THEM. That closes
            P154/P176 as a by-product of a job that needs it anyway.
- **P206** **MO material release panel shows ONE release per material,
  not each distinct release.** Measured S119 on MO-0014: traceability
  lists four Ginger Powder releases (916.471, 10, 100, 200 Kg) but the
  MO's own Material/Products Release Details panel shows a single row of
  916.471 — and it is not summing them either (that would be 1226.471).
  ⚠ **PRE-EXISTING, NOT A NODE FINDING** — the 10 and 100 rows were
  already there and already missing before anything was touched.
  ⚠ A warehouse controller reading that MO cannot see what was actually
  consumed. Find which query feeds the panel; suspect a join collapse or
  a missing aggregate. Raised by Minty.
- **Return path** — P163, **P164 (inverted sign, live on both clients)**,
  P165, P168, rows 20/42/43. Budget as a survey; never read end to end.
  ⚠ `PackingSlips.js:267` and `:419` subtract `currentToDate - returnQty`
  with **no floor** — the same negative-balance exposure Minty ruled
  against in S116, on the return path. Measured S117.
- **P111** QuickBooks. Precondition met — the units write path is closed
  and promoted. One planning session, no code. Needs a new column
  (TRAPS 3).
- **P203** Neither box has ESM Apps enabled; 17 updates pending on dev,
  36 on prod. Measured S118, unchanged S119.

- **P205** PM2 differs between boxes: **dev 7.0.3, prod 7.0.1**.
  Installed GLOBALLY, outside package-lock's control, so it drifts
  independently. Both resurrected correctly through the S118 reboot.
  ⚠ package.json declares `pm2 ^5.3.0` and neither box runs 5.x.
- **P204** 3B cites queue numbers not in this file — P1(b), P3, P4, P12,
  P16, P21, P23, P28, P74, P76, P77. **Settle before ranking by number.**
- **P207** Waterline warns at every boot: null `description` on
  `companyuserrole` and `roles`, null `createdAt`/`updatedAt` on
  `company`. Old data against newer model definitions. Harmless in
  itself — but it floods the error log, and **a real error would be
  buried in it**. That is the only reason it matters. Measured S119.
- **P208** `npm install` reports **110 vulnerabilities, 33 critical**, on
  both Node 22 and 24. Unrelated to the engine. Not yet read in detail —
  `npm audit` names them. Measured S119.

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
  ⚠ Seen again S119: MO-0005 displays `4.8100000000000005 Kg` on the
  material traceability screen. Same family. Stored history, not new.

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
columns · P153 .bak in api/models · P154/P176 deploy procedure not
written down · P155 Mac push and prod origin · P156 company-id namespaces
differ · P158/P159 IP trace procedures divide · P166 field named ship_qty
holds Kg · P167 seven-copy helper · P169 transposed labels · P170
pre-JR15 MR rows read low · P171 unmapped quantity tables · P172 receipt
code not unique · P173 nameless 0.000 row · P174 form control written
into batches · P175 gate that cannot fail · P178 retention rule · P179
`formulations_myCodee` typo · P182 undocumented controls · P185 eval() on
release screen, five sites · P189 possible double-count · P190 VARCHAR
subtraction · P191 lot scanner undocumented · P192 final_qty from
`batches` (fires only on duplicate rows) · P194/P195 Kg displays, correct
under the S116 ruling

- **P200** Negative quantity accepted on the add-sales-order screen.
  `add-sales-order.component.html:84` has no `min`; `.ts:245` and `:249`
  have no `Validators.min(0)`. Fix both. Frontend — needs a build and
  deploy. ⚠ Check the sibling quantity-entry screens before closing.
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

**P202** (Node 18 survey done S119: Node 24 installs, lifts, serves 200,
and wrote a release correctly on dev. grunt 1.0.4 cleared. Node 22
install proven, lift not needed. Superseded by P202b) · P102 · P177 ·
P180 · P199 · P184 · P188 · P197 · P187 · P186 · P181 · P183 · P160 ·
P162 · P151 · P157 · P147 · P161 · P104 · P150

---

## SETTLED DECISIONS — do not re-open

- **A session opens on RULES and NOW only.** Everything else on demand.
  No dedicated documents session — a file is cleaned when next opened.
  *(Minty, S117)*
- **A reboot is its own step.** Never mid-work, never at the end of a
  long session, never both boxes at once. Dev first, standalone; prod
  only if dev resurrects cleanly. *(Proven S118.)*
- **Dev does not rehearse prod's OS.** 24.04 against 26.04. State the
  verdict out loud before relying on a dev result. *(S118, held S119.)*
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
  purpose. 18 → 24, dev runtime first (S120), builder second (S121).
  3B.4's "to match" wording stays; it gets a date and a version.
  *(Minty, S119)*

---

## ONE CORRECTION TO CARRY

Bible PART 4 records the IP4 lot ratio as `0.04478498…`. The true figure
is `41 ÷ 915.53 = 0.0447828…`. It changed no result — 1.957 either way —
but it is wrong where a future session would copy it.
