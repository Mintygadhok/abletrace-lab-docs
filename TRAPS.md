# TRAPS

Last rewritten: S96, 31 July 2026.

⚠ REWRITTEN WHOLE THIS SESSION. The file went from ~40 entries to TEN.
  This is the first rewrite — every previous edit was an append.

MINTY, S96: "the documentation itself is turning into a trap. Cut down
the non-critical ones. The critical part is the load-bearing part."

---

## WHAT A TRAP IS, AND WHAT IT IS NOT

```
A TRAP IS       a fact about how this app is built that FAILS
                SILENTLY — no error, no crash, just a wrong number
                or a missing row. You cannot discover it by testing,
                because nothing announces itself.

A TRAP IS NOT   a bug. A bug goes in the QUEUE and gets fixed.
A TRAP IS NOT   a working method. That goes in RULES.
A TRAP IS NOT   a client symptom. That goes in the client guide.
A TRAP IS NOT   a nuisance that cost an hour once. That goes nowhere.
```

⚠ THE TEST APPLIED IN S96: does believing the wrong thing here CORRUPT
  DATA or PUT A WRONG NUMBER IN FRONT OF THE CLIENT? If not, it was cut.

⚠ EVERY ENTRY BELOW FAILS SILENTLY. That is the only thing they have in
  common and it is the whole reason they are kept.

---

## 1 · THE DO ROW MIXES UNITS AND KG, SIDE BY SIDE

```
dispatchorders.qty_to_ship     KG
dispatchorders.qty_shipped     UNITS
dispatchorders.packing_units   UNITS
```

Same row. Adjacent columns. Every one of them reads plausible.

⚠ Any calculation combining them must convert first.
⚠ Do NOT infer the basis from the column name. qty_to_ship and
  qty_shipped sit side by side and are OPPOSITE bases.

---

## 2 · SHIPPED QUANTITY IS A UNIT COUNT — MISREAD THREE TIMES

`packingslipdos.shipped_qty` and `dispatchorders.qty_shipped` hold a
UNIT COUNT. The Kg figure beside them is DERIVED BY MULTIPLYING.

MEASURED ON DEV, company 464:
```
testpdt260703   20 Kg/unit     qty_to_ship 100    shipped_qty 5
test1.39        1.39 Kg/unit   qty_to_ship 9.73   shipped_qty 7
7 x 1.39 = 9.73 EXACTLY. Not approximately.
```

THREE SEPARATE BITES:
```
S16  subtracted shipped_qty (units) from qty_to_ship (Kg) in one sum
S93  printed it raw as Kg AND divided it for the unit figure
S94  fixed. Same field, third encounter.
```

⚠ THE KNOWN-GOOD SHAPES, both already in the codebase:
```
frontend  edit-packslips.component.ts:280   units# (units x wgt Kg)
SQL       Trace_ProductOneStepForward_SP    shipped_qty * wgt
```
Copy one. Do not invent a third.

---

## 3 · A COLUMN YOU ADD IS SILENTLY IGNORED UNLESS THE MODEL DECLARES IT

A column written via `.update().set()` is DISCARDED with no error unless
it is also declared in the model's attributes block.

⚠ THE DB COLUMN ALONE IS NOT ENOUGH. Any new column needs BOTH.
⚠ THIS IS PROVEN, NOT THEORETICAL. received_units banked 0 silently
  until it was declared. food_safety_enabled has the column and NOT the
  attribute to this day — the toggle write vanishes.
⚠ P111 QUICKBOOKS NEEDS A NEW COLUMN. It will bite there.

---

## 4 · HACCP READS MUST ORDER BY step, NEVER id

Hazard rows insert in PARALLEL, so ids land in completion order, not step
order (id 1220 = step 10, id 1221 = step 1). The `step` column is
authoritative.

⚠ A HACCP DOCUMENT THAT READS OUT OF SEQUENCE IS WRONG. It must read
  receiving → storage → processing → packing → shipping.

---

## 5 · AN ALLERGEN EDIT REACHES SEVEN PRODUCTS AND THEIR COMPLETED LOTS

There is NO as-made allergen snapshot. Allergens re-derive LIVE from the
current recipe, through to past and produced lots.

MEASURED TWICE, both directions, on different products:
```
S73  removing an allergen from one material removed it from a
     COMPLETED, PRODUCED lot
S78  adding one added it to a COMPLETED lot — and to ALL SEVEN
     products in the company sharing that ingredient
```

⚠ ZERO ROWS ADDED OR REMOVED. A row count reports "nothing happened".
⚠ VERIFY EDITS BY SELECT VALUE COMPARISON, NEVER BY COUNTING ROWS.
  This applies to every in-place update — allergen, name, pencil qty,
  MO status, close_status.

MINTY'S RULING (S73, re-affirmed S78): live re-derivation is CORRECT.
Allergen declaration is client knowledge. If an ingredient was
mis-declared the record was always wrong, and freezing it would preserve
that error on every lot ever made. A correction must reach past data.
⚠ DO NOT RE-RAISE THIS AS A DEFECT.

---

## 6 · A POPULATED FK IS AN OBJECT ONE WAY AND A NUMBER THE OTHER

Read via Waterline populate, a status or id comes back as an OBJECT and
is never `=== 2`. It fails silently — the gate just never fires.

Read via a STORED PROC, the same field is a BARE NUMBER and `?.id` is
undefined — also silently false.

⚠ CONFIRM THE READ PATH BEFORE COMPARING.
⚠ Bit twice, 19 sessions apart: mlc_status (S50), role_id (S69). The
  mlc_status one left Receive Product usable with NO MATERIAL RELEASED.

---

## 7 · NEVER TWO COLLECTIONS IN ONE nestedPop POPULATE ARRAY

v0.1.4 silently returns the SECOND one EMPTY. Use a dedicated second pass
and stitch by id.

⚠ FOOD-SAFETY-CRITICAL WHEN IT BIT — subrecipe formulations vanished.
  A recipe reading as though it has no ingredients.

---

## 8 · do_status NEVER ADVANCES

`dispatchorders.do_status` stays "Created" even after a full ship. The
authoritative shipped state is `packingslips.shipped_flag`.

⚠ NEVER READ do_status TO DETERMINE SHIPPED. Reading it tells a client
  something shipped that did not, or the reverse.

⚠ RETAINED UNTIL P133 IS FIXED. Moved to the queue S99 on Minty's
  ruling — if it can be fixed it is a job, not a permanent fact. It
  stays here because it protects live code: until the fix lands,
  reading do_status still tells a client something shipped that did
  not. TRAPS drops to nine when P133 closes.

---

## 9 · NEVER VERIFY A CONVERSION ON A 1:1 PRODUCT

A weight ratio of exactly 1 makes a division INVISIBLE. 10 / 1 = 10
reconciles perfectly whether the code divides or reads the stored value.

⚠ IT HAS ALREADY PRODUCED A CONFIDENT WRONG CONCLUSION that became a
  documented finding and stood for a session (S78, corrected S79).

▶ Pick a product whose `wgt_kgs_per_unit` is NOT 1, and ideally not
  round. `test1.39` at 1.39 Kg/unit is the standing fixture on dev.

⚠ P82 IS ENTIRELY ABOUT DIVISIONS. This rule governs every test in it.

---

## 10 · A NAME INSIDE A VIEW CAN MEAN THE OPPOSITE OF THE REAL COLUMN

⚠ RETIRES WHEN P82a IS DONE. Kept only because it protects that job.

Inside `Trace_ProductHeaderView`, the do_products CTE defines:

```
sum(case when ps.shipped_flag then do.qty_to_ship else 0 end)
    AS qty_shipped                    ⚠ THIS IS KG
```

The real column `dispatchorders.qty_shipped` is UNITS. Same name,
opposite basis, one view, a few lines apart.

⚠ Anyone repointing qty_shipped_su to "the stored units column" by
  reading the CTE name will wire KG INTO A UNITS FIELD, and the
  arithmetic will look plausible at every 1:1 fixture.

⚠ NOT YET BITTEN. Logged S95 while scoping R5, before anyone builds it.

⚠ THE RULE: inside a view, resolve every name to its DEFINITION before
  trusting it. An alias is not a column and a CTE is not a table.

---

## WHAT WAS CUT IN S96, AND WHY

⚠ RECORDED SO NOBODY RE-ADDS THEM. Everything below was reviewed
  one at a time with Minty and cut deliberately.

```
SEVENTEEN EXACT DUPLICATES
  S95's merge (P105) moved JT1-JT22 in verbatim without checking
  against the entries already at the top of the file. Seventeen
  pairs said the same thing twice. ⚠ FREE CUT, no judgement.

BECAME QUEUE ITEMS — something is broken, so fix it
  MO close vs complete           → P114
  the live path is not obvious   → P115 (delete the dead code)
  JSON column guards             → P116
  hidden errors / upload limit   → P117
  deliberately-wrong code        → P118 (comment it IN the code)
  barcode overrun                → P120
  the "java" process             → P121
  printing barriers              → P122
  "Not Secure"                   → P123

BECAME RULES — a working method, not a trap
  the DB is ground truth, screens lie
  measure the boundary, don't reason across it
  grep the pattern, not just the bug
  placeholders in command blocks

CUT ENTIRELY — nothing broken, fixed long ago, or a one-off nuisance
  a button in a form needs type="button"      fixed S53
  a revert is a trade                         both bugs dead S71
  a mask can hide a bug for years             same fix, same session
  grep output can lie                         nothing to fix
  the rebuild filename typo                   trivia; the backup
                                              worry became P119
  "dead code" is checkable                    folds into P115
  DevTools focus voids a keystroke test       nothing broken
  an absent console log proves nothing        cause never found
  two screens called "Dispatch Orders"        nothing broken
  Claude mapping commits from memory          nothing broken
  raw GitHub URLs serve stale content         nothing broken
  a handover note is not the record           notes retired S94
  two documents both claiming current         resolved S95
  naming a slip by database id                nothing broken
  a check that passes for the wrong reason    nothing broken
  a post-write check matching its own comment nothing broken
  a slash is not always a division            nothing broken
  a verification query without the schema     nothing broken
```

⚠ THE PATTERN IN THE CUTS: they were written down because a session lost
  an hour, not because they endanger the app. That is a fair reason to be
  annoyed and a poor reason to occupy permanent space in a file read at
  every session open.

⚠ AND THEY COST MORE THAN SPACE. They sat between the reader and the ten
  entries that matter.

---

## HOW THIS FILE STAYS SMALL

```
1  A NEW ENTRY MUST FAIL SILENTLY AND TOUCH DATA OR A CLIENT-FACING
   NUMBER. If it merely cost time, it does not go here.
2  IF IT CAN BE FIXED, IT IS A QUEUE ITEM, NOT A TRAP.
3  IF IT CAN BE WRITTEN AS A COMMENT NEXT TO THE CODE, PUT IT THERE.
   A comment sits three inches from the thing being tidied. This file
   sits in another repo the tidier is not reading. (→ P118)
4  IF IT IS A CLIENT SYMPTOM, IT BELONGS IN THE CLIENT GUIDE.
5  ⚠ AN ENTRY THAT PROTECTS A JOB RETIRES WHEN THE JOB IS DONE.
   Entry 10 goes when P82a lands.
```
