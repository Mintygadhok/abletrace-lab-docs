# NOW

Written at the S128 close. Rewritten whole — see RULES 6.

---

## STATE

What no command returns. Everything measurable is in the open check.

| | |
|---|---|
| prod's frontend git checkout lags the served build | by design. P8. Read the live build off the newest `www-html.bak-*` name |
| prod on Node 18, dev on Node 24 | dev runs a new engine for a while before prod is asked to. → P210 |
| CI builder on Node 20 | Angular 18 caps at 20, so parity is unreachable. Documented gap, S121. → P217 |

**Dev's backend tree is not clean, deliberately.** `git status` on dev's backend shows `?? node_modules.old-node18/` — the 303 MB Node-18 rollback tree sits *inside* the repo as an untracked directory. Nothing depends on it. This is the concrete reason RULES §2 forbids `git add .`. Delete on the next visit to dev. → P227

**Dev's ssh is fragile.** Dev's security group allows inbound 22 from **one IPv4 /32**, so the Mac drifting onto IPv6 locks you out of dev while prod still connects — that asymmetry is the tell. Always `ssh -4`; only `curl -4 ifconfig.me` gives the real source. → P224

**Dev carries an S127 test fixture. Keep it.** Company `info@`, user `info@abletrace.ca`, license status **Invited** — activation was never completed. It is the proof the SES migration delivers; do not sweep it. Its temporary password is collected from the inbox to complete activation, so an Invited row cannot sign in directly. That is the app working, not a defect.

**Dev's `.env` has two backups**, both in `~/abletrace-lab-backend/`: `.env.bak-S127` (old account's SES credentials) and `.env.bak-S128b` (pre-`APP_BASE_URL` change). Keep until prod is cut over and proven, then delete with P227. A code backup also sits at `/tmp/development.js.bak-S128` — temp, sweeps itself on reboot.

**The old AWS account is being wound down.** Minty's decision, S126.

**P212 is closed.** RULES does not auto-load in the Abletrace project — the project's searchable knowledge holds TRAPS, UNITS-BIBLE, Section_2, Section_3A, Section_5 and NOW, and no RULES. **Keep pasting RULES at the open.**

---

## WHAT S128 DID

**Part 1 of the SES migration is done.** DKIM verification succeeded 23:33 Aug 18. The production-access case **178710371200148** was answered in the AWS Support Center at **11:00:01 PDT Aug 19** with a full response to AWS's four questions. AWS states a 24-hour initial response.

⚠ **The API said DENIED while the email said "we need more information."** Both were true. The email is the softer face of the same decision. `get-account` is the arbiter; do not read the outcome off an email.

**P241 is deployed, not proven.** Dev's invitation link now reads `APP_BASE_URL`. Screen proof is blocked — see below.

**One finding.** The old dev bucket, absent from every teardown inventory — see below.

⚠ **And one false alarm worth remembering.** Claude raised a high-priority security item from an unread email subject line and its proximity to S126's teardown, without checking the record. It was `devapi.abletrace.ca`, already found and fixed in S126. **Proximity is not evidence. Check the record before ranking anything above live work.**

---

## ⚠ OPEN S129 WITH THIS. IT DECIDES THE SESSION.

**[CLOUDSHELL — NEW account]**, one command per block, Ctrl+U before each paste, Enter after.

```
aws sts get-caller-identity --query Account --output text
```

```
aws sesv2 get-account --region ca-central-1 --query "{Prod:ProductionAccessEnabled,Review:Details.ReviewDetails.Status,Max24:SendQuota.Max24HourSend}" --output table
```

**Must read `208073623096`.** The old account is `350466202408`. Both accounts have `abletrace.ca` verified, so an identity check alone cannot tell you which account you are in.

| Prod | do this |
|---|---|
| `True` | **THE JOB — prod cutover**, then P241's verify, then Part 3 |
| `False`, Review `PENDING` | AWS still reviewing → **P245, QuickBooks** |
| `False`, Review `DENIED` again | ⚠ finding. Read the case correspondence before re-filing anything, then → **P245** |

---

## THE JOB — prod cutover, when access is granted

Everything here was measured S127–S128. No re-derivation needed.

### Material

**Prod's `.env` carries eight variables:**

```
DATABASE_URL · SMTP_USER · SMTP_PASSWORD · FROM_EMAIL
S3_ACCESS_KEY · S3_SECRET · SESSION_SECRET · APP_BASE_URL
```

Dev has **nine** — `IS_DEV_BOX` extra. The `grep -c .` check below fails on the wrong number.

**The new credentials** are in Minty's Drive note. Key ID `AKIATA4RHQY4AXV44ISY` — IAM user `abletrace-ses`, account 208073623096, created 2026-08-19 06:22 UTC. The secret is in that note and nowhere else. Never to screen, never to chat.

**Prod needs no code change.** `config/env/production.js:24` reads
`UI_Base_Url: (process.env.APP_BASE_URL || 'https://trace.mintekfoodsafety.com') + '/'`
Measured S127. Client invitation links are correct.

### The action — every step proven on dev

**[PROD]** — check the prompt is red.

```
cd ~/abletrace-lab-backend && cp .env .env.bak-S129 && ls -la .env.bak-S129
```

```
vi .env
```

`vi` method as it worked: arrow to `SMTP_USER=`, press **`A`** (capital) to append at end of line, backspace back to the `=`, paste the new value. `Esc`, arrow down to `SMTP_PASSWORD=`, `A`, backspace, paste. `Esc`, `:wq`, Enter.
Escape hatch: `Esc` `:q!` Enter — nothing saved.

⚠ **If `vi` warns about a swap file**, press **`Q`**, then check whether the stranded editor still lives with `ps -p <PID>`. If dead, `rm -f .env.swp`. An abandoned `vi` holding unsaved edits can later overwrite correct work.

**Verify:**

```
grep -c . .env && grep -o '^SMTP_USER=.\{0,20\}' .env
```

Expect **8** and `SMTP_USER=AKIATA4RHQY4AXV44ISY`.

```
[ "$(grep '^SMTP_PASSWORD=' .env)" = "$(grep '^SMTP_PASSWORD=' .env.bak-S129)" ] && echo "SAME - NOT CHANGED" || echo "CHANGED"
```

Expect **CHANGED**.

⚠ **Do not check the secret by length.** Old and new are both 40 characters — a length check cannot fail and proves nothing.

**Restart:**

```
pm2 restart abletrace-backend --update-env
```

⚠ `--update-env` is load-bearing. Without it pm2 reuses the cached environment, the new credentials never load, and **the restart looks perfectly healthy**. Confirmed on dev in S128: 18mb at restart, 252mb eight seconds later is a correct boot.

```
sleep 15 && pm2 status && curl -s -o /dev/null -w "%{http_code}\n" localhost:1337
```

Expect **200** and memory near **150mb**. `000` with low memory is still booting.

### The verify — an email in an inbox

**A 200 proves nothing about email.** P240: a failed send returns nothing, logs nothing, and the screen looks normal. Receipt is the only proof.

**Trigger path, proven S127:** log in as super admin → **Add Company** → fill the form → **Send Invite**. Fires "You are invited to join Able Trace" from `info@abletrace.ca`.

⚠ **This writes a company and a user row to the clients' database.** Name it obviously, and decide before sending whether it is removed afterwards. Minty's call — it is his data.

---

## PART 3 — deactivate the old key

**Only after prod is proven by a received email.** Deactivate, **not delete** — reversible in one click.

**[CLOUDSHELL — OLD account 350466202408]**

```
aws iam list-access-keys --user-name ses --query "AccessKeyMetadata[].[AccessKeyId,Status,CreateDate]" --output text
```

Then, against the ID matching the value in prod's `.env.bak-S129`:

```
aws iam update-access-key --user-name ses --access-key-id <ID> --status Inactive
```

⚠ The IAM user name `ses` is from NOW's own record and is **not measured**. If the command errors, list users first.

This closes the second half of **P17** and ends the live app's last dependency on the old account.

---

## P241 — deployed, not proven

**The change, made and verified on the box S128.** `config/env/development.js:7` now reads:

```
  UI_Base_Url: (process.env.APP_BASE_URL || 'https://dev.mintekfoodsafety.com') + '/',
```

and dev's `.env` line 8 reads `APP_BASE_URL=https://dev.mintekfoodsafety.com`. `grep -c . .env` returns **9**. Restarted with `--update-env`, 200. Committed and pushed: dev backend `99852bf → 4095344`.

**What is not proven:** that an invitation email now carries the new link. Blocked because the new account's SES is in sandbox and delivers only to `info@abletrace.ca`; mailinator addresses bounce (`MAILER-DAEMON`, Aug 12). `info@abletrace.ca` is already consumed by the S127 fixture and the app will not take it for a second company.

⚠ **The backend log does not print the constructed URL.** Checked S128 — `pm2 logs` carries only Waterline `createdAt`/`updatedAt` warnings. There is no log route to the proof.

**So the verify rides on production access.** Once granted, send a dev invitation to any address and read the link. Expect `https://dev.mintekfoodsafety.com`. One minute's work, appended to the prod cutover session.

**Related, unresolved:** `config/env/staging.js:2` has the same hardcoded shape pointing at `stgapifrontend`. Staging is dead — leave it or strike it, Minty's call.

---

## The old dev bucket — closed, for the record

**`abletrace-development1` is a live old-account S3 website**, returning 200 and serving a **different build** from dev proper (md5 `19bf7a28…` against dev's `871ba2e4…`). Dev proper is nginx on `16.55.10.205` serving `/var/www/html`, proxying `/api/` to `localhost:1337`.

**It has no link to the new account.** Its only pointer was the hardcoded URL in dev's `development.js`, which S128 fixed. It dies when the old account closes.

⚠ **The finding worth keeping is that it was missing from every teardown inventory.** S126's sweep searched for account IDs, key fragments and bucket names and concluded the code was clean; the string in the code is a *website endpoint*, so the sweep's claim was narrower than it read. **Second time that sweep has been found narrow.**

Add to the teardown checklist. No session required. Minty's ruling, S128.

---

## P245 — QuickBooks Online integration

**Scoped S128 with Minty. Not started.** This is the substantial job available whenever SES is blocked.

**Decided:** QuickBooks **Online**, not Desktop. Minty already holds a QuickBooks account and a sandbox.

**The sandbox, measured S128:** company `Sandbox Company US 80fd`, **realm ID `9341457628433780`**, SKU **Plus**, features Accounting + Payments, created 30 Jul 2026. The realm ID is needed on every API call.

⚠ **The sandbox region is US.** If the real books are Canadian, sales tax behaves differently — and tax is exactly where invoice generation gets fiddly. **Confirm before writing the shipping side**, not after.

**The sandbox, measured S128:** company `Sandbox Company US 80fd`, **realm ID `9341457628433780`**, SKU **Plus**, features Accounting + Payments, created 30 Jul 2026. The realm ID is needed on every API call.

⚠ **The sandbox region is US.** If the real books are Canadian, sales tax behaves differently — and tax is exactly where invoice generation gets fiddly. **Confirm before writing the shipping side**, not after.

**Two integration points, shipping-side first by Minty's ruling:**

1. **Shipping → invoice.** ⚠ **One packing slip, one invoice.** The warehouse person selects which DOs ride on one truck; **the selected DO lines move onto the packing slip whole, with all their information.** So the slip already carries everything the invoice needs — the invoice reads what is assembled there rather than gathering it back from the DOs. Minty's ruling, S128.
2. **Receiving → bill.** Materials received against a PO push into QuickBooks for the payable. Second, and lower value.

⚠ **RULES §7 governs the quantities.** A packing slip moves no stock — the movement already happened at the DO. The invoice reads quantities committed earlier, and reads them as **units**. Never derived from weight.

**The step order, agreed:**

1. Register a developer app at Intuit → client id and secret
2. Build the OAuth connection — one-time authorisation, stored refresh token. **A credentials job**: new secrets, new rotation path, Section 4 grows
3. Settle the product mapping — how an AbleTrace product finds its QuickBooks item, and who maintains it when a product is added. **This is the hard part, not the API**
4. Build shipping → invoice
5. Test in the QuickBooks sandbox before anything touches real books
6. Receiving → bill, later

**Open question, not yet decided:** push at the moment of shipping, or a nightly batch. Push is immediate and fails loudly; batch is re-runnable. ⚠ Weigh this against **P240** — the app currently cannot tell anyone when a send fails. Silent failure is tolerable for an email and is not tolerable for an invoice.

**Sandbox credentials reach the dev box by file, never through chat.**

---

## OLD ACCOUNT — where the teardown stands

**Done S126.** Deleted: RDS `newinstance` (with final snapshot), EC2 `devapi_windows` and `stgapi_windows`, three Elastic IPs, two stale Route 53 A records. About **$215 of a $256/month forecast** removed.

⚠ **The final snapshot of `newinstance` is the only copy of two years of departed-client traceability data.** Do not sweep it. Restoring it after 1 Aug 2026 puts that instance back on Extended Support pricing, so any restore is a short deliberate exercise.

**Done S127.** Three DKIM CNAMEs added to the `abletrace.ca` zone for the new account. Change `C047799518UT618CC0POM`. Additive only.

**Still standing:** old app EC2 + Elastic IP `3.98.223.126` (→ P233) · SES (→ P231) · Route 53 zone, holds the live Zoho mail records (→ P232) · CloudFront marketing site (→ P234) · bucket `abletrace-fileuploads1` (→ P236) · **bucket `abletrace-development1` (→ P243, newly found)**.

### The zone — measured S127, for P232

**`abletrace.ca` is served by Route 53 in the old account.** GoDaddy holds the registration and delegates. Zone **`Z0710124HPIPA4X553D7`**, 20 records.

**Contents:** Zoho mail (MX, apex TXT, `_dmarc`, `zmail._domainkey`) · old-account SES (`_amazonses` TXT + five `_domainkey` CNAMEs — five is more than SES issues at once, so some are stale) · two ACM validation CNAMEs · three A records: apex, `www`, and **`prodapi.abletrace.ca`**.

⚠ **`prodapi.abletrace.ca` is a live A record almost certainly pointing at the old app box** — the one queued under P233. **The pointer goes first, the resource second.** P232 and P233 must be ordered against each other, and this record is why. P244 may reach this first.

---

## QUEUE

Minty ranks. Claude never renumbers.

**Minty's ranking, S128: QuickBooks first. The teardown items are parked and come after it.**

| | |
|---|---|
| **P231** | SES migration — dev done S127, prod blocked on production access |
| **P241** | Dev invitation link — **deployed S128, not proven.** Verify rides on production access |
| **P245** | **NEW S128.** QuickBooks Online integration, shipping side first. Scoped, not started. **The job to run whenever SES is blocked** |
| **P232** | DNS zone move. ⚠ order against P233 |
| **P233** | Old app box teardown |
| **P234** | Marketing site |
| **P236** | Old bucket `abletrace-fileuploads1` retention decision |
| **P237** | Section_3B.md full rewrite, after reading 3B.1, 3B.2, 3B.4 |
| **P230** | Fix `~/.my.cnf` |
| **P239** | Dead nodemailer block with plaintext credentials in git history |
| **P240** | `email.js` floating promise — failed sends invisible to app, logs and user. ⚠ read before deciding P245's push-vs-batch |
| **P224** | Dev SSH IPv6 rule |
| **P225** | Sweep Mac Downloads |
| **P227** | Delete `node_modules.old-node18` and the `.env` backups on dev |

**P212 — CLOSED S128.** RULES does not auto-load. Keep pasting.
**P235 — CLOSED S126.** Dev RDS engine version checked.
**P243 — PARKED S128.** The old-account bucket has no link to the new account. Its only pointer was dev's code, now fixed. It dies when the account closes. Held on the teardown checklist, addressed after QuickBooks. Minty's ruling, S128.
**P244 — CANCELLED S128.** The subdomain takeover was `devapi.abletrace.ca`, found and fixed in S126. Nothing left to return to. Claude raised it from an unread subject line without checking the record.

---

## TRAPS EARNED S127–S128 — for the TRAPS file, Minty's approval

**1 · A command that never ran looks exactly like a zero result.** Pastes arriving without a trailing newline sit on the prompt unexecuted; the next paste glues onto them and AWS rejects the joined string. Happened three times in S127, twice nearly read as "no zones exist" and "no identities exist." **Ctrl+U before every paste, Enter after, one command per block.**

**2 · The same command in two accounts returns the same answer for opposite reasons.** `get-email-identity abletrace.ca` returns `SUCCESS / True` in both accounts. Read the account number before the measurement, not after.

**3 · An abandoned `vi` holds unsaved edits that can overwrite correct work later.**

**4 · A check whose two branches cannot differ is not a check.** Comparing secret *lengths* — both 40 characters. Third instance of this family.

**5 · `grep -r` silently skips symlinks. Capital `-R` follows them.** S128: `grep -rn server_name /etc/nginx/sites-enabled/` returned empty because the directory holds only a symlink. Read as "dev has no site config"; dev had one, active, correct. **An empty result needs a reason before it becomes a fact.** Same family as trap 1, different mechanism.

**6 · An email about a decision is not the decision.** AWS emailed "we would like to gather more information" while the API read `DENIED`. Both from the same review. The API is the arbiter.

---

**The test: can the next session open NOW and start meaningful work?**
Yes. Two commands decide the branch. Both branches are fully specified, and the fallback branch has its own homework done.
