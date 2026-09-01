# NOW

Rewritten whole at the close of **S145**.

The open check measures commits, process, port, runtime and dirty trees. Nothing here repeats it. This carries only what no command returns.

---

## STATE

**The domain cutover is COMPLETE and proven on the screen.** All four names serve from `15.157.38.101`.

| name | serves | proven by |
|---|---|---|
| **`app.abletrace.ca`** | the application | login, data screens, file up **and** down, SES email received |
| **`abletrace.ca`** | the same build — marketing pages + Login | incognito, clean padlock |
| **`www.abletrace.ca`** | the same | `curl -s -I` 200, certificate validated |
| `trace.mintekfoodsafety.com` | still up, unchanged | 200 |

**Deliberate, done:**

- Prod frontend is **`2a576cb8`** — `apiUrl` = `https://app.abletrace.ca/api/v1/`. Deployed with label `prod-2a576cb8e64f8ddcd28368cd0696b11f0912ee0d`.
- Prod `.env` line 8 `APP_BASE_URL=https://app.abletrace.ca`. Backend restarted, 200.
- nginx carries **three 443 blocks**; the `app.` block was added S144.
- Three Route 53 A records → `15.157.38.101`, TTL 60, Alias OFF.
- ⚠ **A column was added to the PROD database**: `companycustomers.external_id VARCHAR(255) NULL`. It was missing and was breaking the live Customers screen.
- **GitHub Actions was paid for.** The artifact quota blocker is gone. → **P273 closed.**
- **Clients were told the new address by WhatsApp S145.** The old name still works; no deadline was given.

⚠ **`abletrace.ca` and `app.abletrace.ca` serve the SAME BUILD.** The marketing pages live inside the Angular app and render to anonymous visitors. **No holding page was built and no nginx change was needed** — S144's steps 6 and 7 disappeared. Splitting them later is the same size job as doing it now. → **P280**

**Half-done: nothing.** No rollback is pending, no file is partly written, no record is partly changed.

---

## ⚠ THE FINDING — THE QUICKBOOKS SCHEMA NEVER REACHED PROD

**Measured S145. This is the whole of next session.**

| object | dev | prod |
|---|---|---|
| `companycustomers.external_id` | present | **WAS MISSING — added S145** |
| five `qb_*` columns on `packingslips` | present | **ALL FIVE MISSING** |
| table `quickbooks_tokens` | present | **MISSING** |

⚠ **NOW previously claimed all of these existed on both boxes. That was wrong on every one.** A quoted fact with no measurement beside it is a memory, not material.

⚠ **It is not scattered drift. It is one body of work that stopped at dev.** `external_id` only surfaced because it sits on a table the Customers screen reads — **that screen was throwing a 500 for two live clients and nobody knew** until a domain cutover made someone click it.

⚠ **The QuickBooks screen on prod would fail the moment anyone opened it.**

**RULES already covers this:** *a database object reaches neither box by deploying; run it on each box separately, gate each box separately.* The rule exists. It was not followed. **Why that happened matters more than the columns.**

---

## THE JOB — S146: SCHEMA DRIFT, DEV vs PROD

### The action, in order

1. **File the two traps** marked **→ to TRAPS** at the foot of this document. ⚠ Doc edits are replacements — pull, read the live file, replace whole, diff, commit, push. Delete them from NOW once filed.
2. **Column-level comparison across all 77 tables.** The table-level check found one gap; the column check found six. ⚠ **Spot checks are what let this survive.** Compare every column of every table, both boxes, and produce one list.
3. **Decide what to apply to prod.** ⚠ **Not automatic** — see the QuickBooks question below.
4. **Establish how a schema change gets to both boxes.** Without this it recurs.

### Material — measured S145

| fact | measured by | returned |
|---|---|---|
| Table counts | `SELECT ... information_schema.tables` both boxes | prod **77**, dev **78** (78/79 lines incl. header) |
| The one extra table | `diff /tmp/prod-tables.txt /tmp/dev-tables.txt` | `58a59 > quickbooks_tokens` — **dev only** |
| `qb_*` on prod | `SHOW COLUMNS FROM packingslips LIKE 'qb_%'` on `abletracelab_live` | **empty — none of the five exist** |
| `external_id` before the fix | `SHOW COLUMNS FROM companycustomers LIKE 'external_id'` | empty on prod, present on dev |
| The definition applied | dev's `SHOW COLUMNS` | `varchar(255)`, `YES` null, no key, no default |
| The 500 itself | `pm2 logs abletrace-backend --lines 50 --nostream` | `ER_BAD_FIELD_ERROR: Unknown column 'companycustomers.external_id' in 'field list'` |

### ⚠ The two databases are NOT shared — settled S145

| box | RDS instance | schema |
|---|---|---|
| **prod** | `abletrace-lab-prod.czwsy0m0axvx.ca-central-1.rds.amazonaws.com` | `abletracelab_live` |
| **dev** | `abletrace-lab-dev-s62-dev.czwsy0m0axvx.ca-central-1.rds.amazonaws.com` | `abletracelab_live` |

Measured with `grep "^DATABASE_URL" .env | sed 's|://[^@]*@|://***:***@|'` — masks the credential, shows host and schema.

⚠ **Two separate servers. The schema NAME is identical on both**, which is why `SHOW DATABASES` looks the same on each box and why a wrong-box query would not announce itself. → **P276**

⚠ **Each instance carries three schemas**: `abletrace` (78 prod / 77 dev), `abletrace-dev` (66 both), `abletracelab_live` (the live one). **`abletrace-dev` on the PROD instance is not the dev box's database.**

### ⚠ The QuickBooks question that must be answered first

**Do not apply the QuickBooks schema to prod reflexively.** Minty's S145 ruling on **P279** moves invoicing into AbleTrace, and QuickBooks integration off the critical path. Applying a schema for a feature that may not ship is work for nothing.

**Business question:** does the QuickBooks schema go to prod now, or wait until P279 is settled? The `external_id` column is already applied and stays regardless — it was breaking a live screen.

### Verify — S146 is done when

- One list exists of **every** column difference between the two `abletracelab_live` schemas
- Each difference has a decision beside it: apply, don't apply, or investigate
- Anything applied is verified with `SHOW COLUMNS` on prod
- ⚠ **A screen that uses each changed table has been opened on prod and draws** — a column added is not a screen proven
- A written answer to how the next schema change reaches both boxes

---

## ⚠ ROLLBACK — the cutover, should it ever be needed

**The three DNS records:** turn **Alias back ON** → `Alias to CloudFront distribution` → region **US East (N. Virginia)** → target **`d1gnzid0cfbv78.cloudfront.net`** → Simple routing. ⚠ **Never roll back to the four `18.172.185.x` addresses** — those are CloudFront's own and they rotate.

**The frontend:** `sudo rm -rf /var/www/html/* && sudo cp -r /home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031/* /var/www/html/` ⚠ **Read the rollback path off the box first.** The deploy script prints a rollback line to the build it just replaced — that is not the pre-cutover one.

**The `.env`:** backup at `/home/ubuntu/.env.bak-s145`. **nginx:** `/root/nginx-abletrace.bak-s144-20260830-204516`. **Mac hosts:** `/etc/hosts.bak-s144`. **Mac `environment.prod.ts`:** `~/environment.prod.ts.bak-s144`.

**The added column:** `ALTER TABLE companycustomers DROP COLUMN external_id;` ⚠ Would re-break the Customers screen.

---

## ⚠ THE OLD ACCOUNT IS NOW UNBLOCKED

**Nothing you own points at CloudFront any more.** That was the blocker on retiring the old account's instance, distribution and bucket.

⚠ **Nothing has been deleted. ONE ITEM AT A TIME.** Claude shows what points at each resource, Minty says go, then it goes. Never a batch — the S138 subdomain takeover happened exactly this way.

⚠ **`prodapi.abletrace.ca` A → `3.98.223.126`** — seen in the console S145. That is the old account's Elastic IP. **The DNS record goes first, never the IP first.**

**Goes safely — nothing points at these:** `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (**never used**). ~$2/month.

**Stays permanently:** SES `ca-central-1` (only working email path; the new account was **denied**) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1` — the only copy of client documents** · root + MFA.

**Goes now the cutover has proven out** — ~$58/month: instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record.

**Needs a question answered first:** `s3_cloudfront` key `AKIAVDGLJ3MUH7IPS3W7`, last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at this. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** — $25.76/month: the 6 manual RDS snapshots.

⚠ **Three spent `_acme-challenge` TXT records** remain in the zone. Harmless, delete when convenient.

---

## ⚠ THE ARCHIVE SCHEMA IS RICHER THAN PREVIOUSLY RECORDED

Measured S145. Schema **`abletrace`** on the **prod** RDS instance, new account. **Backed up with prod. Does NOT depend on the old AWS account.**

**Client procedures survive with their full text.** `documents.editorContent` holds the written procedure, 500–4,500 characters each. `documents` and `docDriveLink` are NULL on the text-bearing rows — **there is no file dependency.**

| id | company | licence | docs with text | evidence |
|---|---|---|---|---|
| 366 | Truffle | 6 Inactive | **0** | Oct 2025, 21 docs all empty. First attempt |
| **378** | **Truffle Pig** | 6 Inactive | **36** | ⚠ all v1, **all created in one second** 2026-04-24. A template suite loaded, not authored |
| 418 | Truffle | 6 Inactive | 0 | empty shell, no documents at all |
| **419** | **hagensborg** | 6 Inactive | **24** | ⚠ **authored 27–28 Mar 2026, six revised to v2 minutes apart.** The record that was worked in |

⚠ **A version 2 is a NEW ROW, not an edit.** That is why `createdAt` and `updatedAt` match on every v2.

⚠ **`haccpplan` has NO `company_id`** — it joins through `hazards.hazardId`. 210 rows spanning **2020 to 2026**, so it holds clients older than these four. **Only 366 has a HACCP plan** — one row. 378 and 419 have none.

**Extracted S145:** `hagensborg-procedures.txt`, 18 procedures, 23,884 bytes, on the Mac. ⚠ **'Process flowchart' excluded** — 294,872 characters because it is a base64 image, not text. Extract as a picture if wanted.

⚠ **Column names in this schema are not what you would guess.** `documenttype.name` not `title`. `company.company_name` not `name`. **Read the structure before writing the query.**

---

## ⚠ TWO LIVE CLIENTS SEE "Your licence has expired."

Seen S145 on Shelly (Hagensborg) and Javier (Designer Cookies). ⚠ **Licence status 4 Expired still permits login — only 6 Inactive blocks it.** So it works as designed, but it is the first thing both clients read every time.

**Business question, and it is now urgent:** the WhatsApp message pointing clients at `app.abletrace.ca` was sent S145. **That banner is what greets them at the new address.**

---

## THE DESTINATION — MINTY'S RULING S143, UNCHANGED

| name | what it serves |
|---|---|
| **`abletrace.ca`** / `www.` | the **marketing site** |
| **`app.abletrace.ca`** | **the application**. One login, one session |

**Everything else is a MODULE inside the app, never a new subdomain.** ⚠ **One database, one backend, one front door.** ⚠ **Modules are database rows created THROUGH THE UI, never by SQL.**

---

## ⚠ PRIVACY POLICY — MINTY'S RULINGS S145

**The skeleton is settled. It goes to a lawyer.**

- **Collected:** names, emails, company affiliation for logins; business records including clients' own customer details
- **Purpose:** operating the traceability platform
- **Third parties:** AWS · Amazon SES · Zoho · Intuit ⚠ **check whether any client data sits in Google Drive**
- **Location:** **Canada, `ca-central-1`** — databases, files and email. ⚠ A genuine strength for Canadian producers; state it plainly
- **Retention:** as long as the account is live
- **Deletion:** ⚠ **on request** — Minty's ruling. From the live system; backups age out thereafter
- **Breach:** clients informed, ⚠ **AND the Privacy Commissioner where required** — the law obliges both, and requires a record of all breaches whether reported or not
- **Privacy officer:** **Minty**, `info@abletrace.ca`. ⚠ An accountability role, not an IT one

⚠ **Deactivation does NOT delete anything** — proven S145 by the four Inactive companies whose data is fully intact. **Any policy wording that says otherwise would be untrue about our own system.**

⚠ **Neither legal document currently names AbleTrace.** That alone would fail review.

---

## THEN

**Certificate renewal, before 27 November.** All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **Now DNS points at this box, re-issue them the ordinary webroot way and renewal becomes automatic.** Cheap, and it removes a hard deadline.

---

## ⚠ SECRET EXPOSED S143 — ROTATE

**Dev's `DATABASE_URL`, including the password, was printed to screen and chat.** Dev only; prod untouched; the RDS instance is not publicly reachable. → **P272**. ⚠ **Method is 3B.8 — read it first.**

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| — | **S146. Schema drift, dev vs prod.** Full spec above |
| P279 | **Invoicing inside AbleTrace.** Minty's design, S145: a **default price on the product master, editable per invoice line**; a **default tax treatment per product, overridable per line**, plus a manual option. ⚠ **Store the values USED on the invoice — never re-derive from the master later**, or changing a price rewrites last month's invoices (the S106 principle). ⚠ **Tax must be per line, not per invoice** — basic groceries are zero-rated, prepared foods are not, and one order can carry both. QuickBooks transfer becomes **optional and manual**: the client keys an invoice number and total. ⚠ **This takes P267 off the critical path** |
| P278 | **Terms and privacy policy INSIDE the app, with versioned acceptance.** Both currently live only in Google Drive. Record **who accepted, when, and WHICH VERSION**. ⚠ On a change, ask again — an old acceptance does not carry forward. ⚠ Acceptance rows are never edited or deleted. ⚠ **`company.terms_condition` is a yes/no flag with no version and no timestamp — replace it, don't extend it** |
| P277 | **Client data deletion routine.** Deletion on request is now a published commitment with no tooling. ⚠ Manual today: many related tables in FK order, **plus the `abletrace-fileuploads1` bucket whose filenames name no company**. Needs a documented procedure at minimum |
| P276 | **Naming audit across all environments.** ⚠ Both RDS instances hold a schema called `abletracelab_live` and one called `abletrace-dev`; `SHOW DATABASES` is identical on both boxes. Audit instances, schemas, EC2s, PM2 processes, buckets, IAM users, repos. List what is ambiguous, then decide what is worth renaming and what is too load-bearing to touch |
| P280 | **Split the marketing site out of the Angular app.** Today a visitor downloads the whole application to read three paragraphs, every marketing tweak needs a full rebuild and deploy, and the app serves more than a login door to anonymous visitors. ⚠ **No harder later than now** — the content is HTML and images. Assets already on the box: `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images. ⚠ **Copy them to `/var/www/marketing`, never reference them in `/var/www/html`** — every deploy wipes that whole. ⚠ `/var/www/` is root-owned: `sudo mkdir` then `sudo chown ubuntu:ubuntu` |
| — | **Old-account retirement.** Unblocked S145. Full disposition above. ⚠ **One item at a time** |
| P262 | **Client onboarding importer — complete rebuild.** Mava is the pilot. ⚠ **Verify Section 3A actually holds the spec before starting** — the detail was in S142's NOW and has been dropped. If 3A does not have it, it exists only in git history |
| P272 | **Rotate dev's DATABASE_URL password.** ⚠ **Method 3B.8, read it first** |
| P267 | **QuickBooks production approval.** ⚠ **Off the critical path per P279.** Gaps if resumed: disconnect URL, `intuit_tid` capture, both legal documents naming AbleTrace, and the redirect becomes `https://app.abletrace.ca/api/quickbooks/callback` with `app.abletrace.ca` declared |
| P270 | **Material certificate icon shows red "Certificate Unavailable" when a valid in-date certificate exists.** Seen again S145 on prod. **Display fault only** — the file downloads and opens |
| P274 | **No local build path.** ⚠ `nvm` is not installed; the Mac is Node v24 against a project declaring `^20`. Lower priority now the quota is paid, but it is the only route when GitHub is unavailable. ⚠ `npm ci` was run on the Mac S144 — `node_modules` is a fresh lockfile install |
| P275 | **192 npm vulnerabilities (6 critical, 79 high).** ⚠ **Do NOT run `npm audit fix`** — it rewrites dependency versions |
| P271 | `[object Object]` alert on SO-Management. An error path that fails to render its own message |
| P17 | Two old-account IAM keys still valid and in git history. The old account is load-bearing for email |
| P8 | **Prod git checkout lags the served build.** ⚠ Prod's checkout reads `9bce0238`; `/var/www/html` serves `2a576cb8`. **Not a failed deploy** |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P248 | **OS updates.** ⚠ **Both boxes now say "System restart required" on every login.** Prod 59 pending / 12 security; dev 56 / 25 |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — Phase 2 core done and proven **on dev**. ⚠ **The schema is not on prod at all.** Four failure-handling items remain |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn` |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated. Seen on every run |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dead build folders and spent scripts.** Dev home ~50 folders back to S63. ⚠ Keep the live rollback and one prior. Also: `.env.bak-s139` both boxes · prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/` · **prod `~/patch-nginx-abletrace-s143.py`, `~/patch-nginx-app-s144.py`, `~/extract-hagensborg-procedures.py`, `~/dist-prod-2a576cb8….zip`, `/tmp/*-tables.txt`, `~/hagensborg-procedures.txt`** · Mac `~/environment.prod.ts.bak-s144`, `/etc/hosts.bak-s144`, `~/Downloads/dev-tables.txt` |
| P257 | **Automated bounce and complaint handling.** ⚠ Required for any SES re-application |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` dev, `testsesprod260825` prod. ⚠ Set Inactive through the app, not by SQL |
| P259 | **One IAM key serves both boxes.** Separate eventually. Dev first, prove a send |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` · `abletracelab-ses-smtp-s35` |
| P264 | **No automated tests anywhere.** ⚠ Never run the S141 attack test against prod |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`** |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224`. ⚠ `Materials.js:380` and `:790` use `myCode` and were never checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

---

## ⚠ THE RDS SNAPSHOTS — SETTLED, DO NOT RELITIGATE

**They can go, but not yet.** Master data for all four old clients is in schema `abletrace` on the new account's prod RDS, backed up with it — **and S145 proved the procedure TEXT is there too**.

| id | company | materials | recipes | suppliers | customers |
|---|---|---|---|---|---|
| **184** | **mavatrial2** | **310** | **171** | **25** | **13** |
| **213** | **Kans Gourmet Foods Trial** | **79** | **101** | **25** | **21** |
| 366/378/418 | Truffle / Truffle Pig | 43/26/28 | 14/14/19 | 9 | 172–175 |
| **419** | **hagensborg** | **34** | **84** | **10** | **175** |

⚠ **`164 Mava Foods` is an abandoned empty registration.** Mava's real record is **184 mavatrial2**.

⚠ **`abletrace-fileuploads1` holds PDFs and JPEGs whose filenames name no company.** The bucket and the snapshots are not copies of each other.

⚠ **A snapshot cannot be inspected without restoring it**, which restarts the extended-support meter. Read identifiers and dates — never restore to look.

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **A GitHub run can COMPILE and still fail.** The upload step is separate. **Read which step went red before touching the code.** → **to TRAPS**

⚠ **`dig` ignores `/etc/hosts` entirely.** To prove a hosts override is gone use `dscacheutil -q host -a name <n>` — `dig` answers the same either way and cannot fail. → **to TRAPS**

⚠ **Chrome serves the OLD site from cache after a DNS change.** `abletrace.ca` showed blank while `curl` from the box returned 200. **Prove the server with curl, then use a fresh incognito window** — a normal hard refresh was not enough.

⚠ **A blank page with the correct tab title means the JavaScript threw**, not that the server failed.

⚠ **The deploy script prints a rollback line to the build it just replaced.** That is not the pre-cutover backup. **Read the path off the box.**

⚠ **Check `index.html` is at the top level of an unzipped artifact** before deploying — the script copies `$SRC/*`.

⚠ **`curl -I ... 2>&1 | head -1` returns the PROGRESS METER.** Use `curl -s -I`.

⚠ **Column names are not guessable.** `documenttype.name` not `title`; `company.company_name` not `name`. **`SHOW COLUMNS` first.**

⚠ **`haccpplan` has no `company_id`.** Join through `hazards`.

⚠ **A local `dig` can return EMPTY while Route 53 already holds the new value.** Ask the authoritative server: `dig +short TXT <n> @ns-1320.awsdns-37.org`.

⚠ **Route 53 truncates record names in the list.** **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** **Read the account number before the measurement.**

⚠ **`isAuth` rewrites `req.body.company_id` on every authenticated request.** Sending a different one has no effect and is not a bug.

⚠ **A URL or query carrying another company returns 403 "Company mismatch".** That is P250 working.

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session.

⚠ **A master role row created by SQL grants nothing.** Companies, roles and tasks on prod must be created through the UI.

⚠ **`mysql abletracelab_live` — name the DB explicitly.** A bare `mysql` on prod lands in the archive `abletrace`.

⚠ **`formulation_id` means PARENT in `fosubrecipe`, CHILD in `subrecipeformulation`.**

⚠ **`unitmeasurement` is per-company.** A `uom` value is an id and means different things to different companies.

⚠ **Product titles are not unique.** 171 products, 139 distinct titles. **Match on `internalCode`.**

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

⚠ **`shipped_flag` is the ship gate, not `status_id`.**

⚠ **Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. **Only Inactive blocks login. Expired keeps access and shows a banner.**

⚠ **`SELECT ... INTO OUTFILE` does not work on RDS.** Use `mysql -B`.

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it.

⚠ **`pm2 restart` prints "Use --update-env"** — that is PM2's own env. `dotenv` reads the file at boot. **A restart IS needed after editing `.env`.**

⚠ **Sails reads the SCHEMA per query.** A column added to the database needs no restart — only a browser reload.

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path and it starts an extended-support meter.

⚠ **`sudo` changes HOME.** nginx backups land in `/root/`.

⚠ **nginx `grep -r` silently skips symlinks.** Use `nginx -T`.

⚠ **A server block loads exactly one certificate.** Prod now has three 443 blocks.

**QuickBooks Canada refuses any transaction with no tax code on a line**, and any line with no Amount. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.**

**The QuickBooks access token expires in hours.** Load the QuickBooks page in Chrome first — that page refreshes and writes back.

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, **lower case**.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not. **The trap a Mac-built bundle would hit.**

**`formulations` has no `name` column — it is `title`.**
