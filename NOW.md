# NOW

Last rewritten: S98, 3 August 2026.
State, pending promotion, and the queue. Rewritten whole every session.

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺129 · 200
          frontend SERVING dev-824e0e6d8548
          backend HEAD 2ae869c · both repos clean
          Ubuntu 24.04.4 · kernel 6.17.0-1017-aws · 172.31.1.196
          ⚠ 12 updates pending · restart required
          ⚠ ↺ went 33 → 128 between S97 and S98 with nothing
            deployed. Cause unknown. Likely the S97 password
            rotation crash-loop. NOT INVESTIGATED.

PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · 200
          Glutenull live · SERVING prod-c2a52d8e129d
          backend HEAD 13e3fcd · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · kernel 7.0.0-1004-aws · 172.31.3.156
          ⚠ 31 updates pending · restart required
          ⚠ Usage of / 63.1% of 18.25GB. Dev is 33.3%.

ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-824e0e6d8548
          prod  /home/ubuntu/www-html.bak-prod-c2a52d8e129d
          ⚠ A backup dir holds the build it REPLACED.

SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
          ⚠ SEPARATE GROUPS. Both boxes KEY-ONLY.

CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small  launched  7 Jul 2026
          prod i-0b54ae374250348e0  t3.small  launched 19 May 2026
COMPANIES GLUTENULL is 471 on prod. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100
```

---

## PENDING PROMOTION TO PROD

⚠ Everything below is PROVEN ON DEV and NOT on prod. Nothing was
promoted in S95, S96, S97 or S98.

```
BACKEND    2ae869c   P124 · SO status compared units to Kg
                     ⚠ GLUTENULL IS EXPOSED TODAY. Fruits & Nut
                       bars are 0.32 Kg/unit, so orders read
                       FULLY SHIPPED while stock is still owed.
                       This is the only pending item with a live
                       client symptom.

FRONTEND   824e0e6d  carries three commits:
             a52e4bfc  Products list stock on hand
             b8e7248b  Add-MLO warehouse stock
             824e0e6d  Closed MOs planned/completed qty + Excel
                     ⚠ NO CLIENT SYMPTOM. Measured on prod S98:
                       formulations.inventory and inventory_units
                       AGREE on all 27 Glutenull products, and
                       only FO-0019 and FO-0022 hold any stock.
                       These are anchor hygiene, not a defect fix.

DATABASE   nothing pending.

⚠ THE ASYMMETRY IS THE RANKING QUESTION: the backend fix has a
  live client symptom, the frontend three do not.
```

---

## QUEUE

⚠ New items at the bottom with the next free number. Claude never
renumbers. Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build. Cosmetic
      to fix, real diagnosis trap.
P17   Two old-account IAM keys still valid, deliberately.
      Sequenced AFTER the app.abletrace.ca switch.
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
      Prod 31 updates, dev 12.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — but prod runs
        a DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1, 2 AND 3 AUG. RESCHEDULE.
P104  No 1.39 intermediate fixture on dev.
P106  acrobatics-map-S91.txt — keep or delete.
P108  ⚠ RE-SCOPED S98. The J-entries are session history and the
      rules now hold the lessons. ▶ Review them WITH MINTY and
      retire what is covered. KEEP JR — the database rebuild
      record cannot live anywhere else. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P111  QUICKBOOKS — one full planning session first. NO CODE.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
        so-management.component.ts:170 evalFinalStateElement
          (caller at :138 commented out)
        edit-mlc:295 · edit-mlo:245 · start-mlc:151 (lotReceived)
        add-dispatch.component.ts:72 (v1 popup, never opened)
      ⚠ Four times in S97 Claude named a live-looking site that
        does not run. A patch to any would have changed NOTHING.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  Mark the deliberate code in the code.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P126  ⚠ ANSWERED S98. formulations.inventory and inventory_units
      AGREE on dev 464 and on prod 471. Right number, wrong route.
      ▶ CLOSED.
```

```
NEW IN S98

P127  TWO SOURCES FOR ONE SO STATUS. /SO-Management COMPUTES the
      dot from quantities (fixed S98, P124). /Closed-SOs READS
      the stored soproducts.product_status and does no
      arithmetic (closed-so.component.ts:165-178).
      ⚠ Raised by the P124 fix, not by a symptom. Whether the
        two agree is UNKNOWN.
      ▶ THE CHECK: find one SO on both screens and compare the
        dots. If they differ, find what WRITES product_status —
        if it uses the old units-vs-Kg comparison, P124 only
        half-fixed the rule.

P129  FOOD SAFETY TOGGLE — company.food_safety_enabled has the
      column and NOT the Waterline attribute, so the write
      vanishes silently (TRAPS 3).
      ⚠ NOT VERIFIED — from the record (JR4, J47), not a test.
      ▶ THE CHECK: SELECT id, company_name, food_safety_enabled
        FROM company; on prod. Then flip the toggle and re-read.
      ▶ THE FIX: declare it in Company.js attributes.
      ⚠ LOW PRIORITY, MINTY'S RULING S98. Fold into whichever
        session next touches Company.js.

P130  EXCEL EXPORTS — added S6 (commit 2e1f21b7) across PO, SO
      and MO screens in one pass. The Closed MOs export was
      found in S98 labelling a unit count as Kg, and fixed. The
      others are UNCHECKED.
      ▶ THE CHECK: grep downloadExcel across src, read what each
        column builds, compare against its own screen.
      ⚠ A file leaves the app. A wrong figure there is harder to
        catch than one on screen.
```

```
CLOSED IN S98

P58   Dev could not push. CLOSED — the PAT is re-embedded in
      dev's BACKEND remote URL, which is how it worked before
      16 July. Dev's frontend remote is deliberately left clean.
P125  Dev DB password rotation. Closed in S97.
P126  See above. Answered by query on both boxes.
```

---

## P82 — THE ACROBATICS SWEEP

```
DONE IN S98, all four verified on screen:
  SOManagement.js:182-206              2ae869c
  admin-formulation.component.ts:878   a52e4bfc
  add-mlo.component.html:87            b8e7248b
  closed-mlcs.component.html:79/84     824e0e6d

STILL OPEN — three fixes, all frontend, all scoped in S97:
  edit-closed-mlcs.component.ts:136    divides units-stored qty,
                                       plus R3 via lotReceived
  edit-mlc.component.ts:298            rebuilds received_qty
  product-traceability.component.ts:109,161  same shape

STILL OPEN — the sub-items, each its own job:
  P82a  Trace_ProductHeaderView repoint. Two of seven divisions
        are repointable. ⚠ THE VIEW HAS NOT BEEN READ.
  P82b  SOH. ⚠ BLOCKED behind P82c.
  P82c  Misc release has no units column.
        ⚠ RE-SCOPED S98 AND MUCH SMALLER THAN RECORDED.
          Measured on prod: rejectmaterialandproduct holds FOUR
          rows, all company 464. GLUTENULL HAS ZERO.
          ▶ SO NO BACKFILL IS NEEDED. The job is: add the column
            on both boxes, declare the Waterline attribute, fix
            the write path.
          ⚠ Adding the column does NOT fix SOH. SOH is the view,
            and that is P82a.
  P82e  Trace_ProductProdLotView selects mm.qty twice. Not read.
  P82f  received_qty stores float garbage. Not read.
  P82g  /Dispatch-orders shows 0# on shipped DOs. Reproduced
        twice in S97. ⚠ THE TEMPLATE IS CORRECT, proven with
        cat -A. ▶ Needs a ROW read on packingslips /
        packingslipdos, NOT another code read.

⚠ P82 CANNOT FULLY CLOSE until P82c and P82a are done.
```

---

## DEV FIXTURE RESIDUE

```
company 464
  test0.7 (FO-0009)   0.7 Kg/unit, single pack level. KEEP.
  SO-0014             5 ordered, 4 shipped. ⚠ YELLOW since the
                      P124 fix — this is the live evidence.
  MO-0015/0016        S97
  MO-0017             Test1.39-IP, 10 units, created S98
  DO-0013/0014 · PS-0028/0029
  ⚠ MAT-6 is missing its Sesame allergen (S73, not reverted)
  ⚠ Ginger Powder MAT-5 carries Eggs (S78, not reverted)
  ⚠ FO-0005 has two-version fork residue (S77)
```
