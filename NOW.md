# NOW

Last rewritten: S96, 31 July 2026.
State and queue. Rewritten whole every session, committed at close.

---

## WHAT S96 DID

```
⚠ NO APP WORK. NO CODE. NO DATABASE CHANGE. NOTHING DEPLOYED.
  The session opened locked out of dev and became an infrastructure
  session and a documentation cut. R5 was never started.

THE DEV LOCKOUT — DIAGNOSED AND FIXED
  ssh to dev timed out. ⚠ A TIMEOUT, NOT A REFUSAL — packets dropped
  silently, which rules out the key, the user and permissions.
  CAUSE: dev's security group allowed port 22 from ONE address —
  162.156.123.117/32, Minty's home. Minty was at a client site on
  their wifi, 50.92.167.138.
  ⚠ THE BOX WAS NEVER THE PROBLEM. https answered 200 throughout,
    3/3 status checks, 24 days uptime, nothing restarted.
  FIX: sgr-0155622f2d85235e7 changed to 0.0.0.0/0. One rule edit.
    ⚠ EDITED, NOT ADDED — the stale /32 is gone, not left behind.

  ⚠ THE PART THAT COST THE TIME WAS NOT THE RULE. Minty recalled
    ssh'ing to DEV from a Starlink campsite, which the /32 rule
    makes impossible. Claude began dismantling a MEASURED fact to
    fit a RECOLLECTION. Settled by one date:
        prod born   19 May      campsite  22-27 Jun
        dev born     7 Jul      ⚠ TEN DAYS LATER
    The campsite was PROD, whose port 22 is open to the world. No
    contradiction, no rule was ever edited.
  ⚠ THE LAUNCH TIME WAS ON SCREEN THE WHOLE TIME. Claude did not
    join it to the campsite date until Minty asked.
  ⚠ CORROBORATED THREE TIMES: both boxes' login banners read
    "Last login ... from 162.156.123.117" on 30 Jul — S95, from home.

PROD SSH RISK — MEASURED, NOT ASSUMED
  Prod's port 22 has been open to 0.0.0.0/0 since 19 May.
  Read from sshd's OWN RESOLVED CONFIG on each box, not the file
  — a drop-in can silently override:
      passwordauthentication        no    ⚠ THE ONE THAT MATTERS
      pubkeyauthentication          yes
      permitrootlogin  prohibit-password (prod) / without-password (dev)
      kbdinteractiveauthentication  no
  ⚠ THERE IS NO PASSWORD TO GUESS. Brute force is not slowed down,
    it is structurally impossible. 2539 "Invalid user" over 5.9 days
    = ~430/day, refused before any credential is examined. Normal
    internet background noise for an exposed port 22.
  fail2ban absent. ⚠ DELIBERATELY NOT ADDED — it guards against
    password guessing that cannot happen here, and a misconfigured
    one locks the SOLE OPERATOR out of the live client box.

  MINTY'S RULING, S96: DO NOT NARROW PROD. A developer must be able
  to work from anywhere — client site, campsite, hotel. Narrowing
  strands the one person who can fix a live client problem.
  ▶ THE MITIGATION IS PATCHING, NOT THE FIREWALL. The real exposure
    is an unpatched sshd. → P102.

  ⚠ RECOVERY PATH: keys and secrets are on Google Drive, not only
    the Mac. JR's standing note calls Drive "not verified current"
    — that line MAY NOW BE STALE. Unverified. → P119 touches this.

TRAPS.md REWRITTEN WHOLE — ~40 ENTRIES DOWN TO TEN
  Every entry walked one at a time, in plain language, and ruled on.
  ⚠ SEVENTEEN WERE EXACT DUPLICATES OF EACH OTHER. S95's merge
    (P105) moved JT1-JT22 in verbatim without checking against what
    was already at the top of the file. A third of the file was
    itself, twice. Free cut, no judgement needed.
  THE TEST APPLIED: does believing the wrong thing CORRUPT DATA or
  PUT A WRONG NUMBER IN FRONT OF THE CLIENT? If not, cut.
  WHAT SURVIVED: ten entries, all silent-failure, all about data.
  WHAT MOVED: nine became queue items, four became RULES lines,
  ~18 were cut outright as knick-knacks.

  MINTY, S96: "we were very efficient without documentation when we
  started. Now most of the time goes on maintaining documents."
  MINTY, S96: "if there's an issue, we sort it. If there's no issue,
  we cut it." ⚠ THAT IS THE FILTER. It is now written into TRAPS.

  ⚠ THE PRINCIPLE THAT DID THE MOST WORK: a warning that says "do
    not touch this" is better as a COMMENT ON THE LINE than an entry
    in a file. The comment sits three inches from the thing being
    tidied. → P118.

P82 RESTRUCTURED AND RE-RANKED
  MINTY, S96: shipping units must come from the source AS SHIPPING
  UNITS. No acrobatics in between. RESOLVE THEM IN ONE GO.
  P98, P99 and P103 folded in as sub-items. Eight sub-items now.

HEALTH CHECK — BOTH BOXES, CLEAN, EVERY STAMP MATCHES
  ⚠ It was outstanding from session open and nearly did not happen.
```

---

## STATE

```
DEV       16.55.10.205 · pm2 abletrace-dev ↺33 · frontend HEAD c2a52d8e
          backend 13e3fcd · both repos clean · 200
          Ubuntu 24.04.4 · kernel 6.17.0-1017-aws · 172.31.1.196
          ⚠ 17 updates pending, 5 security · restart required
PROD      15.157.38.101 · pm2 abletrace-backend ↺336 · Glutenull live
          SERVING prod-c2a52d8e129d (read from the newest backup dir)
          ⚠ frontend checkout reads 9bce0238 — stale BY DESIGN (P8).
            Judge prod by the served bundle, never the checkout.
          backend 13e3fcd · both repos clean · 200
          Ubuntu 26.04 · kernel 7.0.0-1004-aws · 172.31.3.156
          ⚠ 31 updates pending · restart required
          ⚠ Usage of / 63.1% of 18.25GB. Dev is 31.9%. Watch it.
SECURITY  DEV   sg-0301330fdca5ee36f (launch-wizard-2)
                22 · 443 · 80 all 0.0.0.0/0   ⚠ 22 OPENED S96
          PROD  sg-034c010b5b20ccf78 (launch-wizard-1)
                22 · 443 · 80 all 0.0.0.0/0   ⚠ since 19 May
          ⚠ SEPARATE GROUPS. Editing one cannot touch the other.
          ⚠ BOTH ARE WIZARD DEFAULTS, NEVER DESIGNED. The names say
            so. The dev/prod difference was two afternoons, not a
            decision.
          Both boxes measured KEY-ONLY, no password path.
          Neither instance has an IAM role.
ROLLBACK  prod: /home/ubuntu/www-html.bak-prod-c2a52d8e129d
          dev:  /home/ubuntu/www-html.bak-dev-c2a52d8e129d
          ⚠ CORRECTED S96 — S95 RECORDED A PATH THAT DOES NOT EXIST.
            It carried the full 40-character build code. The deploy
            script uses TWELVE characters. ⚠ BOTH BOXES READ S96 AND
            BOTH CONFIRM THE TWELVE-CHARACTER FORM.
            ⚠ THE ROLLBACK PATH IS THE ONE THING THAT MUST BE RIGHT
              BEFORE IT IS NEEDED. A wrong path is a bad thing to
              discover mid-incident.
          ⚠ EACH DIRECTORY HOLDS THE BUILD IT REPLACED, not the one
            it is named after. Visible in the listing: the newest is
            named c2a52d8e and contains 0b7ba967; the next is named
            0b7ba967 and contains 275c0250.
          ⚠ THEY ACCUMULATE AND NOTHING PRUNES THEM. Measured S96:
            PROD 11 directories, back to S61 · disk 63.1%
            DEV  25 directories                · disk 31.9%
            Dev collects faster because EVERY PUSH deploys there
            while prod only moves on a promote. Each is a complete
            frontend build.
            ⚠ NOT RANKED, NOT A QUEUE ITEM — recorded because it was
              measured, not because anyone has decided anything.
            ⚠ IF THEY ARE EVER PRUNED, KEEP THE NEWEST. It is the
              only read of what the box is actually serving.
CERTS     trace expires 17 Oct 2026 · dev 9 Oct 2026.
INSTANCES dev  i-098e2cc59844d9ef3  t3.small  launched  7 Jul 2026
          prod i-0b54ae374250348e0            launched 19 May 2026
          ⚠ THE LAUNCH DATES ARE LOAD-BEARING — they settled the
            campsite question in one line. Keep them here.
GLUTENULL company_id 471. Sandbox is 464 and 465.
          ⚠ dev also carries 466 and 469, unaccounted. → P100
```

---

## COMMITS THIS SESSION

```
CODE       NONE.
DATABASE   NONE.
INFRA      one security group rule edited on dev
           (sgr-0155622f2d85235e7 → 0.0.0.0/0).
           ⚠ NOT IN GIT. Nothing about a security group ever is.
DOCS       NOW rewritten · TRAPS REWRITTEN WHOLE (first time ever) ·
           PLAN written · RULES addendum (⚠ NOT a rewrite — RULES
           was not pasted this session and rule 7.1 forbids editing
           an item that has not been read).
⚠ NO NEW FILES.
```

---

## QUEUE

⚠ Logging is mechanical, ranking is Minty's. New items at the bottom
with the next free number. Claude never renumbers.

⚠ P112 AND P113 ARE DELIBERATELY UNUSED. They were drafted in S96 for
the two ssh findings and Minty ruled: "that is an AWS setting, not a
trap — do not log it." The numbers are burnt rather than reused, so
this note is the only record they existed. Numbering continues at P114.

```
CARRIED FORWARD, still open
P20   Delete pre-S72 Section J file.
P22   Delete old Section A file.
P58   Dev remotes do not carry the PAT. Still unfixed. Minutes to fix.
P62   qty_shipped must never be NULL.
P64   Product label prints "null" for Ext ID twice, on prod.
P65   promote.sh runs plain scp and ssh with no -4.
P66   3B.4 rollback points stale again. ▶ DELETE them from 3B.4, do
      not update them. STATE carries them and is rewritten every
      session. Static section, dynamic fact — the anti-rot rule.
P84   Zebra guide into the app. Mechanical.
P85   Windows printer guide.
P86   Cold boot blindness, untested.
P88   Grep Section 5 for J81 / "Fix A" dead pointers.
      ⚠ CHECKED S96 ON TWO FILES ONLY (Section 5, 3A) and both look
        clean — every occurrence already sits inside a strike. NOT
        CLOSED: §2, 3B, 4, 6 and README were not read, and J81 names
        §2 to-verify #8 as a site. A strike that does not chase every
        copy is not a strike.
P90   Strike two false claims in 3A. ⚠ READY, NEEDS NO BOX.
      3A.5 row 7 and 3A.6. ▶ Strike both WITH a pointer to J113.
      ⚠ ROW 7 IS SUBTLER THAN RECORDED — it is a CONFLATION OF TWO
        VIEWS, not a flat falsehood. "trace reads received_units
        directly (already present in the view)" is TRUE of
        Trace_ProductProdLotView (JR7d added it in S51) and FALSE of
        Trace_ProductHeaderView (measured absent, J83). Row 7 names
        neither; row 6 above it names ProductHeaderView, so a reader
        carries that down. ▶ THE STRIKE MUST NAME BOTH VIEWS or the
        next reader re-derives the same ambiguity.
P94   Move or delete /home/ubuntu/mo-0001-before-heal-S93.txt on prod.
P100  Dev carries companies 466 and 469. RULES names only 464 and 465
      as sandbox. Two unaccounted tenants.
P101  3B.3 records the dormant `abletrace` archive as living on the
      PROD instance. ⚠ DEV HAS ONE TOO — measured S95.
P102  ⚠ SHARPENED S96, AND IT IS NO LONGER HOUSEKEEPING.
      Both boxes report *** System restart required ***.
      MEASURED S96: prod 31 updates pending, dev 17 (5 security).
      ⚠ THIS IS NOW THE SECURITY ITEM. With port 22 open on both
        boxes and no password path, the ONLY real exposure is an
        unpatched sshd. Patching is the mitigation Minty chose over
        narrowing the firewall.
      ⚠ RULED S95: its own slot, NEVER inside a working session.
        Prod is the live client and runs a DIFFERENT OS from dev, so
        dev does not rehearse it.
      ⚠ VERIFY PM2 STARTS ON BOOT FIRST (pm2 startup / pm2 save) or
        the box comes back without the app. Dev first.
      ⚠ WAS SCHEDULED SAT 1 AUG ~11:30. Not done. RESCHEDULE.
P104  No 1.39 intermediate fixture exists on dev. Build it if a
      direct read is wanted for P93's answer.
P106  acrobatics-map-S91.txt has no queue item. Keep or delete.
P107  units-kg-checklist-S93.md — P82h points at items 2 and 3, so
      part of it is live. Read it before deciding on the rest.
P108  ⚠ J-ENTRIES ACCUMULATE AND NOTHING AGES THEM OUT. Section 5
      holds 113. The JR block is PERMANENT — it is a build script,
      not history. The J-entries SHOULD AGE: an entry settled for
      ~10 sessions compresses to one line pointing at its commit.
      ⚠ WHAT MUST NOT BE COMPRESSED AWAY: disproven theories still
        being re-derived, and notes protecting code that is WRONG ON
        PURPOSE. ⚠ THE SECOND HALF IS NOW P118's JOB — once the code
        carries its own comment, Section 5 does not have to.
      ⚠ S96 DID THIS EXERCISE ON TRAPS AND IT WORKED. Same method:
        walk them one at a time, plain language, rule on each.
      ▶ A REAL JOB, ITS OWN SITTING, AT A CLOSE.
P109  RETIRE THE DORMANT `abletrace` ARCHIVE, BOTH BOXES.
      MINTY'S RULING, S95: the folded client's old data is not needed.
      ⚠ IT ALSO REMOVES A TRAP: prod's ~/.my.cnf defaults to the
        ARCHIVE, so a bare `mysql` lands in the dead database and
        looks completely normal. Has bitten twice.
      ⚠ IRREVERSIBLE. ORDER MATTERS:
        1  Dump it OFF THE BOX first — Mac and Drive. NOT to
           /home/ubuntu, which is not backed up anywhere.
        2  Repoint prod's ~/.my.cnf at abletracelab_live FIRST.
        3  RENAME, leave it days, confirm nothing broke, THEN drop.
      ⚠ 3B.3 gives no reason it was kept. If a retention obligation
        exists it is not written anywhere. CONFIRM BEFORE DROPPING.
      ▶ Dev first, whole way through, then prod. Own sitting.
P110  ⚠ RULES SIMPLIFICATION DRAFTED S95, NOT ADOPTED, NOT COMMITTED.
      44 rules down to 14. The two that govern:
        3  LOOK FIRST — if it is checkable, check it, and do NOT
           write it down. A checkable fact stored goes stale.
        4  WRITE DOWN ONLY FOUR THINGS — Minty's rulings, wrong
           answers already paid for, traps where looking misleads,
           and the database rebuild list. Nothing else.
      ⚠ S96 APPLIED RULE 4 TO TRAPS WITHOUT ADOPTING IT and the file
        went from ~40 to 10. The principle is proven on real work.
      ⚠ THREE MORE RULES, MINTY, S95 — ADD AFTER 14:
        15  EVERY COMMAND IN ITS OWN FENCED BLOCK, never inline.
        16  CLEANUP FINISHES BEFORE THE SESSION CLOSES.
        17  BEFORE CLOSING, CONFIRM THE NEXT SESSION CAN START COLD.
      ▶ FINISH THE REVIEW. ⚠ The draft is in the S95 chat only and
        must be REBUILT from the two rules above, not recovered.
P111  ⚠ QUICKBOOKS INTEGRATION — MINTY, S95. THE TIME HAS COME.
      PHASE 1: INVOICE LEVEL ONLY. JSON payload with customer name,
      address, product SKU/ID, quantity per line. AbleTrace pushes.
      ⚠ EVERY MINTY CLIENT RUNS QUICKBOOKS. Platform feature, not
        one client's request.
      ⚠ IT UNBLOCKS P43: shipping reference may be MULTIPLE INVOICES
        which must match QuickBooks records. Deferred in S82 for
        exactly this reason.
      ▶ ONE FULL SESSION ON PLANNING FIRST. NO CODE. Seven questions
        that cannot be answered from our codebase:
        1  Online or Desktop? Different products, different APIs.
        2  One shared Mintek app each client authorises, or one
           connection per client? Multi-tenant — it shapes everything.
        3  What triggers the push? ⚠ Shipping is TERMINAL with no
           un-ship, so a push fired there cannot be retried.
        4  Do the products already exist in QuickBooks? ⚠ CHECK.
        5  What is the customer key? companycustomers has no
           QuickBooks id. New column + Waterline attribute or the
           write silently vanishes (TRAPS 3).
        6  What happens on a double push? An invoice posted twice
           into a client's accounts is a real-money error.
        7  What happens when it fails? ⚠ A silent failure means the
           client thinks they invoiced and did not.
      ⚠ OAUTH2 IS NOT OPTIONAL AND NOT SMALL. App registration, a
        browser flow, and REFRESH TOKENS THAT EXPIRE. Tokens go to
        Section H, never the repo, never chat.
      ⚠ TEST AGAINST A QUICKBOOKS SANDBOX, never a client's real
        books. There is no undo on a posted invoice.
      ▶ SIZE, HONESTLY: planning one session, build three or four.
```

```
P82   THE ACROBATICS SWEEP — ⚠ RE-RANKED S96 BY MINTY: PRIORITY.
      MINTY, S96: shipping units must come from the source AS
      SHIPPING UNITS. No acrobatics in between. Wherever a unit
      count is rebuilt by dividing Kg it is wrong, EVEN WHEN THE
      ARITHMETIC IS RIGHT. ▶ RESOLVE THEM IN ONE GO.

  P82a  R5 — THE TWO REPOINTS, Trace_ProductHeaderView.
        qty_produced_su → mm.received_units
        qty_shipped_su  → the stored units column
        ⚠ ALREADY RULED GO (S95). Scope measured in J113 — read it,
          nothing needs re-deriving.
        ⚠ THE TRAP THAT WILL BITE IT: a CTE inside the same view
          defines its own alias called qty_shipped which sums
          qty_to_ship and is KG. → TRAPS 10.
        ⚠ PLAN's one-line version of the second repoint is
          INCOMPLETE. The CTE carries a shipped_flag condition that
          a bare SUM would drop — and qty_shipped is incremented at
          PACKING SLIP CREATION, not at ship (J88), so a DO on an
          unshipped slip already has a non-zero tally. THE REPOINT
          IS A COLUMN SWAP, CONDITION PRESERVED.
        ⚠ GATE BOTH BOXES BEFORE THE ALTER, as P91 did. Dev's answer
          is not prod's answer.
        ⚠ RDS ONLY, NOT IN GIT. JR entry in the SAME BREATH.
        ⚠ ONE SCREEN VERIFIES IT: product-traceability-details.
        ⚠ SOH WILL NOT CHANGE. Expected — see P82b. Do not chase it.

  P82b  SOH_su — THE HEADLINE FIGURE, AND THE LAST ONE FIXABLE.
        Stock on Hand is the number anyone actually reads. It
        subtracts five Kg terms then divides. Cannot be
        unit-anchored until every subtrahend is, and one needs the
        schema change in P82c.
        ⚠ THE TWO CHEAP REPOINTS IMPROVE TWO CELLS AND LEAVE SOH
          EXACTLY AS IT IS. That is the ranking question.

  P82c  MISC RELEASE HAS NO UNITS COLUMN AT ALL.
        rejectmaterialandproduct stores Kg only — measured S95.
        Units are typed on the form and DROPPED from the record.
        ⚠ Needs a column, a write-path change, AND A BACKFILL ON A
          LIVE CLIENT derived from Kg — the exact round-trip this
          whole programme exists to eliminate. NOT COSTED.
        ⚠ Return quantity is Kg-only too, same residual.

  P82d  quanity_shipped_to_date (⚠ NOTE THE MISSPELLING — a grep for
        the correct spelling finds nothing) is divided at
        add-dispatch.component.ts:72. BASIS NEVER ESTABLISHED.
        ⚠ soproducts.quantity is KG on the same row while
          quanity_shipped_to_date is UNITS.
        ⚠ J91 ASKED FOR THE READS TO BE FOUND IN S81. Still not done.
        (was P103, folded in S96)

  P82e  Trace_ProductProdLotView selects mm.qty TWICE — once as
        qty_su and once as qty — with no conversion.
        ⚠ BOTH LABELS CANNOT BE RIGHT. (was P98, folded in S96)

  P82f  mlomanagement.received_qty STORES FLOAT GARBAGE. Dev MO-0009
        holds 15.290000000000001. Line 79 prints it raw as the
        bracketed Kg figure. (was P99, folded in S96)

  P82g  /Dispatch-orders renders the shipped figure for DO-0010 and
        DO-0011 as `0 Kg(0#)` while the DB holds 1 for both.
        ⚠ A LIVE WRONG NUMBER ON A SCREEN. (from J110)

  P82h  THE SCREEN WALK — units-kg-checklist-S93.md items 2 and 3.

  ⚠ NOT IN THIS SWEEP, DELIBERATELY. All three divide a Kg source
    and NO STORED UNITS ALTERNATIVE EXISTS ANYWHERE. Correct as they
    stand; nothing to fix until a column exists:
        intermediate_prd_su  ⚠ mprrecievelots has no units column
        qty_packing_slip_su  sums qty_to_ship, Kg
        qty_do_su            same source, same basis

  ⚠ THE FINGERPRINT (J7, and it has held every time): a clean
    fraction like 1 ÷ weight means a UNITS-STORED FIELD IS BEING
    DIVIDED. Trace any "/weight" to whether the source is
    units-stored (do not divide) or Kg-stored (divide is correct).

  ⚠ NEVER VERIFY ANY OF THESE ON A 1:1 PRODUCT. → TRAPS 9.
```

```
NEW IN S96 — from the TRAPS review. ⚠ RANKING IS MINTY'S.

P114  DOES A CLOSED MO STILL COUNT AS IN PROGRESS ANYWHERE?
      MINTY, S96 — THE RULING: A CLOSED MO IS OUT OF IN-PROGRESS.
      Domain rule, not a preference. Whether the code honours it
      everywhere is UNVERIFIED.
      ⚠ CLOSE IS A FILING ACTION, NOT A PRODUCTION STATUS. Minty,
        S96: it moves the MO off the active screen to an inactive
        one. To work on it you bring it back. That is all it is.
      ⚠ IT WAS WRONG IN AT LEAST ONE PLACE. J28 fixed Add-MLO's In
        Progress block, which counted closed MOs because it tested
        only mlc_status. ⚠ ONE INSTANCE FOUND MEANS GREP THE PATTERN.
      ▶ SCREEN FIRST. Close an MO with quantity outstanding, then
        read every In Progress figure: Stock Info popup ·
        formulation-edit Stock Info popup · Add-MLO In Progress
        block · MO progress chart · Products list.
      ⚠ A SCREEN STILL COUNTING IT SHOWS A PLANNER STOCK THAT WILL
        NEVER ARRIVE. That is a wrong number, not a tidy-up.
      ⚠ THE MECHANISM, so nobody re-derives it: closing sets
        close_status=1 and LEAVES mlc_status unchanged — a closed MO
        commonly still reads status 3. "Still open" tests
        close_status; "production complete" tests mlc_status=4.

P115  DELETE THE DEAD CODE SIBLINGS. Prove dead by grep, delete,
      test the screen, commit.
      ⚠ ABSORBS P36 (add-dispatch v1, declared but never opened) and
        P38 (selectOption still being WRITTEN in the .ts while its
        template block is commented out). Also the older
        single-release function beside createReleaseMaterialProductsV2.
      ⚠ WHY IT MATTERS: an edit on a dead path is a SILENT NO-OP —
        the change looks right and does nothing. Cost real time once
        already (J12), and it would be recorded as fixed.
      ⚠ A FUNCTION REACHED BY A STRING OR A ROUTE IS NOT FOUND BY
        GREPPING ITS NAME. Prove dead, then delete, then check the
        app still works.
      ⚠ ALSO STILL OPEN in the same family: PackingSlips.js:333-334,
        the block that would write NaN into inventory if it ran.
        ▶ DELETE IT. NEVER REPAIR IT — a one-line scope "fix"
        converts a loud failure into silent inventory corruption on
        a live client (J85).

P116  FIX THE JSON FILE-LIST READS PROPERLY. Stop carrying a guard
      note instead of finishing the job.
      ⚠ FOUR MODELS HOLD FILE-LIST COLUMNS (J73/J74):
        PurchaseOrders   PO_ref_docs               CRASHED, fixed
        PackingSlips     shipping_reference_docs   guard added,
                         ⚠ NEVER BROWSER-VERIFIED (J75, since S70)
        SOManagement     customer_ref_docs         verified S71
        Documents        safe by code, nothing to guard
      ⚠ PS AND SO WORK ONLY BY ACCIDENT OF THEIR DATA — their create
        path seeds an empty list where PO's left nothing. Tidying
        that away reinstates the crash. → P118 comments it.
      ▶ SCREEN FIRST: attach a document to an EXISTING packing slip
        and an EXISTING sales order. That is the path that had never
        run. Then confirm in the DB — a file chip renders whether or
        not anything saved.
      ⚠ THE GUARD IS "IS THIS A LIST", NOT "IS THIS EMPTY", because
        a future driver may return TEXT — which does not crash, it
        silently shreds the list into single characters.

P117  FILE TOO LARGE MUST SAY SO. Check the size when the user picks
      the file and show "This file is larger than 10 MB".
      MINTY, S96: "no harm in a popup saying your file is larger
      than X, instead of object object coming."
      ⚠ IT CANNOT BE CAUGHT AFTER THE FACT. nginx rejects an
        oversized upload BEFORE the app runs, so there is nothing in
        the logs and nothing for the app to catch. The check has to
        happen in the browser, before sending.
      ⚠ THE LIMIT IS 10 MB on both boxes (JR13). If that changes,
        the message changes with it.
      ▶ EVERY UPLOAD PATH: PO ref docs · packing slip shipping docs ·
        SO customer ref docs · procedure documents · HACCP uploads.

P118  MARK THE DELIBERATE CODE IN THE CODE. Put the reason on the
      line so nobody has to find a document to know it is on purpose.
      MINTY, S96: make them robust instead of appearing weak.
      ▶ FOUR SITES, one comment each:
        · mlcpackaging stores FLAT per-level quantities — the
          cascade is computed at READ time. Correct by design. Do
          not "correct" it to store multiples.
        · the Excel import SKIPS INTERMEDIATES — added by hand after
          upload. MINTY'S DECISION, not a gap.
        · the batch_qty pencil edit was UNCOMMENTED DELIBERATELY,
          tested and shipped (9bce0238). Do not re-comment.
        · ⚠ PS and SO create paths SEED AN EMPTY LIST. That is the
          ONLY reason their reads do not crash the way PO's did.
      ⚠ THE COMMENT MUST SAY WHY, NOT WHAT. "Seeds []" is useless.
        "Seeds [] — removing this reinstates the J73 crash" stops
        the edit.
      ▶ THIS IS THE GENERAL PATTERN, not one job: every warning that
        says "do not touch this" belongs as a comment on the line,
        not an entry in a file. The comment sits three inches from
        the thing being tidied.

P119  BACK UP THE DATABASE'S OWN CODE INTO THE REPO.
      ⚠ WHAT THIS IS ABOUT, IN PLAIN WORDS: part of the app lives
        INSIDE the database — views and stored procedures. They are
        not in GitHub because they were typed straight into the
        database. Today their full text sits mainly in .sql files on
        the PROD box in /home/ubuntu, which is not backed up.
      ⚠ WHAT IS ALREADY SAFE: the added columns, seed data, RDS
        settings and nginx limit are written out IN FULL in JR. Only
        the views and procedures are the gap — too long to write
        out, so they were left as files on the box.
      ⚠ THE SNAPSHOT IN THE REPO IS STALE. db-definitions-S93.txt is
        hand-made, dated S93, and already missing JR7e. P82a will
        make it staler.
      ▶ THE FIX: one command per box writes every view and procedure
        to a file. Commit both. Regenerate whenever one changes, in
        the same breath as the JR entry.
      ⚠ COMMITTING IT DOES NOT PUT IT IN ANY DATABASE. It is a
        photocopy in a safe. Nothing runs it. (J6 warns about
        exactly this confusion.)
      ⚠ DEV AND PROD ARE SEPARATE DATABASES. Dump each, keep both,
        never assume they match.
      ⚠ CHECK THE OUTPUT BEFORE COMMITTING — the repo is public.
      ▶ MINTY, S96: agreed we need to act on it. ⚠ DETAILS TO BE
        WALKED THROUGH AGAIN BEFORE STARTING — recorded so nobody
        begins assuming they already have been.

P120  THE MATERIAL LABEL BARCODE NEEDS THE SAME FIX AS THE PRODUCT
      LABEL. MINTY, S96: resolved on the product label, still to be
      done for materials.
      ⚠ WHAT GOES WRONG: the barcode is drawn from a start position
        at a fixed module width. Nothing warns when it runs past the
        label edge — it prints as far as the media goes and the tail
        is lost. LOSING THE END MAKES THE SYMBOL INVALID, so a
        scanner will not beep at all. ⚠ SILENCE LOOKS EXACTLY LIKE A
        DEAD SCANNER, A FLAT BATTERY, OR A DISABLED SYMBOLOGY.
      ⚠ THE CAUSE IS CONTENT LENGTH, NOT HARDWARE. Code 128 packs
        DIGIT PAIRS two to a symbol; any letter or dash forces one
        module per character.
          "260530"        6 digits    ~68 modules  x BY4 = ~272 dots
          "Pdt-260718-1"  12 alphanum ~167 modules x BY4 = ~668 dots
        A 4x4 label at 203 dpi is 812 dots. At ^FO256 the second one
        ends around 924 — off the label.
      ⚠ THE TELL: the barcode sits visibly OFF-CENTRE, big margin on
        one side and none on the other.
      ⚠ WHAT WAS WRONGLY BLAMED FIRST, in order: the scanner, print
        quality, a disabled symbology, scanner config, app code. All
        wrong. ⚠ A FACTORY RESET WAS ADVISED AND IT WIPES THE UNIT'S
        CONFIGURATION. Do not reset a working scanner to chase a
        barcode fault.
      ⚠ THE MATERIAL LOT FORMAT IS THE WIDE KIND — Mat-260703-13,
        letters plus dashes. The product fix may not transfer as-is.
      ▶ MEASURE THE LONGEST REAL MATERIAL CODE against the label
        width BEFORE changing anything.

P121  SAY WHAT THE "JAVA" PROCESS IS, WHERE SOMEONE WILL SEE IT.
      MINTY, S96: a one-liner in the client printing guide and
      beside the printing code, so the confusion cannot happen again.
      ⚠ THE FACT: Zebra Browser Print ships its own bundled Java
        runtime, so on a Mac it appears as "java" with NO VENDOR
        NAME. It holds BOTH 9100 and 9101 under ONE process id.
          /Applications/Browser Print.app/Contents/MacOS/jre/bin/java
      ⚠ WHY IT MATTERS: a document in this repo once said the
        OPPOSITE — that a java process may be blocking Browser Print
        and should be killed. FOLLOWING THAT TELLS A CLIENT TO KILL
        THEIR OWN PRINTER SOFTWARE. Corrected S91, but the fact is
        nowhere a client would look.
      ⚠ FOR THE GUIDE: "java" names a RUNTIME, not a program. Read
        the full path before concluding anything about a process.

P122  PUT THE WHOLE PRINTING SETUP INTO THE CLIENT GUIDE, IN ORDER.
      MINTY, S96: get to the root of it and give clear direction.
      ⚠ THERE ARE THREE BARRIERS, NOT ONE, AND THEY FIRE IN A FIXED
        ORDER. Barrier 1 blocks the connection outright, so 2 and 3
        CANNOT APPEAR until it is cleared. S91 cleared the
        certificate, saw printing work, and recorded the certificate
        as the whole story. It was the first gate of three.
        1  CERTIFICATE  browser warning at https://localhost:9101.
           Advanced → Proceed.   Per BROWSER, per USER.
        2  CHROME LOCAL NETWORK  "wants to access other apps and
           services on this device" → ALLOW.  Per browser, per site.
        3  BROWSER PRINT  "wants to access your Zebra Devices" →
           YES.   Per user, PER HOSTNAME.
      ⚠ 2 AND 3 FIRE ON THE FIRST PRINT, NOT DURING INSTALL. Anyone
        documenting setup and stopping at "it prints" misses both.
      ⚠ CLICKING BLOCK OR NO BREAKS PRINTING SILENTLY AND
        PERMANENTLY, and they are undone in DIFFERENT PLACES —
        Chrome site settings for one, Browser Print's own Blocked
        Hosts list for the other. The app shows only "print failed".
      ⚠ PER HOSTNAME, PROVEN: dev and trace are SEPARATE entries.
        Testing on dev does NOT pre-authorise prod.
      ⚠ REINSTALLING OR UPDATING BROWSER PRINT MAKES A NEW
        CERTIFICATE. Every browser exception breaks at once,
        silently, showing only "Failed to fetch".
      ⚠ THE APP CANNOT DIAGNOSE ANY OF IT. A rejected certificate
        tells the page NOTHING — untrusted cert, helper not running,
        and helper never installed all produce the IDENTICAL error.
        The guide is the only fix.
      ⚠ ON localhost THE PADLOCK READS "NOT SECURE" FOREVER, even
        while printing works. Normal. Photographed S92 alongside a
        successful print. ⚠ Do not confuse it with the app URL,
        where the same chip HAS been a real fault — see P123.
      ⚠ BROWSER PRINT'S CONTROLS ARE IN THE MENU BAR, TOP RIGHT, NOT
        THE DOCK. Clicking the Dock icon appears to do nothing.
      ⚠ THE DOWNLOAD IS NOT UNDER "DRIVERS AND DOWNLOADS" — that
        path leads to a printer DRIVER, which installs the macOS
        print path and invites adding the Zebra in Printers &
        Scanners, THE EXACT THING THE PROCEDURE FORBIDS. The wrong
        door does not dead-end, it succeeds at the wrong thing.
        Correct: main site → Support and Downloads → SOFTWARE →
        Browser Print. Labelled "For OSX", not Mac.

P123  "NOT SECURE" TROUBLESHOOTING INTO THE CLIENT GUIDE.
      ⚠ IT HAS NEVER ONCE BEEN THE SERVER. Chased five times across
        three sessions and two Macs. Certificates valid, http
        redirecting correctly, every single time.
      TWO CAUSES, BOTH ON THE CLIENT SIDE:
        1  a long-open tab holding a CACHED security verdict →
           FULL QUIT of the browser, not a refresh
        2  a bookmark pointing at http:// → the chip shows for the
           instant before the redirect completes → fix the bookmark
      ▶ THE FIX FOR A USER: quit the browser completely, reopen, and
        TYPE the address rather than using the bookmark.
      ▶ FOR US, BEFORE TOUCHING NGINX OR CERTBOT: curl -I the http://
        address. A 301 means the server is doing its job.
```

```
DEFERRED — on dev, not promoted
      Licence banner shows on all role tabs. Fix: gate the *ngIf on
      selectedRole===2. Commits dfbadbb0 and 277b2491, dev only.

OPEN DEFECTS — diagnosed, not fixed
      ⚠ DEFECT 1 CLOSED S93 · P92 CLOSED S94 · P91 CLOSED S95.
      Defect 2: display reconstructs units as Kg / weight. ⚠ THIS IS
      P82. The whole sweep is Defect 2's remaining sites.
      ⚠ THERE IS NO THIRD DEFECT. The "version fork writes ship_qty
        0" claim is FALSE and never was true (J81). "Fix A" is a
        dead name.

FROZEN SPEC — ⚠ ALREADY BUILT
      P52 printed packing slip. J112 records it BUILT AND SHIPPED TO
      PROD IN S86 (ba3bfe9f + 8997acdc), with totals, page footer and
      barcode DELIBERATELY NOT BUILT — "decisions, not a backlog, do
      not re-raise". ▶ One look at a printed slip closes it.

NOT ON THE QUEUE AND PROBABLY SHOULD BE
      CERTIFICATE MONITORING. Nothing watches renewal on either box
      and no email setting can change that (Let's Encrypt stopped
      storing contact addresses, 4 Jun 2025). Trace expires 17 OCT
      2026. The fact survives in STATE; the action item does not.
```

---

## WHAT COST TIME IN S96

```
1  ⚠ THE WHOLE SESSION OPENED LOCKED OUT AND NEVER REACHED THE APP.
   R5 was job 1 in PLAN and was not started.

2  ⚠ CLAUDE TRIED TO DISMANTLE A MEASURED FACT TO FIT A
   RECOLLECTION. Dev's :22 rule was read off the console — one
   address, not Minty's. Minty recalled ssh'ing to dev from a
   campsite, which that rule makes impossible. Claude began
   hypothesising that the rule had been edited, and drafted a
   CloudTrail hunt and an SSM project on top of it.
   ⚠ ONE DATE KILLED IT: dev launched 7 Jul, the campsite was
     22-27 Jun. The launch time was ON SCREEN THE WHOLE TIME and
     Claude did not join it to the campsite until Minty asked
     "can u check what date did we set the dev".
   ▶ WHEN A MEASUREMENT AND A RECOLLECTION CONFLICT, LOOK FOR A
     THIRD MEASUREMENT THAT DATES THEM. Do not rebuild the
     measurement to fit the memory.

3  Claude framed the prod fix as "narrow port 22" and presented a
   false pair — open or stranded. ⚠ MINTY CAUGHT IT: a developer
   cannot be expected to work from a fixed location. The correct
   framing was three options, not two.

4  ⚠ CLAUDE CALLED 162.156.123.117 "your home address" for four
   messages before noticing it had never been measured — it was a
   number in a rule. It later proved correct via two login banners,
   but it was asserted before it was known.

5  Claude proposed logging the ssh findings as P112/P113. ⚠ MINTY
   RULED: that is an AWS setting, not a trap. Do not log it.
   ▶ THE RULING GENERALISES AND IS NOW IN TRAPS: if it can be
     fixed, it is a queue item. If nothing is broken, it is nothing.
```
