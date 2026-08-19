# NOW

Written at the S127 close. Rewritten whole — see RULES 6.

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

**Dev carries an S127 test fixture. Keep it.** User id **1332**, `info@abletrace.ca`, created by the invite that proved the SES migration. It is the proof; do not sweep it.

**Dev's `.env` has an S127 backup**, `~/abletrace-lab-backend/.env.bak-S127`. Holds the **old account's** SES credentials. Keep until prod is cut over and proven, then delete with P227.

**The old AWS account is being wound down.** Minty's decision, S126.

---

## THE JOB — S128

### Finish the SES migration and close the last dependency

Three parts, strict order. Each gates the next.

**S127 proved the whole path on dev.** An invitation email sent through the new account's SES landed in `info@abletrace.ca` at 06:51. Credentials authenticate, the IAM policy permits the call nodemailer actually makes, delivery works. **The method below is proven, not proposed.**

---

### ⚠ OPEN S128 WITH THIS. IT DECIDES THE SESSION.

```
aws sts get-caller-identity --query Account --output text
aws sesv2 get-account --region ca-central-1 --query "{Prod:ProductionAccessEnabled,Review:Details.ReviewDetails.Status,Max24:SendQuota.Max24HourSend}" --output table
aws sesv2 get-email-identity --region ca-central-1 --email-identity abletrace.ca --query "{Verified:VerifiedForSendingStatus,Dkim:DkimAttributes.Status}" --output table
```

**CloudShell must read `208073623096`.** The old account is `350466202408`.

⚠ **THE TRAP THAT NEARLY LANDED IN S127.** Both accounts have `abletrace.ca` verified. The identity command returns `SUCCESS / True` from the old account and it looks exactly like the answer you want. **Read the account number first, every time.**

**Branch on the result:**

| Prod | Verified | do this |
|---|---|---|
| `True` | — | production access granted → **Part 2, the prod cutover** |
| `False` | `True` | → **Part 1, re-file**, then Part 3's fallback while it sits |
| `False` | `False` | ⚠ finding — see below |

---

## PART 1 — re-file production access

**Only when the domain reads `Verified: True`.** The first request was **DENIED** — case **178710371200148** — filed when the account had zero verified identities. Re-filing while it still reads unverified invites a second denial on the same case, and a third ask after two rejections is a harder conversation.

**The request text, as submitted S127 — reuse it, with the two additions marked:**

```
aws sesv2 put-account-details --region ca-central-1 --production-access-enabled --mail-type TRANSACTIONAL --website-url https://trace.mintekfoodsafety.com --contact-language EN --use-case-description 'AbleTrace Lab is a food safety traceability SaaS used by food manufacturers in Canada. Emails are transactional only: account invitations, password resets and production notifications sent to named staff at customer companies who have been provisioned in the system by their own administrator. There is no marketing, no bulk sending and no purchased lists. Expected volume is under 100 messages per day. Recipients are known business users, so bounce and complaint rates are expected to be near zero. The sending domain abletrace.ca is verified with DKIM and is actively sending. This account is a migration of an existing SES production workload from another AWS account owned by the same business.'
```

Two sentences differ from S127's: the domain is now stated as verified **and actively sending**. Both are true and both were false at the first ask.

Success prints nothing. Confirm with the `get-account` block above — expect `Review: PENDING`.

⚠ **If `Verified` is still `False` after 24h+**, that is a finding, not a wait. The three CNAMEs resolve publicly — confirmed S127 — so a long delay means something is wrong with what was published. Re-read the zone before re-filing anything.

---

## PART 2 — prod cutover

**Blocked until `Prod: True`.** Prod invites real client staff at their own addresses. Sandbox delivers only to verified recipients, so this genuinely cannot run earlier. Prod stays on the old account's SES until then and is safe there — the old account is not closing.

### Material — measured S127

**Prod's `.env` carries eight variables**, read on the box:

```
DATABASE_URL · SMTP_USER · SMTP_PASSWORD · FROM_EMAIL
S3_ACCESS_KEY · S3_SECRET · SESSION_SECRET · APP_BASE_URL
```

⚠ **S126's NOW said "both boxes carry the same nine variables, dev has IS_DEV_BOX extra." That was wrong.** Prod has **eight**; dev has **nine** including `IS_DEV_BOX`. The `grep -c .` check below fails on the wrong number otherwise.

**Both target names are identical to dev's**, so the proven method transfers exactly.

**The new credentials** are in Minty's Drive note.
Key ID `AKIATA4RHQY4AXV44ISY` — IAM user `abletrace-ses`, account 208073623096, created 2026-08-19 06:22 UTC. The secret is in that note and nowhere else. Never to screen, never to chat.

**Prod's invite link is clean — measured S127.** `config/env/production.js:24` reads
`UI_Base_Url: (process.env.APP_BASE_URL || 'https://trace.mintekfoodsafety.com') + '/'`
No old-account reference. Client emails are correct. **No code change is needed for this cutover.**

### The action — every step proven on dev in S127

**[PROD]** — check the prompt is red.

```
cd ~/abletrace-lab-backend && cp .env .env.bak-S128 && ls -la .env.bak-S128
```

```
vi .env
```

`vi` method, as it worked: arrow to `SMTP_USER=`, press **`A`** (capital) to append at end of line, backspace back to the `=`, paste the new value. `Esc`, arrow down to `SMTP_PASSWORD=`, `A`, backspace, paste. `Esc`, `:wq`, Enter.
Escape hatch: `Esc` `:q!` Enter — nothing saved.

⚠ **If `vi` warns about a swap file**, press **`Q`**, then check whether the stranded editor still lives with `ps -p <PID>`. If dead, `rm -f .env.swp`. Cost several exchanges in S127. An abandoned `vi` holding unsaved edits can later overwrite correct work.

**Verify — the second check is the one that can fail informatively:**

```
grep -c . .env && grep -o '^SMTP_USER=.\{0,20\}' .env
```

Expect **8** and `SMTP_USER=AKIATA4RHQY4AXV44ISY`.

```
[ "$(grep '^SMTP_PASSWORD=' .env)" = "$(grep '^SMTP_PASSWORD=' .env.bak-S128)" ] && echo "SAME - NOT CHANGED" || echo "CHANGED"
```

Expect **CHANGED**.

⚠ **Do not check the secret by length.** Old and new are both 40 characters — a length check passes either way and proves nothing. S127 wrote that check, it could not fail, and it had to be replaced.

**Restart:**

```
pm2 restart abletrace-backend --update-env
```

⚠ `--update-env` is load-bearing. Without it pm2 reuses the cached environment, the new credentials never load, and **the restart looks perfectly healthy**.

```
sleep 15 && pm2 status && curl -s -o /dev/null -w "%{http_code}\n" localhost:1337
```

Expect **200** and memory near **150mb**. Low memory with `000` is still booting — wait and repeat. Read the memory, not just the status.

### The verify — an email in an inbox

**A 200 proves nothing about email.** P240: a failed send returns nothing, logs nothing, and the screen looks normal. Receipt is the only proof.

**Proven trigger path, S127:** log in as super admin → **Add Company** → fill the form → **Send Invite**. Fires "You are invited to join Able Trace" from `info@abletrace.ca`.

Send to a real inbox and confirm arrival. Once production access is granted any address works; `info@abletrace.ca` is always safe.

⚠ **This writes a company and a user row to the clients' database.** Scope it, name it obviously, and decide before sending whether it is removed afterwards. Minty's call — it is his data.

---

## PART 3 — deactivate the old key

**Only after prod is proven by a received email.**

Deactivate, **not delete** — reversible in one click if anything surfaces.

**[CLOUDSHELL — OLD account 350466202408]**

```
aws iam list-access-keys --user-name ses --query "AccessKeyMetadata[].[AccessKeyId,Status,CreateDate]" --output text
```

Then, against the ID that matches the value in `.env.bak-S128`:

```
aws iam update-access-key --user-name ses --access-key-id <ID> --status Inactive
```

⚠ The IAM user name `ses` is from NOW's own record and is **not measured**. If the command errors, list users first.

This closes the second half of **P17** and ends the live app's last dependency on the old account.

---

## IF PART 2 IS BLOCKED

Likely. AWS review takes about a day and the re-file happens at the top of S128.

**Fallback: P241.** Small, measured, and in the same file family.

`config/env/development.js:7` reads:

```
UI_Base_Url : 'http://abletrace-development1.s3-website.ca-central-1.amazonaws.com/',
```

Hardcoded, and it **ignores `APP_BASE_URL` entirely** — which is why dev's invitation link pointed at an old-account S3 bucket even though dev's `APP_BASE_URL` reads `https://trace.mintekfoodsafety.com`.

**The fix is to match production.js's pattern**, which is correct:

```
UI_Base_Url: (process.env.APP_BASE_URL || 'https://dev.mintekfoodsafety.com') + '/',
```

Then set dev's `APP_BASE_URL` to `https://dev.mintekfoodsafety.com` — it currently reads prod's URL, harmlessly today only because nothing reads it.

`config/env/staging.js:2` has the same shape pointing at `stgapifrontend`. Staging is dead — leave it or strike it, Minty's call.

⚠ **This corrects S126's sweep.** The sweep concluded no old-account identifier was hardcoded anywhere. It searched for account IDs, key fragments and bucket names — never `s3-website`. The claim was narrower than it read.

Verify: re-send an invite on dev and read the link in the received email.

---

## OLD ACCOUNT — where the teardown stands

**Done at S126.** Deleted: RDS `newinstance` (with final snapshot), EC2 `devapi_windows` and `stgapi_windows`, three Elastic IPs, two stale Route 53 A records. About **$215 of a $256/month forecast** removed.

⚠ **The final snapshot of `newinstance` is the only copy of two years of departed-client traceability data.** Do not sweep it in a later tidy-up. Restoring it after 1 Aug 2026 puts that instance back on Extended Support pricing, so any restore is a short deliberate exercise.

**Done at S127.** Three DKIM CNAMEs added to the `abletrace.ca` zone for the new account. Change `C047799518UT618CC0POM`, applied 05:54 UTC. Additive only — nothing existing was touched.

**Still standing, and why:** old app EC2 + Elastic IP `3.98.223.126` (→ P233) · SES (→ P231, in progress) · Route 53 zone, holds the live Zoho mail records (→ P232) · CloudFront marketing site (→ P234) · old bucket `abletrace-fileuploads1` (→ P236).

### The zone — measured S127, for P232

**`abletrace.ca` is served by Route 53 in the old account.** Nameservers are `awsdns`; GoDaddy holds the registration and delegates. Zone **`Z0710124HPIPA4X553D7`**, 17 records before S127, 20 after.

**What is in it:** Zoho mail (MX, apex TXT, `_dmarc`, `zmail._domainkey`) · old-account SES (`_amazonses` TXT + five `_domainkey` CNAMEs — five is more than SES issues at once, so some are stale) · two ACM validation CNAMEs · three A records: apex, `www`, and **`prodapi.abletrace.ca`**.

⚠ **`prodapi.abletrace.ca` is a live A record almost certainly pointing at the old app box** — the one queued for teardown under P233. **The pointer goes first, the resource second.** P232 and P233 must be ordered against each other, and this record is why.

---

## QUEUE

Minty ranks. Claude never renumbers.

| | |
|---|---|
| **P231** | SES migration — **dev done and proven S127**. Prod blocked on production access |
| **P232** | DNS zone move. ⚠ order against P233 — see `prodapi` above |
| **P233** | Old app box teardown |
| **P234** | Marketing site |
| **P236** | Old bucket retention decision |
| **P237** | Section_3B.md full rewrite, after reading 3B.1, 3B.2, 3B.4 |
| **P230** | Fix `~/.my.cnf` |
| **P239** | Dead nodemailer block with plaintext credentials in git history |
| **P240** | `email.js` floating promise — failed sends invisible to app, logs and user |
| **P224** | Dev SSH IPv6 rule |
| **P225** | Sweep Mac Downloads |
| **P227** | Delete `node_modules.old-node18` on dev |
| **P241** | **NEW S127.** `development.js:7` hardcodes an old-account S3 website URL and ignores `APP_BASE_URL`. Dev-only; prod is clean |
| **P212** | Does RULES auto-load in the Abletrace project? ⚠ **Test at the S128 open** — see below |

**P235 — CLOSED.** Dev RDS engine version checked, S126.
**P242 — dissolved before it was filed.** Dev's `APP_BASE_URL` pointing at prod is harmless because `development.js` does not read it. Folded into P241.

---

## P212 — the test, at the S128 open

**Open S128 with `start s128` and paste nothing.** If Claude can quote a RULES line unprompted, RULES auto-loads from the project and pasting stops. If Claude asks for it, keep pasting.

Two seconds, and it closes a question open since S125.

⚠ S127 answered this wrongly at first — RULES had been pasted as the session's first message and Claude reported it missing while looking at it. **A memory contradicting a measurement in front of you.**

---

## TRAPS EARNED S127 — for the TRAPS file, Minty's approval

**1 · A command that never ran looks exactly like a zero result.** Pastes that arrive without a trailing newline sit on the prompt unexecuted; the next paste glues onto them, AWS rejects the joined string, and nothing runs. Happened three times. Twice the silence was nearly read as "no zones exist" and "no identities exist." **Ctrl+U before every paste, Enter after every paste, one command per block.**

**2 · The same command in two accounts returns the same answer for opposite reasons.** `get-email-identity abletrace.ca` returns `SUCCESS / True` in the old account and `PENDING / False` in the new. Read the account number before the measurement, not after.

**3 · An abandoned `vi` holds unsaved edits that can overwrite correct work later.** S127 found one from 06:30 with `modified: YES` still holding the file. `diff` against the backup proved nothing had been written.

**4 · A check whose two branches cannot differ is not a check.** Comparing secret *lengths* — old and new are both 40 characters. Third instance of this family in the record.

---

**The test: can the next session open NOW and start meaningful work?**
Yes. One command decides the branch, and both branches are fully specified.
