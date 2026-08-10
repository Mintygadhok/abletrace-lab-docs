# NOW

Last rewritten: S111, 9 August 2026. State, pending promotion, and the queue.
Rewritten whole every session.

✓ S111 SHIPPED FIVE THINGS AND ALL FIVE ARE ON BOTH BOXES.
  3b176720  the intermediate requirement and stock, frontend
  e8e8f572  the Batch Materials stock line, frontend — ⚠ SUPERSEDES 3b176720
  fc78ce1   Formulations.js:1156, BACKEND
  JR22      WhC_GetMoIntermediateProducts_SP, database, each box
  JR22      WhC_GetFormulaIntermediateProducts, database, each box
  ▶ NOTHING IS PENDING PROMOTION. The boxes are in step on all four layers.

⚠⚠ THE BOARD: 34 GREEN · 0 PART · 10 RED · 4 REVIEW, of 48.
  ▶ THE "PART" STATUS RETIRES. It existed for one session and no row wears it.
  ▶ 44 IS THE CEILING — unless row 49 is accepted, when it becomes 45 of 49.
  ⚠ ROW 49 NEEDS MINTY'S RULING. See DECISIONS below.

⚠⚠ P102 IS NOT WHAT THE QUEUE LINE SAYS. Dev has NO pm2 systemd unit —
  `systemctl is-enabled pm2-ubuntu` returns `not-found`. A reboot would take
  the app down and nothing would bring it back. MEASURED S111, dev only.
  ▶ PROD IS UNMEASURED. → P177, and P102 rewritten.

---

## STATE
⚠ READ OFF BOTH BOXES AT S111 CLOSE.

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺262 · 200
          frontend SERVING dev-e8e8f5724cdfb9dc0734daabf5b10ae5d91ce8d4
          frontend checkout c2a52d8e — stale, harmless
          backend HEAD fc78ce1 · both repos clean
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠ 12 UPDATES PENDING — WAS 8 AT S110. restart required
          ⚠ ↺ MOVED 261 → 262. The fc78ce1 restart.
          ⚠⚠ NO pm2 SYSTEMD UNIT. pm2 save WAS run — dump.pm2 is current,
            9931 bytes — but nothing starts pm2 at boot. → P177

PROD      15.157.38.101 · pm2 abletrace-backend ↺342 · 200
          TWO LIVE CLIENTS · SERVING prod-e8e8f5724cdfb9dc0734daabf5b10ae5d91ce8d4
          backend HEAD fc78ce1 · both repos clean
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8)
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING at S110. NOT RE-READ AT S111 CLOSE. → P102
          ⚠ ↺ MOVED 341 → 342. The fc78ce1 restart.
          ⚠⚠ pm2 STARTUP UNIT NOT MEASURED HERE. Assume the dev finding
            applies until proven otherwise. → P177
```

```
✓ BACKENDS MATCH     dev fc78ce1                prod fc78ce1
✓ FRONTENDS MATCH    dev e8e8f572...            prod e8e8f572...
✓ BOTH INTERMEDIATE PROCEDURES MATCH — 3 joins each, both new columns,
  read back OUT OF THE DATABASE on each box. JR22.
✓ THE HEADER VIEW    2 divisions on each box (unchanged, JR20)
✓ THE RECEIVING PROC 1 qty column, 2 joins, each box (unchanged, JR21)
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
```

```
GITHUB    frontend main = e8e8f572   ✓ BUILT AND DEPLOYED BOTH BOXES
          backend  main = fc78ce1    ✓ PULLED TO BOTH BOXES
          docs     main = ⚠ READ IT AT THE COMMIT. See the note below.
          ⚠⚠ S110's NOW CONTRADICTED ITSELF ON THIS LINE. Its GITHUB block
            said "docs main = 20536b9 ✓ S110 CLOSE COMMITTED" while its
            PENDING PROMOTION block, forty lines lower, listed the same
            files as pending. BOTH CANNOT BE TRUE.
            ▶ RULES 6 SAYS WRITE THE GITHUB LINE FROM GITHUB. Do it at
              this commit and do not carry the old number forward.
          ⚠ RUN #56 (30b2ddd4) — the J117 regression artifact. Status
            still UNKNOWN. ▶ NEVER DEPLOY A dist-*-30b2ddd* ZIP.
          ⚠⚠ AND S111 ADDED TWO MORE SUPERSEDED ARTIFACTS:
              dist-dev-3b176720   green, correct code, ONE COMMIT BEHIND
              dist-prod-bc03b22d  green, and it is THIS MORNING'S BUILD
            ⚠ THE SECOND ONE WAS DOWNLOADED AND ALMOST DEPLOYED. Caught
              by reading the stamp. → LESSONS.
          ⚠ THE DEFENCE IS UNCHANGED AND IT IS THE ONLY ONE THAT MATTERS:
            READ THE COMMIT STAMP IN THE ARTIFACT FILENAME. TYPE IT IN FULL.
            NEVER TAKE THE NEWEST BY POSITION.
          ⚠ BUILD ANNOTATION, BOTH RUNS: "Node.js 20 is deprecated ...
            forced to run on Node.js 24". Informational; builds succeed.
            → P180.
```

```
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-e8e8f5724cdfb9dc0734daabf5b10ae5d91ce8d4
          prod  /home/ubuntu/www-html.bak-prod-e8e8f5724cdfb9dc0734daabf5b10ae5d91ce8d4
          ⚠ EACH HOLDS THE BUILD IT REPLACED, NOT THE ONE IT IS NAMED
            AFTER. dev's holds 3b176720. prod's holds bc03b22d.
          ⚠ READ OFF THE BOX AT CLOSE, never from the label.
          ⚠ BACKEND ROLLBACK is `git reset --hard 9230789` then restart.

          DATABASE BACKUPS on each box — ⚠⚠ KEEP ALL OF THESE:
            WhC_GetMoIntermediateProducts_SP.bak-S111-{DEV,PROD}.txt
              ⚠⚠ CURRENT. 1279 bytes · 3 joins · BYTE-IDENTICAL across boxes
            WhC_GetFormulaIntermediateProducts.bak-S111-{DEV,PROD}.txt
              ⚠⚠ CURRENT. 1149 bytes · 3 joins · BYTE-IDENTICAL across boxes
            WhC_GetMoProductReceivingDetails_SP.bak-S110-{DEV,PROD}.txt ⚠⚠ KEEP
            Trace_ProductHeaderView.bak-S109-{DEV,PROD}.txt  ⚠⚠ KEEP
            WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt (+ .after-)
          ⚠ ALL ARE SHOW CREATE TEXT, NOT RUNNABLE. A restore needs the
            DELIMITER $$ wrapper added. → JR16.
```

```
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  · prod i-0b54ae374250348e0 · t3.small
```

```
COMPANIES ⚠⚠ TWO LIVE CLIENTS ON PROD.
            471  GLUTENULL1   2 MOs, both complete. 26 release rows.
                              MO-0001 1750# @0.32 Kg · MO-0002 802# @0.24 Kg
                              ⚠ batch_qty 240 and 400.
                              ⚠ NO INTERMEDIATES. S111 is invisible here.
            469  HAGENSBORG   13 MOs, none run. ZERO release rows.
                              ⚠⚠ batch_qty IS 1 ON EVERY ONE. TRAPS 9 on a
                                live client, permanently.
                              ⚠ NO INTERMEDIATES either.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
          ⚠ 464 test260703@ and 465 test260704b@ are SANDBOXES on prod.
          ⚠⚠ S111 CHECKED PROD THROUGH GLUTENULL'S OWN LOGIN, as S110 did.
            Stronger evidence. Keep doing it where the figure is a client's.

⚠⚠ THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE.
  DEV 469 = test260710@.  PROD 469 = HAGENSBORG.
  ▶ NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX. → P156

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each (P101, P109).
          ⚠⚠ S111 MEASURED SOMETHING NEW: THE ARCHIVE HOLDS ITS OWN COPIES
            OF THE STORED PROCEDURES. An unfiltered information_schema
            query returned every routine TWICE. → P101, and it sharpens
            P134: NAME THE DATABASE ON EVERY mysql CALL, AND THE SCHEMA IN
            EVERY information_schema QUERY.
```

## THE ROLES AND WHO OWNS WHICH SCREEN
⚠⚠ MINTY, S110. THIS COST FIVE SESSIONS TO LEARN AND WAS IN NO DOCUMENT.

```
  SALES CONTROLLER       CREATES the MO      /MLO-Management → /Edit-MLO
  WAREHOUSE CONTROLLER   RELEASES · RECEIVES · yield · returns
                                             /Mfg-lot-codes → /Edit-Mlc
  PRODUCTION CONTROLLER  STARTS production · RELEASES the lot code

⚠ THE ROUTE NAMES LIE ABOUT THE TASK. There is no "edit MO" operation.
⚠⚠ BOTH MO DETAIL SCREENS CARRY AN INTERMEDIATE PRODUCTS BLOCK AND A
  BATCH MATERIALS BLOCK, AND S111 PROVED THE FIX ON BOTH. /Edit-MLO via
  the Sales Controller and /Edit-Mlc via the Warehouse Controller.
  ▶ start-mlc.component.html CARRIES THE SAME TWO BLOCKS and was patched
    identically. NOT screen-proven — it is the Production Controller's
    screen and was not opened. ⚠ THE CODE IS IDENTICAL, WHICH IS AN
    ARGUMENT AND NOT A PROOF. → P181.
⚠ TWO MORE INTERMEDIATE CONTROLS EXIST AND ARE IN NO DOCUMENT:
    edit-mlc.component.html:223   <mat-label>Intermediate Products</mat-label>
    edit-mlo.component.html:319   same
    edit-closed-mlcs.component.html:77  same
  ⚠ NOT READ. They may be filter labels rather than figures. → P182.
```

⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev.
  ▶ PUT `hostname -I` AT THE TOP OF ANY BLOCK. It earned its place in S111 —
    it errored on macOS and stopped a block that had drifted to the wrong box.
  ⚠⚠ AND THE ONE ENVIRONMENT DOES NOT CATCH: `cd ~/abletrace-lab-frontend`
    WORKS ON BOTH MACHINES. A patch script run on dev's copy edits files
    that the next deploy overwrites. SILENTLY. See LESSONS.

---

## THE FIXTURES — ⚠ DO NOT DISTURB.

### COMPANY 474 · test260805@ · on DEV — THE INTERMEDIATE FIXTURE

```
IP-0.37      FO-0004   0.37 Kg/unit   batch_qty 19   inventory_units 47
Parent-0.53  FO-0005   0.53 Kg/unit   batch_qty 13
             Pouch / Carton 3 / Case 7 / Pallet 9
             Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units
             ⚠ subrecipeformulation id 1044: qty 3.33 Kg, ship_qty 9 units.
               RE-MEASURED S111. BOTH POPULATED AND CORRECT.

MO-0003  IP-0.37, 41 units, COMPLETE, lot Pdt-260807-1. ONE RECEIPT.
MO-0004  Parent-0.53, 23 pallets, CREATED, NOT RELEASED
         ⚠⚠ LEAVE IT ALONE. STILL THE BEFORE PICTURE.
         ⚠ MINTY ASKED IN S111 WHETHER TO RUN IT. THE ANSWER IS NO AND THE
           REASON IS WORTH KEEPING: the Intermediate Products block renders
           on a CREATED MO, so nothing needs releasing to read it. Running
           it would spend the fixture for no gain.
MO-0005  IP-0.37, 13 units, lot Pdt-260808-1, COMPLETE. TWO RECEIPTS.
MR-0009  Ginger Powder, 10 Kg, reason Sample. MATERIAL.
DO-0002  IP-0.37, 7 units typed, packing_units STORED AS 7.

⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS. TRAPS 9.

✓✓ ALL THREE PROOFS ON MO-0004 ARE NOW CLOSED.
  1  ✓ S110. Plan Quantity and the Ginger Powder requirement both 2303.910 Kg.
  2  ✓ S111. IP-0.37 Qty required 15.923 — A UNIT COUNT. Was 5.892 Kg.
  3  ✓ S111. WH Stock 47.000 — A UNIT COUNT. Was 17.390 Kg.
  ✓ AND BOTH BLOCKS AGREE at 47.000. → BIBLE ROW 49.

⚠⚠ THE CONTROLS HELD AT EVERY STEP. Pouch 4347.000 Ea · Carton 1449 ·
  Case 207 · Pallet 23. AND Ginger Powder 2303.910 Kg / 9796.983 Kg.
  ▶ THE GINGER POWDER STOCK FIGURE IS NOW A NAMED CONTROL. It is rendered
    by the matList loop, the line DIRECTLY ABOVE the one row 49 changed,
    reading the SAME property name. Pouch sits directly below.
    ⚠ WHEN A PATCH IS SCOPED TO A BLOCK, THE CONTROLS ARE THE BRACKETING
      LINES. A count proves a string changed; the neighbours prove it
      changed in the right place.

⚠ A DISPLAY QUESTION LEFT OPEN, DELIBERATELY: the unit figures now render
  with a "Kg" suffix — "15.923 Kg", "47.000 Kg" — because unit_name comes
  from the formulation's UOM. THE NUMBER IS RIGHT AND THE LABEL IS WRONG.
  ▶ MINTY'S CALL, and Claude's view is to batch it with rows 44 and 48 as
    a labelling job rather than fix it here. → P183.
```

### COMPANY 464 · test260703 · on DEV — THE OLDER FIXTURES

```
FO-0004 / test1.39 / 1.39 Kg per unit / MO-0007
  DOs in all three bucket states. ⚠ DO NOT DELETE DO-0016.
  ⚠ DO-0008 and DO-0009 carry packing_units 0.5 — THE FRACTIONAL FIXTURE.
⚠⚠ MO-0002 CARRIES **TWO** 2 Kg GINGER POWDER RETURNS. → P168's proof.
MO-0011  A 2 Kg GINGER POWDER RETURN. → P164's fixture.
  ⚠⚠ DO NOT CLEAR EITHER.
⚠ 464 IS A DIRTY BASELINE — MAT-6 missing its Sesame (S73), MAT-5 carrying
  Eggs (S78), FO-0005 fork residue (S77).
```

---

## SCHEMA FACTS — DO NOT REDERIVE

```
⚠⚠ THE FULL PICTURE IS IN UNITS-BIBLE.txt PART 1.

formulations.batch_qty  ⚠⚠ SHIPPING UNITS PER BATCH.
                     dev 474: FO-0004 = 19, FO-0005 = 13.
                     prod: Glutenull 240 and 400; Hagensborg 1 on all 13.
                     ▶ SERVED BY WhC_GetMoDetails_SP AS
                       `formula_id__batch_qty` — ⚠⚠ ALIASED, NOT BARE.

subrecipeformulation  qty (KG) · ship_qty (UNITS) · sub_recipe_id ·
                     formulation_id
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX.
                     ▶ NO HEAL WAS NEEDED IN S111 AND NONE IS OUTSTANDING.

formulations.inventory / inventory_units
                     ⚠⚠ BOTH ARE NOW SERVED BY BOTH INTERMEDIATE
                       PROCEDURES. The Kg column is deliberately retained —
                       removing it would change the row shape for no gain,
                       the same reasoning as JR21.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty`.
                     ⚠ internalCode IS NOT UNIQUE PER RECEIPT. → P172.

mprrecievelots       qty_allocated (KG) · TWO PARALLEL FK PAIRS.
                     ⚠ NO UNIT COLUMN. → STEP 5.

returnmpreceivelots  ⚠⚠ AN EXACT TWIN OF THE ABOVE, column for column.

rejectmaterialandproduct  qty_rejected (KG) · qty_rejected_units
                     ⚠⚠ EVERY PRE-S103 ROW HOLDS 0. → P170.

company              company_name  ← NOT `name`
fopackaging          formulation_id ← NOT `formula_id`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
```

---

## DATABASE OBJECTS

```
⚠ BOTH BOXES CAN READ ROUTINE BODIES. ~/.my.cnf, chmod 600.

WhC_GetMoIntermediateProducts_SP   ✓ S111, JR22. BOTH BOXES.
  ▶ NOW SERVES subrecipeformulation_ship_qty AND
    formulations_inventory_units. 1279 → 1408 bytes. 3 joins, unchanged.
  ⚠⚠ IT ALIASES EVERYTHING. Both new columns are aliased.
  ⚠ CALLER: MLOManagement.js:393. The :621 copy is COMMENTED OUT.
  ▶ FEEDS mlcDetails.intermediateProducts → THE INTERMEDIATE PRODUCTS BLOCK.

WhC_GetFormulaIntermediateProducts ✓ S111, JR22. BOTH BOXES.
  ▶ NOW SERVES bare ship_qty AND bare inventory_units. 1149 → 1236 bytes.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. WRITING AGAINST THE WRONG
    CONVENTION RETURNS undefined, SILENTLY.
  ⚠ CALLER: Formulations.js:1083, inside getFormulaByIdForReleaseMaterial.
  ▶ FEEDS matList / formulaList / packList → THE BATCH MATERIALS BLOCK.
  ⚠⚠ THE PAIRING ABOVE WAS PROVEN IN S111 BY READING THE ngFor COLLECTIONS,
    NOT BY REASONING. Earlier plans had it the other way round.

Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20.
  ▶ intermediate_prd_su and SOH_su. BOTH BLOCKED ON STEP 5's SCHEMA.
  ⚠⚠ TRAPS 10 LIVES HERE AND IT IS LIVE.

WhC_GetMoProductReceivingDetails_SP  ✓ SERVES receiveproducts.qty. JR21.
WhC_GetMoDetails_SP  ✓ SERVES formula_id__batch_qty. ⚠ THE ALIAS IS THE POINT.
Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS IN ONE OBJECT.

⚠ db-definitions-S93.txt IS STALE ON EIGHT OBJECTS NOW. → P119.
```

---

## PENDING PROMOTION TO PROD

```
BACKEND    ✓ NOTHING PENDING. fc78ce1 on both boxes.
FRONTEND   ✓ NOTHING PENDING. e8e8f572 on both boxes.
DATABASE   ✓ NOTHING PENDING. JR22 applied to both boxes.
DOCS       ⚠ S111's OUTPUT PENDING COMMIT:
             NOW.md · PLAN.md · UNITS-BIBLE.txt + .xlsx
             Section_5.md — J121 + JR22 TO MERGE, and CORRECT ITS OWN
               HEADER to J121 / JR22 / S111.
           ⚠⚠ WRITE THE GITHUB DOCS LINE FROM GITHUB AFTER THE PUSH.
             S110's NOW contradicted itself on exactly this. RULES 6.
```

---

## ⚠⚠ DECISIONS WAITING ON MINTY

```
1  BIBLE ROW 49 — does the Batch Materials stock site stand as its own row?
   IF YES the board is 35 of 49 and the ceiling is 45.
   IF NO  fold it into row 33 and the board stays 34 of 48.
   ▶ CLAUDE'S VIEW: keep it. Different block, different loop, different
     data path. A row describing two sites is how an address goes wrong.

2  THE "Kg" SUFFIX beside the corrected unit figures. → P183.
   ▶ CLAUDE'S VIEW: batch it with rows 44 and 48 as a labelling job.

3  P102 IS NOW A DIFFERENT JOB. It is a startup-configuration task with a
   reboot at the end, not a reboot. → P177.
```

---

## QUEUE
⚠ New items at the bottom with the next free number. Claude never renumbers.
Ranking is Minty's.

```
P8    Prod's frontend checkout lags the served build.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.  P22  Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod. → P10.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.  P85  Windows printer guide.
P86   Cold boot blindness, untested. ⚠⚠ SHARPENED BY P177 — it is not
      untested any more on dev, it is KNOWN BROKEN there.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive.
      ⚠⚠ MEASURED S111: THE ARCHIVE HOLDS ITS OWN COPIES OF THE STORED
        PROCEDURES. An unfiltered information_schema query returns every
        routine twice. Nothing was written to it. ▶ RECORD THIS IN 3B.
P102  ⚠⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠⚠ REWRITTEN S111. THIS IS NOT A REBOOT JOB. IT IS A STARTUP-
        CONFIGURATION JOB WITH A REBOOT AT THE END. → P177 IS THE
        PRECONDITION AND IT IS NOT MET.
      ⚠ dev 12 updates. prod 46 at S110, NOT RE-READ.
      ⚠⚠ SEVENTEEN DAYS RUNNING. TWO CLIENTS ON PROD.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠⚠ MINTY'S RULING S110: IT STARTS AFTER THE UNITS CAMPAIGN CLOSES.
        The clients are new and carry almost no data, so schema and anchor
        changes are cheap NOW and get harder as they build history.
      ⚠ FOUR THINGS WILL MEET IT: TRAPS 3 · J97's multiple invoices ·
        P138 · P137.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ STILL OPEN:
        rejected-materials.component.ts:152-154 getShippingUnits — NO CALLER
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
        PopUps/add-dispatch (v1) — whole component, never opened
        edit-mlc.component.ts:311 lotReceived consumer — commented out
      ⚠ NEW SIBLING FOUND S111: edit-mlc.component.ts:227, a commented-out
        `this.formulaList.push(data3)` directly above the live push at :243.
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A FIFTH TIME IN S111 — S110's own comment above
        :1156 explained the scaling factor and made the basis change
        obvious. ✓ MINTY APPROVED A SECOND COMMENT LINE THERE. The two now
        read as a pair: S110 explains the factor, S111 explains the basis.
P119  Back up the database's own code into the repo. ⚠ STALE ON EIGHT.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, attribute absent. ⚠ TRAPS 3.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
      ⚠ SHARPENED S111: edit-mlo.component.ts:557 IS an export site and it
        was wrong. The exports are not a separate world from the screens.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
      ⚠⚠ EXTENDED S111: name the SCHEMA in every information_schema query
        too, or the archive's copies double every result.
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. STEP 5.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
      ⚠⚠ DO NOT "FIX" THESE LINES.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE COMMENTED OUT.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE. ⚠ ASK MINTY.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. ⚠ ASK MINTY. LOW.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. ⚠ ASK MINTY. LOW.
P155  A Mac push does not update prod's origin until something fetches.
      ✓ HELD AGAIN IN S111 — fetch, pull, READ HEAD, then restart.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT SHARE
      A COMPANY-ID NAMESPACE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins fopackaging
      with NO whd_flag filter. ▶ STEP 5. MEDIUM.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. ▶ STEP 5.
P160  ✓ CLOSED S111. BOTH INTERMEDIATE PROCEDURES NOW SERVE ship_qty AND
      inventory_units, ON BOTH BOXES. Bible rows 32/33/34/36 green, plus
      row 49. ⚠ DELETE THIS LINE AT THE S112 CLOSE.
P162  ✓ CLOSED S110 — the rounding half. ✓ THE BASIS HALF CLOSED S111.
      ⚠ DELETE THIS LINE AT THE S112 CLOSE.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. ▶ STEP 6.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL.
      ▶ THE SIGN IS INVERTED. ⚠ LIVE ON BOTH CLIENTS.
      ⚠ SEEN AGAIN IN S111 — `released_qty = sum` is THREE LINES BELOW the
        line that was patched, and `returnSum` is still declared and never
        assigned. DELIBERATELY NOT TOUCHED.
      ⚠ ACCEPTED RISK, MINTY'S CALL, MADE KNOWINGLY. ▶ STEP 6.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ STEP 6. MEDIUM.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. ▶ OWN SITTING.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. ▶ STEP 6. HIGH.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ BIBLE ROW 48.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. ▶ MINTY'S CALL.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT. LOW.
P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW when a
      product has no intermediates.
      ⚠ CONFIRMED AGAIN S111 on prod Glutenull MO-0002, AFTER the change.
        Pre-existing, unaffected, still LOW.
P174  ⚠ edit-mlc.component.ts:372 WRITES BACK INTO mlcDetails.batches.
      ⚠ HARMLESS TO S111's FIX TOO — the templates read getFactor(), which
        reads qty and batch_qty, not batches. ⚠ STILL NOT INVESTIGATED.
P175  ⚠ getFormulaByIdForReleaseMaterial :1092 gates on `typeof x != undefined`.
      A gate that cannot fail is not a gate. ⚠ Harmless today. LOW.
P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN.
      ⚠⚠ S111 USED THE python3 ONE-LINER FOUR MORE TIMES, on both boxes.
        `unzip` IS ABSENT FROM BOTH. ▶ RECORD IT IN 3B.4. MEDIUM.
```

### NEW IN S111

```
P177  ⚠⚠ pm2 DOES NOT START ON BOOT. `systemctl is-enabled pm2-ubuntu`
      returns `not-found` ON DEV. MEASURED S111.
      ⚠ pm2 save WAS run, so ~/.pm2/dump.pm2 is current (9931 bytes) — but
        a dump is only read by a pm2 that something has started. NOTHING
        STARTS IT.
      ⚠⚠ PROD IS UNMEASURED. Assume the same until proven otherwise. A
        reboot there takes TWO LIVE CLIENTS down with no automatic return.
      ⚠ THIS MAY BE THE MECHANISM BEHIND S105's "dev failed to boot
        silently" — it may never have been a crash-loop at all. ⚠ THAT IS A
        HYPOTHESIS, NOT A FINDING. Do not write it up as fact.
      ▶ THE FIX IS `pm2 startup` (which prints a sudo command), then
        `pm2 save`, then verify. ⚠ IT INSTALLS A NEW SYSTEMD UNIT ON A LIVE
        CLIENT BOX AND NEEDS ITS OWN GATE.
      ▶ P102 CANNOT PROCEED UNTIL THIS IS DONE. HIGH.

P178  ⚠ PROD CARRIES SIXTEEN OLD dist-prod-* BUILD FOLDERS, back to
      2ae0b4ab, and only TWO www-html.bak-*. Dev is similar.
      ⚠ NOT A HAZARD — deploy-frontend.sh takes an explicit label, so
        nothing picks one accidentally. It is disk on a t3.small.
      ⚠ NOW's TIDY LIST HAS NEVER MENTIONED THEM. ▶ DECIDE A RETENTION
        RULE — Claude suggests keep the last three. LOW.

P179  ⚠ start-mlc.component.html:198 READS `formulations_myCodee` — THREE
      E's. Every other copy reads myCode. It renders blank, silently.
      ⚠ SEEN WHILE PATCHING THE LINE BELOW IT. NOT TOUCHED — not this
        session's job. ▶ ONE-CHARACTER FIX. LOW.

P180  ⚠ THE BUILD WORKFLOW WARNS "Node.js 20 is deprecated ... forced to run
      on Node.js 24". Both S111 runs. Builds succeed.
      ▶ IT WILL STOP BEING FORCED EVENTUALLY. Update the action versions
        before that happens rather than after. LOW.

P181  ⚠ start-mlc.component.html WAS PATCHED IN BOTH S111 COMMITS AND WAS
      NEVER SEEN ON A SCREEN. It is the Production Controller's screen.
      ⚠ THE CODE IS BYTE-IDENTICAL TO THE TWO PROVEN TEMPLATES, WHICH IS AN
        ARGUMENT AND NOT A PROOF. Same shape as S109's row 23, which sat
        green-but-unproven for a session and turned out fine.
      ▶ ONE SCREEN CHECK AT THE NEXT OPEN. LOW, BUT DO IT.

P182  ⚠ THREE MORE INTERMEDIATE CONTROLS EXIST AND ARE IN NO DOCUMENT:
        edit-mlc.component.html:223 · edit-mlo.component.html:319 ·
        edit-closed-mlcs.component.html:77 — all <mat-label>Intermediate
        Products</mat-label>.
      ⚠ NOT READ. They may be filter labels rather than figures. ▶ READ
        THEM BEFORE ASSUMING THE INTERMEDIATE SWEEP IS COMPLETE. MEDIUM.

P183  ⚠ THE UNIT FIGURES NOW CARRY A "Kg" SUFFIX. "15.923 Kg" and
      "47.000 Kg" are correct unit counts wearing the product's UOM.
      ⚠ THE NUMBER IS RIGHT AND THE LABEL IS WRONG — the reverse of where
        this campaign started.
      ▶ MINTY'S CALL. Claude's view: batch with bible rows 44 and 48 as a
        labelling job. LOW.
```

### ✓ CLOSED IN S111 — DELETE THESE LINES AT S112 CLOSE

```
P160  ✓ BOTH PROCEDURES SERVE BOTH COLUMNS ON BOTH BOXES.
P162  ✓ THE BASIS HALF IS CLOSED. The whole item is done.
P151 · P157   ✓ closed in S110, still listed.
P147 · P161   ✓ closed in S109, still listed.
P104 · P150   ✓ closed in S108, still listed.
```

---

## TIDY AT THE NEXT CLOSE — NOT BEFORE

⚠⚠ NOW's S110 TIDY LIST WAS WRONG. It named six Mac zips including
  f4c98e91 and 0dad104d pairs to delete. AT S111 OPEN THERE WERE THREE and
  both stale pairs were already gone. Somebody tidied and did not record it.
  ▶ READ THE DIRECTORY AT THE CLOSE. DO NOT COPY THE PREVIOUS LIST FORWARD.

```
MAC    ~/Downloads — SIX dist zips at S111 close:
         dist-prod-e8e8f572...zip                    ⚠⚠ KEEP — LIVE PROD
         dist-dev-e8e8f572...zip                     ⚠⚠ KEEP — LIVE DEV
         dist-prod-bc03b22d...zip                    keep, prod rollback
         dist-dev-bc03b22d...zip                     keep, dev rollback
         dist-prod-bc03b22d... (1).zip               ⚠ DELETE — A DUPLICATE
           downloaded by mistake mid-session. macOS renamed it.
         dist-dev-3b176720...zip                     ⚠ DELETE — SUPERSEDED
       ⚠⚠ VERIFY BY STAMP, NEVER BY BRACKET NUMBER OR POSITION.

DEV    ~/dist-dev-3b176720*.zip AND ITS FOLDER        delete, superseded
       ~/dist-dev-e8e8f572*.zip AND ITS FOLDER        keep, live
       ~/www-html.bak-dev-3b176720*                   delete
       ~/www-html.bak-dev-e8e8f572*                   ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-dev-bc03b22d*                   keep one generation
       ~/*.bak-S111-DEV.txt                           ⚠⚠ KEEP BOTH
       ~/fix-mo-inter-S111.sql · fix-formula-inter-S111.sql  keep this session
       ~/fix-recv-S110.sql                            delete
       ~/Trace_ProductHeaderView.bak-S109-DEV.txt     ⚠⚠ KEEP
       ~/WhC_GetMoProductReceivingDetails_SP.bak-S110-DEV.txt ⚠⚠ KEEP
       /tmp/b2.js /tmp/b3.js /tmp/p1.js /tmp/p2.js    delete

PROD   ~/dist-prod-e8e8f572*.zip AND ITS FOLDER       keep, live
       ~/www-html.bak-prod-e8e8f572*                  ⚠⚠ KEEP — LIVE ROLLBACK
       ~/www-html.bak-prod-bc03b22d*                  keep one generation
       ~/*.bak-S111-PROD.txt                          ⚠⚠ KEEP BOTH
       ~/fix-mo-inter-S111-PROD.sql · fix-formula-inter-S111-PROD.sql  keep
       ~/dist-prod-* — SIXTEEN OLD FOLDERS            → P178, decide a rule
       /tmp/q1.js /tmp/q2.js                          delete

⚠ RULES 6: tidy at the close and ONLY at the close.
⚠⚠ DO NOT DELETE THE S106, S109, S110 OR S111 .bak FILES. They are the only
  rollback for database objects on a LIVE CLIENT DATABASE.
```

---

## THE LESSONS S111 EARNED

```
1  ⚠⚠ AN ADDRESS IS A CLAIM, AND SIX OF THEM WERE WRONG IN ONE SESSION.
   Four had drifted by about six lines because S110's OWN COMMIT inserted a
   comment and two const lines above them. Two frontend addresses in PLAN
   were wrong, and one carried a WRONG INSTRUCTION with it — "d is the FORM,
   make it read this.mlcDetails" when `d` was already the MO object.
   ▶ WHEN A COMMIT INSERTS LINES, EVERY ADDRESS BELOW IT IS STALE. Correct
     them in the same close.
   ▶ AND ANCHOR ON TEXT, NEVER A LINE NUMBER. Row 34's recorded :1150 is a
     REAL LINE doing a REAL, DIFFERENT thing — the pencil-edit restore.
     Patching by number would have hit it.

2  ⚠⚠ A ROW CAN DESCRIBE ONE SITE WHEN THERE ARE TWO, AND A HALF-FIXED
   SCREEN IS WORSE THAN A CONSISTENTLY WRONG ONE. Between the two S111
   commits, dev showed the same product's stock as 47 units in one block and
   17.390 Kg in the other, ONE BLOCK APART. A client can act on a wrong
   number; nobody can act on two that disagree.
   ▶ THAT STATE SHIPPED TO NOTHING BECAUSE THE SECOND FIX LANDED FIRST. The
     decision to do it in-session rather than defer was Minty's, and it was
     right. → BIBLE ROW 49.

3  ⚠⚠ WHEN THE SAME LINE IS RIGHT IN ONE PLACE AND WRONG IN ANOTHER, SCOPE
   BY STRUCTURE, NOT BY STRING. {{getQty(item?.inventory)}} appears three
   times per template and TWO OF THE THREE ARE CORRECT — materials and
   packaging are Kg-anchored BY RULE. The patch split each file on the two
   loop declarations and asserted 3 occurrences before, 1 inside the block,
   2 after.
   ▶ AND THE PROOF WAS THE BRACKETING LINES, NOT THE COUNT. Ginger Powder
     above and Pouch below, both unmoved, both reading the same property.

4  ⚠⚠ A CHECK COPIED FROM ONE LAYER TO ANOTHER STOPS BEING A CHECK. JR16's
   "grep DEFINER= must return 0" is true of the BUILT FILE. Claude applied
   it to SHOW CREATE on the live object and set the pass condition at 0.
   MySQL ALWAYS records a definer on CREATE — the check could not have
   passed for any procedure that exists.
   ▶ RE-ASK WHAT A CHECK MEANS WHEN YOU MOVE IT. Third mis-scoped check this
     campaign, after JR7e's schema-less grep and S110's bare curl.

5  ⚠⚠ AN ASSERTION THAT COUNTS ITS OWN INSERTION IS JT27 AND IT FIRED AGAIN,
   IN THE SESSION THAT HAD JT27 IN FRONT OF IT. A guard demanded `ship_qty`
   appear once; the inserted alias contains it TWICE.
   ✓ THE SCRIPT REFUSED TO WRITE. The guard did its job.
   ▶ ASSERT ON THE ALIAS, WHICH IS UNIQUE, NOT THE COLUMN NAME.

6  ⚠⚠ THE FRONTEND REPO EXISTS ON BOTH MACHINES, AND THAT IS THE ONE
   WRONG-BOX CASE ENVIRONMENT DOES NOT CATCH. A missed `exit` put
   `cd ~/abletrace-lab-frontend` on DEV. Read-only that time. A patch script
   would have edited files the next deploy overwrites — SILENTLY, with the
   screen never changing and no error anywhere.
   ✓ `hostname -I` CAUGHT THE OTHER ONE by erroring on macOS. It is a
     tripwire and it works BY FAILING. Keep it at the top of every block.

7  ⚠⚠ TWO SUPERSEDED ARTIFACTS WERE DOWNLOADED IN GOOD FAITH AND ONE WAS
   OFFERED FOR DEPLOYMENT. dist-prod-bc03b22d is green, real, and was THIS
   MORNING'S BUILD. Deploying it would have put the old frontend back while
   the procedures and backend had already moved.
   ▶ THE RUN NUMBER IS A SECOND SIGNAL AND IT IS FREE. 31324660398 is lower
     than 31345895357, therefore older. Read the stamp; check the run.

8  ⚠ A LONG HEREDOC TRUNCATED FOR THE THIRD TIME IN THREE SESSIONS. 21 lines
   hung the shell at `heredoc>`; the 11-line rewrite worked first time.
   ▶ PLAN'S 12-LINE RULE IS NOT A STYLE PREFERENCE.

9  ✓ THE MEMORY FIGURE PROVED ITSELF TWICE IN ONE SESSION. Dev 26.1mb →
   164.6mb, prod 21.4mb → 156.8mb, both while pm2 said "online".
   ▶ READ THE MEMORY, NOT THE STATUS. 15 seconds, not 8.

10 ⚠⚠ THE QUEUE LINE FOR P102 CARRIED ITS OWN PRECONDITION FOR SESSIONS AND
   NOBODY RAN IT. "VERIFY PM2 STARTS ON BOOT FIRST" was in the item. The
   first time it was checked, it came back negative.
   ▶ A PRECONDITION WRITTEN DOWN AND NEVER RUN IS NOT A CONTROL. If an item
     names a check, run the check before scheduling the work.
```
