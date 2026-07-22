══════════════════════════════════════════════════════════════════════
══════════════════════════════════════════════════════════════════════
SECTION 5 — PATCHWORK LOG
Deliberate deviations, DB-only changes not in git, and standing traps.
Structure (rebuilt S72): JT (traps) · JR (rebuild checklist) · J-ENTRIES.
⚠ J holds KNOWLEDGE, not work. Pending work lives in Section 1 (NOW).
Original J-numbers are PERMANENT — never renumber, cross-refs depend on
them. Append new entries at the bottom of J-ENTRIES with the next free
number. Highest is J83 — ⚠ the next one is J84, regardless of how many entries exist (there are original gaps at J8, J30–J31, J54–J59). Last restructured: S72, Jul 16 2026. Last appended: S79, Jul 22 2026.
══════════════════════════════════════════════════════════════════════

TRAPS
──────────────────────────────────────────────────────────────────────
JT — STANDING TRAPS. READ THIS BLOCK EVERY SESSION.
The rules that have bitten more than once. Each names its entry; the
entry holds the evidence. If a rule here contradicts your reasoning,
the rule wins — it was earned.
──────────────────────────────────────────────────────────────────────

JT1. POPULATED FK IS AN OBJECT, NOT A NUMBER.  [J24, J-S69]
    A status/id field read via Waterline populate comes back as an OBJECT
    (.id, .role_name). An object is never === 2. It fails SILENTLY — no
    error, the gate just never fires. Read via a STORED PROC, the same
    field is a BARE NUMBER and ?.id is undefined — also silently false.
    BEFORE comparing any FK to a scalar: confirm the read path.
    Bit twice, 19 sessions apart (mlc_status S50; role_id S69).


JT2. WATERLINE SILENTLY DROPS UNDECLARED COLUMNS.  [J20]
    A column written via .update().set() is DISCARDED with no error unless
    it is declared in the model's attributes block. The DB column alone is
    not enough. Any new column needs BOTH.

JT3. HACCP READS MUST ORDER BY step, NEVER id.  [J4]
    hazardidentification rows insert in PARALLEL, so ids land in completion
    order, not step order (id 1220 = step 10, id 1221 = step 1). The step
    column is authoritative. Any read without ORDER BY step scrambles the
    process flow — and a HACCP doc that reads out of sequence is wrong.

JT4. THE DO ROW MIXES UNITS.  [J15]
    dispatchorders.qty_to_ship = Kg. qty_shipped and packing_units = UNITS.
    Same row. Any calc combining them must convert first. Known fossil,
    retire at Route 6.

JT5. do_status NEVER ADVANCES.  [J-S58 traps]
    dispatchorders.do_status stays "Created" even after a full ship. The
    authoritative shipped state is packingslips.shipped_flag. Never read
    do_status to determine shipped.

JT6. MO CLOSE ≠ MO COMPLETE.  [J28, J-S58 traps]
    Closing sets close_status=1 and LEAVES mlc_status unchanged (commonly
    still 3). Full receipt does NOT auto-close. A filter meaning "still
    open" must test close_status; one meaning "production complete" tests
    mlc_status=4. Different questions.

JT7. EDITS ARE INVISIBLE TO ROW COUNTS.  [J-S58 traps, J82]
    In-place updates (allergen, name, pencil qty, MO status, close_status)
    change no row count. Verify edits by SELECT value comparison, never by
    counting rows.
    ⚠ WORSE THAN INVISIBLE — SOME EDITS PROPAGATE. J82: editing ONE material's
    allergen silently rewrote the allergen shown on SEVEN products and on their
    already-completed production lots, with zero rows added or removed anywhere.
    A row count would have reported "nothing happened".

JT8. NEVER TWO COLLECTIONS IN ONE nestedPop POPULATE ARRAY.  [S55, in git]
    nested-pop v0.1.4 silently returns the SECOND collection EMPTY. Use a
    dedicated second pass and stitch by index. Food-safety-critical when it
    bit (subrecipeformulations vanished).

JT9. THE LIVE PATH IS NOT THE OBVIOUS ONE.  [J12]
    Release runs createReleaseMaterialProductsV2 (bulk loop), NOT the older
    single-release function sitting beside it in the same file. An edit on a
    dead path is an invisible no-op. Trace controller → model → the function
    the button ACTUALLY calls, before editing.


JT10. A BUTTON INSIDE A <form> NEEDS type="button".  [J35]
     No type attribute defaults to type="submit". The implicit submit EATS
     the (click). Any action button inside a form in this app needs it
     explicitly, or the click silently does nothing.

JT11. GUARD JSON-COLUMN READS WITH Array.isArray — NOT a null-check.  [J-S70]
     Under the future mysql2 driver (G0e) a JSON column may return a STRING.
     A string does NOT throw on spread: [..."[\"a\"]"] silently spreads into
     CHARACTERS and corrupts the array with no error. Array.isArray(x) ? x : []
     is correct under both drivers. Every JSON-column read follows this shape.

JT12. THE DB IS GROUND TRUTH. SCREENS LIE.  [J-S70, J13]
     A rendered file chip, a green toast, a loaded page — evidence of NOTHING.
     The PO chip looked identical before and after the fix; the PS chip
     rendered for a file never saved. Product SOH on screen is a live VIEW
     (Trace_ProductHeaderView), not the stored column. Verify the row.

JT13. MEASURE THE BOUNDARY, DON'T REASON ACROSS IT.  [J-S70]
     When behaviour depends on a layer edge — driver / SQL literal parser /
     JSON parser / Waterline populate — TEST IT DIRECTLY with one query before
     changing code. S70: three fixes proposed from confident reasoning about
     MySQL's JSON handling; two wrong, one shipped to prod before disproof. A
     single SELECT settled it in seconds.

JT14. A REVERT IS A TRADE, NOT A FIX.  [J-S70]
     "The state it was in for months" is not evidence it was good — it may be
     differently broken. Reverting 771d775 fixed pasted images and silently
     re-opened the apostrophe bug that commit existed to fix. Before reverting,
     ask what the commit was FIXING. Name both sides out loud.

JT15. A MASK CAN HIDE A BUG FOR YEARS.  [J-S71]
     Removing a mask does not CAUSE the bug it reveals. 771d775 exposed a
     Jun-2023 double-encode; it did not create it. Corollary: "it worked
     before" is not evidence the mechanism was sound.

JT16. GREP THE PATTERN, NOT JUST THE BUG.  [J-S70]
     One bug is usually four. grep "oldFiles" found the identical unguarded
     read in 4 models — one crashed, two were safe only by ACCIDENT OF THEIR
     DATA, one safe by code. Also grep the WHOLE repo before reformatting any
     identity string — something parses it (S65).

JT17. GREP OUTPUT IS A RENDERED SCREEN AND CAN LIE.  [J-S71]
     S71: a missing dot in "datastore.sendNativeQuery" was a terminal PASTE
     ARTIFACT, not a file defect. cat -A on the file settled it. Verify a
     suspected typo against the FILE, never the grep echo.

JT18. WHEN AN ERROR IS HIDDEN, GO TO THE BROWSER CONSOLE FIRST.  [J-S71]
     nginx-level rejections (413/502) NEVER reach pm2 logs — Sails never runs.
     The alert() plague renders every error as "[object Object]". S71 lost ~40
     min extracting one string the Console showed in 90 seconds.

JT19. SOME CODE IS DELIBERATELY WRONG. DO NOT "FIX" IT.
     - J14: PackingSlips.js:333-334 — dead, NaN-producing, stale `elem`,
       wrongly subtracts SOH. Skipped on normal ship. Cut at Route 6, not before.
     - J9: intermediates are NOT imported. Manual entry post-upload, by design.
     - J5: mlcpackaging stores FLAT per-level qtys. The cascade is computed at
       READ time. Do not "correct" it to store multiples.
     - J-S61: the batch_qty pencil-edit block was uncommented deliberately
       (9bce0238), tested, shipped. Do not re-comment.
     - PS/SO create paths seed [] — that is the ONLY reason their reads were
       safe before the guards. Do not "tidy" the seeding away.  [J-S70]

JT20. FILENAMES IN THIS LOG ARE THE REBUILD PATH — AND ONE IS WRONG.
     Every /home/ubuntu/*.sql named in J is the source of truth for a
     re-apply. VERIFIED S72 against the prod box: the S43 view backup is
     `Trace_ProductProdLotView.bakS43.sql` — NO DOT before S43, unlike every
     other file. The S43-end Section G recorded it with a dot; G was wrong.
     Trust the box, not the doc.
     ⚠ /home/ubuntu is NOT backed up off-instance. See J-S72a.
     
JT21. ⚠ NEVER VERIFY A CONVERSION PATH WITH A 1:1 FIXTURE. A weight ratio
      of exactly 1 makes a division invisible — 10 / 1 = 10 reconciles
      perfectly whether the code divides or reads the stored value. Pick a
      product whose wgt_kgs_per_unit is NOT 1, and ideally not round.
      (S79 — a 1:1 test in S78 produced a confident wrong conclusion that
      became a documented finding. J83.)
──────────────────────────────────────────────────────────────────────
REBUILD

──────────────────────────────────────────────────────────────────────
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

──────────────────────────────────────────────────────────────────────
⚠ JR — THE STANDING RISK
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
──────────────────────────────────────────────────────────────────────
END SECTION J
────────────────────────────────────────────────────────────
