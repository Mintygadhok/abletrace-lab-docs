# NOW

Written at the close of **S151**. The launchpad for **S152**.

---

## ⚠ HOW S152 OPENS

1. Run the open check.
2. Then THE JOB. It is a build, not an investigation. The design is settled — see THE MATERIAL.

⚠ **The super admin token is live in `~/.s151tok` on dev.** 115 bytes, three JWT parts (36/34/43). Not retired at this close, deliberately — S152 will need it to test the upload screen against the same route. Retire it at the S152 close.

⚠ **The schema diff was NOT run at this close.** `dump-columns.sh` is not on the dev box — the docs repo is not cloned there at all. Measured: `find /home/ubuntu -maxdepth 3 -name "dump-columns.sh"` returned nothing. **No model files were touched this session** — one line of service code, no migrations. S150 diffed both boxes identical at 778 columns. Low risk, but it is a skip and S152 should know.

**RULES requires that script at every close and the box it runs on does not have it.** Either the repo gets cloned to dev, or the rule needs to say where it runs from. Minty's call.

---

## STATE

**Deliberate, done — S151:**

- `api/services/importSheet.js:1028` fixed — `allergen: JSON.stringify([])` → `allergen: []`. Committed `dfee5aa`, pushed. **Dev only. Not on prod.**
- **P288 closed. Verified on screen**, not merely deployed. Baked Chicken opens complete after a full reload of 479 through the patched importer.
- The importer re-proven end to end after the patch: `created: 4 suppliers, 11 materials, 2 products, 1 customer, 2 addresses`, `skipped: []`, `errors: []`.
- `~/importSheet.js.bak-s151` on dev — backup taken before the patch. Keep until the fix reaches prod.
- `~/s151-onboarding.xlsx` on dev, 17,464 bytes — the workbook, verified against the Mac copy's size.

**Half-done:** nothing.

**Standing:** dev on `dev.mintekfoodsafety.com`, 200. Company 479 holds a clean full load from the workbook, made *after* the fix.

**Open check, S151 close:** frontend `c2a52d8e`, backend `dfee5aa`, dev tree clean apart from the deliberate `node_modules.old-node18/`, `abletrace-dev` online, 200, Node v24.19.0.

---

# THE JOB — S152: THE SUPER ADMIN UPLOAD SCREEN

**Build the screen that posts the onboarding workbook to the importer, so onboarding does not require a terminal.**

⚠ **Frontend build. The route already works and is proven twice.**

---

## THE MATERIAL

### Minty's rulings, S151 — these settle the design

1. **Super admin onboards every client.** Not client-facing. One role, no permission work.
2. **The company is created first, on the existing screen.** The importer never creates a company. It loads into one that already exists.
3. **The importer's scope is four data sets:** suppliers (agents), materials, products, customers. That is what it does today.
4. **Opening stock comes straight from the sheet.** No PO, no receipt, no lot. **P290 is closed by decision, not deferred.**
5. **After the first load, all additions are manual and normal.** The importer is a one-time load per client.

### Design before writing — RULES §1

- **Who calls it:** super admin, user 1, from a screen in the admin area.
- **What they send:** `POST /api/v1/Sheet/importSheet`, multipart, three parts — `files` (the .xlsx), `company_id`, `user_id`. Header `authorization: bearer <token>`, **lowercase bearer** or `isAuth` returns 403.
- **What comes back:** `{ success, created: {suppliers, materials, products, customers, addresses}, skipped: [], errors: [] }`. The report is the screen's whole output — show `created` as counts and `skipped` as a list, because a partial load with skips is the normal case, not an error case.

### What already exists to copy

There is an **upload icon on the Products and Materials list screens** — the Sync Client / HACCP import flow. Model the new screen on it rather than inventing a pattern.

### The one thing noticed and not chased

**The route returns 200 to a POST with no file attached.** Measured at S151 while validating the token. Probably harmless — likely reports zero created — but a UI on that route makes it visible. **Check it inside this job**, not as a separate item.

### Rebuilding 479

Unchanged from S150 and used successfully at S151. The delete block and the curl are in THE PROOF below. The workbook is on dev at `~/s151-onboarding.xlsx` and on the Mac at `~/Desktop/Old AWS Docs/AbleTrace-Client-Onboarding-test260901.xlsx`. Ignore the two `SUPERSEDED-s148-` copies beside it.

⚠ **The workbook's opening stock figures are all 10000, identical on all eleven materials.** A bug writing the same value to every row would pass unnoticed. Vary them whenever the workbook is next opened. Not a blocker — Minty's ruling folds this into ruling 4 above.

---

## THE ANALYSIS

### P288, start to finish

The importer wrote `allergen` as the **string** `"[]"` instead of an empty array. `edit-formulation.component.ts:265` calls `.filter` on that value with no parse and no guard. A string has no `.filter`, so it threw, and Angular abandoned the form build — every field below that line stayed empty.

The data was never missing. `getFormulaById` returned 200 with 9.7 kB containing the whole product.

**Why the importer did it, and why it was not carelessness.** Trap 5 in the importer's own header: `allergen`, `agents` and `manufacturers` are `JSON.parse`d off `req.body` by the model methods, so those must be **strings**. That is true for **materials** — `importSheet.js:639` keeps its `JSON.stringify` and is correct. It is **not** true for products: `Formulations.js:830` files `req.body.allergen` straight into a `type: "json"` column with no parse, and the importer passes `FORMULAOBJ` as the **fourth argument** to `methodForCreateFormula`, bypassing `req.body` entirely.

Two conventions in one codebase. The file's own header warns about exactly this and it caught us anyway.

**Blast radius measured:** `grep -rn "allergen: JSON.stringify" api/` returns two sites, both in `importSheet.js`. 639 correct, 1028 wrong. Nothing else in the API writes that column this way.

### Three corrections to NOW as written at S150

1. **"No request reaches the server."** False. `getFormulaById` returns 200 with 9.7 kB. The S150 check — `pm2 flush` then empty logs — **could not have failed**, because Sails does not log ordinary successful requests at dev's level. RULES §1 broken again.
2. **"The product's own allergen column plays no part."** Substantially right, and Claude wrongly doubted it mid-session on the strength of five rows. `Formulations.js:604` calls `getAllergenFromSP(allIds)` and merges the result with the stored value at 605-607 — the roll-up is **computed live on read, server-side**. The stored column is a supplement the browser fills in on Add Product. Design ruling 4 stands.
3. **"The Allergen column is blank for both products, it should not be."** False — **the premise was wrong.** Baked Chicken's recipe does not contain Yogurt. Measured: the four materials across both recipes are Ginger Powder, Salt, Raw Chicken, Salt, all carrying `[]`. Yogurt exists in 479 with `["Milk"]` but nothing consumes it. **An empty Allergen List is the correct answer.** There was never a second symptom.

### The finding of the session — 137 fields, not two

Discovered by accident: Add Product returned **500** with External ID left blank, and saved instantly with `123` typed in. The stack named `myCode` — Waterline refuses an explicit `null` on a `type: 'string'` attribute with no `defaultsTo`.

**That is P289's exact mechanism on a different screen.** P289 was recorded at S150 as a one-word fix on one line. It is not an incident, it is a class.

Measured across `api/models/`:

```
for f in *.js; do awk '/type: *.string./ { if ($0 !~ /defaultsTo/ && $0 !~ /allowNull/) print }' "$f"; done | wc -l
→ 137
```

**137 string attributes with neither `defaultsTo` nor `allowNull`.** Every one will reject a blank optional box. Among them: `Formulations.myCode`, `Formulations.remarks`, `CompanyAgents.email`, `CompanyCustomers.remarks`, `CustomerShippingAdresses.email_address`.

**This is the upper bound, not the confirmed count.** A field only fails when a screen actually sends a blank into it. But establishing which screens do that costs more than fixing the class.

**Why it matters:** the app marks these fields optional — no asterisk — then refuses to save without them. The client's first independent action after onboarding hits a 500 with no explanation. It cannot be trained around.

**Why it does not block onboarding:** the importer has `stripNulls` and handles blanks correctly. This bites hand-entry only, the day after.

**Minty's ruling, S151:** fix it **after** onboarding is finished, as its own session. Until then, type a dash in the box, and warn any client onboarded before the fix.

---

## THE VERIFY

S152 is done when:

1. A workbook has been uploaded through the new screen — no terminal — and the created counts appear on screen.
2. The resulting company has been opened in the app and a product's Details screen verified.
3. Behaviour with no file attached is recorded — the route's 200 explained or fixed.

---

## THE PROOF

Every fact above, with the command that measured it and what it returned. Run in S151.

| fact | command | returned |
|---|---|---|
| request does reach the server | DevTools Network, Fetch/XHR, on the Details click | `getFormulaById` 200, xhr, 9.7 kB, initiator `edit-formulation` |
| the value arrives as a string | DevTools Preview on that response | `allergen: "[]"` in red quotes; `allChildAllergen: []` as a real array beside it |
| the line that throws | DevTools Console | `TypeError: this.data.allergen.filter is not a function` at `edit-formulation.component.ts:265:49`, thrice |
| the code has no parse and no guard | `sed -n '248,268p'` on the component | 264 `this.data = result[0];` 265 `.filter(...)` directly |
| app-created products hold a real roll-up | `select id, company_id, title, allergen from formulations where allergen <> '' and company_id <> 479 limit 5` | 3712 `["Milk","Soy"]`, 3710 `["Milk"]` — **query excluded empty values, so it could not show what the app writes for no allergens** |
| the roll-up is computed live on read | `sed -n '590,615p'` on `Formulations.js` | 604 `getAllergenFromSP(allIds)`, 605-607 merge with the stored value |
| the write site | `grep -n "allergen" api/services/importSheet.js` | 639 materials (correct), 1028 products (the defect) |
| blast radius | `grep -rn "allergen: JSON.stringify" api/` | two hits, both in `importSheet.js` |
| `stripNulls` will not drop an empty array | `grep -A 12 "function stripNulls"` | `if (obj[k] === null \|\| obj[k] === undefined) delete obj[k];` — strict |
| patch applied, anchored | python anchor script, refuses unless exactly 1 match | `PATCHED` |
| the right line moved | `grep -n "allergen: " api/services/importSheet.js` | 639 unchanged with `JSON.stringify`; 1028 now `allergen: [],` |
| restart clean | `pm2 restart abletrace-dev`, `sleep 8`, curl | restart 65, 200 |
| token valid | `awk` part-length split; POST with no file | `parts: 3`, 36/34/43; **200 — not 403, so isAuth passed** |
| workbook intact on dev | `ls -l /home/ubuntu/s151-onboarding.xlsx` | 17464 bytes |
| 479 cleared | delete block, then three counts | 0, 0, 0 |
| reload clean through the patch | POST the workbook | `created: 4, 11, 2, 1, 2`, `skipped: []`, `errors: []` |
| the column now holds a real array | `select title, allergen from formulations where company_id=479` | `[]` on both, **no quote marks** |
| **the screen works** | log in as 479 client, Products, Details arrow, Baked Chicken | **opens complete** — FO-0002, FP-202, Ea, 50 units, 200 Kg, -18 °C, Sub Recipe1, Raw Chicken 22Kg, Salt 0.125Kg, Seasoning Mix 5# (1 Ea), both packaging levels, shelf life 180 |
| UI-created products were never affected | Add Product by hand, then Details arrow | FO-0003 opened complete — **answers NOW's S151 opening question** |
| no allergen is the correct answer | `select m.title, m.allergen` joined through both recipes, company 479 | Ginger Powder, Salt, Raw Chicken, Salt — all `[]`. **Yogurt is in no recipe** |
| blank External ID fails | Add Product, External ID empty, Save | `500`, `Invalid new record ... myCode ... null is not valid vs type 'string'` |
| the same save succeeds with a value | External ID `123`, Save | `Formulation created Successfully` |
| the null fault is systemic | awk over `api/models/*.js` for `type: 'string'` without `defaultsTo` or `allowNull` | **137** |
| commit pushed | `git push` on dev backend | `3cd80d3..dfee5aa main -> main` |
| schema diff not run | `find /home/ubuntu -maxdepth 3 -name "dump-columns.sh"` | nothing — docs repo not on dev |

### Rebuilding 479

Clear it:

```
mysql -e "delete p from fopackaging p join formulations f on p.formulation_id=f.id where f.company_id=479; delete sm from subrecipematerials sm join fosubrecipe fs on sm.sub_recipe_id=fs.id join formulations f on fs.formulation_id=f.id where f.company_id=479; delete sf from subrecipeformulation sf join fosubrecipe fs on sf.sub_recipe_id=fs.id join formulations f on fs.formulation_id=f.id where f.company_id=479; delete fs from fosubrecipe fs join formulations f on fs.formulation_id=f.id where f.company_id=479; delete from formulations where company_id=479; delete ma from materialsagents ma join materials m on ma.material_id=m.id where m.company_id=479; delete from materials where company_id=479; delete a from customershippingadresses a join companycustomers c on a.customer_id=c.id where c.company_id=479; delete from companycustomers where company_id=479; delete from companyagents where company_id=479;" abletracelab_live
```

Reload it:

```
curl -s -X POST https://dev.mintekfoodsafety.com/api/v1/Sheet/importSheet -H "authorization: bearer $(cat ~/.s151tok)" -F "files=@/home/ubuntu/s151-onboarding.xlsx" -F "company_id=479" -F "user_id=1" | python3 -m json.tool
```

If the token has been retired, mint a fresh one: log in to dev as `info.abletrace@gmail.com` in the browser, then on dev —

```
mysql -N -B -e "select webToken from user where id = 1;" abletracelab_live | tr -d '\n' > ~/.s152tok && wc -c ~/.s152tok
```

Reads the row straight into the file. **The token never touches the clipboard.** Expect 115 bytes.

### Company 479 as it stands

| | |
|---|---|
| company | **479**, `test260901@mailinator.com`, admin is user **1335** |
| super admin | user **1**, `info.abletrace@gmail.com`, exempt from the P250 rewrite |
| schema | **`abletracelab_live`** ⚠ prod uses the same name |
| suppliers | 4 — Twin Poultry, Saputo, Snowcap, Premier Packaging |
| materials | 11, MAT-1 to MAT-11, all with 10000 opening stock |
| products | 2 — Baked Chicken `FO-0002`, Seasoning Mix `FO-0001`, both `allergen = []` |
| recipes | Baked Chicken ← Raw Chicken, Salt, Seasoning Mix. Seasoning Mix ← Ginger Powder, Salt. **No Yogurt in either** |
| customer | A Loving Spoonful, 2 addresses |

---

## THE QUEUE

**P291 — Super admin upload screen for the importer.** *S152's job.* Re-scoped by Minty's rulings at S151: super admin only, not client-facing; the company is created first on the existing screen; the importer loads four data sets into it. Model on the existing Sync Client / HACCP upload flow. Route is proven twice.

**P293 — Optional string fields reject a blank box. 137 sites.** *S153.* Waterline refuses an explicit `null` on `type: 'string'` with no `defaultsTo`. Fields marked optional on screen cannot be saved empty; the client gets a 500 with no explanation and no workaround beyond typing a dash. **Absorbs P289 and P292**, which are the two proven instances:

- **P289** — `CompanyAgents.js:124`, `remarks`. **Fix already written, committed `3cd80d3`, on dev only. Still needs prod.** Backup at `~/CompanyAgents.js.bak-s150`. ⚠ Do not lose this in the merge — it is the one piece of P293 that already exists.
- **P292** — `Formulations.js:825` and `949`, `myCode`. Backend passes `req.body.myCode` straight through, so the `null` originates in the browser. Proven at S151: blank → 500, `123` → saves.

Two approaches, decide before writing: **one change at the door** (strip nulls on incoming requests before they reach any model — the pattern already exists as `stripNulls` in `importSheet.js`), or **137 scripted model edits** adding `allowNull: true`. Claude leans to the first — one change instead of a hundred, and new fields are covered automatically. It touches every write in the app, so it needs care.

**P290 — CLOSED by Minty's ruling, S151.** Opening stock comes straight from the workbook with no PO, receipt or lot. Not deferred — decided. The current simple stock write in `importSheet.js` is the answer, not scaffolding. **Remove the scaffolding comment from the file when convenient.**

**P287 — Address duplicate-check OR-instead-of-AND fault** on the hand-entry screen.

**P285 — Phone numbers stored as `double`** on the customer table.

**P286 — Retire `mintekfoodsafety.com`** (three named dependencies). ⚠ Dev still runs on `dev.mintekfoodsafety.com`.

**P269 — Stored-procedure string interpolation vulnerabilities** (`Materials.js:137`, `Hazards.js:224`).

**P283 — Hardcoded `localhost:1338`** in `admin-formulation.component.ts:70`.

**P282 — External supplier code** on `companyagents`.

**P249 — Typing any URL logs the user out.** AuthGuard reads the NGRX store, memory only.

**P210 — Prod Node upgrade.** Prod on Node 18, dev on Node 24.

---

## TRAPS — one candidate, Claude's recommendation

**Proposed for TRAPS.md: two conventions for the same field name in one codebase.**

`allergen` must be a JSON string when written through `Materials.createMaterials` (which parses it) and a real array when written to `Formulations` (which does not). Both columns are `type: "json"`. **Waterline stores either without complaint**, so the wrong one is accepted silently and surfaces later as a frontend crash on an unrelated screen.

It meets the entry rule: it fails **silently**, and it reached a client-facing screen. It is not merely something that cost time.

**Claude recommends adding it. Minty decides.**

Note the importer's own header already documents this as trap 5 and it still caught us — which is an argument for the entry, not against it: the warning existed in the file that was being edited and was not enough.

---

## WHAT S151 GOT WRONG

Recorded because RULES §1 keeps being the rule that breaks.

1. **Claude predicted the screen never called the server.** The Network tab disproved it in one click.
2. **Claude doubted design ruling 4** on the strength of a query that had excluded the rows which would have answered it.
3. **Claude predicted the live roll-up would supply Milk** to the Details screen. It did not — because there was no Milk to supply.
4. **Claude offered to close with the fix unproven** on a one-line change ten minutes from proof. Minty pushed back. That was hedging, not caution — RULES §6 exists to stop Claude stretching past its grip on a long job, not to hand Minty a decision Claude should have made.
5. **Claude issued a command with a placeholder in it** (`<your-pem>`), which failed on the Mac. Ask for the value first.

All five were caught the same way: by measuring instead of arguing.
