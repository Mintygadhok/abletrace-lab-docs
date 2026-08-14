# NOW — S118 close, 14 Aug 2026

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
      backend 99852bf  pm2 abletrace-dev  online ↺0  200  clean
      frontend serving 4910b46d · checkout c2a52d8e (stale, harmless)
PROD  15.157.38.101  Ubuntu 26.04 LTS    kernel 7.0.0-1010-aws  Node v18.20.8
      backend 99852bf  pm2 abletrace-backend  online ↺0  200  clean
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   frontend repo clean at 4910b46d — the only machine that edits it
```

Commits read at open, pre-reboot. **No code changed this session** —
P102 touched no repo, so the commits stand as read.

**BOTH BOXES REBOOTED, S118. P102 CLOSED after pending since S35.**
Both came back on kernel 7.0.0-1010-aws — dev jumped a generation
(6.17→7.0), prod a point release (7.0.0-1004→7.0.0-1010).

**⚠ pm2 RESURRECT IS NOW PROVEN, NOT MERELY ENABLED.** Both boxes
brought their named process back **unattended**, ↺ reset to 0,
`pm2-ubuntu.service` active. Verified on screen: dev MO-0014 reads
41# (915.53 Kg); prod, Glutenull's own login, MO-0001 reads
**1750# (560 Kg)**. P177 is closed properly.

**Databases match.** Both boxes carry `mprrecievelots.qty_allocated_units`
and JR24. Not re-measured this session — unchanged by a reboot.

**Rollback:** frontend `www-html.bak-{dev,prod}-4910b46d*` (holds
e1a82e02). Backend on prod `git reset --hard 4d43bd4`. JR24 from
`~/WhC_GetMoMaterialProductReleaseDetails_SP.bak-S116-{DEV,PROD}.txt`,
2390 bytes each — SHOW CREATE text, needs the DELIMITER wrapper.
⚠ These are S91-era values, still unverified. → P66

**Clients:** 471 Glutenull (2 MOs, round ratios) · 469 Hagensborg
(13 MOs, none run, batch_qty 1 — can never demonstrate a quantity fix).
Neither has ever created a dispatch order or released an intermediate.

**Measured after the reboot:** updates pending **17 on dev, 36 on prod**.
⚠ **Neither box has ESM Apps enabled.** Both banners say so.
Prompt colours confirmed live: dev green, prod red.

**3B'S PASS WAS NOT DONE.** S118 measured the host facts but never
opened 3B to edit it. S119 opens 3B for the Node record — **it gets its
pass then, by that session.** Carried in full at the foot of the job.

---

## PENDING PROMOTION

Nothing. Backend, frontend and database are all level across both boxes.

---

## THE NEXT JOB — S119

**P202 — Node 18 survey. DEV ONLY. NOTHING IS UPGRADED.**

**WHY IT MATTERS, IN PLAIN WORDS.** Node is the engine that runs the
app — every screen and every save passes through it. Both boxes run
Node 18, which **stopped receiving security fixes in April 2025**.
People are still finding holes in it; nobody is fixing them for you.
S118's reboot did nothing for this: those were Ubuntu's patches, and
Node arrives by a separate route. The box reports itself up to date
while the thing running two clients' data is sixteen months past its
last fix.

**WHY A SURVEY AND NOT THE UPGRADE.** AbleTrace sits on Sails, and
Sails sits on several hundred smaller packages, some untouched for
years. When the engine changes a handful stop working, and they do not
announce it — the symptom is a screen that will not load or a save that
silently does not save. Upgrading blind on a box with two live clients
is how you find that out the hard way. **This session ends with dev
running exactly as it does now, plus a costed list.**

```
ACTION — DEV ONLY. PROD IS NOT TOUCHED AT ANY POINT.

1  FIND OUT HOW NODE IS INSTALLED. Everything downstream depends on
   this answer.
   ⚠ **3B WAS READ AT THE S118 CLOSE AND DOES NOT RECORD IT.** 3B.2
     says only: "NODE v18.20.8 on BOTH boxes. ⚠ VERIFIED S79,
     `node -v`, both. CI pins Node 18 to match." Version only. This
     step is a genuine measurement, not a re-derivation.
     ▶ RECORD THE ANSWER IN 3B WHEN FOUND.
     which node
     node -v ; npm -v
     ls -d ~/.nvm 2>/dev/null || echo "no nvm"
     dpkg -l | grep -i nodejs || echo "not an apt package"
     cat /etc/apt/sources.list.d/*node* 2>/dev/null || echo "no nodesource repo"
   ⚠ Do not install anything until this is answered.

2  DONE IN S118. Do not re-run — the answer is in MATERIAL below.

3  INSTALL NODE 24 **AND** NODE 22 ALONGSIDE. DO NOT SWITCH THE
   DEFAULT.
   ⚠⚠ THE DEFAULT MUST STAY 18. If it changes, the next pm2 restart
     or reboot silently brings the app up on an untested engine —
     and S118 just proved pm2 resurrects by itself.
   ⚠ NEVER `pm2 restart` while a new Node is active in the shell.
   ⚠ **TEST BOTH. DO NOT PICK ONE ON REASONING.** 24 is Active LTS
     and the longest runway; 22 is Maintenance and the shorter hop,
     so likelier to clear grunt 1.0.4. The extra cost is minutes in
     the same scratch copy, and it replaces an argument with a
     measurement. RULES 1: state what result distinguishes the two
     answers, then get it.
       both work        → take 24. Longest support. Done.
       22 only          → 24 has a NAMED blocker; choose knowing it.
       neither          → the blocker was never the Node version.
                          That is the most valuable finding of all.

4  BUILD A SCRATCH COPY — do not test in the live dev app.
     cp -r ~/abletrace-lab-backend /home/ubuntu/node-trial
   Then, with the new Node active IN THAT SHELL ONLY, `npm install`
   fresh inside the copy. Repeat for the second version.
   ⚠ `package-lock.json` IS IN GIT (confirmed S118) — the install is
     deterministic, so the two runs are comparable.
   ⚠ NATIVE MODULES ARE COMPILED AGAINST ONE NODE VERSION and throw
     "compiled against a different Node.js version" under a new one.
     THAT IS A FALSE ALARM, NOT AN INCOMPATIBILITY — rebuild before
     judging it. **Measured S118: the declared dependencies contain
     NO native modules** — sails-mysql is pure JavaScript. So this
     risk is LOW, and it survives here only because transitive
     dependencies were not read. If it appears, it is noise.

5  LIFT IT AND WATCH.  `node app.js`  in the foreground.
   ⚠ MEASURED S118: that is EXACTLY what pm2 runs — interpreter
     `node`, script `/home/ubuntu/abletrace-lab-backend/app.js`, no
     args, no ecosystem file, **no NODE_ENV set** (pm2 reports
     N/A). There is NO wrapper to reproduce. Do not add NODE_ENV;
     it would not match what runs today.
   ⚠ It will bind 1337. Stop the pm2 process first, and restart it
     at the end. Dev has no clients; this is safe.
   Some failures land at boot. Others only on a path, so WALK THE
   PATHS: an MO, a release, traceability, one report.

6  RESTORE DEV AND PROVE IT. Node 22 out of the shell, pm2 process
   started, `sleep 8`, curl 200, one screen read.
   ⚠ Delete /home/ubuntu/node-trial at the close.

MATERIAL — quoted in, nothing to look up

  DEV   16.55.10.205 · green prompt · pm2 name abletrace-dev
        Ubuntu 24.04.4 LTS · kernel 7.0.0-1010-aws · Node v18.20.8
        backend repo ~/abletrace-lab-backend at 99852bf
  PROD  15.157.38.101 · red prompt · pm2 name abletrace-backend
        NOT TOUCHED THIS SESSION.
  ssh and scp ALWAYS from the Mac; the pem exists nowhere else.
  Every block opens with `hostname -I`.
  Backend is edited, committed and pushed ON DEV — no build step.
  After any restart: sleep 8, THEN curl.

  ⚠⚠ **BOTH BOXES MEASURED S118 — THE APPLICATION STACK MATCHES.**
    Not deduced from the commit; read from each box.
                     DEV        PROD
      Node           18.20.8    18.20.8   ✓
      npm            10.8.2     10.8.2    ✓
      **PM2          7.0.3      7.0.1     ✗ DIFFERS → P205**
      sails          1.5.8      1.5.8     ✓  (latest 1.5.x is 1.5.18)
      sails-mysql    3.0.1      3.0.1     ✓
      sails-hook-orm 4.0.2      4.0.2     ✓
      sails-hook-grunt 4.0.1    4.0.1     ✓
      grunt          1.0.4      1.0.4     ✓
      nested-pop     0.1.4      0.1.4     ✓
      backend commit 99852bf    99852bf   ✓
    ⚠ **`package-lock.json` IS IN GIT** (311 KB, 8 Jul). That is WHY
      they match — the lock pins exact versions, so `^1.5.8` did not
      drift up to 1.5.18. Declared ≠ installed: read the lock, never
      the caret.
    ▶ **CONSEQUENCE FOR THIS JOB: a dev survey DOES transfer at the
      package layer.** The OS still differs, so HOST behaviour does
      not — but that is not what this job tests.

  MEASURED S118 — do not re-derive any of this.
    Sails ^1.5.8 · sails-hook-orm ^4.0.2 · sails-mysql ^3.0.1 ·
    sails-hook-grunt ^4.0.0 · sails-hook-sockets ^3.0.0 ·
    sails-hook-responsetime ^1.0.8 · @sailshq/connect-redis ^6.1.3 ·
    @sailshq/lodash ^3.10.4 · @sailshq/socket.io-redis ^6.1.2 ·
    aws-sdk ^2.1525.0 · axios ^1.6.2 · dotenv ^17.4.2 ·
    express-rate-limit ^8.5.2 · **grunt 1.0.4 (PINNED EXACT)** ·
    jsonwebtoken ^9.0.2 · moment ^2.29.4 · moment-timezone ^0.6.0 ·
    nested-pop ^0.1.4 · node-cache ^5.1.2 · node-schedule ^2.1.0 ·
    nodemailer ^6.9.7 · pm2 ^5.3.0 · skipper-better-s3 ^2.3.0 ·
    xlsx ^0.18.5
    devDependencies: eslint 5.16.0 (PINNED) · nodemon ^3.0.2
    ⚠ **NO `engines` FIELD.** Nothing declares a Node constraint —
      npm will not block, and will not warn.
    Disk on dev: 13G free of 19G. Ample for the scratch copy.

  ROLLBACK. There is none to write, because nothing is changed. If
  dev will not come back on 18:
    pm2 start /home/ubuntu/abletrace-lab-backend/app.js --name abletrace-dev
  ⚠ **THERE IS NO ECOSYSTEM FILE** — measured S118. `pm2 resurrect`
    also works; dump.pm2 holds the definition. NOT a code rollback
    — no code changed.

ANALYSIS — already done, do not re-derive

  · **NODE LTS POSITIONS, CHECKED S118 (14 Aug 2026).** Only three
    lines are supported: **26 Current · 24 Active LTS · 22
    Maintenance LTS.** Everything else is EOL. Node 20 died 30 Apr
    2026; Node 18 died Apr 2025.
    ⚠ **DO NOT TARGET 26.** Current means library authors are still
      catching up. Production takes Active or Maintenance LTS only.
    ⚠ **AN EARLIER DRAFT OF THIS BLOCK NAMED NODE 22 AS THE TARGET.
      THAT WAS WRONG** — 22 is Maintenance, so its window closes
      soonest and the job would repeat next year. 24 is the target
      IF IT PASSES. Step 3 tests both rather than assuming.
  · The queue's old P180 line said "Node 20 deprecated". It was
    WRONG. 3B's record of v18.20.8 was RIGHT, on both boxes,
    measured S118 from the box. P180 is closed and replaced by this.
  · Dev is 24.04, prod is 26.04. **A clean dev survey is evidence
    about the packages, NOT proof about prod's OS.** Prod gets its
    own run when the real upgrade comes. Same ruling as S118.
  · **THE FOUR SUSPECTS, named S118 so S119 need not hunt them:**
    **grunt, pinned at exactly 1.0.4** (2018, no caret, so npm
    cannot drift it forward — the likeliest break, and
    sails-hook-grunt depends on it) · **eslint 5.16.0** (2019, but
    devDependency only, so it CANNOT affect the running app) ·
    **aws-sdk v2** (itself end-of-life; runs, but unsupported) ·
    **nested-pop 0.1.4** (unmaintained, and already TRAPS'd from
    S55 — two COLLECTION associations in one populate array).
    Sails 1.5.8 itself is current enough not to be the problem.
  · ⚠ **RULES §4 SAYS dotenvx. package.json SAYS `dotenv` ^17.4.2.**
    One of them is wrong. Settle it while the file is open — the
    credentials record must not be wrong about how secrets load.
  · ⚠⚠ **NODE 18 LIVES IN THREE PLACES, NOT TWO.** 3B.4 records the
    GitHub Actions frontend build as pinning **Node 18 "to match"**
    the boxes (runner ~7 GB, NODE_OPTIONS=--max-old-space-size=4096,
    ~9 min, artifact dist-<target>-<full 40-char sha>). The Angular
    build engine is INDEPENDENT of the app's runtime, so this does
    NOT block the backend upgrade — but the record's stated intent
    was parity. Decide it deliberately; do not discover it later.
  · **SETTLED S118: IT IS `dotenv`, NOT `dotenvx`.** package.json
    declares `dotenv ^17.4.2`, and 3B.3's own dev-database recipe
    describes dotenv printing its "◇ injected env" banner. **RULES
    §4 and 3B.8 both carry the wrong name** — one propagated from
    the other. Correct both. It changes no command; it makes the
    credentials record true.
  · Native-module ABI errors are noise, and now look unlikely.
    See step 4.
  · The survey is one session. The upgrade is one more if clean,
    two or three if not. That range is honest and unnarrowable
    until step 5 runs.

VERIFY

  A written list: which packages break, which need replacing, which
  have no maintained version. Plus dev back on Node 18, pm2
  abletrace-dev online, 200, and one screen read on the browser.
  ⚠ NOTHING IS DONE UNTIL IT IS SEEN ON THE SCREEN.
```

**While 3B is open for the Node record, it gets its pass** — no
separate job, per S117's ruling. **3B was read at the S118 close, so
these are named exactly, not left as a search:**
- **3B.2 CONTRADICTS ITSELF ON THE REBOOT, and S118 settled it.** The
  OS block warns "rebooting dev does NOT rehearse rebooting prod" —
  then four lines later the restart-required note says "⚠ DO DEV
  FIRST — it is a true twin, so it is a real rehearsal." **Delete the
  second.** Dev-first is right for a different reason: dev is the box
  with no clients.
- **3B.2 kernel lines are stale.** Records prod 7.0.0-1004 / dev
  6.17.0-1017. Both boxes are now **7.0.0-1010-aws** (S118). OS
  versions unchanged: prod 26.04, dev 24.04.4.
- **Delete the whole "SYSTEM RESTART REQUIRED — PENDING SINCE S35"
  note.** Done S118, both boxes.
- **Record that pm2 resurrect is PROVEN**, both boxes, S118 —
  unattended, ↺ reset to 0. 3B currently only says to verify it.
- **Add the Node install method** once step 1 measures it, and date
  the v18.20.8 line to S118.
- **3B.8 says dotenvx; it is dotenv.** See ANALYSIS above.
- **3B.4's rollback points read `www-html.bak-{prod,dev}-275c025039d7`
  (S91).** Both boxes are now at **4910b46d**. → P66
- **3B.2 calls the reboot P21; NOW called it P102.** One job, two
  numbers. Note which survives — Minty's call.
- ⚠ **3B.4 step 4 says Cmd+Q the browser; RULES §2 says Shift+Cmd+R
  (Minty's ruling, S106).** RULES is later and is the authority.
  Reconcile 3B to it or record why both exist.
- Strip incident language. Session numbers, "cost 40 minutes in S71",
  "old Section A said X" — the facts survive without the stories.
- Delete the build-history header and the ROUTING RECORD. Both describe
  a 2026 reorganisation and say nothing about the system.

---

## QUEUE — Minty ranks. New items at the bottom, never renumbered.

**Top candidates**

- **P202** Node 18 is end of life. → THE NEXT JOB, above.
- **Return path** — P163, **P164 (inverted sign, live on both clients)**,
  P165, P168, rows 20/42/43. Budget as a survey; never read end to end.
  ⚠ `PackingSlips.js:267` and `:419` subtract `currentToDate - returnQty`
  with **no floor** — the same negative-balance exposure Minty ruled
  against in S116, on the return path. Measured S117.
- **P111** QuickBooks. Precondition met — the units write path is closed
  and promoted. One planning session, no code. Needs a new column
  (TRAPS 3).
- **P203** Neither box has ESM Apps enabled; 17 updates pending on dev,
  36 on prod. Measured S118 after the reboot.

- **P205** PM2 differs between boxes: **dev 7.0.3, prod 7.0.1**.
  Measured S118. PM2 is installed GLOBALLY, outside package-lock's
  control, so it drifts independently of every other version — it is
  the one unmatched item in an otherwise identical stack. Both
  resurrected correctly through the S118 reboot, so the behaviour
  that matters is proven. Low, but it is the layer that keeps the
  app alive. ⚠ package.json declares `pm2 ^5.3.0` and neither box
  runs 5.x — the app's copy is not what runs.
- **P204** 3B cites queue numbers that are not in this file — P1(b),
  P3, P4, P12, P16, P21, P23, P28, P74, P76, P77. Either two
  numbering schemes are live or NOW's queue has lost entries. Found
  S118 while reading 3B. **Settle before ranking anything by number.**

**Units campaign leftovers** — board 38 green of 51, a deliberate stop.
⚠ The Bible is **frozen as an archive at S117**. It describes the app as
of the campaign's close and is consulted per row, not read at the open.

- **Rows 37-41** unblocked; the column is populated. Row 41 is cheapest
  and most visible — release details shows Kg with no unit count.
  ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
- **P196** two intermediate blocks disagree by 0.011 Kg (0.004 on the
  IP4 fixture). Display only. Re-seen S117 on MO-0016 and MO-0017.
- **P135** two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
- **P198** `formulations.inventory` (the Kg line) carries float tails.
  ⚠ Measured S117: the Kg line has **no floor and no rounding** — only
  `inventory_units` gets `Math.round` and `Math.max(0,…)`. Low.

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
into batches · P175 gate that cannot fail · P178 retention rule *(run
S117, both boxes at three generations)* · P179 `formulations_myCodee`
typo · P182 undocumented controls · P185 eval() on release screen, five
sites · P189 possible double-count · P190 VARCHAR subtraction · P191 lot
scanner undocumented · P192 final_qty from `batches` (fires only on
duplicate rows) · P194/P195 Kg displays, correct under the S116 ruling

- **P200** Negative quantity accepted on the add-sales-order screen.
  `add-sales-order.component.html:84` has no `min`; `.ts:245` and `:249`
  have no `Validators.min(0)`. A negative unit count multiplies cleanly
  through `:256` and banks a negative Kg plan at `soproducts.quantity`.
  Fix both. Frontend — needs a build and deploy.
  ⚠ Check the sibling quantity-entry screens before calling it done.
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

**P102** (both boxes rebooted S118, verified on prod through Glutenull's
own login) · **P177** (pm2 resurrect proven through a real reboot, both
boxes, S118 — it was only ever recorded as enabled) · **P180** (the
queue line was wrong and 3B was right: both boxes run Node v18.20.8.
Superseded by P202) · P199 · P184 · P188 · P197 · P187 · P186 · P181 ·
P183 · P160 · P162 · P151 · P157 · P147 · P161 · P104 · P150

---

## SETTLED DECISIONS — do not re-open

- **A session opens on RULES and NOW only.** Everything else on demand.
  No dedicated documents session — a file is cleaned when next opened.
  *(Minty, S117)*
- **A reboot is its own step.** Never mid-work, never at the end of a
  long session, never both boxes at once. Dev first, standalone; prod
  only if dev resurrects cleanly. *(Proven S118.)*
- **Dev does not rehearse prod's OS.** 24.04 against 26.04. State the
  verdict out loud before relying on a dev result. *(S118.)*
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

---

## ONE CORRECTION TO CARRY

Bible PART 4 records the IP4 lot ratio as `0.04478498…`. The true figure
is `41 ÷ 915.53 = 0.0447828…`. It changed no result — 1.957 either way —
but it is wrong where a future session would copy it.
