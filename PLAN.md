# PLAN

Written at close of: S95 · for S96.
Disposable. Rewritten whole at every close. Nothing durable lives here.

---

## THE JOB — three items, in order, nothing else

```
1  R5    THE TWO REPOINTS. Minty ruled GO at the S95 close.
           qty_produced_su → mm.received_units
           qty_shipped_su  → SUM(dispatchorders.qty_shipped)
         Both live in Trace_ProductHeaderView. Scope, measurements and
         the consumer list are in J113 — read that, not a plan file.

         ⚠ THE TRAP THAT WILL BITE THIS. The do_products CTE inside the
           same view defines its OWN alias called qty_shipped, which
           sums qty_to_ship and is KG. The real column is UNITS. Same
           name, opposite basis, a few lines apart. Read the TRAPS
           entry before writing anything.
         ⚠ GATE PROD BEFORE THE ALTER, as P91 did. Count the rows that
           would go blank. Dev is not the answer for prod.
         ⚠ RDS ONLY, NOT IN GIT. JR entry in the SAME BREATH.
         ⚠ ONE SCREEN VERIFIES IT: product-traceability-details.
         ⚠ SOH WILL NOT CHANGE and that is expected — it needs a column
           that does not exist. Do not chase it.
         ▶ P90 rides along: strike the two false claims in 3A.5 row 7
           and 3A.6 while in that view. Needs Section_3A.md pasted.

2  P52   SETTLE WHETHER THE PRINTED PACKING SLIP IS ALREADY DONE.
         ⚠ J112 records it BUILT AND SHIPPED TO PROD IN S86, with
           totals, page footer and barcode deliberately not built.
         ▶ OPEN A SHIPPED SLIP ON PROD AND PRINT IT. Minutes. It either
           closes the queue's only additive item, or what is missing IS
           the job.

3  P58   THE PAT. Dev remotes do not carry it. Minutes to fix. Has
         fired every session that pushed.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section_5.md      R5 writes its JR entry there. NOT OPTIONAL.
PLUS Section_3A.md     P90 strikes two claims in it.

NOTHING ELSE.

⚠ SECTION_0.md AND SECTION_1.md NO LONGER EXIST. Deleted S95 (P95).
  RULES.md carries what Section 0 carried, including the map of what
  each reference section holds. Anything asking for them is stale.
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. Read all four stamps against S96 first.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e...
           both backends 13e3fcd · clean · 200
   ⚠ NOTHING WAS DEPLOYED IN S95. A delta here is a real finding.

2  Read J113 and the CTE alias trap in TRAPS.

3  R5. Gate dev, ALTER, verify, then gate prod, ALTER, verify.
```

---

## NOT IN THIS SESSION

```
⚠ NO DOCUMENTATION JOB IS QUEUED. P95 and P105 both closed at the S95
  close. Section 0 and Section 1 are gone, the traps are in one file,
  and RULES carries the map. THIS SESSION IS FOR THE APP.
⚠ P106 and P107 (acrobatics-map-S91.txt, units-kg-checklist-S93.md) are
  rulings, not work. Neither file has been read.
```
