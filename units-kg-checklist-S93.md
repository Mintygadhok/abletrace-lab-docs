# S93 — UNITS / Kg VERIFICATION CHECKLIST

Every screen that displays a units figure derived by dividing Kg.
Organised by SCREEN, not by file, so it can be walked in one pass.

---

## THE TEST — no code reading needed

```
CORRECT      5# (100 Kg)        units OUTSIDE, Kg in brackets
WRONG        5.000 Kg (0.25#)   inverted AND the unit count is divided

THREE THINGS TO CHECK IN EACH CELL
  1  Is the units figure OUTSIDE the brackets?
  2  Is the label on the outer figure "#", not "Kg"?
  3  Does the units figure MATCH REALITY? A figure far too small
     (0.25 where 5 was shipped) is a units-stored value being divided.

⚠ THE FIXTURE MATTERS. Use a product whose Kg-per-unit is NOT 1.
  testpdt260703 on dev is 20 Kg/unit — a 20x error, unmissable.
  Glutenull's Fruits & Nut bars are 0.32 Kg/unit.
  On a 1:1 product every one of these tests passes falsely.
```

---

## 1 — CONFIRMED BUG, verified on screen S93

```
SCREEN     /Dispatch-orders → "Shipped Packing Slip" → Shipped PS list
COLUMN     Qty Shipped / Qty Plan
SEEN       DO-0001   Qty Shipped  5.000 Kg (0.25#)      ⚠ WRONG
                     Qty Plan     100.000 Kg (5#)       ✓ right
           DO-0003   Qty Shipped  1.000 Kg (0.05#)      ⚠ WRONG
                     Qty Plan     20.000 Kg (1#)        ✓ right
TRUTH      DO-0001 shipped 5 units = 100 Kg. Identical to plan.
CODE       dispatch-orders.component.html:117 passes
           Refer_PS[0].shipped_qty — UNITS-stored — into
           getShippingUnit() at dispatch-orders.component.ts:145,
           which divides by wgt_kgs_per_unit.
           html:121 passes qty_to_ship (Kg) into the SAME helper and is
           therefore correct. One helper, one caller right, one wrong.
CORROBORATED  Trace_ProductOneStepForward_SP MULTIPLIES shipped_qty by
           wgt to get weight. GR7 also says qty_shipped is UNITS.
⚠ LIVE ON PROD. Customer-facing shipping screen.
FIX SHAPE  read shipped_qty directly; derive Kg by MULTIPLYING; and
           correct the inverted format to N# (M Kg).
                                                            → P92
```

---

## 2 — HIGH CONFIDENCE, expect the same fault. Verify then fix.

```
SCREEN     /Formulation (products list)
COLUMN     "Stock On Hand"
CODE       admin-formulation.component.ts:878
           element.inventory / packing.wgt_kgs_per_unit
WHY WRONG  divides the OLD Kg column while inventory_units holds the
           correct value. GR5 names this one explicitly.
CHECK      compare against Stock Info popup, which reads
           inventory_units correctly (stock-info.component.ts:188).
           ⚠ IF THE TWO DISAGREE, the list is wrong and the popup right.

SCREEN     /Edit-Mlc → Completed / Finish Production block
CODE       edit-mlc.component.ts:298
           mlcDetails.received_qty / fopackaging_wgt_kgs_per_unit
WHY WRONG  mlomanagement.received_units holds the true unit count.
CHECK      does the completed units figure carry float garbage
           (51.00000000000001) or an ugly fraction?

SCREEN     /Edit-MLO → same block
CODE       edit-mlo.component.ts:251                    same fault

SCREEN     /start-mlc → same block
CODE       start-mlc.component.ts:155                   same fault

SCREEN     Product Traceability (main)
COLUMN     produced / received figures
CODE       product-traceability.component.ts:109 and :161
           item.received_qty / wgt          (both divide)
           ⚠ note :107 and :159 MULTIPLY and are correct — the two sit
             side by side in the same loop.

SCREEN     /Add-MLO → Intermediate Product block, stock line
CODE       add-mlo.component.html:87
           getWduUnits(batch_qty, formulation_id.inventory, wgt)
WHY WRONG  passes the Kg inventory column, not inventory_units.
```

---

## 3 — SHARED HELPERS, one pattern, five screens

```
All five call the same shape:
    (qty / batch_qty) * (batch_qty / wgt_kgs_per_unit)
batch_qty CANCELS. It is qty / wgt wearing a disguise.   → J83

  /Mfg-lot-codes            mfg-lot-codes.component.ts:129
  /Production-Controller    production-controller.component.ts:253
  /MLO-Management           mlo-management.component.ts:164
  Closed MOs                closed-mlcs.component.ts:215
  DO create popup           add-dispatch-v2.component.ts:121
  Receive popup             mlo-list.component.ts:173

⚠ WHAT MUST BE ESTABLISHED FIRST: what each CALLER passes in. If it
  passes a Kg field the division is correct. If it passes qty,
  received_units or shipped_qty it is the same bug as item 1.
  ⚠ mlo-management:176, production-controller:258 and
    mfg-lot-codes:135 MULTIPLY and are correct. The divide and the
    multiply sit in adjacent functions in every one of these files.

CHECK ON SCREEN: the planned and completed columns on each of those
five lists. Apply the three-part test. Any inverted or absurdly small
units figure is the fault.
```

---

## 4 — NEEDS A SCHEMA ANSWER BEFORE ANYONE TOUCHES IT

```
qty_allocated — IS IT Kg-STORED OR UNITS-STORED?
GR7 does not carry it. Four sites divide it:

  product-traceability-details.component.html:352 and :383
      getIntWdu(item.qty_allocated, batch_qty, wgt)
  Trace_ProductOneStepBackwardIP_SP    qty_allocated / wgt
  Trace_ProductOneStepForwardIP_SP     qty_allocated / wgt

⚠ If units-stored, all four are bugs. If Kg-stored, all four are fine.
  One question, four outcomes. Answer it before editing any of them.
                                                            → P93

quanity_shipped_to_date — SAME QUESTION (note the misspelling)
  add-dispatch.component.ts:72 divides it by wgt.
  GR7 does not carry it. P62 already wants this column looked at.
```

---

## 5 — DATABASE. Not reachable by any file grep.

```
Trace_ProductHeaderView          SEVEN divisions, one per _su field
    qty_produced_su · qty_misc_release_su · intermediate_prd_su ·
    qty_packing_slip_su · qty_do_su · SOH_su · qty_shipped_su
⚠ CONTAINS NEITHER inventory_units NOR received_units. The fix is an
  ALTER to carry them, not a repoint. RDS only, NOT in git — needs a
  JR entry or it is lost on rebuild.
⚠ 3A.5 row 7 claims the columns are already there. MEASURED FALSE S93.
                                                            → P90

Trace_ProductProdLotView         ONE division: received_qty / wgt
⚠ AND IT ALREADY SELECTS received_units IN THE SAME VIEW.
  ▶ THE EASIEST FIX IN THE WHOLE LIST. The right value is in hand.
                                                            → P91

CLEAN, verified S93, no action: Trace_MaterialDetails_SP ·
Trace_ProductOneStepForward_SP · WhC_GetAllRejectedList_SP ·
WhC_GetFormulaPackagingMaterials · WhC_GetMoDetails_SP ·
WhC_GetMoPackagingConfiguration_SP · WhC_GetMoProductReceivingDetails_SP

Full text: db-definitions-S93.txt in the docs repo.
```

---

## 6 — LEGITIMATE. DO NOT "FIX" THESE.

```
MATERIALS ARE Kg-ANCHORED END TO END. There is no units anchor on the
materials line, so dividing is the only route available.
  material-traceability-details.component.ts:169 and :170

Kg-STORED FIELDS BEING DIVIDED — correct by definition:
  add-dispatch.component.ts:71        data.quantity      (soproducts, Kg)
  add-dispatch-v2.component.html:12   data.quantity      (Kg)
  edit-sales-order.component.ts:393   elem.quantity      (Kg)
  dispatch-orders.component.html:121  qty_to_ship        (Kg)

SCHEMA GAP, NOT A CODE BUG — the column has no units to read:
  rejected-materials.component.ts:154     qty_rejected is Kg-ONLY
  reject-product.component.html:34        same
  ▶ The real fix is a units column on rejectmaterialandproduct.
    → 3A.5 row 11, P2 item 3.

A SLASH THAT IS NOT A DIVISION — display text in a template literal:
  edit-mlc:126 · edit-mlo:454 · add-mlo:423 ·
  edit-closed-mlcs:209 · start-mlc:120
  `${wgt} ${unit} / ${title}`  renders as "2 Kg / Sugar".

⚠ NEVER TOUCH: PackingSlips.js editPackslips ~325-336. Live code that
  THROWS, and the throw is the only thing preventing three worse bugs
  behind it. → P35, §2 TO BE VERIFIED item 5.
```

---

## 7 — WRITE PATHS. Different risk. Not part of a display sweep.

```
add-dispatch.component.ts:150        writes packing_units by dividing Kg
add-dispatch-v2.component.ts:194     same
  → 3A.5 row 8, already documented as "fragile route". Exact today only
    while lot ratios stay round.

⚠ P89 — batches ROUNDING REACHES MATERIAL RELEASE.
  mlomanagement.batches is stored rounded to 3 places and multiplied
  out at release-mat-details.component.ts:1071 / 1083 / 1095 to compute
  how much material is issued to the floor. This MOVES REAL STOCK.
  Separate job, separate ruling. Not a display fix.
```

---

## SUGGESTED ORDER FOR THE NEXT SESSION

```
1  P92        the confirmed bug. Customer-facing, live on prod.
2  P91        Trace_ProductProdLotView. Data already in the view.
3  P93        settle qty_allocated. One answer unlocks four sites.
4  SECTION 2  walk items in 2 and 3 above on screen, in one pass,
              on a 20 Kg/unit product. Confirm before editing.
5  P90        strike the false claim in 3A.5 row 7.
6  P89        Minty's ruling. Moves stock.

⚠ EVERY FIX COPIES ONE OF THE TWO KNOWN-GOOD PATTERNS:
    frontend   PopUps/stock-info.component.ts:188
               reads inventory_units, MULTIPLIES to derive Kg
    SQL        Trace_ProductOneStepForward_SP
               psd.shipped_qty * fop.wgt_kgs_per_unit AS weight,
               psd.shipped_qty                        AS units
  Do not invent a third.
```
