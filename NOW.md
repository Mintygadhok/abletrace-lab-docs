# NOW

Rewritten whole at the close of S138.
Read RULES.md and this file. Nothing else at the open.

**S139 restores email.** Nothing can be onboarded until it works. The path the app uses to send is measured and quoted below; what the old AWS account can actually do is **not**, and that is step one rather than an assumption.

---

## STATE

What no command returns.

**Dev backend is `0948476`** — both QuickBooks transaction routes, committed and pushed. Nothing half-done.

**Dev frontend deployed and PROVEN ON SCREEN.** The QuickBooks block renders on PS-0032 showing status `invoiced`, estimate 1005, invoice 1017.
```
/home/ubuntu/www-html.bak-dev-d770204085dbb138303ec6decbd3bd73a05c4a8b     rollback
```

⚠ **The backup convention is now proved from the script itself, not inferred.** `deploy-frontend.sh` copies live → backup **before** swapping, so the newest backup's *name* is the build going IN and its *contents* are the build coming OUT. Read the script if this is ever doubted again; it is eleven lines.

**Dev frontend repo reads `d7702040`.** It matches the deployed build today, which is a coincidence of having just pushed — the Mac is the arbiter for frontend, not dev's checkout.

**SES — AWS answered 22 Aug and REFUSED.** Case `178710371200148`, new account `208073623096`. Concerns they would not specify, citing security.

⚠ **The old account 350466202408 cannot be torn down.** Production SES exists only there.

⚠ **Minty's reading, S138: this is now a business stop.** New clients cannot be onboarded without account-invitation email. It outranks everything else on the queue.

**Prod untouched since before S130, on Node v18.** Both deliberate. No QuickBooks anything on prod until Phase 3.
```
/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
```

**Both boxes report "system restart required."** Noted S135, still not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Stray QuickBooks estimate 183** sits in the sandbox with no number — the first send, made while Custom transaction numbers was on. Harmless. Delete in QuickBooks whenever.

**PS-0032 is a spent fixture.** It holds a real estimate and invoice and the route refuses a second send. To exercise the *button*, clear it first — the command is in the material.

---

## THE JOB — S139

**Get email sending again, from the old AWS account, proven by a message arriving.**

### The action, in order

1. **Measure the old account's SES.** Which region, which verified identities, and is it out of the sandbox? ⚠ **Nothing below matters if the answer is no.** Console, not code.
2. **Confirm which domain is verified there** — `mintekfoodsafety.com` or `abletrace.ca` or both. This decides what `FROM_EMAIL` may be.
3. **Create a fresh IAM user** in the old account, `ses:SendRawEmail` only, nothing else. New keys. ⚠ **Not the old keys** — two of those are still valid and sit in git history (P17), and the point of this exercise is that nothing carries over.
4. **Put the new key id and secret into dev's `.env`** as `SMTP_USER` and `SMTP_PASSWORD`. Restart, `sleep 8`, curl.
5. **Send one real invitation** from the app to a mailinator address and watch it arrive. Deployed is not proven.
6. **Then, and only then, the dependency audit** — what else in the old account is still load-bearing. Write findings; change nothing.

⚠ **Prod's `.env` is a separate file on a separate box.** Deploying does not carry it. Dev first, prod deliberately, not in the same breath.

---

### The material

Measured in S138. The command and its return are beside each.

#### How the app actually sends

⚠ **`SMTP_USER` and `SMTP_PASSWORD` are NOT SMTP credentials.** They are an AWS IAM key id and secret. The app uses the AWS SDK, not an SMTP server. A rotation is an IAM key rotation.

```
grep -rn "host\|region\|port\|secure\|service" ~/abletrace-lab-backend/api/services/email.js | grep -vi "pass\|secret\|user" | head -15
```
```
7:  region: 'ca-central-1'
47: exports.sendSESMail = (mailContent) => {
83:  const transporter = nodemailer.createTransport({SES});
101: exports.sendGroupMail = (mailContent) => {
```
⚠ **Region is hardcoded `ca-central-1`** at line 7 — not an environment variable. If the old account's verified identity lives in another region, this line is the change, and it is a code change requiring a commit.

⚠ Lines 13–31 are a **commented-out Zoho SMTP transport**, dead. Do not read it as the live path.

Two senders exist: `sendSESMail` (47) and `sendGroupMail` (101). Both need to work.

```
grep -rln "nodemailer\|createTransport\|SMTP_USER\|sendEmail" ~/abletrace-lab-backend/api ~/abletrace-lab-backend/config
```
```
api/services/email.js
config/env/local.js
config/env/development.js
config/env/staging.js
config/env/production.js
```

#### What is in dev's .env — names only

```
cut -d= -f1 ~/abletrace-lab-backend/.env | grep -v '^$' | tr '\n' ' '; echo
```
```
DATABASE_URL SMTP_USER SMTP_PASSWORD FROM_EMAIL S3_ACCESS_KEY S3_SECRET
SESSION_SECRET APP_BASE_URL IS_DEV_BOX QUICKBOOKS_CLIENT_ID QUICKBOOKS_CLIENT_SECRET
```
⚠ **`FROM_EMAIL` must match a verified identity in whichever account is sending.** Its current value was deliberately not printed and is unmeasured.

#### The deploy script — it is NOT called promote.sh

⚠ **NOW carried the wrong name from S136 to S138.** There is no `promote.sh` on dev.

```
~/deploy-frontend.sh <label>
```
Wants an **unpacked** folder at `~/dist-<label>`. ⚠ `unzip` is not installed:
```
cd ~ && python3 -c "import zipfile; zipfile.ZipFile('<zip>').extractall('<dir>')"
```
The dev artifact is flat — no wrapper folder. The label is the artifact name minus `dist-`, and the GitHub artifact carries the **full 40-character sha**, not the short one. Dev is `16.55.10.205`.

#### Clearing PS-0032 to re-test the buttons

⚠ Live write. Dev only. Scoped by id **and** company.
```
mysql abletracelab_live -e "UPDATE packingslips SET qb_estimate_id=NULL, qb_estimate_no=NULL, qb_invoice_id=NULL, qb_invoice_no=NULL, qb_send_status='not_sent' WHERE id=2417 AND company_id=464;"
```

#### Reaching a guarded route from curl

`isAuth` checks only that the bearer token matches a `user.webToken` — measured at `api/policies/isAuth.js:24`. No password needed, and the token never reaches the screen:
```
TK=$(mysql abletracelab_live -N -B -e "SELECT webToken FROM user WHERE id=1319;"); echo "token length: ${#TK}"
```
User 1319 is `test260703@mailinator.com`. ⚠ Lower case `bearer` for AbleTrace. The variable dies on disconnect.

---

### The analysis

#### What is known about the SES problem

**AWS refused production access on the new account.** The last reply we sent was already detailed. Re-sending the same case will not move them.

**Two things in that reply are the likely cause**, and both are fixable:

1. **"We do not currently have an automated process for handling bounces or complaints."** This is the criterion AWS weighs most heavily and the letter states plainly that it is not met. → **P257.**
2. **The From domain and the link domain do not match.** Sent from `abletrace.ca`, link goes to `trace.mintekfoodsafety.com`. That pattern is a phishing signal to an automated reviewer. → fixed by the estate move.

**A third point needs correcting whenever we next write to AWS:** the earlier reply said the old account was being closed. That is no longer true.

⚠ **Consequence for the order of work.** The domain move is not cosmetic tidying — it is part of what makes the SES case winnable. But it does **not** block S139, which is about restoring service on the account that already works.

**An appeal was drafted in S138 offering the two changes as commitments.** Whether it was sent is unrecorded here — ask Minty.

#### What is NOT known, and must not be assumed

- Whether the old account's SES is in **ca-central-1**. If not, `email.js:7` is a code change.
- **Which identity is verified there**, and whether it is a domain or a single address.
- Whether the old account is genuinely **out of the SES sandbox**. It sent before, so probably — but "probably" is not a measurement, and a sandbox account fails only on unverified recipients, which a mailinator test would expose immediately.
- The current value of `FROM_EMAIL`.

#### The permission to grant the new IAM user

`ses:SendRawEmail` is what nodemailer's SES transport calls. Grant that and nothing else. ⚠ **Resist granting `ses:*`** — the whole point of Minty's S135 ruling is that the old account becomes single-purpose with nothing carried over.

---

### The verify

1. The old account's SES console shows a verified identity and **not** "sandbox".
2. `pm2 restart abletrace-dev`, `sleep 8`, curl returns 200 with the new keys in place.
3. **An invitation email actually arrives** at a mailinator address, sent from the app, opened and read.
4. The link in it works.

⚠ Item 3 is the job. Items 1 and 2 are only the route to it.

---

## WHAT S138 CHANGED

**Backend `0948476`** — `POST /api/quickbooks/send-estimate` and `GET /api/quickbooks/invoice-number/:id`, plus two lines in `config/routes.js`.

**Frontend `d7702040`, deployed and proven** — the QuickBooks block on the packing slip screen, plus two calls on `QuickbooksService`.

**The round trip, measured end to end on PS-0032:** estimate **1005** created → converted by hand in QuickBooks → invoice **1017** fetched back → row 2417 holds all five values, status `invoiced`.

**Three unknowns closed:**
- **Intuit requires `Line.Amount`.** Fault 2020. Sending no price at all is not available to us.
- **QuickBooks Canada requires a tax code on every line.** Fault 6000. ⚠ **The QuickBooks screen fills this in from the item automatically; the API does not.** The interface is more forgiving than the connection.
- **The line description survives estimate → invoice conversion.** S137's open question. Proved by reading the invoice back: `PS-0032 · QB PO-001 — Testpdtqb260820`.

**The design principle held.** Price and tax are both read off the client's own QuickBooks *item* and relayed unchanged. AbleTrace holds neither.

**A settings trap found and fixed.** `CustomTxnNumbers: true` makes QuickBooks return an estimate with **no number and no error**. Turned off in the sandbox; verified `false` by reading preferences back.

**Sandbox settings changed:** Custom transaction numbers → off.

**Nothing on prod.**

---

## THINGS THAT COST TIME IN S138

**`promote.sh` does not exist.** NOW said it did, for three sessions. It is `deploy-frontend.sh` and takes a label argument. ⚠ **A name carried in a document is not a measurement.**

**A patch script was written with a nonsense line** — a ternary whose branches were identical. Caught on re-reading before it left the container, not by any check. ⚠ **`node --check` proves a file parses, never that it is correct.**

**An `scp` stalled at 1%** on the 14MB artifact. Retrying worked. Not a fault.

**The first `scp` of a patch was skipped**, and the failure surfaced one step later as "no such file". ⚠ Run the Mac block before the dev block that depends on it.

---

## TRAPS CARRIED FORWARD — all look like broken code

**QuickBooks Canada refuses any transaction with no tax code on a line**, and refuses any line with no Amount. Both faults are ValidationFaults with useful text in the response *body*, never in the error message. ⚠ **Always log `err.response.data`, truncated. The `message` alone says nothing.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.** ⚠ Per-client setting — a client with it on behaves the same way. Phase 3 support case, not a sandbox quirk.

**The QuickBooks access token expires in hours.** A hand-run script reading it from the table hits 401 mid-session. **Load `dev.mintekfoodsafety.com/quickbooks` in Chrome first** — that page refreshes and writes back. The real routes call the service and do not have this problem.

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails. Use a shell variable.

**A master role row created by SQL grants nothing.** The app's creation path copies every `role_task` into `company_user_task`; SQL runs no application code. The row is indistinguishable from a working one. ⚠ **Phase 3: role and task rows on prod must be created through the UI.**

**A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs. Only the body distinguishes them.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

**`formulations` has no `name` column — it is `title`.**

**`shipped_flag` is the ship gate, not `status_id`.** Measured S138: an unshipped slip carries `status_id` 1 too.

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P17 | Two old-account IAM keys still valid and in git history, deliberately. **Belongs to the estate job** |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. **Phase 2 prerequisite.** Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks integration — **Phase 2 core is DONE and proven.** What remains is the four failure-handling items below. Phase 3 detail kept at the foot |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22 pending. Both report "system restart required." Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only and empty after a page load. Affects every route |
| P250 | **Authorization is enforced by the screen, not the server. BLOCKER FOR PHASE 3.** `PackingSlips.js` lines 74, 148, 250, 354 take `company_id` straight from `req.body`. The browser says which company; the server believes it. Menu, tabs and roles are sound, but the rule lives in the browser. Harmless today; unacceptable with two real clients on one server. The job is *make the server derive the company from the session and filter every route by it* |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| P252 | **External ID duplicate guard, customers and products together.** `createCustomer` already checks `company_id` + `customer_name`; that is the pattern to extend. ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Every `scp` needs the IP typed. Two lines in `~/.ssh/config` |
| P254 | **A sales order cannot be edited once created.** Whether deliberate or a gap is a business question |
| P256 | **Dev home is full of dead build folders.** ~50 going back to S63. ⚠ **Keep `www-html.bak-dev-d770204085dbb138303ec6decbd3bd73a05c4a8b` (the live rollback) and one prior.** Also the S138 patch scripts and `.bak-s138*` files on both Mac and dev |
| P257 | **Automated bounce and complaint handling.** SNS topic on SES bounce/complaint, permanent suppression of hard bounces and complaints, alerting on rate. ⚠ **Required for any SES re-application to succeed** — its absence is stated in writing in our last reply to AWS. Overlaps P240 |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

### PENDING — the estate. Unranked; sequenced behind S139.

**Minty's ruling S138: the order is (1) restore email, (2) audit dependencies, (3) move to abletrace.ca.** Two sessions minimum after S139.

**Minty's ruling S135 stands:** keep the old account **for SES and nothing else**. Strip every other service. Fresh credentials so nothing carries over. A single-purpose mail sender, not "the old estate we never finished leaving."

⚠ **The abletrace.ca move now has a second reason.** Sending domain and link domain must match, or the phishing pattern remains in any future SES application.

**Three things must be measured. None are known:**
1. **What can old-account SES actually do?** Region, verified identities, sandbox or production. **S139 step 1.**
2. **Route 53 is inside the old account** (RULES §4). If DNS stays there, the account is not email-only.
3. **Is the refusal final?** An appeal was drafted S138 offering bounce handling and domain alignment as commitments.

⚠ **RULES, before removing infrastructure:** ask **what still points at this?** — DNS records, credentials, other AWS settings, accounts outside AWS. **The pointer goes first, the resource second.** ⚠ **A code search cannot find these.**

### P245 Phase 3 — two clients, live books. Not S139 work.

**Clients do not get sandboxes.** Each client clicks Connect, signs in, approves, and gets a row in `quickbooks_tokens` under their company name. The company column was added from the start (S129), so this is two more rows, not a rebuild.

⚠ **The company must come from the logged-in session, never a parameter.** Both new routes and the status route currently use a hardcoded `sandbox260820`. ⚠ **Not possible until P250 is done** — there is no session company anywhere in the app. **P250 is a hard blocker.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- Schema changes run on prod **separately**. ⚠ **Including the five `qb_*` columns and `companycustomers.external_id`, which exist on dev only.**
- **Role and task rows through the UI on prod, not by SQL.**
- A **Reconnect URL** is mandatory in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.
- ⚠ **Custom transaction numbers is per-client.** A client with it on gets estimates with no number and no error. Check it at onboarding, or handle it as a named failure reason.

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories. Today Minty sees everything because it is early; that is temporary, not the design.

**Direction, not to be built yet:** support access is **break-glass** — closed by default, client-consented, expiring, logged. Never standing.

⚠ **Consequence to accept:** when a client's connection breaks, Mintek cannot look. Which is why the failure-handling items are not optional.

**The four failure-handling items** — what remains of Phase 2.
1. ~~A status on every slip, always visible.~~ **Done S136–S138, on screen.**
2. The reason, in plain words, on the slip — customer not found, product not set up, no price, no tax code, connection dead. ⚠ **The route already returns exactly these reasons; they are shown only transiently and are not stored.** Storing the last reason is the work.
3. A retry button. Most failures are fixed in QuickBooks, then re-sent. ⚠ **Send is currently blocked once `qb_estimate_id` is set — deliberate. A retry must clear a failed attempt without permitting a duplicate send.**
4. A list of slips shipped with no invoice number. The daily check, and where a silent failure would otherwise hide.

⚠ **Silence is the fragile part.** A connection dies for reasons nobody controls. Under any ownership model the failure is invisible unless the slip says so.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated, other food is not. The sandbox's codes: 2 Exempt, 3 Zero-rated, 5 HST ON, 6 Out of Scope.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.
