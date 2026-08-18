# NOW

Written at the S126 close. Rewritten whole — see RULES 6.

---

## STATE

What no command returns. Everything measurable is in the open check.

| | |
|---|---|
| prod's frontend git checkout lags the served build | by design. P8. Read the live build off the newest `www-html.bak-*` name |
| prod on Node 18, dev on Node 24 | dev runs a new engine for a while before prod is asked to. → P210 |
| CI builder on Node 20 | Angular 18 caps at 20, so parity is unreachable. Documented gap, S121. → P217 |

**Dev's backend tree is not clean, deliberately.** `git status` on dev's backend shows `?? node_modules.old-node18/` — the 303 MB Node-18 rollback tree sits *inside* the repo as an untracked directory, not beside it. Nothing depends on it. This is the concrete reason RULES §2 forbids `git add .`. Delete on the next visit to dev. → P227

**Dev's ssh is fragile.** Dev's security group allows inbound 22 from **one IPv4 /32**, so the Mac drifting onto IPv6 locks you out of dev while prod still connects — that asymmetry is the tell. Always `ssh -4`; plain `curl ifconfig.me` reports a phantom address, only `curl -4 ifconfig.me` gives the real source. Cost a session at S73. → P224

**The old AWS account is being wound down.** Minty's decision, S126. Both live apps verified working after the teardown.

---

## THE JOB — S127

### Move SES to the new AWS account

**One job. Nothing else in the session.**

S126's dependency sweep proved this is the **only** thing the live app takes from the old account. Everything below is measured, not assumed. Do not re-derive it.

### What the sweep established

**S3 is clean.** Every bucket reference on dev and prod is `abletrace-lab-fileuploads` — the new account's bucket. `abletrace-fileuploads1` appears nowhere in code.

**No old-account identifier is hardcoded anywhere.** `350466202408`, `ILD4K76I` and `H7IPS3W7` returned nothing across dev, prod and the Mac frontend.

**DNS is clean for both deployed builds.** `angular.json` replaces `environment.ts` in all three build configurations, so the file naming `devapiw.abletrace.ca` never reaches an artifact — it is the local `ng serve` default only. `environment.prod.ts` points at `trace.mintekfoodsafety.com` (GoDaddy). `environment.dev.ts` holds no `abletrace.ca` reference. Only `environment.stage.ts` uses the old zone, and staging is dead.

**`.env` parity is clean.** Both boxes carry the same nine variables. Dev has `IS_DEV_BOX` extra — the bootstrap dev-safety guard, expected.

### The dependency, precisely

Not "the account" — two things:

1. **`SMTP_USER` holds a raw AKIA key ID** belonging to the old account's `ses` IAM user. Confirmed present in `.env` on **both** boxes.
2. **`abletrace.ca` is a verified sending domain in the old account.** `fromEmail: 'info@abletrace.ca'` is what the app sends as.

### The material — measured S126, quoted in

**The credential path is env-only. No code edit needed for the swap.**

```
config/env/local.js:3-4        smtpUser: process.env.SMTP_USER
config/env/development.js:8-9  smtpPassword: process.env.SMTP_PASSWORD
config/env/staging.js:3-4      ← same pair
config/env/production.js:32-33 ← same pair
```

`email.js` reads `sails.config.smtpUser` / `sails.config.smtpPassword`, which those four files map from `process.env`. **So P231 changes `.env` on two boxes and nothing else.**

**`fromEmail` is hardcoded**, not env-driven:

```
local.js:5 · development.js:10 · staging.js:5 · production.js:34
    fromEmail: 'info@abletrace.ca'
```

There is a `FROM_EMAIL` variable in `.env` that **nothing reads**. If the sending address ever changes, that is a code edit in four files.

**⚠ Two corrections to Section 3B.7, measured S126:**

1. **It is not `SES.sendEmail()`.** The live path is nodemailer wrapping the SES transport — `nodemailer.createTransport({SES})` then `transporter.sendMail(...)`. The direct SES call is commented out. Still SES, but 3B records the wrong call shape.
2. **The error swallow is worse than 3B says.** The live code is:

```
.then(doc => { return true; })
.catch(err => { return false; })
```

Those returns go into a floating promise nothing awaits. The caller gets no value either way and the error object is discarded unlogged. **A failed send is invisible to the app, the logs and the user.** → P240

`email.js` also hardcodes `region: 'ca-central-1'` — same region in both accounts, so not a blocker.

**The old account's SES is in production mode (50k/day). The new account's status is UNMEASURED.** Production access is per-account and granted by AWS support review, not instantly. **If the new account is in sandbox, that request is the long pole and must be filed first.** Measure with:

```
aws sesv2 get-account --query "ProductionAccessEnabled"
```

### The action

1. Measure the new account's SES production-access status. If sandbox, file the request **before** anything else.
2. Verify `abletrace.ca` as a sending domain in the new account. Publish the DKIM records into the existing Route 53 zone — **the zone can stay in the old account for this**; it does not need moving first.
3. Create a new IAM user and access key in the new account, scoped to SES send only.
4. Generate straight into a file, never to screen, never into chat. Swap `SMTP_USER` and `SMTP_PASSWORD` in `.env` on dev, then prod. Rotation method is RULES §4 / 3B.8 — `cp .env` to a dated backup first, Python rewrite not `sed`, never `nano`.
5. `pm2 restart <NAME> --update-env`, `sleep 8`, curl 200.
6. Dev first, prove it, then prod.

### The verify

**An invite email arriving in an inbox.** Not a 200, not a clean deploy, not an absence of errors in the log — the error path returns nothing and logs nothing, so only receipt proves it. Send one on dev, then one on prod, and confirm both landed.

### Then

Deactivate the old account's `ses` IAM key — deactivate, not delete, so it is reversible in one click. That closes the second half of **P17**.

---

## OLD ACCOUNT — where the teardown stands

**Done at S126.** Deleted: RDS `newinstance` (with final snapshot), EC2 `devapi_windows` and `stgapi_windows`, three Elastic IPs (`3.97.172.190`, `3.98.110.30`, `52.60.108.220`), and the two Route 53 A records that pointed at the released addresses. About **$215 of a $256/month forecast** removed. Both live apps verified working afterwards.

**Why the bill jumped in August.** RDS for MySQL 8.0 reached end of standard support on **31 July 2026**. From 1 August AWS auto-enrols any 8.0 instance into paid **Extended Support**, billed per vCPU-hour. `newinstance` was 8.0.45 on a 2-vCPU `db.t3.micro`: July $0.83/day → August $5.47/day, a delta of $4.64/day = **$0.097 per vCPU-hour**, the published year-1 rate. Not a leak — a deadline.

⚠ **Prod's own database escaped this by one month** — upgraded to 8.4 on 1 July. **Dev's instance in the new account is unmeasured.** If `abletrace-lab-dev-s62-dev` is still on 8.0 it has been paying the same surcharge since 1 August, in the account you actually use. → P235

⚠ **The final snapshot of `newinstance` is the only copy of two years of departed-client traceability data.** Do not sweep it in a later tidy-up. Restoring it after 1 August puts that instance back on Extended Support pricing, so any restore is a short deliberate exercise.

**Still standing, and why:** the old app's EC2 box + Elastic IP `3.98.223.126` (→ P233) · SES (→ P231, the S127 job) · the Route 53 zone, which holds the live Zoho mail records (→ P232) · CloudFront marketing site (→ P234) · old bucket `abletrace-fileuploads1` (→ P236).

**The two legacy clients are gone.** Section 3B.10 states they are still live on the old app. That is now false and it removes the blocker on closing the account.

**Minty's test, S126, governs the whole programme:** *if I were to shut the old AWS account, nothing of my current new AWS account or nothing of my current new app should be impacted.* After S127 that will be true of the application. The Route 53 zone will still be outstanding — it fails no app test, but closing the account without moving it kills `info@abletrace.ca`.

---

## SECTION 3B — decided, not yet executed

**Verdict: replace whole. Do not retire.** Minty's call pending; Claude's recommendation, on evidence.

All twelve blocks read at S126 — the file has **twelve**, not eleven, and is 828 lines. Six blocks carry facts that would each cost a session to relearn, three of which could take down the app, the client's mail, or the database. 3B.5 is the only genuinely dead block, and it is dead because RULES absorbed it.

**Contradictions the file carries against itself** — the argument that patching it does not work:

1. 3B.8 says dev's frontend remote is clean (measured S122); 3B.9 fifty lines later says the PAT is in **both** remote URLs.
2. 3B.8 says `dotenv`, corrected S124; 3B.11 still says `dotenvx`.
3. 3B.5 records dev on kernel 6.17.0 vs prod 7.0.0; both banners now read **7.0.0-1010-aws**. Only the distros differ.
4. 3B.7's SES call shape is wrong, and its error-swallow note understates the defect. Measured S126 — see THE JOB.

**The rewrite cannot be written without reading 3B.1, 3B.2 and 3B.4** — ~290 lines never sorted. → P237

**P204's orphans, settled at S126:**

| | |
|---|---|
| P28 | homed in 3B.3 by its own text. Number dies, content survives |
| P76 | Zebra `java` process — corrected S91. Dead |
| P77 | never add the Zebra in System Settings. A standing instruction, not a proposal. Number dies |
| P4 | duplicate of **P117** per TRAPS' own S96 cut list. Dead |
| P3 | live — the 8.0 rollback snapshot's existence is unverified. One look at the RDS snapshot list |
| P74 | live and material — nothing watches SSL renewal on either box, and Let's Encrypt no longer warns |
| P1(b) | **not found.** Absent from all 513 lines read. It lives in 3B.1, 3B.2 or 3B.4 |

---

## QUEUE

New items go at the **bottom** with the next free number. Claude never renumbers. Ranking is Minty's.

### Named next

**P231 · SES to the new account.** The S127 job — see above.

**P230 · Point prod's `~/.my.cnf` at `abletracelab_live`.** Today it carries `database=abletrace`, the dormant archive, so a bare `mysql < file.sql` writes into the wrong database silently. A one-line fix removes the trap at source rather than documenting it. Grep first for anything on prod calling a bare `mysql`. `~/.my.cnf` is not in git — record the change in Section 5's JR block.

**P232 · `abletrace.ca` DNS zone to the new account.** Not an app dependency — proved S126 — but it holds the live Zoho mail records, so the account cannot close without it. Full record export from the Route 53 console first; `dig` only finds what you already know to ask for. Replicate, repoint GoDaddy's nameservers, verify, leave the old zone standing while resolvers drain. **Be surgical.**

**P233 · Old app box.** Image to an AMI first — last copy of that server's configuration — then terminate and release `3.98.223.126`.

**P234 · Marketing site needs a new home** before the account closes.

**P235 · Check dev's RDS engine version in the new account.** If 8.0, it is paying Extended Support. Two minutes.

**P236 · `abletrace-fileuploads1` retention decision.** Departed clients' uploaded food-safety documents. **May carry a regulatory retention period.** Business decision, not technical. Download to Drive if in doubt.

**P237 · Read 3B.1, 3B.2, 3B.4, then rewrite 3B whole.**

**P239 · Dead nodemailer block in `email.js` carries a plaintext password** — `support@piklane.com`, from an unrelated project, commented out but in the repo and therefore in git history. Delete the block; the credential is not ours to leak.

**P240 · `email.js` send errors vanish.** `.then(→true).catch(→false)` on a floating promise nothing awaits. Caller gets no value, error object discarded unlogged. A failed invite is invisible everywhere. Fix while P231 has the file open.

**P16 · JR source files are single-copy on prod.** Every `.sql` behind ~36 procs and 9 views lives only in `/home/ubuntu` on the prod box, which is not backed up off-instance; the Drive copy is unverified. Cited in 3B.3 and in no queue until now.

### Standing

**P210 · PROD TO NODE 24.** Own session, nothing else in it. Prod unpatched since April 2025. Install method measured S122 — NodeSource `node_18.x`, pinned 600. Dev's route transfers: change the repo line to `node_24.x`, apt update, apt install. **Apt replaces, it does not add.**

**P217 · Angular 18 → 20.** The only thing that unblocks a Node 24 builder. Angular 20 supports ^20.19 || ^22.12 || ^24. Framework major on a live client app — multiple sessions, own gate.

**P206 · MO release panel shows one release per material, not each.** MO-0014 traceability lists six Ginger Powder releases; the MO's own panel shows a single row of 916.471 and is not summing them either. A warehouse controller cannot see what was actually consumed. Suspect a join collapse or missing aggregate. Raised by Minty.

**P228 · Move three business-logic rulings into Bible Part 1** (`Section_2.md`). ⚠ Part 1 is edited only on Minty's express permission, wording approved in advance. And **read first** — P221 says four of its blocks are self-declared incomplete. Do this as a job, not a close task. Originals are in Section 5 regardless.

**P111 · QuickBooks.** Precondition met. One planning session, no code. Needs a new column (TRAPS 3).

**P164 is live on both clients today, deliberately.** `Formulations.js` declares `returnSum` in all three branches and never assigns it, then adds the return into the **released** total — so returning material makes the screen show *more* released, and Returned Qty always reads 0. `MLOManagement.js:1112` does the identical job correctly. **The proof one file is wrong is sitting in the other file.** With P163 · P165 · P168 · Bible rows 20/42/43 — budget as a survey; never read end to end.

### Housekeeping

**P203** No ESM Apps on either box; **18** updates pending dev (was 17 at S118), 36 prod.
**P205** pm2 differs, dev 7.0.3 / prod 7.0.1. Global, outside package-lock. `package.json` declares `^5.3.0` and neither box runs 5.x. P210 will not fix it.
**P207** Waterline warns at every boot — null `description` on `companyuserrole` and `roles`, null timestamps on `company`. Harmless, but it floods the log and a real error would be buried.
**P208** `npm install` reports 110 vulnerabilities, 33 critical. `npm audit` names them. Note `aws-sdk` v2 is unmaintained since Sept 2025 — used by `email.js`.
**P214** Old repo `~/abletrace-lab/abletrace-frontend`, GitLab-era. GitHub token dead (401). **GitLab token never measured, may still be live** — revoke in GitLab's UI, it is free. Keep one sanitized snapshot (strip remotes first), then delete.
**P215** `promote.sh` is not in version control — `/Users/mintym1/promote.sh`, outside any repo, one machine. `deploy-frontend.sh` likewise only on the boxes. **These two scripts are the deploy procedure.**
**P216** GitHub Actions v4 deprecated. Bump `checkout`, `setup-node`, `upload-artifact` to @v5. Unrelated to `node-version: '20'`. Cheap.
**P219** `deploy-frontend.sh` names backups after the build. The name is true about what is live; the **contents** are the trap.
**P224** Dev SSH has no IPv6 rule — see STATE.
**P225** Sweep `~/Downloads`. 11+ build artifacts back to S61. `promote.sh` deploys whatever zip you name, and S111 offered a superseded artifact for prod.
**P227** Delete dev's `~/abletrace-lab-backend/node_modules.old-node18`, 303 MB.

### Documents

**P90** Two false claims in 3A, which is searchable in project knowledge. Five of eight modules self-marked STUB is honest; a false claim is not. Find them.
**P221** Bible Part 1 has four self-declared incomplete blocks. **TO BE VERIFIED is the hazard** — it says outright "unconfirmed against live code" and sits in the document a session trusts for business rules. Untouched since S84, now searchable a paragraph at a time.
**P222** Section 4, 635 lines, never edited since S79, held out of the project. ⚠ **The item starts from the wrong end:** it assumed Section 4's "MO production-status indicator ✅ BUILT" was false, but Section_5's J22 says the component *was* built at S49, commit 2228cda9. **Section 4 is probably right and the S46 backlog is the stale record.** Do not correct a true claim.
**P229** Bible **Part 4** records the IP4 lot ratio as 0.04478498…. True figure is 41 ÷ 915.53 = 0.0447828…. Changed no result — 1.957 either way — but wrong where a future session would copy it.

### Behaviour

**P218** Over-release accepted silently. MO-0014 requires 916.471 Kg of Ginger Powder; the screen read 1016.471/916.471 and the app took it. Not a wrong row — the S106 clamshell ruling holds. **Should it warn?**
**P200** Negative quantity accepted on add-sales-order. `.html:84` no `min`; `.ts:245` and `:249` no `Validators.min(0)`. Frontend build and deploy, known 20-minute path.
**P201** `add-sales-order.component.ts:393` — `(quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit)`. batch_qty cancels, so it divides a weight to make a unit count. Reachability unmeasured.

### Units

**Row 41 is cheapest and most visible** — release details shows Kg with no unit count. All history reads 0 (the JR20/P170 trade); sooner is cheaper.
**P196** Two intermediate blocks disagree by 0.011 Kg (0.004 on IP4). Display only.
**P135** Two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
**P198** `formulations.inventory` carries float tails — no floor, no rounding. Only `inventory_units` gets `Math.round` and `Math.max(0,…)`. Low.

### Unranked

P8 · P17 · P20/P22 · P64 · P65 · P84/P85 · P86 · P88 · P94 · P101/P109 · P106 · P108 · P114 · P116/P117 · P118 · P119 · P120 · P121–P123 · P124 · P129 · P130 · P131 · P132 · P133 · P134 · P136 · P137 · P138 · P139 · P142 · P145/P146 · P148 · P152 · P153 · P155 · P156 · P158/P159 · P166 · P167 · P169 · P170 · P171 · P172 · P173 · P174 · P175 · P178 · P179 · P182 · P185 · P189 · P190 · P191 · P192 · P194/P195

**P115 dead code:** `rejected-materials.ts:152-154` · `MLOManagement.js` getMLCbyId/V2 · PopUps/add-dispatch v1 · `edit-mlc.ts:311,227` · `MaterialsProductsReleased.js:52` and `:83-98` · `material-traceability-details.html:113-125, 191-216` · `Traceability.js` @returnedQty/@mprIDs

---

## SESSION HYGIENE — S126 finding

**Screenshots are the most expensive thing in a session** — a full-screen capture costs roughly what a couple of thousand words costs. S126 used about fifteen, comparable to every document read in the session combined.

- Prefer **CloudShell text** over console screenshots. `aws ec2 describe-volumes --query ... --output table` costs a fraction and is easier to read.
- When a console screen is the only source, **crop to the panel**. The dock, menu bar, tab strip and wallpaper cost the same as the data.
- **One job per session.** S126 ran three.
- Do not paste back terminal scrollback already read earlier in the session.
- The S126 sweep is the model: greps returning a dozen lines settled a question fifteen screenshots could not.
