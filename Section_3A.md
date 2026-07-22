# SECTION 3A — THE MODULES

> Everything that is built, organised BY MODULE — not by technology. When something breaks Minty does not think "that is a database problem", he thinks "that is a formulation problem". So each module carries its OWN front end, back end and database in ONE place.
>
> **Bridge to Section 2 (one-way):** rows point UP to Section 2's stable Logic IDs (→ §2 Logic A). Section 2 never lists where its logics are used. That is what prevents drift.
>
> **⚠ WALK STATUS.** Three modules are WALKED (3A.4, 3A.5, 3A.7) — screens seen live, verdicts assigned. Five are STUBS (3A.1, 3A.2, 3A.3, 3A.6, 3A.8) — they carry verified DATABASE facts folded from the old Section K, but their FRONT END and BACK END are marked `NOT YET WALKED`. An empty heading in a stub means nobody has looked, NOT that there is nothing there.
>
> State: folded from Section 3 (workbook) + Section K, S78. Section K RETIRED.

---

## EVERY MODULE HAS THE SAME FIVE HEADINGS

```
WHAT IT DOES   points at its logic in Section 2
FRONT END      screens, components, popups
BACK END       models, controllers, ⚠ THE LIVE PATH (JT9)
DATABASE       tables, procs, views, the columns that matter
KNOWN TRAPS    points at Section 5
```

---

## ⚠ CORRECTIONS BAKED IN AT FOLD TIME (S78) — read before trusting any older copy

```
J81   The "version-fork drops ship_qty to 0" claim is FALSE and was
      never true. Struck from K1 actions 12 and 14, from 3A.5 row 1
      (cols 7/8/9), and from the old Status sheet row 17. No "Fix A"
      is needed and no P-item exists for it. ⚠ If any pointer to
      "Fix A" survives elsewhere in the repo, it is dead — grep and
      strike it.

J82   The "MO stores an as-made allergen snapshot" claim is FALSE.
      TESTED LIVE S78 on dev co464: MO-0012 (lot Pdt-260721-2,
      completed BEFORE the edit) changed from blank to "Eggs" after
      Ginger Powder MAT-5 was edited. Allergens are read LIVE from
      the current recipe. Struck from K2 row 7 and K1 action 15.

J80   Release does NOT explode an intermediate into its raw
      materials. CONFIRMED S78 by operator observation: the release
      screen shows the intermediate as ONE line. Struck from K1
      action 16. (The intermediate's own ingredients are still
      traceable — they were drawn on the intermediate's own MO.
      Different operation, different moment. 3A.6 may correctly say
      trace explodes; release does not.)
```

---

## 3A.1 MATERIALS & AGENTS — ⚠ STUB

**WHAT IT DOES** — The inbound master data. Agents (suppliers) and Materials (the umbrella term covering both ingredients and packaging). ⚠ Kg-anchored end to end — this line never reconciles with the product units line (→ §2 Core #2, Two lines).

**FRONT END** — `NOT YET WALKED`. Known routes only: `/Manage-Materials` (list), `/Edit-Materials` (edit form, carries the Allergen List multi-select).

**BACK END** — `NOT YET WALKED`.

**DATABASE**

```
Add Agent (manual)         companyagents +1
                           Atomic. Supplier name sits in company_name.

Import Agents (Excel)      companyagents +N
                           Bulk is faithful to manual. Dedups by name,
                           so re-import is safe.

Add Material (manual)      materials +1 · materialsagents +1
                           First junction table. Material→agent link
                           lives in materialsagents, by id.
                           Allergen = JSON array in materials.allergen
                           (longtext).

Import Materials (Excel)   materials +N · materialsagents +N ·
                           companyagents +1 · purchaseorders +1 ·
                           pomaterials +N · recievedlots +N
                           ⚠ Import is NOT manual × N. It auto-creates
                           missing agents and establishes opening stock
                           through the full PO→receiving path, under one
                           dummy supplier "OBDummy". (→ §2 Logic C)

Edit Material allergen     materials.allergen updated in place; row
                           count unchanged.
                           ⚠ Invisible to count-diffs — needs a SELECT
                           to verify.
                           ⚠ AND SEE J82: this edit propagates LIVE to
                           every product using the material, and to
                           their already-completed MOs.
```

**KNOWN TRAPS** — J82 (allergen edits are live, not frozen) · §2 GR7 identity block (materials: title=name, internalCode=MAT-N) · master-record field unlocks are P10.

---

## 3A.2 PRODUCTS, FORMULATIONS & MOs — ⚠ STUB

**WHAT IT DOES** — Recipes, versions, product-in-product (intermediates), allergens, packing config, and the MO cycle: create → release → start → receive → close. → §2 Logic A (quantity model), Logic F (packing cascade).

⚠ The FORMULATION and MO-CREATE hops are already walked in **3A.5 rows 1 and 2** — this module points there rather than re-describing them.

**FRONT END** — `NOT YET WALKED` as a module. Known routes: `/Formulation` (list), `/Add-Formulation`, `/Edit-Formulation`, `/Add-MLO`, `/Edit-Mlc`, `/start-mlc`, `/Receive-product`, `/Mfg-lot-codes`, `/Production-Controller`.

**BACK END** — `NOT YET WALKED` as a module. Known: `Formulations.js` (create and fork share ONE handler, `methodForCreateFormula`, present since 2022 — J81) · `MLOManagement.js` · `ReceiveProducts.js`.

**DATABASE**

```
Add Product (manual)       formulations +1 · fopackaging +3 ·
                           fosubrecipe +1 · subrecipematerials +2
                           Packaging = flat per-level rows (→ §2 Logic F):
                           3 levels, one whd_flag=1 anchor, weight builds
                           2→10→20. batch_qty is UNITS (S41). No PO or
                           receiving — products get stock from production.

Add Intermediate           formulations +2 · fopackaging +4 ·
                           fosubrecipe +2 · subrecipematerials +3 ·
                           subrecipeformulation +1
                           Requires a full edit, which forces a version
                           fork (FO-0001 → FO-0001-2).
                           ⚠ J81: the fork CARRIES ship_qty FORWARD
                           correctly. The old "fork writes ship_qty=0"
                           claim is struck. subrecipeformulation holds
                           qty (double, Kg) and ship_qty (double, units,
                           default NULL).

Add Sub-Recipe 2           +fosubrecipe (a 2nd header row against the
                           same formulation_id) + its materials.
                           An intermediate attaches to SR1's header.

Edit recipe qty (pencil)   subrecipematerials.qty in place. NO FORK.
Edit batch_qty (pencil)    formulations.batch_qty in place. NO FORK.
                           Past MOs stay frozen (their stored batches
                           anchor them); new MOs compute off the current
                           value. Fractional batches are correct.
                           ⚠ THE FORK BOUNDARY: quantity edits do not
                           fork. Composition and identity edits do.

Full edit (composition)    formulations +1 · fosubrecipe +1 ·
                           fopackaging +3 · subrecipematerials +2 ·
                           subrecipeformulation +1
                           Version fork. Old version → status 2, new →
                           status 1, version++.

Create MO                  mlomanagement +1 · mlodetails +6 ·
                           mlcpackaging +1
                           qty = planned UNITS. Points only at the
                           current version (status_id=1). mlodetails is
                           one row per recipe line, distinguishing
                           materials (rcp_mat_id) from intermediates
                           (rcp_fo_id). Creating an MO LOCKS the
                           formulation from editing.
                           ⚠ J82: mlomanagement.allergens does NOT
                           behave as an as-made snapshot. The MO screen
                           reads allergens live from the current recipe.
                           Whether the column holds anything at all is
                           a DB question, NOT yet answered.

Start Production           mlomanagement in place: mlc_status→3,
                           release_prod_flag→1, lotCode assigned
                           (Pdt-YYMMDD-N), startDate.
                           Lot code embeds the production date.
                           Count-diff blind. Touches NO stock.

Receive Product            receiveproducts +N (one row per sub-lot)
                           Sub-lots are partial receipts of the SAME
                           lot, not separate lots. A full receipt does
                           NOT auto-close the MO.
                           → the stock effect is 3A.5 rows 5, 6, 7.

Close MO                   mlomanagement.close_status→1 in place.
                           mlc_status stays 3; quantities unchanged.
                           Reopen→reclose works cleanly.
                           ⚠ "Not finished" filters must test
                           close_status, not status ≠ 4.
```

**KNOWN TRAPS** — J81 (fork ship_qty claim, struck) · J82 (allergens live not frozen) · nested-pop two-collection trap, JT8 — never two COLLECTION associations in one populate array · mlc_status read-shape, JT1 — object on populate, bare number on proc · P10 (field unlocks) · P11 (receive product saveable with no material released).

---

## 3A.3 PO & RECEIVING — ⚠ STUB

**WHAT IT DOES** — Agent → material. Lots in. The inbound stock path for the Kg-anchored materials line.

**FRONT END** — `NOT YET WALKED`. → P6 is a full redesign of this surface (scan-to-find, auto-open, global select, ordered-qty default). ⚠ P6 says: read the existing MO-Release Global Select mechanism BEFORE designing.

**BACK END** — `NOT YET WALKED`.

**DATABASE**

```
Create PO (manual)         purchaseorders +1 · pomaterials +N
                           Links agent_id. PO status via status_id
                           (5 = Completed).
                           PO_ref_docs is a json array of
                           "<uuid>.<ext>|<name>" — ⚠ guard reads with
                           Array.isArray, never a null-check (J74/J75).

Receive against PO         recievedlots +1 per receipt
                           ⚠ Each partial receipt is a SEPARATE lot
                           (Mat-260703-13, -14). This is correct
                           food-safety granularity, not a bug.
                           Same code path as import receiving.
```

**KNOWN TRAPS** — J74/J75 (ref-doc array guards; PO crashed, others were safe only by accident of their create path seeding `[]` — a future tidy-up would reintroduce the crash) · P6 (redesign) · note the spelling `recievedlots` and `recieved_qty` throughout.

---

## 3A.4 SALES → DO → PACKING SLIP → SHIP — ✅ WALKED (S76)

**WHAT IT DOES** — The outbound chain. A Sales Order is demand only; stock does not move until a DO is created against it. → §2 Core #2 (the bucket chain), Logic J.

⚠ This module documents the SO SCREENS. The DO-create STOCK HOP — what the popup actually does to `inventory_units` — lives in **3A.5 row 8**. This section points there and does not re-describe it.

**FRONT END**

```
/Add-SO          from /SO-Management → "Create SO".
                 Fields: Customer PO No · Customer* · Shipping Address* ·
                 ref-doc upload · product lines · Remarks.
                 Product line: Product · Int.ID(Ext.ID) · Sh.Unit(#) ·
                 Quantity · Sh.Pack.
                 VERIFIED LIVE S75 — SO-0008. Anchor CLEAN: units
                 entered (10), Kg derived (200). A new SO reads
                 red/No-Shipment until a DO exists.

/Edit-SO         from /SO-Management → "Details →". Page title reads
                 "Control Chart".
                 Header: Date · Customer · Customer PO No · Internal
                 SO No · Shipping Address. Collapsible customer
                 reference document block.
                 "Order Completion Details": the SO product line with
                 DO child-rows nested beneath it (qty · product lot ·
                 receive lot · MO no · DO no · Cancel).
                 Buttons: Stock Info · Create Dispatch Order+.
                 DO-create is a POPUP, not its own route: Select
                 Available Lot → Sh.Unit(#) → Qty(Kg) derived → Save.
                 Reverse walk (cancel a DO) lives here — one bucket
                 back, up to DO/PS only.

VERDICT          SO CREATE 🟢 GREEN
                 SO DETAILS/EDIT 🟠 ORANGE (popup display bug, P27)
```

**BACK END** — `SOManagement.js` → `createNewRecord` (ref-docs guarded by Array.isArray per J75). `DispatchOrders.js` → `createDO` is the popup Save path; the screen read itself is a Waterline populate of DOs against the SO. ⚠ Line numbers were written from session notes — grep to confirm at the moment of use.

**DATABASE**

```
Create SO        somanagement +1 · soproducts +1
                 Order/intent only — no stock allocation.
                 somanagement.internalCode IS the SO number.
                 SO_Ref_No = the external ref, null on most SOs.
                 customer_ref_docs = json array.
                 soproducts.quantity stored in Kg, displayed unit-first.

Create DO        dispatchorders +1 · do_receive_products +1
                 → stock effect: 3A.5 row 8.
                 DO stores BOTH qty_to_ship (Kg) AND packing_units.
                 ⚠ do_status is stuck at "Created" — never read it.

Packing Slip     packingslips +1 · packingslipdos +1
                 Sets DO qty_shipped.
                 packingslips.vehicle_no IS the shipping reference —
                 a relabelled vehicle-number field.
                 shipping_reference_docs = json array.

Ship             packingslips.shipped_flag→1, shippingdate,
                 finalShipmentUserId.
                 The authoritative "shipped" is the PS flag.
```

**KNOWN TRAPS** — P27 (DO-create popup shows "NaN" while Shipping Units holds a partial number like "." — should render blank; same display-guard family as Defect 2) · External ID renders a literal "null", same family as P10 · P7 (PS redesign; ⚠ attaching a shipping doc to an UNSHIPPED slip silently loses the file) · dead PS block `PackingSlips.js:333-334` — DELETE at R6, never repair · blocking `alert()` throughout (P4).

---

## 3A.5 STOCK — ✅ WALKED (S75), THE SPINE

**WHAT IT DOES** — Where every quantity actually lives and moves. → §2 Core #1 (the units anchor), Core #2 (the bucket chain), GR5, Logic I.

⚠ **BOTH STOCK LINES ARE DOCUMENTED TOGETHER, DELIBERATELY.** Documented apart, a reader meets each alone and merges them in their head. Side by side, the difference is unmissable. (Minty's call, S73.)

```
CORE STOCK LINE      formulations.inventory_units
                     Per formulation. Pools across MOs. MOVES BOTH WAYS.
                     "What I have right now."

PRODUCED-TO-DATE     mlomanagement.received_units
                     Per MO, and therefore per PRODUCTION LOT.
                     ONLY CLIMBS. A progress indicator.

They bank the SAME value in the SAME receive loop, independently.
They are NOT the same quantity and must never be merged.
```

⚠ 3A.2 and 3A.4 POINT HERE for the stock hops. They do not describe them.

### THE HOP TABLE

```
VERDICT KEY   🟢 clean/correct · 🟠 works-but-fragile or display-wrong ·
              🔴 broken · ⚪ out of scope.
              A finished hop = green verdict + nothing pending.
BANDS         rows 1-5 IN (produced and arrives) · rows 6-7 THE TWO
              STOCK LINES · rows 8-12 OUT (leaves).
```

**ROW 1 · FORMULATION · 🟢 GREEN**
Anchor: `batch_qty` in SHIPPING UNITS, Kg derived (S41). The field is literally labelled "Shipping Units per Batch" — the anchor is unit-labelled at birth. `wduKgPerUnit` is the OUTPUT of the packing cascade, never hand-entered. Recipe scales by batches, packaging by units; they match only at batch size = 1 (the S42 trap).
DB: `formulations.batch_qty` (units) · `.inventory` (Kg, legacy) · `fopackaging` (whd_flag=1) · `version_number` · `status_id`
Front: 1a CREATE `/Add-Formulation` · 1b LIGHT-EDIT `/Edit-Formulation` (inline pencil, no fork) · 1c FULL-EDIT `/Edit-Formulation` (Edit → Stock gate → Save → version++) · 1d Excel upload → DEFERRED to 3A.8
Back: `Formulations.js` create and fork share one handler
⚠ **CORRECTED S78 (J81):** the old "fork must copy ship_qty forward / S45 fork ship_qty=0" pending fix is STRUCK. It was never a bug.
Mines: blocking `alert()` · nested-pop two-collection trap (JT8) — TO VERIFY still guarded

**ROW 2 · MO CREATE · 🔴 RED (plan only)**
Plan qty should be the requested UNITS stored straight; batches = units ÷ batch_qty. A plan is a PLAN — it never moves stock, because receiving takes the human count.
⚠ **DEFECT 1:** want 50 → stored 50.004. Want 10 → 10.008. The value round-trips through Batches, a starred form field. Seen live S78: MO-0007 plan reads `50.004#`.
DB: `mlomanagement.qty` (planned units)
Front: `/Add-MLO` from `/MLO-Management` → "Create MOs". Three qty fields: Shipping Units / Quantity / Batches*
Back: `MLOManagement.js` · `add-mlo.ts:204-205` builds batches
Pending: store the entered units, or carry batches at full precision → P2 item 2

**ROW 3 · RELEASE (material) · ⚪ OUT OF SCOPE**
Issues raw MATERIALS to the MO. Materials are Kg-anchored end to end — no units anchor. Kept so the cycle reads complete.
Front: `/Release-mat-details` — the SAME screen as row 12. Materials, intermediates and packaging appear in one list. From `/Edit-Mlc` → "Release Material/Product".
Back: `MaterialsProductsReleased` → V2 material branch ⚠ the live path is V2, not the single-release function beside it (JT9)
⚠ **CORRECTED S78 (J80):** release does NOT explode an intermediate to its raw materials. The screen shows the intermediate as ONE line. The old "8 lot draws / recursively exploded" claim is struck.

**ROW 4 · START PRODUCTION · 🟢 GREEN (verified)**
Advances status to 3 (Production Started) AND assigns the production lot code. Touches NO stock.
Verified live: fired Start on MO-0009 — Completed Qty 0# before and after; lot code blank → Pdt-260719-1.
DB: `mlomanagement.mlc_status` (→3) · lot code assigned at start
Front: `/start-mlc` from `/Production-Controller` → "Start". MO lists: `/Mfg-lot-codes` (Warehouse) + `/Production-Controller` (Production).
Mines: mlc_status read-shape trap — object on populate, bare number on proc, status_id on trace views (JT1)

**ROW 5 · RECEIVING · 🟢 GREEN (verified) · ⚠ THE ANCHOR SOURCE**
Finished product received in UNITS ACTUALLY RECEIVED — the human count, not the MO plan. ONE receive feeds BOTH stock lines (rows 6 and 7), same value, independently.
⚠ This hop being clean is WHY the downstream defects are display-only.
Verified live: entered 1 unit → Completed Qty 0# → 1.000# (1.390 Kg).
DB: `receiveproducts.qty` (units) · `.recieved_qty` (Kg) · `.received_at` (datetime, S65) → feeds `formulations.inventory_units` + `mlomanagement.received_units`
Front: `/Receive-product` from `/Edit-Mlc` → "Receive Product". The "Finish Production Units" block.
Back: `ReceiveProducts.js` (`+= RPOBJ.qty`)

**ROW 6 · CORE STOCK LINE · 🟠 ORANGE (display wrong)**
`formulations.inventory_units` = LIVE SOH in units. Per formulation, pools across MOs, moves both ways. The source of truth for Fix B.
⚠ `formulations.inventory` (Kg) still exists — an un-retired remnant. Retire at R6.
The STORED value is CLEAN. **DEFECT 2:** screens rebuild units as Kg ÷ weight and show float garbage. Verified live: MR dropped SOH 5#→4# — 80÷20=4 looks clean, so the garbage only surfaces on non-round divisions.
DB: `formulations.inventory_units` · `[.inventory` Kg = legacy`]` · DB VIEW `Trace_ProductHeaderView` (`_su` fields = Kg÷wgt; lives in RDS, NOT in git)
Front (bug): `/Formulation` products list → "Stock On Hand" column (`admin-formulation:878`, inventory÷wgt) · Traceability `getWduUnits`
Pending: **R5 DISPLAY SWITCH — read `inventory_units` directly, stop dividing. THE priority fix.** → P2 item 1
Mines: DEFECT 2 · `WhC_GetFormulaPackagingMaterials` must return `whd_flag` + `pack_level`, or the cascade silently reads 1/1/1 (→ §2 Logic F)

**ROW 7 · PRODUCED-TO-DATE · 🟠 ORANGE (display wrong)**
`mlomanagement.received_units` = cumulative units per MO / production lot. ONLY CLIMBS. A progressive position WITHIN the MO. Banks the same value as row 6, independently — must not merge.
Same Defect 2 on the trace side: "MO/Completed Qty" reconstructs Kg÷wgt (stored 51, displays 51.00000000000001).
DB: `mlomanagement.received_units` (units) · `.received_qty` (Kg) · `.close_status` · `.qty` (planned)
Front: Traceability "MO/Completed Qty" · MO progress chart
Pending: R5(D) — trace reads `received_units` directly (already present in the view) → P2 item 1

**ROW 8 · DO CREATE · 🟠 ORANGE (fragile route)**
Creating a DO moves units OUT of the live balance, reserved against the DO, in units. ⚠ Stock leaves `inventory_units` at DO CREATION — not at ship (J80). Verified: In Store 4→3, Allocated 0→1.
Observed: `inventory_units` 50→43 (−7), `packing_units` 7. EXPECTED route: subtract the stored 7 (R1). ACTUAL route: `qty_to_ship`(Kg) × lot ratio (R2-via-Logic-I). It lands on 43, but the route is fragile — exact only while lot ratios stay round.
DB: `formulations.inventory_units` (−units) · `dispatchorders.packing_units` (units) · `.qty_to_ship` (Kg)
Front: `/Edit-SO` → "Create Dispatch Order" POPUP (not its own route). Field "Shipping Units*" with Qty(Kg) derived.
Back: `DispatchOrders.js` → `createDO`
Pending: subtract stored units instead of Kg × ratio → P2 item 3
Mines: P27 (NaN flash in this popup) · Logic-I fragility · JT9

**ROW 9 · PS CREATE · 🟢 GREEN (by design)**
Creating a PS carries reserved units forward from the DO. Does NOT touch `inventory_units` — the stock already left at DO creation. R1 by design.
Verified: `inventory_units` 43 UNCHANGED. Anchor visible on screen: "Order Qty (Units)" = 1# (20 Kg).
DB: `dispatchorders.qty_shipped` (units) · `somanagement` · does NOT write `inventory_units`
Front: `/Create-Packslips` from `/Dispatch-orders` → "Create Packing Slip" → DO-select popup
Back: `PackingSlips.js` → `createPS`
⚠ Mine: DEAD PS BLOCK at `PackingSlips.js:333-334` (NaN, Kg-only, dead code) → **DELETE at R6. Do NOT repair.**

**ROW 10 · SHIP · 🟢 GREEN**
Shipping is a TERMINAL status flip. Touches NO stock. There is no un-ship. The reverse walk goes back one bucket at a time, only up to PS/DO — never through ship.
Verified: `inventory_units` 43 UNCHANGED; `editPackslips` sets the flag only.
DB: `packingslips.shipped_flag` (bool) · no inventory write
Front: `/Edit-Packslips` → "Ship" button, from `/Dispatch-orders` → "Shipped Packing Slip". ⚠ NOT `/Create-Packslips`.
Back: `PackingSlips.js` → `editPackslips` (the ONLY write path on that screen)
Mines: J16 (terminal, no un-ship) · P7 (⚠ attaching a doc to an unshipped slip loses it)

**ROW 11 · MR (MISC RELEASE) · 🟠 ORANGE (record Kg-only)**
Misc Release pulls stock OUT direct from SOH — NOT part of the DO/PS chain. One-way write-off. It is ALSO the onboarding induction burn-down mechanism (→ §2 Logic C).
MR = write-off, leaves the system. RETURN = back to store, MO-linked (S59).
Verified live: a 1-unit / 20-Kg reject dropped SOH 5#→4#.
⚠ But the RECORD is Kg ONLY — MR-0004 stored 20.000 Kg with no units column. Units are entered on the form and dropped from the record (an R3 residual). Return qty is likewise Kg-only.
DB: `formulations.inventory_units` (−units) · `rejectmaterialandproduct.qty_rejected` (Kg ONLY)
Front: three screens — `/Reject-products` (form) · `/Rejected-material/product` (list) · `/Edit-reject-product` (details, carries Returned Qty)
Back: `RejectMaterialAndProduct` → `createNewRecord`
Pending: re-anchor the MR write path so the record stores units; add a units column → P2 item 3

⚠ **MR is shared with the MATERIALS side.** `rejectmaterialandproduct` is ONE table serving both: for a product write-off `material_id` and `recievedlot_id` are NULL; for a material write-off both are SET (lot-specific). The reason text comes from `miscellaneous_reason`.

**ROW 11b · MATERIAL RETURN · (companion to MR, not a product-stock hop)**
A production-context return: material was released to an MO and goes BACK to store. ⚠ This is NOT a return to the supplier. Links `mlc_id` → the MO. It is the symmetric inverse of release — net consumption = released less returned, and material trace NETS it correctly (Released shows 40 after a 10 return, with the return visible as an audit line).
DB: `returnmaterialproduct +1` · `returnmpreceivelots +1`
⚠ Return qty is Kg-only, same residual as MR above (S59).

**ROW 12 · INTERMEDIATE RELEASE · 🟢 GREEN (R1-effective)**
An intermediate product consumed BY a parent MO — stock leaves the intermediate's OWN `inventory_units`. Same units anchor (intermediate is a ROLE, not a type). The third bucket-chain exit: SOH → parent MO.
Verified live: releasing intermediate `testpdt260703` into MO-0009 dropped its WH Stock to 38.880 Kg. Per-lot Logic-I ratios visible. Exact on a clean ratio → R1-effective.
DB: `formulations.inventory_units` (−units, the intermediate's own) · `subrecipeformulation.qty` (Kg) · `.ship_qty` (units, default NULL)
Front: `/Release-mat-details` — the SAME screen as row 3. The intermediate is one line in the shared release list.
Back: `MaterialsProductsReleased` → `createReleaseMaterialProductsV2` ⚠ V2 is the live path (JT9)
⚠ **CORRECTED S78 (J80):** the intermediate releases as ONE line. Its own ingredients are NOT drawn here — they were drawn on the intermediate's own MO when it was made.
Pending: subtract stored units to drop the Logic-I fragility → P2 item 3

### STATUS

```
🟢 GREEN      rows 1, 4, 5, 9, 10, 12
🟠 ORANGE     rows 6, 7, 8, 11
🔴 RED        row 2
⚪ OUT        row 3

OPEN, in priority order
  R5 display switch (rows 6, 7)     THE priority fix → P2 item 1
  Defect 1, MO create (row 2)       → P2 item 2
  Subtract stored units (8, 11, 12) → P2 item 3
  MR record Kg-only (row 11)        → P2 item 3
  Delete dead PS block (row 9)      → at R6
  Retire formulations.inventory     → P2 item 4 / R6
  Back-end LINE NUMBERS everywhere  ⚠ written from notes, never read
                                    from live code. Grep at moment of use.
  Trace_ProductHeaderView switch    ⚠ lives in RDS, not git
  Excel upload (row 1d)             → deferred to 3A.8
```

⚠ **CLOSED S78, no longer open:** the row-1 "S45 fork ship_qty=0" item. It was never a bug (J81).

---

## 3A.6 TRACEABILITY — ⚠ STUB

**WHAT IT DOES** — Forward and backward trace. Product trace reconciles produced against shipped, released and on-hand. Material trace walks a lot back to its supplier. Read-only — writes nothing.

**FRONT END** — `NOT YET WALKED`. ⚠ This module holds the display side of Defect 2 (→ §2 GR5 R5-C/D). Known: `getWduUnits` rebuilds units as Kg÷wgt and must switch to reading stored units.

**BACK END** — `NOT YET WALKED`.

**DATABASE**

```
Product Traceability       none — READ ONLY
                           Reconciles: Produced 10 = Shipped 5 +
                           Misc Release 1 + On Hand 4.
                           Forward → customer. Backward → ingredient
                           lots + suppliers, with the intermediate
                           EXPLODED, packaging included.
                           ⚠ Trace exploding an intermediate is CORRECT
                           and does not contradict J80. Release does not
                           explode; TRACE does. Different operation.

Material Traceability      none — READ ONLY
                           Return is correctly NETTED: Released shows
                           40 (50 less a 10 return), SOH reconciles,
                           and the return appears as an audit line.
                           Proc: Trace_MaterialDetails_SP.

Trace_ProductOneStepForward_SP     ⚠ DB PROC — RDS ONLY, NOT IN GIT.
                           S50 corrected two SELECT expressions feeding
                           the "SO Number - Customer Shipping Ref" column:
                             so_number        → somanagement.internalCode
                                                (was SO_Ref_No, null on
                                                most SOs)
                             customer_ship_ref → packingslips.vehicle_no
                                                (was somanagement.internalCode)
                           Both tables were already joined in the proc.
                           This CONFIRMS the schema note that
                           packingslips.vehicle_no IS the shipping ref.
                           Saved: /home/ubuntu/fix-onestepforward-S50.sql

Trace_ProductHeaderView    ⚠ DB VIEW — RDS ONLY, NOT IN GIT.
                           Its _su fields compute Kg÷wgt. This is the
                           R5 switch point for the display fix, and
                           nobody has yet identified exactly where.
```

**KNOWN TRAPS** — ⚠ DB-only objects are NOT in git; the log is their only record (→ §2, stored-proc discipline; Section 0 rule 4.8) · Defect 2 display side · P19 (trace PDF cuts a row across a page break — cosmetic, a known limitation, real fix is section-aware capture).

---

## 3A.7 FOOD SAFETY — ✅ WALKED (S76)

**WHAT IT DOES** — → §2 Logic B. FSMA four preventive controls + HACCP. Two halves: **PROCEDURES** (the document library, Part 1) and **HACCP** (the plan, Part 2 — a three-stage forward-narrowing cascade that links back into Procedures).

⚠ **OWNERSHIP (settled S78).** The document library belongs to the CLIENT ADMIN. They create, edit and add their own procedures, and they own the HACCP plan. Super Admin only SEEDS an initial set as a convenience — templates to kickstart a new client, so they are not staring at an empty library on day one. Rows can therefore arrive TWO ways: created by the client, or seeded once by Super Admin (→ **3A.8** owns the sync mechanism). ⚠ The Records tab is NOT YET BUILT.

⚠ "Walked" means the screen flow was seen. It is NOT a DB or trap verification.

**FRONT END**

```
ENTRY            /AdminHome → "Food Safety System" tile →
                 /food-safety-system → two tiles: Procedures + HACCP.
                 Nav is data-driven (→ §2 Logic E): FS = role 7,
                 task id 22.
                 ⚠ The FS tile is NOT gated by food_safety_enabled —
                 that gate is not built (Feature A, P9).

PROCEDURES LIST  /documents, titled "PROCEDURES". 🟢 WALKED
                 Cols: Title · Type · Section · Sub-Section · Version ·
                 Version Date · Lead · Backup · Log + pencil-edit.
                 Buttons: Upload Procedure · Create Procedure ·
                 Download Document Template.
                 Rows show BOTH Procedure and Record types. Sorted A→Z.
                 ⚠ Logic B wants this labelled "Documents", not
                 "Procedures".

PROCEDURE        /documents/create → "PROCEDURE DETAILS".
CREATE/DETAILS   🟠 WALKED but NOT J78-VERIFIED
                 Fields: Procedure Name* · Type* (Procedure/Record) ·
                 Lead* · Created By · Section · Backup* · Created Date ·
                 Sub Section · Read Access · Last Edited · Reason for
                 Change* · Version# · Uploaded Files · Version History.
                 Saves to /documents/{id} with Back · Download PDF · Edit.

HACCP LIST       /haccp-component, titled "HACCP Plans". 🟢 WALKED
                 Cols: Product Line · Version No (Date) · Authorized By ·
                 Log. Product Line links into the plan.

HACCP CREATE     /create-haccp — ONE route, three stages via Next.
                 🟠 WALKED but traps not verified
                 S1 Hazard Identification & Analysis: header (Product
                    Line* · Version* · Log* · Authorized By* ·
                    Signature*) + Download Template/upload.
                    Scoring: Significance = Severity × Probability;
                    =1 → NS, >1 → S. Row: Step · hazards · Hazard Type ·
                    Likelihood · Severity · Total (auto) · S/NS (auto) ·
                    PRP/GMP control.
                 S2 CCP Determination: ONLY significant rows carried
                    forward. Q1–Q4 Codex tree → CCP Y/N auto +
                    Preventive Controls dropdown.
                 S3 HACCP Plan: the CCP table — CCPs · Sig Hazard ·
                    Hazard Type · Critical Limit · Monitoring Proc ·
                    Corrective Action Proc · Verification Proc ·
                    Records.
                    ⚠ Stage 3 links back into Procedures at FOUR points.
                    That linkage is the module's spine.
```

**BACK END** — `Documents.js` (list read; `addDocument` → `FS_upd_Documents_SP`, BOUND since d3104ea) · `Hazards.js` (`getHazardById`, list, `addHazard`). ⚠ `addHazard` inserts the three stages in PARALLEL — ids land in completion order, so reads MUST `ORDER BY step` (JT3).

**DATABASE**

```
Add Procedure (manual)     documents +1
                           Full SOP structure; versioned.
                           documents.editorContent = LONGTEXT CKEditor
                           body. ⚠ A pasted image is ~840KB base64.
                           documents.documents = json array of files.
                           WRITE proc = FS_upd_Documents_SP.

Procedures list read       FS_Documents_SP / FS_DocumentsByType_SP
                           ORDER BY LOWER(title) — the A→Z sort holding.

HACCP save                 hazardidentification +21 · ccpdetermination +2 ·
                           haccpplan +1 · hazards +1
                           The 3-stage narrowing 21→2→1 (all hazards →
                           significant → CCP). Scoring and the Codex
                           4-question tree compute correctly.
                           ⚠ `step` is the AUTHORITATIVE order. Ids are
                           NOT.

HACCP edit (editHazard)    Per-stage UPSERT (update if the row id is
                           found, create if not) + DELETE of rows not
                           sent back. hazards.version +1.
                           ⚠ See KNOWN TRAPS — this is fragile.

Hazard Type lookup         hazardtype (per-company table)
                           Feeds the Hazard Type dropdown, data-driven.
                           Physical / Chemical / Biological + "None"
                           (id 74) are GLOBAL rows (company_id NULL) and
                           show for every company. Clients can add their
                           own company-scoped types.
                           hazardType is stored as an FK id on EVERY row
                           of all three HACCP stages.

Global Procedure Sync      documents +40 — ⚠ the MECHANISM lives in 3A.8.
                           Rows arrive here; Super Admin drives it.
```

**KNOWN TRAPS**

```
⚠ P18 HACCP EDIT CASCADE — FOOD-SAFETY-CRITICAL, OWN SESSION, DO NOT
  BUNDLE. The three stages are chained by a FOUR-FIELD COMPOSITE MATCH
  (step + processFlow + hazard + hazardType), NOT a stable id.
  SAFE TODAY: edit existing rows in place, append at the END.
  NOT SAFE: insert a row mid-sequence, or change the hazard type on a
  saved row — either can silently duplicate or drop rows across stages
  2 and 3. Step numbering is append-only and does not renumber.
  Backend delete blocks assume all three stage arrays are always sent
  and throw if one is omitted.

⚠ J78 DOCUMENT SAVE — THE MOST TRAP-DENSE WRITE PATH IN THE APP.
  NOT YET VERIFIED. The S76 walk saved a document named "h" with reason
  "1" — that exercised NEITHER an apostrophe NOR a pasted image.
  A green toast is not a clean editorContent (JT12).
  ⚠ REGRESSION PAIR: document save must ALWAYS be tested with BOTH
  (1) text containing an apostrophe and (2) a pasted image. Fixing
  either alone has broken the other TWICE.

⚠ JT3 ORDER BY step — NOT VERIFIED. A single-row test cannot reveal a
  scramble; it needs a multi-step plan or a proc read.

Other: Download = Excel with a type="button" bug (J35), not seen this
walk · blocking alert() throughout (P4) · P14 (the S53 download blocks
need splitting — design → Section 4, mechanics → here).
```

---

## 3A.8 SUPER ADMIN — ⚠ STUB

**WHAT IT DOES** — Onboarding, global procedures, client guides, licences, roles. The operator's own surface, not a client's. → §2 Logic C (bulk import), Logic D (procedure sync), Logic E (roles), A7 (licence lifecycle).

⚠ Super Admin is a row in the `super_admin` table (user_id + active) — **NOT** `role_id=1`.

**FRONT END** — `NOT YET WALKED`. Known: the Client Guides tile shipped S66/S67 (eight PDFs, gated behind login, delivered as separate per-module downloads to protect IP).

**BACK END** — `NOT YET WALKED`.

**DATABASE**

```
Super Admin login          none — READ ONLY
                           Reads user + super_admin. Verifies a
                           salted-MD5 password. ⚠ Cannot be
                           hand-generated without the plaintext.

Add Company + accept       company +1 · user +1 · company_users +1 ·
invite                     company_user_role +1 · company_user_task +5 ·
                           companyallergens +11 · licensehistory +2 ·
                           unitmeasurement +8
                           ⚠ An 8-TABLE CASCADE. The invite ALONE writes
                           nothing — company and user are created only
                           when the invitee sets a password (2-step).
                           Auto-seeds per company: 11 allergens + 8 UOMs.
                           Licence writes 2 rows (create → trial).

Add User (sub-user)        user +1 · company_users +1
                           Immediate write, unlike the company invite.
                           No role rows — roles are assigned separately.

Assign roles               company_user_role +N · company_user_task +N
                           Master → a role row (is_master=1).
                           Sub → a role row + per-feature task grants.

Remove role                company_user_role −N ⚠ HARD DELETE.
                           Proven by an id gap. No soft-delete here,
                           and no orphans result.
                           ⚠ This is the ONE hard delete in the app —
                           everything else soft-deletes (A18).

Add Customer (manual)      companycustomers +1 ·
                           customershippingadresses +2
                           An independent branch. One address is the
                           minimum; each shipping point is one row.

Import Customers (Excel)   companycustomers +N ·
                           customershippingadresses +M
                           Clean — no PO or receiving, since customers
                           are non-stock. Expands $-delimited shipping
                           lists.

Global Procedure Sync      documents +40 (written INTO the client company)
(→ §2 Logic D)             SA → Global Procedures → Sync Client → target.
                           Reports "40 synced, 0 skipped" — skipped means
                           deduped by title. Incremental.
                           ⚠ Resolve the target user with
                           find().sort().limit(1), NEVER findOne()
                           (which throws on more than one row).
                           ⚠ Works even with food_safety_enabled=0,
                           because Feature A is not built (P9).
                           ⚠ THIS IS A SEEDING CONVENIENCE. The client
                           owns the documents afterwards → 3A.7.

Multi-master importer      → §2 Logic C. "Excel is dumb, the app is
(1d, deferred from 3A.5)   smart." Four sheets: Agents, Materials,
                           Products, Customers. Upload order matters:
                           Agents → Materials → Products → Customers.
                           Recipes are materials-only; sub-recipes capped
                           at 2. ⚠ INTERMEDIATES ARE ADDED MANUALLY
                           IN-APP AFTER UPLOAD — a deliberate original
                           build shortcut, a settled decision, NOT a gap
                           to fix.
                           Table writes: see 3A.1 (Import Materials)
                           and above (Import Customers).
```

**KNOWN TRAPS** — P9 (Feature A: the `food_safety_enabled` DB column exists but the Waterline model attribute does not, so ⚠ the toggle write is SILENTLY DROPPED — J20/JT2, one line to fix) · licence statuses 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive, and ⚠ only Inactive blocks login, Expired keeps access · role ids Admin=2, Food Safety Controller=7 · P13 (finish Glutenull onboarding) · A18 (always soft delete; server-side eligibility; one bad row never aborts a batch).

---

**END SECTION 3A**
