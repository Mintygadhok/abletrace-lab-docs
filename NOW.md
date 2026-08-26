# NOW

Rewritten whole at the close of S139.
Read RULES.md and this file. Nothing else at the open.

**S139 restored email on both boxes and proved it on screen.** The business stop is cleared — clients can be onboarded.

**S140 audits the old AWS account.** Delete nothing. The output is a written list of what is in that account and what still points at each thing. Minty's ruling, S139: keep SES and the DNS that SES depends on; everything else is a *candidate* to go, and a candidate only leaves once we know what points at it.

---

## STATE

What no command returns.

**Email works on dev and prod.** Both boxes send through the OLD account's SES using one IAM key created S139. Nothing half-done.

**Both `.env` files were edited by hand and backed up.** Not in git, not carried by any deploy.
```
dev  ~/abletrace-lab-backend/.env.bak-s139   602 bytes
prod ~/abletrace-lab-backend/.env.bak-s139   443 bytes
```

**Prod was restarted for the first time since before S130.** Restart count read `1`. Code unchanged — only `.env`.

**Dev backend is `0948476`, dev frontend deployed and proven.** QuickBooks Phase 2 core is done. Untouched in S139.
```
/home/ubuntu/www-html.bak-dev-d770204085dbb138303ec6decbd3bd73a05c4a8b   dev rollback
/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031  prod rollback
```

**Two test companies now exist and were not cleaned up.** `testses260825a` on dev, `testsesprod260825` on **prod**. Both walked the full invite → password → login path. ⚠ There is no delete path for a company, only Inactive. Deliberate — the full walk proved more than the email alone. → queue.

**Both boxes report "system restart required."** Noted S135, still not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Stray QuickBooks estimate 183** sits in the sandbox with no number. Harmless. Delete in QuickBooks whenever.

**PS-0032 is a spent fixture.** The route refuses a second send. To exercise the button, clear it first — command in the S138 material, not carried here.

---

## THE JOB — S140

**Inventory the old AWS account 350466202408. Delete nothing. Produce the list.**

### The action, in order

1. **Start with the bill, not the console.** Cost Explorer, grouped by service, last 6 months. ⚠ **The bill is the only inventory that misses nothing chargeable.** Per-service screens are easy to miss; S139 proved the estate was not known.
2. **Settle the open question below first** — which account holds the live dev and prod EC2s. Nothing else in the audit can be trusted until it is answered.
3. **Route 53** — every hosted zone, every record. ⚠ **Record what each A/CNAME points at.** This is the list S141 acts on first.
4. **EC2** — instance, Elastic IP, volumes, snapshots, key pairs, security groups. Note what each is attached to.
5. **RDS** — the six manual snapshots, their sizes and their monthly cost.
6. **S3, ACM certificates, CloudWatch, anything the bill surfaced.**
7. **IAM** — all 8 users, their keys, key ages, last-used dates, console access.
8. **Write the list.** For each item: what it is, what points at it, keep or candidate, and what must go first if it goes.

⚠ **Nothing is deleted in S140.** S141 acts on the list, in the order the list dictates.

---

### THE OPEN QUESTION — answer this before anything else

⚠ **We do not know which AWS account the live dev and prod boxes are in.**

The reasoning that says "the new account" is an inference, not a measurement: the old account's EC2 console showed **one** instance in ca-central-1, so dev and prod cannot both be there.

But the old account holds **1 Elastic IP**, and prod's public IP is `15.157.38.101`. If those are the same address, **prod is in the old account** and that Elastic IP must never be released.

⚠ **Releasing an Elastic IP that prod uses would take the live app off the internet.** This is the single most expensive thing S141 could get wrong.

Settle it on the boxes, not by reasoning:
```
curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 60')" http://169.254.169.254/latest/meta-data/instance-id; echo
```
Run on **dev** and on **prod**. Compare each returned instance-id against the old account's EC2 list. ⚠ This command was written in S139 and **never run** — it is not a measurement yet.

---

### The material

Measured in S139. The command or screen is beside each.

#### The old account's SES — the thing being kept

Console, old account 350466202408, SES → Account dashboard:
```
Daily sending quota   50,000 emails per 24-hour period
Maximum send rate     14 emails per second
Region                Canada (Central)
Account health        Healthy
```
⚠ **This is production access, not sandbox.** Sandbox is capped at 200/day and 1/sec, and shows a persistent warning banner. None present.

SES → Identities, 4 rows, all **Verified**:
```
abletrace.ca                    Domain
info@abletrace.ca               Email address
mintydev210706@yopmail.com      Email address
mintydev210705@yopmail.com      Email address
```
⚠ **`mintekfoodsafety.com` is NOT verified here.** `FROM_EMAIL` must stay an `@abletrace.ca` address on both boxes.

⚠ The two yopmail rows are sandbox-era leftovers. `info@abletrace.ca` is redundant given the domain identity. Candidates, but they cost nothing.

#### What was built in S139 — the thing email now depends on

Old account IAM:
```
policy  abletrace260825-ses-send      ses:SendRawEmail + ses:SendEmail, Resource *
user    abletrace260825-ses-sender    that policy only, no console access
key     created S139, secret filed in Section H
```
⚠ **One key serves both boxes.** Same value in dev's and prod's `.env`. → queue.

#### Both boxes, measured S139

```
grep '^FROM_EMAIL' ~/abletrace-lab-backend/.env; awk -F= '/^SMTP_/ {print $1, "length:", length($2)}' ~/abletrace-lab-backend/.env
```
dev and prod both returned:
```
FROM_EMAIL=info@abletrace.ca
SMTP_USER length: 20
SMTP_PASSWORD length: 40
```
⚠ **`SMTP_USER` and `SMTP_PASSWORD` are NOT SMTP credentials.** They are an AWS IAM key id and secret. The app uses the AWS SDK via nodemailer's SES transport. A rotation is an IAM key rotation.

⚠ **Region is hardcoded `ca-central-1` at `api/services/email.js:7`** — not an environment variable. Measured S138. It matches the old account's region, so no code change was needed.

#### The proof that email works — on screen, both boxes

Mailinator, message headers read directly:
```
dev   to testses260825a@mailinator.com    from info@abletrace.ca  sending IP 23.249.208.5  18:24:31
prod  to testsesprod260825@mailinator.com from info@abletrace.ca  sending IP 23.249.208.3  18:35:31
```
⚠ **Both sending IPs are Amazon SES addresses.** This is the independent confirmation that the app sends through SES and not through any other path. It closes the long-standing `info.abletrace@gmail.com` question — that address was never the sender.

Both invitations were walked end to end: email → temporary password → password set → logged in.

#### The old account's EC2 — measured, and the reason the audit exists

Console, ca-central-1:
```
Instances (running) 1     Elastic IPs 1     Volumes 1
Key pairs 5               Security groups 7  Snapshots 7 (EBS)
Load balancers 0          Auto Scaling Groups 0
EC2 cost, past 6 months, Global: $145.51
```
The one instance:
```
AbleTrace Prod N...   i-088b7969158c43bca   Running   t3.small   ca-central-1b   3/3 checks passed
```
⚠ **NOW.md never knew this instance existed.** It is why S140 is an audit and not a cleanup.

#### The dead app in the old account

Browser, S139:
```
abletrace.ca/login          serves a live login page
prodapi.abletrace.ca        500 Internal Server Error on loginUser
```
A backend up with no database behind it. Minty deleted that RDS and took a final snapshot.

⚠ **It cannot hold data or take a client.** But it is only a corpse if the open question above says prod lives elsewhere. **Confirm before touching it.**

#### RDS snapshots in the old account — 6 manual, none automated

Console, RDS → Snapshots → Manual:
```
abletrace-dev-snapshot          8.0.42   abletrace-dev    July 06, 2026
abletrace-dev-snapshot260706    8.0.42   abletrace-dev    July 06, 2026
abletrace-stg-snapshot          8.0.44   abletrace-stg    July 06, 2026
abletrace-stg-snapshot260706    8.0.44   abletrace-stg    July 06, 2026
newinstance-final-20260817      8.0.45   newinstance      August 17, 2026
newinstance-snapshot260706      8.0.44   newinstance      July 06, 2026
```
⚠ **Three former instances**: `abletrace-dev`, `abletrace-stg`, `newinstance`. A three-tier estate, all gone, only snapshots left.

⚠ **All are MySQL 8.0.x.** AWS bills extended support per vCPU-hour on 8.0 after end of standard support. Restoring any of these starts that meter. **Restore, read, delete in the same session — never leave one running.**

⚠ **EBS snapshots are not RDS snapshots.** The "Snapshots 7" on the EC2 dashboard are volume images and a separate list.

#### IAM in the old account — 8 users, three seen

```
abletrace260825-ses-sender    created S139, the live sender
abletracelab-ses-smtp-s35     an older sender, 1 group
Bobby1                        last activity 734 days, password age 1496 days, console access
```
⚠ **P17 lives here.** Two old-account IAM keys are still valid and sit in git history. That account is now load-bearing for email, so this is no longer untidiness.

---

### The analysis

#### Why SES stays in the old account

Technically it causes no problem. Keys are account-scoped; the app just calls the API and cross-account is invisible to the code. Proven twice today.

Three consequences to hold:
1. **The old account can never be closed.** It is permanent infrastructure — root credentials, MFA, billing, security surface, forever.
2. **P17 rises.** Live keys in git history now sit in the account onboarding depends on.
3. **DNS is the only real coupling.** Route 53 serves abletrace.ca; SES verification and DKIM are records in that zone.

⚠ **Correction to the S135 "email-only" ruling.** Route 53 **stays** with SES. Separating the zone from the sender risks breaking DKIM, and ⚠ **DKIM failure is silent** — SES still accepts the message, the log says sent, and deliverability quietly rots. Read S135 as *"email, and the DNS email depends on."*

**The benefit worth naming:** the old account holds years of sending reputation, 50k/day and a clean record. A new account starts cold. Keeping SES there is the stronger position, not a compromise.

#### Why rebuilding in the old account was rejected

Minty raised it. Rejected S139: it would move the live app, two clients' books, the database, nginx, certs and the pipeline onto a different account — downtime and real risk — to gain nothing a client would notice. Moving the large fragile thing because the small stable thing cannot move is the wrong direction.

#### Why the SES re-application does not gate anything

Both things AWS objected to are needed anyway:
- **From-domain and link-domain mismatch** → fixed by the abletrace.ca move, which is wanted regardless.
- **No automated bounce/complaint handling** → P257, which real clients need regardless.

Do both and a re-application is winnable. Granted, the old account closes. Refused, the split stands — it works, costs little, and keeps the reputation. **The decision answers itself at the end instead of gating the start.**

⚠ **The S138 appeal WAS sent.** Confirmed by Minty, S139. Case `178710371200148`, new account `208073623096`, refused 22 Aug.

#### The order that must not be reversed

⚠ **RULES, before removing infrastructure:** ask what still points at this — DNS records, credentials, other AWS settings, accounts outside AWS. **The pointer goes first, the resource second.** ⚠ **A code search cannot find these.**

The most likely place S141 goes wrong: the abletrace.ca DNS records pointing at the dead EC2. Those must be removed **before** the Elastic IP is released. Reversed, a name you own points at somebody else's server.

---

### The verify

S140 is done when:

1. The instance-id command has been run on **both** boxes and the old account's EC2 list has been compared against both. The open question is answered in writing.
2. Cost Explorer has been read by service, and every chargeable line has a matching entry in the list.
3. Every Route 53 record in the old account is written down with what it points at.
4. The list exists as a document, with keep/candidate marked and removal order stated for each candidate.
5. **Nothing has been deleted.**

⚠ Item 1 is the gate. Items 2–4 are the job. Item 5 is the discipline.

---

## WHAT S139 CHANGED

**Email restored on dev and prod**, proven on screen at 18:24 and 18:35. New IAM user and key in the old account; two `.env` files edited by hand; both boxes restarted; both returned 200.

**No code changed. No commit. Nothing in git.** The entire fix was two lines in two files that are deliberately not in the repo.

**Four unknowns closed:**
- The old account's SES is in **production**, not sandbox — 50k/day.
- The verified identity is **abletrace.ca**, not mintekfoodsafety.com.
- The region **matches** the hardcoded `ca-central-1`.
- The app sends through **SES**, proven by the sending IPs. `info.abletrace@gmail.com` was never the sender — it is the Super Admin login (user id 1, per Section_5 J51), a receiving address, not a sending one.

**The archive database is alive on prod's RDS.** `abletrace` answers queries today, alongside `abletracelab_live`. ⚠ **This is why no RDS restore was needed** and why the MySQL 8.0 surcharge question never arose. `newinstance-final-20260817` was left untouched.

**Mava Foods, partially measured.** `mavatrial2@mailinator.com` = user 220, company 184. Company 184's last activity: dispatch orders and packing slips 2024-12-19, MOs and recipes 2025-01-29, one stray materials row 2026-01-28.

⚠ **But 184 is a trial company.** Six Mava-named companies exist in the archive, all licence_status_id 6 (Inactive):
```
164  Mava Foods       2020-12-06
174  Mavadummy1Co     2021-01-04
181  Mava Trial       2021-01-22
183  mavatrial1       2021-01-22
184  mavatrial2       2021-01-22
279  dummymava2101@mailinator.com  2021-09-10
```
**164 is the likely real account and is unmeasured.** Minty's call S139: not required now. → queue.

---

## THINGS THAT COST TIME IN S139

**A memory was argued against a measurement and the memory lost — twice.** `info.abletrace@gmail.com` felt like the sender; it was not. Then the reverse: Minty said the old account was for client passwords, and Claude wrongly inferred the domain must be mintekfoodsafety.com. ⚠ **Both were settled by looking. Neither was settled by reasoning.**

**NOW.md did not know a whole prod EC2 existed** in the old account. Found by screenshot, not by any document. ⚠ **The estate was never inventoried — that is now S140.**

**An IAM policy was created but the checkbox was not ticked** on the attach screen. Caught on the screen before Next. ⚠ A user with no policy fails later as a bare AccessDenied that reads as a broken key.

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops. Never assume a successful send means a delivered one.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it. Fixing dev fixes only dev.

⚠ **`pm2 restart` prints "Use --update-env to update environment variables".** That refers to PM2's own env. `dotenv` reads the file at boot, so a plain restart is enough. Not a warning being ignored.

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path, and it starts an 8.0 extended-support meter. Restore, read, delete in one session.

⚠ **Automated RDS backups die with the instance.** Only a manual or final snapshot survives a deletion.

**QuickBooks Canada refuses any transaction with no tax code on a line**, and refuses any line with no Amount. Both are ValidationFaults with useful text in the response *body*, never in the message. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.** Per-client setting. Phase 3 support case.

**The QuickBooks access token expires in hours.** A hand-run script hits 401 mid-session. **Load `dev.mintekfoodsafety.com/quickbooks` in Chrome first** — that page refreshes and writes back. ⚠ That page has no buttons by design; it is a status page, and the name shown is read live from QuickBooks on every load.

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails. Use a shell variable.

⚠ **`mysql abletracelab_live` — name the DB explicitly.** A bare `mysql` on prod lands in the dormant ARCHIVE `abletrace`. Useful today; dangerous when writing.

**A master role row created by SQL grants nothing.** The app's creation path copies every `role_task` into `company_user_task`; SQL runs no application code. ⚠ **Phase 3: role and task rows on prod must be created through the UI.**

**A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

**`formulations` has no `name` column — it is `title`.**

**`shipped_flag` is the ship gate, not `status_id`.**

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

**Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. ⚠ **Only Inactive blocks login. Expired keeps access.**

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P17 | **Two old-account IAM keys still valid and in git history.** ⚠ **Raised S139** — the old account is now load-bearing for email, so this is a live credential in the account onboarding depends on |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks integration — **Phase 2 core DONE and proven.** Four failure-handling items remain, at the foot |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22+ pending. Both report "system restart required." Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P250 | **Authorization is enforced by the screen, not the server. BLOCKER FOR PHASE 3.** `PackingSlips.js` lines 74, 148, 250, 354 take `company_id` straight from `req.body`. Harmless today; unacceptable with two real clients on one server |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dev home is full of dead build folders**, ~50 back to S63. ⚠ **Keep the live rollback and one prior.** ⚠ **Add: `.env.bak-s139` on BOTH boxes — do not delete until the S139 keys are proven stable** |
| P257 | **Automated bounce and complaint handling.** SNS topic on SES bounce/complaint, suppression of hard bounces, alerting on rate. ⚠ **Required for any SES re-application** — its absence is stated in writing in our reply to AWS. Overlaps P240 |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` on dev, `testsesprod260825` on **prod**. ⚠ **Minty's ruling S139: set them Inactive.** Inactive is the only status that blocks login. ⚠ **Through the app, Super Admin → License and Billing — NOT by SQL.** SQL runs no application code and a licence change writes `licensehistory` rows the UI handles |
| P259 | **One IAM key serves both boxes.** Same `SMTP_USER`/`SMTP_PASSWORD` pair in dev's and prod's `.env`. If it leaks it can only be revoked for both at once. ⚠ **Minty's ruling S139: separate them eventually, not now.** Email has worked for hours after weeks broken — do not swap a proven state for an unproven one. Fold into a session that is editing `.env` anyway. ⚠ **Dev first, prove a send, leave prod on the working key** — a mistake then costs dev, not onboarding |
| P260 | **Old-account IAM users that should not exist.** ⚠ **Minty's ruling S139: nobody but Minty needs an account — if a user is not required, it goes.** `Bobby1` — console access, 734 days idle, 1496-day password. `abletracelab-ses-smtp-s35` — an older sender, plausibly still wired into something. ⚠ **This is a delete, so it is S141, not S140.** Ask the audit question of each first: *what still points at this?* ⚠ **Deactivate a key before deleting it** — deactivation is reversible, deletion is not. Deactivate, wait, see what breaks, then delete |
| P261 | **Mava Foods — confirm which company is real, then export master data.** ⚠ **Minty's view S139: 184 is probably the right one, but check 164's last entry before exporting.** 184 = `mavatrial2`, contact user 220, `mavatrial2@mailinator.com`, created 2021-01-22, trial expiry 2021-02-22, address "2220 Vauxhaul Pl, BC". 164 = `Mava Foods`, created 2020-12-06, six weeks before every trial row, **unmeasured**. Six Mava-named companies exist, all licence_status_id 6. **Step 1** — row counts and last dates for all six: `mysql -N -B -e "SELECT company_id, 'do' t, COUNT(*) n, MAX(createdAt) m FROM abletrace.dispatchorders WHERE company_id IN (164,174,181,183,184,279) GROUP BY company_id UNION ALL SELECT company_id, 'mo', COUNT(*), MAX(createdAt) FROM abletrace.mlomanagement WHERE company_id IN (164,174,181,183,184,279) GROUP BY company_id;"` on **prod**. **Step 2** — export master data only for the confirmed company: ingredients, suppliers, customers, formulations. ⚠ **Master data only — no transactions, no history, no lot numbers.** Mava re-enters it as a starting point rather than typing five years of setup. ⚠ **`SELECT ... INTO OUTFILE` does not work on RDS** — use `mysql -B` to write tab-separated output to a file, which opens in Excel. ⚠ **Formulations are the hard part** — recipes reference ingredients and sub-recipes by id across `subrecipematerials` and `subrecipeformulation`; a flat export loses those links. Ingredients, suppliers and customers are simple lists. Decide what "usable on the other side" means before writing the recipe query. ⚠ **Read-only throughout, on the dormant archive** |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

### THE ESTATE — sequenced

**Minty's ruling S138, still standing:** (1) restore email — **done S139**, (2) audit dependencies — **S140**, (3) move to abletrace.ca.

**Minty's ruling S139:** keep SES **and Route 53** in the old account. Everything else is a candidate. **S140 audits and deletes nothing. S141 acts on the list.**

⚠ **The abletrace.ca move has two reasons.** One app rather than two, and sending domain matching link domain — without which the phishing pattern remains in any future SES application.

### P245 Phase 3 — two clients, live books. Not S140 work.

**Clients do not get sandboxes.** Each client clicks Connect, signs in, approves, and gets a row in `quickbooks_tokens` under their company name. The company column was added S129, so this is two more rows, not a rebuild.

⚠ **The company must come from the logged-in session, never a parameter.** Both transaction routes and the status route currently use a hardcoded `sandbox260820`. ⚠ **P250 is a hard blocker** — there is no session company anywhere in the app.

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- Schema changes run on prod **separately**. ⚠ **Including the five `qb_*` columns and `companycustomers.external_id`, which exist on dev only.**
- **Role and task rows through the UI on prod, not by SQL.**
- A **Reconnect URL** is mandatory in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.
- ⚠ **Custom transaction numbers is per-client.**

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories. Today Minty sees everything because it is early; that is temporary, not the design.

**Direction, not to be built yet:** support access is **break-glass** — closed by default, client-consented, expiring, logged. Never standing.

⚠ **Consequence to accept:** when a client's connection breaks, Mintek cannot look. Which is why the failure-handling items are not optional.

**The four failure-handling items** — what remains of Phase 2.
1. ~~A status on every slip, always visible.~~ **Done S136–S138, on screen.**
2. The reason, in plain words, on the slip. ⚠ **The route already returns exactly these reasons; they are shown transiently and not stored.** Storing the last reason is the work.
3. A retry button. ⚠ **Send is blocked once `qb_estimate_id` is set — deliberate. A retry must clear a failed attempt without permitting a duplicate send.**
4. A list of slips shipped with no invoice number. ⚠ **This belongs on the QuickBooks tab** — the daily check, and where a silent failure would otherwise hide.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated, other food is not. Sandbox codes: 2 Exempt, 3 Zero-rated, 5 HST ON, 6 Out of Scope.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.
