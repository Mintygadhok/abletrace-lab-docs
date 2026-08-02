# NOW

Last rewritten: S97, 2 August 2026.
State and queue. Rewritten whole every session, committed at close.

---

## WHAT S97 DID

```
⚠ NO CODE CHANGED. NOTHING DEPLOYED. NO FIX LANDED.
  The session scoped P82's screen group by reading code, and
  confirmed one live defect. Seven sites are now ready to fix.

THE WALK — DONE, AND IT WAS THE WRONG TOOL FOR MOST OF IT
  Four hours of screen-walking produced FOUR WRONG THEORIES from
  Claude, all withdrawn. Twenty minutes of greps produced the
  entire site list.
  ⚠ THE LESSON IS NOW A RULE: a screen settles what the app DOES.
    Only the code line settles WHICH ROUTE made a number, and only
    the caller settles whether it RUNS. → RULES, LOOK.

⚠ THE FIXTURE ERROR WORTH KNOWING: test0.7 was built at 0.7 Kg per
  unit specifically to expose a hidden division (7 ÷ 0.7 =
  6.999999999999999). Every screen rounds to THREE DECIMALS, so a
  divided value and a stored value printed identically. The same
  blind spot as a 1:1 fixture, reintroduced through the formatter.
  ⚠ The fixture is still valuable — it proved the outbound chain
    and it makes shape errors unmissable. It cannot see divisions.

CONFIRMED DEFECT — SO STATUS COMPARES UNITS TO Kg
  SO-0014: 5 units ordered (3.5 Kg), 4 shipped → GREEN "Fully
  Shipped" with a unit still owed. Predicted, then reproduced.
  ⚠ THE SITE IS THE BACKEND — SOManagement.js:182-206. The
    frontend function that looks identical is DEAD. → J114, P124.

THE OUTBOUND CHAIN RECONCILES — measured end to end on test0.7
  MO → receive → SO → DO → packing slip → ship. Buckets move
  correctly at every hop. 8 in store + 2 shipped = 10 produced.
  ⚠ Receive CANNOT break the anchor — Quantity (Kg) is locked and
    derived on the form. Measured, not assumed.

⚠ FOUR CLAUDE THEORIES PROPOSED AND DISPROVEN. Recorded so nobody
  re-derives them:
    "the allocation buckets are broken"    disproven on a clean
                                           fixture
    "0.666# is a division artefact"        it was real residue
    "a foreign MO in the Stock Info popup" it is the edit gate,
                                           deliberate
    "a missing dot in dispatch-orders"     THE DOT IS THERE. The
                                           grep dropped it. → J114
  ⚠ ALL FOUR WERE PROPOSED BEFORE LOOKING.

⚠ THE DEV DATABASE PASSWORD REACHED THE CHAT TRANSCRIPT, TWICE.
  Dev only. Not internet-reachable on 3306. MINTY RULED: rotate at
  the close. → P125 if it was not done.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺33 · frontend HEAD c2a52d8e
          backend 13e3fcd · both repos clean · 200
          Ubuntu 24.04.4 · kernel 6.17.0-1017-aws · 172.31.1.196
          ⚠ 17 updates pending, 5 security · restart required
PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · Glutenull live
          SERVING prod-c2a52d8e129d (read from the newest backup dir)
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8).
          backend 13e3fcd · both repos clean · 200
          Ubuntu 26.04 · kernel 7.0.0-1004-aws · 172.31.3.156
          ⚠ 31 updates pending · restart required
          ⚠ Usage of / 63.1% of 18.25GB. Dev is 31.9%.
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
          ⚠ SEPARATE GROUPS. Both boxes KEY-ONLY, no password path.
ROLLBACK  prod: /home/ubuntu/www-html.bak-prod-c2a52d8e129d
          dev:  /home/ubuntu/www-html.bak-dev-c2a52d8e129d
          ⚠ TWELVE-character build code. Read off the box, never
            written from the build label.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small  launched  7 Jul 2026
          prod i-0b54ae374250348e0            launched 19 May 2026
GLUTENULL company_id 471. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100
KEY       ~/.ssh/abletrace-lab-key.pem on the MAC. Measured S97.
```

---

## COMMITS THIS SESSION

```
CODE       NONE.
DATABASE   NONE.
INFRA      NONE.
DOCS       NOW rewritten · PLAN written · RULES LOOK item amended ·
           Section 5 J114 appended.
⚠ NO NEW FILES. One patch script (fix-do-shipped-qty-S97.py) was
  written, ABORTED CORRECTLY on its own assertion, and is deleted.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items at the bottom
with the next free number. Claude never renumbers.

```
CARRIED FORWARD, still open
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P58   Dev remotes do not carry the PAT. Minutes to fix.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
      ⚠ ALSO SEEN S97 on the PACKING SLIP — Product External Code
        renders the literal word "null" on a customer document.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them, do not update.
P84   Zebra guide into the app.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers. §2, 3B, 4, 6
      and README not yet read.
P90   Strike two false claims in 3A. ⚠ READY, NEEDS NO BOX.
      3A.5 row 7 and 3A.6. ▶ Strike both WITH a pointer to J113.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries companies 466 and 469, unaccounted.
P101  3B.3 records the dormant `abletrace` archive on PROD only.
      ⚠ DEV HAS ONE TOO.
P102  ⚠ THE SECURITY ITEM, NOT HOUSEKEEPING. Both boxes report
      *** System restart required ***. Prod 31 updates, dev 17.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST. Dev first — prod runs a
        DIFFERENT OS and dev does not rehearse it.
      ⚠ MISSED 1 AUG AND AGAIN 2 AUG. RESCHEDULE.
P104  No 1.39 intermediate fixture on dev.
P106  acrobatics-map-S91.txt — keep or delete.
P107  units-kg-checklist-S93.md ⚠ NOW CONSUMED. Its items 2 and 3
      were all read in S97. ▶ SAFE TO DELETE.
P108  J-entries accumulate and nothing ages them out. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
      ⚠ IRREVERSIBLE. Dump off-box first. Own sitting.
P110  RULES simplification drafted S95, not adopted.
P111  QUICKBOOKS — one full planning session first. NO CODE.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ S97 ADDED FOUR PROVEN-DEAD SITES:
        so-management.component.ts:170 evalFinalStateElement
          (caller at :138 commented out)
        edit-mlc:295 · edit-mlo:245 · start-mlc:151 (lotReceived
          assigned, its only consumer commented out)
      ⚠ THIS IS NOW A REAL PROBLEM, NOT TIDINESS. Four times in
        S97 Claude named a live-looking site that does not run.
        A patch to any of them would have deployed and changed
        NOTHING.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  Mark the deliberate code in the code.
P119  Back up the database's own code into the repo.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
```

```
NEW IN S97

P124  ⚠ SO STATUS COMPARES UNITS TO Kg — CONFIRMED LIVE DEFECT.
      SOManagement.js:182-206, BACKEND.
        dispatchedQty += DO.qty_shipped     UNITS
        soQty         += product.quantity   KILOGRAMS
        if (soQty <= dispatchedQty) → GREEN
      ⚠ PROVEN: SO-0014, 5 ordered (3.5 Kg), 4 shipped → GREEN.
      ⚠ FAILS BOTH WAYS. Under 1 Kg/unit greens too early; over
        1 Kg/unit never greens at all.
      ⚠ GLUTENULL IS EXPOSED — Fruits & Nut bars are 0.32 Kg/unit,
        so the EARLY-GREEN direction is live on prod today.
      ▶ FIX: populate packing_id on the DO find, then MULTIPLY
        qty_shipped by wgt_kgs_per_unit. → PLAN fix 1.
      ⚠ MINTY'S RULING, S97: A DO CAN SHIP MORE OR LESS THAN
        AUTHORISED. So the status must follow qty_shipped, not
        qty_to_ship. This is what rules out the no-conversion fix.
      ⚠ SECOND SITE, NOT YET READ: closed-so.component.ts:136
        computes finalState in the FRONTEND by its own route.
        Two implementations of one rule.

P125  ROTATE THE DEV DATABASE PASSWORD.
      It reached the chat transcript twice in S97.
      ⚠ Dev only. RDS is not internet-reachable on 3306, so the
        real exposure is low — but it is permanent.
      ▶ J39 METHOD: generate straight into a file, never printed,
        set in the RDS console, sync .env, verify 200 and login.
      ⚠ CLOSE THIS OR CARRY IT. Do not let it drift.

P126  ⚠ DO inventory AND inventory_units AGREE TODAY?
      One query. It decides the SEVERITY of PLAN fixes 2 and 3.
        AGREE     → right number, wrong route. Fix at leisure.
        DISAGREE  → the Products list and Add-MLO are showing a
                    WRONG STOCK FIGURE. Top of the list.
      ▶ Answer it BEFORE starting fix 2.
```

---

## P82 — THE ACROBATICS SWEEP

```
⚠ THE SCREEN GROUP IS SCOPED. Seven sites, all paths verified,
  all read in the file. → PLAN. DO NOT RE-INVESTIGATE THEM.

⚠ P82 CANNOT FULLY CLOSE IN S98. P82b (SOH) is structurally
  blocked behind P82c, a schema change on two databases.

  P82a  R5 view repoint. Scoped J113. ⚠ THE VIEW HAS NOT BEEN
        READ. Gate queries cannot be written until it is.
  P82b  SOH. BLOCKED behind P82c.
  P82c  Misc release has no units column. Schema, both boxes,
        plus the Waterline attribute (TRAPS 3). Own session.
  P82d  ⚠ CLOSED AS AN INVESTIGATION, S97. Every read of
        quanity_shipped_to_date was found. The comparison sites
        ARE P124. The add-dispatch:72 divide is DEAD CODE (v1
        popup). stock-info:99 reads it raw — fine.
  P82e  Trace_ProductProdLotView selects mm.qty twice. NOT READ.
  P82f  received_qty stores float garbage. NOT READ.
  P82g  /Dispatch-orders shows 0# on shipped DOs. Reproduced
        TWICE in S97 on fresh DOs.
        ⚠ THE TEMPLATE IS CORRECT. Proven with cat -A after a
          grep artefact suggested a missing dot. → J114.
        ▶ NEEDS A ROW READ on packingslips / packingslipdos.
          NOT another code read.
  P82h  ⚠ DONE. The walk is complete and the checklist is
        consumed. → P107 can be deleted.
```

---

## WHAT COST TIME IN S97

```
1  ⚠ FOUR HOURS OF SCREEN-WALKING FOR A QUESTION SCREENS CANNOT
   ANSWER. Every figure renders to three decimals, so a divided
   value and a stored value print identically. Two fixtures were
   built and neither could discriminate.
   ▶ THE FIX IS THE NEW RULE: code line for route, caller for
     reachability. Twenty minutes of greps did what four hours
     of screens could not.

2  ⚠ FOUR SITES NAMED THAT DO NOT RUN. Commented-out callers sit
   beside live functions throughout this codebase. → P115.

3  ⚠ A GREP DROPPED A CHARACTER AND NEARLY COST A WORKING FILE.
   The "missing dot" in dispatch-orders does not exist. The
   assert-anchored patch refused to write. → J114, and it is
   J83's artefact recurring.

4  ⚠ THREE OF FOUR FILE PATHS IN THE RECORD WERE STALE.
   ▶ find first. Never paste a path from an old document.

5  ⚠ THE TERMINAL WAS PASTED BACK INTO ITSELF REPEATEDLY, once
   leaving the shell at a bquote prompt.
   ▶ Copy ONLY from a fenced block. Never from terminal output.

6  ⚠ A PLACEHOLDER WENT INSIDE A COMMAND BLOCK (<your-pem>) and
   was pasted literally. RULES forbids this and S94 earned it.
```
