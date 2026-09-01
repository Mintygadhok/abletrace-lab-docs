# NOW

Written at the close of **S147**. The launchpad for **S148**.

---

## ⚠ HOW S148 OPENS

**Minty's instruction, S147:** *"ask next session to write the deliverable and discoveries you have made so that is the starting point for next session. if it needs anything more — I will come back to you for providing the answer — that may be the fastest way. we lost 1 hour today."*

So, after the open check and before anything else:

1. **Read THE DELIVERABLES and THE DISCOVERIES below and restate them back to Minty.** Both are written out in full in this file. Nothing needs recovering from a past chat.
2. **Say what — if anything — is missing.** Ask Minty directly. He answers faster than a measurement does.
3. **Then start.**

⚠ **S147 lost an hour** because this file said two scripts were unfiled when the S146 commit had filed them, and because Claude misread two commands' output as one and asserted a change that had not happened. **When this file and the repo disagree, the repo wins. Measure before asserting.**

---

## STATE

**Deliberate, done — S147:**

- **The four rules approved S146 are now in `RULES.md`** and pushed. Commit `577ccdf`. They no longer depend on this file surviving.
- **`operations/dump-columns.sh` was replaced.** The copy filed in S146 had been pulled from prod and lacked the `hostname -s` line; it also hardcoded `abletracelab_live`. The new one prints the host and takes an optional schema argument.
- **`operations/dump-objects.sh` was measured and left alone.** It already had everything — routine bodies, trigger bodies, foreign keys, the hostname line.

**Half-done:** nothing.

**Standing:** the domain cutover is complete and proven — all four names serve from `15.157.38.101`, `.env` line 8 is `APP_BASE_URL=https://app.abletrace.ca`. Dev and prod are structurally identical at 778 columns, 62 FKs, 35 routines, 0 triggers (S146). `quickbooks_tokens` is empty and stays empty until someone clicks Connect.

---

# THE JOB — S148: CLIENT ONBOARDING (P262)

**Rewrite the client onboarding importer, build the template, and load a dummy client on dev.**

⚠ **Dev only. Prod is not in this session.**

---

## THE DELIVERABLES

Agreed with Minty, S147. Restate these at the open.

**1 · Read `api/services/importSheet.js`.** The rewrite is already decided — this is to find what it handles that we have not thought of.

**2 · `AbleTrace-Client-Onboarding.xlsx`** — the template, empty, handed to Minty. Eleven tabs:

| tab | one row per |
|---|---|
| Instructions | — |
| Agents | supplier |
| Customers | customer |
| Customer-Addresses | shipping address |
| Materials | material |
| Material-Allergens | material-allergen |
| Material-Suppliers | material-supplier pair |
| Products | product |
| Product-Packaging | packaging level (1 to 4) |
| Recipe-Lines | recipe component, with `Component_Type` |
| Lists | — |

⚠ **No comma lists. No `$` lists. No Manufacturers tab.**

**3 · Minty fills it** with dummy data — a handful of rows per tab, **including at least one product that uses an intermediate** — and creates a dummy company on **dev** through the UI.

⚠ **This is the session's biggest variable.** Minty may create the dummy company before S148 opens; it needs nothing from Claude.

**4 · Rewrite `importSheet.js`** for the new tabs, on **dev**. Passes in dependency order:

> suppliers → materials → material-suppliers → material-allergens → products → product-packaging → recipe lines (materials) → **recipe lines (products)** → customers → customer-addresses

**5 · The super admin upload screen.** Download Template beside Import, with the Sync Client company picker, **single selection**, filename echoed back in a `confirm()`.

**6 · Load it on dev and prove it on screen.**

**Not promised.** The HACCP-style review screen — rows landing in editable dropdowns before saving — may not fit in one session. If it does not, deliverable 6 uses a plainer upload and the review screen becomes its own job.

⚠ **HACCP is OUT of S148.** Minty's ruling S147: food safety comes after traceability. Its screens are read as a **pattern only** — no HACCP code is touched.

---

## THE DISCOVERIES — all measured S147

### The upload path, traced end to end

> **button → posts the raw file + a `sheetName` → `POST /api/v1/Sheet/importSheet` → `ImportExcelSheetController.importSheet` → `api/services/importSheet.js` → the four model methods → database**

⚠ **The browser never reads the sheet.** Every frontend grep for `XLSX.read`, `sheet_to_json` and `FileReader` returned only **exports**. The server opens the workbook and reads the tab named in `sheetName`.

`sheetName` is hardcoded per screen — `'Materials'` at `manage-materials.component.ts:311`, `'Products'` at `admin-formulation.component.ts:162`. **That is why the same file is uploaded four times today.**

### Code locations

| what | where |
|---|---|
| **the parser** | `api/services/importSheet.js` — a **SERVICE, not a model** |
| controller | `api/controllers/ImportExcelSheetController.js` — 17 lines, pass-through |
| suppliers | `api/models/CompanyAgents.js:35` |
| materials | `api/models/Materials.js:249` |
| products | `api/models/Formulations.js:727` |
| customers | `api/models/CompanyCustomers.js:81` |

⚠ **All four controllers are pass-throughs. The logic is in the models.** S147 wasted time grepping controllers.

Model sizes: `CompanyAgents` 431 · `Materials` 896 · `Formulations` 1301 · `CompanyCustomers` 434 · `Materialsagents` 45.

Upload buttons already exist on: `admin-formulation` · `manage-materials` · `agents` · `manufacturers` · `customers`. **No new upload screen is needed for the client-side path.**

### Faults in the existing importer — the case for rewriting

- ⚠ **`importMaterials`'s duplicate check is broken.** Compares every row against every row below it, **double-pushes** into `duplicateInExcel` once a title is already there, and handles the last row as a hand-written special case. Works on a demo sheet; loses rows on a real one.
- ⚠ **`company_id` is taken off the ROW** — `dataToPopulate[i].company_id`. P250 rewrites the *request*, not each row. **The importer does not respect P250.**
- ⚠ `admin-formulation.component.ts:70` — `url: 'http://localhost:1338/Sheet/importSheet'`, hardcoded. → **P283**

### Database facts

- ⚠ **`unittype` is GLOBAL — no `company_id`. Three rows: 1 Ingredient, 2 Packaging, 3 Non-Food Chemical.** Mava's materials: **294 on type 1, 16 on type 2.** Matches the demo file's `GetMaterialInfo` list exactly. **So the Materials Type column is a FIXED dropdown, same for every client.**
- ⚠ **`producttype` is PER-COMPANY FREE TEXT and Mava misuses it.** Rows 42/45/47/48/49 are `A Loving Spoonful`, `BC Ferries`, `KFW`, `Meals on Wheels`, `Intercity` — **customer names, not product types.** Other companies use Intermediate / Finished / Bulk. **The previous claim that `producttype` drives material Type is DISPROVEN.**
- **`materialsagents`** is the material-supplier link: `material_id`, `agent_id`, `iss`, `iss_expiry_date`.
- **`companyagents`** columns: `company_name, address, contact_person, email, contact_number, is_agent, company_id, user_id, status_id, updatedByUser, remarks`. ⚠ **No code column of any kind.** → **P282**
- **`unitmeasurement` is per-company.** Mava's eight, ids 635–642: Kg, Lb, Ltr, Bag, Box, Bottle, Pallet, Ea.
- ⚠ **`fopackaging` level-1 rows for Mava: ZERO.** No stored unit count per batch. **Batch quantity stays a blind input — Minty's S140 ruling holds.**
- Mava (company 184, archive schema): **310 materials, 171 products, 25 agents, 13 customers.**

### The current template — `1. Demo File.xlsx`, read tab by tab

Eight tabs: Instructions · Agents · Manufacturers · Customers · Materials · Products · GetMaterialInfo · GetProductInfo.

Every positional list, located:

- **Customers** — four parallel `$` lists: shipping contact, number, email, address. ⚠ **Correctness depends on all four having the same count in the same order.** A blank email shifts every address after it onto the wrong contact, silently. ⚠ **The demo file already breaks its own convention** — row 6 has a comma inside a `$` field, row 7 has two comma-separated emails.
- **Materials** — allergens, agents, manufacturers, all comma lists.
- **Products** — seven comma lists. Packing materials / weights / WDU align three ways; two hardcoded `Sub_Recipe1` and `Sub_Recipe2` column pairs align two ways each.
- ⚠ **The single most dangerous cell:** `Packing_Configuration` level 1 is a **WEIGHT in Kg**; every level above is a **COUNT**. Same cell, position deciding which. Baked Chicken reads `.5,10` — half a kilo per tray, then ten trays per carton.
- ⚠ **No column anywhere for a product used as a component.** **That is why intermediates are done by hand.**
- The demo contains a material literally named `Null`, and a product row using it — the placeholder where an intermediate should have gone.

### Working patterns to copy — both seen on screen S147

**Global Procedures → Sync Client:** a company picker searching by name or email, **Company Name and Admin Email side by side**, count on the button. ⚠ **Sync allows many companies; onboarding must allow exactly ONE.**

**Create HACCP:** **Download Template** beside **Import HACCP Excel Sheet**; a `confirm()` echoing the filename (*"Do you want to Upload HACCP_master.xlsx file?"*); then **rows land in an EDITABLE FORM** — Hazard Type and scores as constrained dropdowns, Total Score and NS/S derived live — and nothing is saved until **Next**.

⚠ **That is better than a server-side validate pass.** A wrong value cannot be chosen at all, and Minty sees the data rather than a list of complaints about it. It is the target for the onboarding screen.

**`HACCP_master.xlsx` itself is already one-row-per-record** — `Process_Material`, `Hazard`, `Hazard_Type`, and "Packing baked chicken in BC Tray" appears **twice** because it has two hazards. The new template's shape is already proven in production.

---

## DECIDED — do not relitigate

| | |
|---|---|
| **Rewrite, not extend** | `importSheet.js` is built around splitting cells; we are removing every cell that needs splitting. Old file stays in git. Minty's ruling S147 |
| **Super admin, single company** | Company comes from the picker, not the session. Super admin (user_id 1) is already exempt from the P250 rewrite |
| **Dev before prod** | Prove on dev, then prod as its own step |
| **No Manufacturers tab** | *"agent is good enough. We will take agent as a supplier, single point."* Materials also loses its Manufacturers column. `is_agent` stays in the schema, untouched |
| **No default supplier** | Not in this job. POs exist and could use it → queued |
| **Certificates deferred** | `iss` / `iss_expiry_date` are per material-supplier pair, but a certificate is a **FILE on S3**. Importing the date without the file is worse than blank. Done in the app afterwards |
| **One row per record throughout** | A missing value becomes a blank cell in the right row, not a shortened list that shifts everything after it |
| **Names, never ids** | Supplier names must match **exactly** — *"snowcap means snowcap."* No fuzzy matching |
| **Intermediates: `Component_Type`** | `Material` or `Product`. Products are created first, so the product-as-component pass runs second and every reference resolves. **This removes Minty's manual step** |
| **Quantity units** | `Component_Type = Material` → **Kg**. `Component_Type = Product` → **units** |
| **Shipping unit** | The **highest packaging level present**. `Total_Packaging_WDU` is defunct and does not go in the new template |
| **Refuse a non-empty company** | Recovery is then: delete the company, run again |

⚠ **Minty on stock, S147:** the Kg figure for an intermediate is indicative and will never be exact — that is fine. **Stock on hand in units must stay clean**, or a miscellaneous release cannot be zeroed later. This is RULES §7's one exception: the unit count is derived once at the release write, rounded to three decimals, banked in the row.

---

## VERIFY — what must be seen on screen to call S148 done

1. The dummy company on dev lists its **suppliers**.
2. **Materials** list with the correct Type — Ingredient vs Packaging.
3. A **product** shows its packaging levels, level 1 carrying a weight and levels above carrying counts.
4. ⚠ **A product shows an INTERMEDIATE in its recipe** — the thing done by hand today.
5. **Customers** with more than one shipping address, each address on the right contact.

---

## PROOF — every fact above, with the command that produced it

| fact | measured by | returned |
|---|---|---|
| import routes | `grep -n "import" config/routes.js` on dev | six routes, lines 37/78/130/153/187/289 |
| the four model methods | `grep -n "importCompanyAgentmanufacturer\|importCustomerExcel" api/models/*.js` | `CompanyAgents.js:35`, `CompanyCustomers.js:81`; plus `Formulations.js:727`, `Materials.js:249` |
| controllers are pass-throughs | `wc -l api/controllers/*.js` | 52 / 84 / 118 / 70 / 17 |
| model sizes | `wc -l api/models/...` | 431 / 896 / 1301 / 434 / 45 |
| the parser is a service | `grep -rln "importSheet" api/ config/` | `api/services/importSheet.js` |
| `importMaterials` is broken | `sed -n '249,300p' api/models/Materials.js` | quadratic loop, double-push, hand-written last row, `company_id` off the row |
| no frontend sheet reading | `grep -rn "readAsBinaryString\|XLSX.read\|sheet_to_json" src/app --include="*.ts"` | **empty** |
| upload buttons exist | `grep -rln "cloud_upload\|fileInput\|type=\"file\"" src/app --include="*.html"` | 27 files incl. all four master screens |
| `unittype` | `SELECT id, unit_type_name FROM unittype ORDER BY id;` | 1 Ingredient, 2 Packaging, 3 Non-Food Chemical |
| Mava materials by type | `SELECT type_id, COUNT(*) FROM materials WHERE company_id=184 GROUP BY type_id;` | 1 → 294, 2 → 16 |
| `producttype` misuse | `SELECT * FROM producttype;` | ids 42/45/47/48/49 for company 184 are customer names |
| the link table | information_schema query for tables with material + agent columns | `materialsagents` — `material_id, agent_id, iss, iss_expiry_date` |
| `companyagents` columns | same query, `TABLE_NAME LIKE '%agent%'` | eleven columns, **no code field** |
| units per company | `SELECT id, unit_name FROM unitmeasurement WHERE company_id=184;` | 8 rows, ids 635–642 |
| no level-1 packaging | `SELECT COUNT(*) FROM fopackaging WHERE pack_level=1 AND formulation_id IN (…184);` | **0** |
| Mava counts | four scalar subqueries | 310 / 171 / 25 / 13 |
| the current template | `openpyxl` read of `1. Demo File.xlsx`, all eight tabs | headers and first rows, quoted above |
| the screens | screenshots, S147 | Sync Client dialog · Create HACCP with Download Template + Import · the confirm dialog |

⚠ **Two one-off measurement scripts were used and are deleted at the tidy:** `s147-measure-mava.sh` (prod) and `s147-measure-code.sh` (dev). Their output was `/tmp/s147-mava.txt` and `/tmp/s147-code.txt`, also deleted.

---

## NOT MEASURED — and it is the job, not homework

**`api/services/importSheet.js` has not been read.** Neither have the four Add forms. Both are S148's opening acts, not preparation for it.

---

# OTHER OPEN ITEMS — not part of the job

## ⚠ TWO LIVE CLIENTS SEE "Your licence has expired."

Shelly (Hagensborg) and Javier (Designer Cookies). Status 4 Expired still permits login — only 6 Inactive blocks it. Works as designed, but it is the first thing both clients read, and the WhatsApp pointing them at `app.abletrace.ca` went out S145.

⚠ **Seen again S147** on the `test260703` admin home. **Business question, now three sessions old.**

## Certificate renewal, before 27 November

All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **DNS now points at this box, so re-issue them the ordinary webroot way and renewal becomes automatic.** Cheap, and it removes a hard deadline.

## ⚠ THE OLD ACCOUNT IS UNBLOCKED — S145's job

**Nothing you own points at CloudFront any more. Nothing has been deleted. ONE ITEM AT A TIME** — Claude shows what points at each resource, Minty says go. Never a batch; the S138 subdomain takeover happened exactly that way.

⚠ **`prodapi.abletrace.ca` A → `3.98.223.126`**, the old account's Elastic IP. **The DNS record goes first, never the IP first.**

**Goes safely, nothing points at these** (~$2/mo): `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (never used).

**Goes now the cutover has proven out** (~$58/mo): instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record.

**Stays permanently:** SES `ca-central-1` (only working email path — the new account was denied) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1`, the only copy of client documents** · root + MFA.

**Needs a question answered first:** key `AKIAVDGLJ3MUH7IPS3W7` (`s3_cloudfront`), last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at it. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** ($25.76/mo): the 6 manual RDS snapshots.

⚠ Three spent `_acme-challenge` TXT records remain in the zone. Harmless.

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P262 | **S148. Client onboarding importer — complete rebuild.** Deliverables and discoveries are written out above. **Nothing needs recovering from a past chat** |
| P281 | **Stale `mintekfoodsafety.com` fallbacks in the backend config.** `config/env/production.js` lines **24, 151, 250** and `config/env/development.js` line **7** read `process.env.APP_BASE_URL \|\| 'https://...mintekfoodsafety.com'`. Plus a stale comment at `QuickbooksController.js:97`. ⚠ **Nothing is broken** — prod's `.env` supplies the right value and wins. ⚠ **But if that variable ever goes missing, prod silently reverts to the old domain and nobody would notice.** ⚠ **`development.js` stays — dev is not moving** |
| P279 | **Invoicing inside AbleTrace.** Minty's design S145: **default price on the product master, editable per invoice line**; **default tax treatment per product, overridable per line**, plus a manual option. ⚠ **Store the values USED on the invoice — never re-derive from the master later.** ⚠ **Tax must be per line** — basic groceries are zero-rated, prepared foods are not, one order can carry both. QuickBooks transfer becomes **optional and manual**. Design questions before any code: invoice **numbering scheme** (per-company or global, gapless, never reused, who allocates and when) · where the **editable price field** sits on the product formulation page and who may edit it · **invoice layout** and what a Canadian food invoice must legally carry · **its own tile ("Generate AbleTrace Invoice") or inside the packing slip flow** — a tile means database role rows, not frontend code · **what happens if the push fails after a number is allocated.** ⚠ **Minty's ruling S146: price is CURRENT only — no versioning, no history. The invoice COPIES the price onto itself at issue and never reads back to the product.** Clients wanting their own record get a downloadable Excel |
| P278 | **Terms and privacy policy inside the app, with versioned acceptance.** ⚠ **Measured S146 — the files are `src/assets/docs/terms.html` and `privacy.html`, so replacing them is a FILE SWAP, no code change.** Two acceptance routes, users and company employees, both must point at the same documents. Record **who accepted, when, and WHICH VERSION**; on a change, ask again. ⚠ Acceptance rows are never edited or deleted. ⚠ **`company.terms_condition` is a yes/no flag with no version and no timestamp — replace it, don't extend it.** Still to measure: which screens link to the two files, whether Angular renames assets at build, the prod build path. ⚠ **Blocked on the lawyer returning both documents** |
| P277 | **Client data deletion routine.** Deletion on request is a published commitment with no tooling. ⚠ Manual today: many related tables in FK order, **plus the `abletrace-fileuploads1` bucket whose filenames name no company** |
| P276 | **Naming audit across all environments.** ⚠ Both RDS instances hold a schema called `abletracelab_live` and one called `abletrace-dev`; `SHOW DATABASES` is identical on both boxes. Audit instances, schemas, EC2s, PM2 processes, buckets, IAM users, repos |
| P280 | **Split the marketing site out of the Angular app.** Today a visitor downloads the whole application to read three paragraphs, and every marketing tweak needs a full rebuild. ⚠ **No harder later than now.** Assets on the box: `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images. ⚠ **Copy to `/var/www/marketing`, never reference them from `/var/www/html`** — every deploy wipes that whole. ⚠ `/var/www/` is root-owned |
| P272 | **Rotate dev's DATABASE_URL password.** Printed to screen S143. Dev only; prod untouched; the RDS instance is not publicly reachable. ⚠ **Method 3B.8, read it first** |
| P267 | **QuickBooks production approval.** ⚠ **Off the critical path per P279, and waiting on a lawyer.** Gaps: disconnect URL in Production Settings · `intuit_tid` capture · both legal documents naming AbleTrace · redirect becomes `https://app.abletrace.ca/api/quickbooks/callback` with `app.abletrace.ca` declared. ⚠ **Also never done: the OAuth connect flow has never run against prod, only sandbox** |
| P270 | **Material certificate icon shows red "Certificate Unavailable" when a valid in-date certificate exists.** **Display fault only** — the file downloads and opens |
| P274 | **No local build path.** ⚠ `nvm` is not installed; the Mac is Node v24 against a project declaring `^20`. The only route when GitHub is unavailable |
| P275 | **192 npm vulnerabilities (6 critical, 79 high).** ⚠ **Do NOT run `npm audit fix`** — it rewrites dependency versions |
| P271 | `[object Object]` alert on SO-Management. An error path that fails to render its own message |
| P17 | Two old-account IAM keys still valid and in git history. The old account is load-bearing for email |
| P8 | **Prod git checkout lags the served build.** Checkout reads `9bce0238`; `/var/www/html` serves `2a576cb8`. **Not a failed deploy** |
| P210 | Prod to Node v18 → v24. Dev has run v24 cleanly for several sessions |
| P248 | **OS updates.** ⚠ **Both boxes say "System restart required" on every login.** Prod 59 pending / 12 security; dev 56 / 25 |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — Phase 2 core done and proven on dev. ⚠ **Schema now on prod too, S146.** Four failure-handling items remain |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn` |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated. Seen on every run |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dead build folders and spent scripts.** Dev home ~50 folders back to S63. ⚠ Keep the live rollback and one prior. Also: `.env.bak-s139` both boxes · prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/`, `patch-nginx-abletrace-s143.py`, `patch-nginx-app-s144.py`, `extract-hagensborg-procedures.py`, `dist-prod-2a576cb8….zip`, `/tmp/*-tables.txt`, `hagensborg-procedures.txt` · Mac `environment.prod.ts.bak-s144`, `/etc/hosts.bak-s144` |
| P257 | **Automated bounce and complaint handling.** ⚠ Required for any SES re-application |
| P258 | **Test companies that exist and cannot be deleted.** `testses260825a` dev · `testsesprod260825` prod · `test260831` prod. Set Inactive through the app, not by SQL |
| P259 | **One IAM key serves both boxes.** Separate eventually. Dev first, prove a send |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` · `abletracelab-ses-smtp-s35` |
| P264 | **No automated tests anywhere.** ⚠ Never run the S141 attack test against prod |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`.** ⚠ Confirmed S146: the tile does NOT appear for a company created without the role rows. **Half its homework is done** — the standby job if S148 is blocked |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224`. ⚠ `Materials.js:380` and `:790` use `myCode` and were never checked |
| P282 | **External supplier code on `companyagents`.** ⚠ **Added S147.** The table has **no code column of any kind** — products and customers have `External_ID`, suppliers do not. Needs: a column on **both boxes** · the Add Supplier form and the supplier list screen · a template column. ⚠ **Minty's ruling S147: not in P262. Names work as the join key; do the onboarding first.** Worth doing once POs are in regular use — a PO is raised per supplier and the client reconciles against their own purchasing system |
| P283 | **`http://localhost:1338/Sheet/importSheet` hardcoded** at `admin-formulation.component.ts:70`. ⚠ **Added S147.** A dead URL in production. Likely resolved by the P262 rewrite, but recorded in case it is not |

---

## TRAPS CARRIED FORWARD — all look like broken code

### ⚠ THE PASTE PROBLEM — cost an hour again in S147

⚠ **Copy ONLY from the grey fenced box in the chat. NEVER from the terminal window.** S146 lost five exchanges to this; **S147 lost three more on the very first paste of the session**, and again mid-session — the clipboard held the terminal selection, not the fence, every time. **Ctrl+U, paste, Enter, one block.** When the clipboard will not cooperate, **type the line by hand** — that is what finally worked in S147.

⚠ **A pasted fragment containing `>` SILENTLY EMPTIES the file it names.** S146: a stray tail ending in `> /tmp/prod-columns.txt` truncated the file to zero; `wc -l` then read 0 and the query was suspected instead.

⚠ **A filename label proves NOTHING about which box produced the file.** `dump-columns.sh dev` run on prod produces `columns-dev.txt` holding **prod's** schema, with a line count that reads as agreement. **Read the `hostname -s` line the script prints.**

⚠ **Counts matching is not contents matching.** Two routines can share a name and differ inside. `dump-objects.sh` compares **body text**.

⚠ **`Trace_MaterialDetails_SP` differs between the boxes by FIVE COMMENTS only** — prod has them, dev does not; every statement is character-identical. ⚠ **Minty's ruling S146: leave it. Comments do not execute.**

### ⚠ NEW, S147

⚠ **Two commands run back to back print two results, and it is easy to read the second as belonging to the first.** S147: `git log` and `git diff --cached --stat` ran together, and the stat line — which described Claude's own staged change — was read as S146's commit. It produced a confident, wrong assertion and an unnecessary undo. **One command per block when the output matters.**

⚠ **`M` not `A` in `git status` means the file was ALREADY TRACKED.** That is how S147 discovered NOW was wrong about the operations scripts. **Read the letter.**

⚠ **This file can be wrong about the close's own final steps.** NOW is written, then the close does more work, and nothing goes back to update it. **When NOW and the repo disagree, the repo wins.**

⚠ **Model methods can live in `api/services/`, not `api/models/`.** `grep -rn "name" api/models/*.js` returning nothing does not mean the code is absent. **Search `api/` whole.**

### Standing

⚠ **A GitHub run can COMPILE and still fail.** The upload step is separate. **Read which step went red before touching the code.**

⚠ **`dig` ignores `/etc/hosts` entirely.** Use `dscacheutil -q host -a name <n>`.

⚠ **Chrome serves the OLD site from cache after a DNS change.** Prove the server with curl, then use a **fresh incognito window** — a hard refresh was not enough.

⚠ **A blank page with the correct tab title means the JavaScript threw**, not that the server failed.

⚠ **The deploy script prints a rollback line to the build it just replaced.** **Read the path off the box.**

⚠ **Check `index.html` is at the top level of an unzipped artifact** before deploying — the script copies `$SRC/*`.

⚠ **`curl -I ... 2>&1 | head -1` returns the PROGRESS METER.** Use `curl -s -I`.

⚠ **Column names are not guessable.** `documenttype.name` not `title`; `company.company_name` not `name`. ⚠ **S147: `unitsubtype` was guessed off a model filename and does not exist.** **`SHOW COLUMNS` — or ask `information_schema` — first.**

⚠ **`haccpplan` has no `company_id`.** Join through `hazards`.

⚠ **A local `dig` can return EMPTY while Route 53 already holds the new value.** Ask the authoritative server directly.

⚠ **Route 53 truncates record names in the list.** **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** **Read the account number before the measurement.**

⚠ **zsh needs `--include="*.ts"` QUOTED.** Unquoted, it fails with "no matches found" and looks like an empty result.
