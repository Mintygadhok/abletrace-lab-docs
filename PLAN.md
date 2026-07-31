# PLAN

Written at close of: S95 · for S96.
Disposable. Rewritten whole at every close. Nothing durable lives here.

---

## THE JOB — three items, in order, nothing else

```
1  R5    THE TWO REPOINTS. Ruled GO at the S95 close.
           qty_produced_su → mm.received_units
           qty_shipped_su  → SUM(dispatchorders.qty_shipped)
         Both in Trace_ProductHeaderView. Scope and measurements are in
         J113 — read that, nothing needs re-deriving.

         ⚠ THE TRAP THAT WILL BITE THIS. The do_products CTE inside the
           same view defines its OWN alias called qty_shipped, which
           sums qty_to_ship and is KG. The real column is UNITS. Same
           name, opposite basis, a few lines apart. Read the TRAPS
           entry before writing anything.
         ⚠ GATE PROD BEFORE THE ALTER, as P91 did. Count the rows that
           would go blank. Dev's answer is not prod's answer.
         ⚠ RDS ONLY, NOT IN GIT. JR entry in the SAME BREATH.
         ⚠ ONE SCREEN VERIFIES IT: product-traceability-details.
         ⚠ SOH WILL NOT CHANGE. Expected — it needs a column that does
           not exist. Do not chase it.

2  P90   STRIKE THE TWO FALSE CLAIMS IN SECTION 3A. Rides along with
         R5 — same view, same sitting.
           3A.5 row 7  says Trace_ProductHeaderView already carries
                       received_units. Measured false, S93.
           3A.6        says nobody has identified the R5 switch point.
                       J113 names all seven.
         ▶ Strike both WITH a pointer to J113.

3  DELETES — last, not first. Minutes, and clears five queue lines.
         P20   pre-S72 Section J file
         P22   old Section A file
         P106  acrobatics-map-S91.txt
         P107  units-kg-checklist-S93.md  ⚠ READ IT FIRST — P82 points
               at items 2 and 3, so part of it may still be live.
         P94   /home/ubuntu/mo-0001-before-heal-S93.txt, on prod
         ⚠ P20 and P22 are not in the repo listing. One ls may close
           both without a commit.

⚠ DELETES GO LAST, DELIBERATELY. A session that opens on tidying stays
  there — S94 lost nine exchanges that way.
⚠ P58 (the access token) is NOT on this list. It fires on push, so it
  will bite during this session's own close. Fix it when it fires.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section_5.md      R5 writes its JR entry there. NOT OPTIONAL.
PLUS Section_3A.md     P90 strikes two claims in it.

NOTHING ELSE.

⚠ Section_0.md and Section_1.md NO LONGER EXIST — deleted S95 (P95).
  RULES.md carries what Section 0 carried. Anything asking for them is
  stale.
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. Read all four stamps against S96 first.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e...
           both backends 13e3fcd · clean · 200
   ⚠ NOTHING WAS DEPLOYED IN S95. A delta here is a real finding.

2  Read J113 and the CTE alias trap in TRAPS.

3  R5. Gate dev, ALTER, verify. Then gate prod, ALTER, verify.
```

---

## NOT IN THIS SESSION

```
⚠ NO DOCUMENTATION JOB IS QUEUED. P95 and P105 both closed at the S95
  close. THIS SESSION IS FOR THE APP.

⚠ P111 QUICKBOOKS IS THE NEXT BIG THING AND IT GETS ITS OWN PLANNING
  SESSION. No code. Seven questions in NOW must be answered first —
  Online or Desktop, one app or one per client, what triggers the push,
  do the products already exist in QuickBooks. ▶ NOT S96.

⚠ P102 REBOOT — Saturday 1 August, ~11:30. Its own sitting.
⚠ P109 RETIRE THE ARCHIVE — irreversible, own sitting, not ranked yet.
```
