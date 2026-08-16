NOW — S121 close, 15 Aug 2026
State, next job, queue. Nothing else.

⚠⚠ A SESSION OPENS ON TWO FILES: RULES AND THIS ONE. (Minty, S117) Everything else is consulted ON DEMAND, when the work touches it: BUSINESS LOGIC (Bible Part 1) · 3B infrastructure · 3A the app · Section 5 / JR the database record · TRAPS (10, an 11th drafted below). ▶ NO DEDICATED TIDY-UP SESSION. A document is cleaned when it is next opened, by the session that opens it. (Minty, S117)

What does not go here: lessons, narrative, retrospectives, proof write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment beside the code. If it fits none of those it goes nowhere.

STATE
DEV   16.55.10.205 (private 172.31.1.196)  Ubuntu 24.04.4 LTS
      Node v24.19.0 at /usr/bin/node · npm 11.17.0 · pm2 7.0.3
      backend 99852bf  pm2 abletrace-dev  online  ↺0  200
      frontend serving 9523b913 · checkout c2a52d8e (stale, harmless)
      ⚠ ?? node_modules.old-node18/ — the 303 MB Node-18 rollback tree.
        DO NOT INVESTIGATE, COMMIT OR DELETE. ▶ Delete at the close of
        S122 if dev has been stable — Minty's call.
PROD  15.157.38.101  Ubuntu 26.04 LTS
      ⚠⚠ NOT READ THIS SESSION OR THE LAST THREE. Values below are S118's.
      ⚠⚠ **PROD IS STILL ON NODE 18.** The boxes DIFFER. → P210
      backend 99852bf  pm2 abletrace-backend
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   /Users/mintym1/abletrace-lab-frontend — MEASURED S121, was in no
      document. Clean, HEAD 9523b913, remote clean (no embedded token).
      Docs repo /Users/mintym1/abletrace-lab-docs at 83bea64.
      ⚠ Three untracked .bak files in the docs repo: Section_5.md.bak-S115,
        UNITS-BIBLE.txt.bak-S110, UNITS-BIBLE.txt.bak-S115. → P211
⚠ KERNEL AFTER THE S120 REBOOT STILL NOT MEASURED. Was 7.0.0-1010-aws. → 3B

⚠ DEV DATA CHANGED AGAIN — a real 100 Kg release was made as the write test.

Ginger Powder, lot Mat-260804-3        S120 close    NOW
  SOH                                  7719.322 Kg   7619.322 Kg
  Qty Released                         2270.678 Kg   2370.678 Kg
  Qty Received / Misc Release          10000 / 10.000  unchanged
MO-0014 material release rows          5             6 (916.471, 10, 100, 200, 50, 100)
MO-0014 planned & completed            41# (915.53 Kg) — UNCHANGED, still the fixture
Header ties: 10000 − 2370.678 − 10 = 7619.322. No float tail.

PENDING PROMOTION
Nothing in code. The frontend commit 9523b913 changes only the CI workflow —
it is not in any bundle. ⚠ BUT THE BUILDER NOW MAKES PROD'S FRONTEND ON
NODE 20. Prod's next deliberate deploy uses it. Nothing reaches prod until
Minty dispatches.

P209 — WHAT WAS DONE. Measured S121, do not re-derive.
VERDICT: THE BUILDER RUNS NODE 20, NOT 24. ANGULAR CAPPED IT.
         BUILD GREEN, DEPLOYED TO DEV, PROVEN ON SCREEN INCLUDING A WRITE.

⚠⚠ **THE FINDING OF THE SESSION — 24 WAS NEVER REACHABLE.**
  @angular/core and @angular/cli are ^18.2.12. Angular 18 supports Node
  18 and 20 only; Node 24 first appears at Angular 20. AND the app's own
  package.json declares engines { "node": "^20" } — a hard cap at 20.x.
  ▶ THE OLD PIN OF 18 WAS ALREADY VIOLATING THE APP'S OWN engines FIELD.
    npm only warns, so it built anyway. Nobody knew. Fixed by this job.
  ▶ MINTY RULED OPTION A at the box: builder to 20, documented gap to the
    runtime's 24. The alternative — upgrade Angular first — is queued as
    P217 and was NOT taken.
  ⚠⚠ **THE PARITY RULING (S119, re-confirmed S120) IS NOW BROKEN ON
    PURPOSE.** It was made before anyone knew Angular capped at 20. That
    is new measurement, not a re-derivation. Builder 20 · dev runtime 24 ·
    prod runtime 18. 3B.4's "to match" wording must now read:
      *CI pins Node to the highest the toolchain accepts. 18 → 20, S121.
       Angular 18 caps at Node 20; the runtime is on 24. The gap is
       deliberate and closes only when Angular is upgraded (P217).*

THE ROUTE THAT WAS TAKEN, in order:
  1 read the pin, the Angular version and the engines block  ← the decider
  2 sed line 27 '18' → '20' and the step label, on the MAC
  3 one commit 9523b913, git add by named file
  4 push → CI ran green → artifact dist-dev-9523b913…
  5 cleared Downloads BEFORE downloading (RULES §5)
  6 read deploy-frontend.sh and dev's rollback points off the box
  7 ~/promote.sh dist-dev-….zip dev
  8 Shift+Cmd+R, three screens, plus a 100 Kg write

MEASURED ON THE CI RUN:
  build            GREEN
  artifact         dist-dev-9523b9131a867877e0a20043c06cace1242059ac
  zip size         15,116,935 bytes — BYTE-IDENTICAL to the old
                   dist-dev-4910b46d zip. Same source, different engine,
                   same size out. Strong evidence of an equivalent build.
  1 warning        "Node.js 20 is deprecated" — this is GITHUB complaining
                   about ITS OWN ACTIONS' runtime (checkout/setup-node/
                   upload-artifact are @v4, written in Node 20). It has
                   NOTHING to do with node-version: '20'. → P216

THE ON-SCREEN PROOF (RULES §1 — nothing is done until it is seen):
  MO-0014 · Pdt-260811-1 · IP4 · 41# (915.53 Kg) plan and completed ✓
  Material-traceability-details · Release-mat-details · Manage-Materials
  all rendered clean. No blank panels, no broken lazy chunks.
  Write test: 100 Kg release landed SOH at exactly 7619.322 Kg.

THINGS THAT EXISTED IN NO DOCUMENT AND NOW DO — carry these to 3B (P211)
  MAC FRONTEND REPO   /Users/mintym1/abletrace-lab-frontend
  THE ssh COMMAND     ssh -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
                      (prod: ubuntu@15.157.38.101) — read OUT OF promote.sh,
                      not guessed. ~/.ssh/config has NO host entry.
  THE PIN             .github/workflows/build-frontend.yml line 27
                      NODE_OPTIONS=--max-old-space-size=4096 at line 40
  THE DEPLOY          ~/promote.sh <artifact.zip> <dev|prod>
                      → scp to box → ssh → ./deploy-frontend.sh <label>
                      promote.sh REFUSES a dev bundle on prod and demands a
                      typed "yes" for prod. Label = target + first 12 of sha.
                      ▶ THIS CLOSES P154/P176.
  DEV ROLLBACK POINTS www-html.bak-dev-{4910b46d…, e1a82e02…, 2968c591…,
                      8bbf2c30…, e8e8f572…} and now dev-9523b9131a86.
                      ▶ CLOSES P66 FOR DEV. PROD'S ARE STILL UNREAD.

⚠⚠ **THE BACKUP-NAME TRAP — NEW, AND IT WILL BITE SOMEONE.**
  deploy-frontend.sh names the backup for the build being DEPLOYED, but it
  contains the build being REPLACED. www-html.bak-dev-9523b9131a86 HOLDS
  4910b46d. Restoring "the 9523b913 backup" restores the build before it.
  ▶ TRAPS CANDIDATE — Minty rules at S122.

⚠ **WHAT THIS DOES NOT PROVE.** The builder is not the runtime. This says
  nothing about prod's host, and gets no free ride from S120's proof.
THE NEXT JOB — S122
PART 1 — GITHUB PAT ROTATION. PART 2 — P211. IN THAT ORDER. (Minty, S121)

⚠⚠ THE ROAD, RE-RULED BY MINTY AT THE S121 CLOSE.
  S122  PAT rotation (P213), then P211 — 3B pass + TRAPS 11
  S123  P212 — Claude project workspace
        ── dev runs a week on Node 24 ──
  S124+ P210 — PROD to Node 24
▶ WHY THE ROTATION JUMPED THE QUEUE. It did not exist when the S120 road
  was ruled. A live credential outranks a documentation pass.
▶ WHY IT COMES BEFORE P211, NOT AFTER. P211 is a paste-heavy job and will
  eat the session. A half-done rotation locks Minty out of his own repo.

PART 1 — P213, THE ROTATION

⚠⚠ **A LIVE GITHUB PAT AND A LIVE GITLAB PAT WERE PRINTED TO THE CHAT AT
  S121.** `git remote -v` on ~/abletrace-lab/abletrace-frontend (the old
  superseded clone) printed both in full. Treat both as EXPOSED since
  15 Aug ~18:00. Minty accepted the exposure for the length of P209 so the
  push would not break mid-job. That was a deliberate trade.

WHAT IS ALREADY KNOWN, MEASURED S121 — DO NOT RE-MEASURE:
  · The MAC'S LIVE FRONTEND REPO IS CLEAN. remote has no embedded token.
    NOTHING TO DO THERE.
  · The Mac authenticates from the KEYCHAIN. A github.com internet-password
    entry exists in /Users/mintym1/Library/Keychains/login.keychain-db.
  · The leaked GitHub token is embedded in the OLD clone's `github` remote.
  · The leaked GitLab token is on that same clone's `origin`. GitLab is
    dead here — REVOKING IT COSTS NOTHING.

THE THREE TOUCH POINTS TO CHECK (RULES §4 names them):
  1  Dev's BACKEND remote — RULES §4 says a PAT is embedded in it.
       git -C ~/abletrace-lab-backend remote -v | sed -E 's#//[^@]*@#//REDACTED@#'
  2  The Mac keychain entry.
  3  Minty's Drive note (the record).
⚠⚠ **ESTABLISH WHETHER THEY ARE THE SAME TOKEN STRING BEFORE REVOKING
  ANYTHING.** If the leaked token IS dev's backend token, revoking without
  updating dev first breaks backend pushes from the box.
⚠ ALWAYS PIPE remote -v THROUGH THE sed REDACTION. S121's mistake.

ACTION
  0  OPEN CHECK, dev. Then ⚠ **A READ-ONLY PASS ON PROD** — see PART 2,
     it is needed there and doubles as P210's survey.
  1  Read the three touch points. Compare token strings.
  2  Revoke the GitLab token in GitLab's UI. Free, do it first.
  3  Issue a new GitHub PAT. Update every place that holds the old one, in
     one pass. Verify a push from the Mac AND from dev's backend.
  4  ⚠ **THE OLD REPO ~/abletrace-lab/abletrace-frontend — MINTY RULED
     S121: NO LONGER REQUIRED. KEEP ONE SANITIZED HISTORICAL SNAPSHOT,
     THEN DELETE.** Sanitized = remotes stripped before the snapshot is
     made. HEAD cb07d7b8, GitLab-era. → P214
  5  Only then revoke the old GitHub token.

PART 2 — P211. 3B'S PASS + TRAPS 11. Owed since S118.

⚠ **OPEN ON PROD FIRST — THREE FACTS 3B NEEDS ARE UNMEASURED.** Read-only,
  five minutes, and P210 needs them anyway:
    node -v · npm -v · pm2 -v · uname -r
    ls -1dt /home/ubuntu/www-html.bak-* | head -5
    apt-cache policy nodejs
  ⚠ AND dev's kernel, still unmeasured since the S120 reboot: uname -r

VERIFY: 3B carries a true Node record for BOTH boxes, TRAPS has 11 entries,
and nothing in either file contradicts NOW or RULES.

NEW FROM S121 — all measured, all listed above under "THINGS THAT EXISTED
IN NO DOCUMENT": the Mac repo path, the ssh command, the pin's file and
line, the deploy procedure both halves, dev's rollback points, the
backup-name trap, the Angular/Node ceiling, promote.sh living outside
version control (→ P215), the three stray .bak files in the docs repo.
⚠ 3B.4's "to match" sentence MUST be rewritten — the replacement wording is
  quoted verbatim in the P209 block above.

NEW FROM S120, still owed:
  THE NODE RECORD. Dev: /usr/bin/node, apt nodejs 24.19.0-1nodesource1,
  repo node_24.x, npm 11.17.0, no nvm. Rollback file at
  /home/ubuntu/nodesource.list.bak-S120. PROD UNMEASURED AND STILL ON 18.
  THE ROUTE for P210: change the repo line, apt update, apt install -y
  nodejs. APT REPLACES, IT DOES NOT ADD.
  needrestart restarts pm2 — cross-reference TRAPS 11.
  npm 11 blocks install scripts by default. core-js@2.6.12 only, a no-op,
  do not approve.
  pm2-ubuntu.service at /etc/systemd/system/, enabled, runs pm2 resurrect.
  Two tarball folders at /home/ubuntu/node-v2*-linux-x64 — deletable.

CARRIED FROM S119, still owed:
  3B.2 CONTRADICTS ITSELF ON THE REBOOT. Warns "rebooting dev does NOT
  rehearse rebooting prod", then says "it is a true twin, a real rehearsal."
  Delete the second. Dev-first is right because dev has no clients.
  3B.2 kernel lines stale (prod 7.0.0-1004 / dev 6.17.0-1017).
  Delete "SYSTEM RESTART REQUIRED — PENDING SINCE S35". Done S118.
  3B.8 says dotenvx; it is dotenv. RULES §4 already corrected.
  3B.4's rollback points read …-275c025039d7 (S91). → P66
  3B.2 calls the reboot P21; NOW called it P102. Minty's call.
  ⚠ 3B.4 step 4 says Cmd+Q the browser; RULES §2 says Shift+Cmd+R (S106).
    RULES is the authority. ⚠ promote.sh's LAST ECHO LINE SAYS Cmd+Q TOO —
    same stale instruction, in a script. Fix both.
  Add dev's private address 172.31.1.196 beside the public one.
  Strip incident language. Delete the build-history header and ROUTING RECORD.
TRAPS 11 — DRAFTED AND APPROVED BY MINTY, S120. STILL TO BE WRITTEN INTO TRAPS.md.
Carried in full so it cannot be lost. S122 applies it.

apt install nodejs RESTARTS pm2 AND THE APP COMES BACK UNATTENDED.

apt's needrestart sees the pm2 service linked to the Node binary it has
just replaced and runs `systemctl restart pm2-ubuntu.service`. That
service's job is `pm2 resurrect`, which restores whatever dump.pm2 holds.
A deliberately stopped app therefore restarts MID-UPGRADE, on the new
engine, against the OLD node_modules, pointed at the live database.
Nothing announces it — pm2 reads `online` with ↺0 as though all were well.
Measured S120, dev. On prod this is two clients' app coming back up
without instruction.
▶ AFTER `apt install nodejs`, READ `pm2 status` BEFORE ANYTHING ELSE.
  Stop the app again before reinstalling packages.

RULES CHANGE — APPROVED BY MINTY, S121. APPLY AT S122.
`node -v` is ADDED to the OPEN block. The boxes now run three different
engines across two runtimes and a builder; the check could not see it.
Costs one line of output. A patch script was produced at the S121 close.
▶ No other RULES line is proposed. The backup-name trap is a TRAPS
  candidate. The missing paths were MATERIAL gaps and are now filled.
THE JOB AFTER — S123. P212 — CLAUDE PROJECT WORKSPACE.
Unchanged from the S120 close. A Claude Project has an INSTRUCTIONS field
loaded into every chat and a searchable KNOWLEDGE base, removing the two
large pastes at every open. RULES and NOW are ~35K characters and RULES §6
names large pastes as the thing that shortens a session.

⚠ WHAT IT DOES NOT FIX. The close still has to be written — the expensive
part. NOW is still rewritten whole. Estimated gain 10–20% on a session.
▶ The larger win is quality: 3B kept being deferred partly because opening
  it cost a paste. Searchable, it stops being deferred.

ACTION
 1 ONE project, "AbleTrace". Not several — the work crosses backend,
   frontend, database and infrastructure constantly.
 2 RULES → the INSTRUCTIONS field. ⚠ If it overflows the cap, put RULES in
   KNOWLEDGE and instruct "read RULES.md in full at the open."
 3 KNOWLEDGE, in this order: 3A · 3B · Section 5/JR · TRAPS · Bible Part 1 ·
   Bible archive · NOW. ⚠ Section 5/JR is NOT IN GIT.
 4 ADD TWO RULES LINES: (a) the git repo is the arbiter, project knowledge
   is a MIRROR; (b) to §6 CLOSE, replace NOW in project knowledge.
 5 Test it: ask for something that lives only in 3B.

⚠ MEMORY IS PER-PROJECT AND ISOLATED. A one-time transition cost.
⚠ Do NOT upload before P211. A stale 3B uploaded is stale AND searchable.
QUEUE — Minty ranks. New items at the bottom, never renumbered.
Top candidates

P213 GITHUB PAT ROTATION. → S122 PART 1, above. ⚠ A live GitHub PAT and a live GitLab PAT were exposed to chat at S121. The Mac's live frontend repo is CLEAN and needs nothing. Three touch points to check: dev's backend remote, the Mac keychain, Minty's Drive note. ⚠⚠ Compare token strings BEFORE revoking — if the leaked token is dev's backend token, revoking first breaks pushes from the box. GitLab token is free to revoke immediately.
P211 3B's pass + TRAPS 11. → S122 PART 2, above. Owed since S118. ⚠ Opens with a READ-ONLY PASS ON PROD — node/npm/pm2/kernel/rollback points/apt policy are all unmeasured and 3B is supposed to carry them. Doubles as P210's survey.
P212 Claude project workspace. → THE JOB AFTER, above. ⚠ Not before P211.
P210 PROD TO NODE 24. Prod still on 18, unpatched since April 2025. ⚠ NOT BEFORE DEV HAS RUN ON 24 FOR AT LEAST A WEEK. ⚠ Prod is Ubuntu 26.04; dev is 24.04. The host does not transfer. ⚠ PROD'S INSTALL METHOD IS UNMEASURED. ⚠⚠ needrestart WILL RESTART THE APP MID-UPGRADE — TRAPS 11. On prod that is Glutenull and Hagensborg coming back up unattended. A STEP in the runbook, not a warning at the end of it. Own session, nothing else in it.
P217 ANGULAR 18 → 20. ⚠ THIS IS THE ONLY THING THAT UNBLOCKS A BUILDER ON NODE 24. Angular 18 caps at Node 20; Angular 20 supports ^20.19.0 || ^22.12.0 || ^24.0.0. A framework major on a live client app — multiple sessions, own risk, own gate. Not a Node job. Raised and NOT taken at S121; Minty chose the documented gap instead.
P206 MO material release panel shows ONE release per material, not each distinct release. MO-0014 traceability now lists SIX Ginger Powder releases (916.471, 10, 100, 200, 50, 100 Kg); the MO's own panel shows a single row of 916.471 — and is not summing them either. PRE-EXISTING, re-confirmed S120 and again S121 after the Node 20 build. ⚠ A warehouse controller reading that MO cannot see what was actually consumed. Suspect a join collapse or a missing aggregate. Raised by Minty.
Return path — P163, P164 (inverted sign, live on both clients), P165, P168, rows 20/42/43. Budget as a survey; never read end to end. ⚠ PackingSlips.js:267 and :419 subtract currentToDate - returnQty with no floor — the same negative-balance exposure Minty ruled against in S116, on the return path. Measured S117.
P111 QuickBooks. Precondition met. One planning session, no code. Needs a new column (TRAPS 3).
P203 Neither box has ESM Apps enabled; 17 updates pending on dev, 36 on prod. Measured S118.
P205 PM2 differs: dev 7.0.3, prod 7.0.1. Installed GLOBALLY, outside package-lock, so it drifts independently. ⚠ package.json declares pm2 ^5.3.0 and neither box runs 5.x.
P204 3B cites queue numbers not in this file — P1(b), P3, P4, P12, P16, P21, P23, P28, P74, P76, P77. Settle inside P211, with 3B open.
P207 Waterline warns at every boot: null description on companyuserrole and roles, null createdAt/updatedAt on company. Harmless in itself — but it floods the error log and a real error would be buried in it. Measured S119.
P208 npm install reports 110 vulnerabilities, 33 critical, unchanged under Node 24 and npm 11. Not yet read in detail — npm audit names them.
New from S121

P214 OLD REPO ~/abletrace-lab/abletrace-frontend. ⚠ HOLDS TWO LIVE TOKENS in its remotes. HEAD cb07d7b8, GitLab-era, superseded. ▶ MINTY RULED S121: NO LONGER REQUIRED — KEEP ONE SANITIZED HISTORICAL SNAPSHOT, THEN DELETE. Sanitized = strip the remotes BEFORE snapshotting. Do this inside P213.
P215 promote.sh IS NOT IN VERSION CONTROL. It lives at /Users/mintym1/promote.sh, outside any repo, on one machine, with no backup. deploy-frontend.sh is likewise only on the boxes. These two scripts ARE the deploy procedure. ⚠ Losing the Mac loses the promote path. Decide where they live.
P216 GitHub Actions v4 are deprecated. checkout@v4, setup-node@v4, upload-artifact@v4 run on GitHub's Node 20 action runtime, which is being retired — the warning on every run. Bump to @v5. ⚠ NOT related to node-version: '20'; different thing entirely. Cheap.
P218 OVER-RELEASE IS ACCEPTED SILENTLY AGAINST AN MO REQUIREMENT. MO-0014 requires 916.471 Kg of Ginger Powder; the release screen now reads 1016.471/916.471 Kg and the app took it without complaint. ⚠ NOT a wrong row — the S106 clamshell ruling says a release figure is the true record of what was picked. ⚠ The question is whether it should WARN. Business question, Minty's, not a defect until he says so.
P219 deploy-frontend.sh BACKUP NAMING. The backup is named for the build being deployed but contains the build being replaced. www-html.bak-dev-9523b9131a86 holds 4910b46d. ⚠ Restoring by name restores the wrong build. ▶ TRAPS CANDIDATE — Minty rules at S122. Also: promote.sh truncates the sha to 12 chars while older backups carry the full 40.
Units campaign leftovers — board 38 green of 51, a deliberate stop. ⚠ The Bible is frozen as an archive at S117. Consulted per row.

Rows 37-41 unblocked; the column is populated. Row 41 is cheapest and most visible — release details shows Kg with no unit count. ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
P196 two intermediate blocks disagree by 0.011 Kg (0.004 on the IP4 fixture). Display only.
P135 two divisions left in Trace_ProductHeaderView. Retires TRAPS 10.
P198 formulations.inventory (the Kg line) carries float tails. ⚠ No floor and no rounding — only inventory_units gets Math.round and Math.max(0,…). Low.
Open, unranked

P8 prod frontend checkout lags · P17 two old IAM keys live · P20/P22 delete old section files · P64 product label prints "null" · P65 promote.sh no -4 · P66 stale rollback points — DEV NOW READ (S121), PROD STILL UNREAD · P84/P85 printer guides · P86 cold boot untested · P88 dead "Fix A" pointers · P90 two false claims in 3A · P94 stray heal file on prod · P101/P109 dormant archive holds its own procedures · P106 old map file · P108 review J-entries · P114 closed vs in-progress MOs · P115 delete dead code (below) · P116/P117 file-read handling · P118 comment deliberate code (working — keep) · P119 db definitions stale on ten objects · P120 material barcode · P121-P123 client guide gaps · P124 SO status compares units to Kg, live · P129 food safety toggle has no attribute · P130 Excel exports unchecked · P131 unit count with weight label · P132 dead status columns · P133 do_status never advances · P134 schema naming · P136 view returns duplicates · P137 MR numbering global · P138 soproducts has no unit count ⚠ and no company_id · P139 not defects · P142 MR buttons commented out · P145/P146 MR screen quirks · P148 narrow residual · P152 read-rows drops columns · P153 .bak in api/models · P155 Mac push and prod origin · P156 company-id namespaces differ · P158/P159 IP trace procedures divide · P166 field named ship_qty holds Kg · P167 seven-copy helper · P169 transposed labels · P170 pre-JR15 MR rows read low · P171 unmapped quantity tables · P172 receipt code not unique · P173 nameless 0.000 row · P174 form control written into batches · P175 gate that cannot fail · P178 retention rule · P179 formulations_myCodee typo · P182 undocumented controls · P185 eval() on release screen, five sites · P189 possible double-count · P190 VARCHAR subtraction · P191 lot scanner undocumented · P192 final_qty from batches · P194/P195 Kg displays, correct under the S116 ruling

P200 Negative quantity accepted on the add-sales-order screen. add-sales-order.component.html:84 has no min; .ts:245 and :249 have no Validators.min(0). ⚠ NOT bolted onto S121 — the session went to the Angular finding instead. Frontend: needs a build and deploy, which is now a known 20-minute path.
P201 Acrobatics at add-sales-order.component.ts:393. (quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit) — batch_qty cancels, so it divides a weight to make a unit count. ⚠ Reachability unmeasured.
P115 dead code: rejected-materials.ts:152-154 · MLOManagement.js getMLCbyId/V2 · PopUps/add-dispatch v1 · edit-mlc.ts:311,227 · MaterialsProductsReleased.js:52 and :83-98 · material-traceability-details.html:113-125, 191-216 · Traceability.js @returnedQty/@mprIDs

CLOSED — delete these lines at the next close
P209 (builder moved 18 → 20, not 24 — Angular 18 caps there; CI green, deployed to dev, MO-0014 proven at 41# (915.53 Kg) on screen, 100 Kg write landed at exactly 7619.322 Kg) · P154/P176 (the deploy procedure is written down — promote.sh and deploy-frontend.sh, both read in full at S121) · P202b · P202 · P102 · P177 · P180 · P199 · P184 · P188 · P197 · P187 · P186 · P181 · P183 · P160 · P162 · P151 · P157 · P147 · P161 · P104 · P150

SETTLED DECISIONS — do not re-open
A session opens on RULES and NOW only. Everything else on demand. No dedicated documents session — a file is cleaned when next opened. (Minty, S117)
A reboot is its own step. Never mid-work, never both boxes at once. Dev first, standalone. (Proven S118, S120.)
Dev does not rehearse prod's OS. 24.04 against 26.04. State the verdict out loud before relying on a dev result. (S118, held S119, S120, S121.)
Dev runs on a new engine for a while before prod is asked to. (Minty, S120.)
⚠⚠ THE CI PARITY RULING IS SUPERSEDED. S119/S120 ruled that the builder matches the boxes on purpose. S121 measured that Angular 18 CAPS AT NODE 20, so parity with a Node 24 runtime is unreachable without a framework upgrade. MINTY RULED OPTION A: builder to 20, documented gap, Angular upgrade queued as P217 and not taken. The gap is deliberate. (Minty, S121 — this replaces the S119/S120 wording.)
THE ROAD IS PAT ROTATION → P211 → P212 → week → P210. (Minty, S121 — supersedes the S120 ordering, because the rotation did not exist when that road was ruled.)
Release input stays kilograms. The unit count is derived once at the write, rounded to three decimals, and the same figure is banked in the row and subtracted from stock. (Minty, S116)
~0.001 variance on a multi-release lot is accepted. SOH is reconciled against physical count monthly. The cumulative fix was offered and rejected on domain grounds. (Minty, S116)
Stock must never go negative. Math.max(0,…) on both branches.
Return path goes last. (Minty, S112)
Materials are Kg only; anything carrying a formula_id carries units. (Minty, S112 — Bible Part 1 §5)
Traceability reports what was released at the time. (Minty, S112)
The old GitLab-era frontend clone is no longer required. One sanitized historical snapshot, then delete. (Minty, S121)
ONE CORRECTION TO CARRY
Bible PART 4 records the IP4 lot ratio as 0.04478498…. The true figure is 41 ÷ 915.53 = 0.0447828…. It changed no result — 1.957 either way — but it is wrong where a future session would copy it.
