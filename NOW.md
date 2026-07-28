# NOW

Last rewritten: S90, 27 July 2026.
The only file that changes each session.

---

## HANDOVER

```
THE GOAL      Scan-to-select is DONE and proven end to end, typed and
              scanned. What remains is cleanup: strip the S87 diagnostic
              logging (P63) so the feature can be called finished, then
              decide on promotion.

PASTE LIST    RULES.md + NOW.md. Add TRAPS.md if debugging deepens.
              3B only if a deploy or a printer misbehaves.

FIRST TWO     1  Strip the four console.log lines from onScan
ACTIONS          (do-list.component.ts ~line 153). Commit, build,
                 promote to dev, verify scan still ticks.
              2  Then P58 (dev remotes lost the PAT — pushes prompt for
                 a password every time. Minutes to fix).

⚠ CLEANUP     734f3305 is DIAGNOSTIC ONLY (P63) and 822fa248 SITS ON TOP
OWED          OF IT. Nothing in this stack goes to prod until the
              logging is out.
```

---

## THE SCAN WORK — DONE, pending cleanup

```
⚠ S87's FINDING WAS AN ARTIFACT. "Pressing Enter ticks nothing" was
  almost certainly tested with focus in DevTools, not in the Search box.
  The binding was never broken. A whole session was nearly spent fixing
  a working feature. → TRAPS.

VERIFIED      Typed: filter narrows, Enter ticks every row matching the
S90, ON DEV   lot code within one address, other lots untouched.
              MOVE TO PACKING SLIP appears. Three DOs (DO-0010, DO-0011,
              DO-0012) moved onto PS-0026, saved, and confirmed on a
              SERVER-LOADED list — not browser state.
              Scanned: same route as manual click. Confirmed by Minty.

NOT TESTED    The address lock. Every DO tested sat at the same address
              (Jade 3, ITC RATNADIPA). Per the frozen spec only the
              FIRST selection was changed, so cross-address behaviour is
              not built and was never exercised. Not evidence either way.

⚠ UNEXPLAINED The diagnostic console.log NEVER PRINTED, all session,
              even though onScan demonstrably ran and the string was
              proven present in the loaded chunk (DevTools Search found
              it in 9576.1fe196695fc02a9c.js AND do-list.component.ts
              line 153). Dies with P63, but it is why S87 read the
              situation wrong. → TRAPS.
```

---

## THE LABEL BARCODE — fixed this session

```
THE FAULT     The product label's Code 128 stopped scanning. Not print
              quality, not the scanner, not a config change.
              ^FO256,210^BY4,3,160^BCN — the barcode STARTED 256 dots in.
              Old content "260530" = 6 digits, Code 128 packs digit pairs
              two-to-a-symbol, ~272 dots wide. Ends at 528, inside 812.
              New content "Pdt-260718-1" = 12 chars, letters and dashes
              force one module each, ~668 dots. Starts at 256, would end
              at ~924 — PAST THE 812-DOT LABEL EDGE.
              A Code 128 missing its stop pattern is not faint, it is
              INVALID. The scanner never beeped because it never
              decoded. → TRAPS.

THE FIX       ^FO72 — (812 − 668) / 2 = 72, centred. ^BY4 unchanged,
              content unchanged, onScan unchanged.
              Commit 822fa248. Printed, verified, scans.

⚠ NOT DONE    The MATERIAL lot label is a SEPARATE template
              (print-label.component.ts, received-lots). A material lot
              code like Mat-260703-13 has the same 12-ish alphanumeric
              shape and is probably heading for the same truncation.
              → P71.
```

---

## COMMITS — S90, frontend, DEV ONLY, prod untouched

```
822fa248   P72. Product label barcode origin ^FO256 → ^FO72. Centres a
           12-char Code 128 that was running off the label edge.
           ⚠ Sits on top of 734f3305 (diagnostic). Not prod-safe yet.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev (33 restarts)
          frontend HEAD 822fa248, serving dev-822fa2484d75
          backend HEAD 13e3fcd
          Rollback: sudo rm -rf /var/www/html/* && sudo cp -r \
            /home/ubuntu/www-html.bak-dev-822fa2484d75/* /var/www/html/
PROD      15.157.38.101 · pm2 abletrace-backend (336 restarts) · Glutenull
          backend HEAD 13e3fcd — IDENTICAL TO DEV, verified S90
          frontend checkout 9bce0238 (NOT READ — checkout lags the bundle)
          NOT TOUCHED IN S90
DOCS      Mintygadhok/abletrace-lab-docs
          ⚠ The docs-HEAD line was REMOVED. It can never be correct —
          any commit that writes the current HEAD into NOW becomes a new
          HEAD the moment it lands. Do not reinstate it.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026. certbot clean.
          ⚠ PROD CERTBOT HAS NO REGISTERED EMAIL — no renewal warnings
          will ever arrive. Live client. → P74.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items go at the bottom
with the next free number. Claude never renumbers.

```
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P42   Section 5 restructure. Largely superseded by the S87 doc
      conversion. Minty to confirm closed — but see P67 first.
P58   Dev remotes do not carry the PAT. Prompted for a password AGAIN in
      S90. ▶ Reset both remote URLs. Minutes.
P59   Prod pm2 restart counter reads 336 against dev's 33. ▶ One look at
      pm2 describe abletrace-backend. Still not a reading of WHY.
P60   DO picker popup HEADING never renamed. Last remnant of P7.
P62   qty_shipped must never be NULL. Count NULLs both boxes, heal to 0,
      ALTER NOT NULL DEFAULT 0, check the Waterline model, and check
      soproducts.quanity_shipped_to_date and packingslipdos.shipped_qty
      while the SQL is open.
P63   ⚠ NEXT ACTION. Remove the S87 diagnostic logging (734f3305).
      Blocks calling scan-to-select done and blocks any promotion.
P64   Product label prints the string "null" for Ext ID, twice.
      CONFIRMED S90 on a physical printed label. Customer-facing.
P65   promote.sh runs plain scp and ssh with no -4, but 3B.2 says dev
      always needs -4. Works today only because the Mac resolves v4.
P66   ✅ CLOSED S90. SETTLED BY ARTIFACT NAME. A push to main builds
      DEV, not prod — run #33 produced dist-dev-822fa248…. 3B.4's claim
      that a push auto-builds PROD is WRONG and needs correcting.
      Also: the artifact carries the FULL 40-char SHA, not the short
      form 3B.4 implies.
P67   ⚠ SECTION 5 CANNOT BE DELETED YET. Before any old section is
      removed, the JR REBUILD BLOCK and the RECONCILE ORACLE SQL must be
      extracted to a permanent home. P20, P22 and P42 all wait on this.
P68   The OPEN block in RULES IS NOT PASTEABLE. Its prose sits inside
      the same fenced box as the commands, so pasting it sends zsh a
      line of bare parentheses → "parse error near )". It also carries a
      bare `git status --short` with no -C, which from ~ on dev runs
      against no repo at all. ▶ Fix in RULES: commands only, -C on both
      repos. (Corrected text is in TRAPS.)
P69   The DO popup search box CLEARS ITSELF after Enter. NOW previously
      listed a self-clearing search box under PARKED — deliberately not
      built. Either it exists and the record is wrong, or something else
      resets the field. Seen twice in S90. Cosmetic; unexplained.
P70   ✅ CLOSED S90. The scanner works. The DS2208 reads and transmits
      with an Enter terminator, verified into Excel and into the app.
      Every earlier "scanner broken" reading was the TRUNCATED BARCODE.
P71   Material lot label barcode (print-label.component.ts, received-
      lots) has NOT been checked for the same truncation as P72. A
      Mat-YYMMDD-N code is the same alphanumeric length. ▶ Read its
      ^FO/^BY, do the arithmetic against 812.
P72   ✅ CLOSED S90. Product label barcode centred (822fa248).
P73   PRINT IS NOT ROBUST ENOUGH FOR CLIENTS. Failed twice in S90 with
      "Print failed: Failed to fetch" — the browser could not reach
      Zebra Browser Print at https://localhost:9101.
      ⚠ TWO THINGS WERE CHANGED BEFORE IT WORKED (killed a java process
      holding port 9100, AND loaded localhost:9101 to accept its
      certificate). WHICH ONE FIXED IT IS NOT KNOWN. Do not record a
      cause without testing.
      Two tracks: (a) per-machine setup — trust the Browser Print cert
      in the keychain, set it to launch at login; (b) app side — probe
      the connection before enabling Print, and replace "Failed to
      fetch" with an operator-readable message. Minty's call which.
P74   CERT / "NOT SECURE" HYGIENE.
      ⚠ PROD IS FINE — trace.mintekfoodsafety.com shows the normal
      secure icon, verified S90. The live client does not see this.
      DEV shows "Not Secure" on /login, so dev is being served over
      plain http even though certbot ran with --redirect.
      ▶ curl -I http://dev.mintekfoodsafety.com — a 301 means the
      redirect works and it is the bookmark; anything else means the dev
      vhost lost its redirect block.
      ⚠ SEPARATE AND MORE IMPORTANT: prod's certbot has NO REGISTERED
      EMAIL (3B.6), so no renewal warning will ever arrive. Cert is good
      to 17 Oct. A silent expiry on a live client is the real risk here.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. isAdmin stays true when the
      user holds an Admin role among several. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      MO create round-trips units through a rounded batches figure and
      stores 50.004 instead of 50.
      Display reconstructs units as Kg / weight, producing float garbage
      on screen.
      Version fork copies qty (Kg) but writes ship_qty 0 for
      intermediates. Fix the fork handler in Formulations.js, then heal
      existing 0 rows. Do this BEFORE re-anchoring stock to units.

FROZEN SPEC — ready to build
      P52 printed packing slip: letterhead, stacked DO rows, Code 128
      barcode per unique Customer PO, Shipped By from
      finalShipmentUserId.
      ⚠ QUESTION RAISED S90, NOT ANSWERED: the slip printed in S90
      ALREADY carries letterhead, stacked DO rows and a Shipped By line.
      Either P52 was largely built and the record is stale, or that is a
      different print. Minty to confirm — it changes what P52 means.
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
              ⚠ S90: confirmed still the position. Scanning inside the
              SECOND popup follows the manual click route, which is
              correct behaviour, not a defect.

PARKED        No-match message. Self-clearing search box (⚠ but see
              P69 — it appears to clear anyway). Running count of
              selected DOs. Deliberately not built.
```
