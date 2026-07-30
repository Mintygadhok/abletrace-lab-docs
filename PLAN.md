# PLAN

Written at close of: S94 · for S95.
Disposable. Rewritten whole at every close. Nothing durable lives here.

---

## THE JOB — three items, in order, nothing else

```
1  P91   Trace_ProductProdLotView divides received_qty by
         wgt_kgs_per_unit to produce received_qty_su, WHILE ALREADY
         SELECTING received_units in the same view. Read the stored
         column instead.
         ▶ THE SMALLEST REAL FIX AVAILABLE. The correct value is
           already in hand.
         ⚠ RDS ONLY, NOT IN GIT. The JR entry is written in the SAME
           BREATH as the ALTER, or it is lost on rebuild.

2  P93   Is qty_allocated Kg-stored or units-stored? GR7 does not
         carry it. One SELECT settles it.
         ▶ ONE ANSWER, FOUR OUTCOMES: two IP stored procs
           (Trace_ProductOneStepBackwardIP_SP,
           Trace_ProductOneStepForwardIP_SP) and two frontend sites
           (product-traceability-details.component.html:352 and :383)
           all divide it. If units-stored, all four are bugs. If
           Kg-stored, all four are correct.
         ⚠ SAME QUESTION HANGS OVER quanity_shipped_to_date (note the
           misspelling), divided at add-dispatch.component.ts:72.

3  R5    SCOPE ONLY. NO BUILD.
         Trace_ProductHeaderView has seven divisions and carries
         NEITHER inventory_units NOR received_units, so the fix is an
         ALTER, not a repoint.
         ⚠ IT IS NOT ONE JOB. Read from the committed view text:
             qty_produced_su      reachable now
             qty_shipped_su       reachable now
             intermediate_prd_su  BLOCKED on P93
             qty_misc_release_su  IMPOSSIBLE — qty_rejected is Kg-only
                                  with no units column anywhere. Needs
                                  a schema change first.
             SOH_su               calculated by subtracting the others,
                                  so it stays wrong until the last one
                                  is fixed. THIS IS THE HEADLINE FIGURE.
         ⚠ AND NOBODY HAS ESTABLISHED WHICH SCREENS READ THIS VIEW.
           Until that is known a fix cannot be verified on screen.
         ▶ DELIVERABLE: a scoped plan, not a change.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS db-definitions-S93.txt        both P91 and P93 are database-side

Section_2.md    ONLY if a units-basis judgment is needed. GR7 is the
                oracle for which fields are units-stored.

NOTHING ELSE. Claude asks by name, and says why in the same breath.
⚠ S94 opened with nine files pasted. 3A, 3B, the acrobatics map and the
  S91 patch script were never opened.
```

---

## FIRST THREE ACTIONS

```
1  Health check both boxes. The OPEN block in RULES pastes cleanly now.
   EXPECT  dev frontend c2a52d8e · prod SERVING prod-c2a52d8e...
           both backends 13e3fcd · clean · 200
   ⚠ Read all four document stamps against S95 first.

2  P91. Rebuild the temp cnf from .env (3B.3 recipe), read the view,
   ALTER it, write the JR entry immediately.

3  P93. One SELECT against a known lot.
```

---

## OWED BY MINTY

```
P89       batches is stored rounded to 3 decimal places and multiplied
          out to compute how much material is released to the floor.
          ~5g in 100kg, on a live client, every MO whose plan does not
          divide evenly.
          ▶ ACCEPT IT, OR FIX IT. This is a business call, not a
            technical one. It is the only open item that moves physical
            stock rather than pixels.

R5 SCOPE  After P93 answers. Which of the seven figures are worth
          fixing, given misc-release cannot be fixed without a schema
          change and SOH depends on it.

DROPS     P59, P60, P94 proposed for drop in S94. Not ruled on.
```

---

## STANDING DISCIPLINE FOR THIS SESSION

```
NEW ISSUES        Logged with the next free number, one line, NEVER
                  CHASED. If Claude thinks a find should change the
                  plan, it says so ONCE and Minty rules.
                  ⚠ Found is logged. Logged is not chased. S93 found
                  P89 mid-session, deliberately did not touch it, and
                  that was correct.

DOC WORK          Corrections attach to the work that touches them.
                  P90 is struck WHEN R5 touches that view. P97's JR
                  pointer is written WHEN P91 needs it. Documentation
                  is never its own session.

"JUST THE         Minty may say this at any point. Claude gives the
COMMAND"          command and stops.

THE ONE DOC JOB   P95. Section 0 and RULES are two heads; Section 1 and
NOT IN THIS       NOW are the other pair. Fold 0.2a, 0.2b, 0.2c, 9E and
SESSION           rule 10 into RULES, then retire Section 0 and
                  Section 1 together. ⚠ ONE SITTING, AT A CLOSE.
                  Until then Section 0 names the wrong paste list.
```
