# NOW

Rewritten whole at the close of **S143**.

The open check measures commits, process, port, runtime and dirty trees. Nothing here repeats it. This carries only what no command returns.

---

## STATE

**S143 prepared and proved the domain move. Nothing public changed.**

Everything below was measured or seen on screen this session. The live site was 200 at the start and 200 at the end.

**Deliberate, done, verified:**

- **Three certificates on prod**, each its own renewal config, mutually independent. `trace.mintekfoodsafety.com` was never touched — same serial at close as at open.
- **nginx on prod carries a second 443 block** for `abletrace.ca` / `www.abletrace.ca`, own certificate, same docroot, same `/api/` proxy. The original block is byte-for-byte unchanged. The port-80 redirect now uses `$host` instead of a hardcoded name.
- **The whole app proved working under a new name** in Chrome via a Mac `/etc/hosts` entry: login, AdminHome, materials list, material edit, **file upload to S3**, **file download and render**, invite email delivered, password reset, second login.

**Deliberate, NOT done:** no DNS record was changed. The public still resolves `abletrace.ca` to CloudFront, verified at close against `8.8.8.8`.

**Half-done — must be undone at the top of S144:**

⚠ **The Mac's `/etc/hosts` still contains `15.157.38.101 abletrace.ca www.abletrace.ca`.** Left in place, Minty's Mac sees the new server no matter what DNS says, so he would be the last person to know if a cutover failed. **Remove it before touching DNS.**

⚠ **Three `_acme-challenge` TXT records remain in the zone** (`_acme-challenge`, `_acme-challenge.www`, `_acme-challenge.app`). Spent, harmless, delete when convenient.

---

## ⚠ THE DESTINATION CHANGED — MINTY'S RULING S143

**This supersedes the S142 plan.** S142 planned to move the app to bare `abletrace.ca`. That is no longer the destination.

| name | what it serves |
|---|---|
| **`abletrace.ca`** / `www.` | a **static marketing page**. S144 puts a minimal holding page there; it grows in place afterwards |
| **`app.abletrace.ca`** | **the application**. One login, one session |

**Everything else is a MODULE inside the app, never a new subdomain.** Invoicing, extra food safety, FDA guidance ingestion — all become tiles, opened per client by `company_user_role` / `company_user_task` / `role_task` rows. Minty's ruling S143, after working through the alternative.

⚠ **One database, one backend, one front door.** The reasoning: master data lives once; business rules live once; a second place for invoice logic drifts from the first and the client finds out before you do.

⚠ **Modules are database rows created THROUGH THE UI, never by SQL.** The app's creation path copies `role_task` into `company_user_task`. SQL runs no application code.

**Why the marketing page must be a real static page, not the old CloudFront site:** the old site is the old Angular app, and its Login button works — pointing at the old backend and the old database. Left as the placeholder it is a wrong door that looks right, *and* it keeps CloudFront, the old instance and `abletrace-prod1` alive, blocking the old-account retirement.

---

## THE JOB — S144: CUT OVER TO `app.abletrace.ca`

**Sunday evening, after 5pm.** Minty's ruling S143: two live clients, neither works Sunday.

**All three names move this session.** `app.abletrace.ca` → the app. `abletrace.ca` + `www.` → a minimal holding page. The old CloudFront site goes dark, which closes the wrong-door login and unblocks the old-account retirement.

### The action, in order

1. **Remove the `/etc/hosts` line on the Mac.** Verify with `dig` that `abletrace.ca` resolves to CloudFront again from the Mac's own resolver.
2. **Add the `app.abletrace.ca` server block to nginx on prod.** Certificate already exists. Reload, then `curl -I https://trace.mintekfoodsafety.com` to prove the live site survived.
3. **Edit `environment.prod.ts:3`** on the Mac — `apiUrl` to `https://app.abletrace.ca/api/v1/`. Commit, push, **manual dispatch on GitHub for prod**, then `~/deploy-frontend.sh`. Shift+Cmd+R after.
4. **Change the DNS — three records.** ⚠ **Minty's ruling S143: all three move in S144.**
   - **Create** `app.abletrace.ca` — type A, **Alias OFF**, value `15.157.38.101`, TTL 60.
   - **Edit** `abletrace.ca` A — turn **Alias OFF**, replace the CloudFront alias with value `15.157.38.101`. A TTL box appears once Alias is off; set 60.
   - **Edit** `www.abletrace.ca` A — identical change.
   ⚠ **Do the `app.` record FIRST and prove the app works before touching the other two.** If `app.` fails you still have the old site up while you fix it.
5. **Change `APP_BASE_URL` in prod `.env`** to `https://app.abletrace.ca`, then `pm2 restart abletrace-backend`, `sleep 8`, curl.
6. **Put a minimal holding page at `abletrace.ca`.** Write it to **`/var/www/marketing`** — ⚠ **never `/var/www/html`**, which every frontend deploy overwrites whole. Logo, one or two sentences, a Login button to `https://app.abletrace.ca`. Then change the `root` in the existing `abletrace.ca` 443 block from `/var/www/html` to `/var/www/marketing`, drop its `/api/` proxy (marketing needs no backend), reload.
7. **Verify on screen** — see below.

⚠ **Step 6 is a holding page, not a marketing project.** It grows in place later — more sections, pricing, whatever — with no DNS, no certificate and no deploy pipeline involved. That is the whole payoff of the split. **Do not let it expand inside S144.**

⚠ **Order matters.** Step 3 must land before step 4, or the first visitor to `app.abletrace.ca` gets a page whose API calls go to the old name. Both names work throughout, so there is no outage window — but the build must be out first.

### ⚠ The one that would have bitten — found S143

**`apiUrl` is hardcoded and baked into the build.**

```
/Users/mintym1/abletrace-lab-frontend/src/environments/environment.prod.ts:3
  apiUrl : 'https://trace.mintekfoodsafety.com/api/v1/',
```

Measured by `grep -rn "mintekfoodsafety" ~/abletrace-lab-frontend/src --include="*.ts"` — **exactly two hits**, prod and dev, nothing else anywhere in `src`.

**S143's whole browser test ran with the page calling back to `trace.mintekfoodsafety.com` for data.** It worked because that name still works. **This is why S144 is not two record edits — it is a frontend rebuild and deploy.**

### Material — all measured S143

| fact | measured by | returned |
|---|---|---|
| `abletrace.ca` A record | Route 53 console, old acct `350466202408`, Edit record, not saved | **Alias ON** · Alias to CloudFront distribution · US East (N. Virginia) · `d1gnzid0cfbv78.cloudfront.net` · Simple · **TTL field absent, shows "-"** |
| `www.abletrace.ca` A record | same | **identical in every field** |
| What the public resolves | `dig +short A abletrace.ca @8.8.8.8` and same for `www.` | `18.172.185.12 / .5 / .55 / .104` — both names, same four |
| Certificates on prod | `sudo certbot certificates` | `abletrace.ca` + `www` (exp 2026-11-27) · **`app.abletrace.ca` (exp 2026-11-28)** · `trace.mintekfoodsafety.com` (exp 2026-10-17, **serial unchanged all session**) |
| Renewal configs | `sudo ls /etc/letsencrypt/renewal/` | three separate `.conf` files |
| nginx before | `sudo cat -n /etc/nginx/sites-enabled/abletrace` | one file, 984 bytes, not a symlink. One 443 block, one 80 block |
| nginx after | patch script output | 2149 bytes. Backup at **`/root/nginx-abletrace.bak-s143-20260830-012152`** |
| nginx syntax + live site | `sudo nginx -t` then `curl -I https://trace.mintekfoodsafety.com` | ok, test successful · **HTTP/1.1 200 OK** |
| New block answers | `curl -I -H "Host: abletrace.ca" --resolve abletrace.ca:443:127.0.0.1 https://abletrace.ca` | **200** — and curl validated the certificate to get there |
| Email link source | `grep -rn "mintekfoodsafety" ~/abletrace-lab-backend/ --exclude-dir=node_modules --exclude-dir=.git` | `.env:8 APP_BASE_URL` · `config/env/production.js` lines 24, 151, 250 use `process.env.APP_BASE_URL \|\| '<old name>'` — **fallback only, not hardcoded** |
| Frontend API URL | `grep -rn "mintekfoodsafety" ~/abletrace-lab-frontend/src --include="*.ts"` | **2 hits only** — `environment.prod.ts:3`, `environment.dev.ts:3` |
| Docroot | `ls -1 /var/www/html` · `du -sh` | hashed Angular chunks, **20M** — ⚠ **overwritten whole by every frontend deploy** |
| Rollback builds on prod | `ls -1dt /home/ubuntu/www-html.bak-*` | `...4910b46d` (live) · `...e1a82e02` · `...2968c591` |

### ⚠ Rollback — the only thing that must be right on the night

**To undo step 4, per record:**
- `app.abletrace.ca` — delete it. Nothing else points at it.
- `abletrace.ca` and `www.abletrace.ca` — turn **Alias back ON**, `Alias to CloudFront distribution`, region **US East (N. Virginia)**, target **`d1gnzid0cfbv78.cloudfront.net`**, Simple routing. ⚠ **That target string is the rollback.** The four IP addresses are CloudFront's and rotate on their own — never roll back to those.

⚠ **Because all three move, the old site is no longer a safety net.** Do `app.` first, prove it, then the other two.

**There is no TTL to lower.** Alias records have no TTL field — AWS manages it. This was measured, not assumed. It is why the evening timing carries the whole risk reduction.

**To undo step 3:** the previous build is at `/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031`. ⚠ **Read the rollback path off the box, never from a build label.**

**To undo step 5:** `APP_BASE_URL` back to `https://trace.mintekfoodsafety.com`, restart.

### The records that must not be touched

Zoho `MX` · apex TXT (**two values: zoho-verification AND `v=spf1 include:zohomail.co...`**) · `zmail._domainkey` · 8 SES DKIM CNAMEs · `_amazonses` · `_dmarc` · two ACM validation CNAMEs · NS · SOA.

⚠ **CORRECTION TO S142: an SPF record DOES exist.** S142's NOW stated flatly that there is none. Seen on screen S143 — the apex TXT row holds two values and the second is `v=spf1 include:zohomail.co...`. It names Zoho only; SES is not in it. **Do not "add" SPF and do not disturb the apex TXT.** Mail works today on DKIM plus relaxed DMARC.

### Verify — S144 is done when

- `https://app.abletrace.ca` loads in a browser **with no hosts entry**, padlock clean
- Login works, a data screen draws, a file uploads and downloads
- An invite email arrives and **the link inside says `app.abletrace.ca`**
- `curl -I https://trace.mintekfoodsafety.com` still returns 200
- **`https://abletrace.ca` shows the holding page**, padlock clean, and its Login button lands on the working app
- **`https://www.abletrace.ca` does the same**
- ⚠ **Nothing anywhere still shows the OLD site.** That is the point of moving all three

---

## THEN

**S145 — old-account retirement.** ⚠ **Minty's ruling S143: ONE ITEM AT A TIME. Claude shows what points at each resource, Minty says go, then it goes.** Never a batch. The S138 subdomain takeover happened exactly this way.

**Then QuickBooks production (P267).** ⚠ **`app.abletrace.ca` is the domain to declare to Intuit**, and the OAuth redirect URI becomes `https://app.abletrace.ca/api/quickbooks/callback`. Declaring before the move means going back mid-review.

**Certificate renewal, before 27 November.** All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **Once DNS points at this box, re-issue them the ordinary webroot way and renewal becomes automatic.** Fold into S145.

---

## ⚠ SECRET EXPOSED S143 — ROTATE

**Dev's `DATABASE_URL`, including the password, was printed to the screen and into chat.** Claude's grep pattern matched it. Dev only; prod untouched; the RDS instance is not publicly reachable.

**Not an emergency, but it must be rotated.** → **P272**. ⚠ **Method is 3B.8 — read it first.** A fumble on a live DB password locks the app out.

---

## OLD ACCOUNT — DISPOSITION

Measured S142. ⚠ **Nothing on this list has been deleted.** ⚠ **Minty's ruling S142 stands: the four old clients' data stays until he says otherwise.**

**Goes safely — nothing points at these:** `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (**never used, ever**). ~$2/month.

**Stays permanently:** SES `ca-central-1` (only working email path; new account was **denied**) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1` — the only copy of client documents** · root + MFA.

**Goes after S144 proves out** — ~$58/month: instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record. ⚠ **The DNS record goes first, never the IP first.**

**Needs a question answered first:** `s3_cloudfront` key `AKIAVDGLJ3MUH7IPS3W7`, last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at this. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** — $25.76/month: the 6 manual RDS snapshots.

---

## ⚠ THE RDS SNAPSHOTS — SETTLED, DO NOT RELITIGATE

**They can go, but not yet.** Master data for all four old clients is duplicated in schema `abletrace` on the new account's prod RDS, which is backed up with it. Measured S142:

| id | company | materials | recipes | suppliers | customers |
|---|---|---|---|---|---|
| **184** | **mavatrial2** | **310** | **171** | **25** | **13** |
| **213** | **Kans Gourmet Foods Trial** | **79** | **101** | **25** | **21** |
| 366/378/418 | Truffle / Truffle Pig | 43/26/28 | 14/14/19 | 9 | 172–175 |
| **419** | **hagensborg** | **34** | **84** | **10** | **175** |

⚠ **`164 Mava Foods` is an abandoned empty registration.** Mava's real record is **184 mavatrial2**. Reading "Mava Foods, 0 materials" and concluding the data is missing is the wrong answer.

⚠ **Master data is database data.** `abletrace-fileuploads1` holds PDFs and JPEGs whose filenames name no company. **The bucket and the snapshots are not copies of each other, and neither substitutes for the other.**

⚠ **A snapshot cannot be inspected without restoring it**, which restarts the extended-support meter. Read identifiers and dates — never restore to look.

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P265 | **S144. Cut over to `app.abletrace.ca`.** Full spec above. ⚠ **Sunday evening** |
| — | **S145. Old-account retirement, ONE ITEM AT A TIME.** Minty's ruling S143 |
| — | **Grow the holding page into the real marketing site.** No session needed — it is files in `/var/www/marketing`. No DNS, no certificate, no deploy pipeline. ⚠ **Never `/var/www/html`** |
| P267 | **QuickBooks production approval.** ⚠ **Declare `app.abletrace.ca`.** Privacy policy skeleton first. Brief is a separate file Minty holds |
| P262 | **Client onboarding importer — complete rebuild.** Mava is the pilot. Full spec was in S142's NOW; re-derive from Section 3A when it comes up |
| P272 | **Rotate dev's DATABASE_URL password.** Exposed to screen and chat S143. ⚠ **Method 3B.8, read it first** |
| P270 | **Material certificate icon shows red "Certificate Unavailable" when a certificate IS uploaded, saved, and in date.** Proven S143: MAT-5 BBQ Sauce Bulk, `White Rice Label. copy.pdf`, expiry 2026-09-30, downloads and renders. **Display fault only** — file and date are correct in the row |
| P271 | **`[object Object]` alert on SO-Management.** An error path that fails to render its own message, so the user is told nothing. Seen S143 |
| P17 | Two old-account IAM keys still valid and in git history. The old account is load-bearing for email |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — **Phase 2 core DONE and proven.** Four failure-handling items remain. **Phase 3 UNBLOCKED** — hardcoded `sandbox260820` can become `req.companyId` |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn` |
| P248 | **OS updates.** Both boxes report "system restart required". Prod 59 pending / 12 security |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dev home is full of dead build folders**, ~50 back to S63. ⚠ Keep the live rollback and one prior. ⚠ Also: `.env.bak-s139` on both boxes · prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/` · **prod `~/patch-nginx-abletrace-s143.py`, spent** |
| P257 | **Automated bounce and complaint handling.** ⚠ Required for any SES re-application |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` dev, `testsesprod260825` prod. ⚠ Set Inactive through the app, not by SQL |
| P259 | **One IAM key serves both boxes.** Minty's ruling S139: separate eventually. Dev first, prove a send |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` (console access removed S142; user remains) · `abletracelab-ses-smtp-s35` |
| P264 | **No automated tests anywhere.** The S141 attack test is the only one. ⚠ Never run against prod |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`** |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224` |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **A blank page with the correct tab title means the JavaScript threw, not that the server failed.** Open the console. Seen S143 — it was only a missing refresh.

⚠ **A local `dig` can return EMPTY while Route 53 already holds the new value.** Ask the authoritative server: `dig +short TXT <name> @ns-1320.awsdns-37.org`. Cost twenty minutes in S143.

⚠ **Route 53 truncates record names in the list.** `_acme-challenge`, `_acme-challenge.www` and `_acme-challenge.app` all display as `_acme-ch...`. **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** "root is not authorized to perform route53:GetHostedZone" meant the zone belongs to the other account. **Read the account number before the measurement.**

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

⚠ **Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. **Only Inactive blocks login. Expired keeps access.** Seen S143 — "Your licence has expired" on a working account is not a fault.

⚠ **`SELECT ... INTO OUTFILE` does not work on RDS.** Use `mysql -B`.

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it.

⚠ **`pm2 restart` prints "Use --update-env"** — that is PM2's own env. `dotenv` reads the file at boot.

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path and it starts an extended-support meter.

⚠ **`sudo` changes HOME.** The S143 nginx backup landed in `/root/`, not `/home/ubuntu/`.

⚠ **nginx `grep -r` silently skips symlinks.** Use `nginx -T`.

⚠ **A server block loads exactly one certificate.** Two names needing different certificates need two blocks.

**QuickBooks Canada refuses any transaction with no tax code on a line**, and any line with no Amount. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.**

**The QuickBooks access token expires in hours.** Load the QuickBooks page in Chrome first — that page refreshes and writes back. ⚠ **Retired the moment on-demand refresh is built.**

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, **lower case**.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

**`formulations` has no `name` column — it is `title`.**
