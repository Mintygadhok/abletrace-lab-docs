# NOW

Last rewritten: S95, 30 July 2026.
State and queue. Rewritten whole every session, committed at close.

---

## WHAT S95 DID

```
P91 CLOSED — DEV AND PROD, VERIFIED ON SCREEN
  Trace_ProductProdLotView divided received_qty by wgt_kgs_per_unit to
  produce received_qty_su, WHILE ALREADY SELECTING the stored
  received_units column four fields along the same SELECT.
      was    51.00000000000001#
      now    51# (70.89 Kg)
  ONE TERM CHANGED, alias unchanged, so no frontend edit and NO DEPLOY.
  ⚠ THE DIVISION WAS ARITHMETICALLY CORRECT. A right number wearing float
    garbage, on 4 of 17 non-1:1 rows. Not a wrong figure — an anchor
    violation. Rank this class accordingly.
  GATED BEFORE THE ALTER, ON BOTH BOXES. Line 79 carries an *ngIf, so a
  null or zero unit count would have HIDDEN THE SPAN where a wrong number
  showed before.
      dev   would_go_blank 0 · units_null 0 · units_zero 6 (all qty 0)
      prod  would_go_blank 0 · units_null 0 · units_zero 2 (all qty 0)
  Glutenull did not move: Breakfast Bars 560/0.32 = 1750, Granola Bar
  192.48/0.24 = 802, identical before and after. THE CLIENT SEES NO
  DIFFERENCE. This stops the NEXT awkward ratio producing garbage.
  Rebuild record: JR7e. Evidence: J113. View text: db-definitions-S93.txt.

P93 CLOSED — NO CODE CHANGES NEEDED
  qty_allocated is KG-STORED. All four dividing sites are CORRECT:
    Trace_ProductOneStepBackwardIP_SP · Trace_ProductOneStepForwardIP_SP
    product-traceability-details.component.html:352 and :383
  PROVED BY MASS BALANCE. Baked Chicken with BBQ Sauce MO-0004 received
  50 Kg, consuming Baked Chicken 40 + BBQ Sauce 10 = 50 EXACTLY. As unit
  counts the same rows give 40x0.4 + 10x0.1 = 17 Kg against a 50 Kg
  parent — no balance at all. Second tell: qty_allocated itself carries
  float garbage (4.439999999999998); a stored unit count is a whole
  number.
  ⚠ THE 1.39 FIXTURE DID NOT EXIST. Test1.39-IP is never consumed as an
    intermediate on dev, so there was no awkward-ratio row to read
    directly. The balance is inference, not a direct read. → P104

R5 SCOPED — NO BUILD, AS INSTRUCTED
  Scope is in PLAN. Headline: all seven divisions are arithmetically
  correct; two are repointable, three are correct with no stored
  alternative, one needs a schema change, and SOH_su — the headline
  figure — depends on that one and is the LAST fixable.
  ⚠ S94's PLAN NAMED FIVE OF SEVEN. qty_packing_slip_su and qty_do_su
    were missing. Both are LEAVE.
  ⚠ CONSUMER ESTABLISHED, answering S94's open question:
    product-traceability-details ONLY, plus api/models/Traceability.js.

SECTION 0 FOLDED AND DELETED — P95 CLOSED, P96 CLOSED
  RULES.md rewritten whole. Section_0.md and Section_1.md deleted; both
  remain in git history. patch_s91_close.py deleted.
  ⚠ P95 NAMED FIVE LOAD-BEARING ITEMS. THE DIFF FOUND TEN. The extra
    five: 7.1 whole items only (the rule that drove today's three
    stamps) · 7.5 log evidence AND disproven theories · 7.7 clean as you
    go · 4.8/4.9 DB-only changes are not in git · 5.2 regression-test the
    pair · 6.2 prompt colour · 6.3 scp from the Mac.
  ⚠ AND ONE NOBODY HAD NAMED AT ALL: 9A/9B, the map of what 3A.1–3A.8
    and 3B.1–3B.11 each hold. PLAN's paste list says "Section_3A.md" and
    nothing else in the repo said what was in it. Deleting Section 0 with
    only the five folded would have lost the index to the reference set.
  ⚠ NOT FOLDED, DELIBERATELY: 0.3's standing paste list (Section 0 + 1 +
    5) — that IS the wrong paste list P95 was about. PLAN owns it now.
  ⚠ STILL TWO-HEADED: Section 5's JT block and TRAPS.md. Same shape as
    P95, not folded. → P105

P105 CLOSED — THE TRAPS MERGE
  JT1–JT22 moved from Section 5 into TRAPS.md. ⚠ SLICED BY ANCHOR, NOT
  RETYPED — a transcription error across 27 entries would be silent and
  permanent. Numbers intact, cross-references still resolve. Section 5
  now holds the JR rebuild block and the J-entries only.

RULINGS TAKEN AT THE S95 CLOSE
  P89   ACCEPTED, never revisit. batches is a PLAN INDICATOR; what is
        released is tracked separately and is the load-bearing figure.
  R5    GO. Ranked job 1 for S96, ahead of P52.
  P102  SCHEDULE the reboot — Saturday 1 Aug, ~11:30 AM, own sitting.
  P105  MERGE. Done tonight.
  DROPS P59, P60 and the duplicate P94 — all dropped.

SECTION 5 CORRECTED — three false claims, one patch
  JR7a, J7 and J26 all asserted that the P91 divide was correct or was
  being left in place. All three stamped, pointing at JR7e / J113.
  ⚠ A STRIKE THAT DOES NOT CHASE EVERY COPY IS NOT A STRIKE (J82).
  P97 closed in the same patch: the JR block now points at
  db-definitions-S93.txt. Header moved from J112/S86 to J113/S95.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺33 · frontend HEAD c2a52d8e
          serving dev-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          backend 13e3fcd · clean · 200
PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · Glutenull live
          SERVING prod-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8).
            Judge prod by the served bundle, never the checkout.
          backend 13e3fcd · clean · 200
ROLLBACK  prod: /home/ubuntu/www-html.bak-prod-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          dev:  /home/ubuntu/www-html.bak-dev-c2a52d8e129d29a491fa365a277eaa72eb399fc3
          ⚠ each holds the build it REPLACED (0b7ba967), not the one it
            is named after.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
BOXES     UNTOUCHED THIS SESSION. No git pull, no pm2 restart, no build,
          no promote. NOTHING WAS DEPLOYED.
GLUTENULL company_id 471. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100
```

---

## COMMITS THIS SESSION

```
CODE      NONE. P91 was a database object; P93 needed no change.
          ⚠ AND THE THING THAT FOLLOWS: A DATABASE OBJECT NEVER REACHES
            THE OTHER BOX BY DEPLOYING ANYTHING. Separate RDS instances.
            The ALTER was run on each box directly.

DATABASE  Trace_ProductProdLotView replaced on dev, then on prod.
          Verified by confirming the OLD text is GONE, scoped to
          TABLE_SCHEMA='abletracelab_live' on both. RDS only, not in git.

DOCS
  (this close) NOW rewritten · TRAPS appended (two traps) · PLAN written ·
               Section 5 patched (JR7e, three stamps, JR pointer, J113,
               header).
  ⚠ NO NEW FILES. Two were drafted and both were withdrawn:
    · an R5 scope doc → folded into PLAN
    · a p91_prodlotview.sql → NOT NEEDED. db-definitions-S93.txt already
      holds the view text and JR7e names the one changed term. A third
      copy is a third thing to keep in step.
  ⚠ patch_s95_close.py is a TOOL, NOT A DOCUMENT. Ran from /tmp, deleted,
    never committed. P96 exists because patch_s91_close.py was committed
    and became litter.

NO DATABASE WRITES. Both changes were to a VIEW. No row was touched.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items at the bottom with
the next free number. Claude never renumbers.

```
CARRIED FORWARD, still open
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P58   Dev remotes do not carry the PAT. ⚠ DID NOT FIRE IN S95 — nothing
      was pushed from dev. Still unfixed. Minutes to fix.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale again. ▶ THE FIX IS TO DELETE THEM FROM
      3B.4, not update them. STATE carries them and is rewritten every
      session. Static section, dynamic fact — the anti-rot rule.
P82   The acrobatics sweep. Short list now: R5, plus the screen walk in
      units-kg-checklist-S93.md items 2 and 3. ⚠ P91 AND P93 CAME OFF
      THIS LIST IN S95.
P84   Zebra guide into the app. Mechanical.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
P89   ⚠ CLOSED S95 BY RULING — ACCEPTED, NEVER REVISIT.
      MINTY, S95: the batches figure is a PLAN INDICATOR. What is
      actually RELEASED is the load-bearing number and it is captured
      and tracked separately. A minor variation in the multiplied-out
      recipe figure has no impact. ⚠ DO NOT RE-RAISE THIS AS A DEFECT.
P90   Strike two false claims in 3A, same object. 3A.5 row 7 says
      Trace_ProductHeaderView already carries received_units (measured
      false, S93). 3A.6 says nobody has identified the R5 switch point
      (S93 named all seven). One patch. ⚠ STRIKE 3A.6 WITH A POINTER TO
      J113 — the R5 scope lives in PLAN, which is disposable.
P93   ⚠ CLOSED S95. qty_allocated is Kg-stored; four sites correct.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
      ⚠ THE DUPLICATE WAS DROPPED S95. This one keeps the number.
P95   ⚠ CLOSED S95. Section 0 folded into RULES.md and DELETED, along
      with Section 1 (superseded by NOW.md). Both remain in git history.
      ⚠ P95's LIST OF FIVE WAS INCOMPLETE — the diff found ten. Also
        folded: 7.1 whole items only · 7.5 log the evidence AND the
        disproven theories · 7.7 clean as you go · 4.8/4.9 DB-only
        changes are not in git · 5.2 regression-test the pair · 6.2
        prompt colour · 6.3 scp from the Mac · and 9A/9B THE SECTION
        MAP, which nothing else in the repo carried. RULES now names
        what 3A.1–3A.8 and 3B.1–3B.11 each hold.
P96   ⚠ CLOSED S95. patch_s91_close.py deleted.
P97   ⚠ CLOSED S95. JR block now points at db-definitions-S93.txt.
P98   Trace_ProductProdLotView selects mm.qty TWICE — once as qty_su and
      once as qty — with no conversion. Both labels cannot be right.
      Belongs to P82's sweep. Not touched.
P99   mlomanagement.received_qty STORES float garbage. Dev MO-0009 holds
      15.290000000000001. Line 79 prints it raw as the bracketed Kg.
P100  Dev carries companies 466 and 469. RULES names only 464 and 465 as
      sandbox. Two unaccounted tenants.
P101  3B.3 records the dormant `abletrace` archive as living on the PROD
      instance. ⚠ DEV HAS ONE TOO — measured S95.
P102  Both boxes report *** System restart required ***. ⚠ RULED S95:
      SCHEDULE IT, in its own slot, NEVER inside a working session.
      Prod is the live client and runs a different OS from dev, so dev
      does not rehearse it. SCHEDULED SATURDAY 1 AUGUST 2026, ~11:30 AM,
      as its own sitting. ⚠ VERIFY PM2 STARTS ON BOOT FIRST (pm2 startup
      / pm2 save) or the box comes back without the app. Dev first.
P103  quanity_shipped_to_date (note the misspelling) is divided at
      add-dispatch.component.ts:72. Basis never established. S94's PLAN
      flagged it as riding with P93; P93's answer does not cover it.
      ⚠ J91 ALREADY LOGGED THIS IN S81 and asked for the reads to be
        found. Still not done.
P104  No 1.39 intermediate fixture exists on dev. Test1.39-IP is never
      consumed into a parent MO, so P93 was settled by mass balance, not
      a direct read. Build the fixture if a direct read is wanted.
P105  ⚠ CLOSED S95. MERGED. JT1–JT22 moved from Section 5 into TRAPS.md
      VERBATIM — sliced by anchor, not retyped, numbers intact. Section 5
      now holds the JR rebuild block and the J-entries only. JT23–JT27
      stay inside their session appends as history.
      MINTY, S95: "bring the documentation down, make it simple — the
      primary purpose is to work on the app."
P106  acrobatics-map-S91.txt has no queue item. Pasted at S94 open,
      never opened, never referenced. Keep or delete.
P107  units-kg-checklist-S93.md — P82 points at items 2 and 3, so part
      of it is live. Whether the rest is spent is unknown; the file has
      not been read. Read it before deciding.
P108  ⚠ J-ENTRIES ACCUMULATE AND NOTHING AGES THEM OUT. Section 5 holds
      113 entries; perhaps twenty are settled arguments and disproven
      theories from months ago, still read in full at every rebuild.
      MINTY, S95: once a change is working, what is the relevance of
      the record of what it was before?
      ▶ THE SPLIT THAT ANSWERS IT:
        JR block   PERMANENT. Not history — a BUILD SCRIPT. Every entry
                   must be re-applied if the database is ever rebuilt.
        J-entries  SHOULD AGE. An entry whose finding is built, closed
                   and settled for ~10 sessions compresses to one line
                   pointing at its commit. Git keeps the full text.
      ⚠ WHAT MUST NOT BE COMPRESSED AWAY: disproven theories still being
        re-derived, and notes protecting code that is WRONG ON PURPOSE.
        Those belong in TRAPS, which is append-only, not in a dated
        entry that ages out.
      ⚠ THE COUNTER-ARGUMENT, RECORDED HONESTLY: "keep everything" is
        what rotted old Section A — thirty sessions of appends that
        ended up contradicting the head on nine load-bearing facts.
        Volume is a real cost. README already says resolution decays.
      ▶ A REAL JOB, NOT A TIDY-UP. Its own sitting, at a close.

DROPPED S95 BY RULING
      P59, P60 and the duplicate P94 — all three dropped. P94's number
      stays with the prod backup file, which is real.

DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      ⚠ DEFECT 1 CLOSED S93. ⚠ P92 CLOSED S94. ⚠ P91 CLOSED S95.
      Defect 2: display reconstructs units as Kg / weight. Remaining
      sites are in units-kg-checklist-S93.md plus Trace_ProductHeaderView.
      This is R5, scoped in PLAN.
      ⚠ THERE IS NO THIRD DEFECT. The "version fork writes ship_qty 0"
        claim is FALSE and never was true (J81). "Fix A" is a dead name.

FROZEN SPEC — ⚠ MAY ALREADY BE BUILT
      P52 printed packing slip. ⚠ J112 RECORDS IT AS BUILT AND SHIPPED TO
      PROD IN S86 (commits ba3bfe9f + 8997acdc), with totals, page footer
      and barcode DELIBERATELY NOT BUILT — "decisions, not a backlog, do
      not re-raise". That answers the standing S90 question and suggests
      THE QUEUE IS CARRYING A CLOSED ITEM. ▶ One look at a printed slip
      settles it before anything is scoped.

NOT ON THE QUEUE AND PROBABLY SHOULD BE
      CERTIFICATE MONITORING. Nothing watches renewal on either box and
      no email setting can change that (Let's Encrypt stopped storing
      contact addresses). Trace expires 17 OCTOBER 2026. The fact
      survives in STATE; the action item does not.
```

---

## WHAT COST TIME IN S95

```
1  Claude's P91 verification query omitted TABLE_SCHEMA and returned a
   match from the dormant archive, reading as a failed ALTER. ⚠ CLAUDE'S
   FAULT. Recovered in one command, but the check could not have failed
   correctly. Now in TRAPS.
2  Claude asked for a screen reading without knowing the navigation path,
   and the first screenshot was Edit-Mlc, not the P91 consumer.
   ⚠ NAME THE ROUTE, NOT THE SCREEN.
3  Claude did not filter by company_id until asked, so the first fixture
   named (MO-0005 Baked Chicken) sat under 465, not 464.
4  ⚠ CLAUDE CLOSED THE SESSION BY DRAFTING TWO EXTRA DOCUMENT FILES — an
   R5 scope doc and a JR draft — ON THE SESSION AFTER THE FOUR-FILE SET
   WAS AGREED. Minty caught it. Both were unwritten and folded into PLAN
   and Section 5. ⚠ CLAUDE'S FAULT, and the shape to watch: a new file is
   the easy answer to "where does this go", and it is how a fifth head
   starts.
5  Section 5 was not in the paste list, so the JR entry could not be
   placed until Minty pasted it at close.

⚠ NOTHING WAS CHASED. Seven new items logged, none investigated.
```
