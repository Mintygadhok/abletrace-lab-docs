# NOW

Rewritten whole at the close of S134.
Read RULES.md and this file. Nothing else at the open.

---

## STATE

What no command returns.

**SES — parked, waiting on AWS.** Case `178710371200148` on account `208073623096`. S128 filed the reply to AWS's four questions on 19 Aug. Nothing to do until AWS answers. Not touched S130–S134.

⚠ **`ReviewDetails.Status` is not a live status.** It records the last decision AWS made and will read `DENIED` for as long as the reply sits unread. Read the CaseId alongside it — if the CaseId is still `178710371200148`, no new review has been opened and nothing should be re-filed. Re-filing abandons the queue position.

```
aws sesv2 get-account --region ca-central-1 --query "Details.ReviewDetails" --output json
```

⚠ **SES does not block QuickBooks.** Machine-to-machine API work. Nothing in Phase 1 or 2 sends email.

**Old account 350466202408 — teardown parked.** SES is the only remaining live dependency. Minty's ranking: QuickBooks first.

**Prod is on Node v18.** Deliberate — P210.

**Prod has not been touched since before S130.** All QuickBooks work is dev-only. Prod has no `quickbooks_tokens` table, no QuickBooks code, no QuickBooks role or task rows. Correct, and stays that way until Phase 3.

**Prod's git checkout lags the served build.** Deliberate — P8.

**Dev backend carries two untracked items.** `node_modules.old-node18/` is deliberate (P227). **`s133-status-route.py` is debris** — the patch script that wrote the status route. Its output is committed. Delete it at the S135 open:

```
rm ~/abletrace-lab-backend/s133-status-route.py
```

**TRAPS.md was written in S134 and never filed.** Minty deferred filing to the close and the close ran out of room. The file exists as a download; if it is gone, S135 rebuilds it — the triage is recorded in §THE JOB step 1.

---

## P245 PHASE 1 — WHERE IT ACTUALLY STANDS

**The backend is complete and proven. The frontend is built, deployed and rendering. One thing is missing: a way to click through to the page.**

### Proven this session

**Backend `7bdb711`** — connect, callback, refresh, status.

```
curl -s -H "authorization: bearer $TOK" localhost:1337/api/quickbooks/status
```
returned, S134:
```
{"success":true,"connected":true,
 "companyName":"Sandbox Company CA 26d2",
 "realmId":"9341457751382548"}
```

⚠ **That is Phase 1's headline string, and it has already been produced.** The row, the service, the route and the live Intuit call all work. What has never been seen is that string *rendered on an AbleTrace screen*.

**Frontend `c6ad2b0a`** — six files, built green on CI (#78, 8m 40s), promoted to dev as `dev-c6ad2b0a17ca`.

```
/home/ubuntu/www-html.bak-dev-c6ad2b0a17ca     rollback, read off the box
```

**The QuickBooks tab appears in the left strip**, and only for a user holding role 8. Verified on screen S134 as `test260703`.

### The one thing missing

**Selecting the QuickBooks tab shows an empty page — no tiles.** The Admin tab also shows no QuickBooks tile, despite `role_task` id 24 pointing `/quickbooks` at role 2.

So `role_task` alone does not put a link on the home page. **There is a layer between a role and the tasks a user actually sees**, and the `Add Feature +` buttons on `Manage-Users` are almost certainly the UI for it. That layer has not been found. Finding it is S135.

⚠ **The page cannot be reached by typing the URL.** See P249 below. Clicking is the only door, which is why the tile is not cosmetic.

---

## THE JOB — S135

**Put a QuickBooks link on the screen and see the company name. This closes Phase 1.**

### 1 · First, file TRAPS.md — fifteen minutes, then leave it alone

Carried from S134 unfiled. The triage is done; only the filing remains.

**One new entry, number 12: re-authorising a QuickBooks company destroys the stored connection.** Covers Intuit's OAuth Playground (a live authorisation flow that reads like a docs viewer) and reconnecting "to fix" a connection that only looks broken because Intuit rotates refresh tokens daily rather than per call. Retires when P245 lands.

**Eighteen candidates cut**, recorded in the file the way S96 recorded its cuts. Two of them were not merely stale but **false**: `node -c is not a syntax check` (measured S134 on Node v24.19.0 — `-c` and `--check` gave byte-identical output, both exit 1), and a citation of the nginx symlink trap as "TRAPS 10" when entry 10 is the CTE-alias entry.

Filing is a document replacement: pull, replace whole, diff, commit, push.

### 2 · Find the layer that grants a task to a user

Three facts already measured; the fourth is the gap.

```
roles         id 8   'QuickBooks Controller'
role_task     id 23  QuickBooks  /quickbooks  role_id 8
role_task     id 24  QuickBooks  /quickbooks  role_id 2   (Admin)
company_user_role  id 2041  company_user_id 570  role_id 8  is_master 1
```

measured by:
```
mysql abletracelab_live -e "SELECT id, task_name, routing_path, role_id FROM role_task WHERE routing_path='/quickbooks';"
mysql abletracelab_live -e "SELECT * FROM company_user_role WHERE role_id=8;"
```

⚠ **`company_user` does not exist.** Guessed at in S134 and returned `ERROR 1146 (42S02)`. The table `company_user_role.company_user_id` points at is unknown and must be found, not assumed.

Start here:
```
mysql abletracelab_live -e "SHOW TABLES LIKE '%task%';"
mysql abletracelab_live -e "SHOW TABLES LIKE '%user%';"
```

**What the frontend reads**, and why this matters — `admin-dashboard.component.ts:77`:
```
this.userTasks = this.userRoleDetails.CompanyUser.company_user_role
                   .map(role => role.role_data[0].tasks.map(task => task));
```
The tiles come from `role_data[0].tasks`, and `home.component.html:15` iterates `userTasks`. So the question to answer is: **what populates `tasks` on a role for a given user?** If it were `role_task` alone, task 24 would already show a QuickBooks tile under Admin. It does not.

⚠ **`role_task` rows 23 and 24 already exist. Do not insert them again.**

### 3 · Grant it, then log out and back in

⚠ **The role and task data is cached at login.** `userService.getUserdetails()` reads a cached copy — a change in the database will not appear in an open session however correct it is. This looks exactly like broken code. Log out, log back in.

### 4 · How it is verified

**`Sandbox Company CA 26d2` visible on an AbleTrace screen, reached by clicking, logged in as `test260703`.**

That string cannot appear unless the row, the service, the route, the page and the link all work.

⚠ **Click. Never type the address.** See P249.

Second verify: **a user without role 8 does not see the QuickBooks tab.** Already true by construction — the tab is built from the user's own roles.

---

## MATERIAL — measured in S134, do not re-derive

**The test account**
```
test260703@mailinator.com   holds roles 1-8 incl. QuickBooks Controller
```

**The super-admin token, for any guarded curl on dev**
```
TOK=$(mysql -N -B abletracelab_live -e "SELECT webToken FROM user WHERE id=1;")
```
Header is `authorization: bearer $TOK`, **lower case**, or `isAuth` returns 403.

**The frontend files, all committed at `c6ad2b0a`**
```
src/app/Layouts/admin-dashboard/quickbooks/quickbooks.component.ts
                                          /quickbooks.component.html
                                          /quickbooks.component.scss
                                          /quickbooks.module.ts
                                          /quickbooks-routing.module.ts
src/app/Services/Quickbooks/quickbooks.service.ts
src/app/app-routing.module.ts   (route added after food-safety-system)
```

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive so `ls src/app/services` succeeds and `mkdir -p` silently resolves into the existing folder — but Angular's AOT compiler is case-sensitive and fails with TS1261. Cost one build in S134.

**The API base is NOT `environment.apiUrl`**
```
environment.apiUrl = 'http://devapiw.abletrace.ca:1337/api/v1/'
```
measured by `cat src/environments/environment.ts`. QuickBooks routes sit **outside** `/api/v1/` to match the redirect URI registered at Intuit, so `quickbooks.service.ts` strips it:
```
private base = environment.apiUrl.replace(/\/api\/v1\/?$/, '/api/');
```
⚠ Do not "tidy" the QuickBooks routes into v1. Intuit's registered copy is the arbiter.

**Building the frontend** — the app's own script, which is what CI runs:
```
npm run build-dev          # = ng build --configuration=dev --aot
```
⚠ There is no `development` configuration. `ng build --configuration development` fails with *Configuration 'development' is not set in the workspace*.

**Deploying the frontend** — from the Mac only:
```
./promote.sh ~/Downloads/dist-dev-<sha>.zip dev
```
It refuses a dev bundle aimed at prod and vice versa, backs up to `www-html.bak-dev-<sha>`, and prints the rollback line. A push builds dev automatically; the artifact zip lands in Downloads and **must be promoted manually** — the build does not deploy itself.

Then **Shift+Cmd+R**.

**Permissions at the server: there are none**
```
api/policies/   generateJWT.js  isAuth.js  rateLimitLogin.js
config/policies.js:  '*': 'isAuth'   +  QuickbooksController.callback: true
grep -rn "isAdmin\|role\|is_admin" api/policies/ config/policies.js   → nothing
```
`isAuth` proves only that someone is logged in. **Admin is a frontend distinction.** Minty's ruling S134: match the app, do not build a one-off lock for one route. The finding is queued.

---

## ANALYSIS ALREADY DONE

**Why the status route reads the name live from Intuit.** A row can hold a revoked connection and still look fully populated. Only a call that comes back proves it works today. Every failure returns `connected:false` rather than a stale name — so a broken route and a dead connection look identical on screen, deliberately, with the real reason in `sails.log.error`.

**Why connect returns JSON instead of redirecting.** It sits behind `isAuth`, which reads an authorization header. A browser navigating to a URL cannot send one. Guarded routes hand back the destination and let the frontend navigate. This cost S130 a session; the reason is in the controller's doc comment and in TRAPS.

**Why the callback is public.** Intuit redirects the browser back with no token attached. The guard is the single-use `state` value, held in memory, deliberately not surviving a restart. The exemption is in `config/policies.js`. Removing it breaks the connection and the failure looks like Intuit's.

**Why the company column.** Minty's ruling S129. Phase 3 puts Glutenull and Hagensborg on their own QuickBooks; with the column that is two more rows. `company` is UNIQUE, which is also what stops a re-authorisation creating a second row.

**Why the tab is a role and not a component.** The left strip is built from the logged-in user's own roles; the links under it are tasks. Adding a tab is a **database insert**, not a template edit — which means it reaches neither box by deploying, and Phase 3 runs it on prod separately.

⚠ **git cannot tell you what a session did.** S134 opened on `git status`, found one workflow commit, and concluded S133 had done nothing. S133 had in fact created role 8 and both task rows. When a session touches the database it leaves no trace in git.

---

## AFTER

**Phase 2 — the round trip. Minty's description, S132, in his order:**

1. **Prep in QuickBooks** — dummy products and a dummy customer in the sandbox.
2. **Match them in AbleTrace** — so the app knows product X here is item X there.
3. **Packing slip → invoice** — a slip is sent, QuickBooks creates the invoice.
4. **Invoice number returns** — back onto the packing slip.

⚠ **Phase 2 proves the plumbing, not the fit.** With dummy products, matching is trivial. With a real catalogue it is the hardest part of the job — along with customer matching and tax codes.

**Phase 3.** Glutenull and Hagensborg on their own books. Needs Intuit **production** keys, a fresh authorisation per client, the `CREATE TABLE` run separately on prod, the role and task rows run separately on prod — and **the API base host changes**: production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.

⚠ Production keys reach live client books. They never come near chat, in any form.

⚠ **Intuit's refresh token policy changed.** Refresh tokens carry a maximum validity of five years, and a **Reconnect URL is a mandatory field** in app settings as of February 2026. Applies at Phase 3, but the field is mandatory on the developer portal, so check it when production keys are set up.

**Later, its own phase** — material receipts → supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated for GST; other food is not. Every invoice line carries a tax code and an accountant will see it. This is why the sandbox had to be Canadian.

⚠ **Quantities on an invoice are units, read across from the slip.** Never derived from weight. RULES §7.

⚠ **P240 applies.** A silent failed invoice is worse than a silent failed email.

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
| P245 | QuickBooks integration — **active. Backend and screen done; the link to reach it is S135** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. Fold into P241 |
| P248 | **Prod OS updates.** 59 pending, 12 security, Ubuntu 26.04. Fold into P241 |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, which is memory only and empty after a page load, so it redirects to `/login` and runs `sessionStorage.clear()`. Affects every route, not just QuickBooks. A client who bookmarks or refreshes a screen is thrown out. Found S134 |
| P250 | **No server-side role check anywhere.** `isAuth` proves only that someone is logged in; Admin is a menu distinction. A logged-in user who knows a URL reaches any route. Sits with P247 — a leaked token is both permanent and unrestricted. Found S134 |
| P251 | GitHub warns Node.js 20 actions are deprecated. The CI builder was pinned to 20 on 15 Aug because Angular 18.2.12 refuses 18. Reachable only by an Angular major upgrade |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread across 3B.3, 3B.5–3B.7, 3B.9–3B.11 |

**Closed in S134**
- The connection status route. Written unproven in S133, proven and committed `7bdb711`.
- The QuickBooks screen. Six files, built, committed `c6ad2b0a`, deployed `dev-c6ad2b0a17ca`.
- The QuickBooks tab visible in the left menu, restricted to role 8.
- The admin question. Measured: no server-side role control exists. Minty's ruling: match the app, queue the finding.
- TRAPS triage: one entry in, eighteen cut, two of those false.
