# NOW

Rewritten whole at the close of S130.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply to AWS's four questions at 11:00 PDT on 19 Aug. Nothing to do until AWS answers. Not touched in S130.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` for as long as the reply sits unread. It is not a second refusal. Read the CaseId alongside it — if the CaseId is still `178710371200148`, no new review has been opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

**Old account 350466202408 — teardown parked.** SES is the only remaining live dependency. Everything else is gone. Blocked until SES migration completes. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Dev backend carries `?? node_modules.old-node18/`.** Deliberate — P227. A dirty tree line that is not a finding.

**Prod's git checkout lags the served build.** Deliberate — P8. The `www-html.bak-*` line in the open check is the only reliable read of what is live.

**P245 Phase 1 — half built. Dev only. Prod untouched.**

Built and committed at `1920e3b`:
- `.env` on dev carries `QUICKBOOKS_CLIENT_ID` and `QUICKBOOKS_CLIENT_SECRET`
- table `quickbooks_tokens` exists in `abletracelab_live`
- model `api/models/QuickbooksToken.js` loads, ORM lifts, app returns 200
- controller `api/controllers/QuickbooksController.js` with the `connect` action
- route `GET /api/quickbooks/connect` registered and guarded

⚠ **connect is deployed, not proven — and as written it cannot be proven.** See the fault below. Fixing it is the first job of S131.

⚠ **DESIGN FAULT IN `connect`, found at the S130 close. Claude's error.**

The route sits behind `isAuth`, which reads the token from the `authorization` request header. **A browser cannot send that header on a plain navigation** — typing the URL, clicking a link, or following a redirect all arrive without it. So `GET /api/quickbooks/connect` returns 400 for everyone, logged in or not, and `res.redirect` at the end of the action is unreachable from a browser.

The 400 measured in S130 was read as "the guard works". It does — but it is also the only thing that route can ever return to a browser.

**The fix — do not redirect. Return the URL.** connect stays behind `isAuth` and responds with JSON:
```
{ success: true, authorizeUrl: "https://appcenter.intuit.com/connect/oauth2?..." }
```
The frontend already attaches the token to every call, so it receives the URL and then sends the browser there itself (`window.location.href = authorizeUrl`). Same guard, same security, and it works from a browser.

This also gives a proof that needs no frontend work: a curl carrying a valid super-admin token returns the URL as text, and the URL can be eyeballed for the client id, the scope and the 56-character redirect URI before anyone clicks anything.

The callback is unaffected — it is public and state-guarded by design.

⚠ **The commit message on `1920e3b` overstates one thing.** It says the URI registered at Intuit is "connect and callback". Only `/api/quickbooks/callback` is registered at Intuit. `connect` is ours alone. The code comment in the controller is correct.

---

## THE JOB — S131

Prove connect, then build the callback route and the refresh helper.

### 1 · The task

1. **Fix connect — return the URL, do not redirect.** See the design fault in STATE. `res.redirect(authorizeUrl)` becomes `res.json({ success:true, authorizeUrl })`.
2. **Prove connect with curl.** A curl carrying a valid super-admin bearer token returns the authorize URL as text. Eyeball it: client id present, scope `com.intuit.quickbooks.accounting`, redirect URI exactly 56 chars.
3. **Prove connect on screen.** Frontend sends the browser to that URL; Intuit's consent page appears showing `Sandbox Company CA 26d2`.
4. **Measure the sandbox API base.** Never measured. Intuit Playground Step 3 "Get cURL" shows it.
5. **Build the callback route** at `GET /api/quickbooks/callback` — validate state, exchange the code, store both tokens, the realm and both expiry times. **Add it to `config/policies.js` as `true`** or it will 400 and look like an Intuit fault.
6. **Build the refresh helper** — one place, always writes back the newest refresh token.
7. **Read the company name back** from QuickBooks and put it on a screen.

⚠ **A super-admin bearer token is needed for step 2 and does not exist yet in a usable form.** Getting one means logging into dev and reading the token the app already holds. Work out how at the S131 open — it is needed before anything can be proven.

### 2 · How it is verified

**AbleTrace displays the name `Sandbox Company CA 26d2`, read live from QuickBooks, on a screen.**

Not a 200 in a log. Not a row in the table. The name on the screen. Anything less is deployed, not proven.

Intermediate verifies, each on screen or in a row:
- connect → Intuit consent page appears
- callback → one row in `quickbooks_tokens`, company `sandbox260820`, realm `9341457751382548`, both expiry columns populated
- refresh → refresh token value in the row **changes** after a forced refresh

### 3 · What the job requires

**Credentials — dev `.env`, already in place**
- `QUICKBOOKS_CLIENT_ID` — 50 chars, letters and digits only
- `QUICKBOOKS_CLIENT_SECRET` — 40 chars
- Both re-readable at Intuit: Keys and credentials → Development → Show credentials
- Also in Section H. The value that appeared in the S129 chat log is dead.

**Intuit app**
- Workspace `Abletrace_qbintuit`, app `Abletrace`, AppID `90bf69f7-81d5-4c3b-8d51-5f2b566a808f`
- Status IN DEVELOPMENT. Development keys only, sandbox only. Production keys are Phase 3.

**Sandbox**
- `Sandbox Company CA 26d2`, realm `9341457751382548`
- Plus · Region **CA** · Accounting only
- Created 19 Aug 2026, valid two years
- US sandbox `Sandbox Company US 80fd` realm `9341457628433780` still exists and is **not** to be used.

**Redirect URI — registered at Intuit, 56 chars, must match character for character**
```
https://dev.mintekfoodsafety.com/api/quickbooks/callback
```
Built in code as `process.env.APP_BASE_URL + '/api/quickbooks/callback'`. `APP_BASE_URL` on dev is `https://dev.mintekfoodsafety.com`, no trailing slash.

**Endpoints**
- Authorize: `https://appcenter.intuit.com/connect/oauth2`
- Token exchange: `POST https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer`
- Body: `grant_type=authorization_code`, `code=…`, `redirect_uri=…`
- Auth header: HTTP Basic, `client_id:client_secret` base64-encoded
- ⚠ **API base for reading the company back: NOT MEASURED.** Task 2 above.

**Scope**
```
com.intuit.quickbooks.accounting
```
The Permissions page has payments ticked too. That only defines what the app *may* request. The request decides what the client consents to. AbleTrace does not move money.

**Token lifetimes — measured from a live 200, 20 Aug**
- `expires_in: 3600` — one hour
- `x_refresh_token_expires_in: 8726400` — 101 days, returned on **every** refresh. Store it every time.

**Error discrimination — both seen live in S129**
- `invalid_grant` / "Authorization code incorrect" → the **code** is spent or expired. Single-use, ~10 minutes.
- `invalid_client` → the **secret** is wrong.

**Files to edit**
- `api/controllers/QuickbooksController.js` — add `callback`, consume `_pendingStates`
- `config/routes.js` — add the callback route at line ~25, beside connect
- New helper for refresh — placement to be decided in S131

**Table — exists on dev, columns as built**
```
id  company  realm_id  access_token  refresh_token
access_expires_at  refresh_expires_at  connected_at
createdAt  updatedAt
```
`company` is UNIQUE. Company value for the sandbox: `sandbox260820`. Minty's ruling S130.

**Database is `abletracelab_live`** — the dev box's database, despite the name. `abletrace` and `abletrace-dev` also exist on the box and are not it. `DATABASE_URL` is the arbiter.

### 4 · Proof each item in 3 exists — measured S130

| item | measured how | result |
|---|---|---|
| `.env` keys present | `awk -F= '/^QUICKBOOKS_/…'` | ID 50 chars, secret 40 |
| ID free of stray characters | strip alphanumerics, `cat -A` | bare `$`, clean |
| `APP_BASE_URL` value | `grep '^APP_BASE_URL'` | `https://dev.mintekfoodsafety.com`, no slash |
| table exists, right shape | `DESCRIBE quickbooks_tokens` | 10 columns, `company` UNI |
| dev database name | tail of `DATABASE_URL` | `abletracelab_live` |
| model loads | restart, sleep 12, curl | 200 |
| route registered | `grep quickbooks config/routes.js` | line 24 |
| route guarded | curl unauthenticated | 400 `No token provided` |
| committed and pushed | `git push`, `rev-parse` | `1920e3b` |
| `axios` available | `package.json` dependencies | present, no install needed |
| nginx path | measured S129 | `/api/` → `localhost:1337/api/`, prefix preserved, no change needed |
| sandbox API base | — | **NOT MEASURED. Task 2.** |

### The analysis

**Why a table and not `.env`.** The refresh token rewrites itself roughly daily and the old value is force-expired the moment a new one is issued. Nothing writes to `.env` at runtime. Client ID and secret are static and belong in `.env`; the per-company connection does not.

**Why the company column now.** Minty's ruling S129. Phase 3 puts Glutenull and Hagensborg on their own QuickBooks. With the column, Phase 3 is two more rows. Without it, the table is rebuilt when live client books are already involved.

**Why there is no role check on connect.** Measured S130: the `user` table has no role, type or admin column. Company staff are a separate table with their own login (`CompanyEmployeeController`). Being in `user` *is* being a super admin, and `config/policies.js` defaults to `'*': 'isAuth'`. So isAuth alone gives super-admin-only. Writing a role check would be code that looks like security and is not.

**Why the callback must be public.** Intuit redirects the browser back with no token attached. `isAuth` would reject it and the connection would never complete. The guard is instead the `state` parameter — connect issues a random value, Intuit returns it, callback refuses anything that does not match one it issued. States are held in memory in the controller (`_pendingStates`), single-use, and deliberately do not survive a restart. **The callback route must be added to `config/policies.js` as `true`, or it will 400 and the cause will look like Intuit.**

⚠ **The single most common way these break.** If two processes refresh at once, one stores the new refresh token and the other overwrites it with the stale one. Every call fails from then on, permanently, until a human re-authorises. Design the guard in; retrofitting is expensive.

**Rule: always write back the newest refresh token, every time, without exception.**

**Routes sit outside `/api/v1/` deliberately.** Every other route in the app is `/api/v1/…`. The QuickBooks routes are not, because the redirect URI registered at Intuit is `/api/quickbooks/callback` and Intuit's copy is the arbiter. Do not tidy this into `v1`.

---

## RULES.md EDIT — APPROVED S130, NOT YET APPLIED

Minty approved both additions in S130. **Not written into RULES.md** — the only copy Claude had was the chat-rendered paste from the open, and rewriting the governance document from a flattened copy risks silently dropping a line. **S131 opens by pulling `abletrace-lab-docs`, reading the real `RULES.md`, and replacing it whole with these two additions.** Ten minutes, before the QuickBooks work. Then this section is deleted.

**Addition 1 — into rule 6, after "the verify":**

> **the proof** — each item in the material, with the command that measured it and what it returned, run this session. A quoted fact with no measurement beside it is a memory, not material. Minty's ruling, S130.

**Addition 2 — into rule 6, the close sequence. Minty's wording, S130:**

> **The close, five steps.**
> 1 · **Write and download.** Claude produces NOW, Minty downloads it to Downloads.
> 2 · **Pull and check.** Bring the Mac's repo level with GitHub. Look at what actually landed in Downloads.
> 3 · **Replace and verify.** Overwrite the repo's NOW with the downloaded one. Read the byte count back.
> 4 · **Add, commit, push.** Mark it. Save it. Send it.
> 5 · **Tidy.** Delete the Downloads copy. Replace the panel copy.

**Addition 3 — into rule 1, before "Before you act". Minty's ruling, S130:**

> **Design before writing.** Before writing a route or a screen, say who calls it, what they send, and what comes back. If Claude cannot answer all three, it is not ready to write. A route nobody can reach is not half-built — it is not built.
>
> Why this rule exists: S130 built a connect route behind a policy that reads a request header, to be reached by a browser navigation, which cannot send one. Two minutes of design would have caught it. It was found at the close instead, after the code was committed.

**Addition 4 — into rule 1, alongside "A check must be able to fail". Minty's ruling, S130:**

> **A passing guard proves nothing about the action behind it.** When a policy refuses a request, the controller never ran. Do not read a 400 or a 403 on a new route as evidence the route works.

---

## AFTER — PHASE 2

Minty's phasing, S129.

Dummy products in AbleTrace, matching items in the sandbox, then packing slip → QuickBooks invoice → **invoice number returns into the shipping reference**. That round trip proves AbleTrace both wrote and read back, and gives the audit link and the duplicate guard for free.

⚠ **Phase 2 proves the plumbing, not the fit.** With dummy products, matching is trivial. With a real catalogue it is the hardest part of the job — along with customer matching and tax codes. Expect that, so Phase 3 does not feel like a setback.

**Phase 3** — Glutenull and Hagensborg on their own books. Needs Intuit **production** keys, a fresh authorisation per client, real mapping decisions, and the `CREATE TABLE` run separately on prod.

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
| P245 | QuickBooks integration — **active, Phase 1 half built** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`, with the random generators commented out above it. `api/models/User.js:98`. Seen in passing S130. Untidy on dev; a real exposure if the same path exists on prod. Fold into P241 |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

**Closed in S130**
- Nothing closed. P245 advanced, not closed.

---

## TRAPS RECORDED IN S130

For TRAPS.md when that file is next opened.

**A route behind `isAuth` cannot redirect a browser.** `isAuth` reads the token from the `authorization` header, and a browser sends no such header on a plain navigation — typed URL, clicked link, or a redirect it is following. So any guarded route whose job is to send the browser somewhere returns 400 to everyone and its redirect is unreachable. Guarded routes must **return** the destination as JSON and let the frontend navigate. Cost: the whole of the S130 connect route, found at the close.

**A 400 on a new guarded route can hide a second fault.** In S130 the 400 was read as proof the guard worked. It was — but the same 400 was also masking a route that could never work from a browser. The guard runs before the controller, so nothing about the controller was tested. When a policy refuses, the action behind it is still completely unproven.

**`allowNull` cannot be used with type `ref` or `json` in a Sails model.** It takes the app down at lift with `Failed to lift app: userError`. Waterline names only the **first** offending attribute, so three bad attributes look like one bug and cost three restarts if fixed one at a time. Fix them all in one pass. Cost dev roughly forty crash-loop restarts in S130.

**A dead Sails process still reads `online` in `pm2 status`.** The restart counter and a low memory figure are the tells — a booted AbleTrace sits near 175mb, a crash-looping one near 17mb. `pm2 status` is not a health check. The curl is.

**Long pastes into the terminal garble.** A 25-line heredoc broke mid-line in S130. RULES §5.2 already says anything long goes as a file; this is what happens when it does not. It also cost a wasted delete of a file that was probably fine.

**`res.badRequest` in this app is 400, not 403.** An unauthenticated hit on a guarded route returns 400 `No token provided`, from `api/policies/isAuth.js`. A 400 on a new route is the guard working, not a broken route.

**Carried from S129, still true:**
- **Intuit Save button** has no visible Save until a field is edited, and it sits at the top of the panel. Reload the page and look again — the only check that distinguishes saved from not.
- **Authorization codes are single-use, ~10 minutes.** Reuse returns `invalid_grant`, which reads like a credential failure and is not.
- **`ReviewDetails.Status` on SES is a record, not a status.**
- **nginx `grep -r` skips symlinks.** Already TRAPS 10.
- **Prod cannot ssh to dev.** The pem exists only on the Mac.
