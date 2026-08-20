# NOW

Rewritten whole at the close of S129.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply to AWS's four questions at 11:00 PDT on 19 Aug. Nothing to do until AWS answers.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` for as long as the reply sits unread. It is not a second refusal. Read the CaseId alongside it — if the CaseId is still `178710371200148`, no new review has been opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

**Old account 350466202408 — teardown parked.** SES is the only remaining live dependency. Everything else is gone. Blocked until SES migration completes. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Dev backend carries `?? node_modules.old-node18/`.** Deliberate — P227. A dirty tree line that is not a finding.

**Prod's git checkout lags the served build.** Deliberate — P8. The `www-html.bak-*` line in the open check is the only reliable read of what is live.

**P245 Phase 1 — everything outside our code is proven.** App registered, redirect URI saved and verified after reload, scopes measured, Canadian sandbox created and connected, development secret rotated and tested end to end against `Sandbox Company CA 26d2`, returning 200. Nothing is built in AbleTrace yet. No `.env` entry, no table, no routes.

---

## THE JOB — S130

Build the QuickBooks OAuth connection inside AbleTrace.

### The action

1. Put the QuickBooks credentials into dev's `.env`. By file, never through chat.
2. Create the token store table. Company column from day one.
3. Build the connect route — sends the browser to Intuit.
4. Build the callback route at `/api/quickbooks/callback` — exchanges the code, stores both tokens and the realm.
5. Build the refresh helper — always writes back the newest refresh token.
6. Verify on screen: AbleTrace reads back the company name from QuickBooks.

### The material

Everything this job needs, measured in S129.

**Intuit app**
- Workspace `Abletrace_qbintuit`
- App `Abletrace`, AppID `90bf69f7-81d5-4c3b-8d51-5f2b566a808f`
- Status IN DEVELOPMENT. Development keys only, sandbox only. Production keys are a Phase 3 step.
- Client ID and client secret are in **Section H**. Secret rotated 20 Aug and proven working. The value that appeared in the S129 chat log is dead.
- The secret is re-readable at any time via Keys and credentials → Development → Show credentials. It is not lost-on-creation like the SES key.

**Sandbox**
- `Sandbox Company CA 26d2`
- Realm ID `9341457751382548`
- Plus · Region **CA** · Accounting only, no Payments
- Created 19 Aug 2026, valid two years
- The US sandbox `Sandbox Company US 80fd`, realm `9341457628433780`, still exists and is **not** to be used. It was an account default, not a decision.

**Scope — accounting only**
```
com.intuit.quickbooks.accounting
```
The Permissions page has both accounting and payment ticked. That list only defines what the app *may* request. Deliberately left alone; the request decides what the client consents to. AbleTrace does not move money.

**Redirect URI — registered and verified**
```
https://dev.mintekfoodsafety.com/api/quickbooks/callback
```
56 characters. Must match character for character. Registered alongside Intuit's Playground URI, which stays.

**nginx on dev — measured S129**
- Config is `/etc/nginx/sites-available/dev.mintekfoodsafety.com`, symlinked from `sites-enabled`
- `server_name dev.mintekfoodsafety.com`
- `location /api/` → `proxy_pass http://localhost:1337/api/` — prefix preserved
- HTTPS already live via Certbot, `listen 443 ssl`

So `/api/quickbooks/callback` reaches Sails as `/api/quickbooks/callback`. No nginx change is needed.

**Endpoints seen in the Playground request**
- Authorize: `https://appcenter.intuit.com/connect/oauth2`
- Token exchange: `POST https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer`
- Body: `grant_type=authorization_code`, `code=…`, `redirect_uri=…`
- Auth header: HTTP Basic, `client_id:client_secret` base64-encoded

⚠ The sandbox **API base** (for reading the company back) was not measured in S129. Confirm it at S130 rather than assuming — the Playground's Step 3 "Get cURL" will show it.

**Token lifetimes — measured from a live 200 response, 20 Aug**
- `expires_in: 3600` — access token, one hour
- `x_refresh_token_expires_in: 8726400` — refresh token, 101 days
- `x_refresh_token_expires_in` is returned on **every** refresh. Store it. It is how the code knows a client must reconnect, instead of finding out when an invoice fails.

**Error discrimination — measured, both seen in S129**
- `invalid_grant` / "Authorization code incorrect" → the **code** is spent or expired. Codes are single-use and last roughly ten minutes.
- `invalid_client` → the **secret** is wrong.

These are different errors. When the callback misbehaves, this tells us which half is at fault without guessing.

**Token store columns**

| column | why |
|---|---|
| company | whose books this opens |
| realm_id | QuickBooks' number for that company |
| access_token | the hourly pass |
| refresh_token | used to get a new hourly pass |
| access_expires_at | when to renew |
| refresh_expires_at | from `x_refresh_token_expires_in` |
| connected_at | when the client last authorised |

### The analysis

**Why a table and not `.env`.** The refresh token rewrites itself continuously while the app runs — roughly daily, and the old value is force-expired the moment a new one is issued. Nothing writes to `.env` at runtime. The client ID and secret are static and belong in `.env`; the per-company connection does not.

**Why the company column now.** Minty's ruling, S129: Phase 3 puts Glutenull and Hagensborg on their own QuickBooks. With the column, Phase 3 is two more rows. Without it, the table is rebuilt when live client books are already involved — the worst possible moment to move a credential.

⚠ **The single most common way these break.** If two processes refresh at once, one stores the new refresh token and the other overwrites it with the stale one. Every call fails from then on, permanently, until a human re-authorises. Design the guard in; retrofitting it is expensive.

**Rule: always write back the newest refresh token, every time, without exception.**

**What OAuth buys.** The client signs in at Intuit, not at AbleTrace. AbleTrace never holds a client's QuickBooks password, the client sees AbleTrace in their connected-apps list, and they can disconnect it themselves. Scope is accounting-only and company-specific, so a bug in one client's mapping cannot reach another's books.

### The verify

**AbleTrace displays the name `Sandbox Company CA 26d2`, read live from QuickBooks, on a screen.**

Not a 200 in a log. Not a row in the table. The name on the screen. Anything less is deployed, not proven.

---

## AFTER S130 — PHASE 2

Minty's phasing, S129.

Dummy products in AbleTrace, matching items in the sandbox, then packing slip → QuickBooks invoice → **invoice number returns into the shipping reference**. That round trip is the success test: it proves AbleTrace both wrote and read back, and it gives the audit link and the duplicate guard for free.

⚠ **Phase 2 proves the plumbing, not the fit.** With a handful of dummy products, matching them to QuickBooks items is trivial. With a real catalogue it is the hardest part of the whole job — along with customer matching and tax codes. Expect that, so Phase 3 does not feel like a setback.

**Phase 3** — Glutenull and Hagensborg on their own books. Needs Intuit **production** keys, a fresh authorisation per client, and the real mapping decisions.

⚠ Production keys reach live client books. They never come near chat, in any form.

**Later, its own phase** — material receipts → supplier bills, with the supplier invoice linked to the receipt. Bigger than it looks: one PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision, not a technical one.

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
| P245 | QuickBooks integration — **active, Phase 1** |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

**Closed in S129**
- P212 — RULES.md does not auto-load from the project panel. It is pasted at the open. Closed.

---

## TRAPS RECORDED IN S129

For TRAPS.md when that file is next opened.

**Intuit Save button.** The Settings page has no visible Save until a field is edited, and it sits at the top of the panel, not the bottom. A redirect URI typed and left looks saved and is not. **Reload the page and look again** — that is the only check that distinguishes the two.

**Authorization codes are single-use and short-lived.** Roughly ten minutes. Sending the same code twice returns `invalid_grant`, which reads like a credential failure and is not.

**`ReviewDetails.Status` on SES is a record, not a status.** See STATE above.

**nginx `grep -r` skips symlinks.** `grep -r server_name /etc/nginx/sites-enabled/` returned empty on a box that has a working site config, because the entry is a symlink into `sites-available`. Already TRAPS 10; confirmed again S129.

**Prod cannot ssh to dev.** The pem exists only on the Mac. RULES §2. Attempted twice in S129; failed harmlessly both times.
