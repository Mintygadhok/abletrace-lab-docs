# SECTION 2 — WHY (CORE LOGIC)

> The business and stock logic of AbleTrace — the permanent rules of how the business works. Should outlive the code. This is the standalone "Bible": it does not depend on Section 3 or K to make sense.
>
> **Bridge to Section 3 (one-way):** every Logic here keeps a STABLE ID (Logic A–J, GR5/7/8/10, etc.). Section 3's hop-rows point UP to these IDs ("→ §2 Logic A"). Section 2 does **NOT** list where each logic is used — the stable thing never references the changing thing; that is what prevents drift. (Minty's call, S76.)
>
> **⚠ Numbering note:** "Logic J" (the bucket chain, below) and the "J-series" of Section 5 (J1, J2, J78 = trap-log entries) are DIFFERENT numbering systems that happen to share the letter J. Context disambiguates today; a bare "see J…" could be ambiguous — read which system is meant.
>
> Original IDs kept (GR, Logic A, S-numbers) so cross-references never break. State: folded from G/A/B; the anchor/stock flow is walked and lives in the verified Section 3A.5 table.

---

## CORE #1 — THE UNITS-ANCHOR FLOW (the spine)

Formulation → MO → SO → DO → Packing Slip → Ship → Misc Release → Traceability.

```
The one rule     For products, the COUNT OF SHIPPING UNITS is the anchor —
                 it is what gets stored. Kg is always DERIVED from it
                 (units × weight) for display only, never stored as source,
                 never turned back into units. Storing Kg and rebuilding
                 units is the old pre-S41 pattern, and it is always a bug.

The three routes R1  units → Kg          correct (read units, derive Kg)
                 R2  Kg → units          wrong (units rebuilt by dividing Kg)
                 R3  units → Kg → units  wrong (float garbage)
                 Alarm: any "÷ weight" producing a unit figure = R2/R3 = fail.

Where it stands  Anchor is CLEAN at every real stock hop (receive, DO, PS,
                 ship, MR, intermediate), verified live S75. Two defects:
                 • Defect 1 (MO create) — plan round-trips through batches
                   (50 → 50.004). Plan only; never reaches stock.
                 • Defect 2 (Display) — screens rebuild units as Kg ÷ weight
                   (R3), float garbage. THE priority fix: read stored units.

Full detail      Hop-by-hop, with exact DB/front/back addresses, is in the
                 Section 3A.5 STOCK table.
```

## CORE #2 — THE BUCKET CHAIN (how stock physically moves)

```
Main chain       Stock-On-Hand → DO → Packing Slip → Shipped
Side exit 1      Stock-On-Hand → Misc Release   (one-way write-off)
Side exit 2      Stock-On-Hand → parent MO      (consumed as intermediate)

Rules            Stock leaves SOH at DO CREATION, not at ship (J80). Ship is
                 a terminal flag flip — no stock touched, no un-ship. Reverse
                 walks back one bucket at a time, only up to PS/DO; cancel
                 logic already exists there. MR/reject is a separate one-way
                 exit pulled straight from SOH.

Two lines        Ingredients/materials — Kg-anchored end to end, leave alone.
                 Products (incl. intermediates) — unit-anchored end to end.
                 Never reconcile the two.

Two accumulators Core Stock Line = inventory_units — the LIVE balance, moves
                 both ways. "What I have right now."
                 Produced-To-Date = received_units — cumulative per MO/lot,
                 only climbs. A progress indicator.
                 Same receive feeds both; they are NOT the same quantity.
```

---

## THE DOMAIN LOGICS

```
Logic A     Formulation / quantity model. Shipping unit is the anchor;
            its weight (wduKgPerUnit) is BUILT from the packing cascade,
            an output never hand-entered. Three quantity layers that must
            never be forced to reconcile. Batch size entered in units,
            weight derived. Recipe scales by batches, packaging by units;
            they match only at batch size = 1 (the S42 trap).

Logic B     Food safety system (FSMA + HACCP). FSMA = four preventive
            controls, one (Process PC) is the old HACCP CCP.
            Part 1 Documents (each a Procedure or Record).
            Part 2 HACCP narrows twice: Hazard ID → PC types → HACCP Plan
            (Q1–Q4, CCP table, monitoring/corrective/verification).
            In-app verification only for the Process/CCP control; the
            other three handled outside the app. Order = `step` only.

Logic C     Client onboarding / bulk import. Super Admin only. "Excel is
            dumb, the app is smart." Four sheets: Agents, Materials,
            Products, Customers. Recipes materials-only; sub-recipes
            capped at 2; intermediates added manually after upload.
            Upload order Agents → Materials → Products → Customers.

Logic D     Global procedure → client sync. Incremental, deduped by title.
            Resolve the target user with find().sort().limit(1), never
            findOne() (which throws on >1 row).

Logic E     (also A24) Role / task navigation. Fully data-driven from four
            tables (roles, role_task, company_user_role, company_user_task).
            Rail = user's roles, home = that role's tasks, tile routes.
            Roles 1–7 (Food Safety = 7). New rail role = pure data add.

Logic F     Multi-level packing cascade. Nested stack; one level is the
            shipping unit (whd_flag=1). Cascade computed read-time by
            walking down; NOT stored (tables hold flat per-level qtys).
            Writing one flat row per level is correct — don't "fix" it.
            ⚠ Depends on WhC_GetFormulaPackagingMaterials returning
            whd_flag + pack_level — lose them and it silently reads 1/1/1.

Logic J     Product bucket chain (detailed Core #2). Units flow SOH → DO
            → PS → Shipped; stock leaves at DO creation. Ship = terminal
            flip. MR is a separate one-way exit from SOH.
            (⚠ "Logic J" ≠ Section 5's J-entries — see numbering note above.)
```

---

## ANCHOR LOGIC — WHAT SURVIVED THE COLLAPSE

The anchor was told ten ways across G/A/B. The Section 3A.5 table is now the authority, so those overlapping tellings were dropped (verified live, nothing lost). Only these two survive — each holds a detail the table points to but doesn't state.

```
GR5   Fix B roll-up tracker — the only place the fix is R-status.
      R1 receive · R2 release · R3 MR · R4 ship .... DONE
      R5 display switch .... IN PROGRESS (the priority fix)
         C: product list + trace, switch = Trace_ProductHeaderView
         D: trace MO/Completed Qty (received_units in the view)
         E: shipped cumulative — multi-ship NOT stress-tested (gap)
      R6 retire old Kg line .... TO DO (not until the chain is whole)

Logic I  Kg → unit conversion formula (the table points here):
         units = qty_in_Kg × (lot.qty ÷ lot.recieved_qty).
         Exact per-lot. The table's "R2-via-LogicI". Exact today but
         fragile if a lot ratio isn't round — fix is to subtract
         stored units instead.

Dropped  GR4, S45 two-lines, Logic G, Logic H, Logic K, Logic M — all
         fully covered by the table. A11 dissolved (schema → below).
         Logic L dissolved (naming → this section, mechanism → table).
```

---

## DATED DOMAIN RULES

```
MO status types  1 Material not Released · 2 Material Issued ·
                 3 Production Started · 4 Completed.

Closed vs        Closing sets close_status=1 but leaves status (a closed MO
completed (S51)  often still reads 3). "Not finished" filters must test
                 close_status, not just status ≠ 4.

Edit integrity   Composition/identity changes FORK a new version; quantity/
(S59)            planning changes update in place. As-made record is immutable
                 (MO stores an allergen snapshot at production). Can't fork
                 while an open MO or stock exists. Fork: new → status 1, old →
                 2, version++. Soft-deactivate, never hard-delete. MR = write-
                 off (leaves system); Return = back to store, MO-linked.
                 (All verified live in the 3A.5 formulation walk.)

batch_qty in     A planning change, no fork. Fractional batches are correct.
place (S61)

HACCP edit       Three stages chained by a 4-field composite match, not a
(S64)            stable id. Insert-in-between not safely supported. Food-
                 safety-critical; its own session.

Master edit map  Screen-verified fixed-vs-editable fields per Material /
(S67)            Formulation / Customer / Agent edit form.

PS + PO redesign Slimmed customer PS row + PO barcode; PO receiving reuses
(S67)            MO-Release Global Select. A linked pair.

Allergen         Materials = umbrella (ingredients + packaging); allergens are
recursion (S53)  a property of ingredients, walk down through intermediates,
                 re-derive live (not frozen at add-time). Sound.
```

---

## GENERAL CODE RULES — standing disciplines (govern every read/write, not one hop)

```
Populate vs proc   Before adding or "unlocking" any display field: is it fed by
                   a Waterline POPULATE (the column rides free — frontend-only
                   fix) or a native VIEW/PROC (must add it to the SELECT — a DB
                   change)? Check which before touching it. Governs every read.

NgRx pattern       Every API call = 4 files (actions / selectors / effects /
                   reducers). Recurring bug: stale subscriptions → use a named
                   sub + ngOnDestroy (NOT take(1)). Guard array[0] with length
                   checks (a selector that never emits = J2).

Stored-proc        ~36 procs hold logic NOT in the repo (called via
discipline (A25)   sendNativeQuery 'CALL …'). DB-only changes aren't in git — the
                   notes/J-log are their only record; reproduce by hand on
                   rebuild. Order: back up first (mysqldump --routines) → apply
                   via FILE + SOURCE, never a pasted heredoc → verify → log it.

JSON reads         Guard every JSON-column read with Array.isArray, never a
                   null-check (a [] seed reads fine, a NULL crashes). Applies to
                   all *_ref_docs columns + documents.

Two-escape-layers  Never inline a JSON string into a SQL literal — the escape
                   layers cancel by accident and mask a double-encode.
                   JSON.stringify is for structure; on a string it just escapes.

Blocking alert()   Native alert() halts Angular change-detection so a spinner
                   can't repaint until OK. Use ngx-toastr non-blocking toasts.

Commit / shell     No "!" in a git commit -m (bash history expansion aborts it).
                   Mac ~/.ssh/config ServerAliveInterval 60 so a dropped SSH
                   never loses pushed work.

PDF pagination     html2canvas→jsPDF: addImage then loop addPage until
                   heightLeft<0. Image-slice cuts table rows across page breaks —
                   jsPDF-autotable is the row-safe fix.
```

---

## SCHEMA / COLUMN REFERENCE — GR7, the master units-vs-Kg map

⚠ Every line here bit someone once. Check before writing SQL.

```
Naming             formulations FK = company_id (NOT fo_company_id) · company is
                   SINGULAR · `user` must be backticked.

receiveproducts    qty = UNITS · recieved_qty = Kg (note the spelling) ·
                   received_at = datetime (S65).
mlomanagement      qty = planned UNITS · received_qty = Kg · received_units =
                   UNITS · close_status = 1 when closed (NOT mlc_status) ·
                   allergens = longtext JSON snapshot.
formulations       inventory = Kg SOH · inventory_units = units SOH · batch_qty =
                   UNITS (S41) · food_safety_enabled on company (default 0).
dispatchorders     qty_to_ship = Kg · qty_shipped = UNITS · packing_units =
                   UNITS · do_status stuck "Created" (never read it).
soproducts         quantity = Kg.
rejectmaterialandproduct   qty_rejected = Kg ONLY (no units column).
subrecipeformulation       qty = Kg · ship_qty = UNITS (default NULL).

Identity           materials: title=name, internalCode=MAT-N, allergen=longtext
                   JSON. somanagement: internalCode = THE SO NUMBER. packingslips:
                   vehicle_no = the SHIPPING REFERENCE (a relabelled vehicle-
                   number field). hazardidentification: step = authoritative
                   order, ids are not.

JSON ref-doc cols  All type json, arrays of "<uuid>.<ext>|<name>":
                   purchaseorders.PO_ref_docs · packingslips.shipping_reference_
                   docs · somanagement.customer_ref_docs · documents.documents.
                   documents.editorContent = LONGTEXT CKEditor body (a pasted
                   image ≈ 840KB base64). Guard reads with Array.isArray.

Auth / identity    Super Admin = a row in super_admin (user_id + active), NOT
                   role_id=1. Password = salted-MD5 (can't hand-generate without
                   plaintext). Licence status ids: 1 Invited · 2 Trial · 3 Active
                   · 4 Expired · 6 Inactive. Role ids: Admin=2, Food Safety
                   Controller=7.

Dated DB (S43/46)  shipped_qty units-stored, qty_to_ship Kg-stored.
                   inventory_units column added to formulations (DB + Waterline
                   attribute). Re-apply on rebuild.
```

---

## PRODUCT-LEVEL RULES

```
Architecture (A6)  One app, one URL, two modules (Traceability + Food Safety),
                   shared backend. Module-based licensing. Food Safety = rail
                   role 7. Manage Roles = two popups (feature → user).

Licence (A7)       Statuses: 1 Invited · 2 Trial · 3 Active · 4 Expired ·
                   5 Grace(unused) · 6 Inactive. New → Invited (30d). Accept →
                   Trial. Convert → +365, Active. Renew → +365. Cron auto-expiry
                   daily. Only Inactive blocks login; Expired keeps access.

Bulk / soft        Always soft delete, never hard (orphans break the chain).
delete (A18)       Server-side eligibility, never trust the frontend. One bad
                   row never aborts the batch. Reversible.
```

---

## TEST DATA & FIXTURES

```
GR8   Identify by numeric id scoped by company_id, never by name
      or code. PROD = abletracelab_live; ONLY companies 464 & 465
      are sandbox, everything else is real — never touch Glutenull.
      Primary fixture = 464 (test260703), full end-to-end, holds
      all 6 roles. First real client = Glutenull (GF bakery).
```

---

## FUTURE SCOPE (parked — dissolves into the live NOW list, not a reference block)

```
GR10  Pre-onboarding build order, Feature A (Food Safety toggle),
      Feature B (onboarding tool), security-tidy, HACCP edit-cascade
      rework, Standardized Record Engine, full audit, finish
      Glutenull. All future work — kept here only so nothing is lost.
```

---

## WHAT'S LEFT TO WALK

The 3A.5 STOCK table is the spine, done. These areas still need the same screen-by-screen walk, each becoming its own hop-style table:

1. **Food Safety / HACCP** — §2 Logic B. *(S76: WALKED — now Section 3A.7.)* Held waiting code facts: FS download map (PDF vs Excel, type="button" bug), document-write trap (FS_upd_Documents_SP, J78 test matrix), HACCP parallel-insert (ORDER BY step), Section-K action map.
2. **Traceability** — closes Defect 2's display side (GR5 R5-C/D point here)
3. **Procurement / PO receiving** — §3A.3, material / lots inbound
4. **Sales Order (the SO)** — §3A.4 head, SO create/edit, before the DO. *(S76: WALKED — now Section 3A.4.)*
5. **Customers / Agents / Materials** — §3A.1, master CRUD, same 4-write-path pattern
6. **Super Admin** — §3A.8, licences, roles, guides, procedure sync
7. **Licence engine** — §2 / A7, 6-status lifecycle, cron, login gate
8. **Master-data upload** — §3A.8, the multi-master importer (Agents + Materials + Customers + Formulations, Logic C)

---

## TO BE VERIFIED (unconfirmed against live code — check, then move to the chart or a rule. Not settled until checked.)

1. **Nested-pop two-collection trap** — getFormulaById once dropped the intermediate on edit-save (fixed S55, commit 9a5a5eb). Confirm still guarded in the current Formulations.js → then chart FORMULATION mines.
2. **mlc_status read-shape** — object{.id} on populate, bare number on proc (WhC_GetMoDetails_SP → Edit-Mlc), status_id on trace views. Confirm the live binding on Start Production → then chart START PRODUCTION mines.
3. **Start-production write handler** — the fn that flips mlc_status + assigns the lot code. Notes say WhC_GetMoDetails_SP feeds the gate (bare number); confirm the actual WRITE handler + name → chart back-end.
4. **WhC_GetFormulaPackagingMaterials** — confirm its SELECT returns whd_flag + pack_level (else cascade reads 1/1/1, Logic F) → then a Logic-F pointer.
5. **PS-create dead block** PackingSlips.js:333-334 + createPS/editPackslips line numbers — never confirmed against code. Verify on box → chart back-end.
6. **A9 / A15 frontend file-maps** — look duplicated (two lists of the same files from different sessions). Do NOT merge or prune until verified against live code → then chart / rules as appropriate.
7. **Back-end LINE NUMBERS across all chart rows** — written from session notes, not read from live code. File + function are solid; line numbers are grep-to-confirm at the moment of use (they shift each commit).
8. **RESOLVED (was to-verify) — ship_qty on fork. CLOSED by J9b.** The version-fork WRITES ship_qty=0 for intermediates (carries qty in Kg, drops ship_qty). DB-confirmed S45: FO-0007 ship=10 → FO-0007-2 ship=0. The chart was right; Section K was wrong (its "clean" claim was the pure-ADD path, not the fork — now corrected in K v4). This is a REAL OPEN BUG, no longer a question. Fix = "Fix A" (fork handler copies ship_qty forward + one-time heal of 0# rows). The ACTION now lives in Section 1 (NOW) as a P-item; this line is just the record that it's settled and where the fix is tracked.

---

## CLEANUP PILE (confirm each, then delete — kept actionable, not prose)

```
STALE     A1 stale lines: "Ubuntu 24.04" (really 26.04) · "t3.small" (really
          t2.small) · "abletrace" as live DB (really abletracelab_live). Confirm
          against box, then delete. Also "Current position S42" refs (32 sessions
          old); B's on-box build recipe (superseded by CI — keep the discipline
          lines, drop the build mechanics).
          ⚠ S76 NOTE: Section 0 already records both boxes are t3.small (t2.small
          was the FALSE claim, struck S73). So the STALE line above is itself
          out of date on that one point — the boxes ARE t3.small. Reconcile when
          this pile is cleared.
DEAD      A12 on-box build recipe (box can't build) · A13 "two environments"
          (really three + old app) · duplicate SESSION 0 block in A · duplicate
          S66 dev-environment block in A · duplicate S57 driver/auth block in B.
RECONCILE B's "two-layer / Kg-anchored stock (settled)" framing (Logic K + S59) —
          STRUCK by the S73 route-map, already handled in the anchor collapse;
          this is just the note that it's corrected.
HELD → 4  A23 design system (font Inter / Montserrat landing; rust default, red
          destructive, blue edit, green success, amber status; neutral grey nav
          tiles) → belongs in Section 4 (design/UI), untouched here.
```

---

**END SECTION 2**
