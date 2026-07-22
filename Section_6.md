# SECTION 6 — HISTORY

> Session narrative. **Reconstruction-of-record, NOT daily reading.** You come here to answer *why did we do it that way* — never to find out *what is true now*.
>
> **⚠ THE LOAD-BEARING RULE: NOTHING MAY LIVE ONLY IN SECTION 6.** If a fact is load-bearing it belongs in 0, 2, 3A, 3B or 5 as well. This section holds the reasoning behind decisions, not the decisions themselves. A reader who needs a fact and finds it only here has found a documentation bug.
>
> **RESOLUTION DECREASES WITH AGE — by design.** Recent sessions are detailed because you might need them tomorrow. Old sessions are compressed to what SURVIVED: the decisions and reversals that still shape the system today. The test for keeping a line is: *would a future session make a WORSE DECISION without it?* If not, it was cut.
>
> **⚠ COMPRESSION IS WHERE A WRONG CLAIM GETS CANONISED.** The phantom "Fix A landed S46/S47" survived 32 sessions partly because it read like settled history. So compressed bands state what was **believed at the time** and flag where it was later disproven. They never present an old belief as fact.
>
> **⚠ THE ONGOING HABIT (why this section stops growing):** every ~10 sessions, the oldest per-session band is compressed into a short block. S73–S82 is detailed now; around S90 it becomes a paragraph. Section 6 does not grow — it shifts resolution backwards. That is exactly what old Section A never did, and why A rotted.
>
> Built S79 from old Section C. C RETIRES.

---

## ⚠ PROVENANCE — read once

```
S1–S11    RECONSTRUCTED. The original S1–S32 history was LOST in the
          S33 doc cleanup and rebuilt afterwards from past-session
          records. C's own header states S1–S11 verbatim, S12–S18 from
          the commit log, S19+ from summaries.
          ⚠ SO THE EARLY BAND IS SECOND-HAND. Treat it as approximately
          true, never as eyewitness.

S40       ⚠ NO RECORD. C jumps S39 → S41. The gap is in the source, not
          in this transcription. Nobody should hunt for it.

S72–S74   existed only as CHAT SUMMARIES pasted into C's tail, not as
          proper entries. ⚠ C carried TWO CONTRADICTORY S72 summaries —
          one written from memory, one retrieved from the record. The
          RETRIEVED one is used here; the memory one is discarded.

S75–S77   written from the real session summaries, supplied S79.
          ⚠ These SUPERSEDE an earlier reconstruction that had S75 and
          S76 combined and got S75's central finding BACKWARDS.

S78–S79   written from those sessions directly.

S74       ⚠ NO ENTRY. Falls inside the detailed band but no record was
          supplied. Stamped rather than invented.
```

---

## S1–S13 — THE FOUNDING (May 15 – May 28, 2026)

```
AbleTrace was migrated off its old infrastructure onto a new AWS account.
Both repos moved GitLab → GitHub (Mintygadhok). EC2 stood up with nginx,
Node 18, PM2; RDS restored from a production snapshot; SSL via Let's
Encrypt. The app went live at trace.mintekfoodsafety.com on May 19 —
four days from first login to a running system.
```

**What still matters from this band:**

```
⚠ S8 — THE GIT WIPE. 23 files were lost to a botched git operation and
  every S6 feature had to be rebuilt from scratch. The lesson written
  down that day — IF IT IS NOT IN GIT, IT DOES NOT EXIST — is the
  ancestor of Section 0's rules 4.4, 4.8 and 7.3, and of Section 5's
  entire JR block (which exists because DB objects are the things that
  are NOT in git).

⚠ S9 — THE FOUNDING QUANTITY DECISION. "User enters #, system derives
  Kg." That single line is the ancestor of §2 Logic A, of the S41 flip,
  and of every units argument since. It has never been reversed.

⚠ S13 — THE ROOT CAUSE THAT REFRAMED EVERYTHING. environment.prod.ts
  was pointing at the OLD server. Every fix made on the new EC2 box had
  been having ZERO LIVE EFFECT — for weeks. This is the ancestor of
  JT12 (screens lie, verify the row) and of 3B.4's served-bundle-vs-
  checkout trap, which bit again in S70.
```

Cut from this band: per-session commit SHAs, individual feature lists, the DO-flow collapse that was rolled back and then lost in the S8 wipe anyway.

---

## S14–S28 — STABILISATION (May 28 – Jun 4, 2026)

```
With the API finally pointing at the right server, the app became
genuinely fixable. CORS resolved, HTTPS + HSTS, health monitoring.
Zebra label printing built for both materials and products (ZPL via
Browser Print). Then a systematic frontend bug sweep — 84 bugs across
S23–S24 alone, categorised as crashes, silent data loss, and
subscription leaks.
```

**What still matters:**

```
⚠ THE RECURRING ROOT CAUSE of that 84-bug sweep: take(1) on NgRx
  selectors fires immediately on stale state. The fix — a named
  subscription plus ngOnDestroy — is now a standing rule in §2's
  General Code Rules. It is the single most repeated frontend defect
  in this codebase's history.

⚠ S28 — THE FIRST ONBOARDING WALKTHROUGH. 60+ issues catalogued by
  walking the client's actual path rather than reading code. The same
  method produced S67's 14-item queue and S73's units walk. Walking
  the screen finds what reading the repo does not.
```

Cut: the 84 individual bugs (they are fixed and their patterns live in §2), terminology-lock lists, Manage Roles UX detail.

---

## S29–S42 — LICENCE, SECURITY, AND THE UNITS FLIP (Jun 5 – Jun 15, 2026)

```
Three threads ran through this band: the licence engine was designed and
locked; a credential exposure forced a full rotation; and the quantity
model was re-anchored.
```

**The licence engine (S29–S31).** The full lifecycle was settled in one session and has not changed since: trial_start_date as the permanent anchor, convert adds 365 days, renew adds another, auto-expiry by nightly cron, and — the load-bearing rule — **only Inactive blocks login; Expired keeps access.** Bulk company actions were built with server-side eligibility and always-soft-delete. → §2 A7, A18.

**The credential exposure (S32–S35).** A `.env` was exposed in chat on Jun 7. Every Minty-controlled secret was rotated: RDS password, SES key, GitHub PAT, S3 key. Two lessons came out of it that are still rules — generate secrets straight into a file and never print them, and **RDS passwords must be alphanumeric only** because special characters break the connection-string parse.

```
⚠ TWO OLD-ACCOUNT KEYS WERE DELIBERATELY LEFT ACTIVE and still are.
  The two legacy clients may authenticate via them. This is J1, it is
  still open as P17, and it is sequenced after the domain switch.
  Nearly four months later it remains the oldest open security item.
```

**⚠ S41 — THE BATCH_QTY FLIP. The most load-bearing decision in the system.** Quantities had been stored as derived Kg and reconstructed into units by division everywhere. S41 reversed it: store shipping units as the anchor, derive Kg for display only, never round-trip. Deliberately done as a start-clean with no data migration — the test data was disposable and no real clients were on the new app.

```
⚠ WHY IT STILL MATTERS: every units bug since — S43's 0.5128, S44's
  packaging scaling, S48's over-count, and Defect 1 and Defect 2 which
  are STILL OPEN as P2 — is a place the flip did not fully reach.
  §2 Core #1 is this decision. The pattern "any ÷ weight producing a
  unit figure is a bug" is its diagnostic.
```

**S42 — the cascade bug, and the first sighting of doc rot.** A three-level packing product showed every level as 1.000 Ea. Root cause: the read-time cascade computation ignored each level's own quantity. Fixed in Formulations.js plus a stored-proc change (J5/J6). But the session also found something else:

```
⚠ SECTIONS A, B AND G HAD EACH ACCUMULATED A SECOND STACKED BODY —
  two or three "current states" in one document, contradicting each
  other. S42 rebuilt all three and wrote the whole-document-replacement
  rule.

  ⚠ IT DID NOT HOLD. A was two-headed again by S79, and C by S79 too.
  The rule was right; append-only growth defeated it. That is why
  Section 0 rule 7.1 now insists on WHOLE ITEMS and why the repo
  matters — a file that is replaced cannot silently accrete.
```

Cut from this band: the S36–S38 UI colour overhaul in detail (that material belongs to §4), individual commit chains, HACCP dropdown styling.

---

## S43–S60 — FIX A/B, THE FRESH DATABASE, AND CI (Jun 15 – Jul 3, 2026)

```
The longest band, and the one that built most of what the app is now.
Three threads: chasing the units flip through every screen, discovering
and fixing food-safety-critical bugs, and rebuilding the database and
the build pipeline from scratch.
```

**S43 — the 0.5128 investigation, and a diagnostic that still earns its keep.** Traceability showed 0.5128205128# where the answer was 1#. Minty spotted that 0.5128 is exactly 1 ÷ 1.95 — a computed number, therefore manufactured at some step, therefore not a stored-data problem.

```
⚠ THE RULE THAT CAME OUT OF IT, still used: a clean fraction like
  1÷wgt is THE FINGERPRINT of a units-stored field being divided.
  Trace any "÷ wgt" to whether the field is units-stored (no divide)
  or Kg-stored (divide is correct). ⚠ And check the data source FIRST —
  the fix lived in a DB view and a stored proc, not the frontend that
  was faithfully displaying what it was handed.
```

**S45–S52 — Fix B, the unit re-anchoring.** Product stock was re-anchored from Kg to shipping units across receive, release, misc-release and ship. The "two clean lines" decision was made here and still governs: **ingredients Kg-anchored end to end, products unit-anchored end to end, never reconciled.**

```
⚠ S48 — THE BUG THAT WAS FOUND BY ACCIDENT. The session set out to fix
  a progress bar and found a Core Stock over-count. receive-product was
  sending the MO PLAN instead of the entered per-receipt quantity, so
  multi-receipt MOs over-counted stock. It hid for sessions because
  single-receipt MOs masked it exactly and every Kg-derived screen
  looked right.
  ⚠ THE SHAPE OF THIS BUG RECURS: a defect invisible in the simple case,
  surfacing only when someone finally does the complex one. Same shape
  as S42's cascade (single-level products masked it) and S71's 413
  (small files masked it).
```

**⚠ S55 — the food-safety-critical one.** Editing a formulation containing an intermediate silently dropped the intermediate and its rolled-up allergen. Root cause: nested-pop v0.1.4 chains every entry of a populate array onto ONE Waterline findOne, and that version cannot populate two COLLECTION associations in one query — **the second silently returns empty.** Fixed with a dedicated second pass. This is JT8 and it remains an absolute rule.

**S53–S59 — the fresh database.** The existing DB held a folded client's real two-year history. Decision: do not carry it forward. Build `abletracelab_live` fresh — structure, logic, seed and Super Admin only — archive the old one. This dissolved a scary in-place major-version upgrade into "build fresh on the new version." The MySQL 8.0 → 8.4 Blue/Green upgrade (S56) then went through cleanly with the endpoint unchanged.

```
⚠ S59 VALIDATED THE FRESH DB by running one company through every
  feature end to end. Every quantity reconciled. But it also recorded
  TWO CLAIMS THAT WERE LATER PROVEN FALSE:
    · "the MO stores an as-made allergen snapshot" — called the
      FLAGSHIP food-safety result. ⚠ FALSE. Disproved S73 (J80) and
      again S78 (J82).
    · "release recursively EXPLODES the intermediate to raw materials"
      — ⚠ FALSE. Disproved S73 (J80).
  ⚠ BOTH WERE STAMPED CONFIRMED. Both were copied forward into four
  documents. Both took two sessions each to fully strike. This is the
  origin of Section 0 rule 0.1a.
```

**⚠ S61 — the box was always too small.** Angular builds had started failing. The hypothesis was "swap misconfigured after the 8.4 upgrade." Investigation disproved that and everything adjacent: swap was healthy; the RDS upgrade is on a *different machine* and cannot consume EC2 build RAM; the box was clean of stray processes.

```
THE REAL ANSWER: the box has ~1.9 GB and an Angular prod build needs
~2 GB heap. It was ALWAYS too small. The old app never hit this because
it built in GitHub CI for two years — and that CI was deleted in S39 as
"leftover old-app noise", silently pushing the build onto a box that was
never sized for it. Nobody noticed for 22 sessions.

⚠ THE LESSON: deleting something that appears to do nothing is a change.
  S39 was right that the workflows deployed nothing and leaked a key —
  and still removed a load-bearing capability by accident.

FIX: CI restored. The box has not built since. → 3B.4
```

Cut from this band: per-session commit chains, the S54 SQL inventory detail (it lives in §5's JR block and 3B.3), individual display-fix lists.

---

## S61–S72 — PER-SESSION, TERSE

```
S61   CI build pipeline restored (see band above). Then batch_qty made
      editable in place — the pencil block already existed, commented
      out, parked. Uncommented, tested, shipped. ⚠ SETTLED THAT DAY:
      fractional Batches are CORRECT, not a bug. Do not add a
      whole-batch constraint. First feature shipped through CI.

S62   Dev environment stood up as a separate EC2 box with its own RDS —
      full isolation, not a second process on prod. Dev-safety guard
      committed to bootstrap.js: refuses to boot if a dev box's
      DATABASE_URL contains the prod host token. Proven both ways.
      ⚠ Resolved a long-standing puzzle: the two "spare" EIPs are
      RDS-MANAGED, not releasable. Not an IAM problem, never was.

S63   Security items cleared, dev/prod mirror confirmed. Established the
      repeatable read-only MIRROR CHECK procedure (→ 3B.5).

S64   Both exposed secrets rotated (SESSION_SECRET, S3 key). "None"
      hazard type added as a data-only dev→prod round-trip. HACCP edit
      cascade STUDIED and deliberately deferred — its three-stage
      composite-match fragility mapped, rework scoped to its own
      session. It is still deferred, as P18.
      ⚠ Learned: lazy popup chunks survive Empty-Cache-Hard-Reload AND
      logout. Only a full browser quit loads the new chunk. (J66)

S65   received_at column added to receiveproducts — full stack in one
      session: ALTER on both boxes, Waterline attribute, stored-proc
      SELECT, three frontend templates.
      ⚠ THE DECISION WORTH KEEPING: the alternative was reformatting the
      lot code to embed a timestamp. Investigation found the next-counter
      is derived by PARSING that code (internalCode.split("-")[2]).
      Reformatting would have broken it silently. A separate column
      sidestepped it entirely. → §0 rule 2.4: grep the whole repo for
      identity-string parsers BEFORE changing a string's format.

S66   Dev environment hardened into something usable: permanent dev URL
      with real SSL, dev-configured CI target, one-command promote.sh
      with a cross-environment safety guard, and per-machine coloured
      prompts ([MAC] cyan / [DEV] green / [PROD] red).
      ⚠ The prompts exist because commands kept landing on the wrong box.

S67   Client Guides shipped — 8 branded PDFs behind login on a Super
      Admin tile, bundled in the frontend repo so they ride the normal
      pipeline. Delivered as separate per-module files deliberately, so
      no single artifact is the whole workflow. Then a full screen-
      verification pass produced a ranked 14-item queue — the ancestor
      of today's P-list.

S68   Four fixes shipped to dev. ⚠ AND ONE SHIPPED BROKEN: the trial
      banner gate hid the banner from EVERYONE including admins — worse
      than the bug it fixed. Flagged at session close rather than
      discovered later, which is the right outcome from a wrong action.
      Also found: Edit-PO Save was not superfluous as assumed — it is
      the ONLY path to attach reference documents. Premise wrong,
      backlog item rewritten.

S69   Banner rebuilt to spec, and a real latent defect found behind it:
      isAdmin compared a POPULATED OBJECT to the number 2 and was
      therefore ALWAYS FALSE. Same family as J24. Then a live client
      incident — a straight apostrophe in pasted SOP text terminated an
      inlined SQL literal and 500'd. ⚠ That was a live SQL INJECTION
      vector, not just a bug. Four call sites converted to bound
      parameters (771d775).
      ⚠ WHY THE CLIENT HIT IT AND MINTY DID NOT: Word and Docs normalise
      to a curly apostrophe; Gemini emits a straight one.

S70   ⚠ THE SESSION THAT WROTE SECTION 0. Its own entry below.

S71   ⚠ THE PAYOFF SESSION. Its own entry below.

S72   Documentation restructure. No code. Section J rebuilt into traps
      (JT) · rebuild checklist (JR) · entries — it had rotted into one
      flat log with duplicate entries, two J9s, two contradictory J33s,
      and everything after J60 unnumbered. Section G split into a
      one-page NOW and a stable reference.
      ⚠ AND IT VERIFIED FILENAMES AGAINST THE ACTUAL BOX, which is how
      JT20 exists: the S43 backup is `bakS43` with no dot, unlike every
      other file, and the doc had recorded it wrong. Trust the box.
      ⚠ THE THROUGH-LINE: S72 established the discipline — no
      duplication, whole-item edits, one home per fact — that S73
      through S79 have been applying to the sections S72 did not reach.
```

---

## S70 — THE SESSION THAT WROTE THE RULES (Jul 14, 2026)

```
⚠ NOT COMPRESSED. Section 0's rules 1.2, 2.2, 3.1–3.5 and 7.3 were all
  born in this session, each from a specific failure. Reading the rules
  without this entry loses why they are non-negotiable.
```

**It opened on a false picture.** The docs said backend HEAD was one commit; both boxes were on another — a security commit pushed the previous evening and never recorded. The session began chasing a delta that did not exist. Four hours later that same unrecorded commit turned out to be the cause of the client's bug.

```
⚠ AN UNRECORDED CHANGE IS AN UNRECORDED SUSPECT. → rule 7.3, J77.
```

**Two clean fixes shipped** — the banner scope (gated on the dropdown's actual value, not on whether the user merely holds an Admin role) and the Edit-PO Save 500 (`[...null]` on a column that was NULL on every row, so attaching a document to an existing PO had *never worked in the app's life*).

```
⚠ THE MORE VALUABLE HALF OF THAT SECOND FIX: grep found the identical
  unguarded pattern in FOUR models. Only PO crashed. Two others were
  safe ONLY BY ACCIDENT OF THEIR DATA — their create paths happen to
  seed [] where PO's left NULL. Guards were added for parity, and the
  note that a future "tidy-up" would reintroduce the crash is arguably
  the most valuable thing written that session. → J74, JT16, JT19.
```

**Then the client wrote in, and the session turned.** Pasted images in procedures were rendering broken on prod. The database told the story fast: valid base64, nothing truncated, but the quotes were escaped in the stored column. A timestamp scan dated the break precisely to the unrecorded commit from the morning.

**The revert — and the mistake.** Reverting restored images immediately and the client was unblocked. An hour later, saving text with an apostrophe threw a 500. The revert had re-opened the apostrophe bug that the reverted commit existed to fix.

```
⚠ THE REVERT WAS RECOMMENDED AS "RETURNING TO A STATE THAT WORKED FOR
  MONTHS." IT HAD NOT WORKED. IT WAS DIFFERENTLY BROKEN. One live-client
  breakage was traded for another, and the question that would have
  caught it — what was this commit fixing? — was never asked.
  → rules 3.1–3.5, JT14.
```

**Then it was chased properly.** Three forms were MEASURED rather than argued: inline (apostrophes fail, images fine), bound (apostrophes fine, images fail), bound+cast (identical to bound — *cast changes nothing, do not retry*). The stored procedure was cleared by direct test rather than inference.

```
⚠ THREE FIXES WERE PROPOSED ACROSS THAT NIGHT FROM CONFIDENT REASONING
  ABOUT MYSQL'S JSON HANDLING. TWO WERE WRONG. ONE REACHED PROD BEFORE
  BEING DISPROVEN. A single SELECT settled in seconds what an hour of
  argument had not. → rule 2.2, JT13.

THE DIAGNOSIS IT DID REACH, CORRECTLY: the escape arrives ALREADY
DOUBLED from the JavaScript side. The inline form masked it because
MySQL's literal parser strips one layer — two mistakes cancelling.
The evidence was four bytes: 842,052 inline vs 842,056 bound.
```

**It closed deliberately broken.** Offered the choice of which breakage to leave on prod, Minty declined both: *"let us do it the right way."* Prod was left in the known state, the experiment discarded as evidence rather than left as a stray edit.

```
⚠ THAT WAS THE RIGHT CALL. Neither state was a fix, and picking a lesser
  breakage after fourteen hours would have been a third guess.
  → rules 3.4 and 5.5.

⚠ AND SECTION 0 WAS WRITTEN THAT NIGHT, at Minty's suggestion, because
  the day's three worst moments all traced to rules that EXISTED but
  lived nowhere anyone read first. Minty's instinct was to put them on
  top of the NOW document; they were split into their own section
  instead — because a document rewritten every session erodes its rules
  by paraphrase.
```

---

## S71 — THE PAYOFF (Jul 15, 2026)

```
⚠ NOT COMPRESSED. This entry is the argument for keeping history at all.
```

**S71 opened with prod knowingly broken** and closed the bug in about twenty minutes — because S70 had written down *where to look* rather than *what happened*.

The cause was a line from June 2023: `JSON.stringify` run over a value that was already a string. Stringify does not serialise a string, it *escapes* it — so the content arrived pre-escaped, and the second stringify escaped the escapes. **Three years old.** MySQL's literal parser had been stripping one layer the whole time, so two mistakes cancelled out. The security fix removed the mask and the bug landed verbatim.

```
⚠ THE COMMIT NEVER BROKE ANYTHING. IT REMOVED THE ACCIDENT THAT WAS
  HIDING A THREE-YEAR-OLD BUG. → rule 3.5, JT15.

⚠ AND BEFORE FIXING, THE FRONTEND WAS CHECKED RATHER THAN ASSUMED — it
  passes strings raw, so the backend was the sole escape layer. Had it
  also been escaping, deleting one line would have shipped a half-fix
  to a live client.
```

**The 413 found along the way.** A 500 on upload with `[object Object]` had three plausible candidates held open. All three were wrong. The browser console showed it in seconds: nginx was rejecting the upload at the door with a 413, so Sails never ran and nothing reached the logs. `client_max_body_size` had been absent entirely — the built-in 1 MB default, applying to **every upload path in the app since nginx was first configured.**

```
⚠ ROUGHLY FORTY MINUTES WENT TO EXTRACTING ONE ERROR STRING. pm2 logs
  were asked for twice — once on the wrong box — then the Network tab,
  while the browser Console had it all along. The trap was already
  written down and was not applied. → JT18.

⚠ A SECOND "DEFECT" REPORTED MID-SESSION — a missing dot in a method
  name — was a TERMINAL PASTE ARTIFACT in the grep echo. The file was
  always correct. Rule 2.1 violated by the person who wrote it down.
  → JT17.
```

**The read on "the last two days have been unstable."** Four issues surfaced across S70 and S71. **Not one was caused by recent work.** The double-encode was from 2023. The PO null was original. The 413 had been there since nginx was configured.

```
⚠ WHAT CHANGED IS THAT A REAL CLIENT WAS BEING ONBOARDED AND PATHS WERE
  FINALLY BEING WALKED — attachments attached, apostrophes typed,
  procedures edited. Three years of latent bugs surfacing at once, on
  the sandbox rather than on the client.

  THAT IS THE SYSTEM WORKING, NOT FAILING. Worth remembering the next
  time a stretch feels unstable.
```

---

## S73–S79 — PER-SESSION, FULL

### S73 — THE VERIFICATION SESSION (Jul 17, 2026)

Section B was found asserting **both sides of the same question in two places, each stamped confirmed.** Minty tested three of them live on dev in about twenty minutes.

```
TEST 1  allergen snapshot        → ⚠ CLAIM FALSE. No snapshot exists.
TEST 2  intermediate explodes    → ⚠ CLAIM FALSE. It releases as one line.
TEST 3  stock leaves at DO       → RULE HELD. Verified.

Two of three "confirmed" claims were wrong. → J80.
```

Five further claims were tested against the app and the AWS console; five were false, including a "correction" asserting the boxes were t2.small when the *original* record (t3.small) had been right.

```
⚠ EVERY ONE WAS SETTLED BY OPENING A SCREEN. NONE WERE CAUGHT BY READING.
  → Section 0 rule 0.1a, the hardest-earned rule in the document.

⚠ MINTY'S RULING, LOCKED: live allergen re-derivation is CORRECT. A
  declaration is client knowledge; if an ingredient was mis-declared the
  record was always wrong, and freezing it would preserve that error on
  every lot. A correction must reach past data. The claim was false; the
  BEHAVIOUR is right.

⚠ AND ONE OBSERVATION THAT IS STILL UNRESOLVED: all three tests were
  read off screens that J13 says are Kg-derived and should "legitimately
  disagree" with the units column. THEY DID NOT DISAGREE. One of those
  is wrong, and it still gates P2 four sessions later.
```

### S75 — THE GREAT CONSOLIDATION, AND A CONFLICT CLOSED BACKWARDS (Jul 19–20, 2026)

**The consolidation.** Seventy-four sessions of sprawling documents were consolidated into a clean numbered set matching Section 0's rule-9 structure. The centrepiece was the **3A.5 stock hop table** — twelve hops, each with its key logic, an expected-versus-actual test, a verdict, and exact database, front-end and back-end addresses.

```
⚠ EVERY FRONT-END URL WAS WALKED LIVE ON DEV AND CONFIRMED — not guessed.
  That table is still the spine of 3A, four sessions later, and it has
  not needed a correction. Walking beats reading.
```

Six facts were verified on screen rather than reasoned about: the units anchor is clean at receiving; misc release pulls straight from stock-on-hand; start production touches no stock; a full edit forks behind a stock gate while an inline pencil edit does not; the batch field is literally labelled "Shipping Units per Batch"; and an intermediate release draws down the intermediate's own stock.

**⚠ AND THEN IT GOT THE SESSION'S HEADLINE FINDING EXACTLY BACKWARDS.**

```
THE CONFLICT: Section K claimed the version-fork PRESERVES ship_qty.
The chart claimed the fork writes ship_qty=0 and called it an open bug.
Two documents, opposite claims.

S75 RESOLVED IT — in the wrong direction. Its own words:
  "Section J's own entry J9b resolved it with LIVE DB PROOF: the fork
   DOES write ship_qty=0. The CHART was right; K was wrong."

⚠ J9b WAS NOT LIVE PROOF. It was a 2022 misreading that had been sitting
  in the log for 32 sessions, stamped as fact and never re-tested.

⚠ S75 TREATED A DOCUMENT AS EVIDENCE. That is the precise failure rule
  0.1a exists to prevent — and 0.1a had already been written, in S73,
  two sessions earlier.
```

**The cost was a phantom queue item.**

```
P26 was created that day: "Fix A — version-fork drops ship_qty=0,
DB-confirmed J9b. Fork handler must copy ship_qty forward + a one-time
DB heal of 0# rows."

⚠ P26 WAS A FIX FOR A BUG THAT NEVER EXISTED. It survived two sessions
  before S77 tested the claim three ways and killed it. It is why the
  live queue jumps P24 → P27: P26 died with J81, and P25 has no
  surviving record.

⚠ HAD ANYONE ACTED ON P26, they would have "fixed" a handler that had
  been correct since 2022 — on a food-safety system, on the write path
  for intermediate quantities.
```

**One thing S75 did exactly right, and it is worth copying.** The summary carried its own warning:

```
"⚠ NOT YET SAVED TO ANY DOCUMENT — the SO-create facts exist ONLY in
 the S75 chat. Save them or they're lost."

A session flagging its own unrecorded work, unprompted. That is rule
7.3 obeyed in real time, and it is why those facts survived into 3A.4
instead of evaporating.
```

Two rules were added to Section 0 this session: **0.2a** (monospace two-column format as the default for anything handed over to read) and **9D** (the design section holds visual and interaction language only — database changes and queue items belong elsewhere).

---

### S76 — FOOD SAFETY WALKED, AND THE DOCS MOVED INTO A REPO (Jul 20, 2026)

**The Sales Order walk closed** with `/Edit-SO` — the one screen outstanding from S75. Its "Order Completion Details" table nests each dispatch order as a child row beneath its SO product line, which is the structure 3A.4 now documents.

**A new defect found and logged (P27).** In the dispatch-order popup, a partial number in Shipping Units — just a "." — makes the derived Qty(Kg) field display "NaN".

```
⚠ MINTY'S CALL: it should render blank until the value is valid.
  Same display-guard family as Defect 2. Transient only, no stored
  data affected — but it is the third instance of the same shape,
  which is what makes it worth a queue line rather than a shrug.
```

**Food Safety was walked end to end** and became 3A.7 — the entry path, the procedures list and create screens, and the three-stage HACCP cascade, all consistent with the domain logic.

```
⚠ AND IT WAS RECORDED HONESTLY RATHER THAN OPTIMISTICALLY. Four things
  were explicitly marked NOT verified rather than assumed:
    · the document save was "walked, NOT J78-verified" — the test
      document exercised neither an apostrophe nor a pasted image,
      so the trap remains open
    · HACCP's ORDER-BY-step was not exercised
    · the edit cascade was not walked
    · the dispatch arithmetic was not DB-verified

  ⚠ THAT RESTRAINT IS WHY 3A.7 IS TRUSTWORTHY. A walk that claims more
  than it saw is worse than no walk — it is S59's flagship claim again.
```

**The docs moved into a public GitHub repo**, and two Section 0 decisions were reversed in the process.

```
⚠ REVERSAL 1 — PUBLIC, NOT PRIVATE. S73 had said private, reasoning the
  docs map a live food-safety system. S76 made it public because a
  public repo is the only form Claude can read from a plain URL, and
  because the genuinely identifying infrastructure strings are scrubbed
  into Section H. The repo carries logic, structure and reasoning; not
  the front-door coordinates.

⚠ REVERSAL 2 — SECTION 1 IN THE REPO. S73 had said "never in the repo",
  fearing a repo copy would go stale. The repo actually REDUCES that
  risk: git timestamps show when it was last touched, and there is no
  loose copy to paste stale by accident. The rewrite-whole discipline
  is unchanged.

⚠ WHAT THE REPO FIXES: previously Claude saw only what was pasted, so a
  gap in the source was invisible to Claude. Unrecorded gaps had already
  cost real sessions.
```

**⚠ AND THE REPO IMMEDIATELY TAUGHT ITS OWN TRAP.**

```
GitHub's raw URL served STALE CONTENT FOR HOURS — long past any
reasonable cache window. Claude repeatedly concluded "the edit didn't
commit" while the GitHub web view showed it plainly had.

⚠ THE WEB VIEW IS TRUTH. THE RAW FETCH IS NOT RELIABLE FOR VERIFICATION.

⚠ WHY IT MATTERS MORE THAN IT SOUNDS: Claude was not misreading a file.
  It was misreading THE STATE OF THE RECORD — repeatedly, confidently,
  and in the direction of "your work didn't land." That is the same
  failure family as S70's phantom delta, arriving through a new door.
```

Rule **7.7 (Clean As You Go)** was added — Claude flags stale, redundant or duplicated material at every session close and proposes cleanup; Minty approves before anything is cut, conservative by default. And a **RESUME-HERE block** was added to Section 1 so future sessions self-orient instead of spending their opening working out where they are.

---

### S77 — THE CORRECTION (Jul 21, 2026)

The session was meant to start the fold. It became something else, correctly.

**Building the fold map surfaced the contradiction again** — K2 saying the fork preserves ship_qty, K1 and the chart saying it drops it and calling it an open bug. S75 had already "resolved" this once, from documents. This time it was tested.

```
THREE INDEPENDENT CHECKS, ALL AGREEING:

  LIVE      dev co464: added an intermediate at 7 units to FO-0005,
            which forked to FO-0005-2. DB rows 1042 (ship=7) and
            1043 (ship=1). Both carried forward. Nothing zeroed.
  CODE      Formulations.js:901 — fork and pure-add share ONE handler
            that reads ship_qty forward. git blame: present since
            commit 2e21c0f, 5 July 2022.
  OPERATOR  four years of live use, never seen a ship_qty=0.

VERDICT: NOT A BUG. NEVER WAS. → J81.
```

```
⚠ THE FULL SHAPE OF THE ERROR, once it was finally looked at:

  · The 2022 "FO-0007 ship=0" reading was a MISREAD.
  · It was written down as fact.
  · It was copied forward into four documents.
  · S75 "confirmed" it from those documents rather than from the app.
  · A P-item was created to fix it (P26).
  · The docs also credited a "Fix A" as having LANDED in S46/S47 — but
    the handler predates S46 by four years.

  ⚠ SO THE BUG WAS PHANTOM **AND SO WAS ITS FIX.** Both were invented
    by the record and sustained by it for 32 sessions.
```

**Rule 0.2b was earned this session, in the most literal way available.**

```
Section 1 was handed over twice as chat text and THE CODE FENCES WERE
STRIPPED BOTH TIMES — the monospace blocks arrived as ragged plain text.
Root cause: copying from the rendered chat view copies the OUTPUT, not
the SOURCE. The backticks have already been consumed to DRAW the grey
box, so they are invisible and uncopyable.

⚠ THEN A THIRD FAILURE MANGLED RULE 0.2a ITSELF while 0.2b was being
  pasted in. THE RULE BROKE WHILE BEING WRITTEN.

That is the proof, and it is why the rule is now absolute: hand
documents over as FILES, never as chat text. A file cannot lose its
fences.
```

The fold itself was deliberately not started — left for S78 as its own fresh session, per Minty's own rule about not beginning major work at the tail of a long one.

---

### S78 — THE FOLD (Jul 21, 2026)

Section 3 and Section K were folded into Section 3A and K retired. Eight modules: three carrying full walked content, five as skeleton stubs holding verified database facts with front end and back end explicitly stamped NOT YET WALKED.

```
⚠ THE DECISION: A-lite — stub the missing tabs, invent nothing. Option B
  would have left K alive, meaning two homes for one fact. Full stubbing
  would have meant writing screen detail for modules nobody had walked,
  and invented detail written confidently becomes next session's
  foundation.

⚠ ONE FACT WAS NEARLY LOST — K1's Material Return action had no home in
  the map. It was caught by a mechanical coverage count, NOT by reading.
  → 3A.5 row 11b. The count is why it survived.
```

**And the allergen claim was re-tested** because the strike from S73 had reached one document and left it standing in three others.

```
The test: a product built clean with no allergen, one ingredient with no
allergen, an MO produced and received. Then Eggs was added to the
ingredient. ⚠ THE ALREADY-COMPLETED LOT NOW READ "EGGS".

Same result as J80, opposite direction, different product. → J82.

⚠ THE NEW PART: ONE EDIT REWROTE THE ALLERGEN ON ALL SEVEN PRODUCTS in
  the company sharing that ingredient, and on their existing lots.
  Company-wide, immediate.

⚠ THE REAL LESSON IS NOT ABOUT ALLERGENS. It is that a strike which does
  not chase every copy is not a strike. Three findings this week — J80,
  J81, J82 — were the same failure: a confident wrong answer written
  down, stamped confirmed, and copied into four documents.
```

Section 5 was also rebuilt whole, verified by count: 20 traps, 14 rebuild items, 75 entries, zero lost.

### S79 — INFRASTRUCTURE AND HISTORY (Jul 21, 2026)

Section 3B was built — eleven blocks covering everything the app runs on. Section 6 (this document) was built from old Section C.

```
⚠ THE METHOD CHANGED MID-SESSION, AND THE CHANGE MATTERS. The plan was
  to fold old Section A into 3B. Reading A showed it was TWO-HEADED:
  its top half (stamped S42) contradicted its own bottom half (appends
  through S71) on NINE load-bearing facts — the OS version, the live
  database name, whether the box can build, how many environments exist.

  ⚠ AND IT CARRIED A "CORRECTION" THAT WAS ITSELF THE ERROR: an S61 note
  asserting the boxes were t2.small, "EC2 console confirmed". S73 proved
  both are t3.small. The correction broke a record that had been right.

  SO A'S TOP HALF WAS NOT COPIED FORWARD. 3B's boxes, databases and
  pipeline blocks were rebuilt from Section 1's S72 console-verified
  facts instead. A contributed only its S53-onward appends.

⚠ ROUGHLY HALF OF SECTION A WAS NEVER INFRASTRUCTURE — licence rules,
  quantity rules, file maps, the design system. Those were routed to
  §2, 3A and §4. The routing record lives at the foot of 3B so nobody
  hunts for them.

⚠ ONE LIVE RISK SURFACED WHILE READING: prod's SSL certificate was
  registered with NO contact email, so prod gets no renewal-failure
  warning — on the client-facing box. Dev was deliberately given one.
  → P31.
```

---

## ⚠ THE PATTERN ACROSS 79 SESSIONS

```
Written down because it is the thing this section exists to show, and
it is not visible from any single entry.

THREE TIMES THIS WEEK — J80, J81, J82 — a claim was found to be false
that had been stamped "confirmed" and copied into three or four
documents. In every case the original reading was wrong, nobody
re-checked it, and the copies outlived the strike.

THE SAME SHAPE APPEARS EARLIER:
  S13   every fix having zero effect for weeks, because one config
        value was believed rather than verified
  S42   three documents each carrying two contradictory current-states
  S53   "t3.small" recorded, then "corrected" to t2.small — the
        correction was the error, and it survived twelve sessions
  S59   two food-safety claims stamped FLAGSHIP, both false
  S61   CI deleted as noise in S39; nobody noticed for 22 sessions
  S75   ⚠ THE SHARPEST INSTANCE. A conflict between two documents was
        "resolved" by consulting a THIRD document — a 2022 misreading
        that had never been re-tested. The wrong side won, and a
        P-item was created to fix a bug that did not exist. Rule 0.1a
        had been written two sessions earlier and was not applied.
  S76   the raw URL served stale content for hours; Claude repeatedly
        misread THE STATE OF THE RECORD and concluded work had not
        landed when it had

⚠ THE COMMON FACTOR IS NEVER A BAD DECISION. It is a confident claim
  that was never tested by looking, and a record that grew by
  accumulation rather than replacement.

⚠ AND THE MOST UNCOMFORTABLE VERSION OF IT: S75 had rule 0.1a available
  and still resolved a live question out of the filing cabinet. Writing
  a rule down does not make it fire. What made it fire, eventually, was
  S77 refusing to pick a side and opening the app instead.

That is why Section 0 rule 0.1a exists, why rule 7.1 insists on whole
items, why the queue never renumbers itself, and why this section
compresses backwards instead of growing forwards.
```

---

**END SECTION 6**
