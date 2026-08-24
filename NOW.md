# NOW

Rewritten whole at the close of S135.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply on 19 Aug. Nothing to do until AWS answers.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` while the reply sits unread. Read the CaseId beside it — if it is still `178710371200148`, no new review has opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

⚠ **SES does not block QuickBooks.** Nothing in Phase 1 or 2 sends email.

**Old account 350466202408 — teardown parked.** SES is its only live dependency. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Prod has not been touched since before S130.** No `quickbooks_tokens` table, no QuickBooks code, no QuickBooks role or task rows. Correct until Phase 3.

**Prod's git checkout lags the served build.** Deliberate — P8.

**Both boxes report "system restart required."** Noted S135, not acted on. Belongs with P248.

**Dev backend carries one untracked item** — `node_modules.old-node18/`, deliberate (P227). The S133 patch script was deleted at the S135 open.

**Dev frontend repo reads `c2a52d8e`, not the deployed sha.** Expected and permanent — frontend is edited on the Mac; dev's checkout is not the arbiter for it.

**Mac frontend carries one untracked item** — `s135-qb-auth-header.py`, the patch script whose output is committed. Debris. Delete at the S136 open:

```
rm ~/abletrace-lab-frontend/s135-qb-auth-header.py
```

---

## P245 PHASE 1 — DONE

**Verified on screen S135, logged in as `test260703`, reached by clicking:**

```
Connected
Sandbox Company CA 26d2
Realm 9341457751382548
```

Read live from Intuit on each page load, not from a stored row. That was the whole verification target.

**Backend `7bdb711`. Frontend `a669d7ed`**, CI green, deployed `dev-a669d7edb884`.
```
/home/ubuntu/www-html.bak-dev-a669d7edb884     rollback, read off the box
```

### Two faults fixed to get there, both worth remembering

**1 · A master role row created by SQL grants nothing.** S133 inserted `company_user_role` directly. The app's own creation path copies every `role_task` for that role into `company_user_task` — SQL runs no application code, so that copy never happened. The row looked perfect in every table.

Proved side by side before the fix:
```
2041 | company_user 570 (SQL-made)  | is_master 1 | task_row NULL
2043 | company_user 571 (app-made)  | is_master 1 | task_row 7507 QuickBooks
```
Fix was Remove then Add Master User + through the UI, which re-ran the app path. Result:
```
2045 | company_user 570 | is_master 1 | task_row 7509 QuickBooks
```

⚠ **Consequence for Phase 3: the role and task rows on prod must be created through the UI, not by SQL.**

**2 · The QuickBooks service sent no authorization header.** Written in S134 with bare `http.get`. `isAuth` returned 400 `"No token provided"` before the controller ran — measured in the Network tab, Response body. This app has **no HttpInterceptor**; every service sets the header per call. Fixed to match `api.service.ts`. Affected connect as well as status.

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four different reasons, all before the controller. The response body is what distinguishes them.

---

## THE JOB — S136

**Prepare the ground for the round trip. Seven items, in order. No sending code this session.**

### 1 · Stop the product form adding quote marks

```
src/app/Layouts/admin-dashboard/admin-formulation/add-new-formulation/add-new-formulation.component.ts:624
  myCode: JSON.stringify(this.formulationForm.get('myCode').value),
```
Delete the `JSON.stringify`. The **edit** form at `edit-formulation.component.ts:1214` already sends it raw and is correct — that is why only products created through *Add New* are affected.

⚠ **Do this before item 4.** The customer field is the same kind of field; if the cause is still live, the new column inherits it on day one.

### 2 · Clean the 26 bad rows

Measured S135:
```
4 rows   myCode starts with a quote mark
22 rows  myCode holds the four-letter string 'null'
```
`JSON.stringify(null)` returns `"null"` — same line, same cause.

⚠ **This is a live write.** Back up the rows, scope by `id` and `company_id`, say out loud it is a live write. Minty decides whether to heal.

### 3 · Three new columns on `packingslips`

Estimate number, invoice number, send status. Minty's ruling: the invoice number field sits **between Shipping Reference and Vehicle condition** on the packing slip screen. Shipping Reference stays as it is, for clients who do not use QuickBooks.

⚠ **Send status is not optional even in a bare round trip.** Without it a failed send and an unsent slip both read blank.

### 4 · One new column on `companycustomers`

Holds the **QuickBooks customer display name**. Minty's ruling S135: internal ID and external ID, same convention for products and customers.

| | internal ID | external ID |
|---|---|---|
| Product | `internalCode` — FO-0011 | `myCode` — the QuickBooks SKU |
| Customer | `customer_no` — CUST-0009 | **new column** — the QuickBooks display name |

### 5 · The field on the customer form

So it can be typed. Manually entered by design, same as `myCode`.

### 6 · Set the fixture value

Type `Testcustomer` into it for AbleTrace customer **4778**.

### 7 · Check the duplicate guard on the new field

Within a company. See the pending item below.

### How it is verified

**The new field visible on the customer form, `Testcustomer` typed into it and read back from the row. The three new columns present on `packingslips`. A product saved through Add New whose `myCode` has no quote marks.**

---

## MATERIAL — measured in S135, do not re-derive

### The fixture, ready and shipped

**In AbleTrace, dev**
```
PS-0031   packingslips id 2416   shipped_flag 1   2026-08-24 13:20:23   company_id 464
DO-0017   MO-0020   50 units (50.000 Kg)   ship to 10618, 240 St
Product   formulations id 3714   title Testpdtqb260820   internalCode FO-0011   myCode "SB001"
Customer  companycustomers id 4778   customer_no CUST-0009   customer_name Testcustomer
          address 10518, 240 St
Stock     formulations.inventory_units now 0
```

⚠ **PS-0031 is shipped and cannot be changed.** Minty's ruling S135: a PS or DO can be cancelled before shipping; once the Ship button is pressed neither can be altered. **So the Send button belongs on a shipped slip only.** A second test slip means a new MO, DO and PS.

⚠ **The product is 1:1 — 50 units, 50 Kg.** TRAPS 9: a ratio of exactly 1 makes a division invisible. Phase 2 proves the pipe, not the arithmetic. Any quantity check needs `test1.39`.

**In QuickBooks sandbox `Sandbox Company CA 26d2`, realm `9341457751382548`**
```
Product   Testpdtqb260820   SKU SB001   Inventory   price 25   qty on hand 0
Customer  display name  Testcustomer          <- the match key
          company name  Testcustomercompany   <- deliberately different
          nameId 68 (from the URL, /app/customerdetail?nameId=68)
          billing 10518, 240 St   tax 13%
```

⚠ **Display name and company name were made different on purpose, S135.** They were both `Testcustomer`; if the send matched the wrong field it would have worked by accident. Same principle as bill-10518 / ship-10618.

⚠ **A stray `Testcustomer-1` could not be deleted** — QuickBooks makes customers inactive rather than deleting. Renamed to `abc` instead. Nothing named Testcustomer remains except the real one. **The list still counted 31, not 30 — worth one look before relying on it.**

### The four quoting facts

```
mysql abletracelab_live -e "SELECT HEX(myCode), myCode FROM formulations WHERE id=3714;"
  -> 22534230303122   "SB001"          22 is a quote mark at each end
mysql abletracelab_live -e "SELECT COUNT(*) FROM formulations WHERE myCode='null';"
  -> 22
mysql abletracelab_live -e "SELECT COUNT(*) FROM formulations WHERE myCode LIKE '\"%';"
  -> 4
grep -rn "myCode" ~/abletrace-lab-backend/api/ | grep -v "//"
  -> req.body.myCode straight through, no quoting anywhere in the backend
```
Cause found at `add-new-formulation.component.ts:624`.

### The customer uniqueness facts

```
mysql abletracelab_live -e "SELECT company_id, customer_name, COUNT(*) n FROM companycustomers GROUP BY company_id, customer_name HAVING n > 1;"
  -> empty.  1059 customers, no duplicate names within any company.
```
**AbleTrace's guard is real, measured, not assumed.**

**QuickBooks refuses a duplicate display name** — tried in the sandbox S135, returned "Something's not quite right", and the record it did create was named `Testcustomer-1` while keeping the same company name. **So display name is unique on both sides. Company name is not a key** — `Oxon Insurance Agency` / `Oxon - Holiday Party` / `Oxon - Retreat` share a phone number.

### What Intuit actually returns — measured, not remembered

Query run on dev against the live sandbox:
```
TOK=$(mysql -N -B abletracelab_live -e "SELECT access_token FROM quickbooks_tokens WHERE company='sandbox260820';")
curl -s -H "Authorization: Bearer $TOK" -H "Accept: application/json" "https://sandbox-quickbooks.api.intuit.com/v3/company/9341457751382548/query?query=select%20*%20from%20Estimate"
```

**A converted estimate carries a link to its invoice.** This was the single biggest unknown in Phase 2 and it is now answered:
```
Id 119   DocNumber 1002   "TxnStatus":"Closed"
         "LinkedTxn":[{"TxnId":"123","TxnType":"Invoice"}]
Id 121   DocNumber 1004   "TxnStatus":"Pending"    no LinkedTxn
```
So *Get invoice number* works as designed: read the estimate by Id, check `LinkedTxn`.

**Four more facts from the same response:**
```
DocNumber            the estimate number -> goes on the slip
CustomerRef.value    the QuickBooks customer id
ItemRef.value        the QuickBooks item Id  -- NOT the SKU
BillAddr / ShipAddr  separate fields, both present
TxnTaxDetail         tax computed by QuickBooks, TaxCodeRef per line
```

⚠ **Estimate lines reference items by internal Id, not SKU.** `myCode` holds the SKU. **So the send must look the item up by SKU first, then use the Id.** Settled by looking at the sandbox screens: the Products list shows SKU as a proper column; **no internal Id is visible anywhere, not on screen and not in the URL.** A client can type a SKU. They cannot find an Id. Lookup is the only workable design.

⚠ **The customer screen shows no id either** — hence matching on display name.

⚠ **The token expires in hours.** Raw curl returns `401 Token expired`. Loading the QuickBooks page in AbleTrace refreshes it first; do that before any manual curl.

### Guarded curl on dev
Header `authorization: bearer $TOK`, **lower case**, or `isAuth` refuses.
```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;")
curl -s -H "authorization: bearer $TOK" localhost:1337/api/quickbooks/status
```

### Frontend build and deploy

```
npm run build-dev              # = ng build --configuration=dev --aot. No 'development' configuration exists.
~/promote.sh ~/Downloads/dist-dev-<sha>.zip dev
```
⚠ **`promote.sh` lives in the home directory, not in the repo.** Cost a minute in S135.
⚠ **A local build is not the CI artifact.** Push, let CI build, download the artifact, promote that. Then **Shift+Cmd+R**.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive, Angular's AOT compiler is not. Cost one build.

**The QuickBooks API base is NOT `environment.apiUrl`.** The service strips `/v1/`:
```
private base = environment.apiUrl.replace(/\/api\/v1\/?$/, '/api/');
```
⚠ Do not tidy the QuickBooks routes into v1. Intuit's registered redirect URI is the arbiter.

### The permission chain

```
company_users -> company_user_role -> company_user_task -> role_task
```
`role_task` is the catalogue of what a role **may** reach. `company_user_task` is what a user **does** have. A role alone puts the tab in the left strip; the task grant is what makes the page work.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is. Log out and back in.

---

## ANALYSIS ALREADY DONE

**Why status reads the name live from Intuit.** A row can hold a revoked connection and still look fully populated. Every failure returns `connected:false` rather than a stale name, with the real reason in `sails.log.error`.

**Why connect returns JSON instead of redirecting.** It sits behind `isAuth`, which reads a header a browser navigation cannot send. Cost S130 a session.

**Why the callback is public.** Intuit redirects back with no token. The guard is the single-use `state`, held in memory, deliberately not surviving a restart.

**Why the company column on the token store.** Minty's ruling S129. Phase 3 puts two clients on their own books; with the column that is two more rows.

**Why a tab is a role, not a component.** The left strip is built from the user's own roles. Adding a tab is a database insert, which reaches neither box by deploying.

⚠ **git cannot tell you what a session did.** A session that touches the database leaves no trace in git.

---

## PHASE 2 — THE ROUND TRIP

**PS-0031 in AbleTrace becomes an invoice in QuickBooks, and its number comes back onto the slip.**

### The flow, settled with Minty S135

1. **AbleTrace.** Slip is shipped. Press **Send to QuickBooks**.
2. **QuickBooks.** An **estimate** appears. Its number comes back in the same response and shows on the slip immediately.
3. **The admin, inside QuickBooks.** Opens the estimate, presses **Create invoice**. QuickBooks applies price and tax.
4. **Back in AbleTrace.** A **Get invoice number** button reads the estimate, finds `LinkedTxn`, stores the invoice number. Pressed too early it says the estimate is still open.

**The estimate number is the thread between the two systems.**

⚠ **Nobody is notified.** Someone in AbleTrace presses the button. No automatic alert either way.

⚠ **Send only from a shipped slip.** Minty's ruling S135: shipped is final, and an estimate for goods that did not ship is a credit note and an awkward call.

### Minty's rulings — settled, do not re-open

| | |
|---|---|
| **Who creates the invoice** | QuickBooks. AbleTrace sends only what shipped |
| **Price and tax** | QuickBooks. One price list, one source of truth |
| **Ship-to address** | AbleTrace's, from the dispatch order |
| **Bill-to address** | QuickBooks' own stored address |
| **The invoice** | shows **both** bill-to and ship-to |
| **Quantities** | unit counts, read across. Never derived from weight — RULES §7 |
| **After it is sent** | the invoice number is the record. Edits or voids in QuickBooks are outside AbleTrace's purview |
| **Product matching** | by SKU held in `myCode`, then looked up to get the QuickBooks item Id |
| **Customer matching** | by QuickBooks **display name**, held in the new external ID column |
| **Both external IDs** | manually entered by design |

### Failure handling — agreed in principle, mostly deferred

1. **A status on every slip, always visible.** Not sent / sending / sent + number / failed. **In scope for S136** — it is column three.
2. **The reason, in plain words, on the slip.** Deferred.
3. **A retry button.** Deferred.
4. **A list of slips shipped with no invoice number.** Deferred.

⚠ **P240 applies with force.** A silent failed invoice is worse than a silent failed email. Under Minty's ownership ruling Mintek cannot look at a client's QuickBooks, so the slip has to say so itself.

### Pending, unranked

**Neither external ID has a duplicate guard.** Both are typed by hand and they are the only link between the systems. A duplicate puts a line on the wrong customer's invoice — no error, plausible output. When built: scope uniqueness **per company**, enforce at the write and not only on the form, sweep existing data first.

⚠ **Half the risk is already covered on the customer side** — `customer_name` is unique per company, measured. The new external column is not.

---

## PHASE 3 — TWO CLIENTS, LIVE BOOKS

**Clients do not get sandboxes. They connect their real QuickBooks.** Each client clicks Connect, signs in, approves, and gets their own row in `quickbooks_tokens` under their company name.

⚠ **The company must come from the logged-in session, never from a parameter.** The status route currently falls back to a hardcoded `sandbox260820`. Harmless with one sandbox; wrong the moment there are two clients. **Must change before any real client connects.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- `CREATE TABLE` and the schema changes all run on prod separately. Deploying does not carry them.
- **The role and task rows must be created through the UI on prod, not by SQL.** See Phase 1 above.
- A **Reconnect URL** is a mandatory field in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.

**Minty's ruling on ownership — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories either. Today Minty can see everything because it is early; that is a temporary state, not the design.

**Direction, not to be built yet:** support access is **break-glass** — closed by default, opened only with the client's consent, expiring on its own, and logged.

⚠ **Consequence to accept:** when a client's connection breaks Mintek cannot look. Which is why the four failure-handling items are not optional, and why the reconnect flow must be usable by a non-technical person unaided.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every line carries a tax code and an accountant will see it.

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
| P240 | The app cannot tell anyone a send failed. **Phase 2 raises this from housekeeping to a prerequisite** |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks integration — **active. Phase 1 complete and verified on screen S135. Phase 2 in S136/S137** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22 pending. **Both boxes now report "system restart required."** Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load. Affects every route. A client who bookmarks or refreshes a screen is thrown out. Found S134 |
| P250 | **No role or company check in the policy layer.** `isAuth` proves only that someone is logged in. ⚠ Scope: whether individual controllers filter by `company_id` was **not** measured — the job is *verify every route filters*, not *build separation*. Sits with P247 |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out and probably goes. Also cross-check how Food Safety System was set up, since it sits under both Admin and its own controller |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |
| — | Pending, unranked: external ID duplicate guard, both sides. See Phase 2 above |

**Closed in S135**
- **P245 Phase 1.** Company name visible on an AbleTrace screen, reached by clicking, as `test260703`.
- The permission chain found and fixed — `company_user_task` is the layer, and a SQL-made master role grants nothing.
- The missing authorization header on the QuickBooks service. Frontend `a669d7ed`, deployed `dev-a669d7edb884`.
- Phase 2 fully specified: every open question measured, including Intuit's `LinkedTxn`.
- The quoting fault traced to one line of code.
- The fixture built, shipped and made unambiguous.
