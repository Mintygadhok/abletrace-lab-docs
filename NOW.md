NOW — S122 close, 16 Aug 2026
State, next job, queue. Nothing else.

⚠⚠ A SESSION OPENS ON TWO FILES: RULES AND THIS ONE. (Minty, S117) Everything else is consulted ON DEMAND, when the work touches it: BUSINESS LOGIC (Bible Part 1) · 3B infrastructure · 3A the app · Section 5 / JR the database record · TRAPS (ELEVEN entries — see the ruling below). ▶ NO DEDICATED TIDY-UP SESSION. A document is cleaned when it is next opened, by the session that opens it. (Minty, S117)

What does not go here: lessons, narrative, retrospectives, proof write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment beside the code. If it fits none of those it goes nowhere.

STATE — ⚠ BOTH BOXES MEASURED S122. PROD READ FOR THE FIRST TIME IN FOUR
SESSIONS. Nothing below is carried forward from an older session.

DEV   16.55.10.205 (private 172.31.1.196)  Ubuntu 24.04.4 LTS
      Node v24.19.0 · npm 11.17.0 · pm2 7.0.3 · kernel 7.0.0-1010-aws
      backend 99852bf  pm2 abletrace-dev  online  ↺0  200
      frontend serving 9523b913 · checkout c2a52d8e (stale, harmless)
      ⚠ ?? node_modules.old-node18/ — the 303 MB Node-18 rollback tree.
        ▶ STILL PRESENT. Dev has now run clean through a reboot, a
        build, a deploy and two write tests. DELETE AT THE S123 CLOSE
        IF DEV IS STILL CLEAN — Minty's call, deferred from S122.

PROD  15.157.38.101 (private 172.31.3.156)  Ubuntu 26.04 LTS
      Node v18.20.8 · npm 10.8.2 · pm2 7.0.1 · kernel 7.0.0-1010-aws
      backend 99852bf  pm2 abletrace-backend  online  ↺0  200
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
      both trees CLEAN, nothing untracked
      ⚠⚠ **PROD IS STILL ON NODE 18. THE RUNTIMES DIFFER.** → P210

MAC   /Users/mintym1/abletrace-lab-frontend  HEAD 9523b913, clean
      Docs repo /Users/mintym1/abletrace-lab-docs at c1c396e
      ⚠ Three untracked .bak files STILL in the docs repo:
        Section_5.md.bak-S115-20260811-161932
        UNITS-BIBLE.txt.bak-S110
        UNITS-BIBLE.txt.bak-S115-20260811-161932
        Untracked — deleting them touches no history. → P211

⚠ THE KERNELS NOW READ THE SAME STRING ON BOTH BOXES: 7.0.0-1010-aws.
  Measured, not inferred. Dev's was UNCHANGED by the S120 reboot — that
  reboot cleared a library restart flag, not a kernel. 3B.2's line
  (prod 1004 / dev 6.17.0-1017) is stale on both counts. → P211
⚠ THE HOSTS STILL DO NOT TRANSFER. 24.04 against 26.04. Same kernel
  string is not the same OS. The S118 ruling stands.

DEV DATA — UNCHANGED SINCE THE S121 CLOSE. No writes were made in S122.

Ginger Powder, lot Mat-260804-3
  SOH                                  7619.322 Kg
  Qty Released                         2370.678 Kg
  Qty Received / Misc Release          10000 / 10.000
MO-0014 material release rows          6 (916.471, 10, 100, 200, 50, 100)
MO-0014 planned & completed            41# (915.53 Kg) — the fixture
Header ties: 10000 − 2370.678 − 10 = 7619.322. No float tail.

PENDING PROMOTION
Nothing in code. ⚠ THE BUILDER MAKES PROD'S FRONTEND ON NODE 20 — prod's
next deliberate deploy uses it. Nothing reaches prod until Minty dispatches.

PROD'S ROLLBACK POINTS — READ OFF THE BOX S122. ▶ THIS CLOSES P66.
  /home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
  /home/ubuntu/www-html.bak-prod-e1a82e028903ec317399de1bf2dc8be14a2f1030
  /home/ubuntu/www-html.bak-prod-2968c59142dc9144e2f6f0fb9925bcdf43f9e1a1
  /home/ubuntu/www-html.bak-prod-e8e8f5724cdfb9dc0734daabf5b10ae5d91ce8d4
  /home/ubuntu/www-html.bak-prod-bc03b22dc375ba51bd81b18ffb4299b36aa34ab8
⚠ The lists DIVERGE from dev's, correctly. Dev's fifth is 8bbf2c30; prod's
  is bc03b22d. Do not copy one box's list onto the other.
⚠⚠ THE BACKUP-NAME TRAP STILL APPLIES (P219). The backup is NAMED for the
  build being deployed and CONTAINS the build being replaced.
  ▶ BUT RULES' OPEN BLOCK IS STILL CORRECT. It reads the newest backup's
    NAME to learn what is live, which is exactly what the name is true
    about. The trap is about CONTENTS. RULES needs no change. (S122)

P213 — CLOSED S122. THE ROTATION WAS NOT NEEDED. Do not re-derive.

VERDICT: THE LEAKED GITHUB TOKEN WAS ALREADY DEAD. HTTP/2 401.

  Fingerprints, measured S122 (sha256, first 12 — the tokens themselves
  never reached the screen):
    fd24c9618394  40 chars  THE WORKING TOKEN
    061cec73339d            THE LEAKED TOKEN — dead, 401

  ⚠⚠ **THE WORKING TOKEN IS ONE CREDENTIAL IN TWO PLACES.** The Mac
    keychain entry and dev's backend remote URL hold the SAME string.
    RULES §4 lists them as two separate bullets and reads as two
    credentials. IT IS ONE. → P220
  ⚠ It is a 40-character CLASSIC PAT, in plaintext inside dev's backend
    remote URL. Never exposed. Not rotated — see the ruling below.
  ⚠ The leaked token lived ONLY in the old dead clone
    ~/abletrace-lab/abletrace-frontend. Nothing used it.
  ⚠ THE GITLAB TOKEN ON THAT CLONE WAS NOT MEASURED AND MAY STILL BE
    LIVE. Minty ruled S122: the old application is being dismantled, do
    not spend time on its credentials. Costs nothing to revoke in
    GitLab's UI whenever convenient. P214's sanitized snapshot removes
    the copy either way.

▶ MINTY RULED S122: NO ROTATION OF THE WORKING TOKEN. It was never
  exposed. Rotating it means updating two places in one pass with a real
  chance of locking out a push, and that is not what P213 was raised for.

⚠ e3b0c44298fc IS THE SHA-256 OF EMPTY INPUT. If a fingerprint command
  ever returns it, the extraction FAILED — it is not a match. S122 saw it
  once, from a mis-paste.

TRAPS — RULED S122. THE FILE STAYS AT ELEVEN ENTRIES.

⚠⚠ **THE DRAFTED "TRAPS 11" WAS NEVER TRAPS 11. ENTRY 11 IS TAKEN.**
  TRAPS.md line 210 is `11 · PM2 REPORTS "online" WHILE THE APP IS DEAD
  ON THE PORT`, written at S119. Writing the needrestart draft in as 11
  would have overwritten a real entry. Caught before the write, S122.

▶ MINTY RULED S122: **NO TRAPS 12.** The house rule holds — TRAPS rule 2
  says if it can be FIXED it is a queue item, not a trap. needrestart can
  be configured. The hazard becomes a MANDATORY STEP INSIDE P210 instead.
  ▶ RULES' "TRAPS.md … Eleven entries" IS THEREFORE CORRECT. No edit.
  ▶ Every "TRAPS 11" reference meaning needrestart is now corrected: it
    is P210's pre-upgrade gate. No such trap exists.

THE NEXT JOB — S123
P212 — CLAUDE PROJECT WORKSPACE. ⚠⚠ 3B IS HELD BACK FROM THE UPLOAD.

⚠⚠ THE ROAD, RE-RULED BY MINTY AT THE S122 CLOSE. THIS REVERSES THE
  S121 ORDER OF P211 AND P212.
  S123  P212 — set up the project. Upload everything EXCEPT 3B.
  S124  P211 — clean 3B, using the project method.
  S125  Add the clean 3B to the project.
        ── dev has run on Node 24 since 14 Aug; the week is satisfied ──
  S126+ P210 — PROD to Node 24. Own session, nothing else in it.

▶ WHY THE ORDER FLIPPED. The S121 road put P211 first on one line: a
  stale 3B uploaded is stale AND searchable. That is a rule about 3B
  ALONE, not about the whole project, and files upload individually. The
  dependency actually runs the OTHER WAY — P212's own block says 3B kept
  being deferred BECAUSE opening it cost a paste. Setting up the project
  makes P211 cheaper; doing P211 first makes nothing cheaper. S122 spent
  its second half on paste mechanics against a 785-line file and proved
  the point. (Minty, S122.)
▶ THE CAUTION IS KEPT, NOT DISCARDED. 3B does not go into the project
  until it is clean. That is the whole of what the original warning
  protected.

ACTION
 1 OPEN CHECK on dev only. Prod was fully read S122 and is quoted above;
   a second read costs a session for nothing.
 2 ONE project, "AbleTrace". Not several — the work crosses backend,
   frontend, database and infrastructure constantly.
 3 RULES → the INSTRUCTIONS field. ⚠ If it overflows the cap, put RULES
   in KNOWLEDGE and instruct "read RULES.md in full at the open."
 4 KNOWLEDGE, in this order: 3A · Section 5/JR · TRAPS · Bible Part 1 ·
   Bible archive · NOW.
   ⚠⚠ **3B IS NOT UPLOADED. S125 ADDS IT, AFTER P211.**
   ⚠ Section 5/JR is NOT IN GIT.
 5 ADD TWO RULES LINES: (a) the git repo is the arbiter, project
   knowledge is a MIRROR; (b) to §6 CLOSE, replace NOW in project
   knowledge. ⚠ RULES edits need Minty's approval — propose, do not add.
 6 Test it: ask for something that lives only in 3A or TRAPS.

⚠ MEMORY IS PER-PROJECT AND ISOLATED. A one-time transition cost, paid
  once, and paid sooner is paid cheaper.
⚠ WHAT IT DOES NOT FIX. The close still has to be written — the
  expensive part. NOW is still rewritten whole. Estimated gain 10–20%.

VERIFY: the project exists, RULES loads into every chat, a question
answerable only from 3A or TRAPS is answered from KNOWLEDGE without a
paste, and 3B is confirmed ABSENT from the knowledge base.

THE MATERIAL — EVERY 3B CORRECTION, QUOTED IN FULL

NEW FROM S122 — the Node record 3B is supposed to carry, now complete:
  DEV   Node v24.19.0 · npm 11.17.0 · pm2 7.0.3 · kernel 7.0.0-1010-aws
        /usr/bin/node · apt nodejs 24.19.0-1nodesource1 · repo node_24.x
        no nvm · rollback file /home/ubuntu/nodesource.list.bak-S120
  PROD  Node v18.20.8 · npm 10.8.2 · pm2 7.0.1 · kernel 7.0.0-1010-aws
        apt nodejs 18.20.8-1nodesource1 · repo deb.nodesource.com/node_18.x
        ⚠ PINNED AT 600 against Ubuntu's own 22.22.1 at 500 — the pin is
        why apt has never pulled a newer Node on its own.
  ▶ **PROD'S INSTALL METHOD IS NODESOURCE, THE SAME AS DEV'S.** This was
    P210's biggest unknown and it is now answered: the route transfers.
  CI    builder Node 20 (Angular 18 caps there — S121)

3B.4 — THE "TO MATCH" SENTENCE MUST BE REWRITTEN. Replacement, verbatim:
  *CI pins Node to the highest the toolchain accepts. 18 → 20, S121.
   Angular 18 caps at Node 20; the runtime is on 24. The gap is
   deliberate and closes only when Angular is upgraded (P217).*

3B.4 — ROLLBACK POINTS. It currently reads …-275c025039d7 (S91). Replace
  with BOTH lists as quoted in the STATE block above. ▶ CLOSES P66.
3B.4 — step 4 says Cmd+Q the browser; RULES §2 says Shift+Cmd+R (S106).
  RULES IS THE AUTHORITY. ⚠ promote.sh's LAST ECHO LINE SAYS Cmd+Q TOO.
  Fix both. promote.sh is at /Users/mintym1/promote.sh.

3B.2 — CONTRADICTS ITSELF ON THE REBOOT. It warns "rebooting dev does NOT
  rehearse rebooting prod", then says "it is a true twin, a real
  rehearsal." DELETE THE SECOND. Dev-first is right because dev has no
  clients, not because it is a twin.
3B.2 — kernel lines stale (prod 7.0.0-1004 / dev 6.17.0-1017). Both boxes
  now read 7.0.0-1010-aws, measured S122.
3B.2 — DELETE "SYSTEM RESTART REQUIRED — PENDING SINCE S35". Done S118.
3B.2 — calls the reboot P21; NOW called it P102. Minty's call which wins.
3B.8 — says dotenvx; it is dotenv ^17.4.2. RULES §4 already corrected.

ADD TO 3B — things that existed in NO document until S121/S122:
  MAC FRONTEND REPO   /Users/mintym1/abletrace-lab-frontend
  DEV PRIVATE ADDRESS 172.31.1.196, beside the public 16.55.10.205
  PROD PRIVATE ADDRESS 172.31.3.156, beside the public 15.157.38.101
  THE ssh COMMAND     ssh -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
                      (prod: ubuntu@15.157.38.101) — read OUT OF
                      promote.sh, not guessed. ~/.ssh/config has NO host
                      entry for either box.
  THE CI PIN          .github/workflows/build-frontend.yml line 27
                      NODE_OPTIONS=--max-old-space-size=4096 at line 40
  THE DEPLOY          ~/promote.sh <artifact.zip> <dev|prod>
                      → scp to box → ssh → ./deploy-frontend.sh <label>
                      promote.sh REFUSES a dev bundle on prod and demands
                      a typed "yes" for prod. Label = target + first 12
                      of the sha. ▶ THIS CLOSES P154/P176.
  THE BACKUP-NAME TRAP  deploy-frontend.sh names the backup for the build
                      being DEPLOYED but it contains the build being
                      REPLACED. Record it as a note in 3B.4, NOT as a
                      TRAPS entry. → P219

STRIP FROM 3B — incident language, the build-history header, the ROUTING
  RECORD. Carried since S119.

VERIFY: 3B carries a true Node, npm, pm2 and kernel record for BOTH boxes;
the deploy procedure and the ssh command are in it; 3B.2 no longer
contradicts itself; nothing in 3B contradicts NOW or RULES; the three .bak
strays are gone; commit pushed.
⚠ P204 rides along IF THERE IS ROOM — 3B cites queue numbers not in this
  file (P1(b), P3, P4, P12, P16, P21, P23, P28, P74, P76, P77). Settle
  them with 3B open. Drop it if the session thins.

THE JOB AFTER — S124. P211 — 3B's PASS. Owed since S118.
⚠ The TRAPS half is DONE — Minty ruled S122 that the needrestart hazard
is a P210 step, not a twelfth trap. ONLY 3B REMAINS.

⚠ THE PASS OPENS ON A DOCUMENT, NOT A BOX. Every fact it needs was
  measured in S122 and is quoted in THE MATERIAL below. RE-MEASURE
  NOTHING. Do not re-read prod.

MEASURED S122 — THE SHAPE OF THE FILE. Do not re-derive this either.
  785 lines, eleven blocks. Headers and line numbers:
    1 header · 11 3B.1 THE PICTURE · 43 3B.2 THE BOXES (104 SSH,
    131 PROMPT COLOURS) · 145 3B.3 THE DATABASES (180 two databases,
    198 ACCESS, 227 REBUILD, 245 PRE-UPGRADE RECORD) · 259 3B.4 THE
    PIPELINE (279 THE FLOW, 324 BACKEND DEPLOY, 339 ROLLBACK) ·
    367 3B.5 HEALTH CHECK (371 session check, 391 host check) ·
    411 3B.6 DOMAINS/DNS/SSL (433 SSL, 453 THE FUTURE MOVE) ·
    480 3B.7 SERVICES · 538 3B.8 CREDENTIALS · 587 3B.9 REPOS (609 what
    is in git) · 635 3B.10 THE OLD APP · 678 3B.11 WHEN IT BREAKS
    (730 shell traps) · 757 ROUTING RECORD
  ▶ THE FOUR RANGES THE PASS NEEDS: 43-144 · 259-366 · 538-586 · 757-785.
    Read them in ONE block, not four.

⚠⚠ **A FINDING ALREADY MADE, S122 — THE "TRUE TWIN" LINE IS AT LINE 30,
  IN 3B.1, NOT IN 3B.2.** The carried note said 3B.2. It is in the
  PICTURE block at the top of the file, which is the part a reader
  trusts first: `DEV  dev.mintekfoodsafety.com  NEW account  true twin
  of prod`. Prod is Ubuntu 26.04 with two live clients; dev is 24.04.
  ⚠ CHECK 3B.2 FOR A SECOND COPY. The original note may not be wrong,
    only incomplete.

ACTION
 1 Read the four ranges in one block.
 2 Apply every correction in THE MATERIAL below as ONE patch script,
   written to /tmp, run separately, asserts anchored. Never inline.
 3 Delete the three untracked .bak strays from the docs repo.
 4 Diff, commit, push. Two or three sentences.
 5 S125 then uploads the clean 3B to the project.

QUEUE — Minty ranks. New items at the bottom, never renumbered.
Top candidates

P212 Claude project workspace. → THE NEXT JOB, above. ⚠⚠ 3B IS HELD BACK FROM THE UPLOAD until P211 lands at S124; S125 adds it. Everything else goes up at S123. (Minty, S122 — this REVERSES the S121 order.)
P211 3B's pass. → THE JOB AFTER, above. Owed since S118. ⚠ The TRAPS half is DONE — Minty ruled S122 that the needrestart hazard is a P210 step, not a twelfth trap. Only 3B remains. All material is quoted into the job block, including the file's full header map and the four line ranges to read; the pass opens on a document, not a box.
P210 PROD TO NODE 24. Prod still on 18, unpatched since April 2025. ⚠ Prod is Ubuntu 26.04; dev is 24.04. The host does not transfer. ▶ INSTALL METHOD MEASURED S122 — NodeSource node_18.x, pinned 600. THE DEV ROUTE TRANSFERS: change the repo line to node_24.x, apt update, apt install -y nodejs. APT REPLACES, IT DOES NOT ADD.
  ⚠⚠ **MANDATORY PRE-UPGRADE GATE — MINTY'S RULING, S122.** needrestart WILL restart pm2 mid-upgrade. apt's needrestart sees the pm2 service linked to the Node binary it has just replaced and runs `systemctl restart pm2-ubuntu.service`, whose job is `pm2 resurrect`. A deliberately stopped app therefore comes back UNATTENDED, on the new engine, against the OLD node_modules, pointed at the live database. Nothing announces it — pm2 reads `online` with ↺0 as though all were well. Measured S120 on dev. On prod that is Glutenull and Hagensborg back up without instruction.
  ▶ THE RUNBOOK MUST DO ALL THREE, IN ORDER:
    1 PREVENT — set needrestart to never restart services before the repo line is touched, and PROVE the setting is in force before proceeding.
    2 VERIFY — read `pm2 status` IMMEDIATELY after `apt install nodejs`, before anything else, every time, whether or not step 1 appeared to work.
    3 STOP AGAIN — if it resurrected, stop the app before reinstalling node_modules. Never reinstall packages under a running app.
  ⚠ This is a STEP IN the runbook, not a warning at the end of it. It is not a TRAPS entry precisely because it CAN be prevented — TRAPS rule 2. Own session, nothing else in it.
P217 ANGULAR 18 → 20. ⚠ THIS IS THE ONLY THING THAT UNBLOCKS A BUILDER ON NODE 24. Angular 18 caps at Node 20; Angular 20 supports ^20.19.0 || ^22.12.0 || ^24.0.0. A framework major on a live client app — multiple sessions, own risk, own gate. Not a Node job. Raised and NOT taken at S121; Minty chose the documented gap instead.
P206 MO material release panel shows ONE release per material, not each distinct release. MO-0014 traceability lists SIX Ginger Powder releases (916.471, 10, 100, 200, 50, 100 Kg); the MO's own panel shows a single row of 916.471 — and is not summing them either. PRE-EXISTING, re-confirmed S120 and S121. ⚠ A warehouse controller reading that MO cannot see what was actually consumed. Suspect a join collapse or a missing aggregate. Raised by Minty.
Return path — P163, P164 (inverted sign, live on both clients), P165, P168, rows 20/42/43. Budget as a survey; never read end to end. ⚠ PackingSlips.js:267 and :419 subtract currentToDate - returnQty with no floor — the same negative-balance exposure Minty ruled against in S116, on the return path. Measured S117.
P111 QuickBooks. Precondition met. One planning session, no code. Needs a new column (TRAPS 3).
P203 Neither box has ESM Apps enabled; 17 updates pending on dev, 36 on prod. Measured S118.
P205 PM2 differs: dev 7.0.3, prod 7.0.1 — re-confirmed S122. Installed GLOBALLY, outside package-lock, so it drifts independently and P210 will NOT fix it. ⚠ package.json declares pm2 ^5.3.0 and neither box runs 5.x. ⚠ npm differs too (11.17.0 / 10.8.2) but that is Node's bundled npm and closes itself with P210.
P204 3B cites queue numbers not in this file — P1(b), P3, P4, P12, P16, P21, P23, P28, P74, P76, P77. Settle inside P211, with 3B open, if there is room.
P207 Waterline warns at every boot: null description on companyuserrole and roles, null createdAt/updatedAt on company. Harmless in itself — but it floods the error log and a real error would be buried in it. Measured S119.
P208 npm install reports 110 vulnerabilities, 33 critical, unchanged under Node 24 and npm 11. Not yet read in detail — npm audit names them.
P214 OLD REPO ~/abletrace-lab/abletrace-frontend. HEAD cb07d7b8, GitLab-era, superseded. ⚠ Its GitHub token is DEAD (401, measured S122). ⚠ Its GITLAB token was NOT measured and may still be live — Minty ruled S122 not to spend time on the dismantled app's credentials; revoke in GitLab's UI whenever convenient, it is free. ▶ NO LONGER REQUIRED — KEEP ONE SANITIZED HISTORICAL SNAPSHOT, THEN DELETE. Sanitized = strip the remotes BEFORE snapshotting.
P215 promote.sh IS NOT IN VERSION CONTROL. It lives at /Users/mintym1/promote.sh, outside any repo, on one machine, with no backup. deploy-frontend.sh is likewise only on the boxes. These two scripts ARE the deploy procedure. ⚠ Losing the Mac loses the promote path. Decide where they live.
P216 GitHub Actions v4 are deprecated. checkout@v4, setup-node@v4, upload-artifact@v4 run on GitHub's Node 20 action runtime, which is being retired — the warning on every run. Bump to @v5. ⚠ NOT related to node-version: '20'; different thing entirely. Cheap.
P218 OVER-RELEASE IS ACCEPTED SILENTLY AGAINST AN MO REQUIREMENT. MO-0014 requires 916.471 Kg of Ginger Powder; the release screen reads 1016.471/916.471 Kg and the app took it without complaint. ⚠ NOT a wrong row — the S106 clamshell ruling says a release figure is the true record of what was picked. ⚠ The question is whether it should WARN. Business question, Minty's, not a defect until he says so.
P219 deploy-frontend.sh BACKUP NAMING. The backup is named for the build being deployed but contains the build being replaced. www-html.bak-dev-9523b9131a86 holds 4910b46d. ⚠ Restoring by name restores the wrong build. ▶ Record as a note in 3B.4 during P211 — NOT a TRAPS entry. Also: promote.sh truncates the sha to 12 chars while older backups carry the full 40.

New from S122

P220 RULES §4 LISTS ONE CREDENTIAL AS TWO. The Mac keychain PAT and the PAT embedded in dev's backend remote are the SAME token (fingerprint fd24c9618394, measured S122). §4 has them as separate bullets under ON THE MAC and ELSEWHERE, which reads as two credentials and would send a future rotation looking for a second token that does not exist. ⚠ A RULES edit, so Minty's approval first. Cheap — two lines.

Units campaign leftovers — board 38 green of 51, a deliberate stop. ⚠ The Bible is frozen as an archive at S117. Consulted per row.

Rows 37-41 unblocked; the column is populated. Row 41 is cheapest and most visible — release details shows Kg with no unit count. ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
P196 two intermediate blocks disagree by 0.011 Kg (0.004 on the IP4 fixture). Display only.
P135 two divisions left in Trace_ProductHeaderView. Retires TRAPS 10.
P198 formulations.inventory (the Kg line) carries float tails. ⚠ No floor and no rounding — only inventory_units gets Math.round and Math.max(0,…). Low.

Open, unranked

P8 prod frontend checkout lags · P17 two old IAM keys live · P20/P22 delete old section files · P64 product label prints "null" · P65 promote.sh no -4 · P84/P85 printer guides · P86 cold boot untested · P88 dead "Fix A" pointers · P90 two false claims in 3A · P94 stray heal file on prod · P101/P109 dormant archive holds its own procedures · P106 old map file · P108 review J-entries · P114 closed vs in-progress MOs · P115 delete dead code (below) · P116/P117 file-read handling · P118 comment deliberate code (working — keep) · P119 db definitions stale on ten objects · P120 material barcode · P121-P123 client guide gaps · P124 SO status compares units to Kg, live · P129 food safety toggle has no attribute · P130 Excel exports unchecked · P131 unit count with weight label · P132 dead status columns · P133 do_status never advances · P134 schema naming · P136 view returns duplicates · P137 MR numbering global · P138 soproducts has no unit count ⚠ and no company_id · P139 not defects · P142 MR buttons commented out · P145/P146 MR screen quirks · P148 narrow residual · P152 read-rows drops columns · P153 .bak in api/models · P155 Mac push and prod origin · P156 company-id namespaces differ · P158/P159 IP trace procedures divide · P166 field named ship_qty holds Kg · P167 seven-copy helper · P169 transposed labels · P170 pre-JR15 MR rows read low · P171 unmapped quantity tables · P172 receipt code not unique · P173 nameless 0.000 row · P174 form control written into batches · P175 gate that cannot fail · P178 retention rule · P179 formulations_myCodee typo · P182 undocumented controls · P185 eval() on release screen, five sites · P189 possible double-count · P190 VARCHAR subtraction · P191 lot scanner undocumented · P192 final_qty from batches · P194/P195 Kg displays, correct under the S116 ruling

P200 Negative quantity accepted on the add-sales-order screen. add-sales-order.component.html:84 has no min; .ts:245 and :249 have no Validators.min(0). Frontend: needs a build and deploy, which is now a known 20-minute path.
P201 Acrobatics at add-sales-order.component.ts:393. (quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit) — batch_qty cancels, so it divides a weight to make a unit count. ⚠ Reachability unmeasured.
P115 dead code: rejected-materials.ts:152-154 · MLOManagement.js getMLCbyId/V2 · PopUps/add-dispatch v1 · edit-mlc.ts:311,227 · MaterialsProductsReleased.js:52 and :83-98 · material-traceability-details.html:113-125, 191-216 · Traceability.js @returnedQty/@mprIDs

CLOSED — delete these lines at the next close
P213 (the leaked GitHub token was already dead — 401 measured S122; it lived only in the old clone and nothing used it; the working token was never exposed and Minty ruled against rotating it) · P66 (rollback points now read off BOTH boxes and quoted into this file) · P209 · P154/P176 · P202b · P202 · P102 · P177 · P180 · P199 · P184 · P188 · P197 · P187 · P186 · P181 · P183 · P160 · P162 · P151 · P157 · P147 · P161 · P104 · P150

SETTLED DECISIONS — do not re-open
A session opens on RULES and NOW only. Everything else on demand. No dedicated documents session — a file is cleaned when next opened. (Minty, S117)
A reboot is its own step. Never mid-work, never both boxes at once. Dev first, standalone. (Proven S118, S120.)
Dev does not rehearse prod's OS. 24.04 against 26.04. State the verdict out loud before relying on a dev result. (S118, held S119–S122. ⚠ Both boxes now report kernel 7.0.0-1010-aws — this does NOT soften the ruling.)
Dev runs on a new engine for a while before prod is asked to. (Minty, S120.)
⚠⚠ THE CI PARITY RULING IS SUPERSEDED. Angular 18 CAPS AT NODE 20, so parity with a Node 24 runtime is unreachable without a framework upgrade. MINTY RULED OPTION A: builder to 20, documented gap, Angular upgrade queued as P217 and not taken. The gap is deliberate. (Minty, S121.)
TRAPS STAYS AT ELEVEN. A hazard that can be configured away is a queue item, not a trap — TRAPS' own rule 2. The needrestart hazard is a mandatory STEP inside P210, not a twelfth entry. (Minty, S122.)
THE WORKING GITHUB PAT IS NOT ROTATED. It was never exposed. The leaked one was already dead. (Minty, S122.)
The old GitLab-era application is being dismantled. Do not spend time repairing or rotating its credentials. (Minty, S121 and S122.)
THE ROAD IS P212 → P211 → 3B INTO THE PROJECT → P210. The project is set up FIRST, with 3B held back; 3B is cleaned using the new method and added after. This REVERSES the S121 order, because setting up the project makes the 3B pass cheaper while the reverse buys nothing, and the only thing the original caution protected — a stale 3B being searchable — is preserved by holding that one file back. (Minty, S122.)
Release input stays kilograms. The unit count is derived once at the write, rounded to three decimals, and the same figure is banked in the row and subtracted from stock. (Minty, S116)
~0.001 variance on a multi-release lot is accepted. SOH is reconciled against physical count monthly. The cumulative fix was offered and rejected on domain grounds. (Minty, S116)
Stock must never go negative. Math.max(0,…) on both branches.
Return path goes last. (Minty, S112)
Materials are Kg only; anything carrying a formula_id carries units. (Minty, S112 — Bible Part 1 §5)
Traceability reports what was released at the time. (Minty, S112)

ONE CORRECTION TO CARRY
Bible PART 4 records the IP4 lot ratio as 0.04478498…. The true figure is 41 ÷ 915.53 = 0.0447828…. It changed no result — 1.957 either way — but it is wrong where a future session would copy it.
