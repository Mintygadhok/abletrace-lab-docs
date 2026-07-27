# NOW

Last rewritten: S87, 27 July 2026.
The only file that changes each session.

---

## HANDOVER

```
THE GOAL      Finish scan-to-select in the Dispatch Orders popup.
              Typing a lot code filters correctly. Pressing Enter does
              not tick. Find out why, fix it, remove the diagnostic
              logging.

PASTE LIST    RULES.md + NOW.md. Add TRAPS.md if debugging deepens.
              3B only if a deploy misbehaves.

FIRST TWO     1  Open the popup with the Console open. Does ANY console
ACTIONS          output appear when the dialog opens? That single
                 observation was never cleanly obtained in S87 and it
                 decides between the two hypotheses below.
              2  Fix the binding, or work out why the browser is not
                 running the deployed chunk.

⚠ CLEANUP     734f3305 is DIAGNOSTIC ONLY (P63). Never promote it to
OWED          prod. The feature is not done until it is out.
```

---

## THE SCAN WORK — where it stands

```
WHAT WORKS    Typing a lot code narrows the list correctly (7 rows to
              the 2 matching rows, verified on screen).
              Manual click still ticks the whole lot+customer+address
              group and leaves other-lot DOs alone. NO REGRESSION.

WHAT DOES     Pressing Enter ticks nothing. selectedItem stays 0, so
NOT WORK      MOVE TO PACKING SLIP never appears.

RULED OUT     The scanner — never in play, every failing test was typed
              by hand on the keyboard.
              A stale deploy — grep found "S87 onScan FIRED" inside
              /var/www/html/9576.1fe196695fc02a9c.js on dev.
              The wrong component — the popup is DoListComponent
              (src/app/PopUps/do-list/), NOT add-dispatch or
              add-dispatch-v2. Those belong to edit-sales-order and
              were never in this path.

HYPOTHESIS 1  onScan never fires — the (keyup.enter) binding is not
              reaching the method. UNTESTED.

HYPOTHESIS 2  onScan fires but finds no row. The filter matches on
              "contains"; the tick requires an EXACT match, so a stored
              lot code carrying any extra character would filter fine
              and never tick.

⚠ THE UNREAD  One observation settles both: does "S87 onScan FIRED"
  SIGNAL      appear in the Console on Enter? Note DoListComponent ALSO
              logs on open (line ~44, pre-existing, not added by us).
              If NOTHING appears when the dialog opens, the browser is
              not running the deployed chunk — a different problem.
```

---

## COMMITS — S87, frontend, DEV ONLY, prod untouched

```
26123e0a   Scan-to-select. onScan() plus (keyup.enter) on the search
           input. THE REAL FEATURE. Reuses the existing click-path
           grouping so scan and click cannot drift.
734f3305   DIAG. Four console.log lines inside onScan. ⚠ TEMPORARY.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev
          frontend HEAD 734f3305, serving dev-734f330507ed
PROD      15.157.38.101 · pm2 abletrace-backend · Glutenull live
          NOT TOUCHED IN S87
DOCS      Mintygadhok/abletrace-lab-docs HEAD 3de64a8
          ⚠ NOTHING WAS DELETED. Sections 0-6 all still present
          alongside the new RULES / NOW / TRAPS.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026. certbot clean.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items go at the bottom
with the next free number. Claude never renumbers.

```
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P42   Section 5 restructure. ⚠ Largely superseded by the S87 doc
      conversion. Minty to confirm closed — but see P67 first.
P58   Dev remotes do not carry the PAT. Push prompted for a password
      TWICE AGAIN in S87. ▶ Reset both remote URLs. Minutes.
P59   Prod pm2 restart counter reads 335 against dev's 33, and went
      336 on the S86 promote. ▶ One look at
      pm2 describe abletrace-backend. Still not a reading of WHY.
P60   DO picker popup HEADING never renamed. Last remnant of P7. The
      button was renamed in S84 and is live; the heading was not.
P62   qty_shipped must never be NULL. Decision made, work outstanding
      — count NULLs both boxes, heal to 0, ALTER NOT NULL DEFAULT 0,
      check the Waterline model too, and check
      soproducts.quanity_shipped_to_date and
      packingslipdos.shipped_qty while the SQL is open.

P63   Remove the S87 diagnostic logging (734f3305). Blocks calling the
      scan feature done.
P64   Product label prints the string "null" for Ext ID, twice.
      Cosmetic, but customer-facing.
P65   promote.sh runs plain scp and ssh with no -4, but 3B.2 says dev
      always needs -4. Works today only because the Mac resolves v4.
      When it drifts, promote-to-dev hangs for no obvious reason.
P66   3B.4 accuracy, five minutes: its rollback points are stale (still
      53db203d4ef4), and it says a push auto-builds PROD while S87's
      pushes produced dist-dev- artifacts. One of the two is wrong.
P67   ⚠ SECTION 5 CANNOT BE DELETED YET, AND CLAUDE NEARLY SAID IT
      COULD. Before any old section is removed, the JR REBUILD BLOCK
      and the RECONCILE ORACLE SQL must be extracted to a permanent
      home. 3B.9 states JR is the ONLY record of ~36 procs, 9 views,
      every column add, seed data and RDS config. The oracle runs every
      session, so by the both-directions test it belongs in RULES.
      ⚠ P20, P22 and P42 all wait on this.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. isAdmin stays true when
      the user holds an Admin role among several. Fix: gate the *ngIf
      on selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      MO create round-trips units through a rounded batches figure and
      stores 50.004 instead of 50.
      Display reconstructs units as Kg / weight, producing float
      garbage on screen.
      Version fork copies qty (Kg) but writes ship_qty 0 for
      intermediates. Fix the fork handler in Formulations.js, then heal
      existing 0 rows. Do this BEFORE re-anchoring stock to units.

FROZEN SPEC — ready to build
      P52 printed packing slip: letterhead, stacked DO rows, Code 128
      barcode per unique Customer PO, Shipped By from
      finalShipmentUserId.
```

---

## THE SCAN SPEC — settled with Minty, do not re-derive

```
ONE SLIP =    A packing slip is ONE ship-to address, many lot codes,
ONE ADDRESS   many DOs. Address is the invariant; lot code is only what
              gets scanned.

FIRST SCAN    No address set. Filter to the scanned lot code, take the
              FIRST matching row's address (ascending DO order, so
              oldest wins — FIFO, sort confirmed by Minty), then tick
              every row matching that lot code AND that address.

EVERY SCAN    Address already locked and the list already filtered to
AFTER         it. Tick everything matching the scanned lot code within
              that address. Nothing to decide.

SCOPE         ⚠ Minty's call: change the FIRST selection only. Move to
              Packing Slip, Add Dispatch order and the round-trip
              rhythm all stay as they are. Watch it in use first.

PARKED        No-match message. Self-clearing search box. Running count
              of selected DOs. Deliberately not built.
```
