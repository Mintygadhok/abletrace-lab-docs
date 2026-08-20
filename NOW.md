# NOW

Rewritten whole at the close of S132.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply to AWS's four questions on 19 Aug. Nothing to do until AWS answers. Not touched in S130, S131 or S132.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` for as long as the reply sits unread. It is not a second refusal. Read the CaseId alongside it — if the CaseId is still `178710371200148`, no new review has been opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

⚠ **SES does not block QuickBooks.** Minty's question, S132. Phase 1 and Phase 2 are AbleTrace talking to QuickBooks over an API, machine to machine. Nothing in either sends email. SES only ever meets this work if AbleTrace is one day asked to *email* an invoice — not in either phase, and QuickBooks can email invoices itself.

**Old account 350466202408 — teardown parked.** SES is the only remaining live dependency. Everything else is gone. Blocked until SES migration completes. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Dev backend carries `?? node_modules.old-node18/`.** Deliberate — P227. A dirty tree line that is not a finding.

**Prod's git checkout lags the served build.** Deliberate — P8. The `www-html.bak-*` line in the open check is the only reliable read of what is live.

**Prod has not been touched since before S130.** All QuickBooks work is dev-only. Prod has no `quickbooks_tokens` table and no QuickBooks code. That is correct and stays that way until Phase 3.

**P245 Phase 1 — the backend is complete and proven. Only the screen is left.**

Backend `0852873`. What works, measured S132:
- `GET /api/quickbooks/connect` returns the authorize URL as JSON, guarded by `isAuth`
- `GET /api/quickbooks/callback` completes the exchange, public, state-guarded
- `quickbooksService.getAccessToken(company)` returns a live token, refreshing when needed
- a token fetched by the service reads company data back from QuickBooks — **HTTP 200, `Sandbox Company CA 26d2`**

⚠ **The S130 design fault stays fixed.** connect does not redirect. Do not reintroduce a redirect there — the reason is in the controller's doc comment and in TRAPS.

---

## THE JOB — S133

Build the QuickBooks screen. This closes Phase 1.

### 1 · The task

1. **Add QuickBooks as its own left-menu tab**, alongside Admin, Sales, Production, Warehousing, Purchase, Food Safety. Minty's ruling, S132: **this is its permanent home**, not a Phase 1 throwaway. It later holds the invoice log and the product matching from Phase 2, so build it as a section that can grow, not a single orphan page.
2. **Admin-only.** QuickBooks holds financial credentials and must not be visible to every user. **Measure how the existing tabs are permission-controlled before writing anything** — match whatever Admin uses today. Not measured as of S132.
3. **One backend route: connection status.** Reads the row, calls QuickBooks through `quickbooksService`, returns connected true/false plus the company name.
4. **The page.** Shows connected or not, and the company name **read live from QuickBooks**, not from our own row. A row can hold a dead connection and still look populated.
5. **A Connect button** when not connected: calls `/api/quickbooks/connect`, then `window.location.href = authorizeUrl`.

⚠ **Do not start Phase 2 in S133.** Scope discipline.

### 1a · Also in S133 — file the traps

**Open `TRAPS.md` and move the accumulated entries into it, then cut them out of NOW.** Minty's ruling, S132.

The traps section below has carried the S131 entries unfiled for two sessions and S132 added five more. It is roughly a third of this file. RULES permits this: *a document is cleaned by whichever session next opens it*, and *anything worth keeping must not live in NOW* — NOW is rewritten whole, so a trap left here is a trap waiting to be dropped.

Do this **before** the frontend work, not at the close. It is small, it is bounded, and if it is left to the close it will be dropped again.

### 2 · How it is verified

**`Sandbox Company CA 26d2` visible on an AbleTrace screen, under a QuickBooks tab in the left menu, logged in as super admin.**

That string cannot appear unless the row, the service, the route and the page all work. It is Phase 1's headline verify and it has been the definition since S131.

Second verify: **a non-admin user does not see the tab.**

### 3 · What the job requires

**The frontend is edited on the Mac, not on dev.** Dev's copy is overwritten by the next deploy. RULES §2. A push to GitHub builds dev; prod needs a manual dispatch. After deploying, **Shift+Cmd+R** in Chrome.

**The service — already built, committed, and the only way to get a token**

```
const token = await quickbooksService.getAccessToken('sandbox260820');
```

`api/services/quickbooksService.js`, 259 lines, committed `0852873`. Reached as a **global**, no `require` — that is how `s3Service` and `SharedService` are called throughout this app. It refreshes automatically when the stored token is within five minutes of expiry, and throws rather than returning a bad token. **Nothing may read `access_token` off the row directly** — that bypasses both race guards and kills the design.

`refreshNow(company)` also exists. It forces a refresh regardless of expiry. **Not for normal call sites** — for proving the mechanism and for a future reconnect button only.

**The API base — host-specific, not path-specific**

```
https://sandbox-quickbooks.api.intuit.com
/v3/company/9341457751382548/companyinfo/9341457751382548
```

Both ids in the path are the realm.

⚠ Intuit's own API wants `Authorization: Bearer` with a **capital B**. AbleTrace's `isAuth` wants lower-case `bearer`. Different systems, both right. Do not unify them.

**The super-admin token, for any guarded curl**

```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;")
```

Header form is `authorization: bearer $TOK`, lower case, or `isAuth` returns 403 `bearer not understood`.

**The row as it stands at the close of S132**

```
id 1 · company sandbox260820 · realm_id 9341457751382548
refresh_token MD5 3aa750d8e148fd2237a1ae00b9ce8ab4 · 41 chars
access_expires_at  2026-08-20 23:55:20
refresh_expires_at 2026-11-29 19:34:07
```

**Files**
- `api/services/quickbooksService.js` — the token service
- `api/controllers/QuickbooksController.js` — 271 lines. Has `axios`, `TOKEN_URL`, `escapeHtml`, `page`, `pendingStates`. The status route goes here.
- `api/models/QuickbooksToken.js` — 36 lines
- `config/policies.js` — holds the `QuickbooksController` callback exemption

**Sandbox**
- `Sandbox Company CA 26d2`, realm `9341457751382548`, Plus, Region CA, created 19 Aug 2026, valid two years
- US sandbox `Sandbox Company US 80fd` realm `9341457628433780` exists and is **not** to be used

⚠ **Do not run Intuit's OAuth Playground.** It is a full authorisation flow against the same app. Running it re-authorises the sandbox and kills the refresh token we hold. It looks like a reference page.

### 4 · One thing to check at the open, 30 seconds

**Rotation could not be proven in S132 because it needs a day to pass.** Intuit issues a new refresh token roughly every 24 hours, not on every refresh.

If S133 runs more than ~24 hours after 2026-08-20 19:34 UTC, a refresh should produce a **different** refresh token, and the service should store it. Compare against the hash above:

```
mysql -N -B abletracelab_live -e "SELECT MD5(refresh_token), access_expires_at FROM quickbooks_tokens WHERE company='sandbox260820';"
```

A hash **different** from `3aa750d8e148fd2237a1ae00b9ce8ab4` proves rotation was captured. A hash the **same** after more than 24 hours of the app running is a finding worth stopping for.

### 5 · Proof — measured this session

| item | measured how | result |
|---|---|---|
| open check | the seven-line block, dev | frontend `c2a52d8e` clean, backend `4ed6d03`, 200, Node v24.19.0 |
| process shape | `pm2 status` | **fork**, one process, id 0 — the basis of guard 1 |
| `api/services/` exists | `ls -la api/` | yes, 4 services since 8 Jul |
| services are globals | `grep` for `s3Service`/`SharedService` across api and config | called bare, no `require`, anywhere |
| `config/globals.js` does not list services | `cat` | only `_`, `async`, `models`, `sails` — framework default, not an omission |
| credentials pattern | `grep` the controller | `process.env.QUICKBOOKS_CLIENT_ID` / `_SECRET` / `APP_BASE_URL`, read at point of use |
| Sails version | `.sailsrc` | 1.2.2 |
| bootstrap only schedules crons | `grep` `config/bootstrap.js` | `schedule.scheduleJob` — registers timers, fires nothing at load |
| file landed intact | `md5sum` on Mac and dev | `6e7894f9d9d8ea939250ab5aa86093b6` both ends |
| it parses | `node --check` | SYNTAX OK |
| BEFORE row, independent of the script | `mysql` `MD5(refresh_token)` | `3aa750d8e148fd2237a1ae00b9ce8ab4`, 41 chars, expiry 20:34:06 |
| the service refreshes | `refreshNow` via a loaded Sails | returned a 603-char access token |
| the row was rewritten | `mysql` after | access_expires_at 20:34:06 → **23:55:20** |
| served token == stored token | script comparison | YES |
| **the token actually works** | curl companyinfo, sandbox host, Bearer | **HTTP 200** |
| **the company reads back** | same call, parsed | **`Sandbox Company CA 26d2`** |
| rotation | same call within 24h | refresh token **unchanged** — correct Intuit behaviour, not a fault |
| app boots with the service | restart, sleep 8, curl | 200, counter 48→49, 250.9mb |
| committed and pushed | `git push`, `rev-parse` | backend `0852873`, 259 insertions |
| tree clean after tidy | `git status --short` | only `node_modules.old-node18/` (P227) |

### The analysis

**The refresh token rotates once a day, not on every use.** Corrected in S132 against Intuit's own documentation. The previous entry in NOW said it was single-use and died on every refresh. **That was wrong and it caused a test to report two false failures.** Within a 24-hour window Intuit returns the *same* refresh token; on day two it issues a new one and the previous one starts returning `invalid_grant`.

**The race is therefore rarer than it looked, and exactly as dangerous.** The collision window is the daily rotation, not every hour. If two refreshes cross at that moment, one can store a token the other has already superseded, and from then on every call fails permanently until a human re-authorises. It does not announce itself and it does not fail at the time.

**Both guards were built. Minty's ruling, S132.**

- **Guard 1, in process.** One promise per company; a second caller mid-refresh awaits the first one's result. Sufficient *today* — fork mode, one process, measured this session.
- **Guard 2, in the database.** The write-back matches on the old refresh token value as well as the id. Zero rows updated means another process got there first, so we discard our result and re-read theirs. This is the one that survives a move to more than one process, and it was built now precisely because retrofitting it would only happen after something broke.

⚠ **Guard 1 alone silently protects nothing the day pm2 goes to cluster mode or a second instance runs.** It still looks like it works. That is why guard 2 exists.

**Refresh proactively, not on failure.** The service refreshes when the stored token is within five minutes of expiry rather than catching a 401 and retrying. The refresh then happens at a moment of our choosing, not in the middle of someone's invoice.

**One function, one caller path.** If any call site ever reads `access_token` from the row directly, both guards are bypassed and the design is dead.

**Why the callback is public.** Intuit redirects the browser back with no token attached — a redirect cannot carry an authorization header. `isAuth` would reject it and the connection would never complete. The guard is the `state` parameter, issued by connect, held in memory, single-use, deliberately not surviving a restart. The exemption is in `config/policies.js`. **Removing it breaks the connection and the failure looks like Intuit's.**

**Why the company column.** Minty's ruling S129. Phase 3 puts Glutenull and Hagensborg on their own QuickBooks. With the column, Phase 3 is two more rows. `company` is UNIQUE in the database, which is also what stops a re-authorisation creating a second row.

**Routes sit outside `/api/v1/` deliberately.** Intuit's registered redirect URI is `/api/quickbooks/callback` and Intuit's copy is the arbiter. Do not tidy this into `v1`.

---

## AFTER

**Phase 2 — the round trip. Minty's description, S132, in his order:**

1. **Prep in QuickBooks** — dummy products and a dummy customer in the sandbox, so there is something to invoice against.
2. **Match them in AbleTrace** — the same products set up our side, so the app knows product X here is item X there.
3. **Packing slip → invoice** — a slip is sent to QuickBooks and QuickBooks creates the invoice.
4. **Invoice number returns** — back onto the packing slip in AbleTrace.

The round trip proves AbleTrace both wrote and read back, and gives the audit link and the duplicate guard for free.

⚠ **Phase 2 proves the plumbing, not the fit.** With dummy products, matching is trivial. With a real catalogue it is the hardest part of the job — along with customer matching and tax codes. Expect that, so Phase 3 does not feel like a setback.

**Phase 3.** Glutenull and Hagensborg on their own books. Needs Intuit **production** keys, a fresh authorisation per client, real mapping decisions, the `CREATE TABLE` run separately on prod — and **the API base host changes**: production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.

⚠ Production keys reach live client books. They never come near chat, in any form.

⚠ **Intuit's refresh token policy changed.** Refresh tokens now carry a maximum validity of five years, and a **Reconnect URL is a mandatory field** in app settings as of February 2026. Customers get expiry notifications and need a page to reconnect from. Found S132. Applies to Phase 3, not before — but the field is mandatory on the developer portal, so check it when production keys are set up.

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
| P245 | QuickBooks integration — **active. connect, callback and refresh done; screen is S133** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`, random generators commented out above it. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. A leaked token is valid forever and logging out cannot invalidate it — only a new login can, because `isAuth` also matches the stored `webToken`. Fold into P241 |
| P248 | **Prod OS updates.** 59 pending, 12 of them security, Ubuntu 26.04. The open check does not test the host OS, so this has never been in view. Fold into P241 |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

**Closed in S132**
- The refresh helper. Built, committed `0852873`, proven end to end against QuickBooks.
- Guard decision: both guards, now. Minty's ruling.
- The `api/services/` placement question. Measured — it exists, and services are globals.
- S133 defined: QuickBooks as a permanent admin-only left-menu tab. Minty's ruling.

---

## TRAPS — FILE THESE INTO TRAPS.md IN S133

⚠ **This whole section leaves NOW in S133.** Move it into `TRAPS.md`, then delete it here. See §1a. It is about a third of this file and it has already survived two rewrites it should not have.

**From S132:**

**Intuit rotates refresh tokens daily, not per call.** Within 24 hours the *same* refresh token comes back from a refresh. A test that asserts "the refresh token must change" will report a false failure, and the old token will still be accepted — because it is not old, it is the current one. Cost a false alarm in S132 and, worse, the wrong claim had already been written into NOW as fact.

**`sails.load()` with the `http` hook disabled will not load.** The `views` hook depends on `http` and Sails refuses with *enable both or neither*. Disabling `http` looks like the cautious choice for a script that must not collide with the running app on 1337 — it is unnecessary, because `load()` does not start the HTTP server at all. Only `lift()` does. Cost one failed run.

**`sails version` from `./node_modules/.bin/sails` exits 0 and prints nothing.** Not a broken install. Read `.sailsrc` for the version instead.

**`api/scripts/` in this app is not Sails scripts.** `expire-licences.js` is plain node with its own `require('dotenv')` and a raw `mysql` connection. It never lifts the app, so it has no models, no services and no `sails.log`. Anything needing the real app must load Sails itself, the way `app.js` does.

**A browser download can silently not happen.** In S132 a re-download never landed and two `md5` runs reported no such file. Do not keep re-asking for a download — for a one-line change, edit in place on the box with `sed` and verify by hash. A predicted hash that matches is proof the edit was exactly the intended one.

**From S131, still unfiled:**

**`isAuth` requires lower-case `bearer`.** `api/policies/isAuth.js` does `if (bearer[0] !== 'bearer') return res.forbidden('bearer not understood')`. The conventional capital-B `Bearer` gets a **403** that reads like a broken route. Intuit's own API wants the capital B. Two systems, opposite conventions, both correct.

**A valid token can be read from the database — never ask for a password.** `User.loginUser` stores the minted token in `user.webToken`. `isAuth` re-checks it against the row, so logging in again silently invalidates the old one: a curl that worked and now returns `User not found / Session Expired` means someone logged in since.

**`node -c` is not a syntax check.** The flag is `node --check <file>`.

**Intuit's OAuth Playground is a live authorisation flow, not a documentation viewer.** Running it against your own app re-authorises the company and invalidates the stored refresh token.

**Sandbox and production QuickBooks are different hosts, not different paths.**

**A `pm2 status` taken immediately after a restart shows a mid-boot memory figure.** Seen again in S132: 16.9mb in the first table, 250.9mb after the sleep, same healthy process. The low figure is only a crash-loop tell when it persists.

**Carried, still true:**
- **A route behind `isAuth` cannot redirect a browser.** Guarded routes return the destination as JSON and let the frontend navigate.
- **A passing guard proves nothing about the action behind it.** RULES §1.
- **`allowNull` cannot be used with type `ref` or `json` in a Sails model.**
- **A dead Sails process still reads `online` in `pm2 status`.** The curl is the health check.
- **Long pastes into the terminal garble.** Anything long goes as a file.
- **`res.badRequest` in this app is 400, not 403.**
- **Intuit Save button** has no visible Save until a field is edited, and it sits at the top of the panel.
- **Authorization codes are single-use, ~10 minutes.** Reuse returns `invalid_grant`, which reads like a credential failure and is not.
- **nginx `grep -r` skips symlinks.** TRAPS 10.
- **Prod cannot ssh to dev.** The pem exists only on the Mac.
