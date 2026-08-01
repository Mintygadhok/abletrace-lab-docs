# PLAN

Written at close of: S96 · for S97 and S98.
Disposable. Rewritten whole at every close. Nothing durable lives here.

⚠ TWO SESSIONS, ONE CAMPAIGN. This is the first PLAN written across two
  sittings, because Minty ruled P82 a campaign rather than a fix.
⚠ THE SIZING IS A GUESS UNTIL THE WALK IS DONE. S97's walk defines the
  job. If it finds more than expected, S98 becomes S98-S99 and that is
  a finding, not a failure.

---

## THE CAMPAIGN — P82, THE ACROBATICS SWEEP

```
MINTY, S96: shipping units must come from the source AS SHIPPING
UNITS. No acrobatics in between. "Rank within that one by one. We
look at the screen and see what the issue is and keep on cleaning
it. This is priority for me, I need to get that cleaned up across
the app."

⚠ R5 IS NOT THE WHOLE SWEEP. R5 is ONE database view. It was job 1
  in S95's PLAN because it was the only piece fully scoped. The
  campaign is larger and Minty has ranked the whole thing.
```

---

## S97 — WALK, THEN FIX WHAT THE WALK CONFIRMS

```
1  THE WALK — P82h. ⚠ FIRST, AND IT IS THE POINT OF THE SESSION.
   MINTY'S RULING, S96: walk first, then fix. The walk DEFINES the
   job and may find sites nobody has listed.

   ▶ Read units-kg-checklist-S93.md items 2 and 3 — the only part of
     that file known to be live (P107).
   ▶ Then walk every screen that shows a unit figure and compare
     what it SHOWS against what the database STORES.

   ⚠ NEVER ON A 1:1 PRODUCT. A weight of exactly 1 makes the
     division invisible and has already produced a confident wrong
     finding that stood for a session. USE test1.39 (1.39 Kg/unit)
     ON DEV, company 464. → TRAPS 9.
   ⚠ THE FINGERPRINT: a clean fraction like 1 ÷ weight means a
     UNITS-STORED FIELD IS BEING DIVIDED. Trace any "/weight" to
     whether its source is units-stored (do not divide) or
     Kg-stored (divide is correct). J7, and it has held every time.
   ⚠ THREE FIELDS ARE CORRECT AS THEY STAND and must NOT be
     "fixed" — intermediate_prd_su, qty_packing_slip_su, qty_do_su.
     All divide a Kg source and NO stored units alternative exists
     anywhere. Nothing to do until a column exists.

   ▶ OUTPUT: one list, every site, ranked with Minty in one pass.
   ⚠ LOGGING IS MECHANICAL, RANKING IS MINTY'S.

2  P82d — ONE GREP, AND IT HAS BEEN OWED SINCE S81.
   quanity_shipped_to_date (⚠ note the misspelling — a grep for the
   correct spelling finds nothing) is divided at
   add-dispatch.component.ts:72 and its BASIS WAS NEVER ESTABLISHED.
   J91 asked for the reads to be found in S81. Still not done.
   ⚠ soproducts.quantity is KG on the same row while
     quanity_shipped_to_date is UNITS.
   ▶ Find every read. Then it joins the fix list.

3  P82a — R5, THE TWO REPOINTS. Fully scoped already; measurements
   are in J113. Read that, nothing needs re-deriving.
     qty_produced_su → mm.received_units
     qty_shipped_su  → the stored units column

   ⚠ DO NOT WRITE THE ALTER FROM db-definitions-S93.txt. It is a
     SNAPSHOT dated S93 and does not carry JR7e. Read the box:
       SHOW CREATE VIEW abletracelab_live.Trace_ProductHeaderView\G
     ⚠ SCHEMA-QUALIFIED. Both boxes carry a dormant `abletrace`
       archive with its own copy (P101).

   ⚠ THE SECOND REPOINT IS A COLUMN SWAP, NOT A REWRITE. The CTE
     reads
       sum(case when ps.shipped_flag then do.qty_to_ship else 0 end)
     A bare SUM(qty_shipped) would DROP THE shipped_flag CONDITION —
     and qty_shipped is incremented at PACKING SLIP CREATION, not at
     ship (J88), so a DO on an unshipped slip already carries a
     tally. ▶ Swap the column, keep the case.

   ⚠ THE TRAP THAT WILL BITE IT — TRAPS 10. Inside that same CTE the
     alias `qty_shipped` is KG. The real column is UNITS. Same name,
     opposite basis, a few lines apart. The table qualifier is not
     optional.

   ⚠ GATE BEFORE THE ALTER, ON BOTH BOXES, as P91 did. Count the
     rows that would go blank or change. DEV'S ANSWER IS NOT PROD'S
     ANSWER.
   ▶ The gate queries cannot be written until the view has been
     read. Do not guess the row grain.
   ⚠ RDS ONLY, NOT IN GIT. JR entry in the SAME BREATH.
   ⚠ ONE SCREEN VERIFIES IT: product-traceability-details.
   ⚠ SOH WILL NOT CHANGE. Expected. It is S98's job. DO NOT CHASE IT.

4  P90 — STRIKE THE TWO FALSE CLAIMS IN 3A. Rides with step 3, same
   view, same sitting. ⚠ Needs no box.
     3A.5 row 7  ⚠ NOT A FLAT FALSEHOOD — A CONFLATION OF TWO VIEWS.
                 "trace reads received_units directly (already
                 present in the view)" is TRUE of
                 Trace_ProductProdLotView (JR7d, S51) and FALSE of
                 Trace_ProductHeaderView (measured, J83). Row 7
                 names neither, and row 6 above it names
                 ProductHeaderView, so a reader carries that down.
                 ▶ THE STRIKE MUST NAME BOTH VIEWS.
     3A.6        says nobody has identified the R5 switch point.
                 J113 names all seven.
   ▶ Strike both WITH a pointer to J113.

5  P82e · P82f · P82g — the three screen-level sites already known.
   ⚠ ONLY IF TIME REMAINS. They are not urgent and the walk may
     re-rank them.
     P82e  Trace_ProductProdLotView selects mm.qty TWICE, once as
           qty_su and once as qty, with no conversion. Both labels
           cannot be right.
     P82f  mlomanagement.received_qty STORES float garbage
           (15.290000000000001 on dev MO-0009), printed raw as the
           bracketed Kg.
     P82g  /Dispatch-orders renders DO-0010 and DO-0011 as
           `0 Kg(0#)` while the DB holds 1 for both. ⚠ A LIVE WRONG
           NUMBER ON A SCREEN.
```

---

## S98 — THE SCHEMA PIECE, THEN SOH

```
1  P82c — MISC RELEASE GETS A UNITS COLUMN.
   ▶ MINTY'S RULING, S96, AND IT IS WHAT MAKES THIS DOABLE:
     SAVE UNITS FROM NOW ON. THE PAST STAYS AS IT IS.
   ⚠ NO BACKFILL. Historic rows have no true unit figure anywhere —
     it was never saved. The only way to reconstruct it is to divide
     the stored Kg by the weight, which is THE EXACT ROUND-TRIP THIS
     CAMPAIGN EXISTS TO ELIMINATE.
   ⚠ THE CONSEQUENCE, AND SAY IT OUT LOUD BEFORE STARTING: SOH will
     read a MIX for a period — stored units for new write-offs,
     derived Kg for old ones. It gets cleaner over time and stops
     getting worse the day the column lands.

   ▶ THE WORK:
     · add the units column to rejectmaterialandproduct
     · ⚠ DECLARE IT IN THE WATERLINE MODEL. TRAPS 3 — an
       undeclared column is discarded with NO ERROR. Both, or the
       write vanishes silently. This has bitten twice.
     · save the typed units on the write path
     · ⚠ Return quantity is Kg-only too, same residual, same fix
   ⚠ DEV AND PROD ARE SEPARATE DATABASES. The column goes on each
     box directly. JR entry in the same breath.
   ⚠ MR IS ONE TABLE SERVING BOTH PRODUCTS AND MATERIALS. For a
     product write-off material_id and recievedlot_id are NULL; for
     a material write-off both are SET. Do not break the material
     side while fixing the product side.

2  P82b — SOH.
   ⚠ SOH IS NOT A STORED NUMBER. It is arithmetic — five Kg terms
     subtracted, then divided to show units. It CANNOT read a
     stored unit count because there is not one to read.
   ▶ EVERY INPUT MUST BE UNIT-ANCHORED FIRST. Four can be; the
     fifth was P82c, done in step 1.
   ⚠ THIS IS THE HEADLINE FIGURE. Stock on Hand is the number
     anyone actually reads, and it is the last one fixable. That
     is the whole reason the campaign is ranked as a campaign.
   ⚠ GATE BOTH BOXES. Glutenull reads this number.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section_5.md      the JR entries go there. NOT OPTIONAL.
PLUS Section_3A.md     P90 strikes two claims in it.
NOTHING ELSE.

⚠ units-kg-checklist-S93.md is NOT pasted at open. Claude asks for it
  when the walk starts, so the session does not begin by reading.
⚠ Section_0.md and Section_1.md NO LONGER EXIST — deleted S95 (P95).
⚠ RULES.md was REWRITTEN WHOLE at the S96 close. Its stamp reads S96.
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. Read all four stamps against S97 first.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e129d
           both backends 13e3fcd · clean · 200
   ⚠ NOTHING WAS DEPLOYED IN S95 OR S96. A delta is a real finding.
   ⚠ SSH NOW WORKS FROM ANY NETWORK ON BOTH BOXES. If it does not,
     the cause is NOT the security group — that was settled in S96.

2  Read J113 and TRAPS 10 before writing anything.

3  START THE WALK. Not the fix. ⚠ MINTY'S RULING: walk first.
```

---

## THE DELETES — WHENEVER, NOT RANKED

```
P20   pre-S72 Section J file
P22   old Section A file
P106  acrobatics-map-S91.txt
P107  units-kg-checklist-S93.md ⚠ AFTER THE WALK, not before —
      items 2 and 3 are live until the walk consumes them
P94   /home/ubuntu/mo-0001-before-heal-S93.txt, on prod
⚠ P20 and P22 are not in the repo listing. One ls may close both.

⚠ DELETES NEVER OPEN A SESSION. A session that opens on tidying
  stays there — S94 lost nine exchanges that way.
⚠ P58 (the access token) is not listed. It fires on push from dev,
  so it will bite at the close. Fix it when it fires.
```

---

## NOT IN THESE SESSIONS

```
⚠ NO DOCUMENTATION JOB IS QUEUED. TRAPS was rewritten whole in S96
  and is down to ten entries. RULES was rewritten in the same close.
  THESE SESSIONS ARE FOR THE APP.

⚠ P102 THE REBOOT — its own sitting, never inside a working session.
  MISSED ON 1 AUG. RESCHEDULE. ⚠ It is now the SECURITY item, not
  housekeeping: port 22 is open on both boxes with no password path,
  so the only real exposure is an unpatched sshd. Prod carries 31
  pending updates, dev 17.
  ⚠ VERIFY PM2 STARTS ON BOOT FIRST (pm2 startup / pm2 save) or the
    box comes back without the app. Dev first — and dev does NOT
    rehearse prod, they run different operating systems.

⚠ P111 QUICKBOOKS gets its own PLANNING session. No code. Seven
  questions in NOW must be answered first. NOT S97 OR S98.

⚠ P109 RETIRE THE ARCHIVE — irreversible, own sitting, not ranked.

⚠ P119 BACK UP THE DATABASE'S OWN CODE — Minty asked to walk the
  detail again before it is started. Do not begin it assuming he
  already has.

⚠ P114-P118 AND P120-P123 came out of the S96 traps review and are
  NOT RANKED. They wait for Minty's ranking pass, not for a gap in
  a session.
```
