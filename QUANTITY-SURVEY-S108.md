# QUANTITY SURVEY — S108

What was surveyed, what needs fixing, and what the fix is.
⚠ A REFERENCE NOTE, NOT A WORKING FILE. It is not read at session
  open. Anything a session must act on belongs in PLAN.
⚠ Written S108, 7 Aug 2026. Evidence: S108-SURVEY-RECORD.md.

---

# 1 · WHAT WAS SURVEYED

```
DATABASE — COMPLETE
  35 stored procedures and 9 views listed from information_schema.
  11 touch a per-unit weight. All 11 accounted for.
  12 candidate objects read in full.
  ✓ THE DATABASE HALF IS BOUNDED. No unexamined hiding places.

SCHEMA — COMPLETE
  Every table holding a quantity column listed from the schema
  itself, not from code. 27 found.
  ⚠ THIS PASS EXISTS BECAUSE returnmpreceivelots WAS LOAD-BEARING AND
    ABSENT FROM EVERY DOCUMENT. A routine survey finds only what a
    procedure references.

FRONTEND — COMPLETE
  56 files, 185 references. Swept for direct divisions AND for helper
  functions called from templates.
  ⚠ AN EARLIER SWEEP OF THREE SPELLINGS RETURNED 49 FILES. Adding
    `per_unit` and `kg_per` FOUND SEVEN MORE — edit-material,
    add-materials, view-material, Models/Formulation.ts and others.
    ▶ THE THREE-NAME SWEEP WAS UNDER-REPORTING. Sweep wide, then read.

LIVE TEST — ONE, ON DEV
  A material return on MO-0011, company 464.
  ⚠ IT PRODUCED THE TWO WORST FINDINGS OF THE DAY. Neither would have
    come from reading code.
```

## THE METHOD, SO IT CAN BE REUSED

```
SWEEP 1  find divisions
  REGEXP '/[^*]{0,40}wgt_kgs_per_unit'
  ⚠ AN EARLIER PATTERN REQUIRED WHITESPACE AFTER THE SLASH AND MISSED
    `qty_allocated/fo2.wgt_kgs_per_unit`. It reported a dividing
    object as clean. THE CONTROL PASSED WHILE THE PATTERN WAS WRONG —
    a control proves the pattern matches what it was built on, and
    nothing about shapes the author did not imagine.
  ▶ OVER-REPORT BY DESIGN. A false hit costs one read; a false clean
    costs a defect.

SWEEP 2  find unserved stored columns
  For each object: does it mention a table carrying a stored unit
  column, and does it mention that column?
  ⚠ PRODUCES CANDIDATES, NOT FINDINGS. It cannot tell a join for a
    lot code from a join for data. Trace_ProductProdView was flagged
    and cleared — it joins mlomanagement inside an IN subquery.

SWEEP 3  the schema pass
  Every table with a column matching qty / quant / units / inventory.
  ▶ CATCHES TABLES NO PROCEDURE REFERENCES.
```

---

# 2 · WHAT REQUIRES A FIX, AND WHAT THE FIX IS

## ⚠ GROUP A — INTERMEDIATE PRODUCT. SIX FINDINGS, ONE ROOT CAUSE.

⚠ MINTY, S108: an IP is a product — formulation in units, release in
units, stored in units, with bound Kg. J53 already holds the domain
rule: "intermediate" is a ROLE, NOT A TYPE.

```
A1  WhC_GetMoIntermediateProducts_SP     serves subrecipeformulation.qty (Kg)
A2  WhC_GetFormulaIntermediateProducts   serves qty AND formulations.inventory (Kg)
    FIX  add ship_qty and inventory_units to the SELECT lists.
    ✓ NO SCHEMA CHANGE. Both columns exist and hold correct data —
      ship_qty since 2022 (J81), inventory_units since S46 (JR2).
    ⚠ An alias change rides with it, so a FRONTEND BUILD is involved.
    ⚠⚠ THE SCREEN SHOWS THE IP TWICE FROM TWO SOURCES — the
      Intermediate Products block (these procedures) and the Batch
      Materials block (the JS cascade, A6). FIXING ONE LEAVES ONE
      SCREEN DISAGREEING WITH ITSELF. BOTH OR NEITHER.

A3  mprrecievelots       has NO unit column       (release side)
A4  returnmpreceivelots  has NO unit column       (return side)
    FIX  ALTER TABLE ... ADD COLUMN <name> double DEFAULT 0
         ⚠⚠ TRAPS 3 — declare in the Waterline attributes IN THE SAME
           BREATH or every write is SILENTLY DROPPED (J18/J20).
         ⚠ BOTH TABLES TOGETHER. Release in units and return in Kg
           makes the two sides of one movement unreconcilable —
           WORSE than today.
         ⚠ DOUBLE, NOT INT. Fractional units are permitted (J88).
    ✓ NO BACKFILL. Zero product allocations on either live client;
      zero product returns anywhere. MEASURED.

A5  Trace_ProductOneStepBackwardIP_SP    divides qty_allocated
    Trace_ProductOneStepForwardIP_SP     divides qty_allocated
    WhC_GetMoMaterialProductReleaseDetails_SP   no unit column served
    WhC_GetMoMaterialProductReturnDetails_SP    no unit column served
    FIX  repoint / add the new column, once A3 and A4 exist.

A6  Formulations.js getFormulaByIdForReleaseMaterial
    FIX  serve the unit figure so the Batch Materials block agrees
         with the Intermediate Products block.

A7  THE REQUIREMENT CALCULATION — MINTY'S RULING, S108
    TODAY  formulation.qty × mlcDetails.batches   ⚠ ROUNDED COLUMN
    FIX    ship_qty × (MO quantity ÷ batch_qty), COMPUTED LIVE
    ⚠ WORKED EXAMPLE: batch needs 0.5 units of the IP, batch makes 6
      shipping units, MO is 7 → 7/6 × 0.5 = 0.5833 units.
    ✓ PACKAGING ALREADY DOES THIS, TEN LINES AWAY IN THE SAME FILE:
      cascadeQty × mlcDetails.qty. THE PRECEDENT EXISTS.
    ⚠ FRACTIONAL IS CORRECT. DO NOT ROUND.
    ⚠ NEVER READ mlomanagement.batches — it is that division already
      rounded.
```

## ⚠ GROUP B — DEFECTS BESIDE THE ACROBATICS

```
B1  ⚠⚠ Formulations.js — RETURNS ARE ADDED TO THE RELEASED TOTAL.
    Three branches (materials, intermediates, packaging), same shape:
      sum = sum + qty_allocated      release
      sum = sum + qty_return         ⚠⚠ RETURN, ADDED TO THE SAME SUM
      released_qty  = sum            includes returns
      returned_qty  = returnSum      ⚠ DECLARED, NEVER ASSIGNED = 0
      remaining_qty = sum - 0
    ▶ RETURNING MATERIAL MAKES THE SCREEN SHOW **MORE** RELEASED.
    ✓ MLOManagement.js does the identical job CORRECTLY. The proof is
      in the other file.
    ⚠⚠ LIVE ON BOTH CLIENTS — it fires on MATERIAL returns.
    ⚠ NOT CONFIRMED which component consumes released_qty /
      remaining_qty. ▶ ONE GREP BEFORE ANY PATCH.
    FIX  returnSum = returnSum + qty_return; remaining = sum - returnSum.

B2  ⚠ ReturnMaterialProduct.js — TRAPS 3, LIVE.
    The write sets `status`; the model declares no status attribute,
    so Waterline discards it. The read then FILTERS ON status:"Active".
    ▶ A filter on a value the write never stores. The return history
      list likely shows nothing.
    FIX  declare the attribute. ⚠ SEPARATE COMMIT — different subject.

B3  ⚠ ReturnMaterialProduct.js:68 — THE PRODUCT RETURN ADDS BACK TO
    formulations.inventory (Kg) AND NEVER TOUCHES inventory_units,
    the Core Stock Line.
    ▶ The unit balance would only ever DECREASE.
    ⚠⚠ UNTESTED — the product-return path could not be reached (B4).
      A CODE READING, NOT A PROVEN DEFECT.
    FIX  move inventory_units in the same operation.

B4  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY.
    PROVEN ON DEV: 3.32 Kg demonstrably in store, picker offered
    nothing.
    ▶ THE PRODUCT-RETURN PATH HAS NEVER RUN BECAUSE IT CANNOT BE RUN.
    CANDIDATE  return-mat.component.ts — recProductList declared [];
      getReceiveProductByFormulaIdSuccess imported and apparently
      NEVER SUBSCRIBED, while the material selector IS.
    ⚠ NOT PROVEN. One grep confirms.
    ⚠ FOURTH INSTANCE of a screen that looks operable with no working
      path behind it — J86, J92, this, and P142.

B5  ⚠ Trace_ProductOneStepBackwardIP_SP joins fopackaging with NO
    whd_flag filter. A multi-level product has several rows
    (FO-0003-3 has five). IT DIVIDES BY WHICHEVER ROW THE JOIN
    RETURNS AND RETURNS DUPLICATE ROWS.
    ✓ ITS SIBLING HAS THE FILTER, WITH A COMMENT. Copy it across.
    ⚠ Two other objects share the unfiltered join — Trace_Material-
      Details_SP (errors loudly instead) and WhC_GetMoDetails_SP
      (serves whd_flag, pushing the decision to the consumer).
    ⚠ MAY SHARE A CAUSE WITH P136 (duplicate rows). NOT PROVEN.
```

## GROUP C — ACROBATICS OUTSIDE THE IP WORK

```
C1  qty_misc_release_su   the MR cell in Trace_ProductHeaderView.
    FIX  repoint to qty_rejected_units, AND add a type guard.
    ⚠ The mr CTE has NO type filter. Material MRs carry no mlc_id so
      they group out — SAFE BY DATA, NOT BY CODE (J74).
    ✓ NO BACKFILL. Hagensborg's 24 MR rows are ALL MATERIAL and must
      stay at zero per JR15. MEASURED, question closed.

C2  SOH_su   ⚠⚠ DEPENDENT. It subtracts qty_misc_release_su AND
    intermediate_prd_su. IT CANNOT BE UNITS-ANCHORED UNTIL THE
    INTERMEDIATE COLUMN EXISTS (A3).
    ▶ THEREFORE P82's ACCEPTANCE TEST — ZERO DIVISIONS IN THE VIEW —
      CANNOT BE MET WITHOUT AT LEAST THE IP RELEASE COLUMN.

C3  edit-mlc html:258 + getWdu   the Product Receiving panel divides
    a Kg receipt to show "# Shipping Units".
    FIX  add receiveproducts.qty to
         WhC_GetMoProductReceivingDetails_SP (one column), then
         repoint. ⚠ getWdu dies with it — delete in the same pass.
    ⚠ NOT IP-RELATED. This is product receiving.

C4  P131  Edit Closed MO line 133 — a unit count with a WEIGHT label.
    FIX  one line. Covered by RULES 7.
```

## ⚠ GROUP D — THE FRONTEND. 20 LIVE DIVISION SITES.

⚠ THE CORRECT MODEL IS ALREADY IN THE CODEBASE:
    stock-info.component.ts:188
      inventory_units              → the # count, READ STORED
      inventory_units × wduKgPerUnit → the Kg, DERIVED
  ▶ COPY IT. DO NOT INVENT A THIRD SHAPE.

```
D1  ⚠⚠ THE WRITE PATH. HIGHEST VALUE, ONE LINE.
    add-dispatch-v2.component.ts:194
      packing_units: Math.round(((qtyToShip / batch_qty)
                                 * (batch_qty / wgt)) ...)
    ▶ IT DIVIDES TO PRODUCE packing_units AND WRITES IT TO THE ROW.
      EVERY OTHER SITE IN GROUP D DISPLAYS A WRONG NUMBER. THIS ONE
      STORES ONE — and Trace_ProductHeaderView now reads that column
      for qty_do_su and qty_packing_slip_su (JR18).
    ⚠ J88 measured the column clean because Math.round lands on the
      right integer. J88 ALSO recorded that a FRACTIONAL DO would
      round wrong and SILENTLY SHIP A DIFFERENT QUANTITY THAN
      AUTHORISED. Fractional DOs are permitted by design.
    FIX  take the unit count from the operator's entry / the cascade.
         Never divide, never round.

D2  ⚠ THE MR SITE — PRODUCT MISCELLANEOUS RELEASE
    rejected-materials.component.ts:154
      return element.qty_rejected / element.wgt_kgs_per_unit;
    ✓ qty_rejected_units EXISTS (JR15) AND IS SERVED (JR16). The
      stored value is already on the object.
    FIX  read the stored column. ONE LINE.
    ▶ THIS IS THE ONLY ACROBATIC LEFT ON THE PRODUCT MR PATH.

D3  THE COPY-PASTED HELPER — (qty/batch) × (batch/wgt), SEVEN COPIES
      mfg-lot-codes:129 · dispatch-orders:151 ·
      production-controller:253 · mlo-management:164 ·
      closed-mlcs:215 · mlo-list:173 · add-dispatch-v2:121
    ⚠ ALGEBRAICALLY qty ÷ wgt. THE DISGUISED FORM (J83, J94).
    ▶ ONE DECISION, SEVEN EDITS. Identical arithmetic, pasted.

D4  completeUnit — received_qty ÷ wgt, THREE COPIES
      edit-mlc:298 · edit-mlo:251 · start-mlc:155
    ✓ received_units IS STORED AND NOW SERVED (JR17). STRAIGHT REPOINT.
    ⚠⚠ P151 RECORDS ONLY edit-mlc. THE OTHER TWO ARE UNRECORDED
      ANYWHERE. Found by this survey.

D5  SINGLE SITES
    edit-mlc:354 getWdu + html:258   ⚠ per-receipt. NEEDS P157 FIRST —
        WhC_GetMoProductReceivingDetails_SP must serve
        receiveproducts.qty. ⚠ getWdu dies with the fix; delete it.
    admin-formulation.component.ts:878 + html:123
        ⚠⚠ THE PRODUCTS LIST. inventory ÷ wgt while inventory_units
          sits unread. J83 recorded it; CONFIRMED LIVE S108 —
          testpdt260703 holds inventory_units 0.166 and the screen
          derives the same figure from Kg.
    mfg-lot-codes.component.html:69   getWdu on received_qty
    product-traceability.component.ts:109   received_qty ÷ wgt
    formulation-edit-stock-info.component.ts:269
        ⚠ (inventory/batchQty) × (batchQty/wduKgPerUnit). J83.
        CONFIRMED S108 against its correct sibling.

D6  LIKELY CORRECT — VERIFY, DO NOT ASSUME
    material-traceability-details:169, 170
    ⚠ Materials are Kg-anchored BY DESIGN (RULES 7), so a division to
      show units may be legitimate here. CHECK AGAINST THE DOMAIN
      RULE BEFORE TOUCHING.

✓ CORRECT
    stock-info.component.ts:188        THE MODEL. Reads stored,
                                      multiplies.
    products-for-sales-order:43        shippingUnits × wgt. Units → Kg.
                                      Written oddly, arithmetically R1.

DEAD  PopUps/add-dispatch (v1), whole component. J87 / P36 / P115.

⚠ getQtyRoundOff (~25 uses in release-mat-details) IS A FORMATTER,
  NOT A CONVERTER. It rounds. Not an acrobatic.
```

---

# 3 · WHAT WAS CHECKED AND IS CORRECT

```
✓ Trace_ProductOneStepForward_SP     multiplies (JR7b)
✓ Trace_ProductProdLotView           fixed S95 (JR7e)
✓ WhC_GetFormulaPackagingMaterials   the cascade NEEDS the weight (JR6)
✓ WhC_GetMoPackagingConfiguration_SP serves raw cascade ingredients.
  ⚠ NOW RECORDS THIS AS "NEVER INSPECTED IN FULL". IT HAS BEEN NOW.
✓ WhC_GetMoDetails_SP                received_units present (JR17)
✓ Trace_MaterialDetails_SP           serves the weight, never divides
✓ GET_NESTED_ALLERGENS               no quantities
✓ GET_NESTED_FORMULA_MATERIALS       no quantities
✓ Trace_ProductProdView              a picker list, no quantities
✓ The Edit-Mlc intermediate template MULTIPLIES. No acrobatic there.
✓ The MATERIAL return write path     PROVEN CORRECT BY LIVE TEST.
✓ rejectedmaterial / rejectedproduct EMPTY ON BOTH BOXES. The
  pre-merge design, superseded. Retirement question with P109.
```

---

# 4 · WHAT WAS NOT SURVEYED

```
✓ THE FRONTEND IS DONE. 56 files swept, divisions and helpers.
⚠ WHAT A SWEEP STILL CANNOT SEE: arithmetic split across several
  lines, and a division inside a helper whose name contains no weight
  token. getWdu was caught because it ALSO divides directly. A helper
  named something innocuous, defined in a service, would not be.
  ▶ RESIDUAL RISK, NOT ZERO. Stated rather than glossed.
⚠ THREE TABLES UNCOUNTED — do_receive_products · mlodetails ·
  forecastsales.
⚠ THE RETURN WRITE PATH'S SIX READ SITES that sum qty_return as Kg —
  MLOManagement.js and Formulations.js, three each.
⚠ WhC_GetAllRejectedList_SP was NOT RE-READ. JR16 documents its
  SELECT list in full and nothing has changed since S104. RELYING ON
  THE RECORD, SAID OUT LOUD.
```

---

# 5 · THE ONE STRUCTURAL POINT

```
S41 flipped the anchor to units. The old Kg-to-units calculations
were never all removed. EVERY FINDING IN THIS SURVEY IS A LEFTOVER
FROM THAT FLIP.

⚠ ALL SIX INSTANCES FOUND BEFORE S108 WERE FOUND BY ACCIDENT while
  working on something else. THE FIRST SYSTEMATIC SWEEP FOUND TWO
  MORE IN THE FIRST TWO OBJECTS IT OPENED.
▶ THE SIX FIXED BEFORE S108 WERE NOT THE WHOLE PROBLEM. THEY WERE THE
  ONES THAT HAPPENED TO BE IN FRONT OF SOMEONE.

⚠ AND THE TWO WORST FINDINGS OF S108 CAME FROM ONE TEST ON DEV, NOT
  FROM READING. RULES 1: REPRODUCE FIRST.
```
