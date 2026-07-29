# NOW

Last rewritten: S87, 27 July 2026, 11:15.
The only file that changes each session.

---

## HANDOVER

```
⚠ FIRST JOB   RESTORE THE JR BLOCK. See P67. Claude told Minty to
              delete Section_5.md this morning while converting the
              docs. The JT traps were carried into TRAPS.md; the JR
              REBUILD BLOCK WAS NOT. 3B.9 states JR is the ONLY record
              of ~36 procs, 9 views, every column add, all seed data
              and RDS config. It is recoverable from the docs repo git
              history. Nothing else should start until it is back.

THE GOAL      After that: finish scan-to-select. Typing a lot code
              filters correctly. Pressing Enter does not tick.

PASTE LIST    RULES.md + NOW.md. 3B only if a deploy misbehaves.

FIRST THREE   1  Restore JR (P67).
ACTIONS       2  Open the popup with the Console open. Does ANY console
                 output appear when the dialog opens? That single
                 observation was never cleanly obtained today and it
                 decides the scan bug.
              3  Fix the binding, or work out why the browser is not
                 running the deployed chunk.

⚠ CLEANUP     734f3305 is DIAGNOSTIC ONLY (P63). Never promote it to
OWED          prod.
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
              by hand.
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
              logs on open (line ~44, pre-existing). If NOTHING appears
              when the dialog opens, the browser is not running the
              deployed chunk — a different problem entirely.
```

---

## COMMITS THIS SESSION — frontend, DEV ONLY, prod untouched

```
26123e0a   S87 P7 scan-to-select. onScan() plus (keyup.enter) on the
           search input. THE REAL FEATURE. Reuses the existing
           click-path grouping so scan and click cannot drift.
734f3305   S87 P7 DIAG. Four console.log lines inside onScan.
           ⚠ TEMPORARY. → P63
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev · frontend HEAD 734f3305
          serving dev-734f330507ed
PROD      15.157.38.101 · pm2 abletrace-backend · Glutenull live
          NOT TOUCHED THIS SESSION
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026. certbot clean.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items are at the
bottom with the next free number. **P67 should almost certainly be
ranked first** — Claude is saying so rather than moving it.

```
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P42   Section 5 restructure. ⚠ SUPERSEDED by the S87 doc conversion —
      Minty to confirm closed. Do NOT close it until P67 is done.
P58   Dev remotes do not carry the PAT. Push prompted for a password
      TWICE AGAIN today. ▶ Reset both remote URLs. Minutes.
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

P63   Remove the S87 diagnostic logging (734f3305). Blocks calling
      the scan feature done. Never promote 734f3305 to prod.
P64   Product label prints the string "null" for Ext ID, twice.
      Cosmetic, but customer-facing.
P65   promote.sh runs plain scp and ssh with no -4, but 3B.2 says dev
      always needs -4. Works today only because the Mac resolves v4.
      When it drifts, promote-to-dev hangs for no obvious reason.
P66   3B.4 accuracy, five minutes: its rollback points are stale
      (still 53db203d4ef4), and it says a push auto-builds PROD while
      today's pushes produced dist-dev- artifacts. One of the two is
      wrong.
P67   ⚠ RESTORE THE JR REBUILD BLOCK from Section_5.md via the docs
      repo git history. CLAUDE'S ERROR, S87. JR is the only record of
      ~36 procs, 9 views, every column add, seed data and RDS config
      (3B.9 says so explicitly). Also recover the reconcile oracle SQL
      with its COALESCE(d.qty_shipped,0) fix, and decide its permanent
      home — it is run every session, so by the both-directions test
      it belongs in RULES, not in a file that gets rewritten.

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
      intermediates. Fix the fork handler in Formulations.js, then
      heal existing 0 rows. Do this BEFORE re-anchoring stock to units.

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

---

## TRAPS THAT COST TIME TODAY

```
BROWSER       An hour went on "both sites have gone insecure". Nothing
CACHES ITS    was wrong — certs valid to October, http redirecting to
VERDICT       https on both boxes. Chrome had cached the not-secure
              state in long-open tabs; Cmd+Q cleared it. The security
              indicator is cached and survives a reload. Same family
              as J66.

TWO SCREENS   /Dispatch-orders (the list) and the DIALOG that opens on
NAMED THE     Create Packing Slip are both titled "Dispatch Orders" and
SAME THING    both have a Search box in the same place. A console
              reading was taken on the wrong one.

READING THE   Claude read promote.sh instead of asking for 3B.4, and
SCRIPT NOT    had been stating the CI direction backwards as a result.
THE DOC       Minty caught it. Deploy sessions paste 3B.
```
