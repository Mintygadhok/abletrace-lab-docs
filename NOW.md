# NOW

Rewritten whole at the close of S136.
Read RULES.md and this file. Nothing else at the open.

**P245 Phase 2 groundwork is done.** The schema, the quoting fix and the fixture are all in place and proved on screen. **S137 is the round trip: send the estimate, get the invoice number.**

---

## STATE

What no command returns.

**SES — AWS answered on 22 Aug and REFUSED.** Case `178710371200148` on the new account `208073623096`. Their words: they identified concerns they will not specify, citing security. **No production SES on the new account.**

⚠ **Consequence: the old account 350466202408 cannot be torn down.** Production SES appears to exist only there, which makes it a permanent dependency rather than a parked one. **See the estate pending point in the queue.**

⚠ **Still does not block QuickBooks.** Nothing in Phase 1, 2 or 3 sends email.

**Prod untouched since before S130, on Node v18.** Both deliberate. No QuickBooks anything on prod until Phase 3.

**Both boxes report "system restart required."** Noted S135, still not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Dev frontend repo reads `c2a52d8e`, not the deployed sha.** Permanent and expected — frontend is edited on the Mac; dev's checkout is not the arbiter for it.

**Deployed frontend is `82ae3c3c`.**
```
/home/ubuntu/www-html.bak-dev-82ae3c3c9df3     rollback, read off the box
```

⚠ **The backup name points at the build going IN. Its contents are the build coming OUT.** Measured S136 by diffing the new backup against `dev-a669d7edb884` — they differed, which is what settled it. So the newest backup's *name* is the live commit and its *contents* are what you roll back to. RULES says read the rollback path off the box but does not say which way the name points. This is which way.

**Nothing is half-done.** S136 item 7 was dropped deliberately, not left unfinished — see the queue.

---

## THE JOB — S137

**Send the estimate to QuickBooks, then fetch the invoice number back.** The round trip, end to end, on one packing slip.

### The action, in order

1. Add the five `qb_*` columns to the `Packingslips` Sails model.
2. Design the two routes on paper before writing either — who calls, what they send, what comes back.
3. Build **Send estimate**: look up customer and item by their external identifiers, build the estimate, POST it, store what comes back, set the status.
4. Verify on screen, then in QuickBooks.
5. Convert the estimate to an invoice by hand inside the QuickBooks sandbox.
6. Build **Get invoice number**: read the estimate by Id, follow `LinkedTxn`, read the invoice, store its DocNumber.
7. Verify the invoice number on the AbleTrace screen.

⚠ **Item 1 is not optional and it is the trap that bites first.** Sails only reads and writes attributes it knows about. The columns exist in MySQL, but until they are in the model the backend drops them **silently on save** — no error, the screen looks right, nothing is stored. This exact fault was hit and fixed for `CompanyCustomers` in S136; the packing slip half was deliberately deferred to here because nothing read the columns yet.

### The material

**The five columns on `packingslips`, added S136.**
```
mysql abletracelab_live -e "SHOW COLUMNS FROM packingslips WHERE Field LIKE 'qb_%';"
  -> qb_estimate_id   varchar(64)   NULL
     qb_estimate_no   varchar(64)   NULL
     qb_invoice_id    varchar(64)   NULL
     qb_invoice_no    varchar(64)   NULL
     qb_send_status   varchar(32)   NOT NULL   DEFAULT 'not_sent'
```

**`_id` holds Intuit's internal handle. `_no` holds the DocNumber a human reads.** Not interchangeable. The API answers only to the Id; the DocNumber is what goes on screen. Minty's ruling S136: store both, because the alternative is S137 hunting for documents by number.

**Every existing slip carries a real status, not a blank.**
```
mysql abletracelab_live -e "SELECT qb_send_status, COUNT(*) n FROM packingslips GROUP BY qb_send_status;"
  -> not_sent   39
```

**The customer column, added S136.**
```
mysql abletracelab_live -e "SHOW COLUMNS FROM companycustomers WHERE Field='external_id';"
  -> external_id   varchar(255)   NULL
```

**The fixture, all three parts, measured S136.**

The packing slip to send:
```
mysql abletracelab_live -e "SELECT id, internalCode, company_id, shipped_flag, qb_send_status FROM packingslips WHERE company_id=464 ORDER BY id DESC LIMIT 5;"
  -> 2416  PS-0031  464  shipped_flag 1  not_sent
```

The customer, external ID typed through the new field and confirmed clean:
```
mysql abletracelab_live -e "SELECT id, customer_no, customer_name, external_id, HEX(external_id) FROM companycustomers WHERE customer_name='Testcustomer';"
  -> 4778  CUST-0009  Testcustomer  Testcustomer  54657374637573746F6D6572
```
No `22` at either end — no quote marks.

The product, quotes stripped and now the only holder of that SKU:
```
mysql abletracelab_live -e "SELECT id, internalCode, title, myCode, HEX(myCode) FROM formulations WHERE id IN (3713,3714);"
  -> 3713  FO-0010  Testpdt260820    (empty)
     3714  FO-0011  Testpdtqb260820  SB001   5342303031

mysql abletracelab_live -e "SELECT id, title FROM formulations WHERE myCode='SB001';"
  -> 3714  Testpdtqb260820      exactly one row
```

**Backup of the two product rows before that write:**
```
/home/ubuntu/backup-mycode-s136-20260824-1951.txt
```

**The path from slip to SKU, measured S136. This is the estimate line.**
```
packingslips 2416  (PS-0031)
  -> packingslipdos   PS_id = 2416        shipped_qty 50      row id 10419
     -> dispatchorders 10937              formula_id -> formulations
        -> formulations 3714              myCode 'SB001'
```
```
mysql abletracelab_live -e "SELECT id, shipped_qty, PS_id, DO_id FROM packingslipdos WHERE PS_id=2416;"
  -> 10419   50   2416   10937      exactly one line on this slip
```

⚠ **The join columns are `PS_id` and `DO_id` — capitals, not `packingslip_id`.** Guessing the lowercase form errors. Measured:
```
mysql abletracelab_live -e "SHOW COLUMNS FROM packingslipdos;"
  -> createdAt  updatedAt  id  shipped_qty  company_id  PS_id  DO_id
```

⚠ **`shipped_qty` is already a unit count.** 50 units, matching MO-0020. It goes on the estimate line as-is. Nothing in this path derives a count from a weight — RULES §7 is satisfied without special handling.

**`dispatchorders`, the columns that matter:**
```
mysql abletracelab_live -e "SHOW COLUMNS FROM dispatchorders;"
  -> internalCode  qty_to_ship  qty_shipped  formula_id  SO_id  packing_id  packing_units
```
⚠ There is no `mo_no` or `so_no` column — `SO_id` is the sales order link.

**Model filenames, measured. Both carry capitals that are easy to get wrong:**
```
ls ~/abletrace-lab-backend/api/models/ | grep -iE "packing|quickbook"
  -> PackingSlips.js      capital S in Slips
     PackingSlipDOs.js
     QuickbooksToken.js   lower-case b in Quickbooks
```

**The token service already exists — S137 calls it, never touches tokens directly:**
```
grep -n "async" ~/abletrace-lab-backend/api/services/quickbooksService.js
  -> readRow(company)   doRefresh(company)
     getAccessToken(company)   refreshNow(company)
```

**The QuickBooks routes today — three, all GET, all Phase 1:**
```
grep -n "quickbooks" ~/abletrace-lab-backend/config/routes.js
  -> GET /api/quickbooks/connect    QuickbooksController.connect
     GET /api/quickbooks/callback   QuickbooksController.callback
     GET /api/quickbooks/status     QuickbooksController.status
```
The two new routes are added here. **Send is a POST** — it changes something in QuickBooks. Get invoice number is a GET.

### The analysis

**The design, stated before writing — RULES §1.**

**Send estimate**
- **Who calls it** — the admin, from a button on the packing slip screen. Browser fetch, so it must carry `authorization: bearer <webToken>` explicitly. This app has no HttpInterceptor.
- **What they send** — the packing slip id and the company from the logged-in session. **Never the company as a parameter.**
- **What comes back** — the estimate's Id and DocNumber, and a status. On failure, a reason in plain words.

**Get invoice number**
- **Who calls it** — the admin, from a second button on the same screen, after converting the estimate by hand in QuickBooks.
- **What they send** — the packing slip id.
- **What comes back** — the invoice DocNumber, or "not converted yet" as a distinct answer from a failure.

**The two lookups the send depends on.** Neither the customer nor the item can be referenced directly; both must be found first.
- Customer — matched on QuickBooks display name, which is what `external_id` now holds.
- Item — matched on SKU, which is what `myCode` holds. `ItemRef.value` wants the internal Id, so the SKU lookup comes first and its result feeds the estimate line.

**Quantity comes from the packing slip in units. Never derived from a weight.** RULES §7. QuickBooks owns price and tax; AbleTrace sends only what shipped.

⚠ **`company_id` is a `double` on `companycustomers` and on `dispatchorders`, but an `int` on `packingslips` and `packingslipdos`.** Measured S136. Not a fault today, but the S137 join crosses that boundary twice — a float compared to an integer. Worth knowing before it produces a mystery.

### The verify

Nothing is done until it is seen on the screen.

1. The Send button on PS-0031 returns without error, and the slip shows a status of **sent** with an estimate number.
2. The same estimate is visible in the QuickBooks sandbox, addressed to `Testcustomer`, with a line for `Testpdtqb260820`.
3. After converting it by hand, the Get invoice number button puts a real invoice number on the AbleTrace screen.
4. `SELECT` on row 2416 shows all four `qb_*` values populated and the status correct.

---

## WHAT S136 CHANGED

**Frontend `82ae3c3c`** — the `JSON.stringify` wrapper removed from `myCode` on the Add Product form, and External ID added to both customer forms. Built locally, built by CI, deployed to dev, verified on screen.

**Backend `4e86e45`** — `external_id` added to the `CompanyCustomers` model attributes and to `createCustomer`. `editCustomer` needed no change; it passes `req.body.updates` straight through.

**Database, dev only** — five columns on `packingslips`, one on `companycustomers`. ⚠ **None of this reaches prod by deploying.** Schema runs on each box separately, at Phase 3.

**Two product rows healed**, backed up first, scoped by `id` and `company_id`.

**Dropped deliberately:** the 22 rows holding the string `null` and the two holding empty quotes. Minty's ruling S136 — they are test data in test companies `test260703@` and `test260805@`, they display as blank already, and there is nothing to recover in them. Not a pending item.

---

## THINGS THAT COST TIME IN S136 — all cheap to avoid next time

**`promote.sh` was not used.** The deploy was done by hand — backup, python3 unzip, `rm -rf`, `cp -a`. It worked and was verified with a `diff`, but `~/promote.sh` existed and would have been one line. **Use it in S137.**

**`unzip` is not installed on dev.** Python is:
```
python3 -c "import zipfile; zipfile.ZipFile('<zip>').extractall('<dir>')"
```

**The dev artifact has no wrapper folder.** `index.html` sits at the top level, so contents copy straight into `/var/www/html`.

**There are no SSH host aliases.** `~/.ssh/config` holds only a global keepalive block. Every `scp` and `ssh` needs the IP typed in full. Dev is `16.55.10.205`.

**A check must be able to fail for the right reason.** A patch script counted occurrences of `external_id` and expected two, but the comment it inserted also contained the phrase — so it reported FAIL after writing correctly. The write was fine; the test was wrong. A test that can only fail is as useless as one that can only pass.

---

## TWO FACTS BANKED — expensive to re-measure, needed by S137

**A converted Intuit estimate carries a link to its invoice.** Measured on dev against the live sandbox:
```
Id 119   DocNumber 1002   "TxnStatus":"Closed"
         "LinkedTxn":[{"TxnId":"123","TxnType":"Invoice"}]
Id 121   DocNumber 1004   "TxnStatus":"Pending"    no LinkedTxn
```
⚠ **`LinkedTxn` returns the invoice's TxnId, not its number.** So *Get invoice number* is **two** calls: read the estimate by Id to get the invoice's Id, then read the invoice by Id to get its DocNumber.

**Estimate lines reference items by internal Id, not SKU** — `ItemRef.value`. `myCode` holds the SKU, so the send must look the item up by SKU first. Settled by looking at the sandbox screens: the Products list shows SKU as a proper column; **no internal Id is visible anywhere, not on screen and not in the URL.** A client can type a SKU; they cannot find an Id. Lookup is the only workable design. The customer screen shows no id either — hence matching on display name.

⚠ **The Intuit token expires in hours.** Raw curl returns `401 Token expired`. **Loading the QuickBooks page in AbleTrace refreshes it first** — do that before any manual curl.

⚠ **A stray `Testcustomer-1` could not be deleted** — QuickBooks makes customers inactive rather than deleting. Renamed to `abc`. The list counted 31, not 30 — worth one look before relying on the fixture.

---

## TRAPS CARRIED FORWARD — both look like broken code

**A master role row created by SQL grants nothing.** The app's own creation path copies every `role_task` for that role into `company_user_task`. SQL runs no application code, so that copy never happens. The row is indistinguishable from a working one in every table.

⚠ **Consequence for Phase 3: the role and task rows on prod must be created through the UI, not by SQL.**

**A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four different reasons — no header, expired token, invalid token, token not matching the stored `webToken` — all **before** the controller runs. The response body is the only thing that distinguishes them. Read it in the Network tab, not the console.

⚠ **This app has no HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case. A new service that omits it is unreachable from the browser while working perfectly from curl.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive, Angular's AOT compiler is not.

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
| P245 | QuickBooks integration — **active. Phase 1 and the Phase 2 groundwork complete. S137 is the round trip.** Phase 3 is below |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22 pending. **Both boxes report "system restart required."** Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load. Affects every route. A client who bookmarks or refreshes a screen is thrown out |
| P250 | **No role or company check in the policy layer.** `isAuth` proves only that someone is logged in. ⚠ Whether individual controllers filter by `company_id` was **not** measured — the job is *verify every route filters*, not *build separation* |
| P251 | GitHub warns Node.js 20 actions are deprecated. Reachable only by an Angular major upgrade |
| P252 | **External ID duplicate guard, customers and products together.** Dropped from S136 deliberately — it guards a future mistake, and the fixture was measured clean today. ⚠ `createCustomer` already checks `company_id` + `customer_name` and returns `Duplicate`; that is the pattern to extend. ⚠ **`editCustomer` has no duplicate check at all** — measured S136 |
| P253 | **No SSH host aliases.** Every `scp` needs the IP typed. Two lines in `~/.ssh/config` removes it permanently |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role, so row 24 is the odd one out and probably goes. Also cross-check how Food Safety System was set up, since it sits under both Admin and its own controller |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode` too; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

### PENDING — the estate. abletrace.ca, with the SES constraint. Unranked; Minty prioritises when Phase 2 lands.

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

Kept here in full so it survives NOW being rewritten. **Nothing below is S137 work.**

**Clients do not get sandboxes.** They connect their real QuickBooks. Each client clicks Connect, signs in with their own credentials, approves, and gets their own row in `quickbooks_tokens` under their company name. The company column was added from the start (Minty's ruling S129) so this is two more rows, not a rebuild.

⚠ **The company must come from the logged-in session, never from a parameter.** The status route currently falls back to a hardcoded `sandbox260820`. Harmless with one sandbox; wrong the moment there are two clients, because it means the caller names the company. **This must change before any real client connects.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat, in any form.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- `CREATE TABLE` and every schema change run on prod **separately**. Deploying does not carry them. ⚠ **This now includes the six columns added in S136.**
- **The role and task rows must be created through the UI on prod, not by SQL** — see the trap above.
- A **Reconnect URL** is a mandatory field in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories either. Today Minty can see everything because it is early; that is a temporary state, not the design.

**Direction, not to be built yet:** if access is ever needed for support it is **break-glass** — closed by default, opened only with the client's consent, expiring on its own, and logged. Never a standing permission, and nothing added later may quietly create one.

⚠ **Consequence to accept:** under this ruling, when a client's connection breaks Mintek cannot look. Which is exactly why the four failure-handling items are not optional, and why the reconnect flow must be usable by a non-technical person unaided.

**The four failure-handling items** — agreed in principle 21 Aug. Item 1 is now built as `qb_send_status`; the rest are pending.
1. ~~A status on every slip, always visible.~~ **Column built S136, defaulting to `not_sent`.** Putting it on the screen is S137.
2. The reason, in plain words, on the slip — customer not found, product not set up, connection dead, no price. Not buried in a log.
3. A retry button. Most failures are fixed in QuickBooks, then re-sent.
4. A list of slips shipped with no invoice number. The daily check, and where a silent failure would otherwise hide.

⚠ **Silence is the fragile part, not the design.** A connection dies for reasons nobody controls — the client revokes it from QuickBooks' Apps screen, a token expires, someone re-authorises. Under any ownership model the failure is invisible unless the slip says so.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

**Closed in S136**
- The quoting fault fixed at source and verified on screen. Frontend `82ae3c3c`.
- Five `qb_*` columns on `packingslips`, one `external_id` on `companycustomers`, dev.
- `external_id` wired through the model, the create path and both customer forms. Backend `4e86e45`.
- The fixture completed and proved clean by hex — one customer, one product, one SKU.
- The backup naming convention settled by measurement.
