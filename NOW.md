# NOW

Last rewritten: S91, 28 July 2026.
The only file that changes each session.

---

## HANDOVER

```
THE GOAL      MINTY'S RANKING, SET S91: PRINTER first — finish the
              client instructions, Mac then Windows, then into the
              help-guides set. ACROBATICS second — the units/Kg divide
              sweep. Everything else is below the line.

PASTE LIST    RULES.md + NOW.md + TRAPS.md + Section_3B.md
              PLUS the two S91 files, which live outside git until
              committed:
                zebra-printer-setup-mac.md   client procedure + tests
                S92-opening-note.md          the brief
              ⚠ IF THOSE TWO WERE NOT SAVED, THE PRINTER WORK IS GONE.

FIRST THREE   1  Confirm the two S91 files exist. Commit them into the
ACTIONS          docs repo so they stop living in a chat.
              2  PRINTER. Fold in the second-Mac results if Minty has
                 run them. The one answer that changes the document is
                 COLD BOOT BLINDNESS — see below.
              3  ACROBATICS. Commit the map off dev FIRST (it sits in
                 /home/ubuntu, which is not backed up — P16), then
                 scope from it.

⚠ RULES OPEN  Still not pasteable (P68, carried again). Use the
BLOCK         corrected six commands at the FOOT OF TRAPS.md.
```

---

## THE PRINTER — S91's main work

```
THE CHAIN     browser → Browser Print → printer over USB.
              macOS IS NOT IN IT. The Zebra does not appear in
              Printers & Scanners and MUST NOT be added. → P77

PROVEN S91, ON THE BOX. Do not re-derive.

· The certificate is the WHOLE barrier. Accepting it took Safari from
  "cannot connect" to working, nothing else touched.
· The exception is PER BROWSER and PER USER ACCOUNT. No admin password.
  Chrome working does nothing for Safari. → TRAPS
· It SURVIVES a full browser quit, and survives a restart.
· Auto-start works. LaunchAgent ~/Library/LaunchAgents/
  com.zebra.browserprint.plist, RunAtLoad true. Confirmed by restart —
  fresh PIDs, nothing opened by hand.
· ⚠ NO KeepAlive. Dies mid-shift → stays dead until next login.
  Proven: killed it, it stayed dead.
· ⚠ ~40 SECONDS after login before it answers. Login 10:08:37, java
  process 10:09:16. Printing fails in that window with nothing wrong.
· The certificate is GENERATED LOCALLY at install, NOT shipped by
  Zebra. App bundle built Feb 2023; certificate issued 30 May 2026, the
  SAME SECOND as the LaunchAgent file. → P78 CLOSED, safe to trust
  machine-wide if ever needed.
· ⚠ REINSTALL OR UPGRADE makes a new certificate — every browser
  exception on that machine breaks at once. → TRAPS
· Version 1.3.2.489. Fingerprint on Minty's Mac:
  65:BA:58:3E:1D:71:75:64:D4:C2:D9:A9:3F:33:B6:50:
  A7:2C:11:12:BB:8A:1E:01:CA:4E:AB:39:07:A8:B1:C9

⚠ COLD BOOT BLINDNESS — SEEN ONCE, UNEXPLAINED, THE OPEN QUESTION.
  After a FULL RESTART, Browser Print came up RUNNING BUT BLIND: it
  returned {} while macOS listed the printer perfectly (system_profiler
  showed manufacturer, model, ZPL, drawing power). A manual relaunch
  fixed it instantly.
  ⚠ A LOGOUT/LOGIN did NOT reproduce it — printer seen normally.
  ⚠ Once running it DOES track unplug and replug with no relaunch,
  proven by cable pull. So the fault is in how it STARTS, not in
  rescanning.
  ⚠ DO NOT WRITE A CAUSE. The USB-not-ready-at-boot idea is a
  hypothesis and nothing more. Minty's Zebra sits behind an Apple
  USB-C Multiport Adapter — if the second Mac connects DIRECT and this
  does not reproduce, the hub is the suspect.

⚠ NEVER WALKED FROM NOTHING. Minty's copy was RECONFIGURED 30 MAY 2026
  — an event that appears NOWHERE in the record. Install steps have
  never been tested from a clean machine. That is what the second Mac
  is for.

⚠ CORRECTION OWED TO S90'S READING. S90 recorded that two things were
  changed before printing worked and the cause was unknown. Settled
  S91: the port-9100 kill was NOT it — that process IS Browser Print
  (→ TRAPS). The certificate was the barrier. BUT the kill-and-reopen
  was probably not useless either: it would have cleared an empty
  device list. TWO faults, one fix each.
```

---

## COMMITS — S91, frontend, DEV AND PROD

```
275c0250   P63. Revert of 734f3305 — the four S87 diagnostic
           console.log lines out of onScan. One file, 11 deletions,
           clean revert, no conflict (822fa248 touched a different
           file). Verified: only the line-133 COMMENT survives, and
           the five other console.log lines in that file are
           PRE-EXISTING, unchanged before and after → P79.

PROMOTED   dev  serving dev-275c025039d7
           prod serving prod-275c025039d7   ⚠ GLUTENULL IS ON THIS
           Scan-to-select verified on dev by SCANNER after the rebuild;
           DO-0010 and DO-0011 both moved on one scan, quantity read
           1# (1.39 Kg) on the non-1:1 fixture (R1 intact).
           Prod verified: accounts open, app loads.
           ⚠ P72 (barcode fix, 822fa248) AND P7 scan-to-select
           (26123e0a) BOTH REACHED PROD IN THIS PROMOTE. They could not
           be separated — prod was four commits behind.
           ⚠ THE ADDRESS LOCK IS STILL UNTESTED and is now on a live
           client. It only fires if someone SCANS in that popup;
           clicking is the unchanged path.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev
          frontend HEAD 275c0250, serving dev-275c025039d7
          backend HEAD 13e3fcd
          Rollback: /home/ubuntu/www-html.bak-dev-275c025039d7
PROD      15.157.38.101 · pm2 abletrace-backend (336 restarts) · Glutenull
          backend HEAD 13e3fcd — identical to dev
          SERVING prod-275c025039d7
          Rollback: /home/ubuntu/www-html.bak-prod-275c025039d7
          ⚠ THAT BACKUP HOLDS THE OLD BUILD, NOT THE NEW ONE. The
          backup is named after the build that REPLACED it. → TRAPS
          ⚠ Prod was found serving 8997acdcf4ab from 26 JULY — a deploy
          NO DOCUMENT RECORDED. Discovered only by reading the backup
          directory. → P81
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026 · certbot timer
          healthy, ran 11h before S91 close, next in ~2h.
          ⚠ SEE P74 — THE OLD FRAMING WAS WRONG.
DOCS      Mintygadhok/abletrace-lab-docs
ACROBATICS MAP
          /home/ubuntu/acrobatics-map-S91.txt ON DEV. 157 lines.
          ⚠ NOT BACKED UP (P16). COMMIT IT EARLY IN S92.
```

---

## THE ACROBATICS SWEEP — recovered, re-entered as P82

```
⚠ THIS ITEM WAS LOST IN THE S74–S79 DOC RESTRUCTURE. It ran across
  S40–S43 as P1b, "finish the batch_qty display-tail sweep", and is
  absent from every current document. Recovered S91 by searching past
  sessions. Minty's #2 priority.

THE MAP       48 files, 154 hits: frontend .ts + .html + backend api.
              Full list in the map file on dev.

⚠ 48 FILES IS THE SEARCH SPACE, NOT THE DEFECT COUNT. Reading
  wgt_kgs_per_unit is CORRECT wherever Kg is derived (units × weight =
  R1). Only DIVISION is suspect, and only where the divided field is
  units-stored.

⚠ 14 HTML FILES carry it. Templates were suspected in S41 and NEVER
  CHECKED. Most likely place for survivors.
⚠ BACKEND api: only 1 hit — but S43 proved real bugs lived in DB VIEWS
  AND STORED PROCS, which no file grep reaches. Needs the temp .my.cnf
  (3B.3).

TOP FILES     13  edit-formulation.component.ts  ← probably legitimate,
                  it is where per-unit weight is set. Confirm and strike
                  it off EARLY so it stops distorting the estimate.
               6  edit-mlc · edit-packslips · add-new-formulation
               5  select-material · mlo-list(.ts+.html) ·
                  edit-quantity-info · add-dispatch-v2 ·
                  production-controller · admin-formulation
               4  add-dispatch · mfg-lot-codes · receive-product ·
                  product-traceability · material-traceability-details ·
                  start-mlc · edit-sales-order · mlo-management ·
                  edit-mlo · add-mlo.component.html

⚠ TWO PATTERNS (S41) — the judgment that cannot be greped:
  PATTERN X   qty / wgt                             → bug if units-stored
  PATTERN Y   (qty / batch_qty) × (batch_qty / wgt) → batch_qty cancels
  ⚠ S43 DISPROVED "the rest are all Pattern Y". It found real bugs in
    the lot-code list path AND in a stored proc. VERIFY EACH ON SCREEN.
    DO NOT BLANKET-EDIT.

RELATED       add-mlo appears in both .ts and .html, and add-mlo.ts:204-205
              IS DEFECT 1 (stores 50.004 instead of 50). Likely the same
              problem. The three open defects below belong to this
              family and should be scoped together.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items go at the bottom
with the next free number. Claude never renumbers.

```
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P42   Section 5 restructure. Minty to confirm closed — see P67 first.
P58   ⚠ FIRED TWICE MORE IN S91. Dev remotes still prompt for the PAT.
      ▶ Reset both remote URLs. Minutes. Worth ranking up — it costs a
      manual paste at exactly the wrong moment every time.
P59   Prod pm2 restart counter 336 vs dev's 33. Still not read.
P60   DO picker popup HEADING never renamed. Last remnant of P7.
P62   qty_shipped must never be NULL. Count both boxes, heal to 0,
      ALTER NOT NULL DEFAULT 0, check the Waterline model, and check
      soproducts.quanity_shipped_to_date and packingslipdos.shipped_qty.
P63   ✅ CLOSED S91. Diagnostic logging out (275c0250), built,
      promoted to dev AND prod, verified by scanner.
P64   Product label prints the string "null" for Ext ID, twice.
      CONFIRMED S90 on a physical label. Customer-facing. ⚠ NOW ON PROD.
P65   promote.sh runs plain scp and ssh with no -4. Works today only
      because the Mac resolves v4.
P66   ✅ CLOSED S90. Confirmed a third time S91.
P67   ⚠ SECTION 5 CANNOT BE DELETED YET. JR REBUILD BLOCK and the
      RECONCILE ORACLE SQL must be extracted first. P20, P22, P42 wait.
P68   ⚠ STILL OPEN, CARRIED FROM S91. The OPEN block in RULES is not
      pasteable. Corrected text is at the foot of TRAPS.
P69   DO popup search box clears itself after Enter. Cosmetic,
      unexplained.
P70   ✅ CLOSED S90.
P71   Material lot label barcode (print-label.component.ts,
      received-lots) NOT checked for the same truncation as P72.
      ▶ Read its ^FO/^BY, do the arithmetic against 812.
P72   ✅ CLOSED S91. On prod in prod-275c025039d7.
P73   ⚠ THE PRINTER. Client instructions, Mac drafted, Windows not.
      MINTY'S #1. Blocked on the second-Mac test and on seeing an
      existing help guide. Details above and in
      zebra-printer-setup-mac.md.
P74   ⚠ REWRITTEN S91 — THE OLD FRAMING WAS WRONG.
      NOT "prod certbot has no email". LET'S ENCRYPT ENDED EXPIRATION
      NOTIFICATION EMAILS ON 4 JUNE 2025 and no longer stores contact
      addresses at all. S91 registered info@abletrace.ca on prod:
      HTTP 200 returned AND NOTHING STORED — the account object came
      back with no contact field. No email will ever arrive, for
      anyone, on either box. Dev's registered address is equally
      worthless. → TRAPS
      ⚠ THE REAL RISK IS UNCHANGED: if renewal fails, nothing tells
      you. Cert good to 17 OCTOBER 2026. PARKED BY MINTY, with that as
      the deadline.
      ▶ FIX IS MONITORING. External service (Let's Encrypt points at
      Red Sift Certificates Lite, free to 250 certs) or an own daily
      check. ⚠ If own check: SES swallows send errors silently (3B.7),
      so a failed warning looks like no warning needed — send WEEKLY
      regardless so silence is itself the alarm. ⚠ And a cron/systemd
      job is HOST territory: prod 26.04 vs dev 24.04, so dev is NOT a
      rehearsal (3B.2).
      ✅ THE OTHER HALF IS CLOSED. Dev "Not Secure" is NOT a server
      fault — curl -I http://dev.mintekfoodsafety.com returns 301. It
      is the BOOKMARK pointing at http://.
P75   ✅ CLOSED S91. 3B.4 corrected — a push builds DEV, and the
      artifact carries the full 40-char SHA.
P76   ✅ CLOSED S91. 3B.7 corrected — the java process on 9100 IS
      Browser Print.
P77   Never add the Zebra in Printers & Scanners. Belongs in the client
      procedure and in 3B.7. Recorded S91.
P78   ✅ CLOSED S91. Certificate generated locally, not shipped.
P79   Five PRE-EXISTING console.log lines in do-list.component.ts
      (44, 175 commented, 193, 217, 240). Unrelated to the S87
      diagnostic, unchanged before and after it, already on prod.
      ⚠ Line 44 is the log NOW's old false claim was built on.
P80   CI warns Node.js 20 is deprecated and actions are forced onto
      Node 24. Green today, future break.
P81   ⚠ THE RECORD NEVER STATED WHAT PROD SERVES. Only the checkout,
      which lags. Prod was found on 8997acdcf4ab from 26 July — an
      unrecorded deploy. ▶ Keep the SERVED build in STATE every
      session, and read it from the backup directory, not the checkout.
P82   ⚠ THE ACROBATICS SWEEP. Recovered S91, was P1b in S40–S43, lost in
      the doc restructure. MINTY'S #2. Full scope above.
P83   Angular core.mjs regex error in the console on /Create-Packslips
      ("Pattern attribute value ... is not a valid regular expression").
      Framework-level, pre-existing, not application code. Cosmetic.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. isAdmin stays true when the
      user holds an Admin role among several. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491.
      ⚠ RE-CHECK: these may have ridden to prod inside
      prod-275c025039d7. Confirm before assuming they are still dev-only.

OPEN DEFECTS — diagnosed, not fixed. ⚠ ALL THREE BELONG TO P82.
      MO create round-trips units through a rounded batches figure and
      stores 50.004 instead of 50. (add-mlo.ts:204-205)
      Display reconstructs units as Kg / weight, producing float garbage.
      Version fork copies qty (Kg) but writes ship_qty 0 for
      intermediates. Fix the fork handler in Formulations.js, then heal
      existing 0 rows. Do this BEFORE re-anchoring stock to units.

FROZEN SPEC — ready to build
      P52 printed packing slip: letterhead, stacked DO rows, Code 128
      barcode per unique Customer PO, Shipped By from
      finalShipmentUserId.
      ⚠ QUESTION RAISED S90, STILL NOT ANSWERED: the slip printed in S90
      already carries letterhead, stacked DO rows and a Shipped By line.
      Either P52 was largely built and the record is stale, or that is a
      different print. Minty to confirm.
```

---

## THE SCAN SPEC — settled with Minty, do not re-derive

```
ONE SLIP =    A packing slip is ONE ship-to address, many lot codes,
ONE ADDRESS   many DOs. Address is the invariant; lot code is only what
              gets scanned.

FIRST SCAN    No address set. Filter to the scanned lot code, take the
              FIRST matching row's address (ascending DO order, so
              oldest wins — FIFO, confirmed by Minty), then tick every
              row matching that lot code AND that address.

EVERY SCAN    Address already locked and the list already filtered to
AFTER         it. Tick everything matching the scanned lot code within
              that address.

SCOPE         ⚠ Minty's call: change the FIRST selection only. Move to
              Packing Slip, Add Dispatch order and the round-trip
              rhythm all stay as they are.

⚠ ON PROD     S91 promoted this to the live client. THE ADDRESS LOCK IS
AND UNTESTED  STILL NOT EXERCISED — every DO ever tested sat at the same
              address (Jade 3, ITC RATNADIPA). Cross-address behaviour
              is not built and has never been seen. It only fires on a
              SCAN; clicking is the unchanged path.

PARKED        No-match message. Running count of selected DOs.
              Deliberately not built.
```
