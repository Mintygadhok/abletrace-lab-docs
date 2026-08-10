══════════════════════════════════════════════════════════════════════
══════════════════════════════════════════════════════════════════════
SECTION 5 — PATCHWORK LOG
Deliberate deviations, DB-only changes not in git, and standing traps.
Structure (rebuilt S72): JT (traps) · JR (rebuild checklist) · J-ENTRIES.
⚠ J holds KNOWLEDGE, not work. Pending work lives in Section 1 (NOW).
Original J-numbers are PERMANENT — never renumber, cross-refs depend on
them. Append new entries at the bottom of J-ENTRIES with the next free
number. Highest is J121 — ⚠ the next one is J122, regardless of how many entries exist (there are original gaps at J8, J30–J31, J54–J59). Highest trap is JT27. Last restructured: S72, Jul 16 2026. Highest JR is JR22. Last appended: S111, Aug 9 2026.
⚠ J116 IS NOT A STANDALONE ENTRY. It was assigned inside JR15 and is easily
missed by anyone scanning for J-headings. That is why this header said J115 for
four sessions. S85 and S86 both asked for it to be corrected; S107 did it.
══════════════════════════════════════════════════════════════════════

TRAPS
──────────────────────────────────────────────────────────────────────
⚠ THE STANDING TRAPS THAT WERE HERE MOVED TO TRAPS.md IN S95 (P105).
  JT1–JT22 are in that file, verbatim, with their numbers intact.
  Later traps (JT23–JT27) remain inside their session appends below,
  in place, as history. NEW TRAPS GO TO TRAPS.md — never here.

JR — FRESH-DB REBUILD CHECKLIST
Everything in the database that is NOT in git. Git gives you a working
app pointed at a database that silently does the WRONG THING until every
step below is re-applied. None of these fail loudly. They fail quietly
and wrongly.
Supersedes J40 (S53), which stopped at 8 items and is now stale.
Source files: /home/ubuntu/*.sql on PROD (see JR9 — this is a risk).
Order matters: JR1 first, then columns, then routines, then data.
Last verified current: S72.
──────────────────────────────────────────────────────────────────────

JR1. ORDER OF OPERATIONS — do not improvise this.
     1. Load structure + routines (--no-data --routines dump).
     2. Apply COLUMN adds (JR2, JR3, JR4) — procs and views READ these;
        create them first or the routine is built against a missing column.
     3. Apply ROUTINE fixes (JR5, JR6, JR7).
     4. Load SEED + reference data (JR8).
     5. Apply RDS config (JR9).
     6. Verify every item below present BEFORE onboarding anyone.

JR2. formulations.inventory_units  [J11]
     ALTER TABLE formulations ADD COLUMN inventory_units double DEFAULT 0;
     The Core Stock Line (live balance, moves both ways).
     ⚠ ALSO declare in Formulations.js attributes or writes silently drop (JT2).
     Backup: /home/ubuntu/formulations-schema.bak-S46.sql

JR3. mlomanagement.received_units  [J18]
     ALTER TABLE mlomanagement ADD COLUMN received_units double DEFAULT 0;
     The Produced-To-Date Line (cumulative, only climbs).
     ⚠ ALSO declare in MLOManagement.js attributes (JT2 — this is the entry
     that PROVED the trap; it banked 0 silently until declared).
     Backup: /home/ubuntu/mlomanagement.bak-S48-before-received_units.sql

JR4. company.food_safety_enabled  [J47]
     ALTER TABLE company ADD COLUMN food_safety_enabled TINYINT(1)
       NOT NULL DEFAULT 0;
     NOT NULL deliberately — no third ambiguous state. Feature A foundation.
     ⚠ Code half still TO DO: declare in Company.js attributes (JT2).

JR5. HACCP fetch procs — ORDER BY step  [J4]  ⚠ FOOD-SAFETY CRITICAL
     Three procs must sort by step, not id:
       FS_GetHazardHaccpPlanByHezardId_SP        → ORDER BY haccpplan.step
       FS_GetHazardIdentificationByHezardId_SP   → ORDER BY hazardidentification.step
       FS_GetHazardCCPDeterminationByHezardId_SP → ORDER BY ccpdetermination.step
     IF MISSED: HACCP plans render SCRAMBLED. A HACCP doc must read
     receiving→storage→processing→packing→shipping. See JT3.
     Backup: /home/ubuntu/all-routines.bak-S38.sql
     Apply: DROP+CREATE all three wrapped in DELIMITER $$, sourced via
     mysql < file. NOT a pasted heredoc — inner ; breaks the CREATE and a
     partial run DROPs a proc without recreating it. That exact failure
     happened mid-S38.

JR6. WhC_GetFormulaPackagingMaterials — must return whd_flag + pack_level  [J5]
     IF MISSED: the JS read-time cascade in Formulations.js
     getFormulaByIdForReleaseMaterial silently falls back to 1/1/1 with NO
     ERROR. Every multi-level product shows all pack levels as 1.000 Ea.
     Single-level products unaffected — which is what masked it for years.
     Backup: /home/ubuntu/WhC_GetFormulaPackagingMaterials.bak-S42.sql
     Applied via: /home/ubuntu/fix-pack-proc-S42.sql
     Also recorded in repo: db-changes/S42-pack-cascade.sql
     ⚠ That repo file is DOCUMENTATION, NOT AN APPLIED MIGRATION. Committing
     it does not put the proc in any database. See J6.

JR7. Trace_* view + procs — four separate fixes, applied across three sessions.
     Apply ALL of them.

     JR7a. Trace_ProductProdLotView — qty_su divide REMOVED  [J7, S43]
       ⚠ STATUS S95: the second half of this item — "received_qty_su LEFT
         AS-IS, its /wgt is correct" — IS SUPERSEDED BY JR7e. The divide
         was removed in S95 (P91). The qty_su half of JR7a still stands.
       qty_su = mm.qty  (NOT mm.qty / fop.wgt_kgs_per_unit — mm.qty is now
       units-stored, post-S41 flip). received_qty_su LEFT AS-IS: mm.received_qty
       IS still Kg, so its /wgt is correct.
       IF MISSED: MO Qty reads 0.5128205128# instead of 1#.
       Backup: /home/ubuntu/Trace_ProductProdLotView.bakS43.sql
         ⚠ NOTE THE FILENAME — no dot before S43. See JT20.
       Applied via: /home/ubuntu/fix-prodlot-view-S43.sql

     JR7b. Trace_ProductOneStepForward_SP — pre-flip divides CORRECTED  [J7, S43]
       packingslipdos.shipped_qty is stored in UNITS. The proc had it backwards.
       Corrected to: shipped_qty_weight = shipped_qty * wgt (real Kg);
                     shipped_qty_units  = shipped_qty (already units).
       Backup: /home/ubuntu/all-routines.bak-S43.sql
       Applied via: /home/ubuntu/fix-osf-proc-S43.sql

     JR7c. Trace_ProductOneStepForward_SP — SO-number + shipping-ref SOURCE  [J23, S50]
       so_number        = s.internalCode   (was s.SO_Ref_No — null on most SOs)
       customer_ship_ref = ps.vehicle_no   (was s.internalCode)
       Backup: /home/ubuntu/Trace_ProductOneStepForward_SP.bak-S50.sql (+ .txt)
       Applied via: /home/ubuntu/fix-onestepforward-S50.sql
       ⚠ JR7b and JR7c touch the SAME PROC in different sessions. The S50 backup
       already contains the S43 fix. Apply S50's version and you get both.

     JR7d. Trace_ProductProdLotView — received_units column ADDED  [J26, S51]
       Added: mm.received_units AS received_units
       IF MISSED: the Product-Traceability progress bar reads EMPTY.
       Backup: /home/ubuntu/Trace_ProductProdLotView.bak-S51.txt (SHOW CREATE)
       Applied via: /home/ubuntu/fix-prodlotview-S51.sql
       ⚠ JR7a and JR7d touch the SAME VIEW. The S51 backup contains both.

     JR7e. Trace_ProductProdLotView — received_qty_su reads the STORED
       column, not a division.  [J113, S95, P91]
       received_qty_su = mm.received_units
         (was  mm.received_qty / fop.wgt_kgs_per_unit)
       Alias UNCHANGED, so no frontend change rides with it. Sole consumer
       is product-traceability.component.html:79.
       APPLIED TO BOTH BOXES 30 Jul 2026, dev then prod.
       ⚠ NO SEPARATE .sql FILE. The REST of the view is in
         db-definitions-S93.txt in this repo; the one changed term is
         above. Take the view text from that file, swap that term, run it.
         A third copy of the view would be a third thing to keep in step.
       ⚠ SUPERSEDES JR7a's and J7's claim that this divide is CORRECT.
         It was arithmetically correct and is now redundant: received_units
         has been stored since S48 (JR3) and is cleaner — the division
         produced float garbage (110.99999999999999 for 111).
       ⚠ JR7a, JR7d AND JR7e ALL TOUCH THIS ONE VIEW. The copy in
         db-definitions-S93.txt already carries JR7a and JR7d; only JR7e
         is outstanding against it.
       ⚠ RUN AGAINST abletracelab_live EXPLICITLY. Both boxes carry a
         dormant `abletrace` archive holding its own copy of this view.
         The archive copy is NOT updated. Leave it.
       ⚠ GATE BEFORE APPLYING TO ANY NEW BOX: line 79 carries an *ngIf,
         so a NULL or 0 received_units HIDES the figure where a wrong one
         showed before. Count rows with received_qty > 0 and received_units
         null or 0 first. Both boxes returned 0 in S95.
       ⚠ VERIFY SCHEMA-SCOPED, or the check cannot fail correctly:
         SELECT VIEW_DEFINITION FROM information_schema.VIEWS
          WHERE TABLE_NAME='Trace_ProductProdLotView'
            AND TABLE_SCHEMA='abletracelab_live';
         grep -c for the old divide — expect 0. Without the schema clause
         it matches the archive and always returns 1.

JR8. Document-list procs — alphabetical sort  [J60, S60]
     FS_Documents_SP       : ORDER BY LOWER(d.title) ASC  (was d.version DESC)
     FS_DocumentsByType_SP : ORDER BY LOWER(d.title) ASC  (was d.updatedAt DESC)
     LOWER() is deliberate — the collation does not sort case-insensitively in
     practice, so a lowercase client title sorts after all-caps.
     Backups: /home/ubuntu/FS_Documents_SP.bak-S60.txt,
              FS_DocumentsByType_SP.bak-S60.txt
     Applied via: /home/ubuntu/fix-fs-documents-sp-S60b.sql,
                  fix-fs-documentsbytype-sp-S60.sql

JR9. FS procs parameterized + dead proc dropped  [J48, S58]  ⚠ SECURITY
     FS_GetDocumentDetails_SP and FS_GetHaccpDetails_SP: value BOUND, columnName
     GUARDED to 'id' only (SIGNAL SQLSTATE '45000' otherwise). Signatures
     unchanged. Test_DynamicWhereClause DROPPED (36 routines → 35).
     IF MISSED: an injection surface reopens on a live client system.
     Applied via: /home/ubuntu/fix-fs-procs-S58.sql
     Pre-change definitions: /home/ubuntu/fs-procs-before-S58.txt

JR10. Index: idx_reject_company_status  [J49, S58]
     CREATE INDEX idx_reject_company_status
       ON rejectmaterialandproduct (company_id, status);
     The other two watch-list indexes (dispatchorders.formula_id,
     receiveproducts.mlc_id) already exist in the loaded structure.
     Trace-proc join indexes deliberately NOT added — measure under real load
     first (J45). Do NOT over-index.

JR11. SEED + reference data  [J50, J51, S58]
     WHOLE tables (no company_id):
       roles(7 — incl. role 7 'Food Safety Controller'), role_task(20 — incl.
       FS task id 22), unittype(3), so_product_status(3), mlo_status_types(4),
       licence_status(6), common_status(6), vehicle_condition(2),
       global_documents(40).
       ⚠ This re-applies J3 (role 7 + its role_task) automatically.
     GLOBAL-NULL ROWS ONLY (tables that carry company_id — the rest is client junk):
       documenttype(ids 1/2/3/15 = Procedure/Record/Support Document/HACCP Plan)
       miscellaneous_reason(ids 1/2/3 = Sample/R&D/Non Conforming)
       hazardtype(ids 1/2/3 = Physical/Chemical/Biological) PLUS 'None':
         INSERT INTO hazardtype (createdAt, updatedAt, name, company_id)
           VALUES (NOW(), NOW(), 'None', NULL);        [J-S64, was id 74]
     NOT SEEDED: producttype (client-specific, starts empty) + all transactional.
     SUPER ADMIN: user id 1 + super_admin id 1, no company linkage (platform-level).
       Then RESET the password through the app — the salted-MD5 hash cannot be
       hand-generated.
     Files: /home/ubuntu/seed-whole-S58.sql, seed-global-S58.sql,
            seed-superadmin-S58.sql

JR12. RDS config — NOT in git, NOT a routine  [J41, J42]
     - Parameter group must set mysql_native_password = ON (STATIC).
       ⚠ If the instance is ever moved onto default.mysql8.4, native-password goes
       OFF and the app (mysql@2.18.0 driver) CANNOT CONNECT AT ALL. Any new 8.4
       group MUST set this until the driver migration (G0e) lands.
     - CALL mysql.rds_set_configuration('binlog retention hours', 24);
       Verify: CALL mysql.rds_show_configuration;
     ⚠ CHANGING THE MASTER PASSWORD IN THE RDS CONSOLE ALSO RESETS THE
       USER'S AUTH PLUGIN to caching_sha2_password. The app will not
       boot: ER_NOT_SUPPORTED_AUTH_MODE. ⚠ IT LOOKS LIKE A WRONG
       PASSWORD AND IS NOT - the server never checks the password, it
       refuses on protocol.
     ▶ ALWAYS follow a console password change with:
         ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password
           BY '<the new password>';
       The mysql CLIENT speaks the new protocol, so it can connect and
       fix this where the app cannot. Test with SELECT 1 first - if
       that succeeds, the password is right and only the plugin is
       wrong. (S97, P125. Dev down ~10 minutes.)

JR13. nginx client_max_body_size 10M — on BOTH boxes  [J-S71]
     The default is 1M. It was at the default since day one, silently capping
     EVERY upload path in the app. A 413 from nginx never reaches Sails, so it
     never reaches pm2 logs and surfaces as "[object Object]" (JT18).

JR14. On-box / off-git scripts and config  [J-S61, J-S66, J-S66b]
     Not database, but lost in the same event (box rebuild):
     - /home/ubuntu/deploy-frontend.sh   (both boxes)  md5 50e66fd427ebd31ff4502d4cd6b495a8
     - ~/promote.sh                      (Mac)         md5 362e2f297aec9f1843ba38c82484d6cb
     - dev nginx vhost: /etc/nginx/sites-available/dev.mintekfoodsafety.com
     - dev SSL: sudo certbot --nginx -d dev.mintekfoodsafety.com
         -m info@abletrace.ca --agree-tos --no-eff-email --redirect
     - config/bootstrap.js dev-safety guard IS in git (b70ba10) — carries forward.
     - .github/workflows/build-frontend.yml IS in git — carries forward.
     Restore from Drive Master Brief.

JR15. rejectmaterialandproduct.qty_rejected_units  [J116, S103]
     ALTER TABLE rejectmaterialandproduct
       ADD COLUMN qty_rejected_units double DEFAULT 0;
     Stores the operator's typed shipping-unit count on the MR
     (Miscellaneous Release) product screen. Previously only the Kg
     figure was stored and the count was derived by division on read.
     The last product write path that stored Kg and reconstructed units.
     DOUBLE, NOT INT - fractional shipping units are permitted (J88).
     Declared in RejectMaterialAndProduct.js attributes, commit 05f786c,
       alongside the REJPRODOBJ write (JT2).
     REJMATOBJ deliberately untouched - material reject is Kg-measured
       by design. Adding units there would be a defect.
     Backups: /home/ubuntu/rejectmaterialandproduct-before-S103.sql (dev)
              /home/ubuntu/rejectmaterialandproduct-before-S103-PROD.sql
     Prod mysqldump needs --single-transaction --skip-lock-tables
       --set-gtid-purged=OFF. Without skip-lock-tables RDS denies FLUSH
       TABLES WITH READ LOCK and writes a header-only file that LOOKS
       like a backup. Check grep -c "INSERT INTO" before trusting it.
     Applied to BOTH boxes 4 Aug 2026.
JR16. WhC_GetAllRejectedList_SP - returns qty_rejected_units  [S104]
     The proc names its columns ONE BY ONE. Adding the column in JR15
     did NOT make it reach any screen. qty_rejected_units added to the
     SELECT list, immediately after qty_rejected. NOTHING ELSE CHANGED
     - same 11 joins, same WHERE, same ORDER BY.
     IF MISSED: the MR unit count is stored and displays NOWHERE. No
     error, no blank - the Kg figure shows alone and reads correct.
     BOTH MR SCREENS DEPEND ON THIS ONE PROC. edit-reject-product
       FETCHES NOTHING of its own - it subscribes to a BehaviorSubject
       in warehouse.service.ts, fed by rejected-materials.component.ts
       line 84 handing over the row the LIST already had. So a rebuild
       that misses this column breaks the list AND the details screen.
     Backups: /home/ubuntu/WhC_GetAllRejectedList_SP.bak-S104-DEV.txt
              /home/ubuntu/WhC_GetAllRejectedList_SP.bak-S104-PROD.txt
     Those are SHOW CREATE text, NOT runnable. To restore, take the
       body and add the DELIMITER $$ wrapper. Same shape as JR7c.
     Recreated WITHOUT the DEFINER clause - RDS can refuse an explicit
       definer on recreate.
     METHOD - DO NOT PASTE A PROC BODY INTO A TERMINAL. S104's first
       attempt was a 35-line heredoc with one line over 1000 chars. The
       SSH input buffer overflowed and DISCARDED the overflow. The file
       existed, had a plausible size, and was missing four lines and a
       join. Running it would have DROPped the proc and failed to
       recreate it, killing the MR list.
       BUILD THE NEW OBJECT ON THE BOX FROM ITS OWN BACKUP with a short
       node script, then diff the join list against that backup before
       applying. The long text never travels, and the result is
       guaranteed identical to what is running.
     ⚠ THE PROC ALREADY RETURNED fopackaging.wgt_kgs_per_unit before
       S104. The ingredients for an R2 division are served to this
       screen. Not a defect. Worth knowing. See P135.
     ⚠ status IS THE WORD 'Active', NOT A NUMBER. Calling the proc with
       '1' returns an EMPTY RESULT that looks exactly like a broken
       object. CALL WhC_GetAllRejectedList_SP('<company>','Active').
     Applied to BOTH boxes 5 Aug 2026.
     ⚠ db-definitions-S93.txt DOES NOT REFLECT THIS CHANGE. That
       snapshot is now stale on TWO objects: JR7e's view and this proc.

JR17. WhC_GetMoDetails_SP - returns received_units  [P149, S106]
     One column added to the SELECT list, immediately after
     received_qty:  `mlomanagement`.`received_units`,
     NOTHING ELSE. Same 8 joins, same WHERE, same signature.
     IF MISSED: the yield dialog prints `undefined#` - the frontend
     reads received_units and gets nothing. Edit-Mlc divides a weight
     instead (P151). No error either way.
     Backups, /home/ubuntu on each box:
       WhC_GetMoDetails_SP.bak-S106-DEV.txt   / .after-S106-DEV.txt
       WhC_GetMoDetails_SP.bak-S106-PROD.txt  / .after-S106-PROD.txt
     SHOW CREATE text, NOT runnable. Add the DELIMITER wrapper.
     Verified before use: 28 lines, BEGIN 1, END 1, joins 8.
     Recreated WITHOUT the DEFINER clause. It was `admin`@`%`.
     Per JR16 - RDS can refuse an explicit definer on recreate.
     Confirmed callable afterwards on both boxes.
     METHOD: JR16's. Built on each box from its own backup by node
     script with four guards; two-line diff and join count verified
     before applying; read back out of the database, then CALLed.
     NO FRONTEND BUILD WAS INVOLVED. 8fa2ed14 was already deployed
       and already reading the column.
     db-definitions-S93.txt does NOT reflect this. -> P119.
     Applied to BOTH boxes 6 Aug 2026.
     ADDED TO THIS FILE S107 - see J117 for why the frontend removal
       this obsoleted very nearly shipped anyway.

JR18. Trace_ProductHeaderView - three _su fields read stored unit
     counts instead of dividing  [P135, S107]

     THE VIEW HAS SEVEN _su FIELDS. Before S100 all seven divided a Kg
     figure by fopackaging.wgt_kgs_per_unit. S100 repointed
     qty_produced_su to mm.received_units. S107 repointed three more.
     THREE STILL DIVIDE - see the foot of this entry.

     THE CHANGE, inside the `do_products` CTE - three unit sums ADDED
     beside the three existing Kg sums, same case-when conditions,
     different source column:

       sum(case when ps.shipped_flag = true
                then do.qty_shipped else 0 end)      AS qty_shipped_u
       sum(case when ps.shipped_flag = false
                 and ps.shippingdate is null
                then do.packing_units else 0 end) AS qty_packing_slip_u
       sum(case when ps.shipped_flag is null
                then do.packing_units else 0 end)        AS qty_do_u

     Then three divisions in final_results REPLACED:
       qty_packing_slip_su = coalesce(do_products.qty_packing_slip_u,0)
       qty_do_su           = coalesce(do_products.qty_do_u,0)
       qty_shipped_su      = coalesce(do_products.qty_shipped_u,0)

     THE SHIPPED BUCKET TAKES dispatchorders.qty_shipped. THE OTHER
       TWO TAKE packing_units. THEY ARE NOT INTERCHANGEABLE.
       packing_units is what was AUTHORISED; qty_shipped is what
       ACTUALLY SHIPPED, and a DO can ship more or less than
       authorised (Minty's ruling S97, J114). Using packing_units for
       the shipped bucket reports the authorisation as the shipment.

     TRAPS 10 SITS INSIDE THIS OBJECT AND IT IS LIVE. The do_products
       CTE defines its OWN alias `qty_shipped` which sums
       do.qty_to_ship and is KG. The real column
       dispatchorders.qty_shipped is UNITS. Same name, opposite basis,
       a few lines apart. ANYONE REBUILDING THIS FROM THE NAMES ALONE
       WILL WIRE Kg INTO A UNITS FIELD and it will look plausible at
       every round-ratio fixture.
       -> RESOLVE EVERY NAME TO ITS DEFINITION.

     IF MISSED: qty_shipped_su, qty_packing_slip_su and qty_do_su
     render float garbage on non-round unit weights -
     7.000000000000001 for 7 was live on dev before this change. The
     numbers are ARITHMETICALLY CORRECT; they are the right number
     wearing garbage. Same class as JR7e. No error, no blank - just an
     implausible figure on a client-facing traceability screen.

     ALIASES AND COLUMN ORDER UNCHANGED, so NO frontend change rides
     with this. Sole consumer is
     product-traceability-details.component.ts via
     api/models/Traceability.js.

     Backups: /home/ubuntu/Trace_ProductHeaderView.bak-S107-DEV.txt
              /home/ubuntu/Trace_ProductHeaderView.bak-S107-PROD.txt
     SHOW CREATE text, NOT runnable. Strip the `1. row` banner, the
       `View:` and `Create View:` labels and the two trailing charset
       lines; prefix CREATE OR REPLACE; append a semicolon. The S107
       node script did exactly that.
     THE TWO BOXES WERE BYTE-IDENTICAL BEFORE THE CHANGE - 5932 bytes,
       6 slashes, 22 joins, 5 selects, on each.
     Recreated WITHOUT the DEFINER clause. It was `admin`@`%`.

     METHOD - JR16's, on each box from its OWN backup:
       1  SHOW CREATE to a .bak file. Verify bytes, slash count, join
          count, select count.
       2  Build the new object ON THE BOX by node script. FOUR
          ANCHORS, each asserted to appear EXACTLY ONCE. Slash count
          asserted 6 before and 3 after.
       3  diff old against new on a comma-split readable copy. JOIN
          COUNT MUST HOLD AT 22.
       4  Apply with `mysql abletracelab_live < file`. Read the slash
          count back OUT OF THE DATABASE, not off the file.
       5  Query the fixture and compare against a baseline captured
          BEFORE the write.
     NO VIEW TEXT EVER TRAVELLED THROUGH SSH.

     VERIFICATION IS ARITHMETIC AND IT IS THE WHOLE GATE:
         mysql abletracelab_live -e "SHOW CREATE VIEW
           Trace_ProductHeaderView\G" | grep -o "/" | wc -l
       6 = pre-S107 . 3 = post-S107 . 0 = P135 complete.
     grep -c COUNTS LINES AND THIS OBJECT IS ONE LINE. Use
       grep -o "/" | wc -l for occurrences.

     PROVEN, DEV, company 464, MO-0007, test1.39 at 1.39 Kg/unit, with
     dispatch orders in ALL THREE bucket states:
       BEFORE  qty_shipped_su 7.000000000000001
       AFTER   qty_shipped_su 7
       qty_do_su 1 . qty_packing_slip_su 2 . SOH_su 40 - UNCHANGED
       Screen: Qty in DO 1# (1.39 Kg) . Qty in PS 2# (2.78 Kg) .
               Shipped to Customer 7# (9.73 Kg)

     PROVEN, PROD: every figure IDENTICAL to the baseline on both MOs,
     exactly as predicted - prod's fixtures sit on ROUND ratios (20
     and 5 Kg/unit) where the division landed exactly. Glutenull's
     traceability screen renders 0# (0 Kg) cleanly on all three
     repointed cells; the *ngIf gate does not blank them at zero.
     MEASURED, not assumed.
     THE Kg COLUMNS WERE THE CONTROL AND DID NOT MOVE.

     STILL DIVIDING AFTER S107 - three fields, each blocked for a
       different reason:
         qty_misc_release_su  the mr CTE sums rmp.qty_rejected.
                              rejectmaterialandproduct.qty_rejected_units
                              EXISTS (JR15) but every pre-S103 row
                              holds 0 - 28 of 28 on prod. Repointing
                              without a backfill turns a right-looking
                              figure into a wrong one.
         intermediate_prd_su  mprrecievelots has NO unit column at
                              all. Needs a schema change, a Waterline
                              attribute (TRAPS 3) and a write-path
                              change.
         SOH_su               subtracts five Kg terms then divides.
                              DEPENDENT - cannot be units-anchored
                              until the two above are.
     P136: the view returns DUPLICATE ROWS. Pre-existing, not caused
       by and not fixed by this change.
     Applied to BOTH boxes 6 Aug 2026.


──────────────────────────────────────────────────────────────────────
⚠ ───────────────────────────────────────────────────────────────────────
⚠ JR — WHERE THE OBJECT TEXT LIVES  [P97, S95]
JR names the CHANGES. The COMMITTED TEXT of eleven database objects —
views and stored procedures, read from dev — is in db-definitions-S93.txt
IN THIS REPO. A rebuild driven from JR alone would not find them.
⚠ That file is a SNAPSHOT, dated S93. Anything JR records after S93
  (JR7e) is NOT reflected in it. Read JR for the changes, the file for the
  shapes.
JR — THE STANDING RISK
Every source file above lives in /home/ubuntu on the PROD box, which is
NOT backed up off-instance. The Drive Master Brief copy is the only other
record and it is not verified current. If prod is lost, this checklist
names files that no longer exist. See J-S72a.
──────────────────────────────────────────────────────────────────────
ENTRIES
──────────────────────────────────────────────────────────────────────
J-ENTRIES — THE LOG
Oldest first. Each entry: WHAT / WHY / NORMAL PATTERN / PROPER FIX /
REVISIT TRIGGER / BLAST RADIUS. Numbers are permanent.
──────────────────────────────────────────────────────────────────────

J1 — S35 (Jun 2026) — Two OLD-account IAM keys left deliberately active
WHAT: After the Jun 7 credential exposure, all keys rotated EXCEPT two OLD-account
  IAM keys (ses …ILD4K76I, s3_cloudfront …H7IPS3W7), left active on purpose.
WHY: The 2 legacy clients on abletrace.ca (old app) MAY authenticate via these.
  Deactivating blind could break the live old app.
PROPER FIX: investigate old app's email + S3 config; once confirmed independent →
  deactivate (reversible) → then delete. Deactivating also neutralises the copies
  in git history.
REVISIT TRIGGER: any work touching old-app email/S3, OR before retiring the old
  account (domain switch STEP 2 — see J34).
BLAST RADIUS: exposure window stays open on these two keys until resolved.
S39 UPDATE: the s3_cloudfront key was found not only in git history but HARDCODED
  IN PLAINTEXT in two frontend GitHub Actions workflows (production.yml,
  develop.yml), live on main. Those files deployed nothing, failed every push, and
  were leftover old-app CI. DELETED (commit df4cf421) — live-tree exposure closed.
  BUT THE KEY IS STILL VALID and still in git history. Per Minty, deactivation
  deferred until AFTER the app.abletrace.ca switch. Exposure REDUCED, not CLOSED.

J2 — S37 (Jun 11 2026) — Global Procedures sync toast bypasses NgRx selector
WHAT: global-procedures.component.ts syncClients() drives the success toast
  directly from the cloneToCompany service response in the dialog-close handler,
  not via the getCloneToCompanySuccess store selector (the app's normal pattern).
WHY: The selector did not emit to this standalone component despite a fully-correct
  action→effect→reducer→selector chain and a 200 response. Root cause NEVER FOUND
  after extensive tracing. Routed around it to ship.
PROPER FIX: diagnose why the selector doesn't emit; restore the standard path;
  remove the direct service call + dead subscription + unused imports.
REVISIT TRIGGER: ⚠ the same symptom on ANY other feature (success/error toast
  silently never fires) — this is the precedent. Treat as possible SYSTEMIC NgRx
  issue before assuming a local bug. Did NOT recur through S40.
BLAST RADIUS: one screen. Feature works; only internal wiring deviates.

J3 — S38 (Jun 12 2026) — Food Safety promoted to rail role via direct DB INSERTs
  (DB-ONLY, not in git) → now JR11
WHAT: Two additive INSERTs:
    INSERT INTO roles (id, role_name, createdAt, updatedAt)
      VALUES (7, 'Food Safety Controller', NOW(), NOW());
    INSERT INTO role_task (task_name, routing_path, role_id, createdAt, updatedAt)
      VALUES ('Food Safety System', '/food-safety-system', 7, NOW(), NOW());
  (auto task id 22). Admin's pre-existing Food Safety task (role_task id 20, same
  routing_path, under role 2) LEFT INTACT on purpose so Admins keep their tile.
WHY: The nav is entirely data-driven (roles → role_task → company_user_role →
  company_user_task). Adding a role + task is purely a data operation; a migration
  for a one-time seed would be heavier with no benefit.
REVISIT TRIGGER: any DB rebuild from a pre-S38 snapshot — role 7 MISSING.
BLAST RADIUS: additive only. Backup: /home/ubuntu/roles-tasks.bak-S38.sql
STATUS S72: folded into JR11 (rides the whole-seed of roles + role_task).

J4 — S38 (Jun 12 2026) — HACCP order fixed in stored procs, not in the save path
  (DB-ONLY, not in git) → now JR5.  ⚠ SOURCE OF JT3.
WHAT: Saved HACCP plans rendered SCRAMBLED. REAL root cause is the SAVE path:
  addHazard (api/models/Hazards.js) inserts hazardidentification / ccpdetermination
  / haccpplan rows in PARALLEL (forEach pushing promises → Promise.allSettled), so
  MySQL assigns autoincrement ids in COMPLETION order, not array order. The fetch
  SPs returned rows in id order (no ORDER BY), so the scramble showed.
  FIX APPLIED (read layer, NOT the real cause): ORDER BY <table>.step on the three
  fetch SPs. See JR5 for names and file paths.
WHY THE READ-LAYER FIX IS SUFFICIENT: ORDER BY step doesn't depend on id order at
  all AND repairs every EXISTING scrambled plan immediately. Fixing the parallel
  insert alone would fix only NEW saves and leave all existing plans scrambled.
PROPER FIX (belt-and-suspenders, LOW priority): replace the parallel forEach in
  addHazard with ordered createEach or awaited for...of. The SP ORDER BY makes id
  order irrelevant, so this buys little.
REVISIT TRIGGER: DB rebuild pre-S38; a future feature letting users reorder steps;
  step values ever duplicating or going null (ordering wobbles).
BLAST RADIUS: read-only; no data modified.

J5 — S42 (Jun 15 2026) — Packing cascade is computed at READ time, not stored
  (design fact + a modified proc; DB-ONLY part not in git) → proc now JR6.
  ⚠ SOURCE OF JT19.
WHAT: For multi-level packaging (wrap → carton ×10 → case ×5, case = shipping
  unit), the per-level cumulative quantities shown in MO Batch Materials / release
  are NOT STORED ANYWHERE. mlcpackaging holds only FLAT, per-level, whd_flag-
  filtered quantities (verified against 2019-era transferred records). The CASCADE
  is a READ-TIME computation: walk pack levels DOWN from the shipping unit, each
  lower level's count = running product × the parent level's qty. Implemented in
  Formulations.js getFormulaByIdForReleaseMaterial.
  To feed it, WhC_GetFormulaPackagingMaterials was MODIFIED to also return
  whd_flag + pack_level. That proc change lives in RDS, NOT in git → JR6.
WHY: The cascade depends only on each level's stored flat qty + level ordering, so
  recomputing on read is cheap, always correct, and avoids storing derived multiples
  that would drift if a pack config changed.
⚠ createMLC writing a single FLAT row per level is CORRECT BY DESIGN. DO NOT "fix"
  it to write cascade multiples. The S42 bug was that the READ path set every level's
  final_qty to a constant (batch Kg × batches), ignoring the cascade — latent for
  years because single-level products (one level = the shipping unit) masked it.
REVISIT TRIGGER: ⚠ rebuild from a pre-S42 snapshot, OR anyone rebuilding the proc
  from an old dump — if whd_flag + pack_level are absent from its SELECT, the JS
  cascade SILENTLY falls back to 1/1/1 with no error.
BLAST RADIUS: read-only. If the proc reverts, every multi-level product shows all
  pack levels as 1.000 Ea. JS side committed (Formulations.js 0c658ba).

J6 — S42 (Jun 15 2026) — db-changes/ folder records a proc change inside git, but
  the proc still lives only in RDS
WHAT: The S42 proc modification (J5) was recorded as a tracked file
  db-changes/S42-pack-cascade.sql in the backend repo. This DEVIATES from the
  J3/J4 convention of recording DB-only changes ONLY in this log.
WHY: Keeping the DROP+CREATE alongside the code makes the proc dependency
  discoverable — the JS in Formulations.js is meaningless without the proc
  returning whd_flag + pack_level.
⚠ THE TRAP: db-changes/*.sql is DOCUMENTATION, NOT AN APPLIED MIGRATION.
  Committing the file does NOT apply the proc to any database. It must still be
  sourced by hand on any rebuild. DO NOT ASSUME "it's in git" means "it's in the DB."
BLAST RADIUS: documentation only — but the risk is a false sense of safety.

J7 — S43 (Jun 15 2026) — Traceability planned/shipped qty: removed leftover
  Kg→units divides in a VIEW and a PROC (DB-ONLY, not in git) → now JR7a + JR7b
WHAT: Product-traceability LIST "MO Qty" and details "One Step Forward → Qty
  Shipped" both showed 0.5128205128…# (= 1 ÷ 1.95) where the right value was
  1# (1.95 Kg). Root cause: two DB objects still applied the OLD pre-flip "divide
  stored value by wgt_kgs_per_unit to get units" on fields now ALREADY STORED IN
  UNITS (Logic A flip, S41). Fixed both at source:
    1. VIEW Trace_ProductProdLotView — qty_su was (mm.qty / fop.wgt_kgs_per_unit);
       mm.qty is now units → changed to qty_su = mm.qty (no divide).
       received_qty_su LEFT AS-IS (mm.received_qty IS still Kg, so its /wgt is
       correct → 2).
       ⚠ STATUS S95: the "received_qty_su LEFT AS-IS" sentence above is
         SUPERSEDED BY JR7e / J113. That divide was removed in S95 (P91).
         Everything else in J7 stands.
    2. PROC Trace_ProductOneStepForward_SP — packingslipdos.shipped_qty is stored
       in UNITS (verified: stored 1, wgt 1.95 → 0.5128). The proc had it backwards.
       Corrected to shipped_qty_weight = shipped_qty * wgt (real Kg),
       shipped_qty_units = shipped_qty (already units). Only those two SELECT
       expressions changed; JOINs/WHERE untouched. DEFINER preserved (admin@%).
  Frontend (IN git, commit ffe670f3) completed the display: list line 88 + details
  OSF line 94 render "{units}# ({weight|number:'1.0-2'} {uom})" = 1# (1.95 Kg),
  canonical, matching MLO/WH. Also fixed currentProdDetails (line 230): lot-code
  search items carry the formulation id as item.formula_id(.id) NOT
  item.formulation_id, so details nav posted .../getProductTraceability/11730/
  undefined → 500. Added a fallback so both search paths resolve product_id.
WHY: [RECONSTRUCTED S72 — the original text was truncated mid-sentence at "The".
  Recovered from the S43-end Section G + its P1b backlog item, not from the S43
  chat, which was not retrieved. Substance is sourced; wording is not original.]
  These were the last two surviving pre-flip divides on the outbound/traceability
  read path. The fix belongs at SOURCE — in the view and the proc — not at the
  display, because the frontend was rendering faithfully what the read layer
  handed it. A rebuild from a pre-S43 snapshot silently reintroduces the 0.5128
  bug, which is why these two objects are on the rebuild checklist (JR7a/JR7b).
  DIAGNOSTIC RULE (from the same session, P1b): a clean fraction like 1÷wgt is
  the FINGERPRINT of a units-stored field being divided. Trace any "/wgt" to
  whether the field is units-stored (qty, shipped_qty → NO divide) or Kg-stored
  (received_qty, qty_to_ship → divide OK). Check the data source FIRST — the fix
  may live in a view or proc, not the frontend.
REVISIT TRIGGER: any DB rebuild from a pre-S43 snapshot.
BLAST RADIUS: read-only; no stored data changed.
FILES [VERIFIED ON THE PROD BOX S72 — J40 and the S43 G both mis-stated one]:
  /home/ubuntu/Trace_ProductProdLotView.bakS43.sql   ⚠ NO DOT before S43 (JT20)
  /home/ubuntu/all-routines.bak-S43.sql
  /home/ubuntu/fix-prodlot-view-S43.sql
  /home/ubuntu/fix-osf-proc-S43.sql
  Component backups: product-traceability.component.{html,ts}.bak-S43
⚠ SUPERSEDED IN PART: J23 (S50) and J26 (S51) later changed the SAME two objects.
  Apply the LATEST backup, not this one. See JR7.

J9a — S45 (Jun 17 2026) — Intermediate products are manual-entry, NOT imported
  (deliberate, original build).  ⚠ SOURCE OF JT19.
  [NUMBERING: two entries were both written as "J9". Suffixed S72 to a/b. Content
  unchanged. Both are S45.]
WHAT: The Excel importer does NOT load intermediate products (the fosubrecipe →
  subrecipeformulation formulation-in-formulation path). After a client's products
  are bulk-uploaded the FIRST time, intermediates are added BY HAND in-app
  (Edit-Formulation → Intermediate Product section). The importer resolves recipe
  ingredients against MATERIALS ONLY.
WHY: When the app was first built, the original coder chose manual entry over making
  the import logic handle nested formulation linkage — simpler, and intermediates
  are low-volume per client. SETTLED DECISION, NOT A GAP TO FIX.
PROPER FIX: only if the onboarding importer is ever extended to cover nested
  formulations — it would need a SECOND PASS after all products exist (so the
  intermediate's own formulation id is resolvable). Not planned.
REVISIT TRIGGER: a client with enough intermediates that manual entry becomes
  painful; OR the importer build deciding to absorb this scope.
BLAST RADIUS: none — workflow as designed. Risk is only that a future reader sees
  the importer skip intermediates and mistakes it for a bug.
  Cross-ref: Logic C "ONBOARDING RECIPES ARE MATERIALS-ONLY" — keep consistent.

J9b — S45 (Jun 17 2026) — Intermediate "0#": THE BUG AND ITS FIX WERE
  BOTH PHANTOM.  ⚠ STATUS S78: CLOSED BY J81. READ J81 FIRST.
  ⚠ THIS ENTRY IS RETAINED FOR ITS RULED-OUT LIST ONLY.
SYMPTOM AS ORIGINALLY LOGGED (S45): intermediate products showed 0# (0 units).
⚠ THE S45 DIAGNOSIS WAS WRONG AND WAS COPIED FORWARD FOR 32 SESSIONS. It claimed
  the VERSION-FORK carried qty (Kg) but wrote ship_qty = 0 for intermediates,
  "proven on FO-0007 → FO-0007-2 (ship=0)". S77 DISPROVED THIS THREE WAYS (J81):
  a live fork on dev carried ship_qty forward on BOTH rows; Formulations.js:901
  `ship_qty: formula.ship_qty` has been present since commit 2e21c0f, 2022-07-05;
  and 4 years of operator experience has never produced a ship_qty=0.
⚠ THE EARLIER STATUS LINE ON THIS ENTRY WAS ALSO WRONG. It read "THE BUG IS FIXED.
  Fix A landed (S46/S47)" and cited K1/K2 as confirmation. Line 901 PREDATES S46 by
  ~4 years, so there was almost certainly no fix to land. The bug and its fix are
  BOTH phantom. The single 2022 FO-0007 reading was never chased — prod data, no
  live symptom, not worth it.
⚠ NO "Fix A" P-ITEM EXISTS OR IS NEEDED. If a pointer to "Fix A" survives anywhere
  in the docs, it is dead — strike it on sight.
STILL VALID — THE VERSION-FORK ITSELF: a "full edit" (adding an ingredient or
  intermediate via the full 'Select an Intermediate product' process) is a
  VERSIONING operation BY DESIGN — new formulation version, same title,
  internalCode + "-2", old version retained for traceability. CORRECT, INTENDED,
  NOT DUPLICATION.
STILL VALID — RULED OUT, ⚠ DO NOT RE-CHASE THESE:
  (1) shortcut-pencil qty edit — saveFromSubForRec touches only the edited index.
  (2) pure ADD path — stores ship_qty + qty correctly.
  (3) backend read getFormulaById — returns ship_qty intact (the .map at ~468
      mutates subForm in place, never strips it).
  (4) Excel import — intermediates are never imported (J9a).
  (5) row-duplication — two fosubrecipe headers per parent are LEGITIMATE
      VERSIONS, not a dup bug.
SCHEMA (unchanged): subrecipeformulation cols — qty(double, Kg), ship_qty(double,
  units; default NULL), sub_recipe_id→fosubrecipe.id, formulation_id→intermediate.
⚠ LESSON, same family as J80 / J81 / J82: a confident wrong answer written down
  becomes the next session's foundation. This one survived 32 sessions and seeded
  a phantom fix into four separate documents.

J10 — S45 — Stock/release quantity layers (state at S45)
  ⚠ SUPERSEDED S78. Fix B completed S48–S52; the behaviour below is HISTORY, not
  current. ⚠ DO NOT use its file/line references — they are ~30 sessions stale.
  Retained for the ORIGINAL-BUILD dating at the foot, which is load-bearing.
Confirmed in api/models/MaterialsProductsReleased.js: at S45 ALL stock movement was
  Kg. Release subtracted inventory − qty_allocated (Kg) for BOTH materials
  (getMatData.inventory, line 88) and products (findFormula.inventory, line 96).
  ship_qty did NOT appear in that file. The product-sheet unit figure ('890# (89 Kg)')
  was a one-way display derivation = Kg ÷ per-unit-weight, never stored/subtracted —
  NOT the forbidden round-trip, but per the "two clean lines" decision still WRONG
  for products → Fix B re-anchored product/intermediate stock + release to shipping
  units (raw-material Kg path unchanged).
⚠ THE LOAD-BEARING PART — KEEP: formulations CREATE_TIME 2022-07-06;
  subrecipeformulation likewise. These are ORIGINAL-BUILD tables and ship_qty is NOT
  a column we added. This dating is part of the evidence that closed J9b/J81 — the
  fork handler predates every session in this log.

J11 — S46 — formulations.inventory_units is DB-only → now JR2
ALTER TABLE formulations ADD COLUMN inventory_units double DEFAULT 0;
Lives in RDS, not git. Backup: /home/ubuntu/formulations-schema.bak-S46.sql
[A terse duplicate of J11/J12/J13 existed lower in the log; removed S72, content
identical.]

J12 — S46 — Live release path is V2, not the single function  ⚠ SOURCE OF JT9
The release screen runs MaterialsProductsReleased.createReleaseMaterialProductsV2
(bulk loop), NOT the older single-release function in the same model file. An edit
on the single (dead) path is an INVISIBLE NO-OP. Cost real time in S46 — units
appeared not to subtract because the wrong path was patched.
MR (Miscellaneous Release) and product Reject both route through
RejectMaterialAndProduct.createNewRecord product branch — same path, confirmed S46.
Re-confirmed across S46/S47 for DO, PS, and release paths.

J13 — S46 — Product SOH on screen is a live view, not the stored column
  ⚠ SOURCE OF JT12
Trace_ProductHeaderView computes SOH live (Kg) and derives units as Kg÷wgt. The
Products screen and Traceability read THIS VIEW, not formulations.inventory_units.
Until the display switches, the screen and the units column will LEGITIMATELY
DISAGREE — expected, not a bug. Verify the units loop only by DB query on
inventory_units.

J14 — S47 — PackingSlips.js:333-334 is a DEAD, BROKEN block  ⚠ SOURCE OF JT19
In the editPackslips PS-edit-add-DOs path. It is NaN-producing (Formulations.find()
returns an array), uses a stale `elem`, and wrongly subtracts SOH. It is SKIPPED on
normal ship (DOs array empty). DELIBERATELY LEFT IN PLACE; to be cut in the Route 6
cleanup sweep. ⚠ DO NOT "FIX" IT BEFORE THEN.

J15 — S47 — The DO row carries two units  ⚠ SOURCE OF JT4
dispatchorders.qty_to_ship in Kg (old line) next to qty_shipped in units (new
accumulator) — two units on one row. Known, harmless fossil. The frontend Stock Info
popup reconciles for display by converting units→Kg via wduKgPerUnit. Nothing in the
stock loop reads qty_to_ship for units. Retire at Route 6 — also when a
qty_to_ship_units sibling column would earn its place.

J16 — S47 — Shipping is terminal, by design
Shipping = editPackslips (sets shipped_flag true). There is deliberately NO un-ship
function; shipped is TERMINAL. ⚠ Do not add one without an explicit domain decision.

J17 — S48 — Add-Formulation intermediate summary shows Kg-only during add
  ⚠ STATUS S78: STILL OPEN. The ACTION now lives in the queue as P30.
WHAT: During the ADD flow the intermediate summary displays Kg only; it flips to
  #(Kg) after save. The DB is correct throughout — this is a frontend display
  inconsistency, nothing stored is wrong.
⚠ WHY RE-STAMPED: this entry read "Fix in Route 5 if it matters." Route 5 has
  passed and it was never raised again, so it was tracked NOWHERE — not in the
  queue, not closed. Rule 9D: an ACTION belongs in NOW, not in a reference section.
  Section 5 records that it exists; the queue owns the doing.
FAMILY: same display-guard class as Defect 2 and P27 — a derived figure rendering
  wrong before the underlying value is settled. Worth batching with the R5 display
  switch rather than fixing alone.

J18 — S48 — mlomanagement.received_units → now JR3
New column (double DEFAULT 0), DB-only ALTER on RDS + declared as a Waterline
attribute in MLOManagement.js. The "Produced-To-Date Line": cumulative units produced
against an MO, banked from RPOBJ.qty in the receive loop. ONLY-CLIMBS; no core-stock
linkage. Read by the In-Progress box + MO progress bar. Old Kg received_qty UNTOUCHED
(still read by ~20 screens).
HEAL NOTE: MOs produced before the attribute was declared banked 0 (see J20 —
this is the entry that PROVED the trap); healed MO-0009 received_units → 20,
MO-0010 → 30 manually. Commit b74fbad.
Backup: /home/ubuntu/mlomanagement.bak-S48-before-received_units.sql

J19 — S48 — ⚠ CRITICAL: receive-product sent the MO PLANNED total, not the receipt
WHAT: receive-product.component.ts saveReceiveProd sent qty: this.mlcdetails.qty
  (the MO PLANNED total) instead of the entered per-receipt units. Effect:
  receiveproducts.qty stored the PLAN, repeated on every receipt.
  On MULTI-receipt MOs this (a) over-counted formulations.inventory_units
  (2×10u receipts added 20+20=40 instead of 10+10=20 → SOH 120 vs correct 100),
  and (b) corrupted the DO per-lot ratio qty/recieved_qty (DispatchOrders.js 154,
  254), doubling units-per-Kg.
WHY IT HID FOR SESSIONS: SINGLE-receipt MOs masked it entirely (plan == receipt),
  and recieved_qty (Kg) was ALWAYS correct — so every Kg-derived screen looked right.
FIX: send receiveProdForm.get("quantity").value. Verified safe — every backend reader
  of receiveproducts.qty wants per-receipt units. Healed: MO-0009 receipt rows
  qty 20→10, BC4 inventory_units 120→100. Commit 24e421df.

J20 — S48 — Waterline SILENTLY DROPS undeclared attributes  ⚠ SOURCE OF JT2
Attributes passed to .update().set() that are NOT declared in the model's attributes
block are discarded with NO ERROR. received_units updated to 0 silently until
declared in MLOManagement.js.
RULE: any new column written via .set() needs BOTH the DB column AND the model
attribute. (inventory_units works only because it was declared in Formulations.js.)

J21 — S48 — Route 5 In-Progress / progress-bar display switch
stock-info and formulation-edit-stock-info popups now compute In Progress as
qty(units) − received_units(units), and the bar percentage as received_units/qty
(units/units) — replacing the units-minus-received_qty(Kg) mismatch that produced
meaningless figures ("60 Kg" In Progress, 40% bars on a fully-produced MO). In
Progress now displays units# (Kg derived). Verified BC4. Commit f217b2eb.
NOTE: the bar TEXT LABEL still shows the Kg figure ("12.000 (20.000 Kg)") — bar fill
is correct; label is a cosmetic leftover for Route 5/6.

J22 — S49 (Jun 20 2026) — Shared MO progress indicator component
WHAT: Created src/app/shared/mo-progress-chart/ (standalone,
  <app-mo-progress-chart [mo]="row">) as the SINGLE SOURCE OF TRUTH for the MO
  production-status visual: 2 status circles (green at mlc_status.id >= 2 Material
  Issued / >= 3 Production Started) + a buildup bar (received_units/qty, units/units;
  orange <100%, green >=100%). Replaced hand-rolled 3-box blocks on 5 surfaces:
  MLO-Management, Mfg-lot-codes, Production-Controller, Closed-MLCs, Stock-Info popup.
  Also fixed the transposed Stock-Info label.
WHY: ONE visual, identical everywhere, change-once. Old code had the same bar math
  copy-pasted 7+ times, several reading received_qty(Kg)/qty(units) — the mismatch
  leaving Bar3 part-filled on fully-produced MOs.
⚠ STANDALONE-IMPORT NOTE: the component is standalone → goes in each module's
  imports[] NOT declarations[]. Stock-info popup needed it in BOTH modules that
  declare StockInfoComponent (create-agent-and-manufacturer.module +
  edit-sales-order.module).
COMMIT: 2228cda9. VERIFY FIXTURE: company 461 MO-0002 (Pdt-260620-2),
  received_units=100, qty=100 → two green circles + full green bar.
DEFERRED (do NOT mark done): Product-Traceability + Create-MO (add-mlo) intermediate
  block. [Product-Traceability was unlocked S51 — see J26/J27.]

J23 — S50 (Jun 21 2026) — Traceability One-Step-Forward: SO number + shipping-ref
  source fix (DB-ONLY, not in git) → now JR7c
WHAT: Trace_ProductOneStepForward_SP selected the WRONG COLUMNS for the two stacked
  values in the UI "SO Number - Customer Shipping Ref" column. Was:
  so_number = s.SO_Ref_No (SO external ref, null on most SOs → null on top) and
  customer_ship_ref = s.internalCode (→ SO-0001 on bottom). Corrected to:
  so_number = s.internalCode (SO-0001 on top), customer_ship_ref = ps.vehicle_no
  (packing-slip "Shipping Reference" on bottom). Only those two SELECT expressions
  changed. Frontend already renders so_number top / customer_ship_ref bottom.
⚠ KEY GOTCHA: the Create-Packslips field labelled "Shipping Reference" binds to
  form-control vehicle_num and stores in packingslips.vehicle_no — a RELABELLED
  VEHICLE-NUMBER FIELD. It is NOT shipping_reference_docs (the file-upload field,
  longtext). Confirmed by data: PS-0001 company 461 → vehicle_no = '1';
  PS-0003 → 'Inv 0128'.
⚠ ALSO: somanagement.internalCode = SO number; SO_Ref_No = external ref (often null).
REVISIT TRIGGER: rebuild from a pre-S50 snapshot → re-apply.
BLAST RADIUS: read-only. VERIFIED: CALL Trace_ProductOneStepForward_SP(3583, 11766)
  → so_number SO-0001, customer_ship_ref 1.
Files: /home/ubuntu/Trace_ProductOneStepForward_SP.bak-S50.sql (+ .txt);
  applied via /home/ubuntu/fix-onestepforward-S50.sql

J24 — S50 (Jun 21 2026) — Edit-Mlc button gating bound to the wrong status shape
  ⚠ SOURCE OF JT1
WHAT: On the MO Detail sheet (Edit-Mlc), action buttons' [disabled] bindings read
  mlcDetails?.mlc_status?.id. But this screen's data comes from stored proc
  WhC_GetMoDetails_SP (via getMLCbyIdV3), which returns mlc_status as a BARE NUMBER,
  not an object. So ?.id was ALWAYS undefined, every comparison false, and the
  buttons NEVER disabled — Receive Product was usable with no material released.
FIX: bind the bare value. Receive Product + Check Material Yield: disabled when
  mlc_status == 1 || == 2. Return Material/Product: disabled when == 1. Release:
  always live. (Check Material Yield had NO gate before; added.)
WHY A J ENTRY: it is the THIRD logged instance of the mlc_status data-shape trap
  (object .id vs bare number vs status_id). The same markup pattern (?.id) is CORRECT
  on populate-read screens and WRONG on stored-proc-read screens. Future status
  bindings MUST confirm the live read shape.
REVISIT TRIGGER: if WhC_GetMoDetails_SP is ever changed to return a populated status
  object, this binding breaks THE OTHER WAY.
⚠ DEEPER HOLE, NOTED NOT FIXED: Receive can be reached directly via /Receive-product
  and SAVED with no release — that needs a BACKEND/ROUTE GUARD, not a disabled button.
  Flagged S50 for a later decision. → see J-OPEN.
Commit 850c2143. Backup: /home/ubuntu/edit-mlc.component.html.bak-S50

J25 — S50 (Jun 21 2026) — Traceability PDF pagination re-enabled; release alert NOT
  converted (both intentional states)
WHAT: (a) downloadPDF() in product-traceability-details.component.ts had its
  multi-page jsPDF loop COMMENTED OUT, leaving a single full-height addImage that
  squeezed/clipped the sheet onto one page. Re-enabled (commit 8a589d3c).
  ⚠ KNOWN REMAINING: image-slice pagination can cut a table row across a page
  boundary (cosmetic; backlog for section-aware capture).
  (b) The Release-mat-details success path used native alert(), which freezes the
  loading spinner behind the popup until OK. A line-reorder experiment (spinner-off
  before alert) was tried, BUILT, tested, FOUND NOT TO FIX IT (the alert freezes
  repaint regardless of order), and REVERTED.
⚠ WHY LOGGED: so a future reader doesn't (a) think the PDF row-split is a regression
  — it's a known image-slice limitation; or (b) "fix" the release spinner with a
  line-reorder — ALREADY TRIED, DOESN'T WORK. The real fix is the toaster.
STATUS S72: (b) is DONE — J29 converted release-mat-details in S51, which killed the
  spinner-freeze. (a) still open.

J26 — S51 (Jun 23 2026) — Trace_ProductProdLotView: added received_units column
  (DB-ONLY, not in git) → now JR7d
WHAT: The Product-Traceability LIST rows carried received_qty (Kg) but not
  received_units, so the shared <app-mo-progress-chart> (which reads
  received_units / qty) could not render — one of the two S49-deferred surfaces.
  The list is served by Traceability.getMLCsByFormulaId → SELECT * FROM
  Trace_ProductProdLotView (a native VIEW, NOT a Waterline populate), so the column
  had to be added to the view's SELECT. Added mm.received_units AS received_units
  (the view already joins mlomanagement — no new join, no logic change). The old
  received_qty_su Kg/wgt acrobatic left in place (retire at Route 6).
  ⚠ STATUS S95: THE CLAIM ABOVE IS NO LONGER TRUE. That divide was
  removed in S95 (P91) — it did not wait for Route 6. See JR7e / J113.
  Everything else in J26 stands.
SOURCE OF TRUTH: received_units = mlomanagement.received_units, the existing
  Produced-To-Date Line (J18). NOT a new/third line.
REVISIT TRIGGER: rebuild from a pre-S51 snapshot → the column vanishes and the
  Product-Traceability bar reads EMPTY.
Files: /home/ubuntu/Trace_ProductProdLotView.bak-S51.txt (SHOW CREATE, the restore
  source) + fix-prodlotview-S51.sql. Frontend swap committed 0214d544.
VERIFIED: received_units 10 (qty 10) and 100 (qty 100), company 462; two green
  circles + full green bar, both rows.

J27 — S51 — mo-progress-chart statusId getter: status_id fallback (in git, 0214d544)
WHAT: The shared component's statusId getter read only mo.mlc_status (object .id or
  bare number). Product-Traceability LIST rows (from the view) carry status as
  status_id, not mlc_status — so the circles stayed grey. Changed to:
      const m = this.mo?.mlc_status ?? this.mo?.status_id;
      return (m && typeof m === 'object' ? m.id : m) || 0;
  Now handles all three shapes. This brings the code in line with the J22 comment
  that already CLAIMED three-shape handling (the code didn't actually do status_id
  until now).
WHY A J ENTRY: a deliberate WIDENING of a shared component's contract. The ?? takes
  mlc_status first when present, so all 5 previously-converted surfaces are
  unaffected — but a future reader should know the fallback is INTENTIONAL, not stray.
REVISIT TRIGGER: if a future screen passes BOTH mlc_status and status_id with
  CONFLICTING values (none does today), the ?? picks mlc_status.

J28 — S51 — Add-MLO In-Progress block: exclude CLOSED MOs (in git, 5192ae89)
  ⚠ SOURCE OF JT6
WHAT: add-mlo.component.ts ~341 filtered MLCs with `if (elem2.mlc_status.id != 4)`
  — i.e. it hid only COMPLETED MOs. But closing an MO sets close_status = 1 and
  LEAVES mlc_status unchanged (a closed MO commonly still reads status 3), so closed
  MOs kept showing in the In Progress list. Fixed to
  `if (elem2.mlc_status.id != 4 && !elem2.close_status)`. The !close_status catches
  both true and 1, and lets 0/false/null/undefined through.
WHY A J ENTRY: documents the non-obvious CLOSE-vs-COMPLETE distinction at the code
  site, so a future reader doesn't "simplify" the filter back to a single status
  check. close_status is a DECLARED attribute on MLOManagement.js, so it rides the
  formula_mlcs populate with no backend change — that's why the fix is one line.
REVISIT TRIGGER: if another screen's "in progress" list shows closed MOs, same bug.
⚠ Product-Traceability deliberately does NOT filter close_status — it is an AUDIT
  VIEW that must show all past lots including closed.

J29 — S51 — alert() → ngx-toastr sweep (in git; STARTED, LONG TAIL REMAINS)
WHAT: Began the app-wide sweep. Scope: ~448 alert( calls across ~110 files; dominant
  pattern is the error tail `alert(result.error || result)` (~200) →
  this.toastr.error(...). S51 converted the 5 daily-workflow files ONLY:
    - release-mat-details (8 alerts) — commit 0c32dadd. ⚠ This KILLS the J25
      spinner-freeze (the blocking alert halted change-detection so showSpinner=false
      couldn't repaint until OK; the non-blocking toast fixes it).
    - start-mlc (3), receive-material (3), receive-product (1 error) — d7cf0775.
    - receive-product SUCCESS toast ADDED (its success path silently did
      _location.back() with no confirmation) — ec966730.
PER-FILE RECIPE (proven, reuse for the tail): add
  `import { ToastrService } from 'ngx-toastr';`, inject `private toastr: ToastrService`
  in the constructor, convert each alert by category, build with heap flag, test, commit.
⚠ WHY A J ENTRY: (a) the sweep is PARTIAL — 5 files done, ~105 remain — so a future
  reader must not assume "toaster = done"; (b) the central ToasterService error-branch
  is STILL on alert() with its "// TODO if you wanna switch to toaster" —
  DELIBERATELY NOT FLIPPED, because most callers use raw alert() directly rather than
  routing through that service, so flipping it would help only ~10 files. The direct
  per-file conversion is the chosen path.
STATUS S72: this is the P0/P1 target — the alert plague is a DIAGNOSTIC TAX on every
  session (JT18). Folding the frontend file-size gate into the same sweep.

J32 — S52 (Jun 24 2026) — Pre-onboarding hygiene: stray files + session secret
WHAT: Removed 3 stray tracked files from frontend: edit-mlo.component.ts.bak,
  add-po.component.html.bak, environment.prod.ts.save (f9f27732). Removed
  config/routes.js.bak from backend — ⚠ A .bak TRACKED IN A SAILS PROJECT IS A
  LIVE-CODE HAZARD (Sails loads every .js) (7ec4397). Hardened both .gitignores with
  *.bak and *.save. Rotated the SESSION SECRET: was hardcoded in config/session.js
  (committed plaintext, signs user sessions). New via openssl rand -hex 16 into .env;
  session.js now reads process.env.SESSION_SECRET || (placeholder) (3f6f3c2).
SCAN RESULT — CLEAN: no AWS keys in frontend; .env is NOT tracked and IS gitignored.
[NOTE: J30 and J31 do not exist. Numbering gap is original, not a deletion.]

J33 — S52 (Jun 24 2026) — Committed plaintext DB passwords: INVESTIGATED, CLOSED.
  ⚠ NOT a rotation. The scary string was DEAD.
  [MERGED S72: two contradictory J33 entries existed — an earlier "MUST ROTATE" and
  a later "CLOSED, no rotation needed". The later is correct; this is that version,
  with the earlier entry's residual notes folded in.]
WHAT: A scan found plaintext mysql://user:password@host strings committed in git
  (and in history) — config/datastores.js lines 49-53, config/env/development.js
  line 43. The alarming one was the lab-prod password (the AbleTraceLab2026! string,
  commented).
FINDING: it was a PRE-S34 FOSSIL. An auth attempt returned ACCESS DENIED and its
  value did not match the live .env DATABASE_URL. S34 (Jun 9) had ALREADY rotated the
  real password into .env (correctly gitignored). ⚠ So NO rotation of the live DB was
  needed — and rotating unnecessarily RISKS LOCKING THE APP OUT.
ACTION TAKEN (backend commit 9c24dc6): stripped the dead committed mysql:// strings
  from datastores.js (4 fossil "// url:" lines), development.js (sudhirv line →
  process.env.DATABASE_URL), staging.js (sudhirVstg line → process.env.DATABASE_URL),
  and neutralised Sails sample placeholders (myc00lpAssw2D) in local.js /
  production.js / staging.js. Boot confirmed 200.
RESIDUAL (deferred to old-account close; ties to J1/J34): the OLD-account boxes
  abletrace-dev / abletrace-stg are still reachable (port 3306 open) and still hold
  the sudhirv / sudhirVstg passwords — but there is ZERO BRIDGE from them to the new
  account (a MySQL password is scoped to its own instance; it is NOT an AWS
  credential). Harmless until those boxes are torn down.
ALSO: config/session.js fallback placeholder 'CHANGEME_SET_SESSION_SECRET_IN_ENV'
  can be removed once env-load is long-confirmed (harmless; never triggers).
⚠ LESSON: (1) a "leaked" committed secret may be a DEAD FOSSIL — VERIFY it's live
  (auth test + hash-vs-.env) before any risky rotation. (2) GREP THE WHOLE REPO — the
  first recon only checked the two files G0b named and MISSED staging.js's committed
  string. Use `git grep` across the entire tree. (→ JT16)

J34 — S52 (Jun 24 2026) — DEFERRED: domain switch map (trace.mintek → app.abletrace.ca)
WHAT: Plan locked with Minty: the new app stays on its OWN infra (new EC2/RDS,
  multi-tenant by company_id); keep trace.mintekfoodsafety.com live now, onboard the
  new client there, later re-onboard the 2 old clients onto this same app
  (procedures-only, fresh start, NO raw-data migration), THEN switch the address to
  app.abletrace.ca, THEN the old AWS account (350466202408) becomes closeable. Old
  abletrace.ca stays = marketing website only; old app + 2 legacy clients UNTOUCHED
  until manual switch.
DOMAIN-SWITCH EDIT POINTS (when ready):
  frontend src/environments/environment.prod.ts apiUrl (currently
    'https://trace.mintekfoodsafety.com/api/v1/', ⚠ mislabeled "// dev server")
  backend config/env/production.js: UI_Base_Url line 24 (outbound email/reset links),
    CORS origins lines 151 + 250.
⚠ app.abletrace.ca is a SUBDOMAIN of abletrace.ca, whose DNS zone is in the OLD AWS
  account Route 53 (NOT GoDaddy). Adding the one app record is ADDITIVE and cannot
  affect the old app/clients, but it does require one edit where that zone lives —
  and that zone also holds live Zoho mail records (MX/SPF/DKIM/DMARC). BE SURGICAL.
Also resolve J1 keys at account-close time.

J35 — S53 — HACCP Excel download button did nothing: form-submit swallow
  ⚠ SOURCE OF JT10
The Download button on view-haccp sat inside a <form> with no type attribute, so it
defaulted to type="submit". Clicking SUBMITTED the form (a no-op navigation) and
SWALLOWED the (click)="downloadPDF()". Fix: added type="button" to the Download +
Edit buttons in view-haccp.component.html (commit fe1325b7).
⚠ GENERAL RULE: any action <button> inside a <form> in this app needs an explicit
type="button" or its click is eaten by the implicit submit. Watch for it elsewhere.

J36 — S53 — HACCP Excel: raw → professional 4-sheet styled workbook + cover redesign
downloadPDF builds an exceljs workbook (⚠ MISNAMED — it's Excel, not PDF). Rebuilt
into Cover + Hazard Identification + CCP Determination + HACCP Plan, blue-branded,
frozen panes, landscape. Cover redesign (6c42ed24): embedded AbleTrace logo, big
client company name (this.company_name), removed Section/SubSection/Signature + the
Mintek footer, name-only Approved By, divider rule.
⚠ The HACCP Excel KEEPS BLUE (all-black was Procedures-only). Cover region anchored
between the "SHEET 1: COVER" / "SHEET 2: HAZARD" comment banners so the 3 data sheets
stay untouched. Commits 366fa98b + 6c42ed24.

J37 — S53 — Procedures/Documents PDF: rebuilt off html2canvas onto the shared service
WHAT: The old downloadPDF rendered an HTML string to ONE canvas via html2canvas then
  sliced it into page-height image strips — which CUT THROUGH LINES OF TEXT and was
  blue-branded. Rebuilt on MoSheetPdfService (jsPDF-autotable): infoPairs from the
  form + one "Procedure Content" section, one row per line, rowPageBreak:'avoid' (no
  cut lines), all-black. CKEditor HTML → clean text via a new htmlToPlainText() helper.
  Section headers (non-bullet line ending in ':') render bold with a spacer row before.
  GENERIC across every procedure (⚠ the brief "is it per-procedure?" scare was a STALE
  CACHED DOWNLOAD). html2canvas fully removed from this path. Commit a8c384bd.
⚠ REINFORCES: reuse the shared service; never window.print/html2canvas again. This is
  its 3rd caller.
TECHNIQUE: per-row bold/spacers done with autotable CELL OBJECTS ({content,
  styles:{fontStyle:'bold'}}) mixed into the string rows; the service passes body as
  any, so no service change — cast the caller's rows array to any.

J38 — S53 — DEV/PROD model locked (plan; built S62–S66)
The current single running app = PROD. Before onboarding any real client, build a DEV
copy: separate DB, a second Sails/PM2 process on port 1338, served at
dev.mintekfoodsafety.com (own Nginx block + SSL, DNS in Mintek's own zone — no
old-account contact). Make the base URL ENV-DRIVEN (frontend apiUrl + backend
UI_Base_Url + CORS) so the later switch to app.abletrace.ca is one line.
⚠ RULES: all THREE clients (1 new + 2 returning old) live on PROD only — NEVER dev.
  Once clients are live, EVERY change goes dev → verify → prod; never test on clients.
STATUS S72: BUILT. Dev is a separate EC2 (not a second process on prod) with its own
  RDS. See J-S62/J-S66. The env-driven-URL half is NOT done — J34's edit points stand.

J39 — S53 — DB password RE-ROTATED (live DB; exposed-in-chat incident)
WHAT: The live lab-prod DB admin password was rotated. TRIGGER: during terminal work
  the THEN-CURRENT password appeared IN CHAT via command screen-output (and a freshly
  generated openssl value was pasted once) — i.e. exposed to the chat transcript.
  Rotated to a clean value generated SILENTLY straight to a file
  (openssl rand -hex 16 > /tmp/newpw.txt, NEVER PRINTED), set in the RDS console,
  synced to .env DATABASE_URL + the new ~/.my.cnf (chmod 600), temp file removed.
  Verified: mysql SELECT 1 at source, app reads DB, browser login works.
⚠ SEPARATE EVENT FROM J33. J33 was a dead committed fossil (no rotation). Here the
  LIVE secret was genuinely exposed, so rotation was real and necessary.
⚠ NORMAL PATTERN: generate secrets straight into a file/.env, never echo to screen,
  never paste into chat.
BLAST RADIUS: a fumble on a live-DB password LOCKS THE APP OUT — done with
  health-check ready; verified 200 + login before closing.

J40 — S53 — FRESH-DB re-apply checklist  ⚠ SUPERSEDED S72 BY THE JR BLOCK.
This entry created the checklist concept and listed 8 items. It stopped at S53 and
missed everything added since (J48 security, J49 index, J50/J51 seed, J60 sort,
J-S64 'None' hazard type, J-S71 nginx). ⚠ DO NOT USE THIS LIST — use JR.
Retained for the reasoning: J is the ONLY record of these; the fresh build is exactly
the "DB rebuild/restore" revisit-trigger that every DB-only entry warns about, ALL
FIRING AT ONCE. The proper fix remains a real applied-migration bootstrap.

J41 — S56 — PROD engine 8.4.9 + custom param group (config-only, NOT in git) → JR12
Prod RDS upgraded 8.0.44 → 8.4.9 (Blue/Green, in-place). Parameter group is now
abletrace-mysql84 (family mysql8.4) with mysql_native_password = ON (STATIC; set
before green was built, so it applied at build time — no extra reboot).
authentication_policy left at 8.4 default.
⚠ TRAP: if the instance is ever moved onto default.mysql8.4 (or a new 8.4 group is
created without this), native-password goes OFF and the app (mysql@2.18.0 driver)
CAN NO LONGER CONNECT. Any new 8.4 group MUST set mysql_native_password = ON until
the driver/caching_sha2 migration lands. Not a git artifact — re-apply on any fresh
8.4 build.

J42 — S56 — Binlog retention 24h (config-only) → JR12
Set S55 via CALL mysql.rds_set_configuration('binlog retention hours', 24); carried
through the upgrade, still reads 24 on the 8.4 instance. Was needed for a
reverse-replication rollback path that in the end was not used (the switchover was
clean) — harmless, left in place. Verify: CALL mysql.rds_show_configuration;

J43 — S56 — mysqldump / mysqlsh REJECT the ~/.my.cnf database= line
⚠ TRAP for any future dump/upgrade-check: plain mysql ACCEPTS that line, but
mysqldump and mysqlsh ERROR on it. Use a stripped temp cnf:
  grep -v -i "database" ~/.my.cnf > /tmp/dump.cnf; chmod 600 /tmp/dump.cnf
  --defaults-file=/tmp/dump.cnf ; rm -f /tmp/dump.cnf after (it holds the password).
⚠ ALSO on RDS: mysqldump needs --single-transaction (RDS blocks the default FLUSH
TABLES lock) and --column-statistics=0 when the client is newer than the server.
⚠ DEV HAS NO ~/.my.cnf AT ALL — a bare `mysql` hits a nonexistent local socket. Build
the cnf from .env.
⚠ NAME THE DB EXPLICITLY: `mysql abletracelab_live`. A bare `mysql` on prod lands in
the dormant ARCHIVE.

J44 — S56 — Schema name confirmations (from live 8.4 queries)
⚠ These bit during S56 ad-hoc validation. Pinned so future SQL uses the right names
first try:
  - formulations company FK column = company_id   (NOT fo_company_id)
  - the company table is SINGULAR: company        (NOT companies)
  - user is reserved-ish — BACKTICK it in raw SQL: SELECT ... FROM `user`

J45 — S56 — 8.4 InnoDB default changes (informational, no action taken)
The upgrade compatibility check flagged 18 changed 8.4 defaults (innodb_io_capacity
200→10000, innodb_adaptive_hash_index ON→OFF, innodb_change_buffering all→none,
buffer_pool_instances math, read/parallel-read thread math, etc.). LEFT AT 8.4
DEFAULTS — harmless for the current small workload.
⚠ WATCH: if the trace hotspots (Trace_MaterialDetails_SP, Trace_ProductHeaderView)
regress under real load after onboarding, revisit these in abletrace-mysql84 (esp.
innodb_adaptive_hash_index and innodb_io_capacity) BEFORE assuming a query problem.

J45b — S56 — The mysqlsh upgrade checker over-flags RDS
⚠ RECORD FOR THE FUTURE 9.x JUMP: the generic mysqlsh check reported "4 errors" that
were NOT real blockers — 3 removed replication vars (master_info_repository,
relay_log_info_file, relay_log_info_repository, set by the RDS default 8.0 group and
absent in the 8.4 family, resolved by the param-group swap) + default_authentication
_plugin=mysql_native_password (resolved by native-password ON). ALL data/schema checks
passed clean. TRUST RDS'S OWN BLUE/GREEN PRECHECK as the real gate; the generic
checker over-flags RDS-managed config/system-user items.

J46 — S58 — Fresh DB abletracelab_live built on the existing RDS instance
WHAT: Built the go-live production database as a NEW empty-then-seeded schema
  (abletracelab_live) alongside the archive (abletrace) on the SAME instance.
  Structure + logic from a --no-data --routines dump of the archive (68 tables / 36
  procs / 9 views); then the S58 bake-ins (J47/J48/J49) + global seed (J50) + Super
  Admin copy (J51). ZERO client/transactional data.
WHY: the old DB holds a FOLDED client's real 2-yr data + test data, not carried
  forward. Fresh = structure + logic + seed/reference + Super Admin only.
BLAST RADIUS: none to the archive — untouched, read-only source.

J47 — S58 — company.food_safety_enabled (Feature A foundation) → now JR4
ALTER TABLE company ADD COLUMN food_safety_enabled TINYINT(1) NOT NULL DEFAULT 0;
NOT NULL chosen deliberately so the entitlement is never a third ambiguous state;
every company defaults OFF (Traceability-only) until Super Admin flips it.
⚠ CODE HALF STILL TO DO: declare food_safety_enabled in Company.js attributes — J20
rule. WITHOUT THE ATTRIBUTE THE TOGGLE WRITE WILL SILENTLY NO-OP. (→ JO)

J48 — S58 — FS procs parameterized; Test_DynamicWhereClause dropped → now JR9
WHAT: FS_GetDocumentDetails_SP + FS_GetHaccpDetails_SP previously built their WHERE
  clause by STRING-CONCATENATING the caller's columnName + columnValue straight into
  the SQL (injection-shaped). Rebuilt PARAMETERIZED: value BOUND (SET @val =
  columnValue; PREPARE ... 'WHERE ... id = ?'; EXECUTE ... USING @val), columnName
  GUARDED to 'id' only (SIGNAL SQLSTATE '45000' otherwise). SIGNATURES UNCHANGED so no
  caller breaks. The editorContent boolean branch preserved exactly (the rtnColumn
  string is a FIXED INTERNAL LIST, not user input — safe to keep concatenated).
  Dead Test_DynamicWhereClause DROPPED (36 → 35 routines).
WHY SAFE: verified by grep — all 4 live callers (Documents.js:383/503/538,
  Hazards.js:248) pass columnName='id' ONLY. The "dynamic column" flexibility was
  NEVER USED, so hardcoding id + guarding is faithful.
NORMAL PATTERN: parameterize VALUES; WHITELIST IDENTIFIERS (a column name cannot be a
  bind parameter, so validate against an allowed set).
REVISIT: if a future caller needs a non-id column, extend the guard whitelist (one line).

J49 — S58 — idx_reject_company_status index → now JR10
CREATE INDEX idx_reject_company_status ON rejectmaterialandproduct (company_id, status);
company_id leads (selective int); status is varchar but stores few short values, no
prefix length needed. Baked in while the table was empty (instant). The other two
watch-list indexes (dispatchorders.formula_id, receiveproducts.mlc_id) ALREADY existed.
⚠ Trace-proc join indexes deliberately NOT added — measure under real load first (J45).
  DO NOT OVER-INDEX.

J50 — S58 — Global seed + the PER-COMPANY-SCOPE seed rule → now JR11
⚠ KEY DISCOVERY: several "lookup" tables are PER-COMPANY SCOPED (carry a company_id
  column) and were full of client-typed junk in the archive (hazardtype 'sdf'/
  'vULNABILITY'; misc_reason 'nrr'/'newest'; documenttype 'qqww'/'1233333').
  RULE: for those, seed ONLY the company_id IS NULL (global) rows.
Seed set and rationale → JR11. This also RE-APPLIES J3 (role 7 rides the whole-seed of
  roles + role_task).
CONSEQUENCE: the per-company-scoping + junk finding is the basis for the scope item
  "move producttype/documenttype/misc_reason/hazardtype to Super-Admin control, remove
  client add/delete" — an APP change (G0f), NOT part of the DB build.

J51 — S58 — Super Admin copied into the fresh DB (no company linkage) → now JR11
Copied user id 1 ("AbleTrace Admin", info.abletrace@gmail.com) + super_admin id 1
verbatim from the archive. NO company_users / company rows — the Super Admin is
PLATFORM-LEVEL and has none.
⚠ Super Admin = a super_admin-table row, NOT a role and NOT a user flag.
⚠ The salted-MD5 hash has a PER-ROW RANDOM SALT, making a hash impossible to
hand-generate without the plaintext — so copy-then-reset-through-the-app is the only
clean path.

J52 — S58 — (record) MD5 password hashing is a KNOWN weakness, deliberately deferred
SharedService.encryptpassword = 10-char salt + MD5(pw+salt). MD5 is weak (fast, no
work factor). NOT changed in S58 — modernizing (bcrypt/argon2) means editing
encryptpassword + validatePassword + a forced-reset/migration of existing passwords,
coordinated so login still verifies. Its own security project on a dev copy.
⚠ WHY A J ENTRY: so a future reader knows the weak hash is KNOWN AND DEFERRED, not
overlooked. Tracked as G0f #2.

J53 — S58 — Fresh-DB standing facts (traps discovered during validation)
  ⚠ THIRD BULLET WAS FALSE AND WAS STRUCK S73. See below and J80.
⚠ AUTO-INCREMENT IDS CARRIED FROM THE ARCHIVE: the structure dump did NOT reset
  counters (formulations ~3600, hazards ~1220). HIGH IDS ON A "FRESH" DB ARE NORMAL.
⚠ OPENING-BALANCE PO: material import auto-creates a PO under dummy supplier
  "OBDummy". Opening-stock ingredients trace back to OBDummy — EXPECTED for the
  induction seed, not a data error.
⚠ INTERMEDIATE AT RELEASE — ⚠ STRUCK S73. THE ORIGINAL BULLET WAS FALSE.
  It read: "MO release RECURSIVELY EXPLODES intermediates to their raw materials
  (consumes components, not intermediate stock); back-trace reaches all raw materials
  including the intermediate's components."
  THE RELEASE HALF IS FALSE — DISPROVEN LIVE S73 (J80). Release draws the
  intermediate's OWN STOCK against its OWN PRODUCTION LOT, as a normal release line
  alongside the parent's other recipe lines. Proven: MO-0006 released FO-0002
  25.000 Kg against lot Pdt-260717-1; FO-0002 SOH went 100# (500 Kg) → 95# (475 Kg).
  It is NOT exploded into components, and its components are NOT consumed again —
  they were consumed when the intermediate was produced.
  THE BACK-TRACE HALF IS TRUE and stands: back-trace DOES reach all raw materials
  including the intermediate's components — it walks down through the intermediate's
  own lot. That is the trace chain holding, and it is correct.
  ⚠ THE LIKELY ORIGIN OF THE ERROR: a recursive walk-down is REAL in this system, but
  it belongs to the ALLERGEN ROLLUP (the T5 twins, GET_NESTED_FORMULA_MATERIALS /
  GET_NESTED_ALLERGENS) and to BACK-TRACE — NOT to release. A THIRD recursive walk
  (explode to raw materials for FORECAST MATERIAL PLANNING) is NOT BUILT — that is
  where an explosion would legitimately live, and it is unbuilt scope. THREE distinct
  mechanisms; this bullet fused two of them into one false sentence and stamped it as
  a standing fact.
  ⚠ THE DOMAIN RULE (locked S73, in B): "intermediate" is a ROLE, NOT A TYPE. Any
  product can be consumed by another product's formulation, sold direct to a customer,
  or both. The user decides. There is no special intermediate class and no special
  release path.
[These were logged S58 as unnumbered "J —" bullets. Numbered J53 in S72. The other
bullets in that group are now JT3/JT4/JT5/JT6/JT7.]


J60 — S60 (Jul 3 2026) — Two document-LIST procs re-sorted to alphabetical → now JR8
  [DE-DUPLICATED S72: this entry was pasted twice, verbatim. One copy retained.]
WHAT: Two procs feeding document/procedure lists ordered by the wrong column, so lists
  came out non-alphabetical (the Material table then per-page-sorted the unordered
  data, making A→Z appear to "RESTART" each page).
    FS_Documents_SP       : ORDER BY d.version DESC   → ORDER BY LOWER(d.title) ASC
      (main Procedures/Documents list; Documents.js:97 + :649)
    FS_DocumentsByType_SP : ORDER BY d.updatedAt DESC → ORDER BY LOWER(d.title) ASC
      (HACCP procedure (type1) + record (type2) dropdown; DocumentType.js:78/97)
⚠ LOWER() IS DELIBERATE: the DB collation did NOT sort case-insensitively in practice,
  so a lowercase client-added title ("storing test") sorted AFTER all-caps entries.
⚠ Dropping the old version/updatedAt ORDER BY loses NO de-duplication — in both procs
  the subquery already collapses to one row per title (MAX per title).
VERIFIED: CALL FS_Documents_SP(464) + CALL FS_DocumentsByType_SP(464,1) both return
  A→Z incl. lowercase "storing test" in place.
NOTE: FS_DocumentRecordList_SP (bare SELECT *, no ORDER BY) LEFT UNSORTED — not a
  confirmed live picker source. Fix only if a scrambled Records list surfaces.
[J54–J59 do not exist. Numbering gap is original.]

J61 — S61 — CI build workflow is IN GIT; deploy script is ON-BOX only → now JR14
  .github/workflows/build-frontend.yml — IN GIT (1bf26deb), carries forward.
  /home/ubuntu/deploy-frontend.sh — NOT in git, and /home/ubuntu is NOT backed up
  off-instance. Drive Master Brief is the only other copy.
⚠ Frontend now builds in GitHub CI, not on the box — 2 GB RAM is too small (~2 GB heap
  needed, 1.9 GB total). This is a STRUCTURAL CEILING, not a config problem.

J62 — S61 — batch_qty pencil-edit was uncommented DELIBERATELY  ⚠ SOURCE OF JT19
The pencil-edit block in edit-formulation.component.html was previously COMMENTED OUT
(parked P3). S61 uncommented it deliberately (commit 9bce0238) after validating
in-place-no-fork + past-MO-safe on 464. ⚠ IF A FUTURE SESSION WONDERS WHY IT'S
"SUDDENLY" EDITABLE: it was intentional, tested, and shipped. DO NOT RE-COMMENT.

J63 — S62 — Dev-safety guard committed to config/bootstrap.js (backend b70ba10)
  [MERGED S72: two near-identical J-S62 entries existed; combined.]
WHAT: An IIFE above module.exports.bootstrap. INERT ON PROD (only acts when
  IS_DEV_BOX=true, which prod's .env never sets — returns silently). Trips
  process.exit(1) if a dev box's DATABASE_URL contains the prod host token
  "abletrace-lab-prod". PROVEN BOTH WAYS on dev: boots 200 when correctly wired (logs
  "[dev-safety-guard] OK"); refuses to boot (curl 000, "GUARD TRIPPED - REFUSING TO
  BOOT") when .env host swapped to the prod token, then reverted to 200.
  Same commit hardened .gitignore (.env* + global-bundle.pem) after finding an
  UNTRACKED .env.bak-prod-copy (prod secrets) in the repo — moved to
  /home/ubuntu/.env.prod-copy.bak-S62.
EIP RESOLVED: the two "spare" EIPs (15.223.243.179, 16.54.131.69) are RDS-MANAGED
  (Service managed: rds) — NOT releasable/associable, which explains the S62
  "permission" error. LEFT UNTOUCHED. Allocated NEW eipalloc-0c1a1db8451091427 =
  16.55.10.205 (tagged abletrace-dev-eip), associated to dev box i-098e2cc59844d9ef3.

J64 — S64 (Jul 9 2026) — "None" hazard type (DB-ONLY, NOT in git) → now JR11
INSERT INTO hazardtype (createdAt, updatedAt, name, company_id)
  VALUES (NOW(), NOW(), 'None', NULL);
Global (company_id NULL) → shows for every company like Physical/Chemical/Biological.
Got id 74 on BOTH dev and prod (archive auto_increment carried into the fresh DB;
high id normal — J53).
WHY DB-ONLY: hazardtype drives the dropdown data-driven; no code needed to render or
  to store/read on add+edit (hazardType is a per-row FK id through all three HACCP
  stages). Verified live in the dropdown.
⚠ NO BEHAVIOUR LOGIC: behaves like the other three (Sev/Prob default 1/1, editable,
  1×1→NS). Lock/auto-default DELIBERATELY NOT ADDED (would touch the fragile edit
  component — see G0h-S64).
REVERSIBLE: DELETE FROM hazardtype WHERE id=74 AND company_id IS NULL AND name='None';
Backups: /home/ubuntu/hazardtype.postinsert-S63.sql (prod), hazardtype.bak-S63.sql (dev).
⚠ NOTE: the prod PRE-insert dump initially came back EMPTY — the ~/.my.cnf database=
  trap (J43). Captured a post-state dump via the stripped-cnf method instead.

J65 — S64 — Secrets rotation (audit note, not a DB change)
SESSION_SECRET rotated (prod). S3_SECRET rotated: new key AKIATA4RHQY4PPOTJQMX on
prod+dev .env, verified live (HACCP Excel upload + procedure PDF download). Old
GK5TMHQC deactivated (deleted S65); orphan I3L3PG7I deleted.
⚠ METHOD NOTE: AWS secrets can contain / and other chars that BREAK sed → use the
/tmp-file + Python rewrite method for .env edits, NEVER sed.

J66 — S64 — Create-Packslips DO-list restructure (FRONTEND, in git, f6f821ac)
PopUps/do-list restructured to stacked columns (Product/DO, SO Internal/External, Pdt
Internal/External Id, Lot Code, Customer, Address) + new SO External field
(SO_id.SO_Ref_No, already populated → pure frontend). NOT a DB change.
⚠ LESSON: LAZY POPUP CHUNKS SURVIVE Empty-Cache-Hard-Reload AND LOGOUT. A FULL BROWSER
QUIT (Cmd+Q) is needed to load the new chunk. This has burned multiple sessions.

J67 — S66 — Dev nginx vhost + SSL are on-box config, NOT in git → now JR14
  [DE-DUPLICATED S72: pasted twice, verbatim. One copy retained.]
/etc/nginx/sites-available/dev.mintekfoodsafety.com (symlinked in sites-enabled) +
Let's Encrypt cert /etc/letsencrypt/live/dev.mintekfoodsafety.com/. Both on-box, NOT
in git. The old `default` site symlink in sites-enabled was removed (file kept in
sites-available).
Reproduce: recreate the vhost (mirror prod's abletrace vhost, swap server_name,
  /api/ proxy to localhost:1337), then
  sudo certbot --nginx -d dev.mintekfoodsafety.com -m info@abletrace.ca --agree-tos
    --no-eff-email --redirect

J68 — S66 — promote.sh + deploy-frontend.sh: Mac/on-box only, NOT in git → now JR14
  [DE-DUPLICATED S72: pasted twice, verbatim. One copy retained.]
~/promote.sh (Mac) and /home/ubuntu/deploy-frontend.sh (both boxes) are the deploy
tooling. build-frontend.yml IS in git; these two are NOT.
⚠ /home/ubuntu and the Mac home dir are NOT backed up off-instance. Drive is the record.
  deploy-frontend.sh md5 50e66fd427ebd31ff4502d4cd6b495a8
  promote.sh          md5 362e2f297aec9f1843ba38c82484d6cb

J69 — S67 — Client Guides: static PDFs bundled in git (not scp'd)
The 8 help-guide PDFs live IN the frontend repo (src/assets/docs/help-guides/) rather
than being placed on the box separately. DELIBERATE: Angular copies src/assets/** into
the build, so they deploy via CI→promote like any code change — no out-of-band file
step, and they version with the commit. Content source of truth = an off-repo editable
.docx set; regenerate PDF + re-commit to update.
(Precedent: assets/docs already held terms.html + privacy.html.)

J70 — S67 — Super-Admin tiles are HARDCODED, not data-driven
⚠ Unlike the left-rail nav (data-driven via getUpdatedRoles), the Super Admin HOME
tiles are literal <mat-card [routerLink]> blocks in home.component.html. To add a tile
= add a card + register the route in app-routing.module.ts. (Client Guides added this
way S67.)

J71 — S69 — isAdmin computed wrong: object compared to number (frontend, dfbadbb0)
  ⚠ FEEDS JT1
WHAT: The client Admin home licence banner never rendered even with perfect data.
  home.component.ts ~line 517 computed isAdmin as
  company_user_role.some(role => role.role_data[0].role_id === 2) — but role_id is a
  POPULATED OBJECT here (.id, .role_name), not a number. An object is never === 2, so
  isAdmin was ALWAYS FALSE, so the banner *ngIf never fired.
  PROVEN LIVE: getCompanyLicense returned correct data (licence_status_id.
  licence_status_name = "Trial", expiry_date present), yet an Elements search for
  "licence-banner" returned 0 matches — the div was not in the DOM.
FIX: role.role_data[0].role_id.id === 2, matching how the SIBLING component
  admin-dashboard.component.ts reads it (lines 72/73/88/128).
⚠ SAME FAMILY AS J24 (mlc_status). The sibling component was already correct; the home
  component was the OUTLIER.

J72 — S69/S70 — Licence banner: shipped, then SCOPE-fixed (frontend, 277b2491 →
  53db203d)
  [MERGED S72: the S69 entry logged the bug as deferred; two identical S70 entries
  logged the fix. Combined into one closed record.]
WHAT SHIPPED (S69, 277b2491): client Admin home licence banner to spec —
  Trial → "Your trial is expiring on [expiry_date | mediumDate]."
  Expired → "Your licence has expired." (flat, no date; one message covers both
    expired-trial and expired-annual)
  Active/Inactive/Invited → NO banner.
  File: src/app/Layouts/admin-dashboard/home/home.component.html (block at top).
  DATA PATH: getCompanyLicense → Company.findOne().populate('licence_status_id') —
  Waterline populate, so licence_status_id is an OBJECT carrying licence_status_name
  + id; expiry_date is a top-level company column.
  STATUS IDS: 1 Invited, 2 Trial, 3 Active, 4 Expired, 6 Inactive.
THE SCOPE BUG (found S69, fixed S70, 53db203d): the banner rendered on EVERY ROLE TAB,
  not Admin-only — because isAdmin is true whenever the user HAS an Admin role among
  their roles, REGARDLESS OF THE CURRENTLY SELECTED role in the header dropdown. Test
  user test260703 holds all 6 roles, so isAdmin stayed true everywhere.
FIX: banner *ngIf changed from `isAdmin && (...)` to `selectedRole === 2 && (...)`.
  selectedRole is set at home.component.ts lines 63-64 from
  userService.selectedGrpObservable — a BehaviorSubject(Number(...)) = the dropdown's
  numeric role_id (Admin=2). It ALREADY drives the tile *ngIf
  (task?.role_task_id?.role_id === selectedRole) reliably and reactively, so the
  banner now follows the dropdown and CANNOT RACE.
⚠ KEPT the J71 isAdmin fix — it was genuinely broken and isAdmin remains available to
  other consumers. We simply stopped GATING THE BANNER on it.
VERIFIED dev + prod: Admin tab only; absent on the other five; reappears reactively on
  switching back, no reload. Rollback: www-html.bak-{dev,prod}-53db203d4ef4.

J73 — S70 — Edit-PO Save 500: "oldFiles is not iterable" (backend, 19c8fd0, dev+prod)
  [DE-DUPLICATED S72: two versions existed; the fuller retained.]
WHAT: POST /api/v1/PO/updatePurchaseOrder returned 500 on any attempt to attach a
  reference doc to an EXISTING PO. Save is the ONLY path to attach ref docs
  post-creation, so ⚠ THIS HAD NEVER WORKED IN THE APP'S LIFE.
ROOT CAUSE: PurchaseOrders.js:253 `let oldFiles = checkPO.PO_ref_docs` — read straight
  off the Waterline record with no default, then spread at :266
  `allFiles = [...oldFiles, ...newFiles]`. PO_ref_docs was NULL on every row
  (DB-verified: all 4 POs on company 464), and [...null] throws exactly that message.
⚠ THE ASYMMETRY THAT HID IT: every value from the REQUEST is parsed (JSON.parse at
  :255, :262, :274) but the value from the DB NEVER WAS.
⚠ CHICKEN-AND-EGG: the column only becomes an array after a successful update, but the
  update could not succeed while it was null — so it 500'd FOREVER. The CREATE path
  (:162 JSON.parse(req.body.PO_ref_docs), :173 .map) works because it builds the array
  fresh from the payload and NEVER READS THE DB — which is why attach-at-creation
  worked and attach-later did not.
FIX: `let oldFiles = Array.isArray(checkPO.PO_ref_docs) ? checkPO.PO_ref_docs : []`.
  Chosen over a null-check deliberately (JT11) and over fixing the create path to seed
  [] — the read guard ALSO HEALS the existing NULL rows with no DB touch. The delete
  branch (:278 allFiles.filter()) shared the same exposure and is fixed by the same line.
VERIFIED AT THE DATA LAYER, not the toast: PO 2109 → JSON_TYPE ARRAY, JSON_LENGTH 2,
  two DISTINCT S3 uuids — so the :262-265 index-pairing of ref_docs against
  fileResult.files is sound. First time the merge path had ever executed.
⚠ LESSON: a rendered file chip is NOT evidence of a write — it looked IDENTICAL before
  and after the fix. (→ JT12)

J74 — S70 — Why PS/SO/Documents did NOT have the PO bug  ⚠ THE IMPORTANT HALF
  [DE-DUPLICATED S72.]
WHAT: grep "oldFiles" found the IDENTICAL unguarded pattern in FOUR models. Only PO
  was broken:
  - PurchaseOrders:253/266 — PO_ref_docs NULL on every row → CRASHED.
  - PackingSlips:254/267 — shipping_reference_docs, DB-verified JSON_TYPE=ARRAY value
    [] on every row → [...[]] is fine → ⚠ SAFE BY DATA, NOT BY CODE.
  - SOManagement:396/409 — customer_ref_docs, zero nulls → ⚠ same, safe by data.
  - Documents:428 — oldFiles is assigned and then NEVER USED; allFiles is built from
    the parsed request body with an [] fallback (:429). Safe BY CODE.
⚠ WHY IT MATTERS: PS and SO work BY ACCIDENT — their create paths seed [] where PO's
  create left NULL. DO NOT "TIDY" THOSE CREATE PATHS to skip seeding [], and DO NOT
  assume the read is defended: IT IS NOT. Hence the parity guards (J75). (→ JT19)

J75 — S70 — PS/SO ref-docs guards for parity (backend, 281c8b3)
  [DE-DUPLICATED S72. STATUS UPDATED S71 — see below.]
WHAT: PackingSlips.js:254 → Array.isArray(checkPS.shipping_reference_docs) ? ... : [];
      SOManagement.js:396 → Array.isArray(checkSO.customer_ref_docs) ? ... : []
Documents.js deliberately UNTOUCHED (oldFiles is dead there — nothing to guard).
⚠ WHY Array.isArray AND NOT A NULL-CHECK: under the future mysql2 driver (G0e) a JSON
  column may come back as a STRING. A string does NOT throw on spread —
  [..."[\"a\"]"] silently spreads into CHARACTERS and corrupts the array with no
  error. Array.isArray stays correct under both drivers. (→ JT11)
⚠ HOW IT REACHED PROD: as a SIDE-EFFECT of the S70 git reconcile (reset --hard
  origin/main), NOT a deliberate promote.
STATUS: SO half BROWSER-VERIFIED S71 (SO-0005/2504 dev, SO-0003/2500 prod both landed a
  .png through the guard). PS half STILL UNVERIFIED. (→ JO)

J76 — S70 — PROD data heal: documents 3517 + 3519 (DB-ONLY, prod, not in git)
WHAT: The two procedures created on prod while 771d775 was live stored escaped quotes
  (bs 13, len 867684) and rendered broken images. After the revert, healed in place:
  UPDATE documents SET editorContent = REPLACE(editorContent, '\\"', '"')
    WHERE id IN (3517,3519);
VERIFIED: both now len 867680 / bs 0 — byte-identical in shape to 3520, which saved
  clean after the revert. ⚠ ZERO DATA LOSS: the base64 payload was always intact, only
  the quoting was wrong.
BACKUP (pre-heal, restorable): /home/ubuntu/documents-3517-3519.bak-S70.sql (1.7MB).
⚠ REVISIT: if a future change re-introduces escapes, this REPLACE is the heal pattern
  — but FIX THE WRITE PATH FIRST, or the next save re-breaks the row.

J77 — S70 — Backend 771d775 landed UNRECORDED (docs-hygiene)  ⚠ THE COSTLIEST ENTRY
  [DE-DUPLICATED S72.]
WHAT: S70 opened with both boxes at backend HEAD 771d775 while Section G said 3fddf79
  "unchanged". 771d775 ("Fix SQL injection and apostrophe-breaks-save") sat directly on
  top of 3fddf79 and was pushed to origin/main — ⚠ THE CODE WAS NEVER AT RISK. What was
  missing was the RECORD: no G update, no J entry, despite being a security change.
⚠ WHAT IT COST: the session opened by chasing a phantom dev/prod delta that did not
  exist — and that same unrecorded commit turned out to be the cause of the client's
  image bug four hours later.
⚠ LESSON: these docs are the only technical memory. There is no colleague to ask. Code
  in git but absent from G/J is exactly the drift Section 0 warns about. An unrecorded
  change is an UNRECORDED SUSPECT when something breaks later.

J78 — S71 — OPEN-1 CLOSED: the document-save double-encode was a JUN-2023 bug
  ⚠ THE BIG ONE. Read before touching Documents.js or FS_upd_Documents_SP.
  ⚠ SOURCE OF JT13, JT14, JT15.
THE HISTORY: 771d775 (Jul 14 2026) parameterized four sendNativeQuery call sites,
  fixing a REAL bug — an apostrophe in procedure text ("the trailer's Set Temperature")
  closed the inlined SQL literal early → ER_PARSE_ERROR. But it silently BROKE PASTED
  IMAGES: they stored as <img src=\"data:image/png;base64,...\"> and rendered as a
  broken-image placeholder. Reported by the client. S70 REVERTED it — which RE-OPENED
  the apostrophe bug, leaving prod knowingly broken on document save.
THE THREE FORMS, ALL MEASURED (⚠ DO NOT RE-DERIVE):
  * INLINE  `CALL FS_upd_Documents_SP('${JSON.stringify(DOCOBJ)}')`
      → apostrophes ✗, images ✓
  * BOUND   `CALL FS_upd_Documents_SP($1)`, [json]
      → apostrophes ✓, images ✗
  * BOUND+CAST `CALL FS_upd_Documents_SP(CAST($1 AS JSON))`, [json]
      → apostrophes ✓, images ✗.  ⚠ CAST CHANGES NOTHING. Tested S70. DO NOT RETRY.
THE PROC IS NOT AT FAULT — PROVEN, NOT ASSUMED. FS_upd_Documents_SP takes IN jsonData
  JSON and reads `SELECT jsonData->>'$.editorContent' INTO v_editorContent;` (the
  equivalent JSON_UNQUOTE(JSON_EXTRACT(...)) sits commented beside it). Both operators
  are equivalent and BOTH unescape correctly on 8.4.9:
    SELECT j->>'$.c', JSON_UNQUOTE(JSON_EXTRACT(j,'$.c'))
    FROM (SELECT CAST('{"c":"<img src=\\"d\\">"}' AS JSON) AS j) t;  → both <img src="d">
ROOT CAUSE (S71): a JUN-2023 line — Documents.js:350/489, commit 4430ea89 —
  JSON.stringify'ing an ALREADY-STRING editorContent. ⚠ THREE YEARS OLD. The escape
  arrived ALREADY DOUBLED from the JS side: for \" to survive ->>, the JSON must
  contain \\", i.e. editorContent was already an escaped string before
  JSON.stringify(DOCOBJ) ran over it, so stringify escaped the escapes.
⚠ THE INLINE FORM MASKED IT BY ACCIDENT: MySQL's string-LITERAL parser strips one layer
  before JSON parsing begins, leaving exactly one → a clean ". Two escape layers
  CANCELLED. Binding removed the literal parser and EXPOSED the double-encode.
⚠ 771d775 DID NOT CAUSE THE IMAGE BUG — IT REVEALED THIS ONE. (→ JT15)
THE 4-BYTE DELTA IS THE PROOF: 842,052 inline vs 842,056 bound = the two escapes.
FIX (d3104ea): fixed at SOURCE — removed the double-encode — then RESTORED THE BOUND
  FORM. Apostrophes ✓ AND images ✓. Injection surface closed at BOTH write sites.
  Both bugs died together.
TEST MATRIX — ⚠ BOTH MUST PASS, EVERY TIME, verified in the DB not the toast:
  (1) SOP text containing an apostrophe; (2) a pasted process-flow image.
  SELECT id,title,LENGTH(editorContent) len, LOCATE('\\"',editorContent) bs
  FROM documents WHERE company_id=464 ORDER BY id DESC LIMIT 2;
  PASS = save succeeds AND bs=0. An image doc reads ~842,052, NOT 842,056.
EVIDENCE ROWS — ⚠ KEEP THESE:
  DEV: 3479 "dd" (image, INLINE, len 842052, bs 0 = GOOD ref)
       3481 test260715a (image, bound+CAST pre-fix, len 842056, bs 13 = BAD ref)
       3483 test260715c (image, BOUND post-fix, len 842052, bs 0 = THE PROOF — matches
            3479 exactly)
       3482 test260715b (apostrophe SOP, bs 0); 3484 Allergen control procedure v7
            (edit/fork path, bs 0)
  PROD: 3526 test260715d (image, post-fix, len 842052, bs 0); 3525 Allergen control
        procedure (edit/fork, bs 0)
CONSEQUENCE: G0f#3 (dynamic-SQL) — those two Documents sites are CLOSED again.
  ⚠ STILL OPEN: WhC_GetMoProductReceivingDetails_SP ('CALL ...('${mlcDetails.id}')')
  — id is app-controlled numeric so LOW risk; parameterize when the security pass
  touches procs. (→ JO)

J79 — S71 — nginx client_max_body_size was at its 1MB DEFAULT on BOTH boxes → JR13
WHAT: Every upload path in the app, since day one, was silently capped at 1MB. Now 10M
  on both boxes.
⚠ WHY IT WAS INVISIBLE: nginx rejects with a bare 413 BEFORE Sails ever runs — so it
  never reaches pm2 logs, and the app cannot catch it. The alert() plague then renders
  it as "[object Object]". (→ JT18)
⚠ CONSEQUENCE: the app STILL cannot catch a >10MB rejection. The fix is a FRONTEND
  file.size check on select + a toast, BEFORE upload. (→ JO)

J80 — S73 (Jul 17 2026) — THREE LIVE VERIFICATIONS ON DEV. TWO DOC CLAIMS
  STAMPED "Confirmed" WERE FALSE.  ⚠ READ BEFORE TRUSTING ANY "Confirmed" IN B.
WHY THIS ENTRY EXISTS: S73 combed Section B and found it asserting BOTH sides of the
  same question in two places, each stamped confirmed. Minty tested all three on dev
  in ~20 minutes. Claude had been reasoning toward answers; the screen settled them.
  ⚠ THE LESSON IS NOT "B was sloppy" — it is that a CONFIRMED STAMP IS NOT EVIDENCE.
  Two of three were wrong. (JT13 — measure the boundary.)
FIXTURE: dev, company 464, user test260703. Product testpdt260703 (FO-0001-4, Case,
  20 Kg/unit). Intermediate testintermediate pdt 260703 (FO-0002, Internal Container,
  5 Kg/unit). Material BBQ Sauce Bulks (MAT-6).

TEST 1 — ALLERGEN SNAPSHOT: ⚠ CLAIM WAS FALSE.
  B (S59) claimed: "the MO stores an allergens snapshot at production; editing an
  ingredient's allergen later does NOT rewrite a shipped lot's allergen record. This
  is the core food-safety protection. Confirmed."
  BEFORE: MAT-6 carried Sesame seeds → testpdt260703 showed [Sesame seeds, Milk] →
    MO-0003 (lot Pdt-260704-1, PRODUCED, 1.000# / 20 Kg completed) showed
    Allergens "Sesame seeds, Milk".
  ACTION: removed Sesame seeds from MAT-6.
  AFTER: product → [Milk]. SAME MO-0003, SAME produced lot → Allergens "Milk".
  ⚠ THERE IS NO AS-MADE ALLERGEN SNAPSHOT. Everything re-derives live, through to
    past and produced lots. B's claim struck.
  ⚠ CAVEAT (JT12): the SCREEN re-derives, proven. Whether a snapshot VALUE is stored
    on the MO row and simply never read is UNTESTED. It does not change the answer —
    a snapshot that is never read protects nothing — but it is the difference between
    "not built" and "built and orphaned". One query, not urgent.
  MINTY'S RULING (now locked in B): live re-derivation is CORRECT. Allergen
    declaration is CLIENT KNOWLEDGE. If an ingredient was mis-declared the record was
    always wrong; freezing it would preserve the error on every lot. A correction must
    reach past data.
  ⚠ ALSO PROVEN BY THIS TEST: the whole nested allergen chain works end to end on
    8.4 — material → rollup through the product → surfaced on a produced MO → and the
    REMOVAL propagated back down the same path. The T5 recursive pair is sound.

TEST 2 — INTERMEDIATE DRAW-DOWN ON RELEASE: ⚠ J53's CLAIM WAS FALSE.
  J53 claimed: "MO release RECURSIVELY EXPLODES intermediates to their raw materials
  (consumes components, not intermediate stock)".
  SETUP: MO-0005 produced 100# (500 Kg) of FO-0002, lot Pdt-260717-1.
  MO-0006 created for parent testpdt260703, 10# / 5 batches. Add-MLO Intermediate
    Product block read: Quantity Required 25.000 Kg (5 #), Warehouse Stock 500.000 Kg
    (100 #), In Progress MO-0005.
  RELEASE (MO-0006, Release-mat-details): FO-0002 appeared as ITS OWN RELEASE LINE —
    "testintermediate pdt 260703 / FO-0002 / 25.000 / 25.000 Kg", drawn against lot
    Pdt-260717-1 (Rec-260717-1 = 500.000 / 500 Kg). Released ALONGSIDE the parent's
    own recipe lines (Raw Chicken MAT-2, Yogurt MAT-3, Ginger Powder MAT-5, BBQ Sauce
    MAT-6) — NOT instead of them, and NOT exploded into components.
  AFTER: FO-0002 SOH 100# (500 Kg) → 95# (475 Kg). Exactly the 5# / 25 Kg released.
  ⚠ THE INTERMEDIATE IS RELEASED AS A STOCKABLE PRODUCT AGAINST ITS OWN PRODUCTION
    LOT. J53's release half struck. Its back-trace half is true and stands.

TEST 3 — SOH LEAVES AT DO CREATION: ⚠ DOCUMENTED RULE HELD. VERIFIED.
  Logic J / GR4 claim: "Stock leaves inventory_units at DO CREATION, not at ship."
  BEFORE (Stock Info popup, testpdt260703): In Store 4# (80 Kg) · Allocated to PS 0#
    · Allocated to DO 0# · In Progress 10# (200 Kg).
  ACTION: SO-0006 → Create Dispatch Order → lot Pdt-260701-1 (Rec-260704-1),
    Shipping Units 1, Qty 20 Kg. Saved.
  AFTER: In Store 3# (60 Kg) · Allocated to DO 1# (20 Kg) · Allocated to PS 0#.
    Products list confirmed 4# (80 Kg) → 3# (60 Kg).
  ⚠ RULE CONFIRMED BY DATA, not by document. Stock left In Store at DO CREATION,
    exactly one unit, into the DO bucket.
  MINTY'S REASON (now in B, was never recorded): SOH means AVAILABLE TO THE PLANNER.
    Once allocated to a DO it is spoken for and must not be planned against — even
    though it is still physically in the building. That is WHY the drop is at
    allocation, not at the truck.
  ⚠ STILL UNTESTED: the DO→PS hop leaving SOH untouched. Minty states it as rule;
    not exercised S73.

⚠ THE OBSERVATION THAT MATTERS MOST — FEEDS P1:
  All three tests were read off the PRODUCTS LIST / STOCK INFO screens, and the SOH
  column tracked every UNIT move exactly (100#→95#, 4#→3#). But J13 / Logic G say
  that column is Trace_ProductHeaderView — a Kg-derived live view, INDEPENDENT of
  inventory_units, which will "LEGITIMATELY DISAGREE" with the units column until the
  display switch. IT DID NOT DISAGREE. ONE OF THOSE IS WRONG.
  Either the display already reads the units line, or the view derives from something
  that moves in step. ⚠ THIS SIZES P1 — read what the Products list actually reads
  BEFORE planning the units audit. Do not assume J13 is current.

BLAST RADIUS: none — all reads and dev-only edits. ⚠ MAT-6's Sesame seeds allergen
  was REMOVED on dev and NOT restored. Dev fixture state changed; note it before
  reading MAT-6 allergens as a baseline.


──────────
J81 — S77 (Jul 21 2026) — FORK ship_qty "=0" was NEVER A REAL BUG.
  Doc misread, live-verified closed. ⚠ Same family as J80 — a "confirmed"
  claim tested on dev and found false.
WHAT THE DOCS CLAIMED: version-fork drops ship_qty→0 for intermediates.
  Stated as an OPEN bug in K1 (actions 12/14) + 3A.5 row 1 + §2 to-verify #8,
  "DB-confirmed S45 FO-0007 ship=0", fix = "Fix A" outstanding. ⚠ J9b
  ALSO already said it was fixed — but credited a "Fix A landed S46/S47".
CLOSED BY THREE INDEPENDENT CHECKS (0.1a — looked, did not reason):
  1. LIVE (dev, co464): added intermediate @7u to FO-0005 → forked to
     FO-0005-2 → DB rows srf 1042 (ship=7) + 1043 (ship=1). Both carried
     forward. Zero 0-values. Confirmed rows belong to the fork (sub_recipe_id
     3934 → fosubrecipe → formulation 3686 = FO-0005-2 v2).
  2. CODE: Formulations.js:901 `ship_qty: formula.ship_qty`. The fork and the
     pure-add share ONE handler (methodForCreateFormula, ~line 867) which reads
     ship_qty forward from the payload — no separate fork branch writing 0.
     git blame: that line present since commit 2e21c0f, 2022-07-05.
  3. OPERATOR: Minty confirms never saw a ship_qty=0 in 4 years of live use.
VERDICT: not a code bug, not reproducible. The write path has carried ship_qty
  forward since 2022. The original S45 "FO-0007 ship=0" was a MISREAD written
  down as fact and copied forward — the exact 0.1a / J80 failure mode.
⚠ CORRECTS THE HISTORY, NOT JUST THE STATUS: J9b's "Fix A landed S46/S47"
  is itself doubtful — line 901 predates S46 by ~4 years, so there was likely
  no separate fix to land. The bug and its fix may both be phantom. FO-0007's
  single 2022 reading not chased (prod data, no live symptom, not worth it).
ACTIONS (carried into the P1 fold, not pre-edited): strike the "open bug /
  Fix A needed" claim from K1(12/14), 3A.5 row 1, §2 to-verify #8. Update J9b
  to point here. No "Fix A" P-item needed — the fix was never needed.
FIXTURE: dev 464 FO-0005 is now 2 versions (v1 status2 / FO-0005-2 v2 status1)
  + srf rows 1042/1043 — S77 test residue. Dirtier baseline; note before reuse.
BLAST RADIUS: none — all reads + dev-only edits (co464). No prod, no app code.
========


──────────
J82 — S78 (Jul 21 2026) — ALLERGENS: J80's TEST 1 REPRODUCED IN THE OPPOSITE
  DIRECTION, AND THE BLAST RADIUS MEASURED.
  ⚠ THIS IS NOT A NEW FINDING. J80 settled it in S73. This entry exists because
  THE STRUCK CLAIM SURVIVED IN THREE OTHER PLACES and was still being read as
  fact five sessions later.
WHY IT HAD TO BE RE-TESTED: at the S78 fold, Section K2 row 7 asserted a "FROZEN
  SNAPSHOT: MO captures as-made allergens; later material edits do NOT rewrite
  shipped-lot record — OK, FLAGSHIP", K1 action 15 repeated it ("MO stores
  allergens snapshot (as-made)"), and §2's Edit-integrity rule stated it as settled
  domain law. J80 had struck the claim in ONE place. It lived on in THREE.
  ⚠ A STRIKE THAT DOES NOT CHASE EVERY COPY IS NOT A STRIKE. (Rule 7.1 — whole
  items only, Claude does the diffing.)
THE TEST (dev, company 464, user test260703 — built clean for this):
  BASELINE: product test260720 (FO-0007), created with NO allergen. Its recipe holds
    ONE material, Ginger Powder MAT-5, itself carrying NO allergen. Sub Recipe1, no
    intermediate — the simplest possible path. MO-0012 (lot Pdt-260721-2) created,
    produced and received: plan 10.000# = completed 10.000#. Allergens field EMPTY.
  ACTION: added Eggs to Ginger Powder MAT-5. Saved. Nothing else touched.
  AFTER: ⚠ THE SAME MO-0012, THE SAME ALREADY-COMPLETED LOT, now reads
    Allergens "Eggs".
VERDICT: identical to J80 TEST 1, in the ADDITION direction, on a different product.
  There is NO as-made allergen snapshot. Allergens re-derive live from the current
  recipe, through to past and produced lots.
⚠ THE NEW PART — BLAST RADIUS. J80 measured one product. This test shows ONE
  MATERIAL EDIT rewrote the allergen display on ALL SEVEN products in the company
  sharing that ingredient — test1.39, Test1.39-IP, Test260704, test260719,
  test260720, testintermediate pdt 260703, testpdt260703 — and on their existing
  lots. The rollup is company-wide and immediate, not per-product.
⚠ J80's OPEN CAVEAT IS STILL OPEN. Both tests read a SCREEN (JT12). Whether
  mlomanagement.allergens holds a stored value that is simply never read is STILL
  UNTESTED. It does not change the answer — a snapshot nobody reads protects
  nothing — but it is the difference between "not built" and "built and orphaned",
  and GR7 documents the column as a "longtext JSON snapshot". One query settles it.
  ⚠ DO NOT write "the column is unused" into any document until someone has
  SELECTed it.
MINTY'S RULING STANDS (locked S73, re-affirmed S78): live re-derivation is CORRECT
  domain behaviour. Allergen declaration is CLIENT KNOWLEDGE. If an ingredient was
  mis-declared the record was always wrong, and freezing it would preserve that
  error on every lot ever made. A correction must reach past data.
⚠ THE RESIDUAL RISK IS THE REVERSE DIRECTION, and it is a DOMAIN decision, not a
  code one: a lot that genuinely contained an allergen can have that allergen
  REMOVED from its record by a later edit, with no audit trail of what the record
  said at ship time. Whether a shipped lot needs a separate immutable as-declared
  record is Minty's call. → tracked as P29.
DOCUMENTS CORRECTED AT THE S78 FOLD: K2 row 7 struck · K1 action 15 struck (both
  retired with Section K) · §2 Edit-integrity rule to be reworded · §2 GR7
  "allergens = longtext JSON snapshot" to be reworded once the column is actually
  queried · Section 3A.2 carries the corrected statement.
FIXTURE RESIDUE ⚠ DEV ONLY: Ginger Powder MAT-5 now carries Eggs, added S78, NOT
  reverted. Company 464 was already a dirty baseline — it also holds MAT-6 missing
  its Sesame (J80/S73 → P24) and FO-0005's two-version fork residue (J81/S77).
  ⚠ Note all three before using 464 as a baseline.
BLAST RADIUS: none to prod — all reads plus one dev-only material edit on company
  464. No app code touched, no prod data, no schema change.
========

J83  J13 vs J80 RECONCILED — J13 RIGHT ON DISPLAY, J80 WRONG. (S79, dev, read-only.)

     THE CONFLICT: J13 said the Products-list SOH is Kg-derived and would
     "legitimately disagree" with inventory_units. J80 said it did NOT
     disagree — every unit move tracked exactly. Both could not be true.

     SETTLED BY LOOKING (rule 0.1a), two reads on dev:
       1. SHOW CREATE VIEW Trace_ProductHeaderView — every _su field is
          <Kg column> / wgt_kgs_per_unit. inventory_units and received_units
          appear NOWHERE in the view.
       2. grep wgt_kgs_per_unit across src/app — ~30+ sites divide. The
          Products list (admin-formulation.component.ts:878) divides the OLD
          Kg column: element.inventory / packing?.wgt_kgs_per_unit.

     ⚠ WHY J80's EVIDENCE LOOKED CLEAN — THE TRAP WORTH REMEMBERING:
     the test used 10# at 1 Kg per unit. 10 / 1 = 10. A weight ratio of
     exactly 1 makes a division invisible. The numbers reconciled because
     the arithmetic was a NO-OP, not because anything read the units line.
     ⚠ NEVER VERIFY A UNIT-CONVERSION PATH WITH A 1:1 FIXTURE. Use a
     product whose wgt_kgs_per_unit is not 1 (and ideally not round).

     ⚠ WHICH HALF OF J80 SURVIVES: its STOCK-HOP findings stand — the
     anchor is clean at receive/DO/PS/ship/MR/intermediate, verified
     separately. Only its DISPLAY finding is withdrawn. Do not read this
     entry as discrediting J80 generally.

     ⚠ ONE SITE IS ALREADY CORRECT: PopUps/stock-info.component.ts:188
     reads inventory_units and MULTIPLIES. Its sibling
     formulation-edit-stock-info.component.ts:269 still divides the old Kg
     column — two popups, same figure, one right one wrong.

     ALSO CONFIRMED THIS SESSION (rule 4.3 in action): three suspected
     missing-operator defects in edit-packslips.component.ts:267/322 and
     formulation-edit-stock-info.component.ts:269 were GREP ARTIFACTS. The
     files are clean — cat -A showed the `/` present. The chat/grep render
     had dropped forward slashes inside long template literals. Same family
     as the S71 missing-dot artifact. NOTHING TO FIX.

     STATUS: gate closed. P2 re-scoped in Section 1 from a fix to a campaign.
========

J84  THE TWO BOXES RUN DIFFERENT OPERATING SYSTEMS — AND THE MIRROR CHECK
     PASSED ANYWAY. (S79, both boxes, read-only.)

     FACT, verified from /etc/os-release on each box — not from a banner:
       PROD   Ubuntu 26.04 LTS "resolute"   kernel 7.0.0-1004-aws
       DEV    Ubuntu 24.04.4 LTS "noble"    kernel 6.17.0-1017-aws
       NODE   v18.20.8 on both (this part genuinely does match)

     ⚠ THE RECORD HAD COLLAPSED TWO MACHINES INTO ONE FACT. Old A1 said
     "24.04". A later note "corrected" it to 26.04. BOTH WERE RIGHT —
     about different boxes. The correction was not wrong, it was
     answering a different question than the one being asked. Same
     shape as the t2/t3 inversion, one layer subtler.

     ⚠⚠ THE PART WORTH KEEPING IS NOT THE OS. IT IS THAT A CHECK PASSED.
     S63 ran a dev/prod mirror check, it PASSED, and it was recorded as
     confirming parity. It compares repos, HEADs, schema, PM2 and health
     — the application stack — and never looks at the host. So the
     divergence was not missed through carelessness; it was OUTSIDE WHAT
     THE CHECK LOOKED AT, and the passing result was then read as
     "everything matches". ⚠ A GREEN CHECK IS ONLY EVIDENCE ABOUT WHAT
     IT TESTS. Same failure family as J83's 1:1 fixture: a result that
     could not have revealed the problem, read as though it had.
     → 3B.5 now carries a separate HOST CHECK for exactly this.

     ⚠ CAUSE: UNKNOWN, AND NOT RECOVERABLE. Do not invent one.
       · S62 (dev stand-up) records the box, the RDS and the safety
         guard — but no AMI and no OS version.
       · Prod's apt history only reaches 2026-05-29; older logs rotated.
       · /var/log/dist-upgrade EXISTS but is EMPTY, created 16 Apr —
         which leans AGAINST a release upgrade having been run, but
         does not prove it.
       Most likely dev was simply built later from an older AMI. ⚠ THAT
       IS A GUESS AND IS RECORDED AS ONE. If a future session finds
       evidence, replace this paragraph whole; do not soften it.

     CONSEQUENCE: dev is a twin of the APPLICATION, not of the HOST.
     Anything kernel-, systemd- or packaging-dependent is not rehearsed
     by doing it on dev. P21 (the reboot) re-scoped accordingly.

     ALSO FOUND, same pass: unattended-upgrades is active on PROD and
     was documented nowhere. → P34.

     STATUS: fact settled, cause closed as unrecoverable, 3B.2 / 3B.3 /
     3B.5 corrected, P21 re-scoped, P34 raised.
========

J85  "THE DEAD BLOCK" IN editPackslips IS NOT DEAD — IT IS LIVE CODE THAT
     THROWS, AND THE THROW IS LOAD-BEARING. (S79, dev, read-only.)

     §2's to-verify item 5 had recorded PackingSlips.js:333-334 as a dead
     block with the instruction "do NOT repair". ⚠ THE INSTRUCTION WAS
     RIGHT AND THE REASON WAS WRONG — which is worse than being wrong
     twice, because the right instruction made nobody look again.

     WHAT IS ACTUALLY THERE. In `editPackslips` (fn ~line 245), inside
     `if (DOs && DOs.length)` at ~325:

       for (let i = 0; i < DOs.length; i++) {
         const formulation = await Formulations.find({id: DOs[i].formula_id});
         updatedInventory = formulation.inventory - elem.qty_shipped;
         await Formulations.update({...}).set({inventory: updatedInventory});
       }
       const createPackingSlipDOs = await PackingSlipDOs.createEach(DOs)...

     ⚠ `elem` IS OUT OF SCOPE. It belonged to a `ps.forEach(elem => ...)`
     callback that closed ~15 lines earlier. An undeclared identifier
     throws ReferenceError, so the loop dies on iteration one — and
     `createPackingSlipDOs`, which sits AFTER it in the same branch,
     never runs. Editing a packing slip to ADD a dispatch order cannot
     succeed.

     ⚠⚠ THE THROW IS THE ONLY THING PREVENTING THREE WORSE BUGS:
       1. `Formulations.find()` returns an ARRAY. `formulation.inventory`
          is undefined. `undefined - n` is NaN. This would WRITE NaN
          into the inventory column.
       2. `elem.qty_shipped` does not vary with `i`. Every DO in the loop
          would subtract the same figure.
       3. It writes `formulations.inventory` — the old Kg line — for
          stock that ALREADY left SOH at DO CREATION (§2 Core #2). A
          second subtraction on a bucket that already moved.
     ⚠ SO A ONE-LINE "FIX" OF THE SCOPE CONVERTS A LOUD FAILURE INTO
     SILENT INVENTORY CORRUPTION ON A LIVE CLIENT. → P35.

     ⚠ WHY IT SURVIVED: the normal flow creates a packing slip WITH its
     DOs in one go, through a different function (the `req.body.DOs`
     parse at line 97). Adding a DO to an EXISTING slip is an unusual
     action, so the branch is rarely entered. ⚠ WHETHER THE EDIT SCREEN
     EVER SENDS A NON-EMPTY DOs ARRAY IS STILL UNVERIFIED — one grep of
     the frontend settles "does break" vs "would break if used". Open
     in P35; do not assume either way.

     ⚠ THE TRANSFERABLE LESSON: "dead code, do not touch" is a claim
     about REACHABILITY, and reachability is checkable. This entry was
     believed for sessions because the instruction it carried happened
     to be correct. A right answer for a wrong reason still hides the
     truth. (Same family as J83 and J84: a result that could not have
     revealed the problem, read as though it had.)

     ALSO CLOSED THIS PASS (§2 to-verify): item 4 — the packing proc
     DOES return whd_flag + pack_level, Logic F is safe. Item 3 — the
     start-production write is MLOManagement.js:154.
     ⚠ STILL OPEN: item 1 (nestedPop populate arrays in Formulations.js
     at 609, 632, 1063 — the S55 two-collection rule was not inspected).

     STATUS: §2 items 3, 4, 5 rewritten. P35 raised. Item 1 still open.
========
──────────────────────────────────────────────────────────────────────
J86  P35 IS UNREACHABLE — "WOULD BREAK", NOT "DOES BREAK". AND THE
     REDESIGN IS WHAT MAKES IT REACHABLE. (S80, dev, read-only.)

     J85 left one question open: does the edit-packing-slip screen
     ever send a non-empty `req.body.DOs`? ⚠ SETTLED BY READING THE
     WHOLE FILE, not a grep — the answer is NO.

     THE CHAIN, edit-packslips.component.ts:
       save():506   dispatchData = packForm.get('shipmentList').value.map(...)
       save():541   formData.append('DOs', JSON.stringify(dispatchData))
       → req.body.DOs comes ONLY from shipmentList.
       shipmentList is populated ONLY by addItem() (line 348).
       addItem()'s ONLY caller is in the template at
       edit-packslips.component.html:198-200 — ⚠ AND IT IS
       COMMENTED OUT. The "Add Dispatch order +" button does not
       exist on the rendered page.
       doList() (462) would fill a shipment row, but its trigger
       `(click)="doList(i)"` at html:124 sits INSIDE the
       shipmentList *ngFor — reachable only from a row that can
       never be created.

     SO on every real save, shipmentList is [], dispatchData is [],
     DOs posts as "[]", and `if (DOs && DOs.length)` is false. The
     throwing block is never entered. Severity drops: it is NOT a
     live client bug.

     ⚠⚠ THE FINDING THAT MATTERS. P7 wants add-a-DO-to-an-existing-
     slip BACK — Minty's S80 design has the operator saving a slip,
     staying on it, and moving more DOs in. THAT IS EXACTLY THE
     COMMENTED-OUT MECHANISM. Restoring it re-enables the branch,
     and J85's three bugs (Formulations.find() returns an ARRAY so
     .inventory is undefined → NaN write · the loop subtracts the
     same qty_shipped for every DO regardless of `i` · it writes
     formulations.inventory, the old Kg line, for stock that ALREADY
     left SOH at DO CREATION per §2 Core #2) wake up with it.

     ⚠ THEREFORE THE SEQUENCING ANSWER IS "SAME LINES, NOT JUST SAME
     FILE." The S80 opener asked exactly this. Bundle the defect fix
     with the redesign. Fixing it separately means writing a correct
     backend for a frontend path that is still commented out —
     untestable end to end, and a regression pair (rule 5.2) that
     cannot be exercised.

     ALSO NOTED, same read:
     · The "Ship" button (html:312) calls save() — shipping IS
       saving the packing slip. 3A.5 row 10's "sets the flag only"
       is true TODAY ONLY BECAUSE DOs is always empty. The same
       button would carry DO writes if the feature returned.
     · removeoldItem() (596) already pushes a DO into `deletedDOs`,
       and save() (518) posts it as `deletedDos`. So a
       remove-ONE-DO frontend mechanism EXISTS — but its backend
       branch sits in the same defective function and was NOT read.
       ⚠ Whether it returns the quantity to the DO the way
       deletePs() does is UNKNOWN. Read before relying on it.

     STATUS: P35 reachability closed. Sequencing decided. The fix
     itself is still to do, inside P7.
========


J87  THE PACKING-SLIP SELECTION LOGIC ALREADY EXISTS — P7 IS AN
     EXTENSION, NOT A BUILD. (S80, dev, read-only.)

     Minty's S80 design (recorded in full in Section 1, P7) turned
     out to be most of the way built already. Read
     PopUps/do-list/do-list.component.{ts,html} (184 + 63 lines)
     and create-packslips.component.ts (371 lines) whole.

     WHAT ALREADY EXISTS — ⚠ DO NOT REBUILD:
       · ADDRESS FILTER. do-list.component.ts:69 — picking a DO
         filters the list to that DO's customer_shipping_address.
         Same logic again at :120 and :139. This IS Minty's
         "the list filters down after the first pick".
       · ALREADY-USED DOs SPLICED OUT. :125-131 and :144-150 remove
         DOs already on the slip, so one cannot be added twice.
       · SEARCH IS LOT-CODE ONLY. filterPredicate at :75 and
         :155-159 matches ONLY on
         DO_recProduct_id[0].recProduct_id[0].mlc_id.lotCode.
         ⚠ THE SEARCH BOX IS ALREADY A LOT-CODE BOX. A scanner
         typing into it (html:5, id="do-list-search") already
         narrows the list to that lot. The scan half is close.
       · MULTI-SELECT. getSelectedDo (:57) toggles `selected` and
         rebuilds selectedItem; save() closes with the whole array.
       · MULTI-DO ON THE SHEET. create-packslips doList afterClosed
         (:225) loops the returned array and pushes one form row per
         DO. So "move several DOs at once" ALREADY WORKS on create.
       · THE POPUP IS ALREADY THE ENTRY. create-packslips ngOnInit
         :81 opens it immediately; you never see an empty sheet.
         And afterClosed :215 navigates BACK if nothing was picked.
       · RE-OPEN ON EMPTY. removeItem :156 re-opens the popup when
         the last row is removed.

     WHAT IS MISSING — ⚠ THIS IS THE ACTUAL WORK:
       1. LOT IS NOT IN THE FILTER. The filter groups by address
          only. So today, picking one DO shows every DO for that
          address ACROSS ALL LOTS — the exact confusion Minty's lot
          rule exists to prevent.
       2. CUSTOMER IS NOT IN THE FILTER. ⚠ LATENT BUG: two
          different customers can share a shipping address (a
          shared 3PL or distribution centre). Nothing checks
          customer_id. Minty's rule is customer AND address; the
          code is address only.
       3. NO AUTO-SELECT. Picking a DO FILTERS the list but does
          not TICK its siblings. Every one is still ticked by hand.
       4. NO LOT→DO ENTRY POINT. Nothing starts from a lot code, so
          there is nowhere for the scan (or the ambiguity popup) to
          attach.

     ⚠ A BUG IN getSelectedDo THAT WILL BITE THE AUTO-SELECT:
     line 58 clears selectedItem and rebuilds it from getDoList —
     but getDoList was already narrowed by a previous filter, so
     ticks on rows since filtered out are silently dropped.
     Harmless today with one-at-a-time manual ticking. NOT harmless
     once selection becomes programmatic. Fix it in the same pass.

     ⚠ ARCHITECTURE NOTE FOR THE BUILD: the shared function must
     take a LOT CODE, not a row. The click handler pulls the lot off
     the row it was given; the scan handler passes the scanned
     string straight in. Two thin callers, one function — that is
     what makes scan and click provably identical instead of
     accidentally similar. (Minty's own point, S80.)

     ⚠ ALSO FOUND: PopUps/add-dispatch (v1) IS DEAD CODE. Declared
     in edit-sales-order.module.ts:20 but never opened; the only
     matDialog.open is AddDispatchV2Component
     (edit-sales-order.component.ts:191), and module line 35 shows
     v1 already commented out of a second list. A dead component
     sitting beside a live one is a JT9 trap. → P36.

     STATUS: design captured in P7, code addresses recorded here.
     Ready to build once MO-Release Global Select has been read (P6).
========


J88  qty_shipped IS UNITS AND IS CLEAN — BUT THE ROUTE IS AN
     ACROBATIC, AND FRACTIONAL UNITS MAKE IT WRONG IN PRINCIPLE.
     ⚠ ALSO: A CONFIDENT CLAUDE CLAIM DISPROVEN BY ONE QUERY.
     (S80, dev DB read.)

     THE WORRY: create-packslips.component.ts:246 builds the units
     figure as
       (qty_to_ship / batch_qty) * (batch_qty / wgt_kgs_per_unit)
     — algebraically just qty_to_ship ÷ wgt. That is R2 (Kg→units),
     Minty's "acrobatics", and the disguised form J83 warns about.
     save():293 then splits that display string and posts it as
     shipped_qty, which createPS (PackingSlips.js) ADDS to
     dispatchorders.qty_shipped — a column documented as UNITS.
     ⚠ Meanwhile response.packing_units — the STORED units figure —
     is sitting on the same object, used at :247 and otherwise
     ignored.

     ⚠ CLAUDE PREDICTED VISIBLE FLOAT GARBAGE AT 1.39 Kg/unit
     (58.38 ÷ 1.39 = 41.99999…). THE DATA SAID NO.

     THE QUERY (dev, company 464, dispatchorders joined to
     formulations + fopackaging): on every row where a packing slip
     exists, qty_shipped == packing_units EXACTLY.
       DO-0010   1.39 Kg  → shipped 1, units 1  @1.39 ✓
       DO-0007   9.73 Kg  → shipped 7, units 7  @1.39 ✓
       DO-0002   100 Kg   → shipped 5, units 5  @20   ✓
     No 41.99999 anywhere. The Math.round at :246 lands the division
     on the same integer the stored column already held.
     ⚠ THE FIXTURE WAS CHOSEN TO EXPOSE THIS (1.39 Kg/unit, not
     1:1, per JT21) AND IT STILL CAME BACK CLEAN. The claim was
     wrong. Recorded because a confident wrong answer that goes
     unrecorded becomes next session's foundation (0.1a).

     ⚠⚠ BUT THE ROUTE IS STILL WRONG, AND FOR A BETTER REASON THAN
     FRAGILITY. MINTY CONFIRMED S80: FRACTIONAL SHIPPING UNITS ARE
     PERMITTED BY DESIGN. Evidence in the same query — DO-0008 and
     DO-0009 both carry packing_units = 0.5 (10 Kg of a 20 Kg/unit
     product). That is CORRECT, not a defect. ⚠ DO NOT add an
     integer guard at DO entry.
     → THEREFORE Math.round at :246 is WRONG IN PRINCIPLE, not
     merely fragile: a 0.5-unit DO would round to 0 or 1 on the
     packing slip and SILENTLY SHIP A DIFFERENT QUANTITY THAN THE
     DO AUTHORISES. It has not bitten only because no fractional DO
     has yet reached a packing slip (both 0.5 rows show
     qty_shipped 0). ⚠ SAME SHAPE AS J74: safe by accident of the
     data, not by code.

     ⚠ THE TWO SCREENS DISAGREE ON WHAT shipped_qty MEANS:
       create-packslips:293  posts the divided-then-rounded UNIT count
       edit-packslips:507    posts shipping_order_units × wt_per_unit
                             — which is Kg, not units
     Same field name, same column, two different quantities
     depending on which screen wrote it. ⚠ The edit path is
     currently unreachable for DOs (J86), so only the create value
     has ever been stored — which is why the column is clean today.
     Both must be settled together in P7.

     ▶ THE FIX IS ONE CHANGE AND IT SOLVES ALL OF IT: read the
     stored packing_units instead of rounding a division. Removes
     the acrobatic, handles fractions correctly, and makes the two
     screens agree.

     ✓ ALSO CONFIRMED THIS PASS — createPS (PackingSlips.js) writes
     dispatchorders.qty_shipped and soproducts.quanity_shipped_to_date
     and does NOT touch formulations.inventory or inventory_units.
     Stock does not move at PS creation. Minty's stated rule, §2
     Core #2 and 3A.5 row 9 all agree, now verified in code.
     qty_shipped accumulates (existing + incoming), so a DO can
     legitimately receive quantity more than once.

     STATUS: column verified clean. The route is a P2 site living
     inside the P7 files → fix inside P7. Fractional-units rule
     locked into Section 1 carry-forward.
========
J89  MO-RELEASE GLOBAL SELECT READ AT LAST — IT IS A SELECT-ALL,
     NOT A SELECT-MATCHING. P6's precondition is met.
     (S81, dev, read-only.)

     P6 has said "read the MO-Release Global Select mechanism BEFORE
     designing" since S67 and it was never done. Read this session.

     WHERE IT LIVES (the path is five levels deep; two wrong guesses
     were made before finding it — record it so nobody guesses again):
       src/app/Layouts/admin-dashboard/warehouse/mfg-lot-codes/
       release-mat/release-mat-details/
         release-mat-details.component.ts    1243 lines
         release-mat-details.component.html   265 lines
       Backend: MaterialsProductsReleased.js:150
                createReleaseMaterialProductsV2   (V2 is live — JT9)

     WHAT IT ACTUALLY IS:
       html:35-40   ONE "Select All" mat-checkbox bound to selectAll,
                    firing setAllSelect()
       ts:176-192   setAllSelect() — three near-identical blocks at
                    178, 185, 192, one per list (materials, formulas,
                    packaging), each doing
                      x.isDirectQty = !!this.selectAll
       html:44/114/179  per-row checkboxes, each calling
                    fill{Material,Formula,Pack}ItemFromList behind a
                    guard:  (released_qty < final_qty) && fill...
                    i.e. an already-released row is not re-filled
       ts:146       selectAll = false on list reload
       ⚠ THE FLAG IS `isDirectQty`, NOT `selected`.

     ⚠⚠ THE FINDING THAT MATTERS: IT HAS NO PREDICATE. It ticks every
     row in all three lists unconditionally and relies on the per-row
     guard to skip ineligible ones. P7's rule is CONDITIONAL
     (lot+customer+address). So what transfers is the SHAPE — one
     control, a flag on each row, a fill-handler per list, a guard
     that skips ineligible rows — and NOT the matching logic, which
     does not exist here and had to be written from scratch (J90).
     ⚠ P6 should expect the same: the pattern to reuse is structural,
     not behavioural.

     ⚠ ALSO FOUND — DEAD CODE IN THE SAME FILE. A previous per-row
     lot-picker ("Add +" button + a mat-select of available lots) is
     COMMENTED OUT in the template at html:94-111, 160-176, 223-240 —
     but `selectOption` is STILL BEING WRITTEN in the .ts at 691-700,
     810-818, 1066-1091, with a further commented block at 1104-1143.
     Live writes feeding a dead template. Same JT9/JT22 decoy shape as
     the add-dispatch v1 component (P36), and it sits in the exact
     file P6 will redesign. → P38.

     STATUS: P6's read-first precondition CLOSED. P38 raised.
========


J90  P7 SLICE 2 — THE SELECTION RULE BUILT, AND J87 CORRECTED.
     (S81, dev, commit 0f4c0344, deployed and verified.)

     THE RULE (Minty, S80): picking one DO auto-selects every other DO
     matching ALL THREE — lot + customer + address. Lot is a HARD
     BOUNDARY because identical-looking boxes cannot be told apart by
     eye in the warehouse.

     ⚠ J87 WAS WRONG ON ONE POINT AND IT IS WORTH CORRECTING, because
     a wrong reason stops anyone looking again (JT22). J87 recorded "a
     bug in getSelectedDo that will bite the auto-select: line 58
     clears selectedItem and rebuilds it from getDoList — but
     getDoList was already narrowed by a previous filter, so ticks on
     rows since filtered out are silently dropped."
     READING THE FILE: getDoList is NEVER narrowed. Only `dataSource`
     is rebuilt from a filtered copy. So ticks were not being dropped
     that way.
     ⚠ THE REAL DEFECT WAS DIFFERENT AND WAS FIXED: the filter keyed
     off `material` — the row just clicked — even when that row had
     just been UNTICKED. The visible list could therefore be keyed to
     a DO that was no longer selected. Now the filter anchors on
     selectedItem[0], a DO that is actually selected.

     WHAT WAS BUILT — three helpers, defined ONCE so the click path,
     the auto-select and the list filter cannot drift apart:
       doLotCode(item)    lot code, optional-chained at every hop
       doMatchKey(item)   lot || customer || address   (SELECTION)
       doFilterKey(item)  customer || address          (LIST FILTER)
     doFilterKey deliberately excludes lot: after the first pick the
     operator still works down the remaining lots for that customer
     and address. The lot boundary is enforced at SELECTION, not at
     display.
     ⚠ doLotCode IS THE HOOK FOR THE SCAN. A scanner is a keyboard; it
     types into the search box, which already filters on lot code.
     Scan and click become two thin callers of one function.

     ALSO FIXED: getAllDOs grouped by ADDRESS ALONE in BOTH branches
     (addPS and else — near-duplicate blocks). Two different customers
     can share a shipping address (a 3PL or distribution centre) and
     nothing checked customer. Both branches now use doFilterKey.

     VERIFIED LIVE (dev, after Cmd+Q — lazy chunks survive everything
     less, J66): ticking DO-0004 auto-ticked DO-0005 AND DO-0006. All
     three share lot Pdt-260701-1, customer testcustomer260703,
     address 10518 — ⚠ note DO-0006 is a DIFFERENT SO (SO-0006 vs
     SO-0002) and still matched, which is CORRECT: the rule is
     lot+customer+address, not SO. DO-0008 stayed unticked (same
     customer, same address, lot Pdt-260704-1). List went 6 rows → 4.

     ⚠ THE CUSTOMER HALF IS UNPROVEN — SEE J93. Do not record this
     entry as proving the customer key.

     STATUS: slice 2 shipped to dev. J87's tick-dropping claim struck.
========


J91  soproducts MIXES UNITS AND Kg ON ONE ROW — A P2 SITE NOBODY HAD
     LOGGED. (S81, dev DB read.)

     Observed while verifying the packing-slip cycle on SO-0011:
       soproducts.quantity                 = 13.9    (Kg)
       soproducts.quanity_shipped_to_date  = 1       (UNITS)
     Same row. createPS adds a UNIT count to quanity_shipped_to_date
     while the sibling quantity column is Kg.

     ⚠ SAME SHAPE AS JT4 (the DO row: qty_to_ship Kg next to
     qty_shipped and packing_units in units). Known fossil family, but
     this instance was not in the P2 inventory and nobody has checked
     WHERE quanity_shipped_to_date IS READ. If any screen renders it
     against quantity without converting, that display is wrong.

     ⚠ NOTE THE SPELLING: `quanity_shipped_to_date`, not `quantity_`.
     A grep for the correct spelling finds nothing.

     ▶ ACTION: fold into the P2 inventory — find every read of
     quanity_shipped_to_date before deciding anything.
     BLAST RADIUS: unknown until the reads are found. No data is
     wrong today; the risk is a display or a future calc that treats
     the two columns as the same unit.
========


J92  REMOVE-ONE-DO FROM A PACKING SLIP IS NOT MERELY BROKEN — IT IS
     UNREACHABLE, BECAUSE THE SCREEN HAS NO SAVE BUTTON.
     ⚠ AND THE ONLY COMMIT PATH SHIPS THE SLIP.
     (S81, dev, read + live walk.)

     J86 established that ADD-a-DO is unreachable (its button is
     commented out). REMOVE-a-DO was assumed reachable because
     removeoldItem() exists and is wired to a visible Remove button.
     ⚠ WALKED LIVE S81: the Remove button DOES drop the row from the
     screen — and nothing else. Navigating away and back restores it.
     The DO was still on the slip in the DB.

     WHY: removeoldItem() (edit-packslips.component.ts:596) pushes the
     DO into `deletedDOs`; save() (:518) posts it as `deletedDos`.
     But /Edit-Packslips offers only SHIP and CANCEL — THERE IS NO
     SAVE BUTTON. Ship calls save(), and save() builds PSOBJ with
     `shipped_flag: true` unconditionally.
     ⚠ SO THE ONLY WAY TO COMMIT A REMOVAL IS TO SHIP THE SLIP, and
     shipping is TERMINAL with no un-ship (J16). Removing one DO is
     therefore not a usable operation today.

     ⚠ THE TRAP FOR A FUTURE SESSION: the Remove button LOOKS like it
     works. The row disappears. Only the DB shows it did nothing
     (JT12). This is why the S81 test appeared to "not work" and was
     nearly recorded as a code failure rather than a missing commit
     path.

     MINTY'S DECISION (S81), now the rule: A DO COMING OFF A PACKING
     SLIP ALWAYS RETURNS ITS QUANTITY AND BECOMES AVAILABLE AGAIN —
     whether one DO or all of them. Remove-one is the SAME operation
     as cancel-whole-slip on a smaller selection, not a different
     operation. One function, cancel = "select all then remove".
     ⚠ Neither path touches inventory_units: stock left SOH at DO
     CREATION (§2 Core #2). "Available again" means available TO A
     PACKING SLIP, not returned to store.

     CANCEL-WHOLE-SLIP IS CORRECT AND IS THE REFERENCE IMPLEMENTATION.
     inActivatePS (PackingSlips.js ~217): status_id 1→2, destroys the
     PackingSlipDOs rows, and per DO subtracts data.shipped_qty from
     dispatchorders.qty_shipped and from
     soproducts.quanity_shipped_to_date. No division, no
     wgt_kgs_per_unit — R1, clean. VERIFIED LIVE S81 on PS-0006:
     qty_shipped 1→0, PSDO row gone, DO-0011 back in the selectable
     list, FO-0004 inventory_units UNCHANGED at 41.

     ⚠ THE PAYLOAD DOES NOT CARRY THE QUANTITY — THE FIX MUST NOT
     TRUST IT. deletedDos items carry only {company_id, DO_id, PS_id}
     (edit-packslips.component.ts:517-523). Mirroring inActivatePS's
     `getDO.qty_shipped - data.shipped_qty` would compute
     `number - undefined` = NaN and write it — reintroducing exactly
     the J85 bug inside its own fix. Checked before writing, per 2.2.
     ▶ THE CORRECT SOURCE IS THE STORED JOIN ROW:
     PackingSlipDOs.shipped_qty is a DECLARED number attribute
     (verified S81), so the backend can read what was actually
     recorded rather than what a screen posts. This also sidesteps the
     J88 disagreement about whether shipped_qty means units or Kg.

     ⚠ ALSO CONFIRMED: the old deletedDos branch passed three PARALLEL
     ARRAYS as criteria — {company_id: [x,x], DO_id: [a,b],
     PS_id: [p,p]} — which Waterline reads as IN clauses that
     cross-multiply rather than pairing. With two DOs removed it could
     match more rows than intended. Fixed by working one DO at a time.

     FIXED IN S81 SLICE 1 (backend, commit ff5d183, dev only). ⚠ STILL
     UNTESTED — unreachable until slice 4 adds a commit path that does
     not ship. → P40 (the defect), P41 (the rule into §2 Core #2).
========


J93  SLICE 2'S CUSTOMER KEY IS UNPROVEN — AND NO DEV FIXTURE CAN
     PROVE IT. ⚠ A PASSING TEST THAT COULD NOT HAVE REVEALED THE
     PROBLEM. (S81.)

     Slice 2's doMatchKey and doFilterKey read the customer as
     `SO_id.customer_id?.id ?? SO_id.customer_id ?? ''` — handling both
     the populated-object and bare-number shapes (JT1).

     ⚠ `customer_id` WAS NEVER OBSERVED IN THE POPUP'S PAYLOAD. The
     component only ever read `SO_id.customer_shipping_address`. If the
     DO payload does not include customer_id, the customer half of both
     keys silently becomes '' for every row and the logic degrades to
     ADDRESS-ONLY — the previous behaviour. No error, no crash, no
     visible difference.

     ⚠ AND THE S81 TEST COULD NOT DISTINGUISH THE TWO CASES. Every DO
     in company 464 is either the same customer or at a different
     address, so address-alone produces an identical result. The test
     passed. It proved the LOT boundary and the auto-select. It proved
     NOTHING about customer.

     ⚠ SAME FAMILY AS JT21 (the 1:1 fixture) AND J84 (the mirror check
     that never looked at the host): a result that could not have
     revealed the problem, read as though it had. Recorded so a future
     session does not cite J90 as evidence the customer key works.

     ▶ TO PROVE IT, ONE OF:
       (a) build a dev fixture with TWO DIFFERENT CUSTOMERS sharing
           ONE shipping address, then confirm ticking one does not
           select the other's DOs; or
       (b) console.log a DO object from the popup and confirm
           SO_id.customer_id is present and populated.
     (b) is minutes and settles it. Do (b) first.

     ⚠ IF customer_id IS ABSENT: the fix is a backend change — the
     DO list read must populate it — not a frontend workaround.
     BLAST RADIUS: none today. The degraded case is exactly the old
     behaviour, which shipped for years.
========
END SECTION J
────────────────────────────────────────────────────────────
---

## S82 — J94 · J95 · J96 · J97 · J98

---

**J94 — SLICE 3: THE PACKING-SLIP UNITS FIX. FIVE SITES. VERIFIED IN THE DB.**
STATUS: CLOSED. Commit 897096b4 (frontend, dev only).

```
THE BUG      Five sites rebuilt a unit count by DIVIDING Kg by the
             per-unit weight, wrapped in Math.round. R2 acrobatics
             (§2 Core #1). Math.round made it LOOK correct only
             because no fractional DO had ever reached a slip.

THE SITES    create-packslips.component.ts  :246  display string
             edit-packslips.component.ts    :248  Math.round(shipped_qty / wgt)
             edit-packslips.component.ts    :270  display string
             edit-packslips.component.ts    :325  display string
             edit-packslips.component.ts    :486  display string
             ⚠ FOUR OF THE FIVE were the DISGUISED form:
               (qty / batch) * (batch / wgt), algebraically the
               same divide (J83).

THE FIX      Read the STORED packing_units. It was already on the
             same object in every case - at :247 the create screen
             was literally reading it on the NEXT LINE.

THE PROOF    DO-0008: qty_to_ship 10 Kg, packing_units 0.5, so
             wgt = 20 Kg per unit. 10 / 20 = 0.5, and JavaScript
             rounds 0.5 UP, so the old code shipped 1 unit against
             a DO authorising 0.5.
             After the fix, PS-0008 / DO-0008 reads:
               shipped_qty    0.5
               qty_shipped    0.5
               packing_units  0.5
             All three agree. Verified by SQL, not by the screen
             (rule 5.1, JT12).

⚠ A SECOND BUG WAS FOUND IN THE SAME LINE AND NOT FIXED. The create
  screen's save() builds shipped_qty by SPLITTING the display string
  on a space and taking index [0]. The validators at :268 split the
  SAME string on index [3] - the Kg number - and apply it as BOTH
  min and max to a UNITS field. A string-split is load-bearing in
  three places. Fixing the display made index [0] correct; the
  validator remains wrong. Logged, not fixed - it needs its own test.
```

---

**J95 — THE TWO PACKING-SLIP SCREENS DISAGREED ABOUT WHAT shipped_qty MEANS. RESOLVED.**
STATUS: CLOSED on the code. ⚠ UNTESTED.

```
THE FINDING  create-packslips posts shipped_qty as a UNIT COUNT.
             edit-packslips posted it as shipping_order_units *
             wt_per_unit - which is KILOGRAMS.
             Both write the SAME column, PackingSlipDOs.shipped_qty,
             and createPS then ADDS that value to
             DispatchOrders.qty_shipped, which §2 GR7 says is UNITS.
             So the edit screen was adding Kg into a units column.
             (First noted J88; S82 confirmed it in the code.)

⚠ WHY IT NEVER BIT      The edit screen's write path is reached only
             via "Add Dispatch order +", and that button had been
             COMMENTED OUT (J86). Every row in packingslipdos was
             written by createPS. The mixing was LATENT, not banked.
             ⚠ Ten rows checked on dev: all small whole numbers,
               1 to 12. No Kg-scale values present.
             ⚠ THAT IS INFERRED FROM THE CODE PATH, NOT PROVEN BY
               THE NUMBERS - 1 and 5 are plausible as either. If it
               ever matters, compare a row against its DO's
               packing_units.

⚠ THE TIMING TRAP       Re-enabling the button (slice 4a) is what
             would have introduced Kg into the column for the first
             time. The button fix and the units fix HAD to land in
             the same commit. They did (db415d74).

THE FIX      shipped_qty = data.shipping_order_units. No multiply.

⚠ A GUARD DIED WITH IT. The old code tried to cap shipped_qty at
  the ordered quantity:
      if (shipped_qty > data.shipment_product_order_qty)
  but shipment_product_order_qty is a DISPLAY STRING - "10 Kg
  ( 0.5 # )". A number is never > a string in any useful sense, so
  the cap NEVER FIRED in its entire life. Removing it changed
  nothing in practice, but there is now NO over-ship guard on this
  screen at all. → P45.
```

---

**J96 — SAVE AND SHIP WERE THE SAME ACTION. SPLIT.**
STATUS: CLOSED on the code. ⚠ UNTESTED.

```
THE PROBLEM  editPackslips built its update object with
             shipped_flag: true HARDCODED. There was no other path
             into it. So the ONLY way to post a DO addition or a DO
             removal was to SHIP the slip - terminally, with no
             un-ship (§2 Core #2).
             That is why remove-one-DO was UNUSABLE rather than
             merely broken (J92, P40): the frontend had a Remove
             button that filled deletedDOs, and no button that could
             post it without shipping.

THE FIX      backend  2d22e5a
               const isShipping = req.body.ship === true ||
                                  req.body.ship === 'true';
               PSOBJ carries vehicle_no and remarks always;
               shippingdate, shipped_flag and finalShipmentUserId
               ONLY when shipping.
               ⚠ AN UNSHIPPED SLIP HAS NO SHIPPING DATE. Stamping
                 one on a plain save would have been a quiet lie in
                 the record.

             frontend db415d74
               save()  -> submitSlip(false)
               ship()  -> submitSlip(true)
               Both post the same payload; only ship sends the flag.
               ⚠ sendMail now fires ONLY on Ship. Previously every
                 edit could email the customer. Deliberate.
               ⚠ Save STAYS on the slip; Ship navigates back.

⚠ ORDERING HAZARD, worth remembering. Between the backend deploy and
  the frontend deploy, the SHIP button no longer shipped - it just
  saved, because nothing was sending the flag yet. Harmless on dev
  for a few minutes; on prod it would be a live defect. Deploy both
  halves together or backend-last.
```

---

**J97 — THE PACKING-SLIP FLOW, SETTLED BY MINTY. S82.**
STATUS: DOMAIN RULE. Belongs in §2 → P41.

```
THE SEQUENCE
  1  MOVE       From the DO sheet, pick DOs. The WHOLE ROW moves
                onto the slip.
  2  SAVE       Banks whatever has been moved. REPEATABLE - move
                more, save again. Each save just holds what is there.
  3  DETAILS    Shipping Reference and Vehicle condition are entered
                AFTER the DOs are settled, not before.
  4  SHIP       Greyed until both details are filled. Terminal.
  5  CANCEL     Available from the first save until Ship. Reverses
                everything. NEVER available after Ship.

⚠ THIS INVERTS THE ORIGINAL DESIGN. The app was built to demand
  Shipping Reference and Vehicle condition BEFORE the first save -
  they were `required` on the create form and the Save button was
  [disabled] until they were filled. That is why an early S82 test
  "did nothing": the button was disabled, not silently failing.

⚠ THE DATE PICKER IS ESSENTIAL AND ALREADY CORRECT (Minty, S82).
  Before ship: an editable date picker defaulting to today, so a
  shipment missed yesterday can be dated yesterday. After ship: a
  readonly field showing the shipped date. It sits in the header,
  above the DO rows. MUST SURVIVE the 4b row rebuild - verify after,
  do not assume.

⚠ WHAT S82 BUILT vs WHAT MINTY DESCRIBED - the gap, stated honestly.
  S82 made the shipping fields ALWAYS VISIBLE and always editable,
  with Ship greyed until they are filled. Minty asked for a DISTINCT
  STEP - a "Ready to Ship" moment that reveals them. Those are not
  the same thing: the built version has no moment where the app says
  "you are done adding, now enter the details".
  ⚠ MINTY'S CALL: do the row template FIRST, then the sequencing
    change as its own piece, with a REAL COLUMN behind "Ready to
    Ship". A visual-only toggle forgets itself on reload. → P7 4c.

⚠ SHIPPING REFERENCE MAY BE MULTIPLE INVOICES, and those invoices
  will likely need to match QuickBooks records - all Minty's clients
  run it. That rules out delimited text in the existing single
  column and points at a child table. Deferred by Minty: "if it is a
  larger task, we can do it later". → P43.
```

---

**J98 — A BLANK FORM FIELD ARRIVES AS THE STRING 'null'. TWO ATTEMPTS TO FIX. READ BOTH.**
STATUS: CLOSED. Commits df6d728 (incomplete) then 083fc96 (correct).

```
THE SYMPTOM  After slice 4a dropped `required` from the create
             screen's two shipping fields, saving a slip with them
             blank returned 500 Internal Server Error.
             ⚠ Filling them in still worked - which is exactly the
               shape that makes a defect look like "user error".

THE CAUSE    FormData STRINGIFIES EVERYTHING. The frontend appends
             the JavaScript value null; what reaches the backend is
             the four-letter STRING 'null'.
             vehicle_condition is a model association. Waterline saw
             a string where it wanted a row id and rejected the
             WHOLE record.

⚠ ATTEMPT ONE WAS WRONG AND IS THE MORE USEFUL HALF OF THIS ENTRY.
  The first patch coerced BOTH fields to null. That is correct for
  vehicle_condition (an association) and WRONG for vehicle_no, which
  is declared type: 'string'. Waterline refuses an EXPLICIT null on
  a string attribute even when the attribute is optional. The second
  500 said so verbatim:
      "Even though this attribute is optional, it still does not
       allow `null` to be explicitly set ... please set the value
       for this attribute to the base value for its type, `''`."
  So the fix HAD ALREADY BEEN TOLD TO US by the first error message
  and was still got wrong.

THE RULE     association  -> coerce blank to NULL
             string       -> coerce blank to '' (empty string)
             ⚠ They are not interchangeable. Waterline rejects the
               wrong one loudly on associations and would have
               stored the literal word 'null' on the string.

⚠ AN ANCHOR GUARD EARNED ITS KEEP. The first patch anchored on the
  bare line `vehicle_no: req.body.vehicle_no,` - which appears TWICE
  (createPS :68 and editPackslips :298). The script reported
  "found 2" and REFUSED TO WRITE. Without the exactly-once assertion
  it would have patched both sites with text intended for one, or
  patched the wrong one silently. Rule 4.2 works.

⚠ SAME FAMILY AS P10. The literal string "null" showing in Product
  External Code has this exact shape. S82 found the mechanism;
  P10 is still open.

⚠ AND IT EXPOSED P44. While patching, editPackslips was found to
  write only vehicle_no and remarks - it NEVER writes
  vehicle_condition at all. Pre-existing, not caused by S82, but it
  matters more now that 4a made the dropdown editable AND gated Ship
  on it: an operator can pick a condition, ship, and have it
  silently discarded.
```

---

**JT23 — NEW TRAP. A BLANK FIELD IS NOT AN EMPTY FIELD.**

```
FormData stringifies every value. A blank input does not arrive as
null - it arrives as the four-letter STRING 'null', or 'undefined',
or ''. Any backend that writes such a value straight into Waterline
will either 500 (association) or store the literal word (string).
⚠ GUARD EVERY OPTIONAL FORM FIELD AT THE WRITE, and coerce to the
  RIGHT empty: null for associations, '' for strings.
⚠ THIS ONLY APPEARS WHEN A FIELD STOPS BEING REQUIRED. Making a
  field optional is never a one-line frontend change - it changes
  what the backend receives. (S82, J98. Same family as P10.)
```

---

**J99 — THE POPUP SHOWED "0 of 0" AND IT WAS NOT A BUG. RECORDED SO NOBODY RE-INVESTIGATES.**
STATUS: NO DEFECT. Slice 2 behaves as designed.

```
WHAT WAS SEEN   On Create-Packslips, after moving two DOs onto a slip,
                reopening the DO popup showed an empty table, 0 of 0 -
                while four other DOs were still unallocated.
                It looked like a filter failing to clear between opens.

⚠ BOTH MINTY AND CLAUDE READ IT AS A DEFECT AT FIRST. Claude proposed
  two mechanisms for it. Both were wrong. THE APPEARANCE OF A BUG IS
  NOT A BUG - and the thing that settled it was making a new fixture
  and looking again, not more reasoning. (Rule 0.1a.)

WHAT ACTUALLY HAPPENS, proven with DO-0012 (a Jade 3 / Colombo DO on a
DIFFERENT lot, Pdt-260721-2):
                Ticking DO-0012 filtered the list to THREE rows -
                DO-0010, DO-0011 and DO-0012, all Jade 3 / Colombo -
                and auto-ticked ONLY DO-0012.
                DO-0010 and DO-0011 were LISTED AND UNTICKED because
                they share the address but not the lot.
                Reopening the popup still offered them.

THE TWO KEYS ARE DIFFERENT, AND THAT IS THE DESIGN:
                AUTO-TICK   lot + customer + address
                LIST FILTER customer + address only

WHY THE EARLIER RUN LOOKED EMPTY
                Both Colombo DOs on that lot had already been moved.
                The filter narrowed to Jade 3 / Colombo. Nothing else
                existed at that address at that moment. Zero was
                arithmetically correct.
                ⚠ DO-0012 DID NOT EXIST YET. Creating it is what
                  proved the behaviour.

⚠ SLICE 2's LOT HALF IS NOW PROVEN. J93 recorded that a same-lot DO
  auto-ticks; this proves the converse - a same-address DIFFERENT-LOT
  DO stays visible and unticked. THE CUSTOMER HALF REMAINS UNPROVEN:
  no dev fixture has two different customers sharing one address, so
  address alone would still produce the same result. Evidence gap,
  not a defect. (J93 stands.)
```

---

**J100 — THE DO PICKER ALWAYS RETURNS AN ARRAY. THE EDIT SCREEN NEVER KNEW.**
STATUS: FIXED S84, frontend d223d6ed. Proven in the DB.

```
THE SYMPTOM     Adding a DO to a SAVED packing slip threw
                "TypeError: Cannot read properties of undefined
                (reading 'internalCode')" at edit-packslips ~:481.

THE CAUSE       PopUps/do-list/do-list.component.ts closes with
                `selectedItem`, declared as [] at line 24:
                  addFirstItem()  :50-52  selectedItem = [element]
                  save()          :54-55  selectedItem = [..ticked..]
                BOTH gestures return an ARRAY. Edit's handler read
                response.SO_id.internalCode straight off it.

⚠ THE S83 HANDOVER WAS WRONG ABOUT WHY. It recorded that
  addFirstItem returns an OBJECT and only tick+Save returns an array,
  so only tick+Save was broken. FALSE. Both return arrays; BOTH
  gestures threw. Anyone "verifying" the fix by single-clicking would
  have been testing a path they believed already worked.

⚠ A SECOND, INDEPENDENT PROOF sat in the repo the whole time: the
  CREATE screen does result.forEach(...). Objects have no forEach. If
  single-click returned an object, create would throw on every click.
  Create works. Therefore the return is an array. THE BEHAVIOUR OF
  WORKING CODE IS EVIDENCE ABOUT THE CODE IT SHARES. (Rule 0.1a
  again - it was checkable by looking, not by reasoning.)

THE FIX         Mirror create-packslips (~:227): loop the array,
                patch at (index + i), and push a row via createItem()
                for each DO beyond the first. Edit pre-spawns ONE
                blank row via addItem(), so only the extras need
                pushing. No normalising branch is needed - the shapes
                never differed.

PROVEN          DO-0012 added to a saved slip. Row populated with MO
                number, lot code, best before, order qty. No throw.
                Join row written, quantity correct.

⚠ THE GESTURE IS TWO-STEP AND NON-OBVIOUS, BY DESIGN:
  click "Add Dispatch order +" (spawns the blank row, html:198), THEN
  click into that row's Internal Dispatch Order field (opens the
  picker, html:124). Not a bug. Worth knowing before testing.
```

---

**J101 — THE 500 BEHIND THE DOOR J100 OPENED. A BLANK STRING INTO A NUMERIC COLUMN.**
STATUS: FIXED S84, frontend c3d463c9. Proven in the DB.

```
⚠ THIS DEFECT HAD NEVER RUN BEFORE. Save-after-add on the edit screen
  was unreachable - first the `elem` scope throw (J85/P35), then J100.
  Fixing J100 exposed it. IT IS NOT A REGRESSION; it is the next thing
  that was always broken, now reachable for the first time.

THE SYMPTOM     Save returned 500. The alert showed only the status
                line. The real message was in pm2 logs:
                  "New record contains the wrong type of data for
                   property `shipped_qty`. Specified value (a string:
                   '') doesn't match the expected type: 'number'"

THE CAUSE       edit's doList handler patched
                  shipping_order_units: ''
                and nothing filled it. submitSlip posts
                data.shipping_order_units into a numeric column.
                Sails refused the row.

WHY EXISTING    Rows loaded from the DB already carry a number, so
ROWS WERE FINE  Save always worked on them. Only a freshly-added row
                arrived blank. Same button, two different row states.

THE FIX         Pre-fill from response.packing_units - the DO's own
                stored unit count. shipping_order_qty gets the
                matching Kg string (display only on this screen;
                submitSlip does not post it).

⚠ THE FIX IS THE DOMAIN RULE, NOT A PATCH. Minty, S84: SHIPPED
  QUANTITY IS NOT AN OPERATOR INPUT. It is the DO's quantity carried
  through unchanged. To change what ships, CANCEL the DO and raise a
  fresh one. With nothing typed there is nothing to validate - which
  is why P45's guards can be DELETED rather than repaired.

⚠ THE OLD APP CORROBORATES. Its packing slip row has NO "Shipped
  Units" and NO "Shipped Qty" fields at all - only Order Qty. The
  typed box is a later addition, and it is the source of both the
  dead validators and this 500. (Screens read live, S84.)

PROVEN          PS 2397 wrote three join rows, shipped_qty 1 each,
                for DO-0010 / DO-0011 / DO-0012.

STILL OPEN      Existing rows are built as DISABLED controls
                (edit-packslips.component.ts :274, :329). Angular
                omits disabled controls from form.value, and
                submitSlip reads exactly that. Whether a loaded row's
                quantity reaches the payload at all is UNVERIFIED.
                → carry into the S85 cancel run.
```

---

**J102 — ⚠ D1 IS DISPROVEN. THE CREATE PATH DOES NOT DOUBLE-COUNT. DO NOT RE-DERIVE.**
STATUS: NO DEFECT on create. The S83 finding does not reproduce.

```
⚠ THIS ENTRY EXISTS TO OVERRIDE THE S83 HANDOVER, which recorded the
  create-path double-count as PROVEN and put it second in the S84
  plan. It is not proven. It is not reproducible.

WHAT S83 CLAIMED
                "The DO you CLICK gets its qty_shipped incremented
                TWICE on create. Auto-ticked DOs and separately-ticked
                DOs increment once." Evidence given: DO-0010 went
                1 -> 2 then 2 -> 4.

THE CLEAN EXPERIMENT, S84
                Fixtures reconciled first (see below). Fresh build.
                DO-0004 / 0005 / 0006 all free, all at tally 0, all
                sharing one lot + customer + address.
                  CLICKED      DO-0004
                  AUTO-TICKED  DO-0005, DO-0006
                  UNTOUCHED    DO-0008 (different lot) - correct
                RESULT, read from the DB:
                  DO-0004  shipped_qty 1  tally 1   CORRECT
                  DO-0005  shipped_qty 1  tally 1   CORRECT
                  DO-0006  shipped_qty 1  tally 1   CORRECT
                The CLICKED DO incremented ONCE, identically to the
                auto-ticked ones.

⚠ WHY S83 SAW A DOUBLE-COUNT: ITS EVIDENCE WAS GATHERED ON DIRTY
  FIXTURES. No baseline existed, several cancels had already run, and
  four DO tallies were inflated before testing began. Every quantity
  measured against a wrong starting number lies. S83's own handover
  says it dismissed the same numbers as "fixture residue" earlier in
  that session and then reversed - it was right the first time.

⚠ THE LESSON, AND IT IS THE POINT OF THIS ENTRY:
  A QUANTITY FINDING MEASURED WITHOUT A RECONCILED BASELINE IS NOT A
  FINDING. It cost S83 an afternoon and would have cost S84 another.
  Reconcile first, then measure. (Same family as JT12 - the DB is
  ground truth, but only if you know what it said BEFORE.)

WHERE THE BUG ACTUALLY LIVES — CANCEL, NOT CREATE
                Every DO whose history is create-only reconciles,
                across all five companies.
                The one bad number left is DO-0010 (tally 2, join
                rows 1) and its history includes a CANCEL.
⚠ UNEXPLAINED   DO-0011 went through the SAME cancel on the SAME slip
                and came out CORRECT. Why one and not the other is
                the open question. → S85 STEP 3.
⚠ CANCEL DOES DELETE ITS JOIN ROWS - the packingslipdos id sequence
  has gaps exactly where the cancelled slips were, and none of the
  eight cancelled slips has a surviving row. What cancel does with
  the DO's own qty_shipped is the untrusted half.
⚠ DO-0010 WAS LEFT UNCORRECTED ON PURPOSE. It is the live evidence.
  Read it before resetting it.

⚠ THE FIXTURE RESET THAT MADE THIS MEASURABLE (S84, by id, company
  464, after querying and agreeing each one):
                  DO-0004 (10910)  3 -> 0
                  DO-0005 (10911)  3 -> 0
                  DO-0010 (10924)  4 -> 1
                  DO-0011 (10925)  2 -> 1
                Each set to the sum of its own join rows. The join
                rows were correct in every case - S83 was right about
                that much.
```

---

**J103 — THE SAME QUANTITY STRING IS BUILT TWO WAYS, AND A DISPLAY COMMIT BROKE A VALIDATOR.**
STATUS: FOUND S84, NOT FIXED. → P45 + P49.

```
THE TWO FORMATS, same form control (shipment_product_order_qty):

  CREATE  `${packing_units} # ( ${qty_to_ship} ${unit} )`
          ->  "1 # ( 20.000 Kg )"
  EDIT    `${qty_to_ship} ${unit} ( ${packing_units} # )`
          ->  "20.000 Kg ( 1 # )"

⚠ CREATE READS NUMBERS BACK OUT OF THAT STRING BY POSITION:
  create-packslips.component.ts
    :169  caps qtyShip at  ...split(' ')[0]
    :265  min AND max at   ...split(' ')[3]   <- AN EQUALITY LOCK
    :296  reads            ...split(' ')[0]

⚠ THE EQUALITY LOCK AT :265 IS MINTY'S DOMAIN RULE, WRITTEN IN CODE.
  min and max set to the SAME value = shipped units must equal
  ordered units exactly. Someone built that deliberately, years ago,
  and it matches the rule Minty stated fresh in S84 without knowing
  it was there.

WHAT THE FLIP DID
                       OLD FORMAT       AFTER THE FLIP
  :169  reads [0]      Kg               units      -> improved
  :265  reads [3]      units            Kg         -> BROKEN
  :296  reads [0]      Kg               units      -> improved
  On a 1-unit / 20 Kg DO, :265 now demands the units box equal
  20.000. No valid entry exists.

⚠ THE POINT: A COMMIT THAT TOUCHED DISPLAY CHANGED WHAT A VALIDATOR
  ENFORCES, IN CODE NOBODY OPENED. Not one of those three lines was
  edited. There is no diff to catch it and no test that would fail
  loudly - the field simply stops accepting anything.

⚠ NOT PROVEN: git blame has NOT been run. S82's slice 3 is the
  plausible author (it touched five units sites in create and the old
  format is recorded in P45 as Kg-first), but it is a plausible
  author, not a confirmed one. Do not write it up as fact.

⚠ ALSO CORRECTED S84 — P45 HAD THE TWO SCREENS BACKWARDS. The record
  said EDIT had no over-ship guard and that the string-parsing guard
  had been deleted. Both false:
    EDIT   HAS the guard, and it is the CORRECT kind -
           Validators.max(shipment_order_units), a raw stored number,
           no parsing.  (~:514)
    CREATE is the one still parsing a display string.
  Anyone acting on the old P45 would have built a guard on edit that
  already existed, and left the fragile one untouched on create.

THE FIX IS SMALLER THAN THE PROBLEM
                Under the read-only rule (J101) the field is never
                typed, so the parsing and both validators can be
                DELETED rather than repaired. Do it in slice 4b, and
                make both screens build the string identically.

STILL UNPROVEN  Whether edit applies its guard to rows on LOAD or
                only to rows added via the popup; and whether an
                invalid Angular form actually blocks Save at all. A
                guard that reddens a field but still saves is not a
                guard.
```

---

## S85 — APPENDED 25 JUL 2026

> **NUMBERING CONFIRMED S85.** The highest existing entry was verified as **J103** by grepping the whole file:
> `grep -oE 'J[0-9]+' Section_5.md | grep -oE '[0-9]+' | sort -n | tail -1` → `103`
> These entries therefore run **J104 – J108**. Section 1's cross-references were renumbered to match in the same pass.
>
> **JT NUMBERING ALSO CONFIRMED S85.** A separate grep was needed because `J[0-9]+` does not match `JT23` — the letter T breaks the pattern. `grep -oE 'JT[0-9]+'` returned **23** as the highest existing trap, so these run **JT24 – JT26**.
>
> ⚠ **BEFORE PASTING, GLANCE AT THE EXISTING JT23.** Claude has not read it. If it already covers the same ground as one of the traps below, say so — rule 7.7 warns that two entries stating one thing is how drift starts, and a duplicate trap is worse than no trap because it splits the reader's attention.
>
> ⚠ **ALSO CORRECT THE HEADER.** Section 5's own header still reads "highest is J93 — next is J94" and "Last appended: S81". It is ten entries and four sessions stale. Fix it in this commit.

---

### J104 — SLICE 4b: THE UNIFIED READ-ONLY DO ROW. SHIPPED AND VERIFIED.

**Commit 453f1f44 (frontend). 2 files, +59 −130. Built green, deployed to dev, verified live in the browser.**

`edit-packslips.component.html` carried **TWO** DO row templates, not one:

```
orderNumList   lines 35-116   EXISTING DO rows (already on the slip)
shipmentList   lines 117-197  NEWLY ADDED rows (via the picker)
```

They had drifted apart — Customer, Delivery Address, Shipped Units and Shipped Qty were commented out on the existing-DO row and LIVE on the new-DO row. **4b replaced both with ONE template.**

**THE EIGHT FIELDS (final, Minty S85):** MO Number · Internal DO Number · Customer PO No · Product · Product External Code · Pdt Lot Code · Best Before · Shipped Qty.

Derivation from the S84 ten: Order Qty cut, Shipped Units cut (the unit count already opens the quantity string), leaving eight.

**THE DOMAIN RULE THAT DROVE IT (Minty, S85):** *the DO row is a read-only display of the dispatch order. Nothing on it is typed. To change what is on the slip, remove the DO and add a different one.* This is the S84 shipped-quantity rule widened to the whole row.

**THE UNIFORM QUANTITY STRING (Minty, S85):** `<units># (<Kg> <uom>)` — e.g. `1# (20.000 Kg)`. Units read STORED; Kg DERIVED by multiplying. R1, never R2.

⚠ **THE TRAP THAT WAS AVOIDED, AND IT WOULD HAVE BEEN SILENT.**
The obvious way to make the new row read-only is `disabled: true`, matching the existing-DO row. **That would have broken Save with a 200 and an empty join table.** `submitSlip` (:536) reads `this.packForm.get('shipmentList').value`, and **Angular excludes disabled controls from `.value`** — `do_id` and `shipping_order_units` would both have returned undefined.

⚠ The existing-DO row IS all-disabled and is safe **only because `submitSlip` never reads `orderNumList`.** Safe by accident of which array is read, not by design. (Rule 7.4.)

**THE FIX:** `readonly` in the **template**; controls stay live.

⚠ **PROVEN ON A NON-1:1 FIXTURE.** JT21 says never verify a conversion with a 1:1 fixture. Product `test1.39` is **1.39 Kg per unit** and renders `1# (1.390 Kg)` correctly; the DO list independently shows `1.390 Kg (1#)`. Two screens, two code paths, same number. Earlier proofs used 20:1 or 1:1 only.

⚠ **`decimalPlaces` RESOLVED TO 3.** `environment.decimalPlaces` was declared at :86 and used nowhere; its value was unknown when the patch was written. Flagged as a risk before deploying; confirmed correct on screen.

**STATUS: DONE. DEV ONLY. NOT PROMOTED — blocked by J105.**

---

### J105 — ⚠⚠ CANCELLING A PACKING SLIP DOES NOT RETURN THE DO QUANTITY. REPRODUCED S85.

**THE DEFECT.** Cancelling a packing slip **deletes its `packingslipdos` join rows but leaves `dispatchorders.qty_shipped` untouched.** The DO's tally climbs and never comes back. The app believes more has shipped than actually has.

**THE EVIDENCE — four DOs, arithmetic fits every one:**

```
                   BASELINE (S85 ~21:30)      AFTER TESTING (S85 ~23:00)
  DO-0004            1 / 1  ✓                   3 / 0 rows
  DO-0005            1 / 1  ✓                   3 / 0 rows
  DO-0010            2 / 1  ✗ (S84 drift)       3 / 1 row
  DO-0011            1 / 1  ✓                   2 / 1 row

  DO-0004  1 → +1 (PS-0018) → cancel → +1 (PS-0019) → cancel = 3 / 0
  DO-0005  same history                                       = 3 / 0
  DO-0010  2 → cancel PS-0016 → +1 (PS-0020)                  = 3 / 1
  DO-0011  1 → cancel PS-0016 → +1 (PS-0020)                  = 2 / 1
```

⚠ **DO-0004 AND DO-0005 WERE CLEAN AT THE START OF THE SESSION.** They drifted *during* S85. Reproduced live, not inherited.

**CONFIRMED BY MINTY: he used CANCEL (whole slip), not Remove (one row).** So the guilty path is the **whole-slip cancel**.

**THE FRONTEND IS INNOCENT.** `deletePs()` (edit-packslips.component.ts ~:642) walks `packslip.Refer_DOs` and sends per-DO `shipped_qty` in the payload. The data the backend needs is on the wire.

**`inActivatePS` HAS NOT YET BEEN READ.** That is the first file to open in S86.

⚠ **THIS CONTRADICTS THE SETTLED DOMAIN RULE (Minty S81, J92):** *"a DO coming off a packing slip ALWAYS returns its quantity."* The rule is right. The code does not implement it. Record the rule in Section 2 (P41); track the bug here.

⚠⚠ **IT DISSOLVES THE S84 MYSTERY, AND THAT IS THE LESSON.**
S84 recorded as UNEXPLAINED that DO-0010 came out of a cancel wrong while DO-0011 came out of the *same cancel on the same slip* correct. That framing sent S85 looking for a difference between the two DOs. **There was none.** DO-0010 had simply been through one more cancel than DO-0011. The "anomaly" was cancel *count*.
▶ **AN UNEXPLAINED DIFFERENCE BETWEEN TWO SIMILAR CASES IS OFTEN A DIFFERENCE IN HISTORY, NOT IN KIND.** Count the events before hunting for a property.

⚠⚠ **SLICE 1 (ff5d183) IS NOW SUSPECT, NOT MERELY UNVERIFIED.**
Slice 1 fixed the `deletedDos` (remove-one-DO) path **by mirroring `inActivatePS`.** If `inActivatePS` never returns the quantity, slice 1 copied a broken pattern into the remove-one path. **Read both together; do not fix one in isolation.** → P40.

⚠⚠ **PROD RUNS THE SAME CANCEL CODE, WITH A REAL CLIENT.**
Nothing in P7 touched `deletePs`/`inActivatePS`, and slice 1 was never promoted — so prod almost certainly behaves identically. **That is a reading, not a proof; prod's copy has not been read.** If Glutenull has ever cancelled a packing slip, their `qty_shipped` is overstated **right now**. Real traceability data on a food-safety system.
▶ **S86 STEP 1, BEFORE ANY CODE: run the reconcile oracle on PROD, unscoped.** Read-only. Empty = forward fix only. Not empty = a data heal must be planned.

⚠ **OPEN, UNEXPLAINED:** DO-0006 went onto PS-0019 alongside DO-0004/0005 and does **not** appear in the drift list. It was not queried directly. Why it behaved differently is not known and may sharpen the diagnosis. → S86.

**STATUS: OPEN. → P53. BLOCKS P7 PROMOTION.**

---

### J106 — `createEditItem` / `addEditItem` ARE DEAD. PROVEN, NOT ASSUMED.

`grep -rn "addEditItem\|createEditItem" src/` returns **three hits only**: `addEditItem`'s definition (:221), its call to `createEditItem` (:222), and `createEditItem`'s own definition (:292). **Nothing calls `addEditItem`.**

⚠ `createEditItem` contains textbook R3 acrobatics — divide `qty_to_ship` by the per-unit weight, compare, multiply back. **It is therefore a DEAD defect, not a live one.** P2's "the two row builders disagree in this file" was half a problem, not a whole one.

⚠ **JT22 IN ACTION:** "dead code" is a claim about reachability, and reachability is checkable. It was checked rather than assumed. → P51.

---

### J107 — THE VALIDATOR LOOP THAT THREW INVISIBLY. DELETED BY 4b.

Before 4b, `doList()`'s success handler ended with:

```
:513  for (let i = 0; i < this.shipmentArray.length; i++) {
:514    this.shipmentArray.at(i).get('shipping_order_units').setValidators(
:515      Validators.compose([Validators.required,
:515        Validators.max(this.shipmentArray.at(i)
:515          .get('shipment_order_units').value)]));
```

**`shipment_order_units` IS COMMENTED OUT of `createItem()` (:368).** `get()` returns `null` for a control that was never declared, so `.value` was read off `null` and **threw**.

⚠ **IT THREW INSIDE `afterClosed()`, AFTER `patchValue` had already run** — so the row populated correctly and the failure was **invisible on screen, console only**. Consistent with S84 seeing DO-0012 land cleanly.

⚠ **ALSO CLOSES A P45 SUB-QUESTION.** P45 asked whether an invalid form actually blocks Save. **It does not.** Nothing anywhere reads `packForm.valid`; Save and Ship are gated only on `vehicle_num` + `vehicle_condition` (html :313-314). And `manufacturing_LOT_order_num` is declared `Validators.required` (:362) but **never patched** — the doList line for it is commented out (:493) — so the new-DO group has **always** been invalid and it has never blocked anything.

Deleted by 4b: under the read-only rule nothing on the row can be typed, so there is nothing to validate.

---

### J108 — `company` HAS AN ADDRESS COLUMN AND NO LOGO COLUMN.

`SHOW COLUMNS FROM company` on dev, S85:

```
HAS       company_name  varchar(255)  NOT NULL
          address       varchar(255)  NULL   ⚠ never seen on any
                                             screen; whether it is
                                             populated is untested
NO        no logo column, and no obvious home for one elsewhere
```

▶ The letterhead can carry **name + address** immediately. The **logo is its own feature** — column + Waterline attribute + Super Admin upload + render-time retrieval. → P54, P55.

⚠ **THE COLUMN ALONE IS NOT ENOUGH.** A column written via `.update().set()` is silently dropped unless it is **also declared in the Waterline model attributes** (J20 / JT2). Same trap as P9. Both, or the write vanishes with no error.

---

### JT24 — ⚠ A CHECK THAT CAN PASS OR FAIL FOR THE WRONG REASON IS NOT A CHECK.

**EARNED S85. TWO OF THIRTEEN post-write checks in the 4b patch script were unsound — and they were unsound in opposite directions.**

```
FALSE FAIL   "validator loop removed" tested whether the string
             get('shipment_order_units') was absent from the WHOLE
             FILE. It failed — because Claude's OWN EXPLANATORY
             COMMENT contains that string. The patch was correct;
             the check matched itself.

FALSE PASS   "no stale shippingQty reference" split the file on
             "createEditItem" and tested the part BEFORE it. But
             addEditItem calls createEditItem at line 222, ABOVE
             the function being guarded — so the check never looked
             at the code it was meant to protect. It passed for the
             wrong reason.
```

⚠ **THE FALSE FAIL WAS THE DANGEROUS ONE.** The script printed *"Run: git checkout -- ."* — which would have thrown away a correct patch. **A verification failure must be diagnosed, not obeyed.**

**THE RULES:**
- A check must not match text the patch itself introduces. Scope it to a line range or exclude comment lines.
- A check that scopes by splitting on a function name must confirm that name appears **once**, and in the position assumed.
- ⚠ Write checks **after** reading the file, never from memory of what the file probably contains. Both bad checks were written before Claude had the file.

(Companion to JT12 "screens lie" and rule 0.1a. A self-written check is also a screen.)

---

### JT25 — ⚠ NEVER NAME A RECORD BY DATABASE id IN A DOCUMENT MINTY READS.

**EARNED S85. Cost two wrong instructions and a round trip.**

Section 1 carried `PS 2389`, `PS 2393`, `PS 2397` (database ids) in the **same block** as `PS-0010`, `PS-0013` (internalCodes). **Minty's screen only ever shows internalCode.** He reported, correctly, that no such slips existed.

```
2389 = PS-0008   (and it was CANCELLED, not live as recorded)
2393 = PS-0012
2397 = PS-0016
2398 = PS-0017
```

⚠ Claude then sent Minty to PS-0008 for a fractional test — **a cancelled, empty slip** — by trusting the stale record over a query.

**THE RULE:** in Section 1, name slips and DOs by the **internalCode Minty can see**. If a database id is genuinely needed, give **both**. The oracle returns ids; translate them before writing them down.

⚠ Same family as P48 (two names for one thing), and it is why P48's aggregate cost is higher than any single item in it suggests.

---

### JT26 — ⚠ DO NOT CLOSE AN OPEN QUESTION WITH EVIDENCE THAT ANSWERS A DIFFERENT ONE.

**EARNED S85, and Minty caught it, not Claude.**

Minty asked whether PS-0008 and PS-0015 had been cancelled by him after S84 — slips already cancelled when the baseline query ran. Claude then saw screenshots of **PS-0018** being created and cancelled during the session, and wrote *"Closed."*

**Different slips. Different times. The evidence did not touch the question.**

⚠ **THE FAILURE MODE IS SPECIFIC:** an open question plus *some* arriving evidence produces an urge to mark it resolved. The check is mechanical — **does this evidence name the thing the question named?** If not, the question is still open.

(Rule 0.1a says look rather than reason. This is its sibling: **having looked, confirm you looked at the right thing.**)

---

**END S85 APPEND**

S86 — APPENDED 25 JUL 2026
NUMBERING: highest existing entry verified as J108, highest trap as JT26 (both
from the S85 append). These run J109 – J110 and JT27.

⚠ HEADER STILL WRONG. Section 5's own header reads "highest is J93 — next is
J94" and "Last appended: S81". S85 asked for this to be fixed and it was not.
It is now FIFTEEN entries and five sessions stale. ▶ Fix it in this commit.

⚠ TWO EXISTING ENTRIES NEED A STATUS LINE (rule 7.1 — whole items, Claude does
the diffing). Both are superseded by J109 below:
   J92   its line "CANCEL-WHOLE-SLIP IS CORRECT AND IS THE REFERENCE
         IMPLEMENTATION" is FALSE and is the sentence slice 1 was built to
         mirror. ▶ Needs a STATUS S86 stamp pointing at J109.
   J105  reads "STATUS: OPEN → P53". ▶ Now CLOSED. Stamp it.


J109 — ⚠⚠ THE CANCEL DEFECT: FIXED, AND FOUR CLAUDE THEORIES DISPROVEN ON THE
WAY. STATUS: CLOSED. Backend commit 44759a9, dev only. Reproduced failing,
then proven passing, both on a reconciled baseline.

THE DEFECT, as it actually was:
     inActivatePS trusted req.body.DOs for the quantity to return, and
     DESTROYED EVERY packingslipdos ROW FIRST, before returning anything.
     So when the payload was wrong or short, the rows were already gone and
     the DO's qty_shipped stayed high. No error. A 200 and a clean-looking
     screen (JT12).

⚠ PROVEN ON DEMAND — the thing S85 could not do:
     PS-0020, three DOs, all at 1 unit, baseline captured first.
       BEFORE  DO-0010 tally 3 / 1 row · DO-0011 2 / 1 · DO-0012 1 / 1
       AFTER   DO-0010 tally 3 / 0 rows · DO-0011 2 / 0 · DO-0012 0 / 0
     ⚠ EXACTLY ONE of three subtractions ran. Rows gone for all three.

THE FIX — three changes, and the first is the one that matters:
     1  READ THE STORED JOIN ROW, never the payload. The backend now derives
        everything from PackingSlipDOs.find({PS_id}). The screen is not asked.
     2  RETURN BEFORE DESTROY, per row. A failure can no longer strand a tally.
     3  SEQUENTIAL for...of, not Promise.all. Concurrent read-modify-write on
        the same row was a live hazard.
     Plus: a no-match guard (the status update could match nothing and the old
     code destroyed anyway), and type guards on both quantities.
     ⚠ SAME PATTERN AS ff5d183, the deletedDos branch. Not invented here.

⚠ VERIFIED: PS-0021, two DOs at 1 unit each.
     BEFORE  DO-0010 tally 4 / 1 row · DO-0011 tally 3 / 1 row
     AFTER   DO-0010 tally 3 / 0 rows · DO-0011 tally 2 / 0 rows
     BOTH returned. Four control slips untouched, including the 0.5 fractional
     row on DO-0009.

⚠⚠ FOUR THEORIES WERE PROPOSED AND DISPROVEN BEFORE THE TEST WAS RUN. Recorded
in full because an unrecorded wrong answer becomes the next session's
foundation (0.1a, J88):
     1  "shipped_qty is missing from storage"      → the baseline query showed
                                                      it present on every row.
     2  "the edit screen loads via a path with no nestedPop, so DO_id.id is
        undefined"                                  → :154 reads result[i] out
                                                      of getPSs, which does
                                                      nestedPop. Dead.
     3  "the index stitch rotates the quantities"   → arithmetic kills it: with
                                                      three equal quantities any
                                                      permutation still gives
                                                      1 to each.
     4  "the backend throws"                        → no error, no alert, clean
                                                      pm2 log, and one
                                                      subtraction did run.
     ⚠ THE EXACT TRIGGER INSIDE THE PAYLOAD WAS NEVER PINNED, AND IS NOW
     UNRECOVERABLE — cancel destroys its own evidence by design. THE FIX DOES
     NOT DEPEND ON IT: removing the payload dependency covers every surviving
     hypothesis, and sequentialising covers the race. ⚠ That is why it was
     right to stop diagnosing and fix.

⚠ THE PROCESS LESSON, AND IT IS THE COSTLY ONE. Rule 0.1a says look rather than
reason. The cancel could have been tested in ten minutes at session open. It was
tested after four hours of reading code. ⚠ EVERY THEORY WAS PLAUSIBLE AND EVERY
ONE WAS WRONG. When a behaviour is reproducible on a sandbox, reproduce it
FIRST and read the code SECOND.

⚠ PROD EXPOSURE — MEASURED, NOT ASSUMED. The reconcile oracle was run UNSCOPED
on prod before any code was touched: EMPTY. And only companies 464 and 465 have
any packing slips at all — GLUTENULL HAS ZERO. So the defect never reached real
client data and no heal is needed. ⚠ Prod also has one cancelled slip (PS-0002,
co 464, status_id 2) that reconciles — but whether it reconciles because cancel
worked or because it had nothing to return is UNKNOWABLE, for the same
evidence-destroying reason. Do not write either version down as fact.

⚠ SCHEMA CONFIRMED IN PASSING: common_status 1 Active · 2 Inactive · 3 Deleted.
Cancel sets status_id 2. There is no is_cancelled column.

⚠ IT ALSO SETTLED TWO OPEN QUESTIONS BY ELIMINATION:
     · DO-0006's "unexplained" behaviour (J105) — it reconciles. It never
       appeared in the oracle because its tally equals its rows. Not an anomaly.
     · The S85 drift on DO-0004/0005/0010/0011 was healed AFTER the fix was
       proven, deliberately in that order — they were the reproduction.
       Company 464's oracle is now EMPTY for the first time since S83.

FIXTURE RESIDUE ⚠ DEV ONLY: PS-0020 and PS-0021 cancelled during testing.
BLAST RADIUS: dev only. No prod code, no prod data.


J110 — P7 STEP B: THE READ-ONLY ROW MIRRORED ONTO CREATE. P45 AND P49 CLOSED.
STATUS: DONE, DEV ONLY. Frontend commit 6b269ab3, 3 files, +31 −117.

WHAT SHIPPED: the CREATE packing slip now carries the identical eight-field
read-only row the EDIT screen got in 4b — MO Number · Internal DO Number ·
Customer PO No · Product · Product External Code · Pdt Lot Code · Best Before ·
Shipped Qty. Customer, System SO No, Delivery Address, Product Internal ID and
the typed Shipped Units box are gone from the markup.

⚠ MARKUP ONLY — THE FORM CONTROLS SURVIVE. create populates its header from
those controls, so deleting the controls would have broken it. Only the display
was removed. (Section 1 flagged this before the patch was written; it was
checked, not assumed.)

P45 CLOSED — the equality-lock validator loop is DELETED, not repaired. Under
the read-only rule nothing is typed, so there is nothing to validate. This is
the loop J103 found pointing Validators.min AND max at the Kg figure after S82's
format flip.

P49 CLOSED — save() no longer parses a display string. It read
`data.shipment_product_order_qty.split(' ')[0]`; it now reads
`data.shipment_order_units`, a stored number.
⚠ THE ENABLING DETAIL: shipment_order_units was COMMENTED OUT of createItem
while patchValue still wrote to it — a silent no-op for who knows how long.
Uncommenting the control made the existing write live. ⚠ Angular discards a
patchValue for a control that does not exist, with no error. Same family as
JT2 (Waterline drops undeclared columns): a write to a thing that is not
declared vanishes quietly.

⚠ A SECOND SILENT GAP, CAUGHT BEFORE DEPLOY: on create, shipping_order_qty was
never patched by anything except the dead setShipQty — so the mirrored "Shipped
Qty" field would have rendered BLANK. The patch populates it with the uniform
string `${packing_units}# (${qty_to_ship} ${uom})`.

ALSO DELETED: setShipQty (18 lines). Its only caller is commented out in the
template, and it parsed the quantity string by position. Dead code that
computes wrongly is a decoy — JT22.

⚠ .dark IS A COMPONENT-SCOPED STYLE. It lives in edit-packslips.component.scss
and would NOT have applied on create. Three lines (`.dark{color:black;}`) were
appended to create's own stylesheet. ⚠ Angular component styles do not leak —
copying markup between components does not copy its CSS.

PROVEN IN THE DB, NOT THE TOAST. A new slip PS-0024 with two DOs:
     row_qty 1 · qty_shipped 1 · packing_units 1, on BOTH lines.
     ⚠ This path had NEVER EXECUTED before — save() was reading a control that
     did not exist. A green "Packing Slip Created Successfully" alert proves
     nothing (JT12); the query is the proof.
     Older slips untouched, including DO-0009 at 0.5.

⚠ A DISPLAY DEFECT SPOTTED, NOT FIXED: /Dispatch-orders renders the shipped
figure for DO-0010 and DO-0011 as `0 Kg(0#)` while the DB holds 1 for both.
Pre-existing, not caused by this commit — a P2 division site. → P2.


JT27 — ⚠ A POST-WRITE CHECK MUST NOT MATCH THE PATCH'S OWN COMMENTS.
     ⚠ AMENDS JT24, WHICH WAS NOT SPECIFIC ENOUGH — AND IT FIRED TWICE IN ONE
     SESSION, ON THE VERY SESSION THAT LOGGED IT.

JT24 says "a check must not match text the patch itself introduces." S86 proved
that is read too narrowly. BOTH false failures came from EXPLANATORY COMMENTS,
not from code:

  PATCH 1   check "payload no longer read" searched the block for
            `req.body.DOs`. The new comment says "trusted req.body.DOs".
            FALSE FAIL.
            check "no Promise.all in block" — the comment says "Sequential,
            not Promise.all". FALSE FAIL.

  PATCH 2   check "8 readonly inputs" counted `readonly>` across the WHOLE
            FILE. "Authorized By" sits outside the row block and is the ninth.
            FALSE FAIL.

THE RULES, sharpened:
  1  A check for the ABSENCE of a string must exclude comment lines, or the
     comment must not contain the string. Prefer testing for the CODE SHAPE
     (`for (const psdo of`) over the absence of a name.
  2  A COUNT must be scoped to the block being changed, never to the file.
  3  ⚠ WRITE THE CHECKS AFTER WRITING THE COMMENT, and re-read both together.
     Both S86 failures were invisible until the script ran.

⚠ AND THE HALF THAT MATTERS MOST: the script printed "Run: git checkout -- ."
on failure. Obeying it would have thrown away TWO CORRECT PATCHES. A
verification failure is a hypothesis about the patch, not a verdict on it.
DIAGNOSE, THEN DECIDE. (JT24's own warning, earned again immediately.)

J111 — getPSs STITCHED THE DO ROWS BY ARRAY INDEX. A PACKING SLIP COULD
CARRY THE WRONG LOT CODE. STATUS: CLOSED. Backend commit 13e3fcd, S86.

WHAT IT WAS: getPSs matched its populated DO objects to their join rows by
  ARRAY INDEX — position in one list assumed to correspond to position in
  the other. Nothing guarantees that. Two queries, two orderings, no key.
  Now matched by id.

PROVEN, NOT REASONED: the mismatch was demonstrated on a live slip
  (PS-0020) before the fix — the rows genuinely stitched wrong, not
  "could in principle".

⚠ WHY IT HAD TO LAND BEFORE THE PRINTED SLIP, AND WHY IT IS NOT COSMETIC:
  a mis-stitched row puts THE WRONG LOT CODE on a document that goes to a
  customer. Every other consequence of this bug was a screen someone could
  double-check; this one is a piece of paper leaving the building with a
  traceability claim on it. The print work (J112) sat directly on top of
  this read path, so the order was forced.

⚠⚠ THE PART WORTH KEEPING IS NOT THE BUG. IT IS THAT IT WAS FOUND IN S83,
  RECORDED IN A HANDOVER DOCUMENT AS "D3", AND CARRIED THREE SESSIONS WITH
  NO QUEUE NUMBER. A finding that lives only in a handover is a finding
  that does not exist — nothing points at it, no session opens on it, and
  it surfaces again only by luck. Rule 7.5 exists for exactly this: a bug
  found and not fixed goes in the LOG with its evidence, and a line goes
  in the QUEUE. One of those two happened. That is why it waited.
  ▶ Same failure family as J77 (an unrecorded commit became an
  unrecorded suspect) — the cost is not the defect, it is the silence.

BLAST RADIUS: dev only when fixed; promoted to prod S86 with the rest of
  the P7 set. No data heal needed — the mis-stitch was a read-path defect,
  so nothing wrong was ever stored.
========


J112 — THE PRINTED PACKING SLIP IS NOW ITS OWN DOCUMENT. STATUS: BUILT AND
SHIPPED. Frontend commits ba3bfe9f + 8997acdc, S86.

THE ROOT CAUSE WAS STRUCTURAL, NOT COSMETIC — and this is the whole entry:
  the printed document and the EDITING SCREEN WERE THE SAME DOM. A CSS
  class (doNotPrint) hid the buttons; everything else printed as Material
  form fields. ⚠ THE CUSTOMER WAS RECEIVING A PRINTED DATA-ENTRY FORM.
  No amount of print-CSS tuning fixes that, because the thing being
  printed was never a document. It was a screen with its buttons hidden.

THE FIX: the print view became its own template. ba3bfe9f split it out and
  added real print CSS, real dates (01 Jul 2027, not 27 JL 01) and em-dash
  blanks in place of the literal word "null" (the P10 symptom — the dash is
  required whether or not P10 is ever fixed). 8997acdc followed with fixed
  column widths, larger type and proper spacing.

VERIFIED: Chrome print preview on dev; then on PROD after promotion, along
  with the traceability PDF as the regression pair — ⚠ P52a edited the
  GLOBAL styles.scss, so every other print path in the app was in scope.
  Both clean. Backup: styles.scss.bak-S86-P52a-visual-20260725-231007.

⚠ SCOPE CHANGED MID-SESSION AND THE RECORD MUST SAY SO. The frozen P52
  spec's section 11 reads "NOT PART OF P7 ... P52 IS ITS OWN SESSION."
  MINTY OVERRULED THAT IN S86: the printed slip IS P7's endpoint — it is
  the thing he had been trying to build for six sessions, and the field
  work was scaffolding for it. ▶ Section 11 of the frozen spec is now
  WRONG; correct it when the spec folds into Section 4.

⚠ DELIBERATELY NOT BUILT — MINTY'S CALL, S86, "not required at this time":
    TOTALS        no line total or unit total at the foot of the slip
    PAGE FOOTER   no "Page 1 of 2", no slip number repeated per page
    BARCODE       designed and frozen, NOT built
  ⚠ THESE ARE DECISIONS, NOT A BACKLOG. The slip as it stands IS the
  deliverable. Do not re-raise them as unfinished work.
  ⚠ THE BARCODE KEEPS ONE LIVE DEPENDENCY: when it is built, its
  encoding and P6's PO-receiving scanner must be designed TOGETHER or they
  will not meet. That is the only reason it stays alive at all.

BLAST RADIUS: frontend only, no DB change. On prod as of S86.
========


END S86 APPEND

S95 — APPENDED 30 JUL 2026
NUMBERING: highest existing entry verified as J112, highest trap as JT27.
This is J113. ⚠ NO JT ENTRY IS ADDED HERE — the two traps earned in S95
are in TRAPS.md, the working file. Section 5's JT block is not extended.
See the note at the foot of this entry.


J113 — Trace_ProductProdLotView DIVIDED received_qty WHILE ALREADY
SELECTING received_units. FIXED BOTH BOXES. STATUS: CLOSED.
P91. RDS only, not in git — rebuild record is JR7e.

WHAT IT WAS: the view produced received_qty_su as
  (mm.received_qty / fop.wgt_kgs_per_unit) — while selecting
  mm.received_units four columns further along the same SELECT. The
  stored value and the derived value were both present; the derived one
  was displayed.

⚠ THE DIVISION WAS ARITHMETICALLY CORRECT. received_qty is Kg-stored,
  so Kg / (Kg per unit) genuinely yields units, and every row agreed with
  the stored column to within float noise. THIS WAS NOT A WRONG NUMBER.
  It was a right number wearing garbage: 4 of 17 non-1:1 rows on dev
  rendered 110.99999999999999, 51.00000000000001, 11.000000000000002 and
  10.000000000000002. Rank this class of finding as cosmetic-plus-anchor,
  not as a defect.

THE FIX: received_qty_su = mm.received_units. Rebuild instruction is
  JR7e; the view text it applies to is db-definitions-S93.txt. ⚠ NO
  .sql FILE WAS COMMITTED — the object text is already recorded once and
  a second copy is a second thing to keep in step. ALIAS UNCHANGED, so
  product-traceability.component.html:79 — the sole consumer, grepped
  across frontend src and backend api — needed no edit. No build, no
  deploy, no commit of code.

⚠ AND THE THING THAT FOLLOWS FROM IT: A DATABASE OBJECT NEVER REACHES
  THE OTHER BOX BY DEPLOYING ANYTHING. Dev and prod are separate RDS
  instances. The ALTER was run on each box directly. There is no promote
  path for a view, and nothing in the deploy tooling would have told you.

GATED BEFORE THE ALTER, ON BOTH BOXES — and the gate was not optional.
  Line 79 carries *ngIf='item.received_qty_su', so a NULL or 0 unit count
  HIDES THE SPAN ENTIRELY where a wrong number showed before. Counted
  first:
    dev   would_go_blank 0 · units_null 0 · units_zero 6 (all received_qty 0)
    prod  would_go_blank 0 · units_null 0 · units_zero 2 (all received_qty 0)
  ⚠ Glutenull (company 471) did not move: Fruits & Nut Breakfast Bars
  560/0.32 = 1750, Buckwheat Granola Bar 192.48/0.24 = 802, identical
  before and after. THE CLIENT SEES NO DIFFERENCE. Prod carried no float
  garbage today; this stops the next awkward ratio producing it.

⚠ THE VERIFICATION QUERY WAS WRONG THE FIRST TIME AND RETURNED A FALSE
  FAILURE. Scoped to TABLE_NAME only, it matched the dormant `abletrace`
  archive's untouched copy and returned 1 — reading as "the ALTER did not
  take". It had taken. A check that cannot return a pass is not a check,
  and a false FAILURE invites re-running a write on a live box. Full entry
  in TRAPS.md. ⚠ 3B.3 records the archive as living on the prod instance;
  DEV HAS ONE TOO. → P101

DOCUMENTS CORRECTED IN THE SAME PATCH (rule 7.1 — a strike that does not
  chase every copy is not a strike, J82): JR7a, J7 and J26 each asserted
  that this divide was correct or was being left in place. All three
  stamped, pointing here.

⚠ WHERE THE TRAPS WENT. Section 5's JT block was NOT extended. S94
  settled a four-file working set — RULES, NOW, TRAPS, PLAN — and TRAPS.md
  is the cumulative traps file. Section 5 keeps the REBUILD record, which
  is what makes it undeletable. Two homes for one kind of fact is what
  rotted Section A and is what P95 is about. → P95

BLAST RADIUS: a view definition on each box. No row written, no schema
  change, no code. Rollback is the JR7a+JR7d text, which is in this file.

⚠ MEASURED IN THE SAME PASS — THE R5 SCOPE. Recorded here because these
  are measurements, and a disposable planning file is not where a
  measurement lives.

  ALL SEVEN _su DIVISIONS IN Trace_ProductHeaderView ARE ARITHMETICALLY
  CORRECT. Every source field is Kg-stored. R5 is not seven wrong
  figures — it is garbage generators and anchor violations.

  CONSUMER, grepped across frontend src and backend api — the whole list:
    product-traceability-details.component.ts + api/models/Traceability.js
  ONE SCREEN. A fix is verifiable; nothing else reads this view.

  REPOINT — 2, stored units exist and are reachable in the current joins
    qty_produced_su  → mm.received_units          (P91 proved it clean)
    qty_shipped_su   → SUM(dispatchorders.qty_shipped)   (units, GR7)

  LEAVE — 3, correct and NO stored-units alternative exists
    intermediate_prd_su   qty_allocated is Kg (P93). ⚠ mprrecievelots
                          has NO units column — measured S95.
    qty_packing_slip_su   sums qty_to_ship, Kg
    qty_do_su             same source, same basis

  SCHEMA — 1
    qty_misc_release_su   ⚠ rejectmaterialandproduct has NO units column
                          — measured S95. Needs a column add, a
                          write-path change, and a BACKFILL ON A LIVE
                          CLIENT derived from Kg, which is the Route 3
                          round-trip this whole programme exists to
                          eliminate. NOT COSTED.

  DEPENDENT — 1
    SOH_su   subtracts five Kg terms then divides. Cannot be
             units-anchored until every subtrahend is, and one needs the
             schema change. ⚠ THIS IS THE HEADLINE FIGURE — Stock on
             Hand is the number anyone actually reads — AND IT IS THE
             LAST ONE FIXABLE. Doing the two cheap repoints improves two
             cells and leaves SOH exactly as it is. That is the ranking
             question, and it is Minty's.

  ⚠ SUPERSEDES 3A.6, which says nobody has identified where the R5
    switch point is. → P90
  ⚠ THE TRAP THAT WILL BITE THE REPOINT is in TRAPS: the do_products
    CTE defines its own alias called qty_shipped which sums qty_to_ship
    and is KG.
========


END S95 APPEND

S97 - APPENDED 2 AUG 2026
NUMBERING: highest existing entry verified as J113. This is J114.
No JT entry - the traps file is not extended by this session.


J114 - THE SO STATUS COMPARES UNITS TO Kg. AND THE FRONTEND SITE THAT
LOOKS IDENTICAL IS DEAD. STATUS: DEFECT CONFIRMED, NOT YET FIXED.
P124. Frontend paths verified S97 by find + grep.

THE DEFECT, in api/models/SOManagement.js:182-206 - BACKEND:
     dispatchedQty += DO.qty_shipped;      UNITS
     soQty         += product.quantity;    KILOGRAMS
     if (soQty <= dispatchedQty) finalState = 3   -> GREEN

  PROVEN LIVE, not reasoned: SO-0014 on dev, test0.7 at 0.7 Kg per
  unit. Ordered 5 units = 3.5 Kg stored. Shipped 4 units.
  3.5 <= 4 is TRUE, so the dot went GREEN with one unit still owed.
  ⚠ PREDICTED FIRST, THEN REPRODUCED. The prediction is what makes
    it a finding rather than an observation.

⚠ IT FAILS IN BOTH DIRECTIONS, from the same line:
     under 1 Kg/unit   the unit count outruns the Kg figure, so it
                       greens BEFORE the order is complete
     over  1 Kg/unit   the unit count never reaches the Kg figure,
                       so a completed order NEVER greens
  ⚠ GLUTENULL IS ON THE DANGEROUS SIDE. Fruits & Nut bars are
    0.32 Kg per unit (J113), so the EARLY-GREEN direction is what is
    live on prod: an order reads complete while stock is still owed.

⚠⚠ THE FRONTEND FUNCTION THAT LOOKS LIKE THE CAUSE IS DEAD, AND
THIS IS THE HALF THAT MATTERS. so-management.component.ts:170
  evalFinalStateElement carries the SAME units-vs-Kg comparison at
  :179/182/185. It is the site the S93 checklist and P82d both point
  at. ⚠ ITS ONLY CALLER, AT LINE 138, IS COMMENTED OUT.
  Patching it would have built cleanly, deployed cleanly, and
  changed NOTHING.
  ▶ The status arrives from the backend already computed. html:73
    reads element.finalState; the .ts never sets it.
  ⚠ SECOND SITE, NOT YET READ: closed-so.component.ts:136 calls
    evalFinalStateElement LIVE for the Closed SOs screen and computes
    finalState in the frontend by its own route (:169/172/175). Two
    implementations of one domain rule. Whether they agree is UNKNOWN.

MINTY'S RULING, S97 - AND IT DECIDES THE FIX:
  A DO CAN SHIP MORE OR LESS THAN AUTHORISED.
  So the status must follow what ACTUALLY shipped (qty_shipped,
  units), not what was authorised (qty_to_ship, Kg).
  ⚠ That rules out the tempting no-conversion fix of summing
    qty_to_ship, which is already Kg and would need no maths.
  ▶ THE FIX IS THEREFORE: populate packing_id on the DispatchOrders
    find at :179, then dispatchedQty += qty_shipped * wgt_kgs_per_unit.
    MULTIPLY, never divide. R1.
  ⚠ soproducts stores NO unit count - only quantity (Kg) and
    quanity_shipped_to_date (units). Measured S97 from the model.
    So comparing units to units is NOT available.

⚠ ALSO SETTLED THIS SESSION - THREE SITES ARE DEAD, NOT DEFECTS.
  lotReceived is assigned and its only consumer is commented out in
  all three: edit-mlc:295 (consumer :311), edit-mlo:245 (:260),
  start-mlc:151 (:164). ⚠ THE SURVIVOR IS edit-closed-mlcs:126,
  whose consumer at :136 IS LIVE - somebody switched five of these
  off and missed one. -> P115 for the dead three, PLAN fix 5 for the
  survivor.

⚠⚠ THE "MISSING DOT" IN dispatch-orders.component.html DOES NOT
EXIST. A grep rendered line 116 as element?Refer_PS[0] - no dot -
which reads as a broken ternary and would explain the 0# that screen
shows on shipped DOs. A patch was written against it. THE ASSERTION
REFUSED TO WRITE: anchor found 0 times. cat -A on the raw file shows
element?.Refer_PS[0] - THE DOT IS THERE and always was.
  ⚠ THIS IS J83's ARTEFACT RECURRING. S79 logged three "missing
    operator" defects that were grep artefacts inside long template
    literals. Same shape, seven sessions later.
  ▶ THE RULE: confirm any ONE-CHARACTER defect with cat -A before
    writing a patch. A grep is not a faithful renderer.
  ⚠ AND THE ASSERT-ANCHORED PATCH IS WHAT SAVED THE FILE. A sed
    would have corrupted a working line. Rule 4.2 earned again.
  ⚠ P82g IS THEREFORE STILL UNEXPLAINED. The 0# is real - reproduced
    on DO-0013 and again on DO-0014, both freshly shipped. The
    template is correct. The cause is a ROW question now, not a code
    question: read packingslips.shipped_flag and packingslipdos for
    those DOs.

THE SEVEN SITES SCOPED, all paths verified by find + grep, all read
in the file. Full detail is in PLAN for S98; recorded here as the
evidence:
  SOManagement.js:182-206              units vs Kg      -> P124
  admin-formulation.component.ts:878   legacy inventory column
  add-mlo.component.html:87            legacy inventory column
  closed-mlcs.component.html:79        divides units-stored qty
  edit-closed-mlcs.component.ts:136    divides units-stored qty + R3
  edit-mlc.component.ts:298            rebuilds received_qty
  product-traceability.component.ts:109,161  rebuilds received_qty
⚠ THE LAST THREE ARE THE JR7e / P91 SHAPE EXACTLY - a Kg-stored
  source divided correctly while the stored units column sits unread.
  Right number, wrong route. Same fix, already proven in S95.

CORRECT AND STRUCK, verified by reading WHAT EACH CALLER PASSES:
  mfg-lot-codes.html:69 - production-controller.html:50 -
  mlo-management.html:78 - closed-mlcs.html:84 - add-dispatch-v2:25,28 -
  mlo-list:38,40 - dispatch-orders:117,120. All pass a Kg source.
  ⚠ closed-mlcs.html:84 IS CORRECT WHILE :79 IS WRONG - same helper,
    adjacent lines, one passes received_qty (Kg) and one passes qty
    (units). Do not "tidy" them into one call.

⚠ FOUR CLAUDE THEORIES DISPROVEN. Recorded because an unrecorded
wrong answer becomes the next session's foundation (0.1a, J88):
  1 "the allocation buckets are broken"  -> the DO/PS/ship transfers
      measured CORRECT at every hop on a clean product. The earlier
      readings came from a product whose history included a cancel.
  2 "0.666# is a division artefact"      -> real residue of
      fractional allocations. Withdrawn.
  3 "a foreign MO in the Stock Info popup" -> deliberate. The popup
      lists DOWNSTREAM MOs for the edit gate: "close open MOs before
      you can edit". Not a filter fault.
  4 "a missing dot"                       -> see above.
  ⚠ ALL FOUR WERE PROPOSED BEFORE LOOKING.

⚠ THE FIXTURE ERROR, so nobody repeats it. test0.7 was built at
0.7 Kg/unit to expose hidden divisions: 7 / 0.7 = 6.999999999999999
in binary, so a divide should have confessed. EVERY SCREEN ROUNDS TO
THREE DECIMALS, so it printed 10.000 either way. The same blind spot
as a 1:1 fixture (TRAPS 9), reintroduced through the formatter.
  ▶ A DISPLAY-ROUNDED SCREEN CANNOT REVEAL A DIVISION. Read the code.
  ⚠ WHAT THE FIXTURE DID PROVE, and it is worth keeping: the whole
    outbound chain reconciles - MO -> receive -> SO -> DO -> packing
    slip -> ship, 8 in store + 2 shipped = 10 produced, buckets
    moving correctly at every hop. And RECEIVE CANNOT BREAK THE
    ANCHOR: Quantity (Kg) on the receive form is locked and derived,
    so an operator cannot store an inconsistent pair.

FIXTURE RESIDUE ⚠ DEV ONLY, company 464: product test0.7 (FO-0009),
  MO-0015 (received 10), MO-0016 (released, not received), SO-0014
  (5 ordered, 4 shipped, GREEN - this is the live evidence for P124,
  do not clear it), DO-0013/0014, PS-0028/0029.
BLAST RADIUS: none. No code changed, nothing deployed, no prod touch.
========


J115 - TWO POPUP ERRORS ON getActiveFormula. NOTHING PROVEN.
STATUS: OPEN, CAUSE UNKNOWN, NOT REPRODUCIBLE ON DEMAND.

WHAT MINTY SAW, twice, identical wording:
  "Http failure response for .../getActiveFormula: 0 Unknown Error"
  A blocking alert(). Had to be dismissed with OK.
    14:07 UTC  /Add-SO    creating SO-0014
    14:33 UTC  /Add-MLO   creating MO-0016
  Both on product test0.7. Minty: never seen before.

EFFECT: Shipping Unit and Quantity stayed blank - that call fills
them. Both records SAVED CLEAN once refilled. No data harmed.

MEASURED:
  nginx      SERVER ANSWERED 200 BOTH TIMES, 21455 and 21456 bytes
  pm2        restart count HELD AT 33 - no crash
  error log  no stack trace, nothing near either time

⚠ STATUS 0 IS NOT A SERVER ERROR - it means no response reached
  the browser. Do not chase the backend.

⚠ THE 14:07 REQUEST FIRED TWICE IN THE SAME SECOND. Same byte
  count. A duplicate call is a LEAD, not a proven cause.

▶ IF IT RECURS: read the nginx log for that second, and check
  whether the request duplicated.
⚠ A THIRD OCCURRENCE MAKES IT A DEFECT.

⚠ NOT A QUEUE ITEM - nothing is broken. Recorded so the next
  occurrence is the third data point, not the first.
========


END S97 APPEND

S107 - APPENDED 6 AUG 2026
NUMBERING: highest existing entry is J116, assigned inside JR15. This
is J117. Highest JR is now JR18. No JT entry - TRAPS.md is the traps
file and it is not extended by this session.


J117 - A QUEUED COMMIT WOULD HAVE UNDONE THE PREVIOUS SESSION'S FIX,
AND THE PLAN SAID TO DEPLOY IT. STATUS: CLOSED. Frontend commit
a94f39c3, built as run #57, deployed and screen-proven on BOTH boxes.

WHAT WAS QUEUED: 30b2ddd4, "P140: round the Planned weight and drop
  the unit count from Completed". Pushed 10:29 AM 6 Aug. GitHub
  Actions was in a major outage; run #56 queued and never started.

WHY IT DROPPED THE COUNT - AND IT WAS RIGHT TO, AT THE TIME:
  8fa2ed14 (S105) had folded a unit count and a weight into BOTH
  yield-dialog header boxes, reading Completed from
  mlcDetails.received_units. But WhC_GetMoDetails_SP did not SELECT
  received_units, so the box printed `undefined#`. 30b2ddd4 removed
  the count, leaving weight only, and left a comment naming the exact
  string to restore when the procedure served the column.

S106 FIXED THE PROCEDURE THAT SAME AFTERNOON (JR17), WHICH MADE THE
  REMOVAL OBSOLETE BEFORE IT WAS EVER BUILT. The deployed build was
  still 8fa2ed14 - the OLDER commit, the one that reads the count - so
  the moment the column arrived, dev started rendering 7# (58.38 Kg)
  correctly. S106 recorded that as screen proof and it was, but OF THE
  OLD BUILD.

SO THE QUEUED COMMIT HAD BECOME A REGRESSION SITTING IN A QUEUE.
  PLAN's first-three-actions for S107 read: if Actions is back and #56
  has gone green on 30b2ddd4, deploy it to dev, then consider prod.
  FOLLOWING THAT INSTRUCTION WOULD HAVE TAKEN A WORKING FIGURE OFF THE
  SCREEN, on dev and then on a live client box.
  THE OUTAGE - the obstacle of the whole previous session - IS THE
    ONLY REASON IT HAD NOT ALREADY HAPPENED.

HOW IT WAS FOUND: not by reading the plan. Minty chose to do P151 in
  S107 rather than defer it, which meant opening
  check-mat-yield.component.ts to copy "the shape that is already
  working". THERE WAS NO WORKING SHAPE IN THE FILE - the comment was
  written in the future tense and the line under it rendered weight
  only. That contradiction against NOW's screen proof is what exposed
  the whole thing.
  CLAUDE STOPPED AT THE CONTRADICTION RATHER THAN PATCHING THROUGH IT.
    That is the only reason this is a near-miss and not an incident.

THE FIX (a94f39c3, one file, +9 -8):
    const completedUnits = this.data.mlcDetails.received_units
    qtyCompleted: `${completedUnits}# (${completedKg} ${this.uom})`
  qtyPlanned UNTOUCHED - 30b2ddd4's rounding fix survives intact. The
  replacement comment records WHY the count came back, so a future
  reader meeting 30b2ddd4's message does not re-drop it.

PROVEN, DEV, company 474, MO-0001, after Shift+Cmd+R:
    QTY Planned    7# (58.38 Kg)   not 58.379999999999995
    QTY Completed  7# (58.38 Kg)   the restored count
PROVEN, PROD, Glutenull MO-0001:
    Plan Quantity      1750.000# (560.000 Kg)
    Completed Quantity 1750.000# (560.000 Kg)
  THE (Kg)-OVER-A-CASE-COUNT HEADER LABELS ARE GONE. That was
    30b2ddd4's own contribution and it is what justified promoting to
    prod the same night.

RUN #56 IS STILL QUEUED ON GITHUB AND WOULD NOT CANCEL - "Failed to
  cancel workflow", attempted twice. IF IT EVER COMPLETES ITS ARTIFACT
  REMOVES THE COUNT AGAIN, and being newest it would win an
  `ls -1t | head -1`.
  S107 DEPLOYED BY TYPING THE FILENAME EXPLICITLY, not by taking the
    newest. THE COMMIT STAMP IS IN THE ARTIFACT NAME -
    dist-{dev,prod}-<sha>.zip. READ IT.
  RULES 2's "read the filename off the ls" assumes the newest zip is
    the right one. That assumption does not hold while a superseded
    run is queued.

THE COMMENT IN THE CODE PAID FOR ITSELF A SECOND SESSION RUNNING.
  -> P118. S106 needed no re-derivation because of it; S107 found the
  exact restore string sitting in the comment it was about to replace.
  TWO SESSIONS, TWO PAYOFFS, ONE PRACTICE.

THE TRANSFERABLE LESSON: A WORKAROUND BECOMES A DEFECT THE MOMENT THE
  CAUSE IS FIXED, AND NOTHING ANNOUNCES THE CHANGEOVER. The commit
  message is the warning label - 30b2ddd4 said "drop the unit count"
  in plain words, and NOW described the commit only by its other,
  useful half (the rounding, the prod labels). A commit carrying both
  a fix and a workaround will be remembered for the fix.
  -> BEFORE DEPLOYING ANY COMMIT WRITTEN BEFORE A FIX LANDED, READ
    WHAT IT ACTUALLY DOES.

BLAST RADIUS: none realised. Both boxes now serve a94f39c3 and both
  were screen-proven. Rollbacks in place:
  www-html.bak-dev-a94f39c3b2bf (holds 8fa2ed14179d) and
  www-html.bak-prod-a94f39c3b2bf (holds 0ad1f77cee1d).
========


ALSO SETTLED IN S107, recorded here because they are measurements and
a disposable planning file is not where a measurement lives:

  P151 IS TWO SITES, NOT THREE. edit-mlc.component.ts:354 getWdu has
  exactly ONE live caller - html:258. The call at :309 is commented
  out. Fixing html:258 makes getWdu dead; delete it in the same pass
  (P115). And :295 lotReceived is DEAD ALREADY (J114) - its consumer
  at :311 is commented out. It is NOT a P151 site and must not be
  patched.

  html:258 CANNOT TAKE received_units. It renders a PER-RECEIPT row;
  mlcDetails.received_units is the cumulative MO total. Repointing it
  there would print the whole MO's figure on every receipt row - a
  wrong number where a right-looking one stands now.
  IT NEEDS receiveproducts.qty, and
    WhC_GetMoProductReceivingDetails_SP DOES NOT SERVE IT. Measured
    S107: it selects id, internalCode, mlc_id, mlc_packaging_id,
    received_at, recieved_qty. FIFTH INSTANCE OF THE P143/P149
    PATTERN. -> P157.

  PLAN SAID "THE BLOCKER IS GONE" FOR ALL THREE P151 SITES. It was
  gone for one. A confident scoping line, written when the fix landed,
  aged into a wrong one in a single session.

  S95's SIX-DIVISION SCOPING IS SUPERSEDED. It read "two repointable,
  three leave, one needs a schema change". Measured S107: FOUR
  repointable, one schema, one dependent. It aged because JR15 added
  qty_rejected_units in S103, and because nobody had checked what else
  sat on the dispatchorders row (TRAPS 1 named packing_units and
  qty_shipped the whole time).
  -> RE-ASK A SCOPE BEFORE BUILDING FROM IT.

  HAGENSBORG IS A SECOND LIVE CLIENT ON PROD - company 469, seven MOs
  created, none run, 24 MR rows, zero release allocations. The working
  files named Glutenull as the client and listed 469 among DEV's
  unaccounted companies (P100). Found by a routine group-by that did
  not have to include company_name and did. -> P156.

END S107 APPEND

S108 - APPENDED 7 AUG 2026
NUMBERING: highest existing entry is J117. This is J118. Highest JR is
still JR18 - S108 changed no database object. No JT entry.


J118 - THE UNITS SURVEY. THE FIRST SYSTEMATIC ONE, AND IT FOUND WHAT
TWENTY SESSIONS OF ACCIDENTS DID NOT. STATUS: SURVEY COMPLETE, NO CODE
SHIPPED. Both boxes closed exactly as S107 left them.

⚠⚠ THE OUTPUT IS NOT IN THIS ENTRY. IT IS UNITS-BIBLE.txt IN THIS
  REPO - the four sources of every unit figure, and the state of all
  47 sites that produce one. THIS ENTRY RECORDS THE MEASUREMENTS AND
  POINTS AT IT. Two homes for one fact is what rotted Section A.

WHAT WAS SURVEYED
  DATABASE  35 procedures and 9 views listed from information_schema.
    11 touch a per-unit weight. 12 candidate objects read in full.
    THREE DIVIDE - Trace_ProductHeaderView (3 cells, known) and BOTH
    intermediate-product trace procedures (NEW, in no document).
  SCHEMA  every table holding a quantity column, listed from the
    schema itself rather than from code. 27 found.
  FRONTEND  56 files, 185 references. Swept for direct divisions AND
    for helper functions called from templates.
  ONE LIVE TEST on dev - a material return on company 464 MO-0011.

⚠ THE SWEEP HAD TO BE RUN TWICE. The first pattern required whitespace
  after the slash and missed `qty_allocated/fo2.wgt_kgs_per_unit`. It
  reported a DIVIDING object as CLEAN.
  ⚠⚠ AND THE CONTROL PASSED ANYWAY. A known three-division view
    returned 1 under both patterns, because the pattern matched what
    it was built on.
  ▶ A CONTROL PROVES A PATTERN MATCHES WHAT ITS AUTHOR IMAGINED. IT
    PROVES NOTHING ABOUT SHAPES HE DID NOT. OVER-REPORT BY DESIGN - a
    false hit costs one read, a false clean costs a defect.
  ⚠ THREE SWEEPS GAVE THREE ANSWERS: 49 files, then 56 with two more
    spellings, then 19 aligned sites that mention no weight at all and
    were invisible to both. SAY WHAT A SWEEP CANNOT SEE, IN THE SAME
    BREATH AS ITS RESULT.

MEASUREMENTS - ALL READ-ONLY, AND THEY CLOSED THREE OPEN QUESTIONS
  1  PRODUCT-SIDE ALLOCATIONS ON PROD, by company:
       471 Glutenull 0 · 469 Hagensborg 0 · sandboxes 5.
     ▶ THE INTERMEDIATE BACKFILL TOUCHES NO CLIENT DATA.
  2  MR ROWS ON PROD, by type:
       469 Hagensborg 24 rows, ALL MATERIAL, 216,969 Kg.
       464 sandbox 1 material + 3 product. 471 Glutenull ZERO.
     ⚠⚠ MINTY, S108: "hagensborg rows are materials returns only."
       CONFIRMED BY QUERY.
     ▶ THEREFORE THE MR BACKFILL MUST NOT HAPPEN. JR15 already ruled
       it - material reject is Kg-measured BY DESIGN and adding units
       there is a defect. THE RIGHT VALUE FOR ALL 24 IS ZERO AND ZERO
       IS WHAT THEY HOLD.
     ⚠ CLAUDE'S S107 POSITION PAPER SIZED THIS AS "28 ROWS ACROSS TWO
       CLIENTS" AND TREATED THEM AS ONE KIND OF THING. THEY ARE NOT.
       THE RECOMMENDATION BUILT ON THAT FRAMING WAS WRONG.
  3  PRODUCT RETURNS: ONE ROW ON EACH BOX, BOTH MATERIAL.
     ▶ NO PRODUCT RETURN HAS EVER BEEN RECORDED ANYWHERE.
  ▶ THREE RULINGS DISSOLVED BY MEASUREMENT RATHER THAN DECIDED.
    MEASURE BEFORE ARGUING. A ruling that measurement can dissolve
    should never reach Minty as a ruling.

⚠⚠ mprrecievelots HAS TWO PARALLEL FK PAIRS ON ONE ROW, AND WHICH PAIR
  IS POPULATED ENCODES THE RELEASE TYPE.
    material_id + Rec_Lot_id      = MATERIAL
    formula_id  + Rec_Product_id  = PRODUCT
  Dev: 95 material, 14 product, NO overlaps and no orphans. Nothing in
  the column names says so.
  ⚠ CLAUDE'S FIRST MEASUREMENT OF THIS RETURNED ZERO INTERMEDIATES ON
    EVERY COMPANY - because it joined on material_id, which is NULL on
    every intermediate row. THE QUERY COULD NOT HAVE RETURNED A
    NON-ZERO. It was caught only because J80 TEST 2 records an
    intermediate release on 464 in S73. THE LOG DISPROVED THE QUERY.
  ▶ RULES 1: a check that cannot return a true pass is not a check.

⚠⚠ returnmpreceivelots IS AN EXACT TWIN OF mprrecievelots, COLUMN FOR
  COLUMN, AND IT IS IN NO DOCUMENT. Twenty sessions of quantity work
  never named it. It surfaced only because the return procedure
  happened to be read.
  ▶ A ROUTINE SURVEY FINDS ONLY WHAT A PROCEDURE REFERENCES. THAT IS
    WHY THE SCHEMA PASS EXISTS. It found five more unnamed tables.
  ⚠ TWO OF THOSE FIVE - rejectedmaterial and rejectedproduct - ARE
    EMPTY ON BOTH BOXES. The pre-merge design, superseded by
    rejectmaterialandproduct. Retirement question with P109, not
    campaign work.
  ⚠ JR15 ALREADY NAMED BOTH WRITE OBJECTS - REJPRODOBJ and REJMATOBJ -
    AND NEVER NAMED THE TABLES THEY LAND IN. A DOCUMENT CAN NAME A
    THING AND STILL LEAVE IT UNFINDABLE.

⚠⚠ THE TWO WORST FINDINGS CAME FROM ONE TEST, NOT FROM READING.
  A ten-minute material return on dev produced both:
  (a) THE PRODUCT-RETURN LOT PICKER IS EMPTY. 3.32 Kg demonstrably in
      store on receiveproducts row 11425; the picker offered nothing.
      ▶ THE PRODUCT-RETURN PATH HAS NEVER RUN BECAUSE IT CANNOT BE
        RUN. Not "nobody did one". -> P163.
      ⚠ FOURTH INSTANCE OF THIS SHAPE - J86's commented-out Add-DO
        button, J92's Remove button that removed nothing, P142's
        commented-out MR buttons, and this.
  (b) Formulations.js ADDS THE RETURN INTO THE RELEASED TOTAL, in all
      three branches. returnSum is declared and never assigned, so
      Returned Qty always reads 0.
      ▶ RETURNING MATERIAL MAKES THE SCREEN SHOW MORE RELEASED.
      ⚠⚠ LIVE ON BOTH CLIENTS TODAY. -> P164.
      ✓ MLOManagement.js does the identical job CORRECTLY. THE PROOF
        IT IS WRONG IS IN THE OTHER FILE.
  ▶ RULES 1 IS RIGHT. REPRODUCE FIRST. J109 cost four hours learning
    this; S108 earned it back in ten minutes.
  ✓ THE MATERIAL RETURN PATH ITSELF IS PROVEN CORRECT - Ginger Powder
    9294.861 -> 9296.861 Kg, +2 exactly.

THE FIXTURE, BUILT BY MINTY, COMPANY 474 ON DEV
  IP-0.37      FO-0004  0.37 Kg/unit  19 shipping units per batch
  Parent-0.53  FO-0005  0.53 Kg/unit  13 shipping units per batch
               Pouch / Carton 3 / Case 7 / Pallet 9
               Recipe: Ginger Powder 1302.21 Kg + IP-0.37 9 units
  MO-0003  41 units, COMPLETE.  MO-0004  23 pallets, NOT RELEASED.
  ⚠ 19 AND 13 ARE BOTH PRIME AND SHARE NO FACTORS, so nearly any MO
    quantity produces a repeating decimal. TRAPS 9: a round ratio
    hides a division entirely. THAT IS WHY THOSE NUMBERS.
  ⚠⚠ IT EXPOSED THE BUG BEFORE ANY CODE CHANGED. On MO-0004:
      Plan Quantity      23.000# (2303.910 Kg)
      Ginger Powder req.          2303.609 Kg
    0.301 Kg APART, ON THE SAME PAGE, FROM THE SAME RECIPE. One uses
    the MO quantity; the other uses the stored rounded batches 1.769.
    True factor 23/13 = 1.769230769...
  ⚠ AND MO-0003 ALREADY BANKED ONE: released 15.171 Kg against a true
    requirement of 15.170.
  ⚠⚠ THE CONTROL - Pouch 4347.000 Ea = 23 x 9 x 7 x 3, from the MO
    quantity. IT MUST NOT MOVE AT ANY STEP OF THE FIX. If a packaging
    figure shifts, THE FIX IS WRONG, NOT THE DATA.
  ▶ MO-0004 IS THE BEFORE PICTURE. DO NOT RELEASE IT.

MINTY'S RULINGS, S108 - BOTH CHANGE RULES 7
  1  THE FOUR SOURCES. ING-REQ · PK-CASCADE · STOCK ON HAND ·
     PRD-TO-DATE. The old rule had THREE and its first source fused a
     recipe requirement with the packing cascade - which describes
     packaging correctly and a recipe requirement not at all.
     ▶ THAT FUSION IS WHY THE INTERMEDIATE ROUTE HAD TO BE DERIVED
       FROM SCRATCH IN S108 INSTEAD OF READ OFF THE RULE.
  2  THE REQUIREMENT IS COMPUTED LIVE:
       quantity per batch x (MO shipping units / units per batch)
     ⚠ NEVER mlomanagement.batches - that sum, already rounded.
     ⚠ WORKED EXAMPLE, MINTY: a batch needs 0.5 units of the IP and
       makes 6 shipping units. The MO is 7. 7/6 x 0.5 = 0.5833 units.
       THE MO IS A SCALED-UP BATCH; SCALE BY THE SAME FACTOR.
     ⚠ FRACTIONAL IS CORRECT. Round to three decimals FOR DISPLAY
       ONLY - full precision in the calculation and in storage.
     ⚠⚠ THIS APPLIES TO INGREDIENTS TOO AND THEREFORE SUPERSEDES THE
       S105 RULING that the rounding variance is accepted. RULES 7
       stated that ruling in plain words and was rewritten whole.
     ⚠ PAST MOs WILL SHOW A REQUIREMENT DIFFERING SLIGHTLY FROM WHAT
       WAS RELEASED. THE RELEASE ROWS STAND - Minty's S106 ruling, a
       figure recording what physically happened is not a wrong row.
       SOMEBODY WILL NOTICE AND ASK.

⚠ CLAUDE DECIDED A SCOPE BOUNDARY THAT WAS MINTY'S TO DECIDE. After
  the frontend file list came back Claude wrote "we do not need to
  survey all 49" and moved on - on a day whose whole lesson was that
  partial coverage is how things get missed. MINTY CAUGHT IT AND THE
  SURVEY WAS FINISHED.
  ▶ A BOUNDARY IS A RECOMMENDATION, NOT A STEP. PUT IT TO MINTY.

RAISED BY THIS SURVEY: P158 P159 P160 P161 P162 P163 P164 P165 P166
  P167. CLOSED BY IT: P104 (a usable fixture now exists on 474) and
  P150 (the survey itself).
BLAST RADIUS: none. No code, no prod touch, no schema change. Dev
  fixture residue on 464 (a 2 Kg return, KEEP - it is P164's fixture)
  and on 474 (the whole IP set, KEEP).
========


END S108 APPEND

S109 - APPENDED 8 AUG 2026
NUMBERING: highest existing entry is J118. This is J119. Highest JR was
JR18; the view change below is JR20 - see the note. No JT entry.

⚠ HEADER TO CORRECT IN THIS COMMIT: Section 5's own header reads
"Highest is J118 ... Highest JR is JR18. Last appended: S108, Aug 7
2026." After this commit it is J119 / JR20 / S109, Aug 8 2026.


JR20. Trace_ProductHeaderView - qty_misc_release_su reads the stored
     unit count, and the mr CTE gains a type guard  [P135, S109]

     ⚠ NUMBERED JR20, NOT JR19. JR19 IS DELIBERATELY UNUSED. The next
       reader will look for a JR19 and there is none - this note is why.
       ⚠ IF A JR19 IS EVER WRITTEN IT MUST NOT BE THIS OBJECT.

     THE VIEW HAD THREE DIVISIONS AFTER S107 (JR18). THIS REMOVES ONE.
     TWO REMAIN - intermediate_prd_su and SOH_su - and both are blocked
     on the STEP 5 schema change, not on anything here.

     THE CHANGE, two parts, and they must land together:

     1  The misc_release CTE gains a unit sum AND a type filter:
          coalesce(sum(`rmp`.`qty_rejected`),0) AS `qty_misc_release`,
          coalesce(sum(`rmp`.`qty_rejected_units`),0)
            AS `qty_misc_release_units`
          from `rejectmaterialandproduct` `rmp`
          where (`rmp`.`type` = 'Product')
          group by `rmp`.`mlc_id`

     2  The final_results expression stops dividing:
          coalesce(`mr`.`qty_misc_release_units`,0) AS `qty_misc_release_su`
        WAS:
          coalesce((`mr`.`qty_misc_release` / `fop`.`wgt_kgs_per_unit`),0)

     ⚠ THE CTE READS `rejectmaterialandproduct` DIRECTLY WITH NO JOINS,
       so qty_rejected_units (JR15) was already in scope. No new join.

     ⚠ THE TYPE GUARD CHANGES NOTHING TODAY AND IS NOT DECORATION.
       Material MRs carry NO mlc_id, so they group under NULL and the
       outer `left join misc_release mr on mm.id = mr.mlc_id` never
       matches them. They were excluded BY THE DATA, not by any filter -
       the J74 shape. The guard makes the intent explicit so a future
       reader cannot "tidy" the join and silently pull material weights
       into a product unit figure.

     ⚠⚠ WHAT THIS TRADED, AND IT IS THE PART TO READ BEFORE JUDGING A
       FIGURE. The old division was ARITHMETICALLY CORRECT. It swaps
       "derived but correct" for "stored but incomplete" on any MR row
       written BEFORE JR15 landed in S103 - those rows never stored a
       unit count, so they hold 0.
       PROVEN ON DEV: MO-0001's 41.7 Kg cell went 5 -> 3. Two MR rows on
         mlc_id 11809 - 16.68 Kg with units 0, and 25.02 Kg with units 3.
         The true total is 5. THE VIEW NOW READS 3 AND IS WRONG THERE.
       ⚠ THIS IS EXACTLY WHAT JR18 PREDICTED and it is why S107 left
         this cell alone. It was shipped anyway because MEASUREMENT
         showed no client row can be affected - see the gate below.
       ⚠ THE SYMPTOM IS VISIBLE IN THE APP TOO: dev MR-0007 renders
         "0# (16.680 Kg)" on the MR list. -> P170.

     THE GATE, MEASURED ON PROD BEFORE ANY WRITE - and it is the whole
     reason this was safe to ship:
       471 GLUTENULL    ZERO MR rows of any type.
       469 HAGENSBORG   24 rows, ALL Material, ALL with mlc_id NULL.
                        Already 0 before, still 0 after.
       464 sandbox      3 Product rows, all units 0. THE ONLY ROWS THAT
                        MOVED, and Minty ruled sandbox accuracy does not
                        matter.
     ⚠ THE FIRST VERSION OF THAT QUERY FILTERED type='Product' AND WOULD
       HAVE HIDDEN HAGENSBORG ENTIRELY. Minty caught it and asked for
       both clients by name. A GATE THAT CANNOT SHOW THE THING IT IS
       GATING IS NOT A GATE.

     BACKUPS - ⚠ CAPTURED FRESH. The S107 .bak files hold the
       SIX-division version and were useless here.
         /home/ubuntu/Trace_ProductHeaderView.bak-S109-DEV.txt
         /home/ubuntu/Trace_ProductHeaderView.bak-S109-PROD.txt
       BOTH 6193 bytes, 3 slashes, 22 joins - BYTE-IDENTICAL, as JR18
       recorded them before S107.
     Applied via: /home/ubuntu/fix-header-view-S109.sql        (dev)
                  /home/ubuntu/fix-header-view-S109-PROD.sql   (prod)
     Recreated WITHOUT the DEFINER clause. It was `admin`@`%`.
       ⚠ `SQL SECURITY DEFINER` IS A DIFFERENT CLAUSE AND STAYS. A grep
         for "DEFINER" returns 1 on a correct file; grep for "DEFINER="
         must return 0. S109 nearly stopped on that false alarm.

     METHOD - JR16's, on each box from its OWN backup:
       1  SHOW CREATE to a .bak file. Verify bytes, slashes, joins.
       2  Build the new object ON THE BOX by node script. Both anchors
          asserted to appear EXACTLY ONCE; slash count asserted to fall
          by exactly one; join count asserted to HOLD at 22. The script
          refuses to write if any assertion fails.
       3  Apply with `mysql abletracelab_live < file`.
       4  Read the slash and join counts back OUT OF THE DATABASE.
       5  Query the fixture against a baseline captured BEFORE the write.
     NO VIEW TEXT EVER TRAVELLED THROUGH SSH.

     VERIFICATION IS ARITHMETIC AND IT IS THE WHOLE GATE:
         mysql abletracelab_live -e "SHOW CREATE VIEW
           Trace_ProductHeaderView\G" | grep -o "/" | wc -l
       6 = pre-S107 . 3 = post-S107 . 2 = post-S109 . 0 = P135 complete.

     PROVEN, PROD, GLUTENULL - and NOTHING MOVED, which is the pass
       condition on a round ratio:
         MO-0001  qty_produced_su 1750 . SOH_su 1750
         MO-0002  qty_produced_su 802
         qty_misc_release_su 0 on every client row, before and after.
       Screen: Edit-Mlc and the yield dialog both read
         1750.000# (560.000 Kg). Glutenull is 0.32 Kg per unit, so the
         old division landed EXACTLY. ⚠ THE FIX IS INVISIBLE ON PROD BY
         DESIGN. It was only provable on dev's 0.37 and 0.7 fixtures.

     P136 STANDS: the view still returns DUPLICATE ROWS. Pre-existing,
       not caused by and not fixed by this change.
     Applied to BOTH boxes 8 Aug 2026.


J119 - S109. FOUR REPOINTS, THE DISPATCH WRITE AND THE VIEW. AND THE
SURVEY WAS WRONG IN BOTH DIRECTIONS. STATUS: CLOSED. Frontend commits
281e8bd8 and f4c98e91, both on both boxes. Database change is JR20.

⚠⚠ THE OUTPUT IS NOT IN THIS ENTRY. The map is UNITS-BIBLE.txt/.xlsx.
  This entry records what was learned. 28 green, 16 red, 4 review, of 48.

WHAT SHIPPED
  281e8bd8  four one-line repoints, frontend
              edit-mlc.ts:298, edit-mlo.ts:251, start-mlc.ts:155
                -> mlcDetails.received_units
              formulation-edit-stock-info.ts:269
                -> formulation.inventory_units, UNITS HALF ONLY
  f4c98e91  add-dispatch-v2.ts:183,194 - the dispatch write
  JR20      Trace_ProductHeaderView, both boxes
  ⚠ Prod carries all three. Deployed on a weekend, deliberately -
    Minty's point that nobody is working.

⚠⚠ THE SURVEY WAS WRONG IN BOTH DIRECTIONS, AND THAT IS THE LESSON.
  S108 warned the map would MISS sites. It also MIS-MARKED THREE THAT
  WERE ALREADY FIXED:
    row 26  product-traceability.ts:113 - already reading received_units
            AND CARRYING ITS OWN COMMENT SAYING SO. P118 again.
    row 27  admin-formulation.ts:878 - already reading inventory_units.
    row 21  ⚠ THE INSTRUCTIVE ONE. The map named
            rejected-materials.ts:154 getShippingUnits, which DOES
            divide - AND IS DEAD. Nothing calls it. The LIVE template at
            rejected-materials.html:63 already reads qty_rejected_units
            and is TYPE-GATED so material MRs correctly show Kg alone.
            ▶ AN ADDRESS IS A CLAIM. Confirm the caller, not the code.
  ▶ THREE OF NINE STEP 1 ITEMS NEEDED NO WORK AT ALL. Reading the lines
    before patching them is what found that. Patching first would have
    produced three commits that built clean, deployed clean, and changed
    nothing - the J117 shape.

⚠⚠ "ONE-LINE REPOINT" IS A CLAIM ABOUT A CALL SITE AND SAYS NOTHING
  ABOUT WHAT IT CALLS. Row 25, mfg-lot-codes.html:69, looked identical
  to rows 22-24. It calls getWdu, and getWdu DIVIDES:
      (qty / batch) * (batch / wgt_kgs_per_unit)
  Feeding it the stored count would have divided the COUNT and printed
  a wrong number where a right one stands today. It has six other
  callers and SOME PASS IT THE RIGHT THING (J114: closed-mlcs.html:84
  right, :79 wrong, adjacent lines).
  ✓ THE CORRECT SHAPE IS EIGHT LINES BELOW IT - getPlannedKg:133 takes
    stored units and multiplies, with an S42 comment.
  ▶ READ THE FUNCTION BODY BEFORE CALLING SOMETHING A REPOINT. -> P167.

⚠⚠ ROW 30 WAS A ROUND-TRIP, NOT A DIVISION, AND THAT IS WORSE.
  add-dispatch-v2: the operator TYPES the shipping-unit count into
  qtyWdu - a REQUIRED form field. getQty:101 derives the Kg from it by
  MULTIPLYING, which is correct. Then :194 DIVIDED THAT Kg BACK to
  rebuild the count. The typed number was discarded and reconstructed
  from its own derived weight, then STORED.
  ▶ FIXED: sum qtyWdu across the lots. No division.
  ▶ PROVEN IN THE ROW, NOT ON A SCREEN. Dev 474, IP-0.37 at 0.37 Kg per
    unit: 7 units typed -> 2.59 Kg derived -> packing_units STORED AS 7.
  ✓ PREVENTIVE ON PROD, NOT CORRECTIVE. NEITHER CLIENT HAS EVER CREATED
    A DISPATCH ORDER - all nine on prod are sandbox, all on round ratios
    (100/5, 20/1, 5/1) where the old division landed exactly. NOTHING TO
    HEAL. Measured, not assumed.
  ⚠ J88's FRACTIONAL HAZARD DID NOT APPLY HERE. This line rounds to
    three decimals, not to an integer. The bare Math.round J88 describes
    is create-packslips:246, a DIFFERENT site. PLAN had them conflated.

⚠ THE ENDPOINT NAME LIED AND THE CONTROLLER TOLD THE TRUTH.
  edit-mlo dispatches to `mlo/getMLCbyId`. MLOManagementController:38
  routes that to getMLCbyIdV3 - the modern function - with the old
  getMLCbyId call COMMENTED OUT at :39. The model still holds all three
  versions (V3 at 386, V2 at 424, original at 648).
  ▶ REASONING FROM THE ROUTE NAME WOULD HAVE GOT THIS WRONG. The
    controller is the arbiter. -> P115 for the two dead siblings.

⚠ ROW 23 IS GREEN AND UNPROVEN, AND IT IS RECORDED THAT WAY.
  edit-mlo.ts:251 shipped with the other three and was NEVER SEEN ON A
  SCREEN. /MLO-Management redirects to Mfg-lot-codes under this user's
  roles. It shares getMLCbyIdV3 and WhC_GetMoDetails_SP with rows 22 and
  24, both proven, so the risk is LOW. ⚠ LOW IS NOT PROVEN.
  ▶ FIRST ITEM AT THE NEXT OPEN.

⚠ A GATE THAT CANNOT SHOW THE THING IT IS GATING IS NOT A GATE.
  The first prod MR query filtered type='Product' and would have hidden
  HAGENSBORG - whose 24 rows are the whole reason the gate exists.
  MINTY CAUGHT IT. The corrected query grouped by company AND type and
  named both clients. Same family as RULES 1: a check that cannot return
  the answer is not a check.

⚠ THE LONG HEREDOC TRUNCATED AGAIN. A ~35-line patch script pasted into
  zsh left the shell at `heredoc>` with the terminator lost. Nothing ran
  and nothing was written - the failure was loud. The rewrite was 12
  lines and worked first time. ⚠ SAME FAILURE AS JR16's S104 ATTEMPT,
  which was silent and far worse. ▶ KEEP PASTED SCRIPTS SHORT. Find
  lines by content rather than embedding long literals.

⚠ TWO WRONG-BOX SSH ATTEMPTS, BOTH HARMLESS, BOTH CAUGHT BY THE SAME
  THING: the pem does not exist on the boxes, so the attempt fails
  instead of succeeding somewhere unintended. RULES 2 held.

MEASUREMENTS TAKEN, ALL READ-ONLY
  P161 CLOSED. Row counts on the three uncounted tables:
                          DEV   PROD
    do_receive_products     28      9
    mlodetails              91    129
    forecastsales            0      0
  ▶ forecastsales IS EMPTY ON BOTH BOXES - not a quantity site, unbuilt
    scope, consistent with J53's correction that the forecast explosion
    was never built. IT COMES OFF THE LIST.
  ⚠ mlodetails carries 129 rows on PROD - live client data in a table
    with a quantity column (rcp_qty) that appears in NO map. -> P171.

  THE BASELINE FOR THE REPOINTS, captured BY QUERY before any code was
  written: 23 MOs across companies 464 and 474, received_units compared
  against received_qty / wgt_kgs_per_unit. THEY AGREED ON EVERY ROW.
  ▶ A REPOINT CANNOT BE VERIFIED AGAINST A MEMORY. Measure first.
  ⚠ TWO ROWS IN THAT BASELINE ARE WHY THE WORK MATTERED:
      464 MO-0009  received_qty STORED AS 15.290000000000001
      464 MO-0015  7 / 0.7 = 9.999999999999998 in binary
    Both printed correctly ONLY because every screen rounds to three
    decimals. -> J114: A DISPLAY-ROUNDED SCREEN CANNOT REVEAL A DIVISION.

PREWORK BANKED FOR S110 - ⚠ THIS IS THE POINT OF THE CLOSE
  1  ⚠⚠ THE MULTI-RECEIPT FIXTURE EXISTS. Dev 474 MO-0005, IP-0.37,
     13 units, lot Pdt-260808-1, TWO RECEIPTS of 5 and 8.
     receiveproducts.qty holds 5 and 8 on separate rows; received_units
     totals 13. ⚠ THE TWO ARE UNEQUAL DELIBERATELY - if a fix wrongly
     serves the MO total, BOTH rows read 13 and the error is obvious.
     ⚠⚠ WITHOUT THIS, STEP 3a CANNOT BE PROVEN AT ALL. 474 MO-0003 has
       ONE receipt, so per-receipt and MO-total coincide and a correct
       fix is indistinguishable from the live bug.
     ⚠ Batches reads 0.684 - fractional, because 13/19 does not resolve.
       A SECOND FIXTURE FOR STEP 4 arrived free.
     ⚠ ROW 31 IS ARITHMETICALLY CORRECT ON THIS FIXTURE TODAY. getWdu
       divides each receipt's OWN Kg: 1.850/0.37 = 5, 2.960/0.37 = 8.
       THE DEFECT IS THE ROUTE, NOT THE NUMBER. Do not expect the screen
       to look broken.
  2  P147 CLOSED. Dev 474 MR-0009, Ginger Powder, 10 Kg, reason Sample.
     Stock moved 9806.983 -> 9796.983 Kg, exactly 10 down.
     ⚠ It renders as "10.000 Kg" with NO unit count - correct, because
       it is a Material. The type gate on the MR list, working.
  3  BOTH STEP 3 PROCEDURES READ IN FULL. -> see PLAN. Neither needs a
     new join; both need columns added to a SELECT list only.

FIXTURE RESIDUE ⚠ DEV ONLY, KEEP ALL OF IT:
  474  MO-0005 (the multi-receipt fixture), MR-0009, DO-0002 (7 units,
       the row 30 proof), and the whole IP set including MO-0004 which
       MUST NOT BE RELEASED.
  464  the two returns on MO-0002 and the one on MO-0011 (P164/P168).
BLAST RADIUS: dev and prod both carry the frontend and the view. No
  schema change. No data healed. No client figure moved.
========

END S109 APPEND
S110 - APPENDED 9 AUG 2026
NUMBERING: highest existing entry is J119. This is J120. Highest JR was JR20;
the procedure change below is JR21. No JT entry - TRAPS.md is the traps file
and it is not extended by this session.

⚠ HEADER TO CORRECT IN THIS COMMIT: Section 5's own header reads
"Highest is J119 ... Highest JR is JR20. Last appended: S109, Aug 8 2026."
After this commit it is J120 / JR21 / S110, Aug 9 2026.


JR21. WhC_GetMoProductReceivingDetails_SP - returns receiveproducts.qty,
     the PER-RECEIPT unit count  [P157, S110]

     ONE COLUMN ADDED TO THE SELECT LIST, immediately after recieved_qty:
       `receiveproducts`.`qty`,
     NOTHING ELSE. Same 2 joins, same WHERE, same signature, same
     parameter (IN mlcId varchar(100)).

     IF MISSED: the MO detail receiving panel has no unit count to read and
     the frontend must divide recieved_qty by fopackaging.wgt_kgs_per_unit.
     That division is ARITHMETICALLY CORRECT - it divides each receipt's
     OWN Kg - so nothing looks broken. It is the ROUTE that is wrong.

     ⚠ NOTE THE SCHEMA MISSPELLING. The Kg column is `recieved_qty`, not
       `received_qty`. Any anchor must use the misspelling exactly.

     ⚠ THE PROC STILL SELECTS fopackaging.wgt_kgs_per_unit. Left there
       DELIBERATELY - minimum change, and removing it alters the row shape
       for no benefit. The ingredients for the old division remain served;
       nothing calls for them.

     BACKUPS - captured fresh, BEFORE the write, on each box:
       /home/ubuntu/WhC_GetMoProductReceivingDetails_SP.bak-S110-DEV.txt
       /home/ubuntu/WhC_GetMoProductReceivingDetails_SP.bak-S110-PROD.txt
     BOTH 956 bytes, 2 joins - BYTE-IDENTICAL across the two boxes, the
       same as the view was before S107 and S109.
     SHOW CREATE text, NOT runnable. Add the DELIMITER $$ wrapper to
       restore. Same shape as JR16, JR17, JR18, JR20.
     Applied via: /home/ubuntu/fix-recv-S110.sql        (dev)
                  /home/ubuntu/fix-recv-S110-PROD.sql   (prod)
     Recreated WITHOUT the DEFINER clause. It was `admin`@`%`.
       ⚠ grep "DEFINER=" must return 0. grep "DEFINER" returns 1 on a
         correct file because SQL SECURITY DEFINER is a different clause.

     METHOD - JR16's, on each box from its OWN backup:
       1  SHOW CREATE to a .bak file. Verify bytes and join count.
       2  Build the new object ON THE BOX by a 14-line node script. The
          anchor asserted to appear EXACTLY ONCE; join count asserted at 2
          before AND after; DEFINER= asserted absent. The script refuses to
          write if any assertion fails.
       3  cat the built file and READ IT before applying.
       4  Apply with `mysql abletracelab_live < file`.
       5  Read the new column and the join count back OUT OF THE DATABASE.
       6  CALL the proc against the fixture.
     NO PROC TEXT EVER TRAVELLED THROUGH SSH.

     VERIFICATION, out of the database on each box:
       SHOW CREATE PROCEDURE ... | grep -o "receiveproducts\`.\`qty" | wc -l
         → 1
       ... | grep -o "join" | wc -l  → 2
     ⚠ THE FIRST PATTERN CANNOT MATCH recieved_qty - that column is
       `recieved_qty`, with the backtick in a different place. So 1 is the
       new column, not a false hit.

     PROVEN BY CALL, dev, mlc_id 11813 (474 MO-0005):
       id 11450  recieved_qty 1.85  qty 5  wgt 0.37
       id 11451  recieved_qty 2.96  qty 8  wgt 0.37
     PROVEN ON SCREEN, dev 474:
       MO-0005  two rows, 5.000# and 8.000#  ⚠⚠ NOT 13 AND 13
       MO-0003  one row, 41.000#  - the single-receipt regression check
     PROVEN ON SCREEN, PROD, THROUGH GLUTENULL'S OWN LOGIN:
       MO-0001  Rec-260723-1  560.000 Kg  1750.000#
       MO-0002  Rec-260723-2  192.480 Kg   802.000#
     ⚠ NOTHING MOVED ON PROD, WHICH IS THE PASS CONDITION. Glutenull is
       0.32 and 0.24 Kg per unit - round ratios where the old division
       landed exactly. THE FIX IS INVISIBLE THERE BY DESIGN.

     THE GATE, MEASURED ON PROD BEFORE THE BUILD WAS DEPLOYED:
       Glutenull MO-0001  qty 1750, 560 ÷ 0.32 = 1750    AGREE
       Glutenull MO-0002  qty  802, 192.48 ÷ 0.24 = 802  AGREE
       Hagensborg         NO ROWS - 13 MOs, none run
     ▶ No client row could move. No heal question arose.

     Applied to BOTH boxes 9 Aug 2026.


J120 - S110. ONE PROC, TWO FRONTEND COMMITS, ONE BACKEND COMMIT. THE BOARD
MOVED BY TWO AND CLAUDE SAID FOUR. STATUS: CLOSED. Frontend 0dad104d and
bc03b22d, backend 9230789, all on both boxes. Database change is JR21.

⚠⚠ THE OUTPUT IS NOT IN THIS ENTRY. The map is UNITS-BIBLE.txt/.xlsx.
  This entry records what was learned. 30 green, 3 part, 11 red, 4 review,
  of 48. ⚠ 44 IS THE CEILING - four rows are review items that close as
  decisions.

WHAT SHIPPED
  0dad104d  edit-mlc.component.html:258 reads item.qty; getWdu:355 DELETED
            because that template line was its only live caller.
            ⚠ THE FUNCTION WAS AT :355, NOT :354. Every document said 354.
  bc03b22d  getFactor() added to edit-mlc, edit-mlo and start-mlc; three
            template call sites swapped from mlcDetails.batches.
  9230789   Formulations.js :1120 and :1150 - both final_qty lines compute
            MO units ÷ batch_qty live, with a zero guard.
  JR21      the receiving procedure, each box separately.

⚠⚠ THE SCOPE WAS WRONG WHEN THE SESSION OPENED, AND READING FIXED IT THREE
TIMES. PLAN called Step 3 four rows - 31, 32, 33, 34 - "one screen, all four
together or none". Reading the code found:
  · ROW 34's ADDRESS WAS WRONG. PLAN said "Formulations.js - serve matList".
    matList is at :891, inside methodForCreateFormula - the create-and-fork
    WRITE path (J81's territory). The real line is :1150, inside
    getFormulaByIdForReleaseMaterial at :1079. ⚠ 450 LINES AWAY, DIFFERENT
    FUNCTION, DIFFERENT PURPOSE. Patching where PLAN pointed would have
    built clean, deployed clean and changed NOTHING - the J117 shape.
  · ROWS 32, 34 AND 36 ARE THE SAME ARITHMETIC, and it is STEP 4's, not
    STEP 3's. All three multiplied by the stored rounded `batches`.
  · ROW 33 SITS ONE LINE BELOW ROW 32 in the same four templates - 172 and
    173. Fixing 33 alone would leave the requirement wrong immediately above
    a corrected stock figure.
▶ STEP 3 SHIPPED AS ONE ROW. Rows 32/33/34/36 moved to their own session.
⚠ CLAUDE RECOMMENDED FOUR SCOPES IN ONE SESSION - four rows, then three,
  then two, then one. Each cut came from reading a line it had not read.
  That is not indecision; it is what the survey being wrong looks like from
  the inside.

⚠⚠ CLAUDE OVERSTATED THE SCOREBOARD AND CAUGHT IT ONLY WHEN BUILDING THE
SPREADSHEET. Mid-session it reported 32 green. Checking each row against
PART 1 rather than against its own summary gave 30, with three rows PART:
  ROW 35 IS GREEN. The ingredient requirement is Kg-anchored BY RULE
    (RULES 7 source 1: quantity per batch takes the basis of the thing
    consumed - Kg for an ingredient). Rounding was its only defect.
  ROWS 32, 34, 36 ARE NOT. The intermediate requirement must take
    subrecipeformulation.ship_qty in UNITS. It still reads .qty in Kg.
    The screen shows 5.892 Kg under a header saying "# (UOM)".
▶ A ROW IS GREEN WHEN IT SATISFIES THE RULE, NOT WHEN IT WAS TOUCHED.
▶ A MOVING NUMBER IS NOT PROOF OF A CLOSED ROW. 5.891 became 5.892 - the
  arithmetic improved and the basis stayed wrong.
⚠ A NEW STATUS, "PART", WAS ADDED TO THE MAP for exactly this. Half a fix
  recorded as whole is how J117 nearly shipped a regression.

⚠⚠ A PROCEDURE'S ALIAS IS NOT ITS COLUMN NAME, AND THE DIFFERENCE IS
SILENT. The live requirement needs shipping-units-per-batch, which is
formulations.batch_qty. WhC_GetMoDetails_SP serves it as
`formula_id__batch_qty` - aliased, like every other formulations column in
that proc. Writing mlcDetails.batch_qty would have yielded undefined, and
qty × undefined is NaN, written into a client-facing requirement figure.
▶ SETTLED BY CALLING THE PROC AND READING THE HEADER ROW, not by reading
  SHOW CREATE. SHOW CREATE says what the proc contains; the CALL says what
  the columns are named on the wire.
⚠ SAME FAMILY AS TRAPS 10. Resolve every name to its definition.

⚠⚠ THE CORRECT SHAPE WAS EIGHT LINES AWAY, FOR THE THIRD TIME.
  Formulations.js:1195 - the packaging cascade - already multiplies by
  mlcDetails.qty, never by batches. That is WHY the Pouch control figure has
  never moved through this whole campaign. The two broken lines sat 45 and
  75 lines above a working example of what they should be.
  ✓ Same pattern as getPlannedKg beside getWdu (S109) and stock-info beside
    formulation-edit-stock-info (J83).

MINTY'S RULINGS, S110
  1  THE NUMBER CHANGE IS ACCEPTED. P162 moves requirement figures on
     screens both clients use. Past MOs will show a requirement differing
     slightly from what was released. THE RELEASE ROWS STAND as the record
     of what physically happened - the S106 ruling, re-affirmed.
  2  ⚠⚠ THE UNITS CAMPAIGN FINISHES BEFORE QUICKBOOKS, NOT IN PARALLEL.
     THE REASON IS COMMERCIAL, NOT TECHNICAL: the clients are new and carry
     almost no data, so schema and anchor changes are cheap NOW and get
     harder as they build history. Step 5's column add touches ZERO client
     rows today. Later it would mean dividing Kg to reconstruct units on
     live rows - the exact round-trip the campaign exists to remove.
     ▶ THIS ALSO RE-FRAMES P170. Healing the pre-JR15 MR rows is cheaper
       now than later, for the same reason.

⚠ RULES 7 NEEDED NO REWRITE. PLAN carried "RULES 7 MUST BE REWRITTEN, NOT
  ANNOTATED" into this session as a precondition for Step 4. Reading RULES
  showed the S108 version ALREADY states the live calculation and already
  says never to read the stored batches column. The precondition had been
  satisfied two sessions earlier and nobody had struck it.
  ▶ A PRECONDITION THAT IS ALREADY MET IS A COST IF IT IS STILL LISTED.

MEASUREMENTS TAKEN, ALL READ-ONLY
  formulations.batch_qty IS THE SHIPPING-UNITS-PER-BATCH COLUMN.
    dev 474: FO-0004 = 19, FO-0005 = 13, matching the fixture exactly.
    prod: Glutenull 240 and 400. ⚠⚠ HAGENSBORG batch_qty = 1 ON ALL 13 MOs.
    A 1:1 ratio, so THEIR MOs CAN NEVER DEMONSTRATE A QUANTITY FIX.
    TRAPS 9, on a live client, permanently.
  THE CLIENT EXPOSURE, MEASURED BEFORE THE WRITE:
    Glutenull MO-0001  1750 ÷ 240 = 7.29166..., stored 7.292  ⚠ MOVES
    Glutenull MO-0002   802 ÷ 400 = 2.005 exactly             EXACT
    Hagensborg all 13   qty ÷ 1 = qty                         EXACT
    ▶ ONE ROW OUT OF FIFTEEN MOVES, BY ~0.005%, DOWNWARD.
  subrecipeformulation.ship_qty: ZERO null-or-zero rows on either box -
    dev 15 rows, prod 10 rows. ▶ THE NEXT SESSION NEEDS NO HEAL.
  ⚠⚠ HAGENSBORG HAS 13 MOs, NOT 7. NOW had said seven since S107. Six more
    were created and nobody re-measured. Still none run.
  ⚠ A QUERY SCOPED TO company_id IN (471,469) WAS RUN ON DEV BELIEVING IT
    SHOWED THE CLIENT EXPOSURE. Dev 471/469 are different companies
    entirely. Caught before it was acted on. → P156, and the rule stands:
    NO COMPANY ID CAN BE REASONED ABOUT WITHOUT NAMING THE BOX.

PROVEN ON SCREEN - THE HEADLINE
  474 MO-0004, BEFORE: Plan Quantity 23.000# (2303.910 Kg) and the Ginger
    Powder requirement 2303.609 Kg. 0.301 Kg APART ON THE SAME PAGE, from
    the same recipe, because one used the MO quantity and the other used
    the stored rounded batches 1.769.
  AFTER: BOTH READ 2303.910 Kg. The gap is gone.
  ⚠ MO-0003's banked over-release also resolved - Ginger Powder 15.171 Kg
    became 15.170, matching what was received.
  ⚠⚠ THE CONTROL HELD AT EVERY STEP. Pouch 4347.000 Ea, Carton 1449,
    Case 207, Pallet 23 - unmoved on dev. On prod, Glutenull MO-0001's
    Clamshell320 went 1750.080 → 1750.000 Ea, resolving EXACTLY to the MO
    quantity, and MO-0002's Clamshell240 held at 802.000 with every one of
    its ten ingredient lines identical to what was released.
  ▶ MO-0002 IS THE BEST CONTROL ON PROD: 802 ÷ 400 = 2.005 exactly, so it
    is ARITHMETICALLY INCAPABLE OF MOVING. It did not move.

⚠⚠ FOUR WRONG-BOX COMMAND ATTEMPTS, ALL FAILED SAFELY, AND THAT IS LUCK OF
ENVIRONMENT RATHER THAN A CONTROL:
    a mysql command at the Mac prompt        - no mysql client
    a second, with a `>` redirect            - ⚠ WROTE A 0-BYTE FILE NAMED
                                               ...bak-S110-DEV.txt
    ls ~/Downloads on prod                   - no such directory
    cd ~/abletrace-lab-backend on the Mac    - repo lives only on dev
  ⚠ THE 0-BYTE FILE IS THE ONE THAT MATTERS. It carried a -DEV name and
    held nothing. If it had reached a box or the repo it would have looked
    like a backup. Deleted immediately. Same family as S109's Downloads
    lesson: a plausible filename with the wrong contents.
  ▶ STEP 5's FIRST LIVE COMMAND IS AN ALTER ON THE CLIENTS' DATABASE. THAT
    ONE WOULD NOT FAIL SAFELY.
  ⚠ ALSO: terminal output and prose were pasted back into the shell twice,
    producing "command not found" bursts. RULES 5.1's exact warning - S106
    records the same thing SILENTLY EATING A git pull.

⚠ A CHECK WHOSE PASS CONDITION WAS NEVER DEFINED IS NOT A CHECK. Claude
  added `curl localhost` (port 80) to the deploy verification. It returned
  404 and was read as a possible failure. RULES' own OPEN block curls
  localhost:1337. The 404 was nginx having no vhost for Host: localhost -
  a perfectly good deploy. The Host-header curl returns 301, certbot's
  HTTPS redirect, on BOTH boxes. ▶ SAY WHAT A PASS LOOKS LIKE FIRST.

⚠ 8 SECONDS WAS NOT ENOUGH AFTER THE PROD RESTART. curl returned 000 on a
  healthy boot. The pm2 MEMORY figure settled it: 21.4mb at the curl,
  158.1mb a moment later. ▶ READ THE MEMORY, NOT JUST THE STATUS. A booted
  Sails on these boxes is ~150mb.

⚠ THE DEPLOY PROCEDURE IS NOT FULLY WRITTEN DOWN. `unzip` IS NOT INSTALLED
  ON DEV - the artifact had to be extracted with a python3 one-liner. JR14
  records deploy-frontend.sh but not the extraction step, and the script
  takes a DIRECTORY LABEL, not a zip. ⚠ HOW S109's BUILD WAS EXTRACTED IS
  UNKNOWN. → P176.

FOUR SMALL FINDINGS RAISED, NONE ACTED ON:
  P172  receiveproducts.internalCode is NOT unique per receipt - MO-0005's
        two receipts both read Rec-260809-1.
  P173  the Intermediate Products block renders a nameless 0.000 row when a
        product has no intermediates. Seen on dev AND on both prod clients.
  P174  edit-mlc.component.ts:372 writes a form control back into
        mlcDetails.batches - an operator-editable value overwriting a
        derived stored figure on the object the screen reads.
  P175  getFormulaByIdForReleaseMaterial:1092 gates on
        `typeof x != undefined` - typeof returns a STRING, so the gate is
        always true. A gate that cannot fail is not a gate.

FIXTURE RESIDUE ⚠ DEV ONLY, KEEP ALL OF IT: 474's whole IP set including
  MO-0004 which MUST NOT BE RELEASED, MO-0005's two receipts, MR-0009,
  DO-0002. 464's three returns (P164/P168).
BLAST RADIUS: both boxes carry one procedure change, two frontend commits
  and one backend commit. No schema change. No data healed. ONE CLIENT MO's
  requirement figures moved by ~0.005%, downward, knowingly and by ruling.
========

END S110 APPEND

S111 - APPENDED 9 AUG 2026
NUMBERING: highest existing entry is J120. This is J121. Highest JR was JR21;
the two procedure changes below are ONE entry, JR22. No JT entry - TRAPS.md is
the traps file and it is not extended by this session.

⚠ HEADER TO CORRECT IN THIS COMMIT: Section 5's own header reads
"Highest is J120 ... Highest JR is JR21. Last appended: S110, Aug 9 2026."
After this commit it is J121 / JR22 / S111, Aug 9 2026.


JR22. THE TWO INTERMEDIATE PROCEDURES - both now serve
     subrecipeformulation.ship_qty AND formulations.inventory_units
     [P160, S111]

     ⚠⚠ ONE JR ENTRY, TWO OBJECTS, BECAUSE THEY MUST BE APPLIED TOGETHER.
     They feed the two blocks of one screen. Applying one without the other
     leaves the requirement in units above a stock figure in kilograms, or
     the reverse, ONE BLOCK APART on a client-facing page.

     THE TWO OBJECTS, AND THEY ARE NEARLY TWINS:
       WhC_GetMoIntermediateProducts_SP     1279 -> 1408 bytes
       WhC_GetFormulaIntermediateProducts   1149 -> 1236 bytes
     SAME three tables, SAME three left outer joins, SAME WHERE, SAME
     signature (IN formulationId varchar(100)). They differ ONLY in their
     select lists and in their ALIASING.

     ⚠⚠ AND THE ALIASING IS THE WHOLE TRAP. The Mo procedure ALIASES EVERY
       COLUMN; the Formula procedure SELECTS BARE. So the same logical
       column reaches the frontend under two different names:
         Mo proc       `subrecipeformulation`.`ship_qty` as `subrecipeformulation_ship_qty`
                       `formulations`.`inventory_units` as `formulations_inventory_units`
         Formula proc  `subrecipeformulation`.`ship_qty`     (BARE)
                       `formulations`.`inventory_units`      (BARE)
       WRITING A TEMPLATE AGAINST THE WRONG CONVENTION RETURNS undefined,
       WITH NO ERROR. Same family as TRAPS 10 and as S110's
       formula_id__batch_qty.

     NO NEW JOIN ON EITHER. subrecipeformulation and formulations were
     already joined in both. The columns were reachable all along and simply
     were not in the SELECT list. ⚠ SIXTH INSTANCE OF THAT PATTERN in this
     campaign - see also JR16, JR17, JR20, JR21.

     WHICH PROCEDURE FEEDS WHICH BLOCK - ⚠⚠ PROVEN, NOT REASONED, AND THE
     ANSWER IS THE OPPOSITE OF WHAT EARLIER PLANS IMPLIED:
       Mo proc      -> MLOManagement.js:393 -> mlcDetails.intermediateProducts
                    -> THE INTERMEDIATE PRODUCTS BLOCK
       Formula proc -> Formulations.js:1083, inside
                       getFormulaByIdForReleaseMaterial
                    -> matList / formulaList / packList
                    -> THE BATCH MATERIALS BLOCK
     ▶ SETTLED BY READING THE ngFor COLLECTION NAMES IN THE TEMPLATE AND
       THE ALIASED PROPERTY NAMES BESIDE THEM, not by reading the callers.
       A caller tells you which procedure runs; only the template tells you
       which block renders the result.

     IF MISSED: the intermediate requirement reads subrecipeformulation.qty
     - KILOGRAMS - under a header saying "Qty required - # (UOM)", and the
     stock reads formulations.inventory, also kilograms, under "WH Stock in
     # (UOM)". BOTH ARE PLAUSIBLE NUMBERS. Nothing looks broken.
     ⚠ ON dev 474 MO-0004 THE REQUIREMENT READ 5.892 Kg WHERE THE TRUE
       FIGURE IS 15.923 UNITS, and the stock read 17.390 Kg where the
       warehouse holds 47 units.

     ⚠ THE Kg COLUMNS WERE DELIBERATELY LEFT IN BOTH SELECT LISTS. Removing
       them would change the row shape for no benefit and the frontend no
       longer reads them. Same reasoning as JR21's wgt_kgs_per_unit.

     BACKUPS - captured fresh, BEFORE any write, on each box:
       /home/ubuntu/WhC_GetMoIntermediateProducts_SP.bak-S111-{DEV,PROD}.txt
       /home/ubuntu/WhC_GetFormulaIntermediateProducts.bak-S111-{DEV,PROD}.txt
     BYTE-IDENTICAL ACROSS THE TWO BOXES BEFORE THE CHANGE - 1279 and 1149,
       3 joins each. The same pre-condition JR18, JR20 and JR21 all record.
     SHOW CREATE text, NOT runnable. Add the DELIMITER $$ wrapper to restore.
     Applied via: fix-mo-inter-S111.sql / fix-formula-inter-S111.sql (dev)
                  fix-mo-inter-S111-PROD.sql / fix-formula-inter-S111-PROD.sql
     Recreated WITHOUT the DEFINER clause. It was `admin`@`%`.

     ⚠⚠ AND HERE IS A CORRECTION TO HOW JR16's DEFINER RULE HAS BEEN READ.
       JR16 says the object is "recreated WITHOUT the DEFINER clause" and
       that `grep "DEFINER="` must return 0. THAT IS TRUE OF THE BUILT .sql
       FILE AND FALSE OF THE LIVE OBJECT. MySQL ALWAYS records a definer on
       CREATE; with no clause given it assigns the connecting account. So
       SHOW CREATE on a correctly-built procedure returns DEFINER=`admin`@`%`
       and always will.
       ▶ S111 SET THE PASS CONDITION AT 0 AGAINST THE LIVE OBJECT AND IT
         COULD NOT HAVE PASSED FOR ANY PROCEDURE THAT EXISTS. Caught on
         reading the result, not before.
       ▶ THE CHECK BELONGS ON THE FILE. On the database, read
         information_schema.routines and confirm the object EXISTS with a
         SANE definer - and SCOPE IT BY SCHEMA, or the dormant archive's
         copy doubles every row.
       ⚠ A CHECK COPIED FROM ONE LAYER TO ANOTHER STOPS BEING A CHECK.
         Third instance this campaign, after JR7e's schema-less grep and
         S110's bare `curl localhost`.

     METHOD - JR16's, on each box from its OWN backup:
       1  SHOW CREATE to a .bak file. Verify bytes and join count.
       2  Build the new object ON THE BOX by a SHORT node script. Both
          anchors asserted to appear EXACTLY ONCE; join count asserted at 3
          before AND after; DEFINER= asserted absent FROM THE FILE. The
          script refuses to write if any assertion fails.
       3  cat the built file and READ IT before applying.
       4  Apply with `mysql abletracelab_live < file`.
       5  Read the new column and the join count back OUT OF THE DATABASE.
       6  CALL the proc against the fixture and READ THE HEADER ROW.
     NO PROC TEXT EVER TRAVELLED THROUGH SSH.

     ⚠⚠ AN ASSERTION FIRED ON ITS OWN INSERTION - JT27, IN THE SESSION THAT
       HAD JT27 IN FRONT OF IT. The first script demanded `ship_qty` appear
       exactly once. The text being inserted -
       `subrecipeformulation`.`ship_qty` as `subrecipeformulation_ship_qty` -
       CONTAINS IT TWICE. The script threw `ship_qty 2` and REFUSED TO WRITE.
       ✓ THE GUARD WORKED. Nothing was written.
       ▶ ASSERT ON THE ALIAS, WHICH IS UNIQUE (`_ship_qty\``), NOT ON THE
         COLUMN NAME.

     ⚠ THE BACKTICKS ARE LOAD-BEARING IN THE ANCHORS. `formulations`.`inventory`
       cannot match `formulations`.`inventory_units` BECAUSE OF THE CLOSING
       BACKTICK. Without them the anchor would have matched the wrong column
       and the assertion counts would have been meaningless.

     VERIFICATION, out of the database on each box:
       SHOW CREATE PROCEDURE WhC_GetMoIntermediateProducts_SP\G
         | grep -c "subrecipeformulation_ship_qty"     -> 1
       ... | grep -o "join" | wc -l                     -> 3   (both procs)
       SELECT SPECIFIC_NAME, DEFINER FROM information_schema.routines
         WHERE ROUTINE_SCHEMA='abletracelab_live' AND SPECIFIC_NAME IN (...)
         -> TWO ROWS, both admin@%
       ⚠ THE SCHEMA CLAUSE IS NOT OPTIONAL. Without it the dormant
         `abletrace` archive's copies double the result - MEASURED S111 when
         an unfiltered information_schema.parameters query returned every
         routine twice. → P101.

     PROVEN BY CALL, dev, formulationId 3697 (474 Parent-0.53):
       Mo proc       subrecipeformulation_qty 3.33 · _ship_qty 9
                     formulations_inventory 17.39 · _inventory_units 47
       Formula proc  qty 3.33 · ship_qty 9 · inventory 17.39 ·
                     inventory_units 47
       ✓ ADDITIVE ON BOTH - every original column present and unmoved.

     PROVEN ON SCREEN, dev 474 MO-0004, ON BOTH MO DETAIL SCREENS:
       /Edit-MLO  (Sales Controller)      Intermediate Products 15.923 / 47.000
       /Edit-Mlc  (Warehouse Controller)  same, AND Batch Materials 15.923 / 47.000
       ⚠ 15.923 = 9 x 23/13, computed live. It read 5.892 Kg.
       ⚠ 47.000, NOT 41 - stock moved in S109.

     PROVEN ON PROD through GLUTENULL'S OWN LOGIN:
       MO-0001 1750.000# (560.000 Kg) · MO-0002 802.000# (192.480 Kg)
       Batch Materials: Agave 14.583 Kg, Almond Sliced 21.875 Kg, Baking Soda
       2.188 Kg, Brown Rice Flour 72.917 Kg, Buckwheat Cereal 58.333 Kg,
       Citric Acid 0.729 Kg - ALL UNMOVED. Clamshell320 unchanged.
       ⚠⚠ NOTHING MOVED, WHICH IS THE PASS CONDITION. Neither client has any
         intermediates, so both blocks are EMPTY on every client MO and the
         change is INVISIBLE THERE BY DESIGN.
       ▶ THE REAL PROD EVIDENCE IS THAT THE INTERMEDIATE PRODUCTS BLOCK
         RENDERS CLEAN AND EMPTY. Those templates read two property names
         that did not exist on that box an hour earlier. A clean empty block
         is the only proof available that the procedure, the backend and the
         build agree.

     THE GATE, MEASURED IN S110 AND STILL HOLDING:
       subrecipeformulation.ship_qty is populated on EVERY row of BOTH boxes
       - dev 15 rows, prod 10 rows, ZERO null or zero. NO HEAL NEEDED.
       ▶ AND NO TIME WAS SPENT PROVING IT AGAIN. A measurement recorded in
         the right place is a session saved.

     Applied to BOTH boxes 9 Aug 2026.
     ⚠ db-definitions-S93.txt DOES NOT REFLECT THIS. It is now stale on
       EIGHT objects. -> P119.


J121 - S111. TWO PROCEDURES, TWO FRONTEND COMMITS, ONE BACKEND COMMIT. FOUR
ROWS GREEN, THE "PART" STATUS RETIRED, AND A FIFTH SITE FOUND THAT NO ROW
DESCRIBED. STATUS: CLOSED. Frontend 3b176720 and e8e8f572, backend fc78ce1,
all on both boxes. Database change is JR22.

⚠⚠ THE OUTPUT IS NOT IN THIS ENTRY. The map is UNITS-BIBLE.txt/.xlsx.
  This entry records what was learned. 34 green, 0 part, 10 red, 4 review,
  of 48 - plus row 49 awaiting Minty's ruling.

WHAT SHIPPED
  3b176720  six template repoints (edit-mlc, edit-mlo, start-mlc, lines
            172/173 and 200/201) plus edit-mlo.component.ts:557-558, the
            EXPORT. subrecipeformulation_qty -> _ship_qty and
            formulations_inventory -> _inventory_units.
  e8e8f572  three more template lines - the Batch Materials formulaList
            stock cell. ⚠ THE SITE THAT WAS IN NO ROW.
  fc78ce1   Formulations.js:1156 - final_qty scales
            Number(formulation.ship_qty || 0), not formulation.qty.
            Plus one comment line, approved by Minty. -> P118.
  JR22      both procedures, each box separately.

⚠⚠ SIX ADDRESSES WERE WRONG, AND FOUR OF THEM WERE WRONG BY ONE CAUSE.
  Rows 19, 34, 35 and 36 of the bible all named lines that had DRIFTED DOWN
  BY ABOUT SIX - because S110's OWN COMMIT inserted a comment and two const
  lines above them. The documents were written before the code they describe
  and nobody re-read them at that close.
    RECORDED   :1120 ingredients · :1150 intermediates · :1195 packaging
    ACTUAL     :1123 · :1156 · :1201
  ⚠⚠ AND :1150 IS A REAL LINE DOING A REAL, DIFFERENT THING - the
    beforeEditQty pencil-edit restore, which also assigns to
    formulation.qty. PATCHING BY LINE NUMBER WOULD HAVE HIT IT and produced
    a clean build that changed the wrong statement.
  ▶ WHEN A COMMIT INSERTS LINES, EVERY ADDRESS BELOW IT IN EVERY DOCUMENT IS
    STALE. Correct them in the same close.
  ▶ ANCHOR ON TEXT, NEVER ON A LINE NUMBER. The anchor used was
    `formulation.qty * __f`, verified UNIQUE across the file: :1123 uses
    `mat.` and :1201 does not use __f at all.

⚠⚠ AND PLAN'S TWO FRONTEND ADDRESSES WERE WRONG WITH A WRONG INSTRUCTION
  ATTACHED, WHICH IS WORSE THAN A WRONG ADDRESS ALONE. PLAN said
  edit-mlo.component.ts:551 reads `(d.batches || 0)` "where `d` is the FORM,
  not the MO ... IT MUST READ this.mlcDetails".
  READING IT: the line is :557, and `d` IS ALREADY the MO object -
  d.packagingConfiguration and d.intermediateProducts both resolve on it.
  The real defect was narrower and matched the templates exactly: it
  multiplied by d.batches, the STORED ROUNDED column RULES 7 forbids.
  ▶ FOLLOWING THE INSTRUCTION WOULD HAVE REWRITTEN A WORKING REFERENCE.
  ▶ A WRONG REASON ATTACHED TO A REAL DEFECT IS THE MOST EXPENSIVE KIND OF
    DOCUMENT ERROR - it is confident, actionable, and it stops anyone
    looking. Same family as J85.

⚠⚠ A ROW DESCRIBED ONE SITE AND THERE WERE TWO. THIS IS THE FINDING OF THE
SESSION. Bible row 33 named "MO detail intermediate stock". The MO detail
screen shows that figure TWICE - once in Intermediate Products (from the Mo
procedure) and once in Batch Materials (from the Formula procedure, via the
formulaList loop). ROW 33 DESCRIBED ONLY THE FIRST.
  ▶ AFTER 3b176720 DEPLOYED, dev 474 MO-0004 READ:
      Intermediate Products   IP-0.37   47.000
      Batch Materials         IP-0.37   17.390 Kg
    THE SAME PRODUCT'S STOCK, TWO DIFFERENT NUMBERS, ONE BLOCK APART.
  ⚠⚠ THAT IS WORSE THAN THE ORIGINAL DEFECT, WHERE BOTH WERE CONSISTENTLY
    WRONG. A client can act on a wrong number. Nobody can act on two that
    disagree, and on a food traceability screen the disagreement is the
    thing that destroys confidence in both.
  ▶ MINTY'S CALL, MADE IN SESSION: fix it now rather than defer. The column
    was already served by the procedure, the templates were already open,
    and deferring would have promoted the contradiction to prod. RIGHT CALL.
  ▶ THE ALTERNATIVE WAS ALSO CLEAN AND WAS OFFERED: stop, and DO NOT PROMOTE
    - keeping the contradiction on dev only. An honest either/or beats a
    silent half-ship.
  -> BIBLE ROW 49, awaiting Minty's ruling on whether it stands as a row.

⚠⚠ THREE LOOPS, IDENTICAL MARKUP, AND ONLY ONE OF THEM WRONG. The Batch
Materials block renders matList, formulaList and packList with byte-identical
templates. All three read {{getQty(item?.inventory)}}. FOR MATERIALS AND
PACKAGING THAT IS CORRECT - materials are Kg-anchored BY RULE.
  ▶ SO THE ANCHOR HAD TO BE THE BLOCK, NOT THE STRING. The patch split each
    file on the formulaList and packList *ngFor declarations and replaced
    only between them, asserting 3 occurrences in the file before, exactly 1
    inside the block, and 2 in the file after.
  ⚠ A NAIVE REPLACE WOULD HAVE REPOINTED MATERIALS TO A UNIT COLUMN THAT IS
    ZERO FOR THEM. Silent, plausible, and a defect.
  ▶ SAME FAMILY AS J114's closed-mlcs.html :79 wrong / :84 right, adjacent
    lines, same helper.

⚠⚠ AND THE PROOF WAS THE BRACKETING LINES, NOT THE COUNT. Ginger Powder's WH
stock (9796.983 Kg, matList, the line DIRECTLY ABOVE) and Pouch (4347.000 Ea,
packList, directly below) BOTH UNMOVED. They read the same property name from
the same object shape.
  ▶ WHEN A PATCH IS SCOPED TO A BLOCK, THE CONTROLS ARE THE LINES THAT
    BRACKET IT. An assertion count proves a string changed; only the
    neighbours prove it changed in the right place.

⚠⚠ THE FRONTEND REPO EXISTS ON BOTH MACHINES, AND THAT IS THE ONE WRONG-BOX
CASE ENVIRONMENT DOES NOT CATCH. A missed `exit` sent
`cd ~/abletrace-lab-frontend && git status` to DEV instead of the Mac. It
succeeded - dev has that repo, at the stale c2a52d8e checkout NOW records.
  ⚠ READ-ONLY THAT TIME. A patch script would have edited files that the
    NEXT DEPLOY OVERWRITES - no error, no warning, and the screen simply
    never changes. The session would have been spent hunting a phantom.
  ✓ THE OTHER WRONG-BOX ATTEMPT FAILED LOUDLY BECAUSE `hostname -I` IS NOT
    VALID ON macOS. It errored, and the `cd` after it also failed - no
    backend repo on the Mac.
  ▶ `hostname -I` AT THE TOP OF EVERY BLOCK IS A TRIPWIRE THAT WORKS BY
    FAILING. Keep it. S110 logged four wrong-box attempts that all failed
    safely and called that luck of environment; S111 found the case where
    the luck runs out.

⚠⚠ TWO SUPERSEDED BUILD ARTIFACTS WERE DOWNLOADED IN GOOD FAITH AND ONE WAS
OFFERED FOR DEPLOYMENT TO PROD. dist-prod-bc03b22d is a green, real,
complete artifact - AND IT IS THAT MORNING'S BUILD, the code already live.
  ⚠ DEPLOYING IT WOULD HAVE PUT THE OLD FRONTEND BACK while the procedures
    and the backend had already moved forward. The old templates read
    subrecipeformulation_qty, which the procedure still serves, SO NOTHING
    WOULD HAVE BLANKED - but Batch Materials would have shown final_qty
    computed from ship_qty under a Kg-only template. A silent mismatch on a
    client box.
  ▶ READING THE STAMP CAUGHT IT. And the RUN NUMBER is a free second signal:
    31324660398 is lower than 31345895357, therefore older.
  ⚠ J117's DEFENCE IS NOW EXERCISED THREE TIMES. It holds. There are now
    THREE superseded-but-green artifacts in circulation (30b2ddd4, 3b176720,
    dist-prod-bc03b22d) and the only defence is the stamp.

⚠⚠ A CHECK COPIED FROM ONE LAYER TO ANOTHER STOPS BEING A CHECK - see JR22
above for the DEFINER detail. Third instance this campaign.
  ▶ SAY WHAT A PASS LOOKS LIKE BEFORE RUNNING THE CHECK, AND RE-ASK IT WHEN
    THE LAYER CHANGES. Same family as RULES 1 and S110's LESSON 5.

⚠ THE LONG-HEREDOC TRUNCATION HAPPENED A THIRD TIME IN THREE SESSIONS. A
21-line script hung zsh at `heredoc>` with the terminator lost. Nothing ran
and nothing was written - the failure was LOUD. The 11-line rewrite worked
first time.
  ⚠ AND A SEPARATE PASTE ARRIVED ONE CHARACTER SHORT (`--include=*.htm`),
    which zsh refused to glob. Also loud, also harmless.
  ▶ PLAN'S 12-LINE RULE IS NOT A STYLE PREFERENCE. JR16's S104 truncation
    was SILENT and nearly killed a procedure; every one since has been loud,
    and that is luck, not a control.

✓ THE MEMORY FIGURE PROVED ITSELF TWICE IN ONE SESSION. Dev 26.1mb ->
164.6mb and prod 21.4mb -> 156.8mb, both while pm2 reported "online".
  ▶ 15 SECONDS, NOT 8. READ THE MEMORY, NOT THE STATUS. S110 earned this;
    S111 confirms it on both boxes.

⚠⚠ P102's OWN PRECONDITION HAD NEVER BEEN RUN, AND WHEN IT WAS RUN IT CAME
BACK NEGATIVE. The queue item has said "VERIFY PM2 STARTS ON BOOT FIRST" for
sessions. `systemctl is-enabled pm2-ubuntu` on dev returns `not-found`.
  ⚠ THERE IS NO pm2 SYSTEMD UNIT. A reboot would take the app down and
    nothing would bring it back. pm2 save was run and ~/.pm2/dump.pm2 is
    current at 9931 bytes - but a dump is only read by a pm2 that something
    has started.
  ⚠⚠ PROD IS UNMEASURED. Assume the same until proven. A reboot there takes
    TWO LIVE CLIENTS offline with no automatic return.
  ⚠ THIS MAY BE THE MECHANISM BEHIND S105's "dev failed to boot silently".
    ⚠ THAT IS A HYPOTHESIS AND IS RECORDED AS ONE. Do not write it up as
      fact without evidence.
  ▶ MINTY HAD ASKED FOR P102 TO BE DONE THE SAME EVENING AND DROPPED IT ON
    THIS finding. RIGHT CALL - it is not a reboot job, it is a
    startup-configuration job with a reboot at the end. -> P177.
  ▶ A PRECONDITION WRITTEN DOWN AND NEVER RUN IS NOT A CONTROL. If a queue
    item names a check, RUN THE CHECK BEFORE SCHEDULING THE WORK.

MEASUREMENTS TAKEN, ALL READ-ONLY
  THE DORMANT ARCHIVE HOLDS ITS OWN COPIES OF THE STORED PROCEDURES. An
    information_schema.parameters query with no schema filter returned every
    routine TWICE. Nothing was written to the archive. -> P101, and it
    sharpens P134: name the SCHEMA in every information_schema query, not
    just the database on the mysql call.
  formulaList IS BUILT IN THE FRONTEND, NOT HANDED OVER WHOLE.
    edit-mlc.component.ts:243 does `result.formulations.map(data =>
    this.formulaList.push(data))` - no new object, no property reassignment.
    THAT IS WHY final_qty from the backend and inventory_units from the
    procedure both reach the template unchanged.
  DEV'S PENDING UPDATES WENT 8 -> 12 between S110 and S111.
  PROD CARRIES SIXTEEN OLD dist-prod-* FOLDERS, back to 2ae0b4ab, and only
    TWO www-html.bak-*. -> P178.

FOUR SMALL FINDINGS RAISED, NONE ACTED ON:
  P179  start-mlc.component.html:198 reads `formulations_myCodee` - THREE
        E's. Renders blank, silently. One-character fix.
  P180  the build workflow warns Node.js 20 is deprecated and is being
        forced onto Node.js 24. Builds succeed.
  P181  start-mlc.component.html was patched in BOTH commits and was never
        seen on a screen. Byte-identical to two proven templates, which is
        an argument and not a proof. Same shape as S109's row 23.
  P182  three more Intermediate Products controls exist and are in no
        document - edit-mlc:223, edit-mlo:319, edit-closed-mlcs:77.
  P183  the corrected unit figures carry a "Kg" suffix from the product's
        UOM. The number is right and the label is wrong - the reverse of
        where this campaign started.

⚠ NOW's TIDY LIST WAS WRONG AT THE OPEN. S110's NOW named six Mac zips
  including f4c98e91 and 0dad104d pairs to delete; there were THREE and both
  stale pairs were already gone. Somebody tidied and did not record it.
  ▶ READ THE DIRECTORY AT THE CLOSE. Do not copy the previous list forward.
⚠ AND S110's NOW CONTRADICTED ITSELF: its GITHUB block said the docs commit
  had landed while its PENDING PROMOTION block, forty lines lower, listed
  the same files as pending. ▶ RULES 6 - write the GitHub line FROM GITHUB.

FIXTURE RESIDUE ⚠ DEV ONLY, KEEP ALL OF IT: 474's whole IP set including
  MO-0004 which MUST NOT BE RELEASED - Minty asked in S111 whether to run it
  and the answer is no, because the Intermediate Products block renders on a
  CREATED MO and running it would spend the before picture for nothing.
  Also MO-0005's two receipts, MR-0009, DO-0002. 464's three returns
  (P164/P168).
BLAST RADIUS: both boxes carry two procedure changes, two frontend commits
  and one backend commit. No schema change. No data healed. NO CLIENT FIGURE
  MOVED - neither client has intermediates, so the change is invisible to
  them by design.
========

END S111 APPEND
