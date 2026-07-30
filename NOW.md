# NOW

Last rewritten: S94, 30 July 2026.
State and queue. Rewritten whole every session, committed at close.

---

## WHAT S94 DID

```
P92 CLOSED — END TO END, ON PROD
  The Qty Shipped cell on the shipped packing slip list printed a
  units-stored field raw and labelled it Kg, THEN divided the same
  field by wgt_kgs_per_unit and labelled that "#".
      was    5.000 Kg (0.25#)
      now    5# (100.000 Kg)
  PROVED FROM THE DATABASE FIRST, not the screen. Dev company 464:
      testpdt260703  20 Kg/unit   qty_to_ship 100   shipped_qty 5
      test1.39       1.39         qty_to_ship 9.73  shipped_qty 7
  7 x 1.39 = 9.73 exactly. shipped_qty is UNITS. Third independent
  proof, with GR7 and Trace_ProductOneStepForward_SP.
  Fix: commit c2a52d8e. Two spans rewritten, both now units-first.
  Qty Plan's ARITHMETIC was already correct (qty_to_ship really is Kg)
  — only its presentation moved.
  getShippingUnit() NOT touched. A multiply sibling getShippingKg was
  added beside it, which is the existing shape in mlo-management,
  production-controller and mfg-lot-codes.
  VERIFIED dev (5#/100.000, 1#/20.000, 7#/9.730) and prod (5#/100.000,
  1#/20.000) — both on non-1:1 fixtures.

P68 CLOSED
  The RULES OPEN block pasted CLEANLY on both boxes, first time in
  three sessions. Warnings outside the fence, -C on every git command,
  the prod seventh line reading the served build. The correction owed
  since S91 is delivered. ⚠ TRAPS keeps its block, stamped, not cut.

HEALTH CHECK OPENED CLEAN
  First time in three sessions. Dev and prod both matched NOW exactly.
  That is what committing NOW at close bought.

THE DOCUMENT SET WAS SETTLED
  Four working files, fixed names, stamps on the first lines. See
  RULES DOCS. ⚠ AND A SECOND-HEAD PROBLEM WAS FOUND — see P95.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺33 · frontend HEAD c2a52d8e
          serving dev-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          backend 13e3fcd · clean · 200
PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · Glutenull live
          SERVING prod-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8).
            Judge prod by the served bundle, never the checkout.
          backend 13e3fcd · clean · 200
ROLLBACK  prod: /home/ubuntu/www-html.bak-prod-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          dev:  /home/ubuntu/www-html.bak-dev-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          ⚠ each holds the build it REPLACED (0b7ba967), not the one it
            is named after.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
BACKENDS  UNTOUCHED THIS SESSION. No git pull, no pm2 restart.
```

---

## COMMITS THIS SESSION

```
FRONTEND, dev then promoted to prod
  c2a52d8e   S94 P92. Qty Shipped divided a units-stored field and
             labelled it Kg. Kg now derived by multiplying.

DOCS
  ea1bdd2    units-kg-checklist-S93.md committed.
  (this close) NOW rewritten, TRAPS appended, PLAN created, RULES
             DOCS block replaced.

NO DATABASE WRITES THIS SESSION. P92 was display-only; the stored
data was already correct and reconciled.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items at the bottom
with the next free number. Claude never renumbers.

```
CARRIED FORWARD, still open
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P58   Dev remotes do not carry the PAT. ⚠ FIRED AGAIN IN S94. That is
      every session that has pushed. Minutes to fix.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale again. ▶ THE FIX IS TO DELETE THEM
      FROM 3B.4, not update them. STATE carries them and is rewritten
      every session. Static section, dynamic fact — the anti-rot rule.
P82   The acrobatics sweep. Short list: P91, P93, R5, plus the screen
      walk in units-kg-checklist-S93.md items 2 and 3.
P84   Zebra guide into the app. Mechanical.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P89   ⚠ batches ROUNDING REACHES MATERIAL RELEASE. Stored rounded to 3
      places and multiplied out at release-mat-details 1071/1083/1095
      to compute final_qty. ~5g in 100kg, on a live client. THE ONLY
      OPEN ITEM WITH A PHYSICAL EFFECT. ▶ MINTY'S RULING OWED.
P90   Strike the false claim in 3A.5 row 7 that Trace_ProductHeaderView
      already carries received_units. Measured false on dev, S93.
      ⚠ S94 FOUND A SECOND FALSE CLAIM, SAME OBJECT: 3A.6 says nobody
      has identified where the R5 switch point is. S93 named all seven
      divisions. Strike both in one patch.
P91   Trace_ProductProdLotView: read received_units instead of dividing
      received_qty. The column is already selected in the same view.
      ⚠ RDS only, not in git. Needs a JR entry.
P93   Establish whether qty_allocated is Kg-stored or units-stored. Two
      IP procs and two frontend sites divide it. GR7 does not carry it.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.

PROPOSED FOR DROP — ⚠ MINTY HAS NOT RULED
P59   pm2 restart counters. S93 established the prod count is not
      climbing. History, not a fault.
P60   DO picker popup heading never renamed. Nobody has complained.
P94   Delete a backup file next time anyone is on prod. Does not need
      a number.

NEW IN S94
P95   ⚠ SECTION 0 AND RULES ARE TWO HEADS OF ONE DOCUMENT, AND
      SECTION 1 AND NOW ARE THE OTHER PAIR. Section 0's standing paste
      says Section 0 + Section 1 + Section 5; PLAN says RULES + NOW +
      TRAPS + PLAN. Both read authoritative. Section 0's rule 9 also
      maps NOW to Section_1.md, which is no longer where NOW lives.
      ⚠ SECTION 0 IS NOT DELETABLE AS IT STANDS — it carries five
      load-bearing things RULES does not: 0.2a the two-column format,
      0.2b hand documents over as files, 0.2c the patch loop, 9E the
      both-directions anti-rot test, rule 10 the close protocol.
      ▶ Fold those five into RULES, then retire Section 0 and
        Section 1 TOGETHER. One sitting, at a close, not at an open.
      ⚠ UNTIL THEN SECTION 0 TELLS YOU TO PASTE THE WRONG FILES.
P96   Delete patch_s91_close.py from the docs repo. Spent — it already
      ran, and its lesson is in RULES PATCHES.
P97   Section 5's JR block does not point at db-definitions-S93.txt.
      Eleven database objects are committed in the repo and a rebuild
      from JR would not find them. One pointer line.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      ⚠ DEFECT 1 CLOSED S93. ⚠ P92 CLOSED S94.
      Defect 2: display reconstructs units as Kg / weight. The
      remaining sites are in units-kg-checklist-S93.md plus the four
      database objects. This is R5.
      ⚠ THERE IS NO THIRD DEFECT. The "version fork writes ship_qty 0"
        claim is FALSE and never was true (J81). "Fix A" is a dead name.

FROZEN SPEC — ready to build
      P52 printed packing slip. ⚠ The only open item that ADDS
      something rather than repairing. An S90 question is still
      unanswered: the slip printed then already carried letterhead,
      stacked DO rows and a Shipped By line, so either P52 was largely
      built or that was a different print.

NOT ON THE QUEUE AND PROBABLY SHOULD BE
      CERTIFICATE MONITORING. Nothing watches renewal on either box and
      no email setting can change that (Let's Encrypt stopped storing
      contact addresses). Trace expires 17 OCTOBER 2026. The fact
      survived in STATE; the action item did not.
```

---

## WHAT COST TIME IN S94

```
1  Claude answered a narrow question about folding three files by
   reviewing the whole documentation set. Four exchanges before any app
   work. ⚠ CLAUDE'S FAULT, and the shape to watch: a document question
   is not an invitation to audit documents.
2  Nine files were pasted at open. The paste list asked for three or
   four. 3A, 3B, the acrobatics map and the S91 patch script were never
   opened.
3  Claude put placeholders in command blocks twice. Both were pasted
   literally. See TRAPS.
4  The trailing command dropped off a pasted block on prod. Again.
5  P58. The PAT prompt. Again.
```
