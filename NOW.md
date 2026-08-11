NOW
Last rewritten: S115, 11 August 2026. State, pending promotion, and the queue. Rewritten whole every session.

✓ S115 SHIPPED TWO THINGS AND NEITHER IS ON PROD'S APPLICATION STACK. 1 BACKEND 2c2da8b — final_qty_kg is DERIVED from the unit figure, dev only. 2 ⚠⚠ THE PROD COLUMN LANDED. mprrecievelots.qty_allocated_units NOW EXISTS ON BOTH BOXES. ▶ THE ONE DIVERGENCE THAT HAS BEEN IN THIS FILE FOR FOUR SESSIONS IS CLOSED.

⚠⚠ THE BOARD: 38 GREEN · 10 RED · 3 REVIEW, of 51. UNCHANGED. ▶ S115 MOVED NO ROW AND WAS NOT MEANT TO. 48 IS THE CEILING.

✓✓ THE SESSION'S REAL OUTPUT IS THE READING, NOT THE COMMIT. THREE THINGS: 1 ⚠⚠ THE UNIT WEIGHT IS NOT IN Formulations.js AT ALL — PLAN SAID "IN REACH" AND THE STRING DOES NOT APPEAR IN THE FILE. → below. 2 ⚠⚠ PLAN'S ORDERING WAS WRONG. The prod ALTER was step (h), LAST. IT CANNOT BE LAST. → RULINGS. 3 A FIXTURE THAT CAN FAIL NOW EXISTS — IP4/P4, and it DID distinguish the two routes. → PART 4.

⚠⚠ WHAT S115 PROVED ABOUT THE MAP — READ BEFORE TRUSTING ANY ADDRESS. PLAN said wgt_kgs_per_unit "IS SERVED TO THE PACKAGING CASCADE FURTHER DOWN THE SAME FUNCTION (:1201 region, fopackaging). IN REACH, NOT FREE." ▶ grep -i "wgt" AND grep -i "kgs" BOTH RETURN ZERO ACROSS THE WHOLE FILE. The cascade uses pack_level and quantity and NO WEIGHT. ⚠ The claim was written from the SHAPE of the code, not from a grep. → LESSONS 1.

STATE
⚠ READ OFF ALL THREE MACHINES AT S115 CLOSE.

DEV       16.55.10.205 · pm2 abletrace-dev ↺264 · 200 · 161.3mb
          frontend SERVING dev-4910b46d76a4c49eee431e1a9b435a0116fc9031
          frontend checkout c2a52d8e — ⚠⚠ STALE BY TWENTY SESSIONS.
            HARMLESS UNTIL SOMEBODY READS IT AS LIVE CODE.
          backend HEAD 2c2da8b · both repos clean
          ⚠⚠ THE BACKEND IS ONE COMMIT AHEAD OF PROD, DELIBERATELY.
          Ubuntu 24.04.4 · 172.31.1.196
          ⚠⚠ 22 UPDATES PENDING, TEN OF THEM SECURITY · restart required.
            WAS 12 AT S114. → P102
          ✓ pm2-ubuntu systemd unit INSTALLED AND ENABLED, S112.

PROD      15.157.38.101 · pm2 abletrace-backend ↺343 · 200 · 164.1mb
          TWO LIVE CLIENTS · SERVING prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
          backend HEAD 4d43bd4 · repo clean
          ⚠ frontend checkout reads 9bce0238 — P8, BY DESIGN, and the
            number is recorded here so nobody investigates it. THE
            ROLLBACK LABEL IS THE ONLY RELIABLE READ OF WHAT IS LIVE.
          Ubuntu 26.04 · 172.31.3.156
          ⚠⚠ 46 UPDATES PENDING · restart required. TWENTY-ONE DAYS. → P102
          ✓ pm2-ubuntu ENABLED — measured S112.
          ✓ RESTART COUNTER DID NOT MOVE THROUGH THE ALTER. 343 before
            and after. An ALTER needs no restart; if it had moved,
            something else did it.

MAC       Mintys-Air-2.lan · frontend repo CLEAN at 4910b46d
          ⚠ THE ONLY MACHINE THAT EDITS THE FRONTEND.
⚠⚠ BACKENDS DIVERGE BY ONE COMMIT, DELIBERATELY.
   dev 2c2da8b        prod 4d43bd4
   ▶ 2c2da8b IS S115a AND IT DOES NOT GO TO PROD ALONE. It changes the
     Kg the release screen shows for an intermediate. Neither client has
     an intermediate, so it is INERT there — but it promotes WITH the
     capture, not before it.
✓ FRONTENDS MATCH    dev 4910b46d...      prod 4910b46d...
✓✓ THE DATABASES NOW MATCH. mprrecievelots CARRIES TWO COLUMNS ON BOTH
   BOXES. qty_allocated (Kg, default NULL) and qty_allocated_units
   (default 0). ⚠ MEASURED ON EACH BOX AFTER THE WRITE.
✓ Trace_MaterialDetails_SP  MATCHES — 3 received_units both boxes (JR23)
✓ BOTH INTERMEDIATE PROCEDURES MATCH — 3 joins, both new columns. JR22.
✓ THE HEADER VIEW    2 divisions each box (JR20)
✓ THE RECEIVING PROC 1 qty column, 2 joins (JR21)
⚠ THIS IS PARITY OF THE APPLICATION STACK, NOT THE MACHINES. J84.
GITHUB    frontend main = 4910b46d   ✓ UNCHANGED THIS SESSION.
                                     ⚠ NO FRONTEND BUILD RAN. dist
                                       folder counts did not move.
          backend  main = 2c2da8b    ✓ PUSHED. 4d43bd4..2c2da8b
          docs     main = <WRITE FROM GITHUB AFTER THE PUSH>
            ⚠⚠ RULES 6 EXISTS FOR EXACTLY THIS. S113 recorded f7fad0b
              and the repo was at 66d376d.
          ⚠⚠ A BUNDLE FILENAME IS NOT A BUILD IDENTIFIER ACROSS BOXES.
            SAME COMMIT, DIFFERENT HASHES — prod builds without source
            maps. ▶ THE PROOF IS `diff -r artifact /var/www/html`,
            WHICH RETURNS NOTHING WHEN IT IS RIGHT.
          ▶ THE STAMP IS THE DEFENCE. TYPE IT IN FULL. → J117.
ROLLBACK  dev   /home/ubuntu/www-html.bak-dev-4910b46d76a4c49eee431e1a9b435a0116fc9031
          prod  /home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031
          ⚠ BOTH HOLD e1a82e02. UNCHANGED — no frontend deploy in S115.
          ⚠ BACKEND ROLLBACK ON DEV is `git reset --hard 4d43bd4`
            then restart. THAT IS ALSO PROD'S CURRENT HEAD.
          ⚠⚠ THE PROD COLUMN ROLLBACK IS:
            ALTER TABLE mprrecievelots DROP COLUMN qty_allocated_units;
            Structure backup: ~/mprrecievelots-before-S115-PROD.sql
            2807 bytes, 1 CREATE TABLE. ⚠⚠ VERIFIED NON-EMPTY BEFORE
            THE WRITE — the J43 trap did not fire this time BECAUSE
            THE CHECK WAS RUN.
          ⚠ FILE BACKUP OF THE PATCHED MODEL, DEV:
            ~/Formulations.js.bak-S115a-20260811-201821  (45570 bytes)
            ⚠⚠ THE PATCH SCRIPT WROTE IT INTO api/models/ AND IT WAS
              MOVED OUT. A .bak INSIDE api/models IS A SAILS HAZARD —
              P153, J32. ▶ FUTURE PATCH SCRIPTS WRITE BACKUPS TO
              /home/ubuntu, NEVER BESIDE THE FILE.

          DATABASE BACKUPS — ⚠⚠ KEEP ALL OF THESE:
            PROD mprrecievelots-before-S115-PROD.sql  ⚠⚠ THE PROD COLUMN
                 ROLLBACK. NEW THIS SESSION.
            DEV  mprrecievelots-before-S112-DEV.sql   ⚠⚠ THE DEV COLUMN
                 ROLLBACK.
            BOTH Trace_MaterialDetails_SP.bak-S113-{DEV,PROD}.txt
                 WhC_GetMoIntermediateProducts_SP.bak-S111-{DEV,PROD}.txt
                 WhC_GetFormulaIntermediateProducts.bak-S111-{DEV,PROD}.txt
                 WhC_GetMoProductReceivingDetails_SP.bak-S110-{DEV,PROD}.txt
                 Trace_ProductHeaderView.bak-S109-{DEV,PROD}.txt
                 WhC_GetMoDetails_SP.bak-S106-{DEV,PROD}.txt
          ⚠ ALL SHOW CREATE TEXT ARE NOT RUNNABLE. A restore needs the
            DELIMITER $$ wrapper. → JR16.
SECURITY  DEV   sg-0301330fdca5ee36f · 22 · 443 · 80 all 0.0.0.0/0
          PROD  sg-034c010b5b20ccf78 · 22 · 443 · 80 all 0.0.0.0/0
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3 · prod i-0b54ae374250348e0 · t3.small
COMPANIES ⚠⚠ TWO LIVE CLIENTS ON PROD.
            471  GLUTENULL1   2 MOs, both complete. 26 release rows.
                              batch_qty 240 and 400. NO INTERMEDIATES.
                              ⚠ 0.32 and 0.24 Kg per unit — ROUND RATIOS.
            469  HAGENSBORG   13 MOs, none run. ZERO release rows.
                              ⚠⚠ batch_qty 1 ON ALL 13. TRAPS 9, permanently.
          ⚠⚠ NEITHER CLIENT HAS EVER CREATED A DISPATCH ORDER.
          ⚠⚠ NEITHER CLIENT HAS EVER RELEASED AN INTERMEDIATE. ✓ RE-
            MEASURED S115: prod 68 rows, 63 material, 5 product, ALL
            FIVE ON SANDBOX 465.
          ⚠ SANDBOXES ON PROD: 464 test260703@ and 465 test260704b@.
            ⚠⚠ 465 IS THE ONE WITH PRODUCT-SIDE ALLOCATION HISTORY.
          ⚠⚠ THE TWO BOXES DO NOT SHARE A COMPANY-ID NAMESPACE. → P156

DATABASES ⚠ THE LIVE DB ON BOTH BOXES IS `abletracelab_live`.
          Plus the dormant `abletrace` archive on each.
          ⚠⚠ THE ARCHIVE HOLDS ITS OWN COPIES OF THE STORED PROCEDURES.
            → P101, and NAME THE SCHEMA in every information_schema
            query or every routine returns twice. → P134.
THE ROLES AND WHO OWNS WHICH SCREEN
  SALES CONTROLLER       CREATES the MO      /MLO-Management → /Edit-MLO
  WAREHOUSE CONTROLLER   RELEASES · RECEIVES · yield · returns
                                             /Mfg-lot-codes → /Edit-Mlc
  PRODUCTION CONTROLLER  STARTS production · RELEASES the lot code
                                             /Start-mlc

⚠ THE ROUTE NAMES LIE ABOUT THE TASK. There is no "edit MO" operation.
⚠ PROD IS REACHED FROM THE MAC. NEVER ssh from dev. ▶ hostname AND git log --oneline -1 AT THE TOP OF EVERY MAC BLOCK. ⚠⚠ THE MAC AND THE BOXES DO NOT SHARE A COMMAND VOCABULARY. hostname -I and cat -A are GNU-only and FAIL LOUDLY on the Mac. ▶ THE ONE TO WATCH IS sed -i, WHICH EXISTS ON BOTH AND BEHAVES DIFFERENTLY.

⚠⚠ WHERE THE UNIT WEIGHT ACTUALLY LIVES — MEASURED S115, AND IT IS NOT
WHERE FOUR SESSIONS OF DOCUMENTS SAID
  Formulations.js grep -i "wgt"   → 0 hits
  Formulations.js grep -i "kgs"   → 0 hits
  ⚠ THE PACKAGING CASCADE USES pack_level AND quantity AND NO WEIGHT.
    :1201 multiplies a cascade count by mlcDetails.qty. That is all.
  ⚠⚠ AND THE THREE PROCEDURES AT THE TOP OF THE FUNCTION ALL TAKE
    req.body.formula_id — THE PARENT. So findPackaging holds the
    PARENT'S packaging (0.41 / 2.05 / 26.65 on P4) and the
    intermediate's own weight is NOT IN THAT SET AT ANY LEVEL.
  ▶ THE ROUTE THAT WORKS, AND IT IS WHAT S115a SHIPPED: CALL
    WhC_GetFormulaPackagingMaterials AGAIN, ONCE PER INTERMEDIATE,
    with the INTERMEDIATE's formulation_id, and read the whd_flag row.
  ✓ MEASURED: CALL ...('3696') returns ONE row, whd_flag 1, 0.37.
    CALL ...('3697') returns FOUR rows, whd_flag on the Pallet, 100.17.
  ⚠ AND THE ALTERNATIVE WAS REJECTED ON MINTY'S RULING: qty ÷ ship_qty
    also yields the weight and WOULD CREATE A SECOND PLACE A UNIT
    WEIGHT LIVES. PART 1 SECTION 2 SAYS THERE IS ONE PLACE.

⚠⚠ AND THE PROCEDURE THAT BLOCKS (b) — MEASURED, NOT ASSUMED
  WhC_GetMoMaterialProductReleaseDetails_SP
    grep -o "qty_allocated" | wc -l   → 1   ⚠ THE KG COLUMN ONLY
    grep -o "join" | wc -l            → 8
    CALL ...('11612') header row      → qty_allocated_units ABSENT
  ▶ SO released_qty_units CANNOT BE SUMMED IN Formulations.js TODAY.
    The value never reaches the code. A sum of it would read undefined
    and bank NaN, SILENTLY. TRAPS 3's shape.
  ✓ THE EDIT IS THE EASIEST SHAPE THIS CAMPAIGN HAS SEEN: ONE SELECT
    STATEMENT, ONE COLUMN PER LINE, `mprrecievelots` IS THE DRIVING
    TABLE SO THE COLUMN IS ALREADY IN SCOPE. NO NEW JOIN.
  ▶ THE ANCHOR, READ OFF THE OBJECT AND UNIQUE:
      `mprrecievelots`.`qty_allocated`,
    ONE LINE ADDED AFTER IT. → JR24, S116.
  ⚠ SEVENTH INSTANCE OF THIS PATTERN — JR16, JR17, JR20, JR21, JR22,
    JR23 were all "the column exists, the join exists, it is simply not
    in the SELECT list".
SCHEMA FACTS — DO NOT REDERIVE
⚠⚠ THE FULL PICTURE IS IN UNITS-BIBLE.txt PART 1.

mprrecievelots       qty_allocated (KG) · qty_allocated_units
                     ✓✓ NOW ON BOTH BOXES. S112 dev, S115 prod.
                     MPR_id · Rec_Lot_id · material_id · Rec_Product_id ·
                     formula_id
                     ⚠⚠ TWO PARALLEL FK PAIRS, AND WHICH IS POPULATED
                       ENCODES THE RELEASE TYPE:
                         material_id + Rec_Lot_id     = MATERIAL
                         formula_id  + Rec_Product_id = PRODUCT
                     ✓ MEASURED S115 CLOSE:
                         DEV  137 rows · 17 product   ⚠ WAS 127 · 16
                         PROD  68 rows ·  5 product   ⚠ ALL FIVE ON 465
                       ▶ TEN ROWS ADDED ON DEV TODAY BY THE IP4 BUILD.
                       ▶ RE-COUNT AT THE GATE. DO NOT CARRY IT FORWARD.
                     ⚠ qty_allocated_units IS 0 ON EVERY ROW OF BOTH
                       BOXES. INCLUDING THE TEN ADDED TODAY.
                       ⚠⚠ ITS DEFAULT IS 0 WHERE qty_allocated's IS NULL.
                         SO AN OMITTED WRITE BANKS A ZERO, INDISTINGUISH-
                         ABLE FROM A REAL ZERO. TRAPS 3's shape.
                         ▶ A ZERO AT S116's GATE IS A FAILURE.
                     ⚠⚠ ROW 84044 IS THE DEFECT, VISIBLE: MPR 11611,
                       formula 3696, qty_allocated 1.793,
                       qty_allocated_units 0. The Kg was banked and the
                       count that belongs beside it never was.
                     ✓✓ qty_allocated IS SUMMED AS Kg IN ALL SIX READ
                       SITES AND LEFT AS Kg. READ IN FULL, S113:
                         Formulations.js :1103 :1136 :1190
                         MLOManagement.js :1097 :1102 :1107
                       ▶ S116 DOES NOT TOUCH THEM, so long as
                         qty_allocated STAYS KILOGRAMS.

receiveproducts      qty (UNITS, per receipt) · recieved_qty (KG) ·
                     prev_received_qty (KG)
                     ⚠ NOTE THE MISSPELLING `recieved_qty`.

mlomanagement        qty (UNITS since S41) · received_qty (KG) ·
                     received_units (UNITS)
                     ⚠ THERE IS NO MPR_id COLUMN ON THIS TABLE. Measured
                       S115 — the query errored. MPR_id reaches the
                       frontend from WhC_GetMoDetails_SP, aliased from
                       elsewhere. ▶ DO NOT SELECT IT FROM mlomanagement.

subrecipeformulation qty (KG) · ship_qty (UNITS)
                     ✓ ZERO null-or-zero ship_qty ON EITHER BOX.
                     ✓✓ MEASURED S115 — ALL 18 ROWS ON DEV HAVE
                       qty ÷ ship_qty EXACTLY EQUAL TO THE PACKAGING
                       WEIGHT. GAP ZERO ON EVERY ROW.
                       ⚠⚠ THAT IS WHY NO EXISTING FIXTURE COULD PROVE
                         S115a. The two routes agree everywhere in the
                         current data. → THE IP4/P4 FIXTURE EXISTS FOR
                         EXACTLY THIS.
                       ▶ AND IT IS WHY MINTY'S DESIGN MATTERS: they
                         agree by convention, not by construction.

formulations         inventory (KG) · inventory_units (UNITS) · batch_qty
                     ⚠ batch_qty IS SHIPPING UNITS PER BATCH, served by
                       WhC_GetMoDetails_SP ALIASED as formula_id__batch_qty.

fopackaging          formulation_id ← NOT `formula_id`
                     wgt_kgs_per_unit ON THE whd_flag ROW IS THE ONLY
                     PLACE A UNIT WEIGHT IS HELD ANYWHERE.
                     ✓✓ MEASURED S115 ON ALL 13 INTERMEDIATES: EVERY ONE
                       HAS EXACTLY ONE whd_flag ROW. No zero, no two.
                     ⚠ WhC_GetFormulaPackagingMaterials SELECTS BARE —
                       no aliases. wgt_kgs_per_unit and whd_flag arrive
                       under their own names.
                     ⚠⚠ ON A MULTI-LEVEL PRODUCT THE whd_flag ROW IS NOT
                       LEVEL 1. P4: Level 1 Pouch 0.41, whd_flag on the
                       CASE at 26.65. PART 1 says Level 1 carries the
                       BASE weight; the whd_flag row carries the
                       SHIPPING-UNIT weight. BOTH ARE TRUE AND THEY ARE
                       DIFFERENT ROWS. ▶ READ whd_flag, ALWAYS.

company              company_name  ← NOT `name`
soproducts           quantity (KG) · NO company_id · NO UNIT COUNT → P138
DATABASE OBJECTS
Trace_MaterialDetails_SP  ✓ JR23, BOTH BOXES. S113.
WhC_GetMoIntermediateProducts_SP   ✓ JR22, BOTH BOXES.
  ⚠⚠ IT ALIASES EVERYTHING. ▶ FEEDS THE INTERMEDIATE PRODUCTS BLOCK.
  ⚠⚠ AND IT IS P196's SITE — see the queue.
WhC_GetFormulaIntermediateProducts ✓ JR22, BOTH BOXES.
  ⚠⚠ IT SELECTS BARE WHERE ITS TWIN ALIASES. undefined, SILENTLY.
  ▶ FEEDS matList / formulaList / packList — THE BATCH MATERIALS BLOCK.
  ✓ MEASURED S115: 0 hits for wgt_kgs_per_unit, 0 for fopackaging,
    3 joins. IT CANNOT SERVE THE WEIGHT AND WOULD NEED A NEW JOIN.
    ▶ THAT IS WHY S115a CALLS THE PACKAGING PROC INSTEAD. Rejected
      route B deliberately — a join here would multiply one
      intermediate into four rows without a whd_flag filter, which is
      row 39's second defect exactly.
WhC_GetFormulaPackagingMaterials  ✓ SERVES wgt_kgs_per_unit AND whd_flag.
  ⚠ JR6 REQUIRES BOTH. Measured S115: 1 each. ▶ S115a's SOURCE.
WhC_GetMoMaterialProductReleaseDetails_SP  ⚠⚠ NEEDS ONE COLUMN. → JR24.
Trace_ProductHeaderView   ⚠ TWO DIVISIONS REMAIN. → JR20, and → S117.
Trace_ProductOneStepBackwardIP_SP  ⚠⚠ TWO DEFECTS. → S117.
Trace_ProductOneStepForwardIP_SP · ...ReleaseDetails_SP  → S117.
WhC_GetMoProductReceivingDetails_SP  ✓ receiveproducts.qty. JR21.
WhC_GetMoDetails_SP  ✓ formula_id__batch_qty. ⚠ THE ALIAS IS THE POINT.

⚠ db-definitions-S93.txt IS STALE ON NINE OBJECTS. → P119.
PENDING PROMOTION TO PROD
BACKEND    ⚠⚠ 2c2da8b IS ON DEV ONLY AND STAYS THERE. It changes the Kg
             shown beside an intermediate on the release screen.
             ✓ INERT ON PROD — neither client has an intermediate, so no
               client row can reach the changed line.
             ▶ IT PROMOTES WITH THE CAPTURE, NOT BEFORE IT. Promoting it
               alone would ship half a design.
FRONTEND   ✓ NOTHING PENDING. 4910b46d on both boxes.
DATABASE   ✓✓ NOTHING PENDING. THE COLUMN IS ON BOTH BOXES.
             ⚠ THE PROCEDURE CHANGE (JR24) IS S116's AND IT MUST GO TO
               BOTH BOXES SEPARATELY. A database object does not travel
               with a deploy.
DOCS       ⚠ S115's OUTPUT PENDING COMMIT:
             NOW.md · PLAN.md · UNITS-BIBLE.txt + .xlsx
             Section_5.md — J125 and JR-note to merge.
           ⚠⚠ WRITE THE GITHUB DOCS LINE FROM GITHUB AFTER THE PUSH.
⚠⚠ RULINGS MADE IN S115 — RECORDED, NOT PENDING
1  ⚠⚠ THE ORDER IS COLUMN, THEN ROUTINE, THEN CODE. PLAN HAD THE PROD
   ALTER AS STEP (h), LAST. IT CANNOT BE LAST — JR24 makes a procedure
   read qty_allocated_units, and a procedure that references a missing
   column is broken the moment it lands.
   ▶ JR1 ALREADY SAYS THIS: "Apply COLUMN adds FIRST — procs and views
     READ these; create them first or the routine is built against a
     missing column." THE RULE EXISTED AND THE PLAN CONTRADICTED IT.
   ✓ MINTY SPLIT THE SESSION AT EXACTLY THAT SEAM — "do the column now
     and the finishing next session" — WHICH IS THE CORRECT ORDER.
   ⚠ AND THE TWO HALVES ARE NOT EQUALLY RISKY, WHICH IS WHY THE SPLIT
     WORKS: THE COLUMN IS INERT (nothing reads it, the attribute is
     already declared on both boxes at 9dac080), THE PROCEDURE IS NOT
     (a wrong procedure breaks a live screen immediately).

2  ⚠⚠ THE UNIT WEIGHT COMES FROM THE FORMULATION'S PACKAGING AND
   NOWHERE ELSE. MINTY, S115, RE-AFFIRMING PART 1 SECTION 2.
   ▶ THREE ALTERNATIVES WERE ON THE TABLE AND TWO WERE KILLED BY THIS:
       the LOT — 15.17 Kg ÷ 41 units = 0.37. WORKS. REJECTED.
       SOH    — 15.597 ÷ 42.154 = 0.37. WORKS. REJECTED.
     BOTH WOULD HAVE CREATED A SECOND PLACE A UNIT WEIGHT LIVES.
   ⚠ THE COST OF THE RULING IS ONE EXTRA DATABASE CALL PER INTERMEDIATE
     ON EVERY RELEASE-SCREEN LOAD. Up to three today. ACCEPTED.

3  ✓ P196 IS DISPLAY-ONLY AND WAITS. Minty, S115: "this is a display
   figure and can be fixed after you complete what you have in plan."

4  ✓ THE FIXTURE WAS BUILT RATHER THAN MO-0004 SPENT. IP4 and P4, at
   Minty's own hand. ⚠⚠ 474 MO-0004 IS STILL THE LAST UNRELEASED
   INTERMEDIATE MO OF THE ORIGINAL SET AND IT IS STILL INTACT.

5  ⚠ THE IP4 RECIPE QUANTITY WAS ENTERED AS 5 UNITS, NOT THE 4 THE SPEC
   ASKED FOR, AND WAS DELIBERATELY LEFT. Changing it would fork the
   formulation (J9b/J81) and the test would run on a forked recipe.
   ✓ 5 GIVES A WIDER DISCRIMINATOR THAN 4 WOULD HAVE. The fixture is
     BETTER as built.
QUEUE
⚠ New items at the bottom with the next free number. Claude never renumbers. Ranking is Minty's.

P8    Prod's frontend checkout lags the served build. ⚠ IT READS 9bce0238.
P17   Two old-account IAM keys still valid, deliberately.
P20   Delete pre-S72 Section J file.  P22  Delete old Section A file.
P62   qty_shipped must never be NULL. ⚠ MEASURED S100 — it never is.
P64   Product label prints "null" for Ext ID twice, on prod. → P10.
      ⚠ SEEN AGAIN S115 — every IP4 and P4 row renders "FO-0010 null".
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale. ▶ DELETE them.
P84   Zebra guide into the app.  P85  Windows printer guide.
P86   Cold boot blindness. ⚠ Both boxes now have a pm2 unit. Untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P90   Strike two false claims in 3A.5 row 7 and 3A.6.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries UNACCOUNTED COMPANIES. ⚠⚠ SUPERSEDED BY P156.
P101  Both boxes carry a dormant `abletrace` archive, AND IT HOLDS ITS
      OWN COPIES OF THE STORED PROCEDURES. → record in 3B.
P102  ⚠⚠ SECURITY. Both boxes report *** System restart required ***.
      ⚠⚠ DEV IS NOW 22 UPDATES, TEN OF THEM SECURITY — WAS 12 AT S114.
        PROD 46. ⚠⚠ TWENTY-ONE DAYS. TWO CLIENTS ON PROD.
      ▶ OWN JOB, OWN GATE. ⚠ IT IS GETTING HEAVIER, NOT LIGHTER.
P106  acrobatics-map-S91.txt — keep or delete.
P108  Review the J-entries WITH MINTY. KEEP JR. Own sitting.
P109  Retire the dormant `abletrace` archive, both boxes.
P111  QUICKBOOKS — one full planning session first. NO CODE.
      ⚠⚠ AFTER THE UNITS CAMPAIGN CLOSES. Minty's ruling S110.
P114  Does a closed MO still count as in progress anywhere?
P115  DELETE THE DEAD CODE SIBLINGS.
      ⚠ STILL OPEN:
        rejected-materials.component.ts:152-154 getShippingUnits — NO CALLER
        MLOManagement.js getMLCbyId (:648) and getMLCbyIdV2 (:424)
        PopUps/add-dispatch (v1) — whole component, never opened
        edit-mlc.component.ts:311 lotReceived consumer — commented out
        edit-mlc.component.ts:227 formulaList.push(data3) — commented out
        MaterialsProductsReleased.js:52 createReleaseMaterialProducts
        MaterialsProductsReleased.js:83-98 — the OLD single-release
          function. ⚠ IT MUST NOT BE MISTAKEN FOR THE LIVE PATH IN S116.
          The live one is the block from :179 down.
        material-traceability-details html:113-125 and html:191-216
        Traceability.js — @returnedQty and @mprIDs, computed, never used
P116  Fix the JSON file-list reads properly.
P117  File too large must say so.
P118  MARK THE DELIBERATE CODE IN THE CODE.
      ✓ PAID FOR ITSELF A NINTH TIME IN S115 — the comment at
        Formulations.js:1159 CALLED ITSELF A STOPGAP, which is what
        identified the exact line to replace. The replacement comment
        now records WHY the extra database call exists, which is the
        thing a future reader would otherwise call carelessness.
P119  Back up the database's own code into the repo. ⚠ STALE ON NINE.
P120  Material label barcode needs the product-label fix.
P121  Say what the "java" process is, in the client guide.
P122  Put the whole printing setup into the client guide, in order.
P123  "Not Secure" troubleshooting into the client guide.
P129  FOOD SAFETY TOGGLE — column present, attribute absent. ⚠ TRAPS 3.
P130  EXCEL EXPORTS — Closed MOs fixed S98. Others UNCHECKED.
P131  EDIT CLOSED MO LINE 133 — unit count with a WEIGHT label.
P132  THREE DEAD STATUS COLUMNS ON THE SO TABLES.
P133  do_status NEVER ADVANCES. ⚠ TRAPS 8 RETAINED UNTIL FIXED.
P134  THREE DATABASES ON DEV AND THE NAMES ARE BACKWARDS.
P135  ⚠ TWO CELLS LEFT OF SIX. ▶ intermediate_prd_su and SOH_su. → S117.
P136  Trace_ProductHeaderView RETURNS DUPLICATE ROWS.
P137  MR NUMBERING IS GLOBAL, NOT PER-COMPANY. ⚠ ASK MINTY FIRST.
P138  soproducts STORES NO UNIT COUNT — Kg only, no company_id.
P139  add-mlo:150 AND :228 LOOK LIKE DEFECTS AND ARE NOT.
P142  ⚠⚠ EDIT/SAVE/RETURN BUTTONS ON /Edit-reject-product ARE COMMENTED OUT.
P145  /Edit-reject-product SHOWS THE SAME NUMBER TWICE. ⚠ ASK MINTY.
P146  THE TWO MR SCREENS DISAGREE ON DECIMAL PLACES. LOW.
P148  ⚠ WITHDRAWN S105. NARROW RESIDUAL only. LOW.
P152  ⚠⚠ read-rows.js SILENTLY DROPS COMPUTED COLUMNS AND ALIASES.
P153  A BACKUP FILE INSIDE api/models/ TAKES SAILS DOWN. LOW.
      ⚠⚠ NEARLY FIRED IN S115 — the patch script wrote its own backup
        into api/models/. Caught and moved. ▶ THE RULE IS NOW: PATCH
        SCRIPTS WRITE BACKUPS TO /home/ubuntu, NEVER BESIDE THE FILE.
P154  ⚠ NO SECOND ROUTE TO A FRONTEND BUILD. LOW.
P155  A Mac push does not update prod's origin until something fetches.
P156  ⚠⚠ HAGENSBORG IS A SECOND LIVE CLIENT, AND THE TWO BOXES DO NOT
      SHARE A COMPANY-ID NAMESPACE.
P158  ⚠⚠ Trace_ProductOneStepBackwardIP_SP — DIVIDES, AND joins
      fopackaging with NO whd_flag filter. → S117.
P159  ⚠ Trace_ProductOneStepForwardIP_SP — divides qty_allocated. → S117.
P163  ⚠⚠ THE PRODUCT-RETURN LOT PICKER IS EMPTY. ▶ THE RETURN PATH.
P164  ⚠⚠ Formulations.js ADDS RETURNS INTO THE RELEASED TOTAL. THE SIGN
      IS INVERTED. ⚠⚠ LIVE ON BOTH CLIENTS.
      ▶ THE RETURN PATH, and Minty ruled it LAST.
P165  ⚠ ReturnMaterialProduct.js — TWO DEFECTS. ▶ THE RETURN PATH.
P166  ⚠ do-details.component.ts:30,54 — a field NAMED ship_qty holds Kg.
P167  ⚠⚠ THE SEVEN-COPY MO QUANTITY HELPER. ▶ OWN SITTING.
P168  ⚠⚠ ONLY ONE RETURN PER MATERIAL IS COUNTED. ▶ RETURN PATH. HIGH.
P169  ⚠ THE STOCK POPUP'S MO CARD TRANSPOSES ITS LABELS. ▶ ROW 48.
P170  ⚠⚠ PRE-JR15 PRODUCT MR ROWS READ LOW IN THE VIEW. ▶ MINTY'S CALL.
P171  ⚠ TWO QUANTITY TABLES HOLD DATA AND APPEAR IN NO MAP.
P172  ⚠ receiveproducts.internalCode IS NOT UNIQUE PER RECEIPT. LOW.
P173  ⚠ THE INTERMEDIATE PRODUCTS BLOCK RENDERS A NAMELESS 0.000 ROW.
      ⚠ SEEN AGAIN S115 on MO-0014 — IP4 has no intermediates of its
        own, so the block renders 0.000# (0.000). EXPECTED. LOW.
P174  ⚠ edit-mlc.component.ts:372 WRITES A FORM CONTROL BACK INTO
      mlcDetails.batches. ⚠ STILL NOT INVESTIGATED.
P175  ⚠ getFormulaByIdForReleaseMaterial :1092 gates on
      `typeof x != undefined`. A gate that cannot fail. LOW.
P176  ⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` is absent
      from both boxes. ⚠⚠ THE PROOF OF A DEPLOY IS
      `diff -r <artifact-dir> /var/www/html` RETURNING NOTHING. MEDIUM.
P178  ⚠⚠ RE-COUNTED AT THE S115 CLOSE:
      DEV 50 dist-dev-* FOLDERS · PROD 26. ✓ NEITHER MOVED — no
      frontend build ran this session.
      ⚠⚠ BUT /tmp IS NOT WHAT S114 RECORDED. DEV HOLDS 57 PYTHON PATCH
        SCRIPTS GOING BACK TO S84. PROD HOLDS ZERO.
        ⚠⚠ S114 COUNTED /tmp/*.js AND FOUND ZERO AND READ IT AS "SOMEBODY
          TIDIED". THE SCRIPTS ARE .py — WE HAVE NOT WRITTEN A .js PATCH
          SINCE S97. THE COUNT MATCHED THE WRONG PATTERN.
        ▶ FOURTH SESSION RUNNING THE TIDY RECORD HAS BEEN WRONG, AND THE
          FIRST TIME THE MEASUREMENT ITSELF WAS WRONG RATHER THAN COPIED.
        ⚠ RULES 5.2 SAYS PATCH SCRIPTS RUN FROM /tmp AND ARE DELETED.
          THAT HAS NOT HAPPENED FOR THIRTY SESSIONS.
      ✓✓ MINTY RULED THE NUMBER, S115: THREE GENERATIONS.
      ▶ THE RULE, AND IT NEEDS NO JUDGEMENT TO APPLY:
          KEEP THE LAST THREE dist-* FOLDERS AND THE LAST THREE
          www-html.bak-* FOLDERS ON EACH BOX, NEWEST BY `ls -1dt`.
          DELETE THE REST. CLEAR /tmp/*.py. EXECUTED AT EVERY CLOSE.
        ⚠⚠ VERIFY THE DEPLOY BEFORE TIDYING. ALWAYS THAT ORDER — S114
          reported a prod deploy complete that had not run, and
          deleting older builds around it is how a rollback goes
          missing.
        ⚠ NEVER DELETE A DATABASE BACKUP OR A COLUMN-ROLLBACK .sql
          UNDER THIS RULE. It governs dist-*, www-html.bak-* and
          /tmp/*.py ONLY.
        ⚠ /tmp WAS CLEARED ON DEV AT THIS CLOSE. THE FOLDERS WERE NOT —
          the rule lands at the S116 close, with the deploy verified
          first.
P179  ⚠ start-mlc.component.html:198 READS `formulations_myCodee` —
      THREE E's. Renders blank, silently. One-character fix. LOW.
P180  ⚠ THE BUILD WORKFLOW WARNS Node.js 20 is deprecated. LOW.
P182  ⚠ THREE MORE INTERMEDIATE CONTROLS IN NO DOCUMENT. MEDIUM.
P184  ⚠⚠ THE RELEASE WRITE PATH DERIVES UNITS FROM A WEIGHT AND
      SUBTRACTS THEM FROM THE CORE STOCK LINE.
      ✓✓ MEASURED S114 — 42.15405405405406 STORED WHERE 42.154 IS TRUE.
      ⚠ THE WRONG VALUE IS STILL IN formulations id 3696 ON DEV.
      ▶ CLOSES AS PART OF S116. HIGH.
P185  ⚠ eval() IS USED TO SUM QUANTITIES ON THE RELEASE SCREEN.
      ⚠⚠ FIVE SITES — :239 :322 :399 :439 :456. MEDIUM.
P188  ⚠⚠ DISSOLVED BY MINTY'S S114 DESIGN. ▶ CLOSES WITH S116.
P189  ⚠ MLOManagement.js :1097 AND :1102 SUM THE SAME MATERIAL TWICE
      UNDER DIFFERENT GUARDS. ⚠ NOT INVESTIGATED. LOW.
P190  ⚠ material-traceability-details.component.ts:171 subtracts two
      VARCHAR strings. Works by coercion. LOW.
P191  ⚠⚠ THE RELEASE SCREEN HAS A LOT-CODE SCANNER AND IT IS IN NO
      DOCUMENT. ✓ MATERIALS-ONLY AND CORRECT. ▶ ITS OWN SITTING.
P192  ⚠ final_qty IS ALSO BUILT IN THE FRONTEND, FROM `batches`.
      release-mat-details.component.ts :1071 :1083 :1095. MEDIUM.
P193  ⚠ released_qty IS ACCUMULATED IN THE FRONTEND AFTER EACH RELEASE.
      :866 ADDS UNITS INTO A Kg RUNNING TOTAL once the basis changes.
      ▶ IT IS PART OF S116, NOT A SEPARATE JOB.
P194  ⚠ THE oldRecProducts BLOCK RENDERS PRIOR ALLOCATIONS IN Kg. LOW.
P195  ⚠ THE PER-LOT ERROR MESSAGE READS remaining_qty IN Kg. → S116.
NEW IN S115
P196  ⚠⚠ THE TWO INTERMEDIATE BLOCKS ON THE MO DETAIL SCREEN NOW DERIVE
      THE Kg BY DIFFERENT ROUTES AND VISIBLY DISAGREE.
      MEASURED ON 474 MO-0015, ON BOTH /Edit-MLO AND /Edit-Mlc:
        Intermediate Products   IP4  1.957# (43.689 Kg)   OLD route
        Batch Materials         IP4  1.957# (43.700 Kg)   NEW route
      ▶ Batch Materials is served by getFormulaByIdForReleaseMaterial,
        which S115a fixed. Intermediate Products is served by
        MLOManagement.js:393 via WhC_GetMoIntermediateProducts_SP and
        still scales subrecipeformulation.qty.
      ⚠ ELEVEN GRAMS. BOTH FIGURES ARE DISPLAY — NEITHER IS STORED, AND
        NEITHER FEEDS THE WRITE PATH.
      ⚠⚠ IT IS ROW 49's SHAPE REPEATING: the same figure rendered twice,
        two blocks apart, disagreeing. A client can act on a wrong
        number; nobody can act on two that disagree.
      ✓ MINTY'S RULING S115: display only, fix AFTER the capture lands.
      ▶ THE FIX IS S115a's SHAPE IN A DIFFERENT FILE. MEDIUM.

P197  ✓ CLOSED S115. Dev's /tmp held 57 PYTHON PATCH SCRIPTS going back
      to S84; CLEARED AT THIS CLOSE. Prod was already zero.
      ⚠⚠ RULES 5.2 ALREADY REQUIRED THIS. The rule existed and was not
        applied for thirty sessions. ▶ IT IS NOW PART OF P178's RULE so
        it happens without anyone having to remember.
✓ CLOSED IN S115 — DELETE THESE LINES AT S116 CLOSE
P187 · P186 · P181   ✓ closed in S113, still listed.
P177 · P183          ✓ closed in S112, still listed.
P160 · P162          ✓ closed in S111, still listed.
P151 · P157          ✓ closed in S110, still listed.
P147 · P161          ✓ closed in S109, still listed.
P104 · P150          ✓ closed in S108, still listed.
TIDY AT THE NEXT CLOSE — NOT BEFORE
⚠⚠ READ THE DIRECTORY AT THE CLOSE. DO NOT COPY THIS LIST FORWARD. ⚠⚠ AND COUNT THE RIGHT THING — S114 COUNTED /tmp/*.js, FOUND ZERO, AND CONCLUDED SOMEBODY HAD TIDIED. THE SCRIPTS ARE .py.

COUNTED AT THE S115 CLOSE:
  MAC    dist-*.zip in ~/Downloads — NOT COUNTED THIS SESSION
  DEV    50 dist-dev-* folders · /tmp/*.py ✓ CLEARED, 57 → 0
  PROD   26 dist-prod-* folders · 0 /tmp/*.py · 0 /tmp/*.js
  ⚠ THE FOLDERS WERE NOT TOUCHED. P178's rule is set but lands at the
    S116 close, after the deploy is verified. ▶ VERIFY, THEN TIDY.
  ✓ RE-COUNTED AFTER THE CLEAR: dist-dev-* STILL 50, and the newest
    three www-html.bak-dev-* are 4910b46d, e1a82e02 and 2968c591.
    ⚠ THAT WAS CHECKED BECAUSE TERMINAL OUTPUT WAS PASTED BACK INTO THE
      SHELL DURING THE TIDY — RULES 5.1. Every line failed as
      "command not found" and NOTHING WAS DELETED, confirmed by count
      rather than by assumption. ⚠⚠ S106 RECORDS THE SAME PASTE
      SILENTLY EATING A git pull. THE BURST IS NOT THE DANGER; WHAT IT
      SWALLOWS IS.

KEEP, WHATEVER THE RULE:
  dist-dev-4910b46d* · www-html.bak-dev-4910b46d*      LIVE
  dist-prod-4910b46d* · www-html.bak-prod-4910b46d*    LIVE
  www-html.bak-{dev,prod}-e1a82e02*                    ROLLBACK
  ~/mprrecievelots-before-S112-DEV.sql    ⚠⚠ DEV COLUMN ROLLBACK
  ~/mprrecievelots-before-S115-PROD.sql   ⚠⚠ PROD COLUMN ROLLBACK, NEW
  ~/Formulations.js.bak-S115a-*  on dev   ⚠ the pre-S115a model
  ALL *.bak-S106/S109/S110/S111/S113 DATABASE BACKUPS, BOTH BOXES
  ~/mo-0001-before-heal-S93.txt on prod  → P94, decide separately

▶ THE RULE ITSELF IS P178 AND IT IS MINTY'S TO SET.
THE LESSONS S115 EARNED
1  ⚠⚠ "IN REACH, NOT FREE" WAS A GUESS DRESSED AS A MEASUREMENT, AND
   TWO GREPS DISPROVED IT. PLAN said the unit weight was served to the
   packaging cascade in the same function. The string does not appear
   anywhere in that file. The claim was written from the SHAPE of the
   code — there is a packaging cascade, packaging holds weights,
   therefore the weight must be there.
   ▶ A CLAIM ABOUT WHAT A FILE CONTAINS COSTS ONE GREP. Make it, or
     write it down as unknown.
   ⚠ SIXTH MIS-SCOPED CLAIM THIS CAMPAIGN.

2  ⚠⚠ THE FIXTURE WAS BUILT BECAUSE A QUERY PROVED NO EXISTING ONE
   COULD WORK. Before asking Minty to build anything, every intermediate
   on dev was compared: stored qty ÷ ship_qty against the packaging
   weight. GAP ZERO ON ALL EIGHTEEN ROWS.
   ▶ SO THE OLD ROUTE AND THE NEW ROUTE AGREE ON EVERY ROW THAT EXISTS,
     AND NO EXISTING SCREEN COULD HAVE TOLD THEM APART. The MO-0004
     check confirmed the patch broke nothing and PROVED NOTHING ELSE —
     which was said out loud BEFORE it was run.
   ▶ IP4/P4 GAVE 43.700 AGAINST 43.689. A CHECK THAT COULD FAIL.
   ⚠ AND IT NEEDED THREE PACK LEVELS, NOT ONE. IP-0.37 is single-level,
     so its Level 1 row and its whd_flag row are the SAME ROW and a
     wrong-row read is invisible. IP4's are 0.29 and 22.33.

3  ⚠⚠ MINTY SPLIT THE SESSION BETTER THAN CLAUDE PROPOSED. Claude
   recommended closing with the whole database half undone. Minty:
   "will it not be better to do the column now and do the finishing in
   next session."
   ▶ THE COLUMN IS INERT AND THE PROCEDURE IS NOT. Claude had lumped
     two operations of very different risk into one "database half" and
     recommended deferring both. The seam was in the wrong place.
   ✓ AND IT CLOSED A DIVERGENCE THAT HAD BEEN IN NOW FOR FOUR SESSIONS.

4  ⚠⚠ A PATCH SCRIPT PUT ITS OWN BACKUP IN THE ONE DIRECTORY THE
   DOCUMENTS NAME AS DANGEROUS. Formulations.js.bak-S115a-* landed
   inside api/models/. P153 and J32 both say a .bak there is a Sails
   hazard. Caught on reading the script's output, moved immediately.
   ⚠ THE ROLLBACK WAS GIT ANYWAY. The file backup was belt-and-braces
     that introduced a hazard.
   ▶ PATCH SCRIPTS WRITE BACKUPS TO /home/ubuntu. NEVER BESIDE THE FILE.

5  ⚠⚠ THREE ROUTES TO THE SAME NUMBER, AND THE RULE PICKED THE ONE THAT
   COSTS MORE. The lot knows its own unit weight (15.17 ÷ 41). So does
   SOH (15.597 ÷ 42.154). Both were offered and both were REJECTED,
   because PART 1 says the weight lives in ONE place.
   ▶ A RULE THAT ONLY EVER AGREES WITH THE CHEAP ANSWER IS NOT DOING
     ANY WORK. This one cost an extra query per intermediate.

6  ⚠ COUNTING THE WRONG PATTERN IS WORSE THAN NOT COUNTING. S114 wrote
   "/tmp/*.js IS NOW ZERO ON BOTH BOXES — somebody tidied and did not
   record it" into a file whose own instruction is COUNT IT, DO NOT
   DESCRIBE IT. Dev held 57 .py scripts back to S84.
   ▶ THE MEASUREMENT MUST MATCH WHAT THE THING ACTUALLY IS.
   ✓ CLEARED AT THIS CLOSE, AND MINTY SET P178's NUMBER AT THREE —
     so the next session applies a rule rather than a judgement.

7  ⚠ TWO SCREENS WERE READ AS THE WRONG SCREEN, TWICE, BEFORE THE RIGHT
   ONE WAS FOUND. MO-0014 is the IP4 MO and has no intermediates of its
   own; MO-0015 is the P4 MO and is on PAGE TWO of a ten-row list.
   ▶ NAME THE MO NUMBER AND SAY WHICH PAGE. A screenshot of the wrong
     screen cannot fail the check either.
