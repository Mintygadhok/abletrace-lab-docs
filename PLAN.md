# PLAN

Written at close of: S97 · for S98.
Disposable. Rewritten whole at every close. Nothing durable lives here.

⚠ THIS IS A FIX LIST. NOT A WALK, NOT AN INVESTIGATION.
  S97's PLAN said "walk first, then fix" and the walk consumed the
  whole session. That instruction was right for S97 and is POISON
  for S98. The hunting is DONE.

---

## THE ONE RULE FOR THIS SESSION

```
NO NEW INVESTIGATION UNTIL THE FIX LIST IS EMPTY.

Anything odd found mid-fix goes on the QUEUE. Carry on to the
next fix. Do not chase it.

⚠ S97 found seven sites in twenty minutes of greps, then spent
  four hours generating branches. One fix landed: none.
```

---

## THE SEVEN FIXES — ONE AT A TIME

⚠ EVERY PATH BELOW WAS VERIFIED IN S97 WITH `find` + `grep`.
  DO NOT RE-LOCATE THEM. The paths in older documents are stale —
  three of four were wrong.
⚠ EVERY SITE BELOW WAS READ IN THE FILE IN S97.
  DO NOT RE-INVESTIGATE. Read it to write the patch, not to
  confirm the finding.

```
FOR EACH ONE, IN ORDER:
  patch → git diff → build → deploy → LOOK AT THE SCREEN → log → next
⚠ FINISH ONE BEFORE STARTING THE NEXT.
```

---

### 1 · SO STATUS — units compared to Kg  ⚠ DO THIS FIRST

```
FILE   api/models/SOManagement.js   lines 182-206   ⚠ BACKEND
```

The sales-order status dot compares a UNIT count to a Kg total:

```
dispatchedQty += DO.qty_shipped;     ⚠ UNITS
soQty         += product.quantity;    ⚠ KILOGRAMS
if (soQty <= dispatchedQty) finalState = 3   → GREEN
```

⚠ PROVEN LIVE, S97: SO-0014 ordered 5 units (3.5 Kg), shipped 4.
  `3.5 <= 4` is true → GREEN "Fully Shipped" with a unit still owed.
⚠ IT FAILS BOTH WAYS. Under 1 Kg/unit it greens too early. Over
  1 Kg/unit a completed order never greens.
⚠ GLUTENULL IS EXPOSED: Fruits & Nut bars are 0.32 Kg/unit (J113),
  so the EARLY-GREEN direction is live on prod.

▶ THE FIX — two changes in one function:
    1  add .populate('packing_id') to the DispatchOrders.find at :179
    2  dispatchedQty += DO.qty_shipped * <packing_id.wgt_kgs_per_unit>
  ⚠ MULTIPLY, never divide. R1.

⚠ WHY NOT qty_to_ship (already Kg, no conversion): MINTY'S RULING,
  S97 — a DO CAN SHIP MORE OR LESS THAN AUTHORISED. So the status
  must follow what ACTUALLY shipped, which is qty_shipped.

⚠ DO NOT PATCH THE FRONTEND FUNCTION THAT LOOKS LIKE THIS ONE.
  so-management.component.ts:170 evalFinalStateElement has the same
  units-vs-Kg comparison and IS DEAD — its caller at :138 is
  commented out. Patching it changes nothing. → J114.

⚠ SECOND SITE, SAME RULE, NOT YET READ: closed-so.component.ts:136
  computes finalState in the FRONTEND for the Closed SOs screen,
  by its own route at :169/172/175. Two implementations of one
  rule. ▶ Read it when fix 1 is done; fix it the same way or log it.

VERIFY: SO-0014 on dev must drop from GREEN to YELLOW.
Backend only — pm2 restart, no build, no promote.
```

---

### 2 · PRODUCTS LIST STOCK ON HAND — reads the legacy Kg column

```
FILE   app/Layouts/admin-dashboard/admin-formulation/admin-formulation.component.ts
LINE   878
NOW    Math.round((element.inventory / packing?.wgt_kgs_per_unit) ...)
```

⚠ `formulations.inventory` is the LEGACY Kg column.
  `formulations.inventory_units` holds the live unit balance and
  appears NOWHERE in this file.
⚠ Line 897/898 exports the same two figures from the same source.

▶ FIX: read inventory_units directly. No divide.
⚠ THE KNOWN-GOOD PATTERN: PopUps/stock-info.component.ts:188 reads
  inventory_units and MULTIPLIES to derive Kg. Copy it.

⚠ OPEN QUESTION, ONE QUERY, ANSWER IT BEFORE FIXING 2 AND 3:
  do formulations.inventory and inventory_units AGREE today?
  AGREE     → this is a right number by a wrong route
  DISAGREE  → ⚠ the Products list is showing a WRONG stock figure
              and these two jump to the top of the list.
```

---

### 3 · ADD-MLO WAREHOUSE STOCK — same legacy column

```
FILE   app/Layouts/admin-dashboard/mlo-management/add-mlo/add-mlo.component.html
LINE   87
NOW    {{_Number(item?.formulation_id?.inventory)...}} Kg
       ({{getWduUnits(batch_qty, item?.formulation_id?.inventory, wgt)}} #)
```

⚠ BOTH figures come from the legacy Kg column — the Kg raw, the
  units by dividing it.
⚠ This is the "have I enough intermediate to make this?" line an
  operator reads when creating an MO.
⚠ Line 85 is CORRECT and must not be touched — batches * item.qty,
  a multiply off a units-stored value.

▶ FIX: read inventory_units.
```

---

### 4 · CLOSED MOs LIST — divides a units-stored field

```
FILE   app/Layouts/admin-dashboard/mlo-management/closed-mlcs/closed-mlcs.component.html
LINE   79
NOW    {{getQty(element.qty)}} {{unit}}({{getWdu(element, element.qty)}}#)
```

⚠ `mlomanagement.qty` is PLANNED UNITS, STORED. This divides it.
  On a 0.7 Kg/unit product, 10 ÷ 0.7 = 14.286# where the truth is 10.
⚠ A WRONG NUMBER, not a rebuilt one.
⚠ LINE 84 IS CORRECT — same helper, passes received_qty (Kg).
  Two calls, adjacent, one right one wrong. Do not touch 84.

▶ FIX: print element.qty directly as the unit count. Derive Kg by
  MULTIPLYING.
```

---

### 5 · EDIT CLOSED MO — divides a units-stored field, plus R3

```
FILE   app/Layouts/admin-dashboard/mlo-management/closed-mlcs/edit-closed-mlcs/edit-closed-mlcs.component.ts
LINE   136
NOW    WDU: `${Math.ceil((this.mlcDetails.qty / this.wduUnits)...)} ...
             ( ${lotReceived} )`
```

⚠ TWO FAULTS ON ONE LINE:
    · divides mlcDetails.qty — UNITS-STORED. Wrong number.
    · prints lotReceived (:126), which rebuilds received_qty by
      dividing. R3.
⚠ THIS IS THE ONLY SURVIVOR OF ITS FAMILY. The same WDU line is
  COMMENTED OUT in edit-mlc:311, edit-mlo:260 and start-mlc:164.
  Somebody switched five off and missed this one.

▶ FIX: qty is already units — print it. lotReceived should read
  mlomanagement.received_units.
```

---

### 6 · EDIT-MLC COMPLETED — rebuilds a stored figure

```
FILE   app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/edit-mlc/edit-mlc.component.ts
LINE   298
NOW    completeUnit = Number(received_qty / fopackaging_wgt_kgs_per_unit)
```

⚠ received_qty IS Kg-stored, so the arithmetic is CORRECT. The
  fault is that mlomanagement.received_units holds this figure
  already, stored since S48.
⚠ Right number, wrong route — and it produces float garbage on
  awkward weights.

▶ FIX: read received_units.
⚠ IDENTICAL TO JR7e / P91, proven in S95 on
  Trace_ProductProdLotView. Same source column, same fix.

⚠ LINE 295 (lotReceived) IS DEAD — its only consumer at :311 is
  commented out. Do not fix it. Delete it with P115.
```

---

### 7 · PRODUCT TRACEABILITY — rebuilds a stored figure, twice

```
FILE   app/Layouts/admin-dashboard/traceability/product-traceability/product-traceability.component.ts
LINES  109 and 161
NOW    wduRec = Math.round((item.received_qty / ...wgt_kgs_per_unit)...)
```

⚠ Same as fix 6 — Kg-stored source, correct arithmetic, but
  received_units is already there.
⚠ LINES 107 AND 159 ARE CORRECT and sit two lines away — they
  MULTIPLY item.qty (units-stored) to derive Kg. Do not touch them.

▶ FIX: read received_units.
```

---

## WHAT S97 STRUCK — ⚠ DO NOT RE-CHASE THESE

```
CORRECT, verified by reading what each caller passes in:
  mfg-lot-codes.html:69          passes received_qty (Kg)  ✓
  production-controller.html:50  passes received_qty (Kg)  ✓
  mlo-management.html:78         passes received_qty (Kg)  ✓
  closed-mlcs.html:84            passes received_qty (Kg)  ✓
  add-dispatch-v2.html:25,28     passes recieved_qty (Kg)  ✓
  mlo-list.html:38,40            passes recieved_qty (Kg)  ✓
  dispatch-orders.html:120       passes qty_to_ship  (Kg)  ✓
  dispatch-orders.html:117       getShippingKg MULTIPLIES  ✓

DEAD — assigned and never read, or the caller is commented out:
  edit-mlc:295 · edit-mlo:245 · start-mlc:151   (lotReceived)
  so-management.component.ts:170 evalFinalStateElement
  add-dispatch.component.ts:72   (v1 popup, never opened — P36)
  ▶ These belong to P115's dead-code sweep, NOT to P82.

FIXTURE FACTS, measured S97 on test0.7 (0.7 Kg/unit, dev 464):
  the whole outbound chain reconciles — MO → receive → SO → DO →
  packing slip → ship. 8 + 2 = 10. Buckets move correctly at
  every hop. ⚠ DO NOT RE-WALK IT.
```

---

## NOT IN THIS SESSION

```
⚠ P82 CANNOT FULLY CLOSE IN S98 AND NOBODY SHOULD TRY.
  P82b (SOH) is BLOCKED behind P82c, which is a schema change on
  two separate databases and a session of its own.

STILL OPEN, EACH ITS OWN JOB — do not start them mid-fix:
  P82g   /Dispatch-orders shows 0# on shipped DOs. Reproduced
         twice S97. ⚠ THE TEMPLATE IS CORRECT — proven with
         cat -A. Cause unknown. ▶ Needs a row read on
         packingslips / packingslipdos, NOT another code read.
  P82a   R5 view repoint. Scoped in J113. Needs SHOW CREATE VIEW
         on BOTH boxes before gate queries can be written.
  P82c   misc release has no units column. Schema, both boxes,
         plus the Waterline attribute (TRAPS 3).
  P82e   Trace_ProductProdLotView selects mm.qty twice. Not read.
  P82f   received_qty stores float garbage. Not read.

⚠ P102 THE REBOOT — its own sitting. Still missed. Prod 31
  updates pending, dev 17. VERIFY pm2 startup FIRST.
⚠ P111 QUICKBOOKS — planning session, no code.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section_5.md      the J entry goes there. NOT OPTIONAL.
NOTHING ELSE.

⚠ units-kg-checklist-S93.md IS CONSUMED. Its item 2 and 3 sites
  were all read in S97 and are either in the fix list above or
  struck. → P107 can now be deleted.
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e129d
           both backends 13e3fcd · clean · 200
   ⚠ NOTHING WAS DEPLOYED IN S95, S96 OR S97.

2  ⚠ ROTATE THE DEV DATABASE PASSWORD IF S97 DID NOT.
   It reached the chat transcript twice in S97. Dev only, not
   internet-reachable on 3306, but permanent once exposed.
   J39 method: generate straight into a file, never printed.

3  START FIX 1. Not a walk. Not a review.
```

---

## DEV FIXTURE RESIDUE — S97

```
test0.7 (FO-0009)   NEW. 0.7 Kg/unit, single pack level, one
                    material, no intermediate. Built as a
                    deliberate non-1:1 fixture. KEEP IT.
MO-0015             10 units produced, fully received
MO-0016             created, material released, NOT received
SO-0014             5 ordered, 4 shipped ⚠ GREEN — this is the
                    live evidence for fix 1. DO NOT CLEAR IT
                    until the fix is verified.
DO-0013 · DO-0014   2 units each, both shipped
PS-0028 · PS-0029   both shipped
```
