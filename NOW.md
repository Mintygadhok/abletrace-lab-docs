# NOW

Rewritten whole at the close of S131.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply to AWS's four questions on 19 Aug. Nothing to do until AWS answers. Not touched in S130 or S131.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` for as long as the reply sits unread. It is not a second refusal. Read the CaseId alongside it — if the CaseId is still `178710371200148`, no new review has been opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

**Old account 350466202408 — teardown parked.** SES is the only remaining live dependency. Everything else is gone. Blocked until SES migration completes. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Dev backend carries `?? node_modules.old-node18/`.** Deliberate — P227. A dirty tree line that is not a finding.

**Prod's git checkout lags the served build.** Deliberate — P8. The `www-html.bak-*` line in the open check is the only reliable read of what is live.

**RULES.md edit applied and pushed.** Docs repo `9a23cbb`. Rule 6 now has two parts — writing NOW, then filing NOW. Rule 1 gained *Design before writing* and the passing-guard warning. Nothing outstanding.

**P245 Phase 1 — connect and callback done and proven. Refresh not built. Dev only, prod untouched.**

Backend `4ed6d03`. What works, proven on screen this session:
- `GET /api/quickbooks/connect` returns the authorize URL as JSON, guarded by `isAuth`
- `GET /api/quickbooks/callback` completes the exchange, public, state-guarded
- one row in `quickbooks_tokens`, company `sandbox260820`, realm `9341457751382548`
- the stored access token reads live company data back from QuickBooks

⚠ **The access token in that row expired at 2026-08-20 20:34 UTC.** Expected — there is no refresh helper yet. Nothing depends on it, nothing is broken. To get a live token again, call connect and click through Intuit once. Ten seconds.

⚠ **The S130 design fault is fixed.** connect no longer redirects. Do not reintroduce a redirect there — the reason is in the controller's doc comment and in TRAPS.

---

## THE JOB — S132

Build the refresh helper.

### 1 · The task

1. **Write one refresh function.** One place, one caller path. Every future QuickBooks call goes through it.
2. **Design the race guard first.** See the analysis. This is the whole risk of the job.
3. **Always write back the newest refresh token**, on every refresh, without exception.
4. **Prove it** — force a refresh and watch the stored refresh token value change.
5. **Prove the old token dies** — the previous refresh token must be rejected by Intuit afterwards.

⚠ **Do not build the settings screen in S132.** That is S133 and it is a full session. Scope discipline.

### 2 · How it is verified

**The `refresh_token` value in `quickbooks_tokens` is different before and after a forced refresh, and the row's `access_expires_at` moves forward by an hour.**

Compare by hash, not by eye — the value must not reach the screen:

```
mysql -N -B abletracelab_live -e "SELECT MD5(refresh_token), access_expires_at FROM quickbooks_tokens WHERE company='sandbox260820';"
```

Run it before, force the refresh, run it after. Both fields must change.

Second verify, and the more important one: **the superseded refresh token is dead.** Capture it before the refresh, try it after, and Intuit must return `invalid_grant`. If the old one still works, the write-back is not doing what it claims.

### 3 · What the job requires

**The token endpoint — same URL as the code exchange, different grant_type**

```
POST https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer
```

Already a constant in the controller: `TOKEN_URL`.

- Body: `grant_type=refresh_token&refresh_token=<the stored one>`
- Header: `Authorization: Basic ` + base64 of `client_id:client_secret`
- Header: `Content-Type: application/x-www-form-urlencoded`
- Header: `Accept: application/json`

**What comes back** — a new `access_token`, a new `refresh_token`, `expires_in`, and `x_refresh_token_expires_in`. All four are stored. The refresh token comes back on *every* refresh and the old one is dead the moment the new one is issued.

**The API base — measured S131, and it is host-specific not path-specific**

```
https://sandbox-quickbooks.api.intuit.com
```

Company info path, both ids are the realm:

```
/v3/company/9341457751382548/companyinfo/9341457751382548
```

⚠ Intuit's own API wants `Authorization: Bearer` with a **capital B**. AbleTrace's `isAuth` wants lower-case `bearer`. They are different systems and both are right. Do not unify them.

**Credentials — dev `.env`, in place and unchanged**
- `QUICKBOOKS_CLIENT_ID` — 50 chars
- `QUICKBOOKS_CLIENT_SECRET` — 40 chars
- Re-readable at Intuit: Keys and credentials → Development → Show credentials. Also in Section H.

**The row as it stands**

```
id 1 · company sandbox260820 · realm_id 9341457751382548
access_token 603 chars · refresh_token 41 chars
access_expires_at 2026-08-20 20:34:06  (expired, expected)
refresh_expires_at 2026-11-29 19:34:06
connected_at 2026-08-20 19:34:06
```

**Getting a live connection again**, needed before anything can be refreshed:

```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;") && curl -s -H "authorization: bearer $TOK" localhost:1337/api/quickbooks/connect
```

Paste the returned URL into a browser, pick `Sandbox Company CA 26d2`, consent. Do not restart dev in between — states live in memory.

**The super-admin token, for any guarded curl**

Read it out of the row. Never type a password into a command.

```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;")
```

Header form is `authorization: bearer $TOK`, lower case, or `isAuth` returns 403 `bearer not understood`.

**Files**
- `api/controllers/QuickbooksController.js` — has `axios`, `TOKEN_URL`, `escapeHtml`, `page`, `pendingStates`
- Placement of the helper is the first decision of S132. A service (`api/services/`) is the obvious home if one exists — **measure whether `api/services/` exists before deciding.** Not measured.

**Sandbox**
- `Sandbox Company CA 26d2`, realm `9341457751382548`, Plus, Region CA, created 19 Aug 2026, valid two years
- US sandbox `Sandbox Company US 80fd` realm `9341457628433780` exists and is **not** to be used

⚠ **Do not run Intuit's OAuth Playground.** It is a full authorisation flow of its own against the same app. Running it re-authorises the sandbox and kills the refresh token we hold. Nearly done in S131.

### 4 · Proof — measured this session

| item | measured how | result |
|---|---|---|
| super admin exists | join `user` × `super_admin` | id 1, `info.abletrace@gmail.com`, token 115 chars |
| that token is valid | curl `/api/v1/unittype/getunittypes` with `bearer $TOK` | 200 |
| the guard refuses without it | same route, no header | 400 |
| header must be lower case | read `api/policies/isAuth.js` | `bearer[0] !== 'bearer'` → 403 |
| connect returns the URL | curl with token | JSON, client id + scope + 56-char redirect URI |
| connect still guarded after the policy edit | curl, no header | 400 |
| callback is public | curl, no header, bogus state | 200 |
| callback refuses a bogus state | same, `grep "<h2>"` | `Not connected` |
| full round trip | browser, consent | `Connected` page, on screen |
| the row landed | `SELECT` on `quickbooks_tokens` | 1 row, acc 603, ref 41, all dates populated |
| sandbox API base | curl companyinfo, sandbox host | **200** |
| production host rejects the sandbox token | same call, production host | 403 |
| company name reads back | curl companyinfo, parsed | `Sandbox Company CA 26d2`, Country `CA` |
| all three files parse | `node --check` × 3 | SYNTAX OK, CONFIGS OK |
| app lifts | restart, sleep 10, curl | 200, 234.6mb, restart counter held |
| committed and pushed | `git push`, `rev-parse` | backend `4ed6d03` |
| RULES.md edit landed | `git diff`, `git log` | docs `9a23cbb`, 18 insertions, 2 deletions |

### The analysis

**The race, and why it is the whole job.** A refresh token is single-use. Intuit issues a new one on every refresh and kills the old one immediately. If two refreshes run at once, both send the same old token; one succeeds and stores the new one, the other succeeds a moment later against a token that is already dead — or worse, succeeds and then overwrites the good stored value with its own now-superseded one. From then on every call fails, permanently, until a human re-authorises. It does not announce itself and it does not fail at the time.

**What we know about the process shape.** `pm2 status` shows one process, **fork** mode, id 0. Not cluster. So today an in-process guard is sufficient — a module-level promise per company, so that a second caller arriving mid-refresh waits on the first one's result rather than starting its own. That is simple and it is enough.

⚠ **It stops being enough the moment there is more than one process.** If pm2 is ever switched to cluster mode, or prod runs a second instance, an in-process guard silently protects nothing. Write that in the code comment, not just here. A database-level guard (a lock row, or a conditional update on the old token value) is the version that survives that change — decide in S132 whether to build it now or write the warning and defer.

**Refresh proactively, not on failure.** Checking `access_expires_at` before a call and refreshing if it is within a few minutes of expiry is simpler and more predictable than catching a 401 and retrying. It also means a refresh happens at a moment of our choosing rather than in the middle of someone's invoice.

**One function, one caller path.** Every QuickBooks call should go through something that hands back a valid access token, refreshing if needed. If any call site ever reads `access_token` from the row directly, the guard is bypassed and the design is dead.

**Why the callback is public.** Intuit redirects the browser back with no token attached — a redirect cannot carry an authorization header. `isAuth` would reject it and the connection would never complete. The guard is the `state` parameter, issued by connect, held in memory, single-use, and deliberately not surviving a restart. The exemption is in `config/policies.js` under `QuickbooksController`. **Removing it breaks the connection and the failure looks like Intuit's.**

**Why the company column.** Minty's ruling S129. Phase 3 puts Glutenull and Hagensborg on their own QuickBooks. With the column, Phase 3 is two more rows. `company` is UNIQUE in the database, which is also what stops a re-authorisation creating a second row.

**Routes sit outside `/api/v1/` deliberately.** Intuit's registered redirect URI is `/api/quickbooks/callback` and Intuit's copy is the arbiter. Do not tidy this into `v1`.

---

## AFTER

**S133 — the QuickBooks settings screen.** Minty's decision, S131: a proper page, not a throwaway. Shows connected or not, the company name read live from QuickBooks, and a Connect button that calls `/api/quickbooks/connect` and does `window.location.href = authorizeUrl`. Angular, edited on the Mac. This delivers Phase 1's headline verify — `Sandbox Company CA 26d2` on an AbleTrace screen.

**Phase 2.** Dummy products in AbleTrace, matching items in the sandbox, then packing slip → QuickBooks invoice → **invoice number returns into the shipping reference**. The round trip proves AbleTrace both wrote and read back, and gives the audit link and the duplicate guard for free.

⚠ **Phase 2 proves the plumbing, not the fit.** With dummy products, matching is trivial. With a real catalogue it is the hardest part of the job — along with customer matching and tax codes. Expect that, so Phase 3 does not feel like a setback.

**Phase 3.** Glutenull and Hagensborg on their own books. Needs Intuit **production** keys, a fresh authorisation per client, real mapping decisions, the `CREATE TABLE` run separately on prod — and **the API base host changes**, measured S131: production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.

⚠ Production keys reach live client books. They never come near chat, in any form.

**Later, its own phase** — material receipts → supplier bills, supplier invoice linked to the receipt. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every invoice line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

⚠ **Quantities on an invoice are units, read across from the slip.** Never derived from weight. RULES §7.

⚠ **P240 applies.** A silent failed invoice is worse than a silent failed email. The slip needs a visible status — sent, failed, not sent.

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P17 | Two old-account IAM keys still valid and in git history, deliberately |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P225 | Sweep Mac Downloads |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks integration — **active. connect and callback done; refresh is S132, screen is S133** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`, random generators commented out above it. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. A leaked token is valid forever and logging out cannot invalidate it — only a new login can, because `isAuth` also matches the stored `webToken`. Seen in passing S131. Fold into P241 |
| P248 | **Prod OS updates.** 59 pending, 12 of them security, Ubuntu 26.04. The open check does not test the host OS, so this has never been in view. Seen in passing S131. Fold into P241 |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

**Closed in S131**
- The S130 connect design fault. Fixed and proven.
- The RULES.md edit approved in S130. Applied, pushed, `9a23cbb`.
- P245 Phase 1: connect, callback, and the API base. Refresh outstanding.

---

## TRAPS RECORDED IN S131

For TRAPS.md when that file is next opened.

**`isAuth` requires lower-case `bearer`.** `api/policies/isAuth.js` does `if (bearer[0] !== 'bearer') return res.forbidden('bearer not understood')`. The conventional `Authorization: Bearer <token>` — capital B, which is what every HTTP client and every tutorial writes by default — gets a **403** that reads like a broken route. Intuit's own API, by contrast, wants the capital B. Two systems, opposite conventions, both correct.

**A valid token can be read from the database — never ask for a password.** `User.loginUser` stores the minted token in `user.webToken`. Reading it out of the row gives a working bearer token with no credential anywhere near the chat or the screen. `isAuth` re-checks `webToken` against the row, so logging in again silently invalidates the old one: a curl that worked and now returns `User not found / Session Expired` means someone logged in since.

**`node -c` is not a syntax check.** The flag is `node --check <file>`. `node -c "..."` treats the string as a module path and fails with a confusing `Cannot find module` naming the whole string. Cost one wasted command in S131.

**Intuit's OAuth Playground is a live authorisation flow, not a documentation viewer.** Running it against your own app re-authorises the company and invalidates the refresh token already stored. It looks like a reference page. Nearly clicked in S131 on Claude's own suggestion.

**Sandbox and production QuickBooks are different hosts, not different paths.** `sandbox-quickbooks.api.intuit.com` returns 200 to a sandbox token; `quickbooks.api.intuit.com` returns 403 to the same token. Phase 3 must change the host along with the keys, or every call fails with something that reads like a permissions problem.

**A `pm2 status` taken immediately after a restart shows a mid-boot memory figure.** S131 read 16.9mb straight after restarting and 234.6mb ten seconds later. Both were the same healthy process. The low figure is only a crash-loop tell when it persists — take the reading after the sleep, not before.

**Carried, still true:**
- **A route behind `isAuth` cannot redirect a browser.** Guarded routes must return the destination as JSON and let the frontend navigate.
- **A passing guard proves nothing about the action behind it.** Now RULES §1.
- **`allowNull` cannot be used with type `ref` or `json` in a Sails model.** Waterline names only the first offending attribute.
- **A dead Sails process still reads `online` in `pm2 status`.** The curl is the health check.
- **Long pastes into the terminal garble.** Anything long goes as a file.
- **`res.badRequest` in this app is 400, not 403.**
- **Intuit Save button** has no visible Save until a field is edited, and it sits at the top of the panel.
- **Authorization codes are single-use, ~10 minutes.** Reuse returns `invalid_grant`, which reads like a credential failure and is not.
- **`ReviewDetails.Status` on SES is a record, not a status.**
- **nginx `grep -r` skips symlinks.** TRAPS 10.
- **Prod cannot ssh to dev.** The pem exists only on the Mac.
