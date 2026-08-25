# NOW

Rewritten whole at the close of S137.
Read RULES.md and this file. Nothing else at the open.

**Everything S138 needs is measured and quoted below.** The schema is in place, the fixture is complete and shipped, both QuickBooks lookups are resolved to concrete ids, and both routes are designed on paper. **S138 writes code from the first minute.**

---

## STATE

What no command returns.

**Dev backend is `8141e73`** — the five `qb_*` attributes are declared on the PackingSlips model, committed and pushed. **The table already had the columns** (added S136). Nothing half-done.

**SES — AWS answered on 22 Aug and REFUSED.** Case `178710371200148` on the new account `208073623096`. Their words: concerns they will not specify, citing security. **No production SES on the new account.**

⚠ **Consequence: the old account 350466202408 cannot be torn down.** Production SES appears to exist only there — a permanent dependency, not a parked one. See the estate pending point in the queue.

⚠ **Still does not block QuickBooks.** Nothing in Phase 1, 2 or 3 sends email.

**Prod untouched since before S130, on Node v18.** Both deliberate. No QuickBooks anything on prod until Phase 3.
```
/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
```

**Both boxes report "system restart required."** Noted S135, still not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Dev frontend repo reads `c2a52d8e`, not the deployed sha.** Permanent and expected — frontend is edited on the Mac; dev's checkout is not the arbiter for it.

**Deployed frontend is `82ae3c3c`.**
```
/home/ubuntu/www-html.bak-dev-82ae3c3c9df3     rollback, read off the box
```

⚠ **The backup name points at the build going IN. Its contents are the build coming OUT.** Measured S136 by diffing the new backup against `dev-a669d7edb884`. So the newest backup's *name* is the live commit and its *contents* are what you roll back to.

---

## THE JOB — S138

**Write the two routes, send the estimate for PS-0032, convert it by hand, fetch the invoice number back.**

### The action, in order

1. **Write `POST /api/quickbooks/send-estimate`** — design below, ids below.
2. **Send it for PS-0032** from curl on dev first, before any frontend exists.
3. **Look at the estimate in the QuickBooks sandbox** — confirm the line description carries `PS-0032` and `QB PO-001`.
4. **Convert it to an invoice by hand** in the sandbox.
5. **Write `GET /api/quickbooks/invoice-number/:id`** — two calls, see the analysis.
6. **Prove which fields survived conversion** — read the invoice back and look for the description text.
7. **`SELECT` row 2417** showing all four `qb_*` values populated.
8. **Then the screen block**, if there is session left. It is the smallest piece and the only one with no unknowns.

⚠ **Do NOT run any `ALTER TABLE`.** The five columns already exist — measured this session, output quoted below. This was nearly done blind.

---

### The material

Everything below was measured in S137. The command and its return are beside each.

#### The columns already exist

```
mysql abletracelab_live -e "SHOW COLUMNS FROM packingslips LIKE 'qb%';"
```
```
qb_estimate_id  varchar(64)  YES  NULL
qb_estimate_no  varchar(64)  YES  NULL
qb_invoice_id   varchar(64)  YES  NULL
qb_invoice_no   varchar(64)  YES  NULL
qb_send_status  varchar(32)  NO   not_sent
```

#### The fixture — complete, shipped, measured end to end

**PS-0032**, created and shipped in S137 specifically so the PO number is exercised. PS-0031 has a null PO and proves only half the description.

```
mysql abletracelab_live -e "SELECT p.id, p.internalCode, pd.DO_id, pd.shipped_qty FROM packingslips p JOIN packingslipdos pd ON pd.PS_id=p.id WHERE pd.DO_id=(SELECT id FROM dispatchorders WHERE SO_id=2520)\G"
```
```
id: 2417   internalCode: PS-0032   DO_id: 10938   shipped_qty: 25
```

```
mysql abletracelab_live -e "SELECT id, internalCode, SO_Ref_No, customer_id, company_id FROM somanagement WHERE internalCode LIKE '%0016%'\G"
```
```
id: 2520   internalCode: SO-0016   SO_Ref_No: QB PO-001
customer_id: 4778   company_id: 464
```

```
mysql abletracelab_live -e "SELECT id, title, myCode, HEX(myCode) FROM formulations WHERE id=3714\G"
```
```
id: 3714   title: Testpdtqb260820   myCode: SB001   hex: 5342303031
```
⚠ **Five bytes, no quote characters.** The S136 quoting fault does **not** affect this row. Nothing to strip in the send path.

**The chain, in full:**
```
packingslips 2417 (PS-0032)
  -> packingslipdos  PS_id 2417, DO_id 10938, shipped_qty 25
  -> dispatchorders  10938 (DO-0018), formula_id 3714, SO_id 2520
  -> somanagement    2520 (SO-0016), SO_Ref_No "QB PO-001", customer_id 4778
  -> companycustomers 4778, Testcustomer, external_id "Testcustomer"
  -> formulations    3714, myCode SB001
```
⚠ `SO_id` on DispatchOrders is a model association to **`SOManagement`** — `api/models/DispatchOrders.js:22`. There is no `salesorders` table.

⚠ `company_id` is a **double** on `companycustomers` and `dispatchorders`, an **int** on `packingslips` and `packingslipdos`. This join crosses that boundary twice.

#### The two QuickBooks ids — resolved, no lookup needed to test

```
select Id,Name,Sku,Type from Item where Sku = 'SB001'
```
```
Item Id 28   Testpdtqb260820   Type Inventory
```
⚠ The route must still **do** the lookup by SKU — a client can type a SKU, never an Id. Id 28 is here so a first curl can be built without one.

**Customer** matches on display name = `external_id` = `Testcustomer`. Measured S136; no id is visible on the QuickBooks customer screen either.

#### The token

```
mysql abletracelab_live -e "SELECT company, realm_id FROM quickbooks_tokens;"
```
```
company: sandbox260820   realm_id: 9341457751382548
```

⚠ **The access token expires in hours.** Any hand-run script that reads it straight from the table will hit `401` mid-session. **Load `dev.mintekfoodsafety.com/quickbooks` in Chrome first** — that page calls `getAccessToken()`, which refreshes and writes back. Happened twice in S137. **The real routes do not have this problem** — they call the service.

Scaffolding pattern that works — the token never reaches the screen:
```
cd ~/abletrace-lab-backend && TOKEN=$(mysql abletracelab_live -N -B -e "SELECT access_token FROM quickbooks_tokens WHERE company='sandbox260820';") node -e "..."
```
⚠ **`mysql2` is not a dependency.** A `require('mysql2/promise')` fails. Use the shell variable above.

#### The estimate shape, read live from the sandbox

Estimate Id 119, `GET /v3/company/<realm>/estimate/119?minorversion=75`:
```
"DocNumber": "1002"          <- this is the estimate number
"TxnStatus": "Closed"
"LinkedTxn": [{"TxnId":"123","TxnType":"Invoice"}]
"CustomField": []            <- empty
Line[].SalesItemLineDetail.ItemRef.value = internal Id
Line[].Description, Line[].SalesItemLineDetail.Qty
```

#### Custom fields are OFF — measured, not assumed

`GET /v3/company/<realm>/preferences` → `Preferences.SalesFormsPrefs`:
```
UseSalesCustom1  false
UseSalesCustom2  false
UseSalesCustom3  false
CustomTxnNumbers true
AllowEstimates   true
```
⚠ **All three custom slots are off**, which is why `CustomField` came back empty. **We are not using them** — see the decision below.

---

### The analysis

#### Decisions taken in S137, all Minty's

**1 · Status vocabulary — four words.** `not_sent` · `sent` · `invoiced` · `failed`. The failure *reason* is out of scope for now — P240 item 2.

**2 · The QuickBooks invoice must show the AbleTrace packing slip number.** QuickBooks knows nothing about AbleTrace; the characters only appear if we write them onto the estimate.

**3 · Both references ride in ONE line description. Custom fields are left alone.**
```
PS-0032 · QB PO-001 — Testpdtqb260820
```
Format: `<PS internalCode> · <SO_Ref_No> — <product title>`. **PO part omitted when `SO_Ref_No` is blank.**

Why not a custom field: all three slots are off, each client's admin would have to enable and name one in their own settings, and they may already be using them. Description is a standard field on every estimate on every client's books. Why not a second line: every extra line is another row an accountant reads as goods.

⚠ **Whether the description survives estimate → invoice conversion is NOT measured.** It is expected to. **Step 6 is what proves it.** If it does not survive, the fallback is the customer memo, and that is a fresh decision.

**4 · Send is only allowed once the slip is SHIPPED.** Minty's ruling, carried from S136 and restated in S137: **ship is the final step and nothing can change after it.** An estimate must never be built from a slip that can still be edited, or QuickBooks holds numbers AbleTrace later contradicts.

⚠ **The Send estimate button must be DISABLED until shipped.** Build it that way; do not retrofit.

**5 · Placement on the screen.** A QuickBooks block at the **bottom of the packing slip screen, above Print**, after Shipping Supervisor. Shows Status, Estimate number, Invoice number — all read-only — plus **Send estimate** and **Get invoice number**. ⚠ **The two `_id` values are stored but never displayed.** They are Intuit's internal handles and mean nothing to a user.

#### The two routes, designed

**`POST /api/quickbooks/send-estimate`**

- **Who calls it** — the Send estimate button, logged-in staff. Must set `authorization: bearer <webToken>` explicitly. ⚠ This app has **no HttpInterceptor**; a service that omits it is unreachable from the browser while working perfectly from curl.
- **What they send** — `{ ps_id: 2417, company_id: 464 }`. ⚠ House pattern, Minty's ruling S137 — see the analysis. Not from the session; there is no session company.
- **What comes back** — `{ ok:true, estimate_id, estimate_no }` or `{ ok:false, reason }`.

Order of work inside:
1. Walk the chain above from `ps_id` → customer `external_id`, `SO_Ref_No`, product `myCode` and title, `shipped_qty`.
2. Query QuickBooks customer by display name. Not found → stop, status stays `not_sent`, reason returned.
3. Query QuickBooks item by SKU, take its **Id**. `ItemRef.value` wants the Id.
4. One line: `Qty` = shipped units, `Description` per the format above. **No price, no tax** — QuickBooks owns both.
5. POST the estimate. Store `qb_estimate_id` = Id, `qb_estimate_no` = DocNumber, `qb_send_status` = `sent`.

**`GET /api/quickbooks/invoice-number/:id`**

⚠ **Two calls, not one.** `LinkedTxn` gives the invoice's **TxnId**, never its number.
1. Read the estimate by stored `qb_estimate_id`.
2. No `LinkedTxn` → **"not converted yet"**, which must be a **distinct answer from a failure**. Status unchanged.
3. `LinkedTxn` present → read the invoice by that TxnId, take its `DocNumber`.
4. Store `qb_invoice_id`, `qb_invoice_no`, status → `invoiced`.

#### The pattern to copy

`api/controllers/QuickbooksController.js`, the `status` method, **lines 137–190**. It shows the whole shape: `QuickbooksToken.findOne({company})` → `quickbooksService.getAccessToken(company)` → base from `process.env.QUICKBOOKS_API_BASE || 'https://sandbox-quickbooks.api.intuit.com'` → `Authorization: 'Bearer ' + token`.

⚠ **Capital B for Intuit. Lower case for AbleTrace's own `isAuth`.** Two different headers, two different conventions, in the same request path.

⚠ **`company` currently falls back to a hardcoded `'sandbox260820'`.** Harmless with one sandbox, wrong the moment there are two clients. **Must go before Phase 3.**

⚠ **RESOLVED S137 — do not re-investigate.** `isAuth.js:28` sets `req.user` from the `User` table, which holds super admins only, so there is **no session company to read**. Every existing route takes `company_id` from `req.body` — measured, `PackingSlips.js` lines 74, 148, 250, 354. **Minty's ruling S137: the send route follows the house pattern.** `company_id` arrives in the body alongside `ps_id`. It is no weaker than any other route because it is the same weakness, and fixing it in one route alone would mean building session-company plumbing that does not exist. **The proper fix is P250, app-wide, and is now a Phase 3 blocker.**

`api/controllers/PackingSlipsController.js` is a thin delegator — every method calls `PackingSlips.<sameName>(req,res,cb)`. It never mentions `company_id`.

---

### The verify

1. Curl returns `{ ok:true }` with an estimate number.
2. The estimate is visible in the QuickBooks sandbox and its line reads `PS-0032 · QB PO-001 — Testpdtqb260820`.
3. After manual conversion, the invoice-number route returns a DocNumber.
4. `SELECT id, qb_estimate_id, qb_estimate_no, qb_invoice_id, qb_invoice_no, qb_send_status FROM packingslips WHERE id=2417\G` shows all five populated, status `invoiced`.
5. **If the screen block is built:** the numbers appear on PS-0032 in Chrome after Shift+Cmd+R.

---

## WHAT S137 CHANGED

**Backend `8141e73`** — five `qb_*` attributes added to `api/models/PackingSlips.js`, anchored patch script, `node --check` passed, pm2 restarted, HTTP 200. ⚠ `migrate: "safe"` verified at `config/models.js:53` and `config/env/production.js:106` **before** patching, so declaring attributes alters nothing.

**Data, dev only** — SO-0016, DO-0018, PS-0032 created and shipped. 25 units. **The first fixture carrying a PO number.**

**Nothing on prod. Nothing on the frontend.**

---

## THINGS THAT COST TIME IN S137

**Terminal output pasted back into the terminal — five times.** Every line returned "command not found"; nothing ran and nothing was harmed, but the intended command never executed. ⚠ **Copy only from inside a fenced block, never from the terminal.** RULES §5.1. S106 showed this can silently eat a `git pull`.

**Commands run on the wrong box, twice.** A `[MAC]` line run on dev; the prod health check re-run on dev. ⚠ Prompt colours: Mac cyan, dev green, prod red.

**`formulations` has no `name` column — it is `title`.** Cost two round trips.

**A patch script's backup landed inside the repo** and would have dirtied the tree. Moved to `~/` immediately. Write backups outside the repo.

**S136's own close said the five columns were added, and they were.** An item to add them was nearly carried into S138 anyway. ⚠ **Check the table before writing a schema step into NOW.**

---

## TRAPS CARRIED FORWARD — all look like broken code

**A master role row created by SQL grants nothing.** The app's creation path copies every `role_task` into `company_user_task`. SQL runs no application code, so that copy never happens. The row is indistinguishable from a working one in every table. ⚠ **Consequence for Phase 3: role and task rows on prod must be created through the UI, not by SQL.**

**A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four different reasons, all **before** the controller runs. Only the response body distinguishes them — read it in the Network tab, not the console.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

⚠ **`promote.sh` exists on dev and was not used in S136.** Use it. `unzip` is not installed; `python3 -c "import zipfile; zipfile.ZipFile('<zip>').extractall('<dir>')"`. The dev artifact has no wrapper folder. Dev is `16.55.10.205`.

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P17 | Two old-account IAM keys still valid and in git history, deliberately |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P225 | ~~Sweep Mac Downloads~~ — **done S137, Downloads is empty** |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. **Phase 2 raises this from housekeeping to a prerequisite** |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks integration — **active. Phase 1 done, Phase 2 groundwork done, both routes designed. S138 is the round trip.** Phase 3 is below |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22 pending. **Both boxes report "system restart required."** Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load. Affects every route. A client who bookmarks or refreshes a screen is thrown out |
| P250 | **Authorization is enforced by the screen, not the server. BLOCKER FOR PHASE 3.** ⚠ Measured S137: `PackingSlips.js` lines 74, 148, 250, 354 all take `company_id` straight from `req.body`. The browser says which company; the server believes it. `isAuth` proves only that someone is logged in. The menu, tabs and role layer are sound — a sub-user sees only their sections — but the rule lives in the browser, so a hand-crafted request bypasses it. **App-wide, not QuickBooks.** Harmless today: one sandbox, test companies. Unacceptable with two real clients on one server. The job is *make the server derive the company from the session and filter every route by it* |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| P252 | **External ID duplicate guard, customers and products together.** ⚠ `createCustomer` already checks `company_id` + `customer_name` and returns `Duplicate`; that is the pattern to extend. ⚠ **`editCustomer` has no duplicate check at all** — measured S136 |
| P253 | **No SSH host aliases.** Every `scp` needs the IP typed. Two lines in `~/.ssh/config` removes it permanently |
| P256 | **Dev home is full of dead build folders.** ~50 `dist-dev-*` and `www-html.bak-dev-*` going back to S63, plus two Node tarballs and their unpacked trees — listed S137. ⚠ **Keep `www-html.bak-dev-82ae3c3c9df3` (the live rollback) and one prior.** Check free disk before deciding it is worth doing |
| P254 | **A sales order cannot be edited once created.** Found S137 when a PO number could not be added to SO-0015; a whole new SO, DO and PS had to be built instead. Whether this is deliberate or a gap is a business question |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out and probably goes. Also cross-check how Food Safety System was set up |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode` too; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

### PENDING — the estate. abletrace.ca, with the SES constraint. Unranked; Minty prioritises when Phase 2 lands.

**Two jobs in one, because they are the same job: get everything onto abletrace.ca and reduce the old account to an email-only shell.**

**The original direction was to disconnect from the old account completely.** `mintekfoodsafety.com` was always temporary; the platform lives at **abletrace.ca**. **AWS's refusal makes full disconnection impossible**, so the plan changes shape rather than being abandoned.

**Minty's ruling S135:** keep the old account **for SES and nothing else**. Strip out every other service. Issue **fresh credentials** so nothing carries over. A single-purpose mail sender — as good as new — not "the old estate we never finished leaving."

**Claude to produce a complete route before anything is touched:** what moves, in what order, what points at what, and the rollback at each step.

**Three things must be measured first. None are known today:**
1. **Can old-account SES send from `abletrace.ca`?** The domain is DKIM-verified on the **new** account. Verifying one domain on two accounts is normally allowed, but it needs proving.
2. **Route 53 is inside the old account** (RULES §4). If DNS stays there, the account is not email-only.
3. **Is the refusal final?** If it can be re-filed with a fuller use case, the whole plan may be unnecessary.

⚠ **P17 belongs to this job.** Two old-account IAM keys are still valid and sit in git history.

⚠ **RULES, before removing infrastructure:** ask **what still points at this?** — DNS records, credentials, other AWS settings, accounts outside AWS. **The pointer goes first, the resource second.** ⚠ **A code search cannot find these.** Nothing in the code names them — that is why they get left behind.

### P245 Phase 3 — two clients, live books. Pending, not this session.

Kept here in full so it survives NOW being rewritten. **Nothing below is S138 work.**

**Clients do not get sandboxes.** They connect their real QuickBooks. Each client clicks Connect, signs in, approves, and gets their own row in `quickbooks_tokens` under their company name. The company column was added from the start (Minty's ruling S129) so this is two more rows, not a rebuild.

⚠ **The company must come from the logged-in session, never from a parameter.** The status route currently falls back to a hardcoded `sandbox260820`. **Must change before any real client connects.** ⚠ **This is not possible until P250 is done** — there is no session company anywhere in the app today. **P250 is therefore a hard blocker on Phase 3, not housekeeping.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat, in any form.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- `CREATE TABLE` and every schema change run on prod **separately**. Deploying does not carry them. ⚠ **This includes the five `qb_*` columns and `companycustomers.external_id`, which exist on dev only.**
- **Role and task rows created through the UI on prod, not by SQL** — see the trap above.
- A **Reconnect URL** is mandatory in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories either. Today Minty can see everything because it is early; that is a temporary state, not the design.

**Direction, not to be built yet:** if access is ever needed for support it is **break-glass** — closed by default, opened only with the client's consent, expiring on its own, and logged. Never standing, and nothing added later may quietly create one.

⚠ **Consequence to accept:** under this ruling, when a client's connection breaks Mintek cannot look. Which is why the four failure-handling items are not optional, and why the reconnect flow must be usable by a non-technical person unaided.

**The four failure-handling items** — agreed in principle 21 Aug.
1. ~~A status on every slip, always visible.~~ **Column built S136, model attribute S137.** Putting it on the screen is S138.
2. The reason, in plain words, on the slip — customer not found, product not set up, connection dead, no price. Not buried in a log.
3. A retry button. Most failures are fixed in QuickBooks, then re-sent.
4. A list of slips shipped with no invoice number. The daily check, and where a silent failure would otherwise hide.

⚠ **Silence is the fragile part, not the design.** A connection dies for reasons nobody controls — the client revokes it, a token expires, someone re-authorises. Under any ownership model the failure is invisible unless the slip says so.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

**Closed in S136**
- The quoting fault fixed at source, verified on screen. Frontend `82ae3c3c`.
- Five `qb_*` columns on `packingslips`, one `external_id` on `companycustomers`, dev.
- `external_id` wired through the model, the create path and both customer forms. Backend `4e86e45`.
- The backup naming convention settled by measurement.

**Closed in S137**
- The five model attributes. Backend `8141e73`.
- **The S136 unverified risk closed:** Intuit does expose the estimate→invoice link. Measured, quoted above.
- Custom-field state measured — all three off, so the description carries both references.
- The PO field identified as `somanagement.SO_Ref_No`, measured on a real row.
- `myCode` proved clean by hex on the fixture product — no unquoting needed in the send path.
- QuickBooks item Id for SB001 resolved: **28**.
- A shipped fixture with a PO number built end to end: SO-0016 / DO-0018 / **PS-0032**.
- **P250 measured and re-scoped.** Authorization is enforced by the screen, not the server — evidence in the queue. Ruled a Phase 3 blocker.
