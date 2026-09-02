# NOW

Written at the close of **S149**. The launchpad for **S150**.

---

## ⚠ HOW S150 OPENS

**Nothing to discover.** S149 read the workbook cell by cell and resolved every column mapping against dev's database. S148 handed over a specification with four unknowns in it. There are none now.

1. Read THE MATERIAL and restate it back.
2. Start writing `importSheet.js`.

⚠ **S150 writes backend code only. No screen, no button, no prod.**

⚠ **The workbook and the measurement scripts are already on dev** at `~/s149-work/`. The workbook stays there for S150 — do not re-transfer it.

⚠ **RULES.md is not in the Claude project panel.** S149 opened on a pasted copy reading *"Last revised: S131"* when the repo held S148. **Pull `RULES.md` from the repo and read the header before trusting any pasted copy.** This is the second session running that this has happened.

---

## STATE

**Deliberate, done — S149:**

- The whole workbook is read and verified. Every cross-tab join checked. No orphans.
- Every column mapping resolved against dev's database.
- Five design rulings taken from Minty. They are in THE ANALYSIS and they **supersede** what S148 wrote.
- `~/s149-work/` created on dev holding the workbook and four read-only measurement scripts.

**Half-done:** nothing. **No code was written in S149.**

**Standing:** domain cutover complete and proven. Dev remains on `dev.mintekfoodsafety.com`, returns 200, Certbot-managed and auto-renewing. `quickbooks_tokens` is empty and stays empty until someone clicks Connect.

**Open check, S149:** frontend `c2a52d8e`, backend `cf7722d`, both trees clean apart from the deliberate `node_modules.old-node18/`, `abletrace-dev` online, 200, Node v24.19.0.

---

# THE JOB — S150: WRITE THE IMPORTER

**Rewrite `importSheet.js` to load the whole workbook into company 479 on dev in one pass, post the file to it, and prove all six VERIFY items on screen.**

⚠ **Dev only. Prod is not in this session.**

⚠ **No upload screen.** The route already exists and a file can be posted to it directly. The button is **S151** and it is small, safe work once the importer is proven.

---

## THE MATERIAL

### The target

| | |
|---|---|
| company | **479**, `company_name` = `test260901@mailinator.com` |
| its admin | user **1335** |
| super admin | user **1**, `info.abletrace@gmail.com`, **exempt from the P250 company_id rewrite** |
| dev address | `https://dev.mintekfoodsafety.com` — returns 200 |
| dev schema | **`abletracelab_live`**. ⚠ Prod uses the same name |
| the workbook | `~/s149-work/AbleTrace-Client-Onboarding-test260901.xlsx` on dev, 17,464 bytes |

**479 is empty:** 0 agents, 0 materials, 0 products, 0 customers.

**479 already has, seeded at company creation:** 8 units, ids **2990 Kg · 2991 Lb · 2992 Ltr · 2993 Bag · 2994 Box · 2995 Bottle · 2996 Pallet · 2997 Ea**, and 11 allergens. ⚠ Every company on the box has the identical eight.

⚠ **The import must run as user 1.** P250's `isAuth.js` rewrites `req.body.company_id` from the session for everyone else, so any other identity writes into its own company instead of 479.

### The upload path

> **the raw file + `sheetName` → `POST /api/v1/Sheet/importSheet` (`routes.js:37`) → `ImportExcelSheetController.importSheet` (17 lines, pass-through) → `api/services/importSheet.js` → the model methods → database**

⚠ **The browser never reads the sheet.** Every frontend grep for `XLSX.read`, `sheet_to_json` and `FileReader` returned only exports.

### `importSheet.js` today — 32 lines, five faults

It opens the workbook, finds the tab named in `sheetName`, converts it, hands the rows back. **It is not a parser.** All five faults are fixed by the rewrite:

- ⚠ **`sheet_to_json` with no options DROPS EMPTY CELLS.** No key at all, not an empty string. **`defval: ''` is not optional.**
- ⚠ **A wrong tab name crashes silently.** `sheetIndex` stays undefined, the code asks for `Sheets[undefined]`, and you get a 500 with no message.
- ⚠ **One tab per call.** Hardcoded per screen — `'Materials'` at `manage-materials.component.ts:311`, `'Products'` at `admin-formulation.component.ts:162`. **Minty's ruling S148: one upload, all eleven tabs, one request.**
- ⚠ **Every uploaded workbook is kept forever** in Sails' temp uploads folder. → P277
- If no file is attached it throws on `filesUploaded[0].fd`. `file_name` is read on line 4 and never used.

### ⚠ THE HEADER IS ON ROW 2, NOT ROW 1

**Row 1 of every tab is a guidance sentence. Row 2 is the header. Data starts at row 3.**

⚠ **Assume row 1 and every column comes back undefined and every row fails validation with no visible reason.** Measured S149 on all eleven tabs.

### The tabs, with their exact headers — measured S149

A `*` is part of the literal header text and must be matched.

```
Instructions          (no data)

Agents                4 rows
  Supplier_Name*  Address  Contact_Person  Email  Contact_Number  Remarks

Materials             11 rows
  Material_Name*  Type*  UOM*  Opening_Stock  External_ID
  Storage_Temperature  Temperature_Unit  Food_Contact  Remarks

Material-Suppliers    11 rows
  Material_Name*  Supplier_Name*

Material-Allergens    2 rows
  Material_Name*  Allergen*

Products              2 rows
  Product_Name*  UOM*  Shipping_Units_Per_Batch*  Opening_Stock_Units
  Product_Type  External_ID  Storage_Temperature  Temperature_Unit
  Shelf_Life_Days  Ops_Instructions  Remarks

Product-Packaging     2 rows
  Product_Name*  Level_1_Packaging*  Level_1_Weight_Kg*
  Level_2_Packaging  Level_2_Units_Per_Pack
  Level_3_Packaging  Level_3_Units_Per_Pack
  Level_4_Packaging  Level_4_Units_Per_Pack

Recipe-Lines          5 rows
  Product_Name*  Component_Name*  Quantity_Kg  Intermediate_Units

Customers             1 row
  Customer_Name*  Customer_No  External_ID  Contact_Person
  Contact_Number  Email  Other_Emails  Address  Remarks

Customer-Addresses    2 rows
  Customer_Name*  Shipment_Address*  Shipping_Contact_Person
  Shipping_Contact_Number  Email_Address  Billing_Address

Lists                 reference only
```

⚠ **Material-Suppliers and Material-Allergens declare a range of A1:C but column C is empty on every row.** Formatting residue. Reading by header name never sees it.

⚠ **`Customer_No` comes OFF the sheet.** Minty's ruling S149 — the app generates it. `External_ID` stays and holds the client's own reference for that customer.

### The workbook contents — verified, every join checked

```
Agents        Twin Poultry · Saputo · Snowcap · Premier Packaging

Materials     Ingredient, Kg:  Raw Chicken · Yogurt · Salt · Ginger Powder ·
                               BBQ Sauce Bulk · Salt 1
              Packaging,  Ea:  BC Tray · BCwBS Retail Carton · Case ·
                               BS Pouch · Internal Container
              Opening_Stock 10000 on every row. External_ID GP-100..GP-109, GP-111

Products      Seasoning Mix  Ea  40 units/batch  500 opening  Intermediate  FP-201  365d
              Baked Chicken  Ea  50 units/batch  1200 opening Finished     FP-202  180d  -18 Celsius

Packaging     Seasoning Mix  L1 Internal Container 0.2 Kg
              Baked Chicken  L1 BC Tray 0.4 Kg,  L2 Case x10

Recipe        Seasoning Mix  <- Ginger Powder 7 Kg
              Seasoning Mix  <- Salt 1 Kg
              Baked Chicken  <- Raw Chicken 22 Kg
              Baked Chicken  <- Salt 0.125 Kg
              Baked Chicken  <- Seasoning Mix, 5 UNITS   <- THE ROW THAT MATTERS

Customers     A Loving Spoonful   External_ID 1042   604-555-0199
Addresses     220 Industrial Way, Richmond BC     (Warehouse Desk, 604-555-0177)
              1500 Marine Dr, North Vancouver BC  (Site Manager,   604-555-0188)
```

⚠ **`Salt 1` is a real material, not a stray row.** Minty's ruling S149. It is on Materials as GP-111. 11 materials, 11 supplier pairs, one for one.

⚠ **No trailing spaces and no odd characters anywhere in the file.** Every value dumped quoted, S149. Exact-match joins on names will work.

⚠ **Minty's ruling S148: exactly one of `Quantity_Kg` and `Intermediate_Units` is filled per row.** Which column holds a value says whether the component is a material or a product.

⚠ **`BS Pouch` and `BCwBS Retail Carton` are on Materials but used in no packaging.** Deliberate. Unused packaging materials are not an error.

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

What it does, measured at `Formulations.js:895–935`:

- builds `materialArray` and `formulationArray`, then `SubrecipeMaterials.createEach` and `Subrecipeformulation.createEach`
- `formulationArray` takes **`qty` and `ship_qty` straight from the request** — both supplied by the caller, neither computed
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

### The column mappings — all measured S149

| sheet column | goes to | note |
|---|---|---|
| `UOM*` | `materials.uom` / `formulations.uom` | ⚠ **`int`, NOT NULL.** A pointer to the company's unit rows — 479's ids **2990–2997**. `Kg`→2990, `Ea`→2997. **Look up per company** |
| `External_ID` | `materials.myCode` / `formulations.myCode` | varchar. Confirmed on both |
| `External_ID` (customers) | `companycustomers.external_id` | varchar |
| `Storage_Temperature` + `Temperature_Unit` | **one** `storage_temp` varchar | Two sheet columns, one column. Stored as `-18 C`, `0-4 C` — **value, space, first letter of the unit** |
| `Food_Contact` | `materials.food_contact_flag` | `tinyint`. Yes→1, No→0. **Every one of 267 existing rows is 0** |
| `Contact_Number` (supplier) | `companyagents.contact_number` | ⚠ **`varchar`. Dashes store fine. Do NOT strip** |
| `Contact_Number` (customer) | `companycustomers.contact_person_no` | ⚠ **`double`. Strip to digits or write null** → P285 |
| `Shipping_Contact_Number` | `customershippingadresses.shipping_contact_person_no` | ⚠ **`double`. Same** |
| `Opening_Stock` | `materials.inventory` | in the material's own UOM |
| `Opening_Stock_Units` | `formulations.inventory_units` | **and** `formulations.inventory` = units × Level 1 weight |
| `Product_Type` | **nowhere** | ⚠ Leave NULL — see below |
| `Customer_No` | **nowhere** | Off the sheet. The app generates it |

⚠ **`product_type` is dead. NULL on all 114 rows on the box.** `producttype` is a per-company free-text table with **zero rows for every company**. Nothing marks a product as an intermediate — **a product becomes an intermediate simply by being chosen in another product's Intermediate Product picker, and that picker filters nothing.** Confirmed on screen S149: all three products listed. **Create Seasoning Mix as an ordinary product and reference it by name.**

### The quantity rules — the heart of the job

⚠ **`ship_qty` is what the client TYPES. `qty` is DERIVED from it.** Minty, S148:

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

**For this workbook:** Baked Chicken ← Seasoning Mix, `ship_qty` 5, `qty` = 5 × 0.2 = **1 Kg**.

⚠ **This is RULES §7's one and only exception**, and the reason is Minty's, S148: the count subtracted from `inventory_units` must be the count someone typed.

### ⚠ OPENING STOCK NEEDS THE WEIGHT BEFORE THE PRODUCT EXISTS

**Both stock columns are live and they reconcile exactly** — measured S149:

```
Baked Chicken   (id 3611)  111 units x 0.4 = 44.4 Kg
Seasoning Mix   (id 3607)  9.625    x 8    = 77   Kg
```

`SOH_actual` is **0 on every row**. Leave it.

⚠ **But the Level 1 weight lives in packaging, and packaging is written after the product.** So at product-create time the multiplier is not in the database yet.

**Take it off the sheet.** The whole workbook is read before anything is written, so carry `Level_1_Weight_Kg` from the Product-Packaging tab into the products pass. No second update, no extra pass.

**For this workbook:** Seasoning Mix 500 × 0.2 = **100 Kg**. Baked Chicken 1200 × 0.4 = **480 Kg**.

### Packaging, measured

- `fopackaging.pack_level` is **text**: `Level 1 Pack` … `Level 5 Pack`. The model formats an integer for you.
- ⚠ **`whd_flag = 1` marks the shipping level, and it is stored, not inferred.** One level → flagged on 1. Two → on 2. Three → on 3. Measured across 20 rows.
- ⚠ **`wgt_kgs_per_unit` is CUMULATIVE.** Level 1 carries the unit weight; each level above is its ratio × the weight below. Product 3705: `0.41 → 5 × 0.41 = 2.05 → 13 × 2.05 = 26.65`. **The sheet carries the ratio and the Level 1 weight only. The importer multiplies.**
- `fopackaging.material_id` is **NOT NULL** — every level needs a packaging material that exists with Type = Packaging. ⚠ All three in this workbook do.

**For this workbook:** Seasoning Mix — L1 Internal Container, 0.2, `whd_flag` on 1. Baked Chicken — L1 BC Tray 0.4, L2 Case ratio 10 weight 4.0, `whd_flag` on **2**.

### Recipes

- Lines hang off a **`fosubrecipe`** row, which hangs off the product. `fosubrecipe` has **four columns only** — `createdAt`, `updatedAt`, `id`, `formulation_id`.
- **113 of 114 products have exactly one sub-recipe; one has two.** The importer creates one per product.
- Materials go to `subrecipematerials` (`qty` in Kg), intermediates to `subrecipeformulation`.
- ⚠ **Never read `mlomanagement.batches`** — it is the same sum, already rounded and stored.

### ⚠ ALLERGENS ARE AUTOMATIC — THERE IS NO ROLL-UP PASS

**Confirmed by Minty, S149:** *"when I edit the allergen in materials, the edited allergen shows in products."*

If the roll-up were stored on the product, a later edit to a material would leave the old value behind. It doesn't. **The app computes it fresh every time the screen is drawn** — `Formulations.js:606–607` merges the product's own allergens with those gathered from its materials and de-duplicates, without writing.

**So the importer does nothing about product allergens.** It writes allergens on materials from the Material-Allergens tab, and it writes recipe lines. The screen does the rest, including the two-step through Seasoning Mix.

⚠ **This removes a pass from the order and the ordering risk that came with it.**

- Stored as a **JSON array of strings**: `["Milk","Soy"]`. Empty is `[]`. Same on `materials.allergen` and `formulations.allergen`, both `longtext`.
- `companyallergens` is the client's own list — 11 rows on 479, seeded.

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

⚠ **`status_id = 1`** on materials, agents and formulations — it is what every existing row uses.
⚠ **`unittype` is GLOBAL, no company_id.** `1 Ingredient · 2 Packaging · 3 Non-Food Chemical`. Same for every client. Maps `Type*`.
⚠ **`customershippingadresses` has no `company_id`** — scoped only through `customer_id`. Billing column is spelled **`billing_adrress`**.
⚠ **`Shipping_Units_Per_Batch` → `formulations.batch_qty`.**

---

## THE ANALYSIS — S149's rulings supersede S148's

**⚠ THE PRODUCT IS THE UNIT OF LOADING.** Minty's ruling, S149. **This replaces S148's all-or-nothing and its refuse-a-non-empty-company guard.**

- Load what is good, skip what is not.
- **One bad cell anywhere on a product** — its own row, its packaging, any of its recipe lines — **and that product is not created at all.** Everything else in the file still goes in.
- The reason: the app creates a product, its packaging and its recipe in **one single call**. There is no way to add a missing recipe line to a product that already exists. A half-loaded product cannot be repaired by re-uploading.

**⚠ THE REPORT NAMES THE CELL.** Tab, row and column for every fault. Fix the file, upload again, and anything already loaded is left alone.

- **Skipping cascades, and each skip gets its own line.** If Salt fails, every recipe line using Salt is skipped too, and each says so — nobody is left guessing why Baked Chicken came in short.
- **Opening stock can only ever load once.** It rides on the material and product rows. If those already exist we do not touch them, so a second upload cannot double the stock. That is what the old non-empty guard was protecting, and it is now protected by skipping instead.

**⚠ ADDRESSES GO IN AS GIVEN.** Minty's ruling, S149. Every address row on the sheet becomes an address row in the database. **No duplicate check.** A real client genuinely ships to two doors sharing one phone number, and dummy data repeats.

⚠ **Do NOT route shipping addresses through `CompanyCustomers.compareShipAdress`** — it treats two addresses as duplicates if **ANY ONE** of contact person, number, address or email matches. An OR where an AND was meant. It stays in place guarding the hand-entry screen. → P287

**⚠ ONE FILE, ONE PASS.** Minty's ruling, S148, re-confirmed S149. Validation is cross-tab — a recipe line can only be judged with the Materials and Products tabs both in hand — so splitting the upload would mean re-reading the database between parts, and would find the Materials faults before the Recipe faults instead of all of them at once.

**The pass order.** Dependency-driven. Packaging must precede recipe lines so the Level 1 weight exists for the units→Kg conversion:

> agents → materials → material-suppliers → material-allergens → **products (with packaging and recipe in the same call)** → customers → customer-addresses

**Names, never ids.** Exact match, no fuzzy matching. *"Snowcap means snowcap."*

**Certificates deferred.** `iss` / `iss_expiry_date` are per material-supplier pair, but a certificate is a **file on S3**. Importing the date without the file is worse than blank. Done in the app afterwards.

**No Manufacturers tab.** *"Agent is good enough. We will take agent as a supplier, single point."* `is_agent` stays in the schema, untouched.

---

## VERIFY — what must be seen on screen to call S150 done

⚠ **On `dev.mintekfoodsafety.com`, not `abletrace.ca`.** Prod screens look identical and prove nothing about this work.

1. Company 479 lists its **four suppliers**.
2. **Materials** list, 11 rows, correct Type — Ingredient vs Packaging.
3. **Baked Chicken** shows its packaging: Level 1 BC Tray at 0.4 Kg, Level 2 Case × 10.
4. ⚠ **Baked Chicken shows SEASONING MIX in its recipe** — the intermediate. The thing done by hand today and the reason this job exists.
5. **Baked Chicken's allergen list is not empty** — it must show what carried up through Seasoning Mix. Nothing in the importer produces this; if it is empty, the recipe did not load.
6. **A Loving Spoonful** shows **two** shipping addresses, each on the right contact.

---

## PROOF

⚠ **Provenance is marked.** S149 facts were measured this session. S148 facts were measured last session and not re-measured — they are structural and cheap to re-check if doubted.

| fact | measured by | returned | when |
|---|---|---|---|
| header is on row 2 | `s149-headers.js` over all 11 tabs | row 1 is guidance prose on every tab | S149 |
| every tab's headers | same | quoted in full above | S149 |
| row counts | same | 4·11·11·2·2·2·5·1·2 | S149 |
| no stray characters | `s149-lists.js` / `s149-rows.js`, values dumped quoted | every value tight | S149 |
| stray column C is empty | `s149-lists.js`, `!ref` plus every cell | A1:C13 declared, C empty throughout | S149 |
| `Salt 1` is on Materials | `s149-rows.js` | row 13, Ingredient, Kg, GP-111 | S149 |
| every cross-tab join | `s149-rows.js` + `s149-lists.js`, read against each other | no orphans | S149 |
| uom is an int | `information_schema.COLUMNS` | `int`, NOT NULL, both tables | S149 |
| External_ID → myCode | `SELECT internalCode, myCode FROM materials/formulations` | MAT-29 / 25160 | S149 |
| storage_temp is one varchar | same, plus `GROUP BY storage_temp` | `-18 C`, `0-4 C` | S149 |
| supplier phone is varchar | `information_schema.COLUMNS` | `varchar`, dashes safe | S149 |
| customer phones are double | same | `double` → P285 | S149 |
| food_contact_flag | `GROUP BY` | `tinyint`, 0 on all 267 | S149 |
| customer_no is app-generated | `SELECT customer_no FROM companycustomers` | CUST-0001..0008 sequential | S149 |
| product_type is dead | `GROUP BY product_type` | NULL on all 114 | S149 |
| the intermediate picker filters nothing | screenshot, Add Formulation | all 3 products listed | S149 |
| allergens are computed, not stored | Minty: editing a material changes the product | + `Formulations.js:606–607` merge with no write | S149 |
| both stock columns reconcile | `SELECT inventory, inventory_units` | 111 × 0.4 = 44.4; 9.625 × 8 = 77 | S149 |
| the open check | the OPEN block on dev | `c2a52d8e` / `cf7722d` / online / 200 / v24.19.0 | S149 |
| `importSheet.js` is 32 lines | `scp` from dev, read in full | opens workbook, one tab, returns rows | S148 |
| the route | `grep -n "Sheet/" config/routes.js` | line 37, one route only | S148 |
| the four create paths | `grep -n "^  *[a-zA-Z_]*: *async" api/models/*.js` | line numbers quoted above | S148 |
| the import mode | `sed -n '895,935p' api/models/Formulations.js` | `if (req.import != undefined) return findFormula` | S148 |
| code generators count rows | `sed -n` over the three models | `count()+1`, called per record at `:321`, `:417`, `:879`, `:187`, `:254` | S148 |
| ship_qty is units, qty is Kg | join of `subrecipeformulation` to both formulations | four rows reconciled exactly | S148 |
| pack_level values | `GROUP BY pack_level` | `Level 0` … `Level 5 Pack` | S148 |
| whd_flag marks the top | 20-row `fopackaging` ladder | flagged on the highest level present | S148 |
| cumulative weights | same ladder, product 3705 | 0.41 → 2.05 → 26.65 | S148 |
| one sub-recipe per product | `GROUP BY` count of `fosubrecipe` | 113 have 1, one has 2 | S148 |
| `fosubrecipe` is bare | `SELECT * FROM fosubrecipe LIMIT 5` | four columns | S148 |
| 479 is empty | four scalar counts | 0 / 0 / 0 / 0 | S148 |
| 479's units | `SELECT id, unit_name FROM unitmeasurement WHERE company_id=479` | 8 rows, ids 2990–2997 | S148 |
| 479's admin | `SELECT id, email FROM user WHERE email LIKE 'test260901%'` | 1335 | S148 |
| status ids | `GROUP BY status_id` on three tables | 1 on all | S148 |
| allergen format | `SELECT allergen` non-empty | `["Milk","Soy"]`, `[]` | S148 |
| `unittype` global | `SELECT * FROM unittype` | 3 rows, no company_id | S148 |
| dev's schema | `.env` DATABASE_URL, tail after last slash | `abletracelab_live` | S148 |

**Left on dev at `~/s149-work/`:** the workbook — **keep, S150 needs it**. The four read-only scripts `s149-headers.js`, `s149-lists.js`, `s149-rows.js`, `s149-cols.sh` are deleted at the tidy along with their Mac Downloads copies.

---

## NOT MEASURED

**Nothing blocking.** The `materialsagents` create path was not read line by line — the material-supplier link is two ids and `is_agent`, and `Materials.createMaterials` may already write it. **Read it before writing that pass; it is one grep.**

---

# OTHER OPEN ITEMS — not part of the job

## ⚠ TWO LIVE CLIENTS SEE "Your licence has expired."

Shelly (Hagensborg) and Javier (Designer Cookies). Status 4 Expired still permits login — only 6 Inactive blocks it. Works as designed, but it is the first thing both clients read, and the WhatsApp pointing them at `app.abletrace.ca` went out S145.

⚠ **Business question, now five sessions old.**

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

| # | item |
|---|---|
| P262 | **S150. Write the importer.** Deliverable, material, analysis, verify and proof are all in THE JOB above |
| P288 | **The upload screen — S151.** ⚠ **Half its homework is done, S147–S149.** Goes in `src/app/Layouts/super-admin-dashboard/global-procedures/` — four files, `global-procedures.component.ts/.html` and `sync-client-dialog/`. Copy Sync Client's company picker, searching by name or email, ⚠ **but Onboarding must allow exactly ONE company where Sync allows many.** Create HACCP is the pattern for the file side: Download Template beside Import, and a `confirm()` echoing the filename. ⚠ **Upload buttons already exist** on `admin-formulation`, `manage-materials`, `agents`, `manufacturers`, `customers` — 27 files carry `type="file"`, so no new plumbing is needed, only the screen. ⚠ **Frontend is edited on the MAC, built by GitHub Actions** — a full deploy cycle, which is why it is its own session. ⚠ The editable review screen is a **separate** job again, not part of this |
| P281 | **Stale `mintekfoodsafety.com` fallbacks.** `config/env/production.js` lines 24, 151, 250; stale comment `QuickbooksController.js:97`. ⚠ Nothing is broken — prod's `.env` wins. ⚠ **But if that variable ever goes missing, prod silently reverts to the old domain and nobody would notice.** ⚠ `development.js` line 7 stays — dev is not moving yet |
| P279 | **Invoicing inside AbleTrace.** Default price on the product master, editable per line. Tax per line, overridable — basics are zero-rated, prepared foods are not, one order can carry both. ⚠ **Store the values USED on the invoice; never re-derive from the master later.** ⚠ **S146 ruling: price is CURRENT only, no versioning, no history.** ⚠ **Added S149: QuickBooks identifies a customer by NAME ONLY — it has no customer id to match on.** So the link between an AbleTrace customer and a QuickBooks one is the name string itself: a rename on either side silently breaks it, and two customers can never share a name. Open before any code: numbering scheme · where the editable price field sits · invoice layout and what a Canadian food invoice must legally carry · own tile or inside the packing slip flow · what happens if the push fails after a number is allocated |
| P278 | **Terms and privacy in-app with versioned acceptance.** ⚠ Files are `src/assets/docs/terms.html` and `privacy.html` — replacing them is a FILE SWAP, no code change. Two acceptance routes, users and company employees, both pointing at the same documents. Record **who accepted, when, and WHICH VERSION**; on a change, ask again. ⚠ Acceptance rows are never edited or deleted. ⚠ `company.terms_condition` is a yes/no flag with no version or timestamp — replace it, don't extend it. ⚠ **Blocked on the lawyer returning both documents** |
| P277 | **Client data deletion routine.** Deletion on request is a published commitment with no tooling. ⚠ Manual today: many related tables in FK order, **plus the `abletrace-fileuploads1` bucket whose filenames name no company.** ⚠ **Every uploaded workbook is kept forever in Sails' temp uploads folder** — a client's full master data, in a folder nobody looks at |
| P276 | **Naming audit across all environments.** ⚠ Both RDS instances hold a schema called `abletracelab_live` and one called `abletrace-dev`; **dev's app runs on `abletracelab_live`**. `SHOW DATABASES` is identical on both boxes. Audit instances, schemas, EC2s, PM2 processes, buckets, IAM users, repos |
| P280 | **Split the marketing site out of the Angular app.** Today a visitor downloads the whole application to read three paragraphs, and every marketing tweak needs a full rebuild. ⚠ **No harder later than now.** Assets on the box: `AbleTraceLogo.png` · `home-bg.jpg` · `about.jpg` · `contact-img.jpg` · six feature images. ⚠ **Copy to `/var/www/marketing`, never reference them from `/var/www/html`** — every deploy wipes that whole. ⚠ `/var/www/` is root-owned |
| P272 | Rotate dev's `DATABASE_URL` password, printed to screen S143. Dev only. ⚠ Method 3B.8, read it first |
| P267 | **QuickBooks production approval.** ⚠ Off the critical path per P279, and waiting on a lawyer. Gaps: disconnect URL in Production Settings · `intuit_tid` capture · both legal documents naming AbleTrace · redirect becomes `https://app.abletrace.ca/api/quickbooks/callback`. ⚠ **Also never done: the OAuth connect flow has never run against prod, only sandbox** |
| P287 | **`compareShipAdress` is an OR where an AND was meant.** `CompanyCustomers.js`. Treats two addresses as duplicates if **ANY ONE** of contact person, number, address or email matches, so a second delivery point sharing one company email is silently discarded. ⚠ **Hand-entry screen only** — the importer bypasses it per Minty's S149 ruling. Found S148, scoped S149 |
| P289 | **`storage_temp` holds the words `undefined undefined`.** ⚠ **245 material rows**, plus 9 saying `null null`; on formulations 19 say `null null`, 13 say ` null`, 3 say ` undefined`. The screen glues two blank boxes together and stores the result as text. Cosmetic — no calculation reads it — but it appears on a client's screen. Measured S149. ⚠ Fix the screen first or a heal will just refill |
| P270 | Material certificate icon shows red "Certificate Unavailable" when a valid in-date certificate exists. Display fault only — the file downloads and opens |
| P274 | No local build path. `nvm` is not installed; the Mac is Node v24 against a project declaring `^20` |
| P275 | 192 npm vulnerabilities (6 critical, 79 high). ⚠ **Do NOT run `npm audit fix`** |
| P271 | `[object Object]` alert on SO-Management |
| P17 | Two old-account IAM keys still valid and in git history |
| P210 | Prod to Node v18 → v24. Dev has run v24 cleanly for several sessions. ⚠ Dev keeps `node_modules.old-node18/` as the fallback — deliberate, untracked |
| P248 | OS updates. ⚠ Both boxes say "System restart required" on every login. Prod 59 pending / 12 security; dev 56 / 25 |
| P224 | Dev SSH IPv6 rule |
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
| P268 | **QuickBooks tile visibility gate is not in `src/app/Layouts`.** ⚠ Confirmed S146: the tile does NOT appear for a company created without the role rows. **Half its homework is done** |
| P269 | **Two stored procedures built by string interpolation.** `Materials.js:137`, `Hazards.js:224`. ⚠ `Materials.js:380` and `:790` use `myCode` and were never checked |
| P282 | **External supplier code on `companyagents`.** ⚠ The table has **no code column of any kind** — products and customers have `External_ID`, suppliers do not. Needs: a column on **both boxes** · the Add Supplier form and the supplier list screen · a template column. ⚠ **Minty's ruling S147: not in P262. Names work as the join key.** Worth doing once POs are in regular use |
| P283 | `http://localhost:1338/Sheet/importSheet` hardcoded at `admin-formulation.component.ts:70`. A dead URL in production. Likely resolved by the P262 rewrite |
| P284 | **Dev to follow prod onto `abletrace.ca`.** Dev is `https://dev.mintekfoodsafety.com`, returns 200, Certbot-managed and auto-renewing. A move means reissuing that certificate. Blocks P286. ⚠ **Cosmetic — it changes nothing about what the box does** |
| P285 | **Phone numbers are stored as `double`.** `companycustomers.contact_person_no` and `customershippingadresses.shipping_contact_person_no`. A number with a dash, a leading zero, brackets or an extension cannot be stored. ⚠ **`companyagents.contact_number` is varchar and is FINE** — measured S149, only the two customer columns are affected |
| P286 | **Retire `mintekfoodsafety.com`, dev and prod.** ⚠ **Three dependencies must clear first, in order.** (1) **P284** — dev is served at `dev.mintekfoodsafety.com`. (2) **P281** — prod's config falls back to `mintekfoodsafety.com` URLs if `APP_BASE_URL` is ever missing. (3) **Prod still serves `trace.mintekfoodsafety.com`** from its own 443 block with its own certificate — clients may have it bookmarked. Then: the nginx blocks, the certificates, the DNS records, and finally the GoDaddy registration. ⚠ **Business question first: do any clients still reach the app on `trace.mintekfoodsafety.com`?** ⚠ **Run the pointer before releasing the resource** — the S138 subdomain takeover happened exactly this way |

---

## TRAPS CARRIED FORWARD — all look like broken code

### ⚠ THE PASTE PROBLEM

⚠ **Copy ONLY from the grey fenced box in the chat. NEVER from the terminal window.** **Ctrl+U, paste, Enter, one block.** When the clipboard will not cooperate, **type the line by hand**.

⚠ **A pasted fragment containing `>` SILENTLY EMPTIES the file it names.**

⚠ **Counts matching is not contents matching.**

### ⚠ NEW, S149

⚠ **A command run on the wrong box can return a plausible answer.** S149 ran the workbook check on **dev** when the file was on the **Mac**. `unzip` found nothing, the error went to `/dev/null`, and `grep -c` returned **0** — which reads identically to "this is the superseded file". **Every measurement command must print `hostname -s` first.** A check that cannot distinguish its two answers is not a check.

⚠ **A header row is not necessarily row 1.** Every tab of the onboarding workbook has guidance prose on row 1 and the real header on row 2.

⚠ **Excel declares a range wider than the data.** `!ref` said A1:C13 where column C was empty throughout. Read by header name, never by position count.

⚠ **A file offered for download is not a file downloaded.** Twice in S149 an `scp` failed on a file that had never been saved. **`ls -lt ~/Downloads | head -3` before every transfer** — it also catches the numbering trap.

⚠ **A pasted command with no output below it was never run.**

### Standing

⚠ **A document pasted into the chat can be an OLD COPY.** S148 and S149 both opened on a `RULES.md` reading "Last revised: S131". **Check the header and the byte count against the repo before rewriting any document.**

⚠ **A hidden row is still a row.** Excel row numbers jumping 2 → 4 means row 3 is hidden, not deleted, and any importer will read it.

⚠ **A code generator that counts rows breaks under bulk insert.** See THE INTERNAL CODE TRAP above.

⚠ **`sheet_to_json` omits empty cells entirely** — no key, not an empty string.

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
