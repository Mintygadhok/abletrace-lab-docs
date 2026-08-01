# PLAN

Written at close of: S96 · for S97.
Disposable. Rewritten whole at every close. Nothing durable lives here.

---

## THE JOB — the app, in order, nothing else

```
⚠ S96 NEVER REACHED THE APP. It opened locked out of dev and became
  an infrastructure session and a documentation cut. THE CARRIED JOB
  IS UNCHANGED.

1  P82a  R5 — THE TWO REPOINTS. Ruled GO at the S95 close.
           qty_produced_su → mm.received_units
           qty_shipped_su  → the stored units column
         Both in Trace_ProductHeaderView. Scope and measurements are
         in J113 — read that, nothing needs re-deriving.

         ⚠ DO NOT WRITE THE ALTER FROM db-definitions-S93.txt. It is
           a SNAPSHOT dated S93 and does not carry JR7e. Read the box:
             SHOW CREATE VIEW abletracelab_live.Trace_ProductHeaderView\G
           ⚠ SCHEMA-QUALIFIED. Both boxes carry a dormant `abletrace`
             archive with its own copy (P101).

         ⚠ THE SECOND REPOINT IS A COLUMN SWAP, NOT A REWRITE. The
           CTE reads
             sum(case when ps.shipped_flag then do.qty_to_ship else 0 end)
           A bare SUM(qty_shipped) would DROP THE shipped_flag
           CONDITION — and qty_shipped is incremented at PACKING SLIP
           CREATION, not at ship (J88), so a DO on an unshipped slip
           already carries a tally. ▶ Swap the column, keep the case.

         ⚠ THE TRAP THAT WILL BITE IT — TRAPS 10. Inside that same
           CTE the alias `qty_shipped` is KG. The real column is
           UNITS. Same name, opposite basis, a few lines apart. The
           table qualifier is not optional.

         ⚠ GATE BEFORE THE ALTER, ON BOTH BOXES, as P91 did. Count
           the rows that would go blank or change. DEV'S ANSWER IS
           NOT PROD'S ANSWER.
           ▶ The gate queries cannot be written until the view has
             been read. Do not guess the row grain.

         ⚠ RDS ONLY, NOT IN GIT. JR entry in the SAME BREATH.
         ⚠ ONE SCREEN VERIFIES IT: product-traceability-details.
         ⚠ NEVER ON A 1:1 FIXTURE. Use test1.39 at 1.39 Kg/unit.
         ⚠ SOH WILL NOT CHANGE. Expected — it needs a column that
           does not exist (P82b). DO NOT CHASE IT.

2  P90   STRIKE THE TWO FALSE CLAIMS IN SECTION 3A. Rides along with
         R5 — same view, same sitting. ⚠ NEEDS NO BOX; it could be
         done cold at any point.
           3A.5 row 7  ⚠ NOT A FLAT FALSEHOOD — A CONFLATION OF TWO
                       VIEWS. "trace reads received_units directly
                       (already present in the view)" is TRUE of
                       Trace_ProductProdLotView (JR7d, S51) and FALSE
                       of Trace_ProductHeaderView (measured, J83).
                       Row 7 names neither, and row 6 above it names
                       ProductHeaderView, so a reader carries that
                       down. ▶ THE STRIKE MUST NAME BOTH VIEWS.
           3A.6        says nobody has identified the R5 switch
                       point. J113 names all seven.
         ▶ Strike both WITH a pointer to J113.

3  DELETES — last, not first. Minutes, and clears five queue lines.
         P20   pre-S72 Section J file
         P22   old Section A file
         P106  acrobatics-map-S91.txt
         P107  units-kg-checklist-S93.md  ⚠ READ IT FIRST — P82h
               points at items 2 and 3, so part of it is live.
         P94   /home/ubuntu/mo-0001-before-heal-S93.txt, on prod
         ⚠ P20 and P22 are not in the repo listing. One ls may close
           both without a commit.

⚠ DELETES GO LAST, DELIBERATELY. A session that opens on tidying
  stays there — S94 lost nine exchanges that way.
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

⚠ RULES.md WAS REWRITTEN WHOLE AT THE S96 CLOSE. Its stamp reads S96.
  Four items changed and nothing else: BLAST RADIUS, LOOK, DEPLOY and
  DOCS. ⚠ THREE PROPOSED LINES WERE DROPPED AS DUPLICATES — S96 had
  drafted them before RULES had been read.
⚠ Section_0.md and Section_1.md NO LONGER EXIST — deleted S95 (P95).
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. Read all four stamps against S97 first.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e...
           both backends 13e3fcd · clean · 200
   ⚠ NOTHING WAS DEPLOYED IN S95 OR S96. A delta here is a real
     finding.
   ⚠ SSH NOW WORKS FROM ANYWHERE ON BOTH BOXES. If it does not, the
     cause is NOT the security group — that was settled in S96.

2  Read J113 and TRAPS 10 (the CTE alias) before writing anything.

3  P82a. Read the view off the box. Gate dev, ALTER, verify
   schema-scoped. Then gate prod, ALTER, verify.
```

---

## NOT IN THIS SESSION

```
⚠ NO DOCUMENTATION JOB IS QUEUED. TRAPS was rewritten whole in S96
  and is down to ten entries. THIS SESSION IS FOR THE APP.

⚠ P110 — finishing the RULES simplification is the natural next
  documentation job, and S96 proved the method works. NOT S97.

⚠ P111 QUICKBOOKS gets its own PLANNING session. No code. Seven
  questions in NOW must be answered first. NOT S97.

⚠ P102 THE REBOOT — its own sitting, never inside a working session.
  MISSED ON 1 AUG. RESCHEDULE. ⚠ It is now the security item, not
  housekeeping: prod carries 31 pending updates, dev 17.
  ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — and dev does NOT
    rehearse prod, they run different operating systems.

⚠ P109 RETIRE THE ARCHIVE — irreversible, own sitting, not ranked.

⚠ P119 BACK UP THE DATABASE'S OWN CODE — Minty asked to walk the
  detail again before it is started. Do not begin it assuming he
  already has.
```
