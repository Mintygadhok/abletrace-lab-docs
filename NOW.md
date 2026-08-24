# NOW

Rewritten whole at the close of S135.
Read RULES.md and this file. Nothing else at the open.

**P245 Phase 1 is done** — company name seen on an AbleTrace screen, reached by clicking, as `test260703`. S136 prepares the ground for the round trip. **No sending code this session.**

---

## STATE

What no command returns.

**SES — AWS answered on 22 Aug and REFUSED.** Case `178710371200148` on the new account `208073623096`. Their words: they identified concerns they will not specify, citing security. **No production SES on the new account.**

⚠ **Consequence: the old account 350466202408 cannot be torn down.** Production SES appears to exist only there, which makes it a permanent dependency rather than a parked one. **See the estate pending point in the queue.**

⚠ **Still does not block QuickBooks.** Nothing in Phase 1, 2 or 3 sends email.

**Prod untouched since before S130, on Node v18.** Both deliberate. No QuickBooks anything on prod until Phase 3.

**Both boxes report "system restart required."** Noted S135, not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Dev frontend repo reads `c2a52d8e`, not the deployed sha.** Permanent and expected — frontend is edited on the Mac; dev's checkout is not the arbiter for it.

**Deployed frontend is `a669d7ed`** as `dev-a669d7edb884`.
```
/home/ubuntu/www-html.bak-dev-a669d7edb884     rollback, read off the box
```

---

## THE JOB — S136

Seven items, in order. Items 1 and 2 must precede item 4.

### 1 · Stop the product form adding quote marks

**One word deleted, one file, on the Mac.**

```
src/app/Layouts/admin-dashboard/admin-formulation/add-new-formulation/add-new-formulation.component.ts:624
  myCode: JSON.stringify(this.formulationForm.get('myCode').value),
```

Remove the `JSON.stringify(...)` wrapper so the value goes through raw.

**The edit form is already correct** and is the pattern to match:
```
edit-formulation.component.ts:1214
  myCode: this.formulationForm.get('myCode').value,
```

**The backend does nothing to the value** — measured:
```
grep -rn "myCode" ~/abletrace-lab-backend/api/ | grep -v "//"
  -> Formulations.js:825 and :949   myCode: req.body.myCode
  -> no quoting, no stringify anywhere in the backend
```

⚠ **Materials use the same field name** (`Materials.js:380`, `:790`) but were not checked. Out of scope; note only.

**Build and deploy** — frontend is edited on the Mac, and a local build is not the CI artifact:
```
npm run build-dev              # = ng build --configuration=dev --aot
                               # there is no 'development' configuration
```
Push, let CI build, download the artifact, then:
```
~/promote.sh ~/Downloads/dist-dev-<sha>.zip dev
```
⚠ **`promote.sh` is in the home directory, not the repo.** Cost a minute in S135.
⚠ Then **Shift+Cmd+R** in Chrome.
⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive, Angular's AOT compiler is not. Cost one build.

### 2 · Clean the 26 bad rows

**Measured S135:**
```
mysql abletracelab_live -e "SELECT COUNT(*) FROM formulations WHERE myCode LIKE '\"%';"
  -> 4      rows whose myCode starts with a quote mark

mysql abletracelab_live -e "SELECT COUNT(*) FROM formulations WHERE myCode='null';"
  -> 22     rows holding the four-letter string 'null'
```

`JSON.stringify(null)` returns the string `"null"` — same line 624, same cause.

**The fixture row, showing the quoting is real and not a display artefact:**
```
mysql abletracelab_live -e "SELECT HEX(myCode), myCode FROM formulations WHERE id=3714;"
  -> 22534230303122   "SB001"
```
`22` is a quote mark at each end.

⚠ **This is a live write.** Back up the rows first, scope by `id` and `company_id`, and say out loud that it is a live write. **Claude queries and reports; Minty decides whether to heal.**

⚠ **The 22 `null` rows are not the same decision as the 4 quoted rows.** A quoted row has a recoverable true value — strip the quotes. A `null` row never had one; blanking it is the likely answer but it is Minty's call.

### 3 · Three new columns on `packingslips`

**The table, measured:**
```
mysql abletracelab_live -e "DESCRIBE packingslips;"
```
16 columns. No external references of any kind today. Relevant ones:
```
internalCode              varchar(255)   PS-0031
shipping_reference_docs   longtext
vehicle_no                varchar(255)
vehicle_condition         int            ordinal position 15
shipped_flag              tinyint(1)
company_id                int
```

**Add:** estimate number, invoice number, send status.

**Minty's ruling S135 on placement:** on the packing slip **screen**, the invoice number field sits **between Shipping Reference and Vehicle condition**. Shipping Reference stays exactly as it is — it remains the free-text field for clients who do not use QuickBooks.

⚠ **Send status is not optional even in a bare round trip.** Without it a failed send and a never-sent slip both read blank, and blank meaning two things is the silent failure P240 is about.

⚠ **A database object reaches neither box by deploying.** Run it on dev now; prod is a separate run at Phase 3.

### 4 · One new column on `companycustomers`

**Holds the QuickBooks customer display name.**

**Minty's ruling S135 — one convention, both objects:**

| | internal ID | external ID |
|---|---|---|
| **Product** | `internalCode` — FO-0011 | `myCode` — the QuickBooks SKU |
| **Customer** | `customer_no` — CUST-0009 | **new column** — the QuickBooks display name |

Both external IDs are typed by hand and both mean the same thing: *this is the QuickBooks identifier.*

**The table, measured:**
```
mysql abletracelab_live -e "DESCRIBE companycustomers;"
```
17 columns. `customer_no varchar(255)` is AbleTrace's own sequential number — **not** free to overwrite. `customer_name varchar(255)` holds the AbleTrace name. Nothing holds a QuickBooks identifier.

⚠ **Do item 1 before this.** The new field is the same kind of field; if the quoting cause is still live, the new column inherits it on day one.

### 5 · The field on the customer form

So the value can be typed. Manually entered by design, same as `myCode`.

⚠ **Design before writing, per RULES:** state who calls it, what they send, what comes back, before touching the form.

### 6 · Set the fixture value

Type `Testcustomer` into the new field for AbleTrace customer **4778**, then read the row back.

### 7 · Check the duplicate guard on the new field

**Within a company.** Two AbleTrace customers pointing at one QuickBooks customer puts a line on the wrong account — no error, plausible output.

**AbleTrace's existing name guard is real** — measured, not assumed:
```
mysql abletracelab_live -e "SELECT company_id, customer_name, COUNT(*) n FROM companycustomers GROUP BY company_id, customer_name HAVING n > 1;"
  -> empty.  1059 customers, no duplicate names within any company.
```

**QuickBooks enforces unique display names too** — tried in the sandbox S135. It refused with "Something's not quite right" and the record it did create was named `Testcustomer-1` while keeping the same company name.

⚠ **So display name is unique on both sides. Company name is not a key** — the sandbox has `Oxon Insurance Agency`, `Oxon - Holiday Party` and `Oxon - Retreat` sharing one phone number.

⚠ **The new external column has no guard.** That is what item 7 is.

---

## HOW S136 IS VERIFIED

**On the screen, not in the database:**

1. A product saved through **Add New** whose `myCode` reads back with **no quote marks**.
2. The **new field visible on the customer form**, `Testcustomer` typed into it and read back from row 4778.
3. The **three new columns present** on `packingslips`.

⚠ **Nothing is done until it is verified on the screen.** Deployed is not proven. Say which it is, every time.

---

## THE FIXTURE — do not re-derive

**In AbleTrace, dev**
```
PS-0031   packingslips id 2416   shipped_flag 1   2026-08-24 13:20:23   company_id 464
DO-0017   MO-0020   50 units (50.000 Kg)   ship to 10618, 240 St
Product   formulations id 3714   title Testpdtqb260820   internalCode FO-0011   myCode "SB001"
Customer  companycustomers id 4778   customer_no CUST-0009   customer_name Testcustomer
          address 10518, 240 St
Stock     formulations.inventory_units now 0
```

**In QuickBooks sandbox `Sandbox Company CA 26d2`, realm `9341457751382548`**
```
Product   Testpdtqb260820   SKU SB001   Inventory   price 25   qty on hand 0
Customer  display name  Testcustomer          <- the match key
          company name  Testcustomercompany   <- deliberately different
          nameId 68   billing 10518, 240 St   tax 13%
```

⚠ **PS-0031 is shipped and cannot be changed.** Minty's ruling S135: a PS or DO can be cancelled **before** shipping; once Ship is pressed neither can be altered. A second test slip means a new MO, DO and PS.

⚠ **Display name and company name were made different on purpose.** They were both `Testcustomer`; if the send matched the wrong field it would have worked by accident. Same principle as bill-10518 / ship-10618.

⚠ **The product is 1:1 — 50 units, 50 Kg.** TRAPS 9: a ratio of exactly 1 makes a division invisible. Any quantity check needs `test1.39`.

⚠ **A stray `Testcustomer-1` could not be deleted** — QuickBooks makes customers inactive rather than deleting. Renamed to `abc`. **The list still counted 31, not 30 — worth one look before relying on the fixture.**

---

## TWO FACTS BANKED FOR S137 — expensive to re-measure

**A converted Intuit estimate carries a link to its invoice.** This was the one unknown that could have invalidated the Phase 2 design. Measured on dev against the live sandbox:
```
Id 119   DocNumber 1002   "TxnStatus":"Closed"
         "LinkedTxn":[{"TxnId":"123","TxnType":"Invoice"}]
Id 121   DocNumber 1004   "TxnStatus":"Pending"    no LinkedTxn
```
So *Get invoice number* works as designed: read the estimate by Id, check `LinkedTxn`.

**Estimate lines reference items by internal Id, not SKU** — `ItemRef.value`. `myCode` holds the SKU, so the send must look the item up by SKU first. Settled by looking at the sandbox screens: the Products list shows SKU as a proper column; **no internal Id is visible anywhere, not on screen and not in the URL.** A client can type a SKU; they cannot find an Id. Lookup is the only workable design. The customer screen shows no id either — hence matching on display name.

⚠ **The Intuit token expires in hours.** Raw curl returns `401 Token expired`. **Loading the QuickBooks page in AbleTrace refreshes it first** — do that before any manual curl.

---

## TWO TRAPS FROM S135 — both looked like broken code

**A master role row created by SQL grants nothing.** The app's own creation path copies every `role_task` for that role into `company_user_task`. SQL runs no application code, so that copy never happens. The row is indistinguishable from a working one in every table.

⚠ **Consequence for Phase 3: the role and task rows on prod must be created through the UI, not by SQL.**

**A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four different reasons — no header, expired token, invalid token, token not matching the stored `webToken` — all **before** the controller runs. The response body is the only thing that distinguishes them. Read it in the Network tab, not the console.

⚠ **This app has no HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case. A new service that omits it is unreachable from the browser while working perfectly from curl.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is.

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
| P245 | QuickBooks integration — **active. Phase 1 complete. S136 is the schema and the quoting fix; Send and Get invoice number is the session after.** Phase 3 is below |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22 pending. **Both boxes now report "system restart required."** Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load. Affects every route. A client who bookmarks or refreshes a screen is thrown out |
| P250 | **No role or company check in the policy layer.** `isAuth` proves only that someone is logged in. ⚠ Whether individual controllers filter by `company_id` was **not** measured — the job is *verify every route filters*, not *build separation* |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out and probably goes. Also cross-check how Food Safety System was set up, since it sits under both Admin and its own controller |
| — | **Materials may have the same quoting fault.** `Materials.js` uses `myCode` too; not checked in S135 |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |
| — | Pending, unranked: external ID duplicate guard on **products**. The customer side is item 7 |

### PENDING — the estate. abletrace.ca, with the SES constraint. Unranked; Minty prioritises after S136.

**Two jobs in one, because they are the same job: get everything onto abletrace.ca and reduce the old account to an email-only shell.**

**The original direction was to disconnect from the old account completely.** `mintekfoodsafety.com` was always temporary; the platform lives at **abletrace.ca**, with AbleTrace as an app under it. **AWS's refusal makes full disconnection impossible**, so the plan changes shape rather than being abandoned.

**Minty's ruling S135:** keep the old account **for SES and nothing else**. Strip out every other service. Issue **fresh credentials** so nothing carries over from the old system. The account becomes a single-purpose mail sender — as good as new — not "the old estate we never finished leaving."

**Claude to produce a complete route before anything is touched:** what moves, in what order, what points at what, and what the rollback is at each step.

**Three things must be measured first. None are known today:**
1. **Can old-account SES send from `abletrace.ca`?** The domain is DKIM-verified on the **new** account. Verifying one domain on two accounts is normally allowed, but it needs proving, not assuming.
2. **Route 53 is inside the old account** (RULES §4). If DNS stays there, the account is not email-only. Decide whether DNS moves or whether "email-only" means "email and DNS."
3. **Is the refusal final?** Whether the request can be re-filed with a fuller use case, or the case is closed. If it can be re-filed, the whole plan may be unnecessary.

⚠ **P17 belongs to this job.** Two old-account IAM keys are still valid and sit in git history. Under "as good as new" they must be rotated or revoked, not left.

⚠ **RULES, before removing infrastructure:** ask **what still points at this?** — DNS records, credentials, other AWS settings, accounts outside AWS. **The pointer goes first, the resource second.** Never the reverse; in between, a name you own points at something you don't. ⚠ **A code search cannot find these.** Nothing in the code names them — that is why they get left behind.

### P245 Phase 3 — two clients, live books. Pending, not this session.

Kept here in full so it survives NOW being rewritten. **Nothing below is S136 or S137 work.**

**Clients do not get sandboxes.** They connect their real QuickBooks. Each client clicks Connect, signs in with their own credentials, approves, and gets their own row in `quickbooks_tokens` under their company name. The company column was added from the start (Minty's ruling S129) so this is two more rows, not a rebuild.

⚠ **The company must come from the logged-in session, never from a parameter.** The status route currently falls back to a hardcoded `sandbox260820`. Harmless with one sandbox; wrong the moment there are two clients, because it means the caller names the company. **This must change before any real client connects.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat, in any form.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- `CREATE TABLE` and every schema change run on prod **separately**. Deploying does not carry them.
- **The role and task rows must be created through the UI on prod, not by SQL** — see the S135 trap above.
- A **Reconnect URL** is a mandatory field in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories either. Today Minty can see everything because it is early; that is a temporary state, not the design.

**Direction, not to be built yet:** if access is ever needed for support it is **break-glass** — closed by default, opened only with the client's consent, expiring on its own, and logged. Never a standing permission, and nothing added later may quietly create one.

⚠ **Consequence to accept:** under this ruling, when a client's connection breaks Mintek cannot look. Which is exactly why the four failure-handling items are not optional, and why the reconnect flow must be usable by a non-technical person unaided.

**The four failure-handling items** — agreed in principle 21 Aug. Item 1 is in S136 as the send status column; the rest are pending.
1. A status on every slip, always visible. Not sent / sending / sent + number / failed. Blank is not a status.
2. The reason, in plain words, on the slip — customer not found, product not set up, connection dead, no price. Not buried in a log.
3. A retry button. Most failures are fixed in QuickBooks, then re-sent.
4. A list of slips shipped with no invoice number. The daily check, and where a silent failure would otherwise hide.

⚠ **Silence is the fragile part, not the design.** A connection dies for reasons nobody controls — the client revokes it from QuickBooks' Apps screen, a token expires, someone re-authorises. Under any ownership model the failure is invisible unless the slip says so.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

**Closed in S135**
- **P245 Phase 1.** Company name visible on an AbleTrace screen, reached by clicking, as `test260703`.
- The permission chain found and fixed — `company_user_task` is the layer.
- The missing authorization header on the QuickBooks service. Frontend `a669d7ed`, deployed `dev-a669d7edb884`.
- Phase 2 specified end to end: every open question measured, including Intuit's `LinkedTxn`.
- The quoting fault traced to one line of code.
- The fixture built, shipped and made unambiguous.
