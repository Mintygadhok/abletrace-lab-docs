# NOW

Last rewritten: S99, 3 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

---

## STATE

⚠ MEASURED AT CLOSE OF S99, both boxes, not from memory.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺129 · 200
          frontend SERVING the code of 770d3c4f
          ⚠ THE BACKUP DIR NAME LIES. Newest dir is
            www-html.bak-dev-34e99c3e7a53, but dev was ROLLED BACK
            from it, so it is serving 770d3c4f's contents under a
            34e99c3e name. RULES' seventh OPEN line will mislead
            on dev until the next clean promote.
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD 2ae869c · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ✓ ↺ HELD AT 129 ALL DAY. The S98 open question is CLOSED.

PROD      15.157.38.101 · pm2 abletrace-backend ↺337 · 200
          Glutenull live · SERVING prod-c2a52d8e129d
          backend HEAD 2ae869c · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠ 29 updates pending · restart required
          ⚠ Usage of / 63.3% of 18.25GB. Dev is 34.7%.

BACKENDS MATCH. 2ae869c on both. This morning's promotion holding.
FRONTENDS DO NOT. Prod is FIVE fixes behind. → JOB B.

GITHUB    frontend main = 2e22e0a1 (the Fix 6 revert)
          ⚠ Code on main is IDENTICAL to 770d3c4f. The revert
            undoes 34e99c3e exactly. Building from main is safe.

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-34e99c3e7a53
                ⚠ ALREADY USED. Holds 770d3c4f, which is live.
          prod  /home/ubuntu/www-html.bak-prod-c2a52d8e129d
          ⚠ A backup dir holds the build it REPLACED.

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
          ⚠ SEPARATE GROUPS. Both boxes KEY-ONLY.

CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small
          prod i-0b54ae374250348e0  t3.small
COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100

DATABASES ⚠ LEARNED S99. THE LIVE DB ON BOTH BOXES IS
            `abletracelab_live`.
          Dev ALSO carries `abletrace-dev` — 251 companies, max id
          321 — which is DEAD. The name is backwards from the truth.
          Plus the dormant `abletrace` archive (P101, P109).
          ⚠ A query against the wrong one RETURNS ROWS, not an
            error. → P134
```

---

## DONE IN S99

```
PROMOTED TO PROD
  2ae869c  SO status fix. Backend only. Pulled, restarted, 200.
           ⚠ NOT VERIFIED ON SCREEN — Glutenull has NO SALES
             ORDERS, so there is nothing to look at. The premise
             that this was a live client symptom was WRONG. The
             arithmetic was measured; the exposure was not.

FIXED AND VERIFIED ON DEV
  9b9cf05d  Closed-SOs status dot. The screen OVERWROTE the
            finalState the backend already computes with a read of
            soproducts.product_status — a column nothing writes,
            holding 1 on all 14 rows, rendering red on every closed
            order. One line commented out; the same line was
            already commented out on so-management:138.
            ✓ VERIFIED: 8 closed SOs, 5 red (nothing shipped),
              2 green, 1 yellow. Regression pair held.
            ▶ ALSO FIXES the status filter and the Excel export,
              both of which read finalState.

  770d3c4f  P82 fix 5. Edit Closed MO, two faults on one line.
            ✓ VERIFIED: the received figure now reads a clean 11
              on MO-0009, matching Closed MOs.
            ⚠ The unit figure still reads 10.008 because 10.008 is
              what is STORED. Code never reaches saved rows.

ATTEMPTED AND REVERTED
  34e99c3e → reverted by 2e22e0a1
            P82 fix 6. Edit MLC release quantity.
            ⚠ PROVEN BROKEN by before-and-after on the SAME screen,
              same MO, same field: /Edit-Mlc MO-0007 Completed
              Quantity read 0# with the patch, 51# without.
            ▶ THE CAUSE: received_units DOES NOT REACH that
              component. Fix 5's screen gets it; this one does not.
              Different route. → JOB, see PLAN.
```

---

## MEASURED IN S99 — findings, not jobs

```
PROD IS CLEAN OF THE MO RESIDUE.
  mlomanagement company 471: MO-0001 qty 1750, MO-0002 qty 802.
  Whole numbers, and 1750 x 0.32 = 560 and 802 x 0.24 = 192.48
  reconcile exactly. GLUTENULL WAS NEVER EXPOSED.

THE MO CREATE PATH IS SOUND TODAY.
  MO-0018 created in S99 with 10 units stored 10, derived 13.9.
  Dev's corrupted rows (50.004, 10.008 x4, 1750.08) are RESIDUE
  from before a fix that landed between MO-0013 and MO-0014.
  ⚠ Dev fixture only. Nothing to heal.

THREE STATUS COLUMNS ARE FROZEN. → P132
  soproducts.product_status, soproducts.status, and
  somanagement.status_id all hold ONE value across all 14 SOs —
  on the order that over-shipped and the five that shipped nothing
  alike. close_status behaves correctly (1 on the 8 closed).

received_qty STORES FLOAT GARBAGE. Confirmed by row, not assumed.
  MO-0009 holds 15.290000000000001 where 11 x 1.39 = 15.29 exactly.
  ⚠ This is P82f, now READ.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    nothing pending. 2ae869c is on both boxes.

FRONTEND   FIVE commits, all proven on dev, none on prod:
             a52e4bfc  Products list stock on hand
             b8e7248b  Add-MLO warehouse stock
             824e0e6d  Closed MOs planned/completed qty + Excel
             9b9cf05d  Closed-SOs status dot          (S99)
             770d3c4f  P82 fix 5                      (S99)
           ⚠ Build from main HEAD 2e22e0a1. The revert on top is
             a no-op; the code equals 770d3c4f.

DATABASE   nothing pending.

⚠ NO CLIENT SYMPTOM ON ANY OF THE FIVE. Measured S98: inventory
  and inventory_units AGREE on all 27 Glutenull products, and only
  FO-0019 and FO-0022 hold stock. These change the ROUTE, not the
  number. ⚠ SO THE VERIFICATION IS "nothing blanks", NOT "the
  number is right" — it already is.

⚠ THE GAP GREW IN S99 rather than shrank. Two sessions running.
  Left alone this becomes a big-bang promotion. → JOB B, FIRST.
```

---

## QUEUE

⚠ New items at the bottom with the next free number. Claude never
renumbers. Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build. Cosmetic
      to fix, real diagnosis trap.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
      ⚠ ALSO on the PACKING SLIP and the Closed MOs Excel export.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them, do not update.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries companies 466 and 469, unaccounted.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ SECURITY. Both boxes report *** System restart required ***.
      Prod 29 updates, dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1, 2 AND 3 AUG. RESCHEDULE.
P104  No 1.39 intermediate fixture on dev.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY and retire what is covered.
      KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 evalFinalStateElement
          (caller at :138 commented out)
        closed-so.component.ts:165 evalFinalStateElement
          (caller at :136 commented out S99)
        edit-mlc:295 · edit-mlo:245 · start-mlc:151 (lotReceived)
        add-dispatch.component.ts:72 (v1 popup, never opened)
      ⚠ COST TIME TWICE IN S99. Claude nearly copied
        so-management's dead routine into closed-so before
        grepping the caller.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  Mark the deliberate code in the code.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P127  ⚠ ANSWERED S99, differently than framed. The two screens
      share NO orders, so they cannot be compared directly. But
      /Closed-SOs was reading a dead column and is now fixed
      (9b9cf05d). ▶ CLOSED.
P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute. LOW PRIORITY.
      Fold into whichever session next touches Company.js.
P130  EXCEL EXPORTS — the Closed MOs one was fixed S98. The others
      are UNCHECKED. ▶ grep downloadExcel across src.
      ⚠ A file leaves the app. A wrong figure there is harder to
        catch than one on screen.
```

```
NEW IN S99

P131  EDIT CLOSED MO LINE 133 — a unit count printed with the
      WEIGHT label, beside a Kg figure with NO label.
        quantity: qty + " " + uom + " (" + received_qty + ")"
      MEASURED: MO-0009 renders "10.008 Kg (15.290000000000001)".
      The 10.008 is a UNIT COUNT wearing a Kg label; the bracketed
      figure is the real Kg, unlabelled.
      ⚠ DELIBERATELY NOT TOUCHED in fix 5. Out of scope, and
        changing an unscoped line inside a scoped patch is how a
        clean fix becomes an unexplained regression.

P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
      soproducts.product_status · soproducts.status ·
      somanagement.status_id. All frozen at one value across all
      14 orders, including one that shipped 11 against 10 ordered.
      ▶ DECIDE: write them properly, or remove them.
      ⚠ They FAIL SILENTLY. A column full of a plausible number
        looks like a working column. This already cost the
        Closed-SOs screen years of red dots.

P133  do_status NEVER ADVANCES. dispatchorders.do_status stays
      "Created" after a full ship; packingslips.shipped_flag is
      the authoritative shipped state.
      ▶ DECIDE: write it properly or remove it. Same family as P132.
      ⚠ WAS TRAPS ENTRY 8. Moved to the queue S99 on Minty's
        ruling: if it can be fixed it is a job, not a permanent fact.
      ⚠ TRAPS 8 IS RETAINED UNTIL P133 IS FIXED. It protects live
        code — until then, reading do_status still tells a client
        something shipped that did not. TRAPS drops to nine only
        when P133 closes.

P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
      `abletracelab_live` is LIVE on both boxes.
      `abletrace-dev` on dev is DEAD — 251 companies, max id 321.
      `abletrace` is the dormant archive (P101, P109).
      ⚠ A query against the wrong one RETURNS ROWS, not an error.
      ▶ Fold into P109 when the archive is retired, or rename.
```

```
CLOSED IN S99
P127  See above. The screen is fixed; the comparison was
      impossible because the two screens share no orders.
```

---

## P82 — THE ACROBATICS SWEEP

```
DONE, all verified on screen:
  SOManagement.js:182-206              2ae869c   (S98)
  admin-formulation.component.ts:878   a52e4bfc  (S98)
  add-mlo.component.html:87            b8e7248b  (S98)
  closed-mlcs.component.html:79/84     824e0e6d  (S98)
  edit-closed-mlcs.component.ts:126/136  770d3c4f (S99, fix 5)

ATTEMPTED AND REVERTED:
  edit-mlc.component.ts:298            fix 6
  ⚠ received_units DOES NOT REACH /Edit-Mlc. The frontend line is
    correct; the BACKEND ROUTE must return the column first.
    Proven by before-and-after. → PLAN.

STILL OPEN — one frontend fix:
  product-traceability.component.ts:109,161   fix 7
  ⚠ SAME SHAPE AS FIX 6. Before patching, PROVE received_units
    reaches that component. Fix 6 failed for exactly this reason.

STILL OPEN — the sub-items, each its own job:
  P82a  Trace_ProductHeaderView repoint. Two of seven divisions
        are repointable. ⚠ THE VIEW HAS NOT BEEN READ.
  P82b  SOH. ⚠ BLOCKED behind P82a and P82c.
  P82c  Misc release units column. ⚠ NOT STARTED.
        ⚠ NO BACKFILL NEEDED — measured on prod S98,
          rejectmaterialandproduct holds 4 rows, all company 464,
          GLUTENULL ZERO. The risky half of this job is gone.
        ⚠ Adding the column does NOT fix SOH. That is P82a.
  P82e  Trace_ProductProdLotView selects mm.qty twice. Not read.
  P82f  received_qty stores float garbage. ⚠ NOW CONFIRMED BY ROW —
        MO-0009 holds 15.290000000000001. Still unfixed.
  P82g  /Dispatch-orders shows 0# on shipped DOs. ⚠ THE TEMPLATE
        IS CORRECT, proven with cat -A. ▶ Needs a ROW read on
        packingslips / packingslipdos, NOT another code read.

⚠ P82 CANNOT FULLY CLOSE until fix 6, fix 7, P82a and P82c are done.
```

---

## DEV FIXTURE RESIDUE

```
company 464
  test0.7 (FO-0009)   0.7 Kg/unit, single pack level. KEEP.
  test1.39            1.39 Kg/unit. THE STANDING FIXTURE for any
                      conversion test. Never verify on 1:1.
  SO-0013             ⚠ MOVED TO CLOSED AND BACK in S99 as an
                      experiment. Returned to its original state.
  MO-0018             ⚠ CREATED IN S99. test1.39, 10 units.
                      Proves the create path stores 10, not 10.008.
                      KEEP — it is the clean-path evidence.
  MO-0015/0016/0017   S98-S99
  DO-0013/0014 · PS-0028/0029

CORRUPTED PLANNED QUANTITIES — DEV ONLY, DO NOT HEAL
  MO-0007 50.004 · MO-0008/0009/0010/0011 10.008 · MO-0013 1750.08
  ⚠ Residue from before a fix that landed between MO-0013 and
    MO-0014. Recoverable (divide by 1.0008) but NOT WORTH IT —
    this is test data and prod is clean.
  ⚠ DO NOT read these as a live defect next session.

  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
```
