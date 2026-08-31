# NOW

Rewritten whole at the close of **S144**.

The open check measures commits, process, port, runtime and dirty trees. Nothing here repeats it. This carries only what no command returns.

---

## STATE

**S144 did the first half of the cutover and was stopped by GitHub, not by anything in the app. No DNS record was changed. Nothing public moved.**

The live site was 200 at the start and 200 at the end.

**Deliberate, done, verified:**

- **The Mac's `/etc/hosts` override is GONE.** S143's line `15.157.38.101 abletrace.ca www.abletrace.ca` was removed. The Mac now resolves `abletrace.ca` to CloudFront exactly as the public does. Backup at `/etc/hosts.bak-s144`.
- **nginx on prod now carries a THIRD 443 block**, for `app.abletrace.ca`, its own certificate, same docroot, same `/api/` proxy. The two existing 443 blocks are untouched. `app.abletrace.ca` added to the port-80 redirect. Backup at **`/root/nginx-abletrace.bak-s144-20260830-204516`**.
- **`environment.prod.ts:3` now reads `https://app.abletrace.ca/api/v1/`.** Committed and pushed as **`2a576cb8`**. Mac backup of the old file at `~/environment.prod.ts.bak-s144`.

**Deliberate, NOT done:** no DNS record changed. No frontend deployed anywhere. Prod still serves the old build.

**Half-done — nothing on any box is in a broken or partial state.** The commit is on `main` and deployed nowhere.

---

## ⚠ THE ONE THING THAT MUST NOT BE GOT WRONG

**`2a576cb8` MUST NOT REACH PROD BEFORE `app.abletrace.ca` RESOLVES.**

That build calls `https://app.abletrace.ca/api/v1/` for every piece of data. Deploy it while the name still points nowhere and the live site loads a page whose every data call fails — a white app for two live clients.

**Order is: DNS record first, prove it resolves, then deploy.** This inverts S143's plan, which had the deploy first. ⚠ **The inversion is safe because the record is NEW.** Creating `app.abletrace.ca` breaks nothing — no name changes meaning, no traffic moves. It simply starts resolving to a host that already answers 200 on it. Nothing reaches it until someone types it.

---

## ⚠ THE BLOCKER — GITHUB ARTIFACT STORAGE QUOTA

**GitHub will not hand over a build. Two attempts, both failed identically.**

```
Failed to CreateArtifact: Artifact storage quota has been hit.
Unable to upload any new artifacts. Usage is recalculated every 6-12 hours.
```

⚠ **The compile SUCCEEDS.** Run #82 ran 7m37s, the dispatch run 6m26s, both compiled cleanly and both died at the *Upload dist artifact* step. **There is nothing wrong with the code.** Reading this as a build failure is the wrong answer.

**What was already tried:** Minty deleted the old artifacts around 14:10. The dispatch run at 21:46 — over seven hours later, inside the stated 6–12 hour window — failed the same way.

⚠ **So the deletions may not have freed enough.** The window has nearly elapsed and the gate is still shut. **Do not assume the morning fixes it.** Try once, and if it fails again the quota is not the whole story.

**First action of S145 is one dispatch.** Actions → Build Frontend → Run workflow → `main` → target **prod**. Green with an artifact means carry on. Red at upload means go to the Mac path below.

### The Mac fallback — homework done, not executed

The Mac can build this. Measured S144: `node_modules` present, `npm ci` completed successfully.

⚠ **`npm ci` HAS ALREADY BEEN RUN.** `~/abletrace-lab-frontend/node_modules` is a fresh lockfile install as of S144. Do not run it again unless something suggests it is stale.

⚠ **The Mac is on Node v24.13.1. `package.json` declares `node: '^20'` and the pipeline pins Node 20.** npm printed `EBADENGINE ... required: { node: '^20' }, current: { node: 'v24.13.1' }`. It warns, it does not refuse.

**`nvm` is NOT installed** — measured, `NO nvm`. So the Mac path forks:

- **Install nvm, build on Node 20** — matches the pipeline exactly, removes the version objection. Preferred.
- **Build on Node 24** — off-spec, nobody has tested this configuration.

**The build command is `npm run build-prod`**, read off the workflow file. The runner does exactly `npm ci` then `npm run build-prod`, nothing else.

**Then:** zip `dist/`, `scp` it to prod, unzip to `~/dist-prod-<full sha>`, and run the deploy script exactly as with a downloaded artifact. ⚠ **The deploy script does not care where the folder came from.**

---

## THE JOB — S145: FINISH THE CUTOVER

**All three names still to move.** `app.abletrace.ca` → the app. `abletrace.ca` + `www.` → a minimal holding page.

⚠ **Sunday evening was S143's ruling. Minty overrode it in S144 on the grounds that no client works Sunday.** Two live clients — if S145 lands on a weekday, the timing question is open again and it is Minty's to answer.

### The action, in order

0. **File the two new traps into TRAPS.md.** Marked **→ to TRAPS** at the foot of this document. ⚠ **Doc edits are replacements** — pull, read the live file, replace whole, diff, commit, push. Five minutes at the open. Delete them from NOW once filed.
1. **Get a prod build.** One GitHub dispatch. If it fails at upload, go to the Mac path above.
2. **Create the `app.abletrace.ca` DNS record** — Route 53, **old account `350466202408`**, zone `abletrace.ca`. Type **A**, **Alias OFF**, value **`15.157.38.101`**, TTL **60**. ⚠ **Creating this breaks nothing.** Prove it resolves before going on.
3. **Deploy the build to prod.** `scp` the zip, unzip to `~/dist-prod-2a576cb8e64f8ddcd28368cd0696b11f0912ee0d`, then `~/deploy-frontend.sh prod-2a576cb8e64f8ddcd28368cd0696b11f0912ee0d`. Shift+Cmd+R in Chrome after.
4. **Change `APP_BASE_URL` in prod `.env`** to `https://app.abletrace.ca`, then `pm2 restart abletrace-backend`, `sleep 8`, curl.
5. **Prove the app on `app.abletrace.ca`** — login, a data screen, a file up and down, an invite email whose link says `app.abletrace.ca`. ⚠ **Do not touch the other two records until this passes.** Until this point the old site is still up and nothing has been taken away.
6. **Write the holding page to `/var/www/marketing`.** ⚠ **NEVER `/var/www/html`** — every frontend deploy overwrites that whole. Logo, a sentence or two, a Login button to `https://app.abletrace.ca`.
   - ⚠ **The folder does not exist and `/var/www/` is root-owned.** `sudo mkdir /var/www/marketing` then `sudo chown ubuntu:ubuntu /var/www/marketing`, matching `/var/www/html`. Without the chown, every future edit needs sudo and "grow it in place" becomes a chore.
   - **The images already exist** in `/var/www/html/assets/images/` — the old marketing site's assets, still riding inside the app build. `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images (`abletrace-food-safety`, `-traceablity`, `-production`, `-rceipe`, `-supplier`, `-order-fulfillment`). ⚠ **COPY them into `/var/www/marketing/`, never reference them where they sit** — the next frontend deploy wipes `/var/www/html` whole and the page would lose its images.
7. **Point `abletrace.ca` and `www.` at the holding page** — change the `root` in the existing `abletrace.ca` 443 block from `/var/www/html` to `/var/www/marketing`, drop its `/api/` proxy, `nginx -t`, reload.
8. **Edit the two DNS records** — `abletrace.ca` A and `www.abletrace.ca` A. Turn **Alias OFF**, value `15.157.38.101`. A TTL box appears once Alias is off; set 60.
9. **Verify on screen** — see below.

⚠ **Step 6 is a holding page, not a marketing project.** It grows in place later, with no DNS, no certificate and no deploy pipeline involved. That is the whole payoff of the split. **Do not let it expand inside the session.**

### Material — measured S144 unless stated

| fact | measured by | returned |
|---|---|---|
| Frontend commit to deploy | `git push` | **`2a576cb8`** (`d7702040..2a576cb8`) |
| What changed in it | `cat -n .../environment.prod.ts` before and after | line 3 `trace.mintekfoodsafety.com` → **`app.abletrace.ca`**, one line, `decimalPlaces: 3` intact |
| Scope of that string | `grep -rn "mintekfoodsafety" ~/abletrace-lab-frontend/src --include="*.ts"`, S143 | **2 hits only** — prod and dev environment files. ⚠ **`environment.dev.ts` deliberately untouched** |
| nginx after the S144 patch | patch script output | 2149 → **3286 bytes**. Backup `/root/nginx-abletrace.bak-s144-20260830-204516` |
| nginx syntax | `sudo nginx -t` | ok, test successful |
| Live site survived the reload | `curl -s -I https://trace.mintekfoodsafety.com \| head -1` | **HTTP/1.1 200 OK** |
| `app.` block answers | `curl -s -I -H "Host: app.abletrace.ca" --resolve app.abletrace.ca:443:127.0.0.1 https://app.abletrace.ca \| head -1` | **HTTP/1.1 200 OK** — curl validated the certificate to get there |
| Mac sees public DNS again | `grep -n abletrace /etc/hosts; dscacheutil -q host -a name abletrace.ca` | grep empty · `18.172.185.5 / .55 / .12 / .104` — CloudFront |
| The build pipeline | `cat -n .../.github/workflows/build-frontend.yml` | `npm ci` → `npm run build-prod` · **Node pinned to 20** · dispatch input `target`, choice prod/dev, **default prod** · a **push** builds **dev** · `retention-days: 14` |
| Deploy script | `cat -n ~/deploy-frontend.sh` on prod | takes a **label**, copies `~/dist-<label>` → `/var/www/html`. **Backs up to `~/www-html.bak-<label>`, named after the NEW label — so it does NOT overwrite the existing rollback** |
| Builds on prod | `ls -1dt /home/ubuntu/dist-*` | `dist-prod-4910b46d…` + `.zip` · `…e1a82e02` + `.zip` · `…2968c591` |
| Rollback builds on prod | `ls -1dt /home/ubuntu/www-html.bak-*` | **`/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031`** (live) |
| Mac build capability | `node -v; npm -v`, `ls -d …/node_modules` | v24.13.1 · npm 11.8.0 · `node_modules` present, freshly `npm ci`'d |
| nvm on the Mac | `command -v nvm \|\| ls -d ~/.nvm` | **NO nvm** |
| **Full SHA — the deploy label** | `git -C ~/abletrace-lab-frontend rev-parse HEAD` | **`2a576cb8e64f8ddcd28368cd0696b11f0912ee0d`**. ⚠ **The label is the FULL sha, not the short one** |
| Docroot ownership | `ls -ld /var/www/ /var/www/html /var/www/marketing` | `/var/www/` **root:root** · `/var/www/html` **ubuntu:ubuntu** · **`/var/www/marketing` does not exist** |
| Marketing images available | `ls -1 /var/www/html/assets/images/` | logo, background, about, contact and **six named feature images** — a whole marketing site's assets |
| Downloads | `ls -1t ~/Downloads` | one file, `patch-nginx-app-s144.py`, spent. **No numbered duplicates** |
| Dev, untouched | dev open check | frontend `c2a52d8e`, backend `cf7722d` **matching prod**, clean but for `node_modules.old-node18/` (P227), `abletrace-dev` online, 200, v24.19.0 |

### ⚠ Rollback

**To undo step 2:** delete the `app.abletrace.ca` record. Nothing else points at it.

**To undo step 3:** `sudo rm -rf /var/www/html/* && sudo cp -r /home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031/* /var/www/html/`. ⚠ **Read the rollback path off the box first, never from a build label.**

**To undo step 4:** `APP_BASE_URL` back to `https://trace.mintekfoodsafety.com`, restart.

**To undo step 8, per record:** turn **Alias back ON**, `Alias to CloudFront distribution`, region **US East (N. Virginia)**, target **`d1gnzid0cfbv78.cloudfront.net`**, Simple routing. ⚠ **That target string is the rollback.** The four `18.172.185.x` addresses are CloudFront's own and rotate — **never roll back to those.**

**There is no TTL to lower.** Alias records have no TTL field; AWS manages it. Measured S143, not assumed.

**To undo the S144 nginx change:** the backup is at `/root/nginx-abletrace.bak-s144-20260830-204516`. ⚠ **`sudo` changes HOME** — that is why it is in `/root/`, not `/home/ubuntu/`.

### The records that must not be touched

Zoho `MX` · apex TXT (**two values: zoho-verification AND `v=spf1 include:zohomail.co...`**) · `zmail._domainkey` · 8 SES DKIM CNAMEs · `_amazonses` · `_dmarc` · two ACM validation CNAMEs · NS · SOA.

⚠ **An SPF record DOES exist** — the apex TXT row holds two values and the second is SPF, naming Zoho only. **Do not "add" SPF and do not disturb the apex TXT.** Mail works today on DKIM plus relaxed DMARC.

⚠ **Three spent `_acme-challenge` TXT records remain** (`_acme-challenge`, `_acme-challenge.www`, `_acme-challenge.app`). Harmless, delete when convenient.

### Verify — S145 is done when

- `https://app.abletrace.ca` loads in a browser **with no hosts entry**, padlock clean
- Login works, a data screen draws, a file uploads and downloads
- An invite email arrives and **the link inside says `app.abletrace.ca`**
- `curl -I https://trace.mintekfoodsafety.com` still returns 200
- **`https://abletrace.ca` shows the holding page**, padlock clean, Login button lands on the working app
- **`https://www.abletrace.ca` does the same**
- ⚠ **Nothing anywhere still shows the OLD CloudFront site**

---

## ⚠ THE DESTINATION — MINTY'S RULING S143

| name | what it serves |
|---|---|
| **`abletrace.ca`** / `www.` | a **static marketing page**, grown in place |
| **`app.abletrace.ca`** | **the application**. One login, one session |

**Everything else is a MODULE inside the app, never a new subdomain.** Invoicing, extra food safety, FDA guidance ingestion — all tiles, opened per client by `company_user_role` / `company_user_task` / `role_task` rows.

⚠ **One database, one backend, one front door.** Master data lives once; business rules live once; a second place for invoice logic drifts from the first and the client finds out before you do.

⚠ **Modules are database rows created THROUGH THE UI, never by SQL.**

**Why the marketing page must be a real static page:** the old CloudFront site is the old Angular app and **its Login button works**, pointing at the old backend and the old database. A wrong door that looks right — *and* it keeps CloudFront, the old instance and `abletrace-prod1` alive, blocking the old-account retirement.

---

## THEN

**Old-account retirement.** ⚠ **ONE ITEM AT A TIME. Claude shows what points at each resource, Minty says go, then it goes.** Never a batch. The S138 subdomain takeover happened exactly this way.

**Then QuickBooks production (P267).** ⚠ **`app.abletrace.ca` is the domain to declare to Intuit**, and the OAuth redirect becomes `https://app.abletrace.ca/api/quickbooks/callback`.

**Certificate renewal, before 27 November.** All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **Once DNS points at this box, re-issue them the ordinary webroot way and renewal becomes automatic.**

---

## ⚠ SECRET EXPOSED S143 — ROTATE

**Dev's `DATABASE_URL`, including the password, was printed to screen and chat.** Dev only; prod untouched; the RDS instance is not publicly reachable. → **P272**. ⚠ **Method is 3B.8 — read it first.**

---

## OLD ACCOUNT — DISPOSITION

Measured S142. ⚠ **Nothing on this list has been deleted.** ⚠ **The four old clients' data stays until Minty says otherwise.**

**Goes safely — nothing points at these:** `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (**never used**). ~$2/month.

**Stays permanently:** SES `ca-central-1` (only working email path; new account was **denied**) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1` — the only copy of client documents** · root + MFA.

**Goes after the cutover proves out** — ~$58/month: instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record. ⚠ **The DNS record goes first, never the IP first.**

**Needs a question answered first:** `s3_cloudfront` key `AKIAVDGLJ3MUH7IPS3W7`, last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at this. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** — $25.76/month: the 6 manual RDS snapshots.

---

## ⚠ THE RDS SNAPSHOTS — SETTLED, DO NOT RELITIGATE

**They can go, but not yet.** Master data for all four old clients is duplicated in schema `abletrace` on the new account's prod RDS, backed up with it. Measured S142:

| id | company | materials | recipes | suppliers | customers |
|---|---|---|---|---|---|
| **184** | **mavatrial2** | **310** | **171** | **25** | **13** |
| **213** | **Kans Gourmet Foods Trial** | **79** | **101** | **25** | **21** |
| 366/378/418 | Truffle / Truffle Pig | 43/26/28 | 14/14/19 | 9 | 172–175 |
| **419** | **hagensborg** | **34** | **84** | **10** | **175** |

⚠ **`164 Mava Foods` is an abandoned empty registration.** Mava's real record is **184 mavatrial2**.

⚠ **Master data is database data.** `abletrace-fileuploads1` holds PDFs and JPEGs whose filenames name no company. **The bucket and the snapshots are not copies of each other.**

⚠ **A snapshot cannot be inspected without restoring it**, which restarts the extended-support meter. Read identifiers and dates — never restore to look.

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P265 | **S145. Finish the cutover to `app.abletrace.ca`.** Full spec above. ⚠ **Blocked on a GitHub build** |
| P273 | **GitHub artifact storage quota is full and blocks EVERY frontend build.** Old artifacts deleted S144; still blocked seven hours later. ⚠ **This blocks all frontend work, not just the cutover.** Options: wait longer · delete more · `retention-days` below 14 · a paid plan · build on the Mac |
| P274 | **No local build path exists.** ⚠ **`nvm` is not installed and the Mac is on Node 24 against a project that declares `^20`.** Worth having regardless of P273 — it is the only route when GitHub is unavailable |
| P275 | **192 npm vulnerabilities (6 critical, 79 high)** reported by `npm ci` S144. ⚠ **Do NOT run `npm audit fix`** — it rewrites dependency versions. Needs a deliberate session |
| — | **Grow the holding page into the real marketing site.** No session needed — files in `/var/www/marketing`. ⚠ **Never `/var/www/html`** |
| P267 | **QuickBooks production approval.** ⚠ **Declare `app.abletrace.ca`.** Privacy policy skeleton first |
| P262 | **Client onboarding importer — complete rebuild.** Mava is the pilot. Re-derive the spec from Section 3A |
| P272 | **Rotate dev's DATABASE_URL password.** ⚠ **Method 3B.8, read it first** |
| P270 | **Material certificate icon shows red "Certificate Unavailable" when a certificate IS uploaded and in date.** Proven S143. **Display fault only** |
| P271 | **`[object Object]` alert on SO-Management.** An error path that fails to render its own message |
| P17 | Two old-account IAM keys still valid and in git history. The old account is load-bearing for email |
| P8 | **Prod git checkout lags the served build.** ⚠ After S145's deploy, prod's checkout will still read `9bce0238` while `/var/www/html` serves `2a576cb8`. **Not a failed deploy** |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — **Phase 2 core DONE and proven.** Four failure-handling items remain. **Phase 3 UNBLOCKED** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn` |
| P248 | **OS updates.** Both boxes report "system restart required". Prod 59 pending / 12 security |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated. ⚠ **Seen again S144** — `actions/checkout@v4` forced onto Node 24 |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dev home is full of dead build folders**, ~50 back to S63. ⚠ Keep the live rollback and one prior. ⚠ Also: `.env.bak-s139` both boxes · prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/` · **prod `~/patch-nginx-abletrace-s143.py` and `~/patch-nginx-app-s144.py`, both spent** · Mac `~/environment.prod.ts.bak-s144`, `/etc/hosts.bak-s144` |
| P257 | **Automated bounce and complaint handling.** ⚠ Required for any SES re-application |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` dev, `testsesprod260825` prod. ⚠ Set Inactive through the app, not by SQL |
| P259 | **One IAM key serves both boxes.** Separate eventually. Dev first, prove a send |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` · `abletracelab-ses-smtp-s35` |
| P264 | **No automated tests anywhere.** The S141 attack test is the only one. ⚠ Never run against prod |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`** |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224` |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **A GitHub run can COMPILE and still fail.** The upload step is separate. **Read which step went red before touching the code.** Cost most of S144. → **to TRAPS**

⚠ **`dig` ignores `/etc/hosts` entirely.** To prove a hosts override is gone, use `dscacheutil -q host -a name <n>` — `dig` would answer the same either way and cannot fail. → **to TRAPS**

⚠ **A blank page with the correct tab title means the JavaScript threw, not that the server failed.** Open the console.

⚠ **A local `dig` can return EMPTY while Route 53 already holds the new value.** Ask the authoritative server: `dig +short TXT <n> @ns-1320.awsdns-37.org`.

⚠ **Route 53 truncates record names in the list.** `_acme-challenge`, `.www` and `.app` all display as `_acme-ch...`. **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** **Read the account number before the measurement.**

⚠ **`isAuth` rewrites `req.body.company_id` on every authenticated request.** Sending a different one has no effect and is not a bug.

⚠ **A URL or query carrying another company returns 403 "Company mismatch".** That is P250 working.

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session.

⚠ **A master role row created by SQL grants nothing.** Companies, roles and tasks on prod must be created through the UI.

⚠ **`mysql abletracelab_live` — name the DB explicitly.** A bare `mysql` on prod lands in the dormant archive `abletrace`.

⚠ **`formulation_id` means PARENT in `fosubrecipe`, CHILD in `subrecipeformulation`.**

⚠ **`unitmeasurement` is per-company.** A `uom` value is an id, and the same id means different things to different companies.

⚠ **Product titles are not unique.** 171 products, 139 distinct titles. **Match on `internalCode`, never on name.**

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

⚠ **`shipped_flag` is the ship gate, not `status_id`.**

⚠ **Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. **Only Inactive blocks login. Expired keeps access.**

⚠ **`SELECT ... INTO OUTFILE` does not work on RDS.** Use `mysql -B`.

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it.

⚠ **`pm2 restart` prints "Use --update-env"** — that is PM2's own env. `dotenv` reads the file at boot.

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path and it starts an extended-support meter.

⚠ **`sudo` changes HOME.** nginx backups land in `/root/`, not `/home/ubuntu/`.

⚠ **nginx `grep -r` silently skips symlinks.** Use `nginx -T`.

⚠ **A server block loads exactly one certificate.** Two names needing different certificates need two blocks. Prod now has three.

**QuickBooks Canada refuses any transaction with no tax code on a line**, and any line with no Amount. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.**

**The QuickBooks access token expires in hours.** Load the QuickBooks page in Chrome first — that page refreshes and writes back. ⚠ **Retired the moment on-demand refresh is built.**

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, **lower case**.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not. ⚠ **This is the trap a Mac-built bundle would hit.**

**`formulations` has no `name` column — it is `title`.**
