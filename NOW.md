# NOW

Last rewritten: S93, 29 July 2026.
The only file that changes each session.

⚠ THE S91 AND S92 REWRITES OF THIS FILE WERE NEVER COMMITTED. The repo
  carried the S87 version until today. S93 opened by pasting it, and the
  first stretch of the session went on working out which document to
  believe. See TRAPS. The fix is in RULES now: NOW is committed AT close,
  not downloaded and forgotten.

---

## HANDOVER

```
THE GOAL      P82 THE ACROBATICS SWEEP is now a SHORT LIST, not a survey.
              Phases 1, 2 and 3 are DONE. What remains is verification on
              screen, then R5.

PASTE LIST    RULES.md + NOW.md + TRAPS.md.
              Section 2 if any judgment about which fields are
              units-stored is needed (GR7 is the oracle).
              db-definitions-S93.txt for anything database-side.

FIRST THREE   1  Health check both boxes. Six corrected commands are in
ACTIONS          TRAPS under RULES CORRECTION OWED. Expect dev 0b7ba967,
                 prod SERVING prod-0b7ba96779ad, backends 13e3fcd.
              2  Verify the dispatch-orders find on screen (P92). It is
                 the only probable frontend BUG the sweep produced, and
                 it needs a non-1:1 fixture.
              3  Rule on R5 scope now that Phase 3 has sized it.

⚠ FIRST       P89. batches rounding reaches MATERIAL RELEASE on a live
CANDIDATE     client. It is the only S93 finding that moves real stock.
```

---

## WHAT S93 DID

```
GLUTENULL BUG, END TO END, CLOSED
  Reported: MO-0001 planned qty read 1750.08# where 1750 was entered.
  Mechanism: add-mlo.component.ts:204-205. batches = 1750/240 = 7.29166…
  stored rounded to 7.292, then totalQty = 7.292 x 240 = 1750.08. The
  entered units were discarded at 204. totalQty feeds the HIDDEN
  "quantity" control -> saveMLO obj.qty -> mlomanagement.qty.
  Scope: ONE row on the whole of prod. No other MO carries a fraction.
  Heal: prod row 11789 (company 471) qty 1750.08 -> 1750. Backup at
  /home/ubuntu/mo-0001-before-heal-S93.txt on prod (24 lines).
  Fix: commit 0b7ba967, line 205 now Number(qty) || 0.
  Proof: CONTROLLED EXPERIMENT on dev, company 464, product FO-0008,
  batch_qty 240, same entered 1750, minutes apart -
      MO-0013  old code  qty 1750.08  batches 7.292
      MO-0014  new code  qty 1750     batches 7.292
  Read from the DATABASE, not the screen.
  Promoted prod-0b7ba96779ad. Client screen confirmed 1750# (560 Kg).
  ▶ 3A.5 ROW 2 IS NO LONGER RED. Defect 1 is closed.

P82 SWEEP - PHASES 0, 1, 2 AND 3 ALL DONE
  Map committed (dcfea9c). 157 lines = 154 hits + 3 headers.
  edit-formulation.component.ts struck: 13 hits, ZERO divisions.
  Whole map triaged: ~22 multiplications, ~45 reads/declarations,
  ~14 commented out, ~6 text slashes, ~39 LIVE DIVISION SITES.
  ⚠ PHASE 2 WAS ALREADY DONE. The 14 HTML templates the plan called
  "never checked, most likely place for survivors" were in the map all
  along under === HTML ===. No survivors.

PHASE 3 - THE DATABASE. 9 views, 35 routines.
  11 objects mention wgt_kgs_per_unit. FOUR divide. SEVEN just pass it
  through. Full text committed as db-definitions-S93.txt (65ef245).

P67 CLOSED. JR1 through JR14 all present in Section_5.md, no gaps.
```

---

## THE P82 SHORT LIST — what is actually left

```
DATABASE (Phase 3, read on dev, text committed)

  Trace_ProductHeaderView        SEVEN divisions, one per _su field:
                                 qty_produced_su · qty_misc_release_su ·
                                 intermediate_prd_su · qty_packing_slip_su ·
                                 qty_do_su · SOH_su · qty_shipped_su
                                 ⚠ CONTAINS NEITHER inventory_units NOR
                                   received_units. The view must be
                                   ALTERED, not repointed.
                                 ⚠ RDS ONLY, NOT IN GIT. Any change needs
                                   a JR entry or it is lost on rebuild.

  Trace_ProductProdLotView       divides received_qty to make
                                 received_qty_su WHILE SELECTING
                                 received_units IN THE SAME VIEW.
                                 ▶ THE EASIEST FIX IN THE CODEBASE. The
                                   correct value is already in hand.

  Trace_ProductOneStepBackwardIP_SP   qty_allocated / wgt -> shipping_units
  Trace_ProductOneStepForwardIP_SP    qty_allocated / wgt -> qty_used_su
                                 ⚠ UNRESOLVED: is qty_allocated Kg or
                                   units? GR7 does not carry it. Settle
                                   before touching either.

  CLEAN, no action: Trace_MaterialDetails_SP ·
  Trace_ProductOneStepForward_SP · WhC_GetAllRejectedList_SP ·
  WhC_GetFormulaPackagingMaterials · WhC_GetMoDetails_SP ·
  WhC_GetMoPackagingConfiguration_SP · WhC_GetMoProductReceivingDetails_SP

FRONTEND - the one probable BUG (as opposed to a display fix)

  dispatch-orders.component.ts:145   getShippingUnit() is
                                 (data/batchQty) * (batchQty/wgt).
                                 batchQty cancels: it is data / wgt.
    html:121  passes qty_to_ship         Kg-stored    -> LEGITIMATE
    html:117  passes Refer_PS.shipped_qty UNITS-stored -> ⚠ SUSPECT
                                 ⚠ CORROBORATED: Trace_ProductOneStep-
                                   Forward_SP MULTIPLIES shipped_qty by
                                   wgt to get weight. shipped_qty is
                                   units. Two independent sources.
                                 ▶ NOT CONFIRMED. Needs a shipped slip on
                                   screen with wgt_kgs_per_unit ≠ 1. → P92

  R5 DISPLAY SITES, already known, not re-listed here:
    admin-formulation:878 · edit-mlc:298 · edit-mlo:251 · start-mlc:155 ·
    product-traceability:109 and :161 · add-mlo.html:87 · getWduUnits

  LEGITIMATE, leave alone: the material-traceability pair (materials are
  Kg-anchored end to end) · add-dispatch:71/72 · edit-sales-order:393 ·
  dispatch-orders.html:121 · add-dispatch-v2.html:12

  SCHEMA GAP not a code bug: rejected-materials:154 and
  reject-product.html:34 divide qty_rejected, which GR7 confirms is
  Kg-ONLY with no units column. The division is forced. → 3A.5 row 11.

  DOCUMENTED FRAGILITY, not new: add-dispatch:150 and
  add-dispatch-v2:194 write packing_units by dividing Kg. → 3A.5 row 8.

⚠ DO NOT TOUCH: PackingSlips.js editPackslips ~325-336. It is live code
  that THROWS, and the throw is the only thing preventing three worse
  bugs behind it. → P35, and §2 TO BE VERIFIED item 5.
```

---

## ⚠ THE SECOND REFERENCE IMPLEMENTATION

```
The docs named ONE place that does R1 correctly:
  PopUps/stock-info.component.ts:188   reads inventory_units, MULTIPLIES.

S93 found a SECOND, in SQL:
  Trace_ProductOneStepForward_SP
      psd.shipped_qty * fop.wgt_kgs_per_unit AS shipped_qty_weight,
      psd.shipped_qty                        AS shipped_qty_units

  ▶ Copy this shape for any database-side fix. Do not invent one.
  ▶ It also PROVES shipped_qty is units-stored.
```

---

## CORRECTION OWED TO THE FROZEN DOCS

```
⚠ SECTION 3A, 3A.5 ROW 7, CARRIES A FALSE CLAIM.

  It says:   "R5(D) — trace reads received_units directly
              (ALREADY PRESENT IN THE VIEW)"

  MEASURED ON DEV S93, information_schema.VIEWS:
      Trace_ProductHeaderView
        has_inventory_units   0
        has_received_units    0
        mentions_weight       1

  Section 2 GR5 was RIGHT and 3A.5 row 7 is WRONG. §2 needs no change.

  ▶ Strike the "(ALREADY PRESENT IN THE VIEW)" claim from 3A.5 row 7 and
    replace with: the view carries NEITHER unit column; the R5 fix is an
    ALTER, not a repoint, and needs a JR entry. → P90
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺33 · frontend HEAD 0b7ba967
          serving dev-0b7ba96779ad · backend 13e3fcd · clean · 200
PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · Glutenull live
          SERVING prod-0b7ba96779ad
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8).
            Judge prod by the served bundle, never the checkout.
          backend 13e3fcd · clean · 200
ROLLBACK  prod: /home/ubuntu/www-html.bak-prod-0b7ba96779ad
          dev:  /home/ubuntu/www-html.bak-dev-0b7ba96779ad
          ⚠ each holds the build it REPLACED (275c025039d7), not the one
            it is named after.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
BACKENDS  UNTOUCHED THIS SESSION. No git pull, no pm2 restart.
```

---

## COMMITS THIS SESSION

```
FRONTEND, dev then promoted to prod
  0b7ba967   S93 Defect 1 fix. MO create stored a round-trip of the
             entered units. Line 205 now stores what was entered.
             batches deliberately unchanged.

DOCS
  dcfea9c    acrobatics-map-S91.txt preserved off /home/ubuntu (P16).
  65ef245    db-definitions-S93.txt. Full text of the 2 views and 9
             procs referencing wgt_kgs_per_unit. NOT otherwise in git.

PROD DATA
  mlomanagement id 11789 company 471 · qty 1750.08 -> 1750
  Backup /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
  ⚠ /home/ubuntu is not backed up. Move or delete when no longer needed.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items at the bottom with
the next free number. Claude never renumbers.

```
CARRIED FORWARD, still open
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P58   Dev remotes do not carry the PAT. ⚠ PROMPTED AGAIN IN S93. That is
      every session that has pushed. Minutes to fix.
P59   pm2 restart counters: prod 336, dev 33.
      ⚠ S93 FINDING: prod still reads 336, unchanged since the S86
      promote. The gap is HISTORICAL ACCUMULATION, not something
      climbing. No crash loop. Downgraded, not closed.
P60   DO picker popup HEADING never renamed.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 accuracy: stale rollback points.
P68   ⚠ THE RULES OPEN BLOCK STILL CANNOT BE PASTED. THIRD SESSION.
      Corrected commands are at the foot of TRAPS. Fix RULES itself.
P82   The acrobatics sweep. ▶ NOW A SHORT LIST, see above.
P84   Zebra guide into the app. Mechanical.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.

NEW IN S93
P89   ⚠ batches ROUNDING REACHES MATERIAL RELEASE. batch count is stored
      rounded to 3 places (7.292 against a true 7.29166…) and is
      multiplied out at release-mat-details.component.ts:1071, 1083 and
      1095 to compute final_qty for ingredients, intermediates AND
      packaging. Also add-mlo:150 and :223 for packaging quantities.
      ⚠ THIS MOVES REAL STOCK, not pixels. ~5g in 100kg, on a live
      client. It is the only S93 finding with a physical effect.
      ⚠ DO NOT "TIDY" THE batches LINE while in add-mlo. S93 deliberately
      left it alone for exactly this reason.
P90   Strike the false claim in 3A.5 row 7 that Trace_ProductHeaderView
      already carries received_units. Measured false on dev, S93.
P91   Trace_ProductProdLotView: read received_units instead of dividing
      received_qty. The column is already selected in the same view.
      ⚠ RDS only, not in git. Needs a JR entry.
P92   Verify dispatch-orders.component.ts:145 via html:117 on a shipped
      slip. ⚠ MUST use a product whose wgt_kgs_per_unit is not 1.
P93   Establish whether qty_allocated is Kg-stored or units-stored. Two
      IP procs divide it. GR7 does not carry the answer.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod
      once the heal is settled. /home/ubuntu is not backed up.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      ⚠ DEFECT 1 IS CLOSED. Fixed and promoted in S93.
      Defect 2: display reconstructs units as Kg / weight. ~30+ sites
      plus the 4 database objects above. This is R5.
      ⚠ THERE IS NO THIRD DEFECT. The "version fork writes ship_qty 0"
        claim is FALSE and never was true (J81). "Fix A" is a dead name.

FROZEN SPEC — ready to build
      P52 printed packing slip.
```

---

## THE FIVE THINGS THAT COST TIME IN S93

```
1  THE RECORD WAS FIVE SESSIONS STALE and nobody knew until the boxes
   were read. Cause: NOW written at close, downloaded, never committed.
   Twice running.
2  P68. The RULES OPEN block still cannot be pasted. Third session.
3  The trailing command dropped off a pasted block on prod. Again.
4  P58. The PAT prompt. Again.
5  Two of Claude's own grep patterns were wrong in ways that looked
   right — JR1[0-4]* cannot match JR2-9, and LIKE '%/%needle%' does not
   test for division. Both caught, neither became a finding. See TRAPS.
```
