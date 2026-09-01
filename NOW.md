# NOW

Written at the close of **S148**. The launchpad for **S149**.

---

## ⚠ HOW S149 OPENS

**Minty's instruction, S148:** *"no exploring when you are fresh — we need to do all homework before starting afresh."*

Every discovery S149 needs is written out below, in full, measured on 1 September 2026. **Nothing needs recovering from a past chat and nothing needs re-measuring.**

1. Read THE MATERIAL and restate it back.
2. Say what — if anything — is missing, and ask Minty. He answers faster than a measurement.
3. Start writing code.

⚠ **The filled workbook already exists.** `AbleTrace-Client-Onboarding-test260901.xlsx`, on Minty's Mac. It is the file that gets uploaded. It is not built in S149.

---

## STATE

**Deliberate, done — S148:**

- **The queue-length rule is in `RULES.md`**, §5 under Queue, and pushed. Commit `a2c64d5`, header bumped to S148.
- **The queue is trimmed** to obey it — one line for unstarted items, a paragraph only where homework exists.
- **The onboarding template is built and filled** with dummy data for company 479.

**Half-done:** nothing.

**Awaiting a ruling:** three retirements proposed at the bottom of the queue. Not deleted without Minty's word.

**Standing:** the domain cutover is complete and proven. Dev remains on `dev.mintekfoodsafety.com`, returns 200, Certbot-managed and auto-renewing. `quickbooks_tokens` is empty and stays empty until someone clicks Connect.

---

# THE JOB — S149: UPLOAD THE EXCEL DATA

**Load `AbleTrace-Client-Onboarding-test260901.xlsx` into company 479 on dev, through the app, and prove it on screen.**

⚠ **Dev only. Prod is not in this session.**

That single sentence is the deliverable. The importer rewrite and the upload screen are means to it, not separate goals.

---

## THE MATERIAL — everything measured, S148

### The target

| | |
|---|---|
| company | **479**, `company_name` = `test260901@mailinator.com` |
| its admin | user **1335** |
| super admin | user **1**, `info.abletrace@gmail.com`, exempt from the P250 company_id rewrite |
| dev address | `https://dev.mintekfoodsafety.com` — returns 200 |
| dev schema | **`abletracelab_live`** — derived from dev's own `.env`. ⚠ Prod uses the same name |

**479 is empty and is a clean target:** 0 agents, 0 materials, 0 products, 0 customers.

**479 already has, seeded at company creation:** 8 units, ids **2990 Kg · 2991 Lb · 2992 Ltr · 2993 Bag · 2994 Box · 2995 Bottle · 2996 Pallet · 2997 Ea**, and 11 allergens. ⚠ **Nobody sets these up. Every company on the box has the identical eight.**

### The upload path, traced end to end

> **button → posts the raw file + a `sheetName` → `POST /api/v1/Sheet/importSheet` (`routes.js:37`) → `ImportExcelSheetController.importSheet` (17 lines, pass-through) → `api/services/importSheet.js` → the model methods → database**

⚠ **The browser never reads the sheet.** Every frontend grep for `XLSX.read`, `sheet_to_json` and `FileReader` returned only exports.

### `importSheet.js` — read in full, S148, 32 lines

It opens the workbook, finds the tab named in `sheetName`, converts it, hands the rows back. That is all it does. **It is not a parser.** The logic lives in the models.

Five faults in it:

- ⚠ **`sheet_to_json` with no options DROPS EMPTY CELLS.** No key at all, not an empty string. Levels 2–4 on Product-Packaging are mostly blank. **`defval: ''` is not optional.**
- ⚠ **A wrong tab name crashes silently.** `sheetIndex` stays undefined, the code asks for `Sheets[undefined]`, and you get a 500 with no message about what was wrong.
- ⚠ **One tab per call.** `sheetName` is hardcoded per screen — `'Materials'` at `manage-materials.component.ts:311`, `'Products'` at `admin-formulation.component.ts:162`. **This is why the same file is uploaded four times today.** Minty's ruling S148: **one upload, all eleven tabs, one request.**
- ⚠ **Every uploaded workbook is kept forever** in Sails' temp uploads folder. A client's full master data in a folder nobody looks at. → P277
- If no file is attached it throws on `filesUploaded[0].fd`. `file_name` is read on line 4 and never used.

### The create paths to mirror — NOT the `import*` ones

| what | call this | line |
|---|---|---|
| supplier | `CompanyAgents.addcompanyagentmanufactrer` | `api/models/CompanyAgents.js:112` |
| material | `Materials.createMaterials` | `api/models/Materials.js:374` |
| product | `Formulations.createFormulas` → `methodForCreateFormula` | `api/models/Formulations.js:819` → `:867` |
| customer | `CompanyCustomers.createCustomer` | `api/models/CompanyCustomers.js:223` |

⚠ **The four `import*` methods are the broken originals.** `Materials.importMaterials:249` compares every row against every row below it, double-pushes into `duplicateInExcel`, hand-codes the last row, and takes `company_id` **off the row** rather than the session — so it does not respect P250. Old file stays in git. Minty's ruling S147: **rewrite, do not extend.**

### ⚠ `methodForCreateFormula` ALREADY HAS AN IMPORT MODE

`Formulations.js` near line 930:

```
if (req.import != undefined) { return findFormula } else { cb(null, findFormula) }
```

**Call it with `req.import` set and it returns instead of responding.** Sub-recipes, recipe lines, packaging and code generation all come for free, identical to the screen's behaviour. **This is the single biggest shortcut in the job.**

What that function does, measured at `Formulations.js:895–935`:

- builds `materialArray` and `formulationArray`, then `SubrecipeMaterials.createEach` and `Subrecipeformulation.createEach`
- `formulationArray` takes **`qty` and `ship_qty` straight from the request** — both are supplied by the caller, neither is computed
- `sub_recipe_id` comes from sub-recipes created just above
- reads packaging from **`req.body.Refer_packaging`**, and **formats the level itself**: send integer `1`, it stores `Level 1 Pack`
- ⚠ **`whd_flag` is commented out in that block.** The caller must set it.
- gets its own internal code at `:879` via `Formulations.beforeNewCreation`

### ⚠ THE INTERNAL CODE TRAP — the one that will bite

All three generators **count existing rows and add one**, and each is called **once per record inside the loop**:

| | | |
|---|---|---|
| `Materials.beforeNewCreation` | `Materials.js:231` | `count()` + 1 → `MAT-N` |
| `Formulations.beforeNewCreation` | `Formulations.js:85` | finds all, splits on `-`, sorts, max + 1 → `FO-0001` padded to 4 |
| `CompanyCustomers.beforeNewCreation` | `CompanyCustomers.js:57` | `count()` + 1 → `CUST-0001` padded to 4 |

⚠ **Each record must be created and awaited before the next code is generated.** Build an array and `createEach` it at the end and **every row in the import gets the same internal code**. Silent. Nothing complains. It surfaces months later when someone searches by code.

⚠ `Formulations.beforeNewCreation` splits `internalCode` on `-` with no guard. A null or malformed code throws.

### The quantity rules — the heart of the job

⚠ **`ship_qty` is what the client TYPES. `qty` is DERIVED from it.** Minty's explanation, S148:

> **units in, weight derived. Never the reverse.**

```
subrecipeformulation.ship_qty = the units on the sheet
subrecipeformulation.qty      = ship_qty x the intermediate's Level 1 weight (Kg)
```

Verified four times against live rows:

| parent | child | ship_qty | child's L1 weight | qty |
|---|---|---|---|---|
| Baked Chicken | Seasoning Mix | 0.125 | 8 | 1 |
| BBQ Sauce | Seasoning Mix | 0.125 | 8 | 1 |
| Baked Chicken w BBQ Sauce | Baked Chicken | 10 | 0.4 | 4 |
| Baked Chicken w BBQ Sauce | BBQ Sauce | 10 | 0.1 | 1 |

⚠ **This is RULES §7's one and only exception**, and the reason for it is Minty's, S148: the count subtracted from `inventory_units` must be the count someone typed. Derive the count from a weight and every miscellaneous release leaves a fractional tail that can never be zeroed.

⚠ **Packaging must be written before recipe lines**, or the Level 1 weight is not there to multiply by.

### Packaging, measured

- `fopackaging.pack_level` is **text**: `Level 1 Pack` … `Level 5 Pack`. The model formats an integer for you.
- ⚠ **`whd_flag = 1` marks the shipping level, and it is stored, not inferred.** One level → flagged on 1. Two → on 2. Three → on 3. Measured across 20 rows.
- ⚠ **`wgt_kgs_per_unit` is CUMULATIVE.** Level 1 carries the unit weight; each level above is its ratio × the weight below. Product 3705: `0.41 → 5 × 0.41 = 2.05 → 13 × 2.05 = 26.65`. **The sheet carries the ratio and the Level 1 weight only. The importer multiplies.**
- `fopackaging.material_id` is **NOT NULL** — every level needs a packaging material that exists with Type = Packaging.
- `fopackaging` level-1 rows for Mava: **zero**. Batch quantity stays a blind input. Minty's S140 ruling holds.

### Recipes

- Lines hang off a **`fosubrecipe`** row, which hangs off the product. `fosubrecipe` has **four columns only** — `createdAt`, `updatedAt`, `id`, `formulation_id`. Nothing else.
- **113 of 114 products have exactly one sub-recipe; one has two.** The importer creates one per product. `Sub_Recipe` was dropped from the template for this reason.
- Materials go to `subrecipematerials` (`qty` in Kg), intermediates to `subrecipeformulation`.
- ⚠ **Never read `mlomanagement.batches`** — it is the same sum, already rounded and stored.

### Allergens

- Stored as a **JSON array of strings**: `["Milk","Soy"]`. Empty is `[]`. Same on `materials.allergen` and `formulations.allergen`, both `longtext`.
- `companyallergens` is the client's own list — 11 rows on 479, seeded.
- ⚠ **A product's allergens are never typed.** They roll up from the materials in its recipe. **The roll-up runs LAST and runs TWICE** where an intermediate is involved: materials → intermediate, then intermediate → finished product.
- Proven on screen S148: product FO-0008 shows `Allergen List: Eggs`, which nobody entered.

### The tables it writes

```
companyagents    company_name, address, contact_person, email, contact_number,
                 is_agent, company_id, user_id, status_id, updatedByUser, remarks
                 ⚠ NO code column of any kind -> P282

materials        company_id, user_id, internalCode, myCode, title, type_id,
                 ing_sub_type_name, statutory_flag/file_name/file_path,
                 food_contact_flag, allergen, remarks, status_id, storage_temp,
                 uom, inventory, SOH_actual, updatedByUser

materialsagents  iss, iss_expiry_date, is_agent, material_id, agent_id

formulations     company_id, user_id, internalCode, myCode, title, uom, batch_qty,
                 product_type, storage_temp, shelf_life, remarks, ops_instructions,
                 version, version_date, approved_by, status_id, allergen,
                 inventory, SOH_actual, updatedBy, inventory_units

fopackaging      quantity, wgt_kgs_per_unit, formulation_id, material_id,
                 whd_flag, pack_level

fosubrecipe      formulation_id

subrecipematerials    qty, sub_recipe_id, material_id
subrecipeformulation  qty, ship_qty, sub_recipe_id, formulation_id

companycustomers      company_id (double), user_id (double), customer_no,
                      customer_name, contact_person, contact_person_no (double),
                      email, other_emails, address, next_review_date, remarks,
                      status, annual_review_status, updatedByUser, external_id

customershippingadresses  shipping_contact_person, shipping_contact_person_no (double),
                          email_address, shipment_address, billing_adrress, customer_id
```

⚠ **`status_id = 1`** on materials, agents and formulations — measured, it is what every existing row uses.
⚠ **`unittype` is GLOBAL, no company_id.** `1 Ingredient · 2 Packaging · 3 Non-Food Chemical`. Same for every client.
⚠ **`producttype` is per-company free text and has ZERO rows for every company.** Optional, nothing reads it. Create on the fly or leave null.
⚠ **`customershippingadresses` has no `company_id`** — scoped only through `customer_id`. Billing column is spelled **`billing_adrress`**.
⚠ **Phone numbers are typed `double`.** A dash, a leading zero, brackets or an extension cannot be stored. → P285. **Strip to digits or write null; do not let the import fail on it.**
⚠ `CompanyCustomers.compareShipAdress` treats two addresses as duplicates if **ANY ONE** of contact person, number, address or email matches. An OR where an AND was meant.

### The workbook — eleven tabs, filled, on Minty's Mac

`AbleTrace-Client-Onboarding-test260901.xlsx`

| tab | one row per | notes |
|---|---|---|
| Instructions | — | |
| Agents | supplier | 4 rows |
| Materials | material | 11 rows, **`Opening_Stock`** → `materials.inventory` |
| Material-Suppliers | material-supplier pair | 11 rows |
| Material-Allergens | material-allergen pair | 2 rows — Yogurt→Milk, BBQ Sauce Bulk→Soy |
| Products | product | 2 rows, **`Opening_Stock_Units`** → `formulations.inventory_units` |
| Product-Packaging | **product** | 9 columns: L1 packaging + L1 weight, then packaging + units for levels 2–4 |
| Recipe-Lines | component | 4 columns: `Product_Name`, `Component_Name`, `Quantity_Kg`, `Intermediate_Units` |
| Customers | customer | 1 row |
| Customer-Addresses | address | 2 rows, same customer |
| Lists | — | reference only |

**The dummy data:**

```
Products      Seasoning Mix  Ea  40 units/batch  500 opening   Intermediate
              Baked Chicken  Ea  50 units/batch  1200 opening  Finished

Packaging     Seasoning Mix  L1 Internal Container 0.2 Kg
              Baked Chicken  L1 BC Tray 0.4 Kg,  L2 Case x10

Recipe        Seasoning Mix  <- Ginger Powder 7 Kg
              Seasoning Mix  <- Salt 1 Kg
              Baked Chicken  <- Raw Chicken 22 Kg
              Baked Chicken  <- Salt 0.125 Kg
              Baked Chicken  <- Seasoning Mix, 5 UNITS   <- THE ROW THAT MATTERS
```

⚠ **Minty's ruling S148: exactly one of `Quantity_Kg` and `Intermediate_Units` is filled per row.** Which column holds a value says whether the component is a material or a product. `Component_Type` and `Sub_Recipe` were both removed as redundant.

### The screen to build and the screens to copy

**Where it goes:** `src/app/Layouts/super-admin-dashboard/global-procedures/` — four files:

```
global-procedures.component.ts / .html
sync-client-dialog/sync-client-dialog.component.ts / .html
```

**Sync Client**, seen S147: a company picker searching by name or email, Company Name and Admin Email side by side, count on the button. ⚠ **Sync allows many companies. Onboarding must allow exactly ONE.**

**Create HACCP**, seen S147: **Download Template** beside **Import**, and a `confirm()` echoing the filename — *"Do you want to Upload HACCP_master.xlsx file?"* Then rows land in an **editable form** with constrained dropdowns and nothing saved until Next.

⚠ **The editable review screen is NOT promised for S149.** If it does not fit, use a plainer upload and it becomes its own job.

⚠ **Upload buttons already exist** on `admin-formulation`, `manage-materials`, `agents`, `manufacturers`, `customers` — 27 files carry `type="file"`. No new upload plumbing is needed, only the screen.

⚠ `admin-formulation.component.ts:70` has `url: 'http://localhost:1338/Sheet/importSheet'` hardcoded. → P283. Likely resolved by this rewrite.

---

## THE ANALYSIS — thinking already done

**The pass order.** Dependency-driven, and packaging must precede recipe lines so the Level 1 weight exists for the units→Kg conversion:

> agents → materials → material-suppliers → material-allergens → **products** → **product-packaging** → recipe lines (materials) → **recipe lines (intermediates)** → **allergen roll-up** → customers → customer-addresses

**All or nothing.** Validate every row of every tab first, write nothing until all pass. A rejection leaves the company exactly as it was, so recovery is "fix the sheet, upload again" rather than "delete the company".

**Refuse a non-empty company.** Minty's ruling S147. 479 is empty today; if a failed run leaves rows behind, delete the company and start over.

**Names, never ids.** Exact match, no fuzzy matching. *"Snowcap means snowcap."*

**Certificates deferred.** `iss` / `iss_expiry_date` are per material-supplier pair, but a certificate is a **file on S3**. Importing the date without the file is worse than blank. Done in the app afterwards.

**No Manufacturers tab.** *"Agent is good enough. We will take agent as a supplier, single point."* `is_agent` stays in the schema, untouched.

**Opening stock is the only balance the import writes**, and it can only ever run once. The non-empty refusal is what protects it.

---

## VERIFY — what must be seen on screen to call S149 done

1. Company 479 lists its **four suppliers**.
2. **Materials** list, 11 rows, correct Type — Ingredient vs Packaging.
3. **Baked Chicken** shows its packaging: Level 1 BC Tray at 0.4 Kg, Level 2 Case × 10.
4. ⚠ **Baked Chicken shows SEASONING MIX in its recipe** — the intermediate. The thing done by hand today and the reason this job exists.
5. **Baked Chicken's allergen list is not empty** — it must show what rolled up through Seasoning Mix.
6. **A Loving Spoonful** shows **two** shipping addresses, each on the right contact.

---

## PROOF — every fact above, with the command that produced it

| fact | measured by | returned |
|---|---|---|
| `importSheet.js` is 32 lines | `scp` from dev, read in full | opens workbook, one tab, returns rows |
| the route | `grep -n "Sheet/" config/routes.js` | line 37, one route only |
| the four create paths | `grep -n "^  *[a-zA-Z_]*: *async" api/models/*.js` | the line numbers quoted above |
| the import mode | `sed -n '895,935p' api/models/Formulations.js` | `if (req.import != undefined) return findFormula` |
| code generators count rows | `sed -n '231,249p' Materials.js` + `85,105p` Formulations + `57,81p` CompanyCustomers | `count()+1`, called per record at `:321`, `:417`, `:879`, `:187`, `:254` |
| packaging level formatting | same 895–935 block | `item.pack_level = \`Level ${item.pack_level} Pack\`` |
| `qty` / `ship_qty` pass through | same block | `qty: formula.qty, ship_qty: formula.ship_qty` |
| ship_qty is units, qty is Kg | join of `subrecipeformulation` to both formulations + Minty's explanation | four rows reconciled exactly |
| every column | `information_schema.COLUMNS` for 21 tables | `/tmp/s148-columns.txt`, 251 lines |
| 479 is empty | four scalar counts | 0 / 0 / 0 / 0 |
| 479's units | `SELECT id, unit_name FROM unitmeasurement WHERE company_id=479` | 8 rows, ids 2990–2997 |
| 479's admin | `SELECT id, email FROM user WHERE email LIKE 'test260901%'` | 1335 |
| status ids | `GROUP BY status_id` on three tables | 1 on all |
| allergen format | `SELECT allergen FROM materials/formulations` non-empty | `["Milk","Soy"]`, `[]` |
| pack_level values | `GROUP BY pack_level` | `Level 0` … `Level 5 Pack` |
| whd_flag marks the top | 20-row `fopackaging` ladder | flagged on the highest level present |
| cumulative weights | same ladder, product 3705 | 0.41 → 2.05 → 26.65 |
| one sub-recipe per product | `GROUP BY` count of `fosubrecipe` per formulation | 113 have 1, one has 2 |
| `fosubrecipe` is bare | `SELECT * FROM fosubrecipe LIMIT 5` | four columns |
| `producttype` empty | `GROUP BY company_id` | no rows at all |
| `unittype` global | `SELECT * FROM unittype` | 3 rows, no company_id |
| dev's schema | `.env` DATABASE_URL, tail after last slash | `abletracelab_live` |
| dev's address | nginx `server_name` on dev, then `curl` from the Mac | 200 |
| the screen's location | `grep -rln "Sync Client\|syncClient" src/app` | `Layouts/super-admin-dashboard/global-procedures/` |
| the roll-up is real | screenshot, S148 | FO-0008 shows `Allergen List: Eggs` |

⚠ **Four one-off scripts were used and are deleted at the tidy:** `s148-measure-columns.sh`, `s148-measure-shape.sh`, `s148-homework.sh`, `s148-last.sh` on dev; their output `/tmp/s148-columns.txt`, `s148-shape.txt`, `s148-homework.txt`, `s148-last.txt` on dev and in Mac Downloads. Also `RULES.md.bak-s148-20260901-131418` on the Mac.

---

## NOT MEASURED — and it is small

**Nothing blocking.** The editable review screen's implementation was read as a pattern only, not line by line, because it is not promised for S149.

---

# OTHER OPEN ITEMS — not part of the job

## ⚠ TWO LIVE CLIENTS SEE "Your licence has expired."

Shelly (Hagensborg) and Javier (Designer Cookies). Status 4 Expired still permits login — only 6 Inactive blocks it. Works as designed, but it is the first thing both clients read, and the WhatsApp pointing them at `app.abletrace.ca` went out S145.

⚠ **Business question, now four sessions old.**

## Certificate renewal, before 27 November

All three `abletrace.ca` certificates are `--manual` and will not auto-renew. ⚠ **DNS now points at this box, so re-issue them the ordinary webroot way and renewal becomes automatic.** Cheap, and it removes a hard deadline. Dev's certificate is Certbot-managed and renews itself.

## ⚠ THE OLD ACCOUNT IS UNBLOCKED

**Nothing you own points at CloudFront any more. Nothing has been deleted. ONE ITEM AT A TIME** — Claude shows what points at each resource, Minty says go. Never a batch; the S138 subdomain takeover happened exactly that way.

⚠ **`prodapi.abletrace.ca` A → `3.98.223.126`**, the old account's Elastic IP. **The DNS record goes first, never the IP first.**

**Goes safely, nothing points at these** (~$2/mo): `abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambdas · 1 API Gateway · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key.

**Goes now the cutover has proven out** (~$58/mo): instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record.

**Stays permanently:** SES `ca-central-1` (only working email path — the new account was denied) · IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ` · Route 53 zone `abletrace.ca` · **`abletrace-fileuploads1`, the only copy of client documents** · root + MFA.

**Needs a question answered first:** key `AKIAVDGLJ3MUH7IPS3W7` (`s3_cloudfront`), last used 2026-07-08, carries EC2+S3+SES+CloudFront+SSM+CodeDeploy full access. ⚠ **Ask what still points at it. Deactivate before deleting — deactivation is reversible.**

**After Minty is comfortable** ($25.76/mo): the 6 manual RDS snapshots.

---

## QUEUE

Minty ranks. Claude never renumbers. **Length is readiness** — a paragraph means the homework is done, a one-liner means it is not.

⚠ **Three retirements proposed S148, awaiting Minty's ruling: P266, P227, P8.** Marked below. Not deleted without his word.

| # | item |
|---|---|
| P262 | **S149. Upload the Excel data into company 479 on dev.** Deliverable, material, analysis, verify and proof are all in THE JOB above |
| P281 | **Stale `mintekfoodsafety.com` fallbacks.** `config/env/production.js` lines 24, 151, 250; stale comment `QuickbooksController.js:97`. ⚠ Nothing is broken — prod's `.env` wins. ⚠ **But if that variable ever goes missing, prod silently reverts to the old domain and nobody would notice.** ⚠ `development.js` line 7 stays — dev is not moving yet |
| P279 | **Invoicing inside AbleTrace.** Default price on the product master, editable per line. Tax per line, overridable — basics are zero-rated, prepared foods are not, one order can carry both. ⚠ **Store the values USED on the invoice; never re-derive from the master later.** ⚠ **S146 ruling: price is CURRENT only, no versioning, no history. The invoice copies the price at issue and never reads back.** Open before any code: numbering scheme (per-company or global, gapless, who allocates and when) · where the editable price field sits · invoice layout and what a Canadian food invoice must legally carry · own tile or inside the packing slip flow — a tile means database role rows, not frontend code · what happens if the push fails after a number is allocated. QuickBooks transfer becomes optional and manual |
| P278 | **Terms and privacy in-app with versioned acceptance.** ⚠ Files are `src/assets/docs/terms.html` and `privacy.html` — replacing them is a FILE SWAP, no code change. Two acceptance routes, users and company employees, both pointing at the same documents. Record **who accepted, when, and WHICH VERSION**; on a change, ask again. ⚠ Acceptance rows are never edited or deleted. ⚠ `company.terms_condition` is a yes/no flag with no version or timestamp — replace it, don't extend it. Unmeasured: which screens link the two files, whether Angular renames assets at build, the prod build path. ⚠ **Blocked on the lawyer returning both documents** |
| P277 | **Client data deletion routine.** Deletion on request is a published commitment with no tooling. ⚠ Manual today: many related tables in FK order, **plus the `abletrace-fileuploads1` bucket whose filenames name no company.** ⚠ **Added S148: every uploaded workbook is kept forever in Sails' temp uploads folder** — a client's full master data, in a folder nobody looks at |
| P276 | **Naming audit across all environments.** ⚠ Both RDS instances hold a schema called `abletracelab_live` and one called `abletrace-dev`; **dev's app runs on `abletracelab_live`, measured S148**. `SHOW DATABASES` is identical on both boxes. Audit instances, schemas, EC2s, PM2 processes, buckets, IAM users, repos |
| P280 | **Split the marketing site out of the Angular app.** Today a visitor downloads the whole application to read three paragraphs, and every marketing tweak needs a full rebuild. ⚠ **No harder later than now.** Assets on the box: `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images. ⚠ **Copy to `/var/www/marketing`, never reference them from `/var/www/html`** — every deploy wipes that whole. ⚠ `/var/www/` is root-owned |
| P272 | Rotate dev's `DATABASE_URL` password, printed to screen S143. Dev only. ⚠ Method 3B.8, read it first |
| P267 | **QuickBooks production approval.** ⚠ Off the critical path per P279, and waiting on a lawyer. Gaps: disconnect URL in Production Settings · `intuit_tid` capture · both legal documents naming AbleTrace · redirect becomes `https://app.abletrace.ca/api/quickbooks/callback` with `app.abletrace.ca` declared. ⚠ **Also never done: the OAuth connect flow has never run against prod, only sandbox** |
| P270 | Material certificate icon shows red "Certificate Unavailable" when a valid in-date certificate exists. Display fault only — the file downloads and opens |
| P274 | No local build path. `nvm` is not installed; the Mac is Node v24 against a project declaring `^20` |
| P275 | 192 npm vulnerabilities (6 critical, 79 high). ⚠ **Do NOT run `npm audit fix`** |
| P271 | `[object Object]` alert on SO-Management |
| P17 | Two old-account IAM keys still valid and in git history |
| P8 | ⚠ **RETIREMENT PROPOSED S148.** Prod git checkout lags the served build. Already stated in RULES' OPEN block; its stored commits are S144-stale |
| P210 | Prod to Node v18 → v24. Dev has run v24 cleanly for several sessions. ⚠ Dev keeps `node_modules.old-node18/` as the fallback — deliberate, untracked |
| P248 | OS updates. ⚠ Both boxes say "System restart required" on every login. Prod 59 pending / 12 security; dev 56 / 25 |
| P224 | Dev SSH IPv6 rule |
| P227 | ⚠ **RETIREMENT PROPOSED S148** — folded into P210 |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks Phase 2 — four failure-handling items remain. Schema is on prod too, S146 |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | App JWTs never expire. `api/policies/generateJWT.js`, no `expiresIn` |
| P249 | Typing any URL logs the user out. `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated |
| P252 | External ID duplicate guard, customers and products. ⚠ `editCustomer` has no duplicate check at all |
| P253 | No SSH host aliases. Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | A sales order cannot be edited once created. Business question |
| P256 | **Dead build folders and spent scripts.** Dev home ~50 folders back to S63. ⚠ Keep the live rollback and one prior. Also `.env.bak-s139` both boxes · prod `mava-export*.sh`, `mava-export-260826/`, `patch-nginx-*.py`, `extract-hagensborg-procedures.py`, `dist-prod-*.zip`, `/tmp/*-tables.txt` · Mac `environment.prod.ts.bak-s144`, `/etc/hosts.bak-s144` |
| P257 | Automated bounce and complaint handling. ⚠ Required for any SES re-application |
| P258 | Test companies that cannot be deleted: `testses260825a` dev · `testsesprod260825` prod · `test260831` prod. Set Inactive through the app, not by SQL |
| P259 | One IAM key serves both boxes. Dev first, prove a send |
| P260 | Old-account IAM users that should not exist: `Bobby1` · `abletracelab-ses-smtp-s35` |
| P264 | No automated tests anywhere. ⚠ Never run the S141 attack test against prod |
| P266 | ⚠ **RETIREMENT PROPOSED S148.** Eleven dead `Object.keys(req.body)` guards, always true since P250. Recorded as harmless |
| P268 | **QuickBooks tile visibility gate is not in `src/app/Layouts`.** ⚠ Confirmed S146: the tile does NOT appear for a company created without the role rows. **Half its homework is done** |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224`. ⚠ `Materials.js:380` and `:790` use `myCode` and were never checked |
| P282 | **External supplier code on `companyagents`.** ⚠ The table has **no code column of any kind** — products and customers have `External_ID`, suppliers do not. Needs: a column on **both boxes** · the Add Supplier form and the supplier list screen · a template column. ⚠ **Minty's ruling S147: not in P262. Names work as the join key.** Worth doing once POs are in regular use — a PO is raised per supplier and the client reconciles against their own purchasing system |
| P283 | `http://localhost:1338/Sheet/importSheet` hardcoded at `admin-formulation.component.ts:70`. A dead URL in production. Likely resolved by the P262 rewrite |
| P284 | **Dev to follow prod onto `abletrace.ca`.** Dev is `https://dev.mintekfoodsafety.com`, returns 200, Certbot-managed and auto-renewing. A move means reissuing that certificate. Blocks P286 |
| P285 | **Phone numbers are stored as `double`.** `companycustomers.contact_person_no` and `customershippingadresses.shipping_contact_person_no`. A number with a dash, a leading zero, brackets or an extension cannot be stored. Measured S148 |
| P286 | **Retire `mintekfoodsafety.com`, dev and prod.** ⚠ **Three dependencies must clear first, in order.** (1) **P284** — dev is served at `dev.mintekfoodsafety.com`; while that is true the domain cannot go. (2) **P281** — prod's config falls back to `mintekfoodsafety.com` URLs if `APP_BASE_URL` is ever missing. (3) **Prod still serves `trace.mintekfoodsafety.com`** from its own 443 block with its own certificate — clients may have it bookmarked. Then: the nginx blocks, the certificates, the DNS records, and finally the GoDaddy registration. ⚠ **Business question first: do any clients still reach the app on `trace.mintekfoodsafety.com`?** If so it needs a notice period and a redirect that stays up. ⚠ **Run the pointer before releasing the resource** — the S138 subdomain takeover happened exactly this way |

---

## TRAPS CARRIED FORWARD — all look like broken code

### ⚠ THE PASTE PROBLEM

⚠ **Copy ONLY from the grey fenced box in the chat. NEVER from the terminal window.** S146 lost five exchanges to this; S147 lost three more on the very first paste. **Ctrl+U, paste, Enter, one block.** When the clipboard will not cooperate, **type the line by hand**.

⚠ **A pasted fragment containing `>` SILENTLY EMPTIES the file it names.**

⚠ **A filename label proves NOTHING about which box produced the file.** **Read the `hostname -s` line the script prints.**

⚠ **Counts matching is not contents matching.**

### ⚠ NEW, S148

⚠ **A document pasted into the chat can be an OLD COPY.** S148 opened with a `RULES.md` reading "Last revised: S131" when the repo held S147 and 110 more lines. Writing a replacement from it would have deleted four rules silently. **Check the header and the byte count against the repo before rewriting any document.**

⚠ **A hidden row is still a row.** Excel row numbers jumping 2 → 4 means row 3 is hidden, not deleted, and any importer will read it.

⚠ **Reusing an example row leaves its marker behind.** Text ends up in a numeric column and nothing complains until the import.

⚠ **A code generator that counts rows breaks under bulk insert.** See THE INTERNAL CODE TRAP above.

⚠ **`sheet_to_json` omits empty cells entirely** — no key, not an empty string.

### Standing

⚠ **Two commands run back to back print two results, and it is easy to read the second as belonging to the first.** **One command per block when the output matters.**

⚠ **`M` not `A` in `git status` means the file was ALREADY TRACKED.**

⚠ **This file can be wrong about the close's own final steps.** **When NOW and the repo disagree, the repo wins.**

⚠ **Model methods can live in `api/services/`, not `api/models/`.** **Search `api/` whole.**

⚠ **A GitHub run can COMPILE and still fail.** The upload step is separate.

⚠ **`dig` ignores `/etc/hosts` entirely.** Use `dscacheutil -q host -a name <n>`.

⚠ **Chrome serves the OLD site from cache after a DNS change.** Prove the server with curl, then use a **fresh incognito window**.

⚠ **A blank page with the correct tab title means the JavaScript threw**, not that the server failed.

⚠ **The deploy script prints a rollback line to the build it just replaced.** **Read the path off the box.**

⚠ **Check `index.html` is at the top level of an unzipped artifact** before deploying.

⚠ **`curl -I ... 2>&1 | head -1` returns the PROGRESS METER.** Use `curl -s -I`.

⚠ **Column names are not guessable.** `documenttype.name` not `title`; `company.company_name` not `name`; `billing_adrress` not `billing_address`. **`SHOW COLUMNS` first.**

⚠ **`haccpplan` has no `company_id`.** Join through `hazards`.

⚠ **Route 53 truncates record names in the list.** **Read the Record details panel, never the row.**

⚠ **AWS phrases a wrong-account resource as an authorization error.** **Read the account number before the measurement.**

⚠ **zsh needs `--include="*.ts"` QUOTED.**
