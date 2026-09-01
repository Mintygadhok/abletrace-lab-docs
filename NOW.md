# NOW

Rewritten whole at the close of **S146**.

The open check measures commits, process, port, runtime and dirty trees. Nothing here repeats it. This carries only what no command returns.

---

## STATE

**S146 closed the schema drift. Dev and prod are structurally identical.**

**Deliberate, done:**

- **The QuickBooks schema was applied to PROD.** Table `quickbooks_tokens` (10 columns) and five `qb_*` columns on `packingslips`. Add-only: nothing dropped, no existing column altered, no row touched. `packingslips` 6 rows before and after.
- **Proven, not just applied.** Re-dumped both boxes and diffed: **778 columns each, `diff` returned nothing.**
- **Procedures, triggers and foreign keys also compared.** 62 FKs, 35 routines, **0 triggers** — identical on both boxes.
- Dispatch Orders drew on prod under `app.abletrace.ca` after the change. Empty (test company), no error, no `ER_BAD_FIELD_ERROR` in the log.

⚠ **Nothing was connected to QuickBooks.** `quickbooks_tokens` is empty and stays empty until someone clicks Connect. **The plumbing is in; the tap is not connected.**

**Half-done — ONE item:**

⚠ **Four rules were approved S146 and are NOT yet in RULES.md.** They are quoted verbatim below. **Write them into RULES at the open of S147, while fresh.** Until that is done they exist only in this file.

**The domain cutover remains complete and proven.** All four names serve from `15.157.38.101`. Prod frontend `2a576cb8`, `.env` line 8 `APP_BASE_URL=https://app.abletrace.ca`, three nginx 443 blocks, three Route 53 A records TTL 60 Alias OFF. Clients told by WhatsApp S145.

---

## ⚠ THE FOUR RULES APPROVED S146 — WRITE THESE INTO RULES.md FIRST

**Minty approved all four. Claude has not yet edited RULES.** Doc edits are replacements: pull first, replace whole, diff, commit, push.

**1 · Into §6, ahead of the numbered list:**

> **Load-bearing work goes first.** Design, judgement and change go in the fresh part of a session. Discovery — measurements, paths, dependencies — comes after, because it degrades gracefully and a wrong measurement shows itself.
>
> **The close is proposed before it is written.** Claude states the next job as a plain list, the discovery it needs, and which of that discovery has been done — then stops and waits for Minty. Missing discovery is done before the close, not after.

⚠ **Point 3 must be allowed to say NO.** A confirmation that can only come back yes is not a check — the same fault as a test that cannot fail.

⚠ **Consequence, and it constrains Claude:** do not open a session with a long measuring pass before the real work. Push back if a session drifts into discovery while Claude is still sharp.

**2 · Into §6, under "Also at the close":**

> **Diff the schemas at every close.** Run `dump-columns.sh` on both boxes and diff the two files. A difference is either applied to both boxes before the close, or written into NOW as deliberate. Never left unexplained.

⚠ **This aligns STRUCTURE, never DATA.** Prod's rows are clients' records; dev's are test junk. Keeping the data apart is the whole point of two boxes. **Word it so that cannot be misread.**

**3 · The `operations/` folder.** A new folder in `abletrace-lab-docs`.

> **`operations/` holds only scripts a rule tells you to run.** One-off scripts are written, run, and deleted at the tidy. What a one-off did is recorded in its **commit message** — not in NOW, which is rewritten whole.

⚠ **Operational code vs application code — Minty's distinction, S146.** Application code runs the product, ships to clients, and breaks AbleTrace if it breaks. Operational code runs *us* — it measures and reports, never reaches a client, and announces its own failure. Operational code belongs beside the rules it serves.

**4 · The entry test for `operations/` is strict**, or the folder becomes the same trap the documents were.

---

## ⚠ THE OPERATIONS SCRIPTS — WRITTEN S146, NOT YET FILED

Both exist on **prod and dev home directories** and in **Mac Downloads**, all three of which are ephemeral. **Rename (drop the `-s146`) and commit to `abletrace-lab-docs/operations/` at the close.**

**`dump-columns.sh`** — every column of every table and view. `TABLE_TYPE|TABLE_NAME|COLUMN_NAME|COLUMN_TYPE|IS_NULLABLE|DEFAULT|EXTRA`, one line each, sorted. Prints hostname, line count, first line. **Required at every close.**

**`dump-objects.sh`** — routines with **full body text**, triggers with body text, and foreign keys with update/delete rules. Body text is included so a routine that exists on both boxes with **different logic inside** is caught; a name-only comparison would miss it. **Run when a session has touched a procedure, or every few sessions.**

⚠ **`apply-qb-schema-s146.sh` is a one-off. It has run. Delete it at the tidy.** → P256

⚠ **The label argument names the OUTPUT FILE ONLY — it does not select a box.** S146 ran `dump-columns.sh dev` while still on prod and produced a file called `columns-dev.txt` holding prod's schema, with an identical line count that looked like agreement. **Both scripts now print `hostname -s` first. Read it.**

---

## THE JOB — S147: THE CLIENT ONBOARDING IMPORTER

**P262. Complete rebuild. Minty's ruling S140, restated S146: no constraint to preserve the existing template or importer. Several clients are coming. This must be robust.**

⚠ **Minty's ruling S146: S147 opens with its own discovery, deliberately.** The five measurements below were not taken in S146. That is accepted, not an oversight — the design work below is done and evidenced, and the measurements are named rather than vague.

**Mava is the pilot.** Real data, real complexity, nobody harmed if it goes wrong.

⚠ **The direction is the REVERSE of S140.** S140 pulled Mava's master data OUT of the archive into a workbook. S147 pushes it back IN, to a fresh dummy company, to test the importer.

### The action, in order

1. Run the five measurements below.
2. Minty creates the dummy company **through the UI**.
3. Rebuild the importer to the one-row-per-record shape.
4. Load `Mava-Foods-master-data.xlsx` into the dummy company.
5. Second automated pass wires the product-as-component lines.
6. Prove it **on the screen**.

### The five measurements — S147 opens with these

1. **Does the existing importer still run?** Where it lives — controller, route, and the screen that calls it. ⚠ If it does not run, "extend" was never on the table.
2. **Column diff, archive `abletrace` vs live `abletracelab_live`.** The archive data is 2019–21; the schema has moved. `formulations` gained `inventory_units`; `companycustomers` gained `external_id`. ⚠ **One command — `dump-columns.sh` already does exactly this**, point it at the other schema.
3. **`producttype`** — turns `type_id` into the Type column. Mava's materials are `type_id` 1 (294 rows) and 2 (16 rows).
4. **`fopackaging` level-1 rows for company 184.** If they exist, the unit count per batch may be **stored** rather than a blind input — better, and one query.
5. **Can the importer accept a PRODUCT as a sub-recipe component?** 25 lines across 12 products depend on it. The template's columns say "Materials", and the demo row `Baked Chicken with BBQ Sauce` has `Sub_Recipe1_Materials` = `Null` with qty 1, which reads like a workaround.
6. **Does the importer respect P250?** It predates the fix. `isAuth` now rewrites `req.body.company_id` on every authenticated request — an importer that sets its own company id will be overridden.

### ⚠ The two silent failure modes that justify the rebuild — measured S140

**1 — Parallel comma lists.** `Sub_Recipe1_Materials` holds `"Ginger Powder,Salt"` and `Sub_Recipe1_Materials_Qty` holds `"7,1"`. Nothing enforces same length or same order. ⚠ **When it breaks it misassigns quantities rather than failing.**

**2 — `$` packed into customer cells.** `Shipping_Contact_Person` holds `"Shanda$tom$Gerry"` with matching `$` lists in three other columns. Same failure mode.

**The fix, and it is one idea: one row per record, everywhere.** A `Recipe_Lines` tab — parent code, component name, component type, quantity, one line each. A `Customer_Addresses` tab — one row per address. ⚠ **This is exactly the shape the Mava workbook already has, because it is the shape the database has.**

⚠ **Keep referencing everything by NAME, not by id.** That is what makes the sheet human-editable and removes all id-remapping from the load.

### ⚠ Minty's manual step 2 can be deleted entirely — measured S140

Today the recipe load is two steps: formulations without intermediates, then **Minty manually amends recipes to add intermediate products**. The manual step exists because a product cannot be referenced before it exists.

```
parents that use a sub-recipe:              12
distinct children used:                     16
children that are THEMSELVES parents:       none — depth is exactly 1
```
Measured from `6-recipes.tsv`:
```
python3 -c "import csv; rows=list(csv.reader(open('6-recipes.tsv'),delimiter='\t'))[1:]; edges={}; [edges.setdefault(r[1],set()).add(r[7]) for r in rows if r[5]=='product']; kids=set().union(*edges.values()); print(len(edges), len(kids), sorted(kids & set(edges)))"
```

⚠ **Nothing nests.** So: insert all products with their material lines, then a **second automated pass** wires the product-as-component lines. Same script, no human. A dependency sort handles nesting if a future client has it; Mava does not need one.

### The Mava data — measured S140, archive `abletrace`, company 184

⚠ **164 is an empty shell despite being named `Mava Foods`. 184 is the operating company despite being named `mavatrial2`.** Confirmed across five tables.

```
materials      310      companyagents (suppliers)   25
formulations   171      companycustomers            13
recipe lines  1055      shipping addresses          13
dispatch orders 93      MOs                        131   last activity Jan 2025
```

**Schema:**
```
fosubrecipe            createdAt, updatedAt, id, formulation_id
subrecipematerials     createdAt, updatedAt, id, qty, sub_recipe_id, material_id
subrecipeformulation   createdAt, updatedAt, id, qty, ship_qty, sub_recipe_id, formulation_id
companyagents          ... company_name, address, contact_person, email, contact_number, is_agent ...
customershippingadresses  ... shipping_contact_person, shipping_contact_person_no,
                             email_address, shipment_address, billing_adrress, customer_id
unitmeasurement        createdAt, updatedAt, id, company_id, unit_name
```

⚠ **There is no supplier or vendor table.** Suppliers are `companyagents`. Every name search for `%uppl%` and `%endor%` returned nothing.

⚠ **`unitmeasurement` is per-company.** A new company needs its own unit rows created **before** any material can reference one. Raw `uom` values are ids, not text.

**Every one of the 170 recipes has exactly one stage.** Only one `Sub_Recipe` column pair is ever needed for Mava.
```
awk -F'\t' 'NR>1 {print $2"|"$5}' 6-recipes.tsv | sort -u | cut -d'|' -f1 | uniq -c | awk '{print $1}' | sort -n | uniq -c
→ 170 recipes, all with 1 stage
```

**Product UOM spread:** 135 Kg · 20 Ea · 10 Ltr · 6 Box.

⚠ **`ship_qty` is blank or 0 on all 25 sub-recipe lines.** Never populated in that version.

**Status:** materials 307 Active / 3 Inactive. Products 135 Active / **36 Inactive**. Suppliers 25 Active. Customers 13 Active. ⚠ **Inactive products are referenced by live recipes — they cannot simply be skipped.**

⚠ **All 13 billing and shipping addresses are identical.** The one-to-many capability was never exercised in this data.

### Batch quantity — settled S140, do not relitigate

⚠ **Minty's ruling: batch quantity goes across as a blind input and the client edits it.** Easily changed in the app.

**Rule 7 does NOT apply here.** ⚠ **Minty's ruling S140: rule 7 governs figures the running app computes, not seed data being loaded in.** Claude misapplied it and was corrected. **Do not over-apply it in the importer either.**

Batch quantity moved from Kg to units. 135 of 171 products carry a Kg batch. **Carry the stored figure across and flag it for correction. Do not attempt a weight-to-units conversion.**

### ⚠ The company must be created through the app, not by SQL

The app's creation path copies every `role_task` into `company_user_task`; SQL runs no application code. **A company or role created by SQL grants nothing.**

### The deliverable that already exists

`Mava-Foods-master-data.xlsx` — 8 tabs, handed over and checked on screen S140. README, Materials, Suppliers, Material-Suppliers, Customers (shipping merged, one row per address, `ship_no` numbering them), Products, Recipes (`s_no` 1–170 keyed on `recipe_code`), Products-No-Recipe.

⚠ **`s_no` is keyed on the CODE, never the name. Six different products are called "Slow Roast."**
```
mysql -N -B -e "SELECT COUNT(DISTINCT title), COUNT(DISTINCT internalCode), COUNT(*) FROM abletrace.formulations WHERE company_id=184;"
→ 139  171  171
```

### Verify — S147 is done when

1. The five measurements are answered **in writing**.
2. A dummy company exists, created through the UI.
3. Mava's workbook loads into it with **no manual amendment step**.
4. Recipe quantities are checked against the workbook **row by row on a sample** — the old failure misassigned rather than failed, so a clean run proves nothing on its own.
5. Proven **on the screen**. ⚠ **Loaded is not proven.**

---

## ⚠ QUICKBOOKS — BOTH OPTIONS, PLACED. SETTLED S146

**Nothing is lost or at risk on either path. Both need the same live connection, so P267 serves both and is the true bottleneck — and it waits on a lawyer, not on us.**

**Option 1 — packing slip out, invoice number back.** Storage **fully in place** as of S146. Code written and proven on sandbox. What remains: P267's five gaps, the QuickBooks screen never opened on prod, P268 (the tile's visibility gate), and the OAuth connect flow never run against prod.

**Option 2 — AbleTrace issues the invoice, the number goes to QuickBooks.** Columns can hold it — `qb_invoice_no` stores a number whatever produced it. ⚠ **But AbleTrace does not generate invoice numbers at all today.** No scheme, no sequence, no column. That is P279 and it is business logic, not schema.

⚠ **Minty's ruling S146: he may end up needing BOTH, depending on client need.** QuickBooks stays the accounting software for all clients either way; the linkage is required on both paths. **Clients may key the invoice number across manually in the interim — that needs nothing from anyone.**

**The sequence holds whichever way it goes: connection first, then decide who owns the number.**

⚠ **The 15 columns cost nothing if P279 wins. They drop in one statement.**

---

## ⚠ TERMS AND PRIVACY — MEASURED S146, JOB NOW SHAPED

**Both documents are STANDALONE FILES, not hard-coded in a component.**
```
src/assets/docs/terms.html
src/assets/docs/privacy.html
```
Component at `src/app/login/terms/`. Backend holds **no** copy — `assets/` has no PDF and nothing named terms or privacy. The backend does one thing: record acceptance.

⚠ **TWO acceptance routes, and both must point at the same documents:**
```
POST /api/v1/user/updatetermsandcondition            → UsersController
POST /api/v1/companyemployee/updatetermsandcondition → CompanyEmployeeController
```

**So the job, once the lawyer returns both: replace two files, build, deploy, verify on screen.** No code change.

⚠ **They are HTML, not PDF.** That also gives Intuit the public URL it needs — `app.abletrace.ca/assets/docs/privacy.html` — with nothing hosted separately. ⚠ **A Word file from the lawyer must be converted; that is the fiddly part.**

⚠ **Nothing records WHICH VERSION was accepted.** These are about to change, so an acceptance before and one after are indistinguishable. → **P278**. **Open business question: does the version stamp matter to Minty?**

**Still outstanding:** the three build-side questions — which screens link to those two files, whether Angular renames assets at build, and the prod build-and-deploy path. → **P278**

**Minty's rulings S145 on the policy content stand unchanged:** collected · purpose · third parties (AWS, SES, Zoho, Intuit — ⚠ check whether any client data sits in Google Drive) · location **Canada `ca-central-1`** · retention · **deletion on request** · breach to clients **and the Privacy Commissioner where required** · **privacy officer is Minty**, `info@abletrace.ca`.

⚠ **Deactivation does NOT delete anything** — proven S145. Any wording saying otherwise would be untrue about our own system.

⚠ **Neither legal document currently names AbleTrace.** That alone would fail review.

---

## ⚠ TWO LIVE CLIENTS SEE "Your licence has expired."

Seen S145 on Shelly (Hagensborg) and Javier (Designer Cookies). ⚠ **Status 4 Expired still permits login — only 6 Inactive blocks it.** Works as designed, but it is the first thing both clients read.

**Business question, still unanswered and now two sessions old:** the WhatsApp pointing clients at `app.abletrace.ca` went out S145. **That banner is what greets them at the new address.**

---

## ⚠ THE OLD ACCOUNT IS UNBLOCKED

**Nothing you own points at CloudFront any more.**

⚠ **Nothing has been deleted. ONE ITEM AT A TIME.** Claude shows what points at each resource, Minty says go, then it goes. Never a batch — the S138 subdomain takeover happened exactly this way.

⚠ **`prodapi.abletrace.ca` A → `3.98.223.126`**, the old account's Elastic IP. **The DNS record goes first, never the IP first.**

**Goes safely — nothing points at these:** `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (**never used**). ~$2/month.

**Stays permanently:** SES `ca-central-1` (only working email path; the new account was **denied**) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1` — the only copy of client documents** · root + MFA.

**Goes now the cutover has proven out** — ~$58/month: instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record.

**Needs a question answered first:** `s3_cloudfront` key `AKIAVDGLJ3MUH7IPS3W7`, last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at this. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** — $25.76/month: the 6 manual RDS snapshots.

⚠ **Three spent `_acme-challenge` TXT records** remain in the zone. Harmless, delete when convenient.

---

## ⚠ THE ARCHIVE SCHEMA — RICHER THAN PREVIOUSLY RECORDED

Schema **`abletrace`** on the **prod** RDS instance, new account. **Backed up with prod. Does NOT depend on the old AWS account.**

**Client procedures survive with their full text.** `documents.editorContent` holds the written procedure, 500–4,500 characters each. `documents` and `docDriveLink` are NULL on the text-bearing rows — **no file dependency.**

| id | company | licence | docs with text | evidence |
|---|---|---|---|---|
| 366 | Truffle | 6 Inactive | **0** | Oct 2025, 21 docs all empty. First attempt |
| **378** | **Truffle Pig** | 6 Inactive | **36** | ⚠ all v1, **all created in one second** 2026-04-24. A template suite loaded, not authored |
| 418 | Truffle | 6 Inactive | 0 | empty shell |
| **419** | **hagensborg** | 6 Inactive | **24** | ⚠ **authored 27–28 Mar 2026, six revised to v2 minutes apart.** The record that was worked in |

⚠ **A version 2 is a NEW ROW, not an edit.**

⚠ **`haccpplan` has NO `company_id`** — joins through `hazards.hazardId`. 210 rows spanning 2020–2026. **Only 366 has a HACCP plan.**

**Extracted S145:** `hagensborg-procedures.txt`, 18 procedures, 23,884 bytes, on the Mac. ⚠ 'Process flowchart' excluded — 294,872 characters because it is a base64 image.

---

## ⚠ THE RDS SNAPSHOTS — SETTLED, DO NOT RELITIGATE

**They can go, but not yet.** Master data for all four old clients is in schema `abletrace` on the new account's prod RDS, backed up with it — and the procedure TEXT is there too.

| id | company | materials | recipes | suppliers | customers |
|---|---|---|---|---|---|
| **184** | **mavatrial2** | **310** | **171** | **25** | **13** |
| **213** | **Kans Gourmet Foods Trial** | **79** | **101** | **25** | **21** |
| 366/378/418 | Truffle / Truffle Pig | 43/26/28 | 14/14/19 | 9 | 172–175 |
| **419** | **hagensborg** | **34** | **84** | **10** | **175** |

⚠ **`abletrace-fileuploads1` holds PDFs and JPEGs whose filenames name no company.** The bucket and the snapshots are not copies of each other.

⚠ **A snapshot cannot be inspected without restoring it**, which restarts the extended-support meter. Read identifiers and dates — never restore to look.

---

## THE DESTINATION — MINTY'S RULING S143, UNCHANGED

| name | what it serves |
|---|---|
| **`abletrace.ca`** / `www.` | the **marketing site** |
| **`app.abletrace.ca`** | **the application**. One login, one session |

**Everything else is a MODULE inside the app, never a new subdomain.** ⚠ **One database, one backend, one front door.** ⚠ **Modules are database rows created THROUGH THE UI, never by SQL.**

---

## THEN

**Certificate renewal, before 27 November.** All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **Now DNS points at this box, re-issue them the ordinary webroot way and renewal becomes automatic.** Cheap, and it removes a hard deadline.

**Dev's `DATABASE_URL` password was printed to screen S143 and must be rotated.** Dev only; prod untouched; the RDS instance is not publicly reachable. → **P272**. ⚠ **Method is 3B.8 — read it first.**

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P262 | **S147. Client onboarding importer — complete rebuild.** Mava is the pilot. **Full spec above — do NOT reopen S140 or S146 to recover it** |
| P281 | **Stale `mintekfoodsafety.com` fallbacks in the backend config.** `config/env/production.js` lines **24, 151, 250** and `config/env/development.js` line **7** read `process.env.APP_BASE_URL \|\| 'https://...mintekfoodsafety.com'`. Plus a stale comment at `QuickbooksController.js:97`. ⚠ **Nothing is broken** — prod's `.env` supplies the right value and wins. ⚠ **But if that variable ever goes missing, prod silently reverts to the old domain and nobody would notice.** ⚠ **`development.js` stays — dev is not moving** |
| P279 | **Invoicing inside AbleTrace.** Minty's design S145: **default price on the product master, editable per invoice line**; **default tax treatment per product, overridable per line**, plus a manual option. ⚠ **Store the values USED on the invoice — never re-derive from the master later.** ⚠ **Tax must be per line** — basic groceries are zero-rated, prepared foods are not, one order can carry both. QuickBooks transfer becomes **optional and manual**. **Added S146, design questions to answer before any code:** invoice **numbering scheme** (per-company or global, gapless, never reused, who allocates and when) · where the **editable price field** sits on the product formulation page and who may edit it · **invoice layout** and what a Canadian food invoice must legally carry · **its own tile ("Generate AbleTrace Invoice") or inside the packing slip flow** — a tile means database role rows, not frontend code · **what happens if the push fails after a number is allocated.** ⚠ **Minty's ruling S146: price is CURRENT only — no versioning, no history. The invoice COPIES the price onto itself at issue and never reads back to the product.** Past invoices then cannot change. Clients wanting their own record get a downloadable Excel |
| P278 | **Terms and privacy policy inside the app, with versioned acceptance.** ⚠ **Measured S146 — the files are `src/assets/docs/terms.html` and `privacy.html`, so replacing them is a FILE SWAP, no code change.** Two acceptance routes, users and company employees, both must point at the same documents. Record **who accepted, when, and WHICH VERSION**; on a change, ask again. ⚠ Acceptance rows are never edited or deleted. ⚠ **`company.terms_condition` is a yes/no flag with no version and no timestamp — replace it, don't extend it.** Still to measure: which screens link to the two files, whether Angular renames assets at build, the prod build path. ⚠ **Blocked on the lawyer returning both documents — expected within the week** |
| P277 | **Client data deletion routine.** Deletion on request is a published commitment with no tooling. ⚠ Manual today: many related tables in FK order, **plus the `abletrace-fileuploads1` bucket whose filenames name no company** |
| P276 | **Naming audit across all environments.** ⚠ Both RDS instances hold a schema called `abletracelab_live` and one called `abletrace-dev`; `SHOW DATABASES` is identical on both boxes. Audit instances, schemas, EC2s, PM2 processes, buckets, IAM users, repos |
| P280 | **Split the marketing site out of the Angular app.** Today a visitor downloads the whole application to read three paragraphs, and every marketing tweak needs a full rebuild. ⚠ **No harder later than now.** Assets on the box: `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images. ⚠ **Copy to `/var/www/marketing`, never reference them from `/var/www/html`** — every deploy wipes that whole. ⚠ `/var/www/` is root-owned |
| P272 | **Rotate dev's DATABASE_URL password.** ⚠ **Method 3B.8, read it first** |
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
| P256 | **Dead build folders and spent scripts.** Dev home ~50 folders back to S63. ⚠ Keep the live rollback and one prior. Also: `.env.bak-s139` both boxes · prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/`, `patch-nginx-abletrace-s143.py`, `patch-nginx-app-s144.py`, `extract-hagensborg-procedures.py`, `dist-prod-2a576cb8….zip`, `/tmp/*-tables.txt`, `hagensborg-procedures.txt` · Mac `environment.prod.ts.bak-s144`, `/etc/hosts.bak-s144` · **added S146: `apply-qb-schema-s146.sh` on prod (spent), `dump-columns-s146.sh` and `dump-objects-s146.sh` on BOTH boxes (superseded by the `operations/` copies), `/tmp/columns-*.txt` and `/tmp/objects-*.txt` on both** |
| P257 | **Automated bounce and complaint handling.** ⚠ Required for any SES re-application |
| P258 | **Test companies that exist and cannot be deleted.** `testses260825a` dev · `testsesprod260825` prod · ⚠ **`test260831` on PROD, added S146 — that is a THIRD.** Set Inactive through the app, not by SQL |
| P259 | **One IAM key serves both boxes.** Separate eventually. Dev first, prove a send |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` · `abletracelab-ses-smtp-s35` |
| P264 | **No automated tests anywhere.** ⚠ Never run the S141 attack test against prod |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`.** ⚠ Confirmed S146: the tile does NOT appear for a company created without the role rows. **Half its homework is done** — this is the standby job if S147 is blocked |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224`. ⚠ `Materials.js:380` and `:790` use `myCode` and were never checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

---

## TRAPS CARRIED FORWARD — all look like broken code

### ⚠ NEW, S146 — THE PASTE PROBLEM TURNED DESTRUCTIVE

⚠ **A pasted fragment containing `>` SILENTLY EMPTIES the file it names.** S146: a stray tail of terminal output ending in `> /tmp/prod-columns.txt` ran on its own and truncated the file to zero. `wc -l` then read 0 and the query was suspected instead. **So far only a temp file. The same fragment could name anything.**

⚠ **Copy ONLY from the grey fenced box in the chat. Never from the terminal window.** S146 lost five exchanges to output being pasted back — the clipboard held the terminal selection, not the fence, every time. **Ctrl+U, paste, Enter, one block.**

⚠ **A filename label proves NOTHING about which box produced the file.** `dump-columns.sh dev` run while sitting on prod produced `columns-dev.txt` holding prod's schema, with an identical line count that read as agreement. **Both operations scripts now print `hostname -s` first — read it before trusting the file.**

⚠ **Counts matching is not contents matching.** Two routines can share a name and differ inside. Compare **body text**, which `dump-objects.sh` does.

⚠ **`Trace_MaterialDetails_SP` differs between the boxes by FIVE COMMENTS only** — prod has them, dev does not. Every statement is character-identical. ⚠ **Minty's ruling S146: leave it. Comments do not execute.** Do not "fix" this on a live database.

### Standing

⚠ **A GitHub run can COMPILE and still fail.** The upload step is separate. **Read which step went red before touching the code.** → **to TRAPS**

⚠ **`dig` ignores `/etc/hosts` entirely.** Use `dscacheutil -q host -a name <n>`. → **to TRAPS**

⚠ **Chrome serves the OLD site from cache after a DNS change.** **Prove the server with curl, then use a fresh incognito window** — a hard refresh was not enough.

⚠ **A blank page with the correct tab title means the JavaScript threw**, not that the server failed.

⚠ **The deploy script prints a rollback line to the build it just replaced.** **Read the path off the box.**

⚠ **Check `index.html` is at the top level of an unzipped artifact** before deploying — the script copies `$SRC/*`.

⚠ **`curl -I ... 2>&1 | head -1` returns the PROGRESS METER.** Use `curl -s -I`.

⚠ **Column names are not guessable.** `documenttype.name` not `title`; `company.company_name` not `name`. **`SHOW COLUMNS` first.**

⚠ **`haccpplan` has no `company_id`.** Join through `hazards`.

⚠ **A local `dig` can return EMPTY while Route 53 already holds the new value.** Ask the authoritative server: `dig +short TXT <n> @ns-1320.awsdns-37.org`.

⚠ **Route 53 truncates record names in the list.** **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** **Read the account number before the measurement.**

⚠ **`isAuth` rewrites `req.body.company_id` on every authenticated request.** Sending a different one has no effect and is not a bug.

⚠ **A URL or query carrying another company returns 403 "Company mismatch".** That is P250 working.

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session.

⚠ **A master role row created by SQL grants nothing.** Companies, roles and tasks on prod must be created through the UI.

⚠ **`mysql abletracelab_live` — name the DB explicitly.** A bare `mysql` on prod lands in the archive `abletrace`.

⚠ **`formulation_id` means PARENT in `fosubrecipe`, CHILD in `subrecipeformulation`.**

⚠ **`unitmeasurement` is per-company.** A `uom` value is an id and means different things to different companies.

⚠ **Product titles are not unique.** 171 products, 139 distinct titles. **Match on `internalCode`.**

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

⚠ **`shipped_flag` is the ship gate, not `status_id`.**

⚠ **Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. **Only Inactive blocks login. Expired keeps access and shows a banner.**

⚠ **`SELECT ... INTO OUTFILE` does not work on RDS.** Use `mysql -B`.

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it.

⚠ **The backend falls back to `mintekfoodsafety.com` if `APP_BASE_URL` is missing.** **A wrong default that looks like it works.** → P281

⚠ **`pm2 restart` prints "Use --update-env"** — that is PM2's own env. `dotenv` reads the file at boot. **A restart IS needed after editing `.env`.**

⚠ **Sails reads the SCHEMA per query.** A column added to the database needs no restart — only a browser reload. **Confirmed again S146.**

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path and it starts an extended-support meter.

⚠ **`sudo` changes HOME.** nginx backups land in `/root/`.

⚠ **nginx `grep -r` silently skips symlinks.** Use `nginx -T`.

⚠ **A server block loads exactly one certificate.** Prod has three 443 blocks.

⚠ **The backend log's boot warnings are NOT faults.** Four `Action middleware ... doesn't match any registered actions` lines print at every boot, and a `company.updatedAt` null warning is old data. **Neither is evidence of anything current.**

**QuickBooks Canada refuses any transaction with no tax code on a line**, and any line with no Amount. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.**

**The QuickBooks access token expires in hours.** Load the QuickBooks page in Chrome first — that page refreshes and writes back.

⚠ **`quickbooks_tokens.uq_company` is UNIQUE on `company`** — one connection per company. A second connection overwrites the first rather than sitting alongside it. **A design decision baked into a key.**

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, **lower case**.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

**`formulations` has no `name` column — it is `title`.**
