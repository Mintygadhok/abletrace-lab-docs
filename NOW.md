# NOW

Rewritten whole at the close of S134.
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

**Dev backend carries two untracked items.** `node_modules.old-node18/` is deliberate (P227). **`s133-status-route.py` is debris** — the patch script that wrote the status route, whose output is committed. Delete it at the S135 open:

```
rm ~/abletrace-lab-backend/s133-status-route.py
```

---

## P245 PHASE 1 — WHERE IT STANDS

**Backend complete and proven. Frontend built, deployed and rendering. One thing missing: a way to click through to the page.**

### Proven in S134

**Backend `7bdb711`** — connect, callback, refresh, status.

```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;")
curl -s -H "authorization: bearer $TOK" localhost:1337/api/quickbooks/status
```
returned:
```
{"success":true,"connected":true,
 "companyName":"Sandbox Company CA 26d2",
 "realmId":"9341457751382548"}
```

⚠ That is Phase 1's headline string and it has already been produced. What has never been seen is that string **rendered on an AbleTrace screen**.

**Frontend `c6ad2b0a`** — six files, CI green (#78, 8m 40s), promoted as `dev-c6ad2b0a17ca`.
```
/home/ubuntu/www-html.bak-dev-c6ad2b0a17ca     rollback, read off the box
```

**The QuickBooks tab appears in the left strip**, only for a user holding role 8. Seen on screen as `test260703`.

### The one thing missing

**Selecting the tab shows an empty page.** The Admin tab also shows no QuickBooks tile, despite `role_task` id 24 pointing `/quickbooks` at role 2.

So `role_task` alone does not put a link on the home page. **There is a layer between a role and the tasks a user actually sees**, and `Add Feature +` on `Manage-Users` is almost certainly its UI. Finding it is S135.

⚠ **The page cannot be reached by typing the URL** — P249. Clicking is the only door, which is why the tile is not cosmetic.

---

## THE JOB — S135

**Put a QuickBooks link on the screen and see the company name. This closes Phase 1.**

### 1 · Find the layer that grants a task to a user

Three facts measured; the fourth is the gap.

```
roles              id 8   'QuickBooks Controller'
role_task          id 23  QuickBooks  /quickbooks  role_id 8
role_task          id 24  QuickBooks  /quickbooks  role_id 2   (Admin)
company_user_role  id 2041  company_user_id 570  role_id 8  is_master 1
```
measured by:
```
mysql abletracelab_live -e "SELECT id, task_name, routing_path, role_id FROM role_task WHERE routing_path='/quickbooks';"
mysql abletracelab_live -e "SELECT * FROM company_user_role WHERE role_id=8;"
```

⚠ **`company_user` does not exist.** Guessed at in S134, returned `ERROR 1146 (42S02)`. The table `company_user_role.company_user_id` points at is unknown and must be found, not assumed.

```
mysql abletracelab_live -e "SHOW TABLES LIKE '%task%';"
mysql abletracelab_live -e "SHOW TABLES LIKE '%user%';"
```

**What the frontend reads** — `admin-dashboard.component.ts:77`:
```
this.userTasks = this.userRoleDetails.CompanyUser.company_user_role
                   .map(role => role.role_data[0].tasks.map(task => task));
```
Tiles come from `role_data[0].tasks`; `home.component.html:15` iterates `userTasks`. **So: what populates `tasks` on a role for a given user?** If it were `role_task` alone, task 24 would already show a tile under Admin. It does not.

⚠ **Rows 23 and 24 already exist. Do not insert them again.**

### 2 · Grant it, then log out and back in

⚠ **Role and task data is cached at login.** A database change will not appear in an open session however correct it is. This looks exactly like broken code.

### 3 · How it is verified

**`Sandbox Company CA 26d2` visible on an AbleTrace screen, reached by clicking, logged in as `test260703`.**

Second verify: a user without role 8 does not see the tab. True by construction.

⚠ **Click. Never type the address** — P249.

### 4 · Two small checks at the close, if there is room

- Does any controller filter by `company_id`? One list route settles the framing of P250 — see the queue note.
- Is `external_id` constrained, and can two rows in one company share one? Feeds the pending duplicate-guard item.

---

## MATERIAL — measured in S134, do not re-derive

**Test account** — `test260703@mailinator.com`, holds roles 1–8 including QuickBooks Controller.

**Guarded curl on dev** — header `authorization: bearer $TOK`, **lower case**, or `isAuth` returns 403.

**Frontend files, committed at `c6ad2b0a`**
```
src/app/Layouts/admin-dashboard/quickbooks/quickbooks.component.ts
                                          /quickbooks.component.html
                                          /quickbooks.component.scss
                                          /quickbooks.module.ts
                                          /quickbooks-routing.module.ts
src/app/Services/Quickbooks/quickbooks.service.ts
src/app/app-routing.module.ts   (route added after food-safety-system)
```

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive so `ls` and `mkdir -p` both succeed against the wrong casing; Angular's AOT compiler is not, and fails with TS1261. Cost one build.

**The API base is NOT `environment.apiUrl`**
```
environment.apiUrl = 'http://devapiw.abletrace.ca:1337/api/v1/'
```
QuickBooks routes sit **outside** `/api/v1/` to match the redirect URI registered at Intuit, so the service strips it:
```
private base = environment.apiUrl.replace(/\/api\/v1\/?$/, '/api/');
```
⚠ Do not tidy the QuickBooks routes into v1. Intuit's registered copy is the arbiter.

**Building** — the app's own script, which is what CI runs:
```
npm run build-dev          # = ng build --configuration=dev --aot
```
⚠ There is no `development` configuration.

**Deploying** — from the Mac only:
```
./promote.sh ~/Downloads/dist-dev-<sha>.zip dev
```
Refuses a dev bundle aimed at prod and vice versa, backs up to `www-html.bak-dev-<sha>`, prints the rollback line. **A push builds dev but does not deploy it** — the artifact must be promoted by hand. Then **Shift+Cmd+R**.

**Permissions at the server**
```
api/policies/   generateJWT.js  isAuth.js  rateLimitLogin.js
config/policies.js:  '*': 'isAuth'   +  QuickbooksController.callback: true
grep -rn "isAdmin\|role\|is_admin" api/policies/ config/policies.js   → nothing
```
`isAuth` proves only that someone is logged in. Minty's ruling S134: match the app, do not build a one-off lock for one route.

---

## ANALYSIS ALREADY DONE

**Why status reads the name live from Intuit.** A row can hold a revoked connection and still look fully populated. Every failure returns `connected:false` rather than a stale name, deliberately, with the real reason in `sails.log.error`.

**Why connect returns JSON instead of redirecting.** It sits behind `isAuth`, which reads a header a browser navigation cannot send. Cost S130 a session.

**Why the callback is public.** Intuit redirects back with no token. The guard is the single-use `state`, held in memory, deliberately not surviving a restart. Removing the exemption breaks the connection and the failure looks like Intuit's.

**Why the company column.** Minty's ruling S129. Phase 3 puts two clients on their own books; with the column that is two more rows. `company` is UNIQUE, which also stops a re-authorisation creating a second row.

**Why a tab is a role, not a component.** The left strip is built from the user's own roles. Adding a tab is a **database insert**, which reaches neither box by deploying and must be run on prod separately at Phase 3.

⚠ **git cannot tell you what a session did.** S134 opened on `git status`, found one workflow commit, and concluded S133 had done nothing. S133 had created role 8 and both task rows. A session that touches the database leaves no trace in git.

---

## PHASE 2 — THE ROUND TRIP

**Packing slip in AbleTrace → invoice in QuickBooks → invoice number back onto the slip.**

### The fixture, built by Minty 21 Aug — ready and waiting

**In QuickBooks sandbox `Sandbox Company CA 26d2`**
```
Product   Testpdtqb260820   SKU SB001   Inventory   price 25   qty on hand 0
Customer  Testcustomer      nameId 67
          billing 10518, 240 St, Maple Ridge BC V2W1X1, Canada
          tax 13%
```

**In AbleTrace, dev, matched by External ID**
```
Product   Testpdtqb260820   External ID "SB001"   BS Pouch
Customer  Testcustomer      External ID = the QuickBooks customer id
MO-0020   Pdt-260821-1      50# (50 Kg)   complete
SO-0015   Testcustomer      ship to 10618, 240 St
```

⚠ **The two addresses differ deliberately.** Bill 10518, ship 10618. That is a feature of the fixture: if ship-to ever silently falls back to the billing address, it will be visible on the invoice.

⚠ **The product is 1:1 — 50 units, 50 Kg.** TRAPS 9: a ratio of exactly 1 makes a division invisible. Minty's ruling: Phase 2 proves the pipe, not the arithmetic. **Any quantity check needs `test1.39`**, the standing non-round fixture.

### Minty's rulings, 21 Aug — settled, do not re-open

| | |
|---|---|
| **Who creates the invoice** | QuickBooks. AbleTrace sends only what shipped |
| **Price** | QuickBooks. One price list, one source of truth |
| **Tax** | QuickBooks. Codes live against items and customers there |
| **Ship-to address** | AbleTrace's, from the dispatch order — the record of where goods physically went |
| **Bill-to address** | QuickBooks' own stored address |
| **The invoice** | shows **both** bill-to and ship-to |
| **Quantities** | unit counts, read across. Never derived from weight — RULES §7 |
| **After it is sent** | the invoice number is the record. **Edits or voids in QuickBooks are outside AbleTrace's purview** |
| **Matching** | `external_id` on both products and customers, **manually entered in AbleTrace by design** so it can carry the customer's own identifiers |

**The trigger is a button on the packing slip.** Manual versus automatic is **not yet decided**. Claude's view: start manual — a wrong invoice reaching an accountant is harder to undo than a slow one.

### What the button does, in order

1. Read the slip — customer, products, unit counts, ship-to
2. Translate through `external_id` on both sides
3. Send to QuickBooks
4. QuickBooks creates the invoice and returns its number
5. Store that number on the slip

The stored number is both the audit link and the duplicate guard.

### Failure handling — four things, agreed in principle

1. **A status on every slip, always visible.** Not sent / sending / sent + number / failed. Blank is not a status.
2. **The reason, in plain words, on the slip** — customer not found, product not set up, connection dead, no price. Not buried in a log.
3. **A retry button.** Most failures are fixed in QuickBooks, then re-sent.
4. **A list of slips shipped with no invoice number.** The daily check, and where a silent failure would otherwise hide.

⚠ **Silence is the fragile part, not the design.** A connection dies for reasons nobody controls — the client revokes it from QuickBooks' Apps screen, a token expires, someone re-authorises. Under any ownership model the failure is invisible unless the slip says so. **P240 is the thing that makes this safe.**

⚠ **P240 applies with force here.** A silent failed invoice is worse than a silent failed email.

### Pending, unranked, deliberately parked

**`external_id` has no duplicate guard.** It is typed by hand and it is the only link between the two systems. A duplicate puts a line on the wrong customer's invoice — no error, plausible output. When it is built: scope uniqueness **per company** (two clients may legitimately reuse an id), enforce it at the write and not only on the form, and sweep the existing data first. Minty's call, 21 Aug: keep it pending, keep the focus on the integration.

---

## PHASE 3 — TWO CLIENTS, LIVE BOOKS

**Clients do not get sandboxes. They connect their real QuickBooks.** The sandbox is a development tool. Each client clicks Connect, signs in with their own QuickBooks credentials, approves, and gets their own row in `quickbooks_tokens` under their company name.

⚠ **The company must come from the logged-in session, never from a parameter.** The status route currently falls back to a hardcoded `sandbox260820`. Harmless with one sandbox; wrong the moment there are two clients, because it means the caller names the company. **This must change before any real client connects.**

**Also at Phase 3**
- Intuit **production** keys. They reach live client books and never appear in chat, in any form.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- `CREATE TABLE`, the role row and the task rows all run on prod separately. Deploying does not carry them.
- A **Reconnect URL** is a mandatory field in Intuit app settings as of Feb 2026. Refresh tokens cap at five years.

**Minty's ruling on ownership, 21 Aug — wider than QuickBooks**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories either. Today Minty can see everything because it is early; that is a temporary state, not the design.

**Direction, not to be built yet:** if access is ever needed for support, it is **break-glass** — closed by default, opened only with the client's consent, expiring on its own, and logged. Never a standing permission, and nothing added later may quietly create one.

⚠ **Consequence to accept:** under this ruling, when a client's connection breaks Mintek cannot look. Which is exactly why the four failure-handling items above are not optional, and why the reconnect flow must be usable by a non-technical person unaided.

**Later, its own phase** — material receipts → supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

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
| P245 | QuickBooks integration — **active. Backend and screen done; the link to reach it is S135** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **Prod OS updates.** 59 pending, 12 security, Ubuntu 26.04. Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load, so it redirects to `/login` and runs `sessionStorage.clear()`. Affects every route. A client who bookmarks or refreshes a screen is thrown out. Found S134 |
| P250 | **No role or company check in the policy layer.** `isAuth` proves only that someone is logged in. ⚠ **Scope corrected:** whether individual controllers filter by `company_id` was **not** measured — tenant separation is probably real and enforced per query. So the job is *verify every route filters, find the ones that don't*, not *build separation*. Sits with P247: a leaked token is permanent and unrestricted. Minty's ownership ruling above gives this its requirement |
| P251 | GitHub warns Node.js 20 actions are deprecated. The CI builder was pinned to 20 on 15 Aug because Angular 18.2.12 refuses 18. Reachable only by an Angular major upgrade |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |
| — | Pending, unranked: `external_id` duplicate guard. See Phase 2 above |

**Closed in S134**
- The connection status route. Written unproven in S133, proven and committed `7bdb711`.
- The QuickBooks screen. Six files, built, committed `c6ad2b0a`, deployed `dev-c6ad2b0a17ca`.
- The QuickBooks tab visible in the left menu, restricted to role 8.
- TRAPS filed — entry 12 in, eighteen candidates cut, two of those false. Docs `8e17f41`.
- Phase 2 designed and its fixture built. Phase 3 ownership ruled on.
