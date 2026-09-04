# NOW

Written at the close of **S150**. The launchpad for **S151**.

---

## ⚠ HOW S151 OPENS

1. Run the open check.
2. Reproduce the symptom: log in to dev as `test260901@mailinator.com`, open **Products**, click the **Details arrow** on Baked Chicken. Expect a blank form.
3. Then THE JOB, first thing. It is one measurement, then a decision.

⚠ **The super admin token was retired at the S150 close.** `webToken` on user 1 is NULL, so any old token fails. Log in again to get a fresh one if S151 needs to post to the importer.

⚠ **RULES.md in the Claude project panel was stale for a third session running** — the panel held S131 while the repo held S148. The panel copy was replaced at the S150 close. **Still check the header line against the repo before trusting it.**

---

## STATE

**Deliberate, done — S150:**

- `api/services/importSheet.js` rewritten whole. 1,181 lines, committed `ed7f0cb`, pushed.
- `api/models/CompanyAgents.js` line 124 fixed — `remarks` fallback changed from `null` to `''`. Committed `3cd80d3`, pushed. **On dev only. Not on prod.** → P289
- The importer is **proven on dev**: one POST of the workbook loads company 479 end to end with **zero skips**.
- Schemas diffed dev against prod at the close: **identical**, 778 columns each. The importer needs no schema change to reach prod.
- `~/CompanyAgents.js.bak-s150` kept on dev — backup of the live model change, keep until the fix reaches prod.

**Half-done:** nothing. The importer is finished and proven. The blank Product Details screen is a **new finding**, not unfinished work.

**Standing:** dev on `dev.mintekfoodsafety.com`, 200. Company 479 currently holds a full load from the workbook — 4 suppliers, 11 materials, 2 products, 1 customer, 2 addresses.

**Open check, S150 close:** frontend `c2a52d8e`, backend `3cd80d3`, trees clean apart from the deliberate `node_modules.old-node18/`, `abletrace-dev` online, 200, Node v24.19.0.

---

# THE JOB — S151: THE PRODUCT DETAILS SCREEN LOADS BLANK

**Find out why clicking Details on a product opens an empty form, and whether it affects products created through the UI as well as imported ones.**

⚠ **Frontend investigation. Not the importer.** The importer is done.

---

## THE MATERIAL

### The symptom, exactly

Log in as the 479 client user → **Products** → click the **arrow under "Details"** on Baked Chicken.

The URL becomes `dev.mintekfoodsafety.com/Edit-Formulation`. The page renders **"Product Details"** with every field empty: Internal Code, External ID, Name, Units of Measurement, Shipping Units per Batch, Product Type, Storage Temperature. Sub Recipes shows an empty Total Materials box.

**No request reaches the server.** Measured: `pm2 flush abletrace-dev`, then the click, then `pm2 logs abletrace-dev --lines 40 --nostream` — **both out and error logs completely empty**.

### The second symptom, probably the same cause

On the **Products list**, the **Allergen column is blank for both products**. It should not be. Baked Chicken's recipe contains Yogurt, Yogurt carries Milk, and the roll-up is computed live from the recipe. The **Materials** list shows allergens correctly — Milk on Yogurt, Soy on BBQ Sauce Bulk — so the data is right and it is the product side that is not showing them.

### What is ruled out

| ruled out | how |
|---|---|
| stale browser state / P249 | fresh logout, fresh login, straight to the list, one click. Same result. |
| bad data from the importer | rows verified in the database, and the **list** screen renders both products correctly |
| a backend error | pm2 logs empty — the controller never ran |
| a schema difference | dev and prod schemas diffed identical at the close |

### The one thing not yet measured

**Does this happen to a product created through the UI?**

That single test splits the diagnosis in two:

- **Blank for a UI-created product too** → pre-existing app fault, nothing to do with the importer. Queue it, size it, fix it on its own merits.
- **Fine for a UI-created product, blank only for imported ones** → the importer omits something the detail screen needs, and the importer is not finished after all.

Create a product by hand in 479 through the Add Product screen, then click its Details arrow.

### The frontend, what is known

- Screen route: `/Edit-Formulation`. List route: `/Formulation`.
- Backend route exists and works — the list is served fine.
- `Formulations.getFormulaById` is the method the detail screen would call, at `api/models/Formulations.js:396`.
- The allergen roll-up is **computed, not stored** — confirmed at `Formulations.js` lines 260–267 and 503–510, which collect `item.allergen` off each material in the recipe and de-duplicate. `getAllergenFromSP` at line 114 walks child formulations through a stored procedure. The product's own `allergen` column plays no part.
- Products in 479 correctly hold `allergen = "[]"` — the importer writes nothing there, which is right.

### Company 479 as it stands

| | |
|---|---|
| company | **479**, `test260901@mailinator.com`, its admin is user **1335** |
| super admin | user **1**, `info.abletrace@gmail.com`, exempt from the P250 rewrite |
| schema | **`abletracelab_live`** ⚠ prod uses the same name |
| suppliers | 4 — Twin Poultry, Saputo, Snowcap, Premier Packaging |
| materials | 11, MAT-1 to MAT-11, all with 10000 opening stock |
| allergens | Milk on Yogurt, Soy on BBQ Sauce Bulk |
| products | 2 — Baked Chicken `FO-0002`, Seasoning Mix `FO-0001` |
| recipe | Baked Chicken ← Seasoning Mix, `ship_qty` 5, `qty` 1 Kg |
| packaging | Baked Chicken: BC Tray L1 0.4 Kg, Case L2 ×10 = 4.0 Kg, `whd_flag` on L2. Seasoning Mix: Internal Container L1 0.2 Kg, `whd_flag` on L1 |
| customer | A Loving Spoonful, 2 addresses |

To rebuild 479 from scratch, the delete-then-reload commands are in THE PROOF below.

---

## THE ANALYSIS

**The importer is done.** It loads an entire company from one POST with zero skips. Suppliers, materials with their supplier links and allergens and opening stock, products with packaging cascades and derived recipe quantities, customers with their addresses. Verified in the database and on the Materials screen. Minty's no-update rule verified on a real re-upload.

**Four passes, not seven.** S149 planned seven. Three collapsed because the app's own model methods already do the work:

- `Materials.createMaterials` writes the supplier links itself (`Materialsagents.createEach`, line 484), so Material-Suppliers folds in.
- Allergens are a field on the material row, so Material-Allergens folds in.
- `CompanyCustomers.createCustomer` writes the addresses itself, so Customer-Addresses folds in.

**Five design rulings, Minty, S150:**

1. **Existing rows are never updated on a re-upload.** Skip and report, always, even if the sheet now says something different. Correcting a loaded row is done on the screen.
2. **A record with a bad cell is not created at all**, and everything else in the file still loads. For a product that includes its packaging and its recipe, because the app creates all three in one call and a half-loaded product could never be repaired.
3. **Material opening stock is written by the importer as a separate step**, not by changing `createMaterials`. The screen's guard stays shut so nobody can type stock into a material by hand. Stated cost, accepted: an opening balance has no lot and no receipt behind it.
4. **Allergens belong to the material, never to the product.** The product's allergens are computed from its recipe every time, so changing an ingredient's allergen changes every product containing it, automatically. The importer writes an empty allergen list on products deliberately.
5. **Opening stock via a purchase order is the right long-term answer** — create a PO, receive against it, book a dummy lot code. Deferred, and it **replaces** the simple stock write rather than sitting beside it. → P290

**Five traps in `importSheet.js`, documented in the file's own header.** Do not remove the guards without reading why:

1. Header is on row 2 — `range: 1`. Row 1 is guidance prose.
2. `sheet_to_json` drops empty cells entirely — `defval: ''`, not optional.
3. Internal code generators count existing rows and add one, so every record must be created and awaited singly. A `createEach` gives every row the same code, silently.
4. The model methods answer the browser themselves on failure. A stub `res` captures the message into the report instead; without it the first bad row closes the response and everything after writes into a request already answered.
5. Two conventions in one codebase: `allergen`, `agents`, `manufacturers` are `JSON.parse`d so must be **strings**; `Refer_SubRecipe` and `Refer_packaging` are used as live **arrays**.

**The workbook is correct as it stands.** S148 built it right. The Lists tab holds the ten Health Canada priority allergens; the Material-Allergens tab attaches them to materials; its own guidance already says allergens are never recorded against a product. **No workbook change was needed or made.**

---

## THE VERIFY

S151 is done when:

1. A product created through the **UI** has been opened via the Details arrow, and the result recorded — blank or not blank.
2. The cause of the blank screen is named, with the measurement that proves it.
3. Either the fix is on screen and verified, or the job is sized and queued with what was learnt.

---

## THE PROOF

Every fact above, with the command that measured it and what it returned, run in S150.

| fact | command | returned |
|---|---|---|
| importer loads with zero skips | POST to `/api/v1/Sheet/importSheet`, company 479, user 1 | `created: 4 suppliers, 11 materials, 2 products, 1 customer, 2 addresses`, `skipped: []` |
| database agrees | `select count(*)` per table where `company_id=479` | 4, 11, 2, 1, 2 |
| recipe quantity derived correctly | `select ship_qty, qty from subrecipeformulation ...` | Baked Chicken ← Seasoning Mix, ship_qty 5, qty 1 — that is 5 × 0.2 |
| packaging cascade cumulative | `select pack_level, quantity, wgt_kgs_per_unit, whd_flag from fopackaging ...` | L1 BC Tray 0.4; L2 Case ×10 = 4.0, whd_flag 1. Seasoning Mix L1 0.2, whd_flag 1 |
| allergens on materials, not products | `select title, allergen from materials / formulations where company_id=479` | Yogurt `["Milk"]`, BBQ Sauce Bulk `["Soy"]`; both products `"[]"` |
| material stock written | `select title, inventory, uom from materials where company_id=479` | 10000 on all 11; uom 2990 Kg / 2997 Ea |
| sheet says 10000 too | node + xlsx read of the Materials tab | 10000 for all eleven — **the test is weak because every value is identical. Vary them next time.** |
| 479 has its allergens | `select count(*) from companyallergens where company_id=479` | 11, same as every other company. Seeded at company creation, `User.js:238` |
| no request on Details click | `pm2 flush`, click, `pm2 logs --lines 40 --nostream` | both logs completely empty |
| not stale state | fresh logout, fresh login, straight to list, one click | same blank form |
| schemas identical | `dump-columns.sh` on both boxes, then `diff` | `SCHEMAS IDENTICAL`, 778 columns each |
| both commits pushed | `git push` on dev backend | `cf7722d..3cd80d3 main -> main` |
| token retired | `update user set webToken = NULL where id = 1` | `webToken` NULL on user 1 |

### Rebuilding 479

Clear it:

```
mysql -e "delete p from fopackaging p join formulations f on p.formulation_id=f.id where f.company_id=479; delete sm from subrecipematerials sm join fosubrecipe fs on sm.sub_recipe_id=fs.id join formulations f on fs.formulation_id=f.id where f.company_id=479; delete sf from subrecipeformulation sf join fosubrecipe fs on sf.sub_recipe_id=fs.id join formulations f on fs.formulation_id=f.id where f.company_id=479; delete fs from fosubrecipe fs join formulations f on fs.formulation_id=f.id where f.company_id=479; delete from formulations where company_id=479; delete ma from materialsagents ma join materials m on ma.material_id=m.id where m.company_id=479; delete from materials where company_id=479; delete a from customershippingadresses a join companycustomers c on a.customer_id=c.id where c.company_id=479; delete from companycustomers where company_id=479; delete from companyagents where company_id=479;" abletracelab_live
```

Reload it — needs the workbook back on dev and a fresh token in `~/.s150tok`:

```
curl -s -X POST https://dev.mintekfoodsafety.com/api/v1/Sheet/importSheet -H "authorization: bearer $(cat ~/.s150tok)" -F "files=@/home/ubuntu/s150-onboarding.xlsx" -F "company_id=479" -F "user_id=1" | python3 -m json.tool
```

The workbook is on the Mac at `~/Desktop/Old AWS Docs/AbleTrace-Client-Onboarding-test260901.xlsx`, 17,464 bytes. Ignore the two `SUPERSEDED-s148-` copies beside it.

---

## THE QUEUE — new at the close of S150

**P288 — Product Details screen loads blank.** Clicking the Details arrow on a product opens an empty edit form and sends no request to the server. The product Allergen column on the list is also blank when it should show the roll-up from the recipe. Frontend. This is S151's job.

**P289 — Deploy the supplier Remarks fix to prod.** `CompanyAgents.js:124` wrote an explicit `null` into `remarks`, which Waterline refuses on a string column with no `defaultsTo`, so the whole record was rejected. **This means adding a supplier with the Remarks box blank fails on the live Add Supplier screen today.** Fixed and committed on dev, `3cd80d3`. One-word change, no schema change needed. Backup at `~/CompanyAgents.js.bak-s150` on dev.

**P290 — Opening stock via purchase order and receipt.** Material opening stock is currently written straight onto the material row by the importer, with no lot and no receipt behind it. Minty's design: create a PO, receive against it, book a dummy lot code, so opening balances are traceable like everything else. Needs the receiving path measured and may need extra columns on the workbook's Materials tab — a supplier, a date, a lot code. **Replaces** the simple stock write in `importSheet.js`, which is marked in the file as scaffolding.

**P291 — Client-facing upload screen for the importer.** The route is driven by curl today. Nobody can onboard a client without a terminal. There is already an upload icon on the Products and Materials list screens. Small and safe once P288 is understood.

---

## TRAPS — considered and rejected, S150

Three entries were proposed at the close and **rejected, Minty's decision after Claude's recommendation.**

They were: a one-character defect cannot be read out of pasted terminal output; a failed MySQL query looks like an empty result; a case-sensitive grep cannot prove absence.

**Why they were rejected.** TRAPS.md's own entry rule says a new entry must fail silently and touch data or a client-facing number, and that something which merely cost time does not go in. All three merely cost time. Two of them are already on the S96 cut list, deliberately removed — *"an absent console log proves nothing"* and *"a check that passes for the wrong reason"*.

**What they actually were.** All three are the same failure: Claude accepted a check that could not have failed. RULES §1 already says *"A check must be able to fail."* The rule exists and was broken three times in one session. That is a discipline problem, not a gap in the documentation.

**Nothing was added to TRAPS.md. Do not re-propose these.**
