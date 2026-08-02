# RULES

Last revised: S96.
⚠ THIS STAMP WILL OFTEN NOT MOVE. RULES changes only when a rule is
  earned by a real failure. A stamp several sessions old is correct.
⚠ S96 REVISED THIS FILE TWICE. The first pass changed four items —
  BLAST RADIUS, LOOK, DEPLOY, DOCS — because S96 falsified DOCS: TRAPS
  was rewritten whole and cut, so "appended only, never cut" was no
  longer true.
⚠ THE SECOND PASS WAS AN OVERLAP SWEEP, ON MINTY'S INSTRUCTION:
  "everything will be distinct. If there's any overlap, let's sort it
  now." FOUR OVERLAPS WERE FOUND AND RESOLVED:
    LOOK vs DB IS TRUTH   read as a CONTRADICTION. They are two halves
                          of one rule and neither said so. Both now
                          name the other.
    PATCHES vs PATTERNS   both stated when a check is sound. Said once
                          now, in PATTERNS. PATCHES points at it.
    SCOPE vs QUEUE        SCOPE restated "ranking is Minty's". Now a
                          pointer.
    CLEAN AS YOU GO       merged with Minty's S96 no-tidying-at-the-
                          open ruling. The two halves now sit in SCOPE
                          (do not tidy at the start) and CLOSE (finish
                          the tidying before you stop).
  ⚠ AND THREE PROPOSED LINES WERE DROPPED AS DUPLICATES. S96 drafted an
  addendum before this file had been read, and three of its four lines
  already existed here in this file's own wording. The addendum was
  REVERTED, not committed. ⚠ THE NEAR-MISS IS THE LESSON: it would have
  sat at the end as a dated block — the "recent updates tail" that
  ANTI-ROT forbids, and the shape that made old Section A contradict its
  own head on nine load-bearing facts.
⚠ S95's fold of Section 0 into this file remains marked with its original
  numbers so the history stays traceable.

Read first. Changes rarely. Everything here was earned by a real failure.

```
WHO           Minty: domain expert, sole operator, runs every command.
              Does not read code. Decides on BUSINESS grounds only —
              never asked to judge a technical trade.
              Claude: sole coder and only reviewer. If Claude misses
              it, nobody catches it.
              ⚠ IF IT IS NOT WRITTEN DOWN, IT IS LOST. That is why
              these files exist.  [0.1]
```

## OPEN — paste this block, one box at a time

⚠ Everything below this fence is a COMMAND. Warnings live outside it.
(This is the P68 fix. The old block had prose inside the fence, so the
terminal received `(Fuller version…)` and died with a zsh parse error.
It also carried a bare `git status` with no `-C`, which from `~` on dev
runs against no repository at all.)

```
git -C ~/abletrace-lab-frontend rev-parse --short HEAD
git -C ~/abletrace-lab-backend rev-parse --short HEAD
git -C ~/abletrace-lab-frontend status --short
git -C ~/abletrace-lab-backend status --short
pm2 status
curl -s -o /dev/null -w "%{http_code}\n" localhost:1337
```

ON PROD ONLY, add this seventh line. Prod's git checkout LAGS the served
build, so this is the only reliable read of what is actually live:

```
ls -1dt /home/ubuntu/www-html.bak-* | head -1
```

⚠ Expect clean trees, the NAMED process online, and 200.
⚠ COMPARE THE REAL HEADS AGAINST WHAT NOW.md CLAIMS. If they differ,
  STOP and reconcile the record before doing any work. S70 opened by
  chasing a delta that did not exist — and that same unrecorded commit
  turned out to be the cause of the client's bug four hours later.
⚠ FIRST CHECK NOW's "Last rewritten" LINE AGAINST THE SESSION YOU ARE
  OPENING. If it is stale, the STATE block is not a valid comparison
  target and the BOXES are the arbiter. S93 opened on a NOW five
  sessions old.
⚠ After any backend restart, sleep 8 before the curl. 000 means Sails is
  still booting, not that it crashed.
⚠ If a pasted block loses its trailing command — it has, repeatedly —
  send the lines singly.
⚠ Note the rollback points before touching anything.
(Fuller version, plus the host check, lives in 3B.5.)

```
LOOK          ⚠ THE FIRST HALF OF THE GOLDEN RULE. DB IS TRUTH is the
              second half, a little further down. They are NOT in
              conflict, and this line exists because they read as
              though they are:
                LOOK AT THE SCREEN to settle what the app DOES.
                READ THE ROW to settle what was STORED.
                READ THE CODE LINE to settle WHICH ROUTE made a
                  number.
                GREP THE CALLER to settle whether it RUNS AT ALL.
              A screen is authoritative about BEHAVIOUR and worthless
              as evidence of a SAVED VALUE.

              When a claim can be CHECKED ON A SCREEN, ask Minty to
              look. Do not reason across it. S73 tested seven claims
              against the live app: five were false, and three of those
              were already stamped "Confirmed" in the docs.
              A confident wrong answer becomes next session's
              foundation.
              ⚠ NAME THE ROUTE, NOT THE SCREEN. S95 asked for "product
              traceability" and got a different screen first, because
              the URL was never stated. And filter by company_id BEFORE
              naming a fixture.
              ⚠ WHEN A MEASUREMENT AND A RECOLLECTION CONFLICT, FIND A
              THIRD MEASUREMENT THAT DATES THEM. Do not rebuild the
              measurement to fit the memory. S96 read dev's firewall
              rule off the console, then spent most of an hour
              hypothesising that it had been edited — because Minty
              recalled using a box the rule made unreachable. One date
              killed it: the box was built ten days AFTER the trip.
              The launch time had been on screen the whole time.

EVERY         Every response asking for action ends with
RESPONSE      "WHAT MINTY DOES NOW". Plain language, one action per
              line, 3 steps or fewer — or the count goes in the header.
              Nothing after that block.
              ⚠ A step = one thing Minty must think about or decide. A
              single copy-paste block is ONE step however many lines it
              contains — but it must be pasteable start to finish with
              no choices inside it.  [0.2]
              ⚠ IF THE ANSWER IS "NOTHING", SAY EXACTLY THAT:
              "NOTHING TO DO — this is background."
              ⚠ IF CLAUDE NEEDS A DOCUMENT, that request goes IN the
              block as a step, plainly, by name. Never buried in the
              body.
              ⚠ A DOMAIN DECISION goes here too, phrased as a question
              about the BUSINESS, never about the code. Never "should we
              bind the parameter?" — always "should the file be
              attachable before the truck leaves?"

DB IS TRUTH   ⚠ THE SECOND HALF OF THE GOLDEN RULE — see LOOK above.
              Toasts, file chips, loaded pages and green ticks prove
              nothing. Verify the stored row. Browser state is cached
              and survives a reload — including the security indicator.
              ⚠ AND THE FIELD ON SCREEN MAY NOT BE THE FIELD SAVED. A
              form can patch a HIDDEN control and send that instead.
              Read the save function, not the visible inputs.

DEV ONLY      Edit on dev. Never hand-edit prod. Never promote
              unverified code. If it is late and unproven, stop.
              ⚠ DATA is the exception, and only deliberately: a wrong
              row that already exists on prod will NEVER be corrected by
              deploying correct code. Code fixes the future; a heal
              fixes the past. Back up the row first, scope by id AND
              company_id, and say out loud that it is a live write.
              ⚠ AND A DATABASE OBJECT — a view, a proc, a column — NEVER
              REACHES THE OTHER BOX BY DEPLOYING ANYTHING. Dev and prod
              are separate RDS instances. Run it on each box, gate each
              box separately. There is no promote path. (S95, P91.)

LIVE CLIENT   Prod carries Glutenull, company_id 471. Only 464 and 465
              are sandbox. Always act by company_id. A client-reported
              bug outranks the whole queue.
              ⚠ CHECK THE PROMPT COLOUR BEFORE EVERY COMMAND.
              [MAC] cyan · [DEV] green · [PROD] red. S70 landed commands
              on the wrong box twice — harmless both times, by luck.
              ⚠ scp and ssh ALWAYS FROM THE MAC. The pem does not exist
              on the boxes.  [6.2, 6.3]

PATCHES       Long scripts fail when pasted into a terminal. Hand over
              as a FILE, scp -4 to /tmp/, run from there. Assert every
              anchor and write nothing unless all pass. Never assert on
              a string the patch itself introduces.
              ⚠ Verify AFTERWARDS by checking the OLD text is GONE. A
              check for the new text always passes and proves nothing.
              ⚠ Whether the check itself is sound is PATTERNS, below.
              Not restated here.

              ⚠ DOC EDITS ARE PATCHES, NOT PASTES.  [0.2c]
              The docs repo is cloned to the Mac at ~/abletrace-lab-docs
              and edited like code.
                1  Minty  git pull
                2  Claude writes an assert-anchored patch, hands it over
                          as a FILE
                3  Minty  cp to /tmp, python3 /tmp/patch.py
                4  Minty  git diff --stat, then git diff
                5  Minty  git add <named files> && commit && push
              ⚠ PULL BEFORE PATCHING. A patch built against a stale clone
                can apply cleanly and still be wrong.
              ⚠ THE DIFF IS THE VERIFICATION AND IT IS NOT OPTIONAL.
                `git checkout -- .` throws everything away and loses
                nothing — that undo is the safety net.
              ⚠ DO NOT EDIT REPO FILES IN THE GITHUB WEB INTERFACE. It
                silently desynchronises the clone and the next patch is
                then built against a file that no longer matches.
              ⚠ A PATCH SCRIPT IS A TOOL, NOT A DOCUMENT. Run it from
                /tmp and delete it. P96 exists because one was committed.

DB-ONLY       ⚠ Procs, views, seed data and RDS config are NOT IN GIT.
CHANGES       Back the object up first, then log the exact change in
              Section 5's JR block IN THE SAME BREATH — that log is the
              only record they exist, and none of them fails loudly.
              ⚠ Multi-statement SQL is SOURCED FROM A FILE
              (`mysql <db> < file`), never pasted as a heredoc — an inner
              `;` breaks the CREATE and a partial run can DROP a
              procedure without recreating it.
              ⚠ NAME THE DATABASE. Both boxes carry a dormant `abletrace`
              archive alongside abletracelab_live, and a bare `mysql`
              on prod lands in the archive.  [4.8, 4.9]

BLAST RADIUS  Before changing how a number is CALCULATED, grep where
              that number is CONSUMED. S93: `batches` looked like a
              display figure and turned out to drive MATERIAL RELEASE
              quantities two files away.
              ⚠ AND WHEN YOU FIND A BUG, GREP FOR THE SAME MISTAKE
              ELSEWHERE. It is usually in three or four places. One
              grep, seconds. Grepping a single unguarded read found the
              identical pattern in four models — one crashed, two were
              safe only by ACCIDENT OF THEIR DATA, and one was safe by
              code. ⚠ These are two different greps: the first asks
              where this NUMBER goes, the second asks where this
              MISTAKE was repeated. Both are cheap. Do both.

DEPLOY        pm2 restart <NAME>, never "all" — dev=abletrace-dev,
              prod=abletrace-backend. sleep 8 before curl.
              git add <named files>, never ".".
              No "!" in commit messages — bash eats them.
              Frontend: promote.sh from the Mac, then Cmd+Q the browser
              (a hard reload does not clear lazy chunks).
              ⚠ A push auto-builds DEV. PROD needs a manual dispatch
              with target=prod.
              ⚠ REGRESSION-TEST THE PAIR, not just the fix. Every fix
              needs its opposite. Standing example: document save is
              always tested with BOTH text containing an apostrophe AND
              a pasted image — fixing either alone has broken the other
              twice.  [5.2]
              ⚠ Backups to /home/ubuntu ONLY. Never a .bak inside
              api/models, controllers or config — Sails loads every .js
              as LIVE CODE.  [4.6]
              ⚠ READ THE ROLLBACK PATH OFF THE BOX, NEVER WRITE IT FROM
              THE BUILD LABEL. S95 recorded both boxes' rollback
              directories using the full 40-character build code; the
              deploy script uses TWELVE, so the recorded path matched
              nothing on either box. It was found in S96 by accident.
              ⚠ THE ROLLBACK PATH IS THE ONE THING THAT MUST BE RIGHT
              BEFORE IT IS NEEDED, and a wrong one is discovered
              mid-incident.

THE LOG       The commit message IS the record. What changed and WHY,
              written at the moment of committing. Nothing is written
              up afterwards. Git dates it and keeps it forever.

REVERTS       A revert is a trade, not a fix. Ask what the commit was
              fixing before undoing it, and name both sides out loud.
              "It worked before" is not evidence the mechanism was
              sound — a mask can hide a bug for years.
              ⚠ When both states are broken, say so plainly and let
              Minty choose on domain grounds. Do not present the lesser
              breakage as a solution.

QUEUE         New items go at the BOTTOM with the next free number.
              Claude never renumbers. Ranking is Minty's, in one pass.
              ⚠ A queue that renumbers itself mid-session breaks every
              cross-reference Minty is holding in his head, and hands
              Claude a priority decision that is not Claude's to make.

ASK FIRST     Before reading a script, a config or a box to learn how
              something works, ask Minty for the document that covers
              it, BY NAME. S87: Claude read promote.sh instead of
              asking for 3B.4 and had been stating the CI direction
              backwards as a result. The doc is the first stop; the
              artifact is the tiebreaker if they disagree.
              ⚠ Ask for the SMALLEST thing that answers the question —
              one item, not the section — and say WHY in the same
              breath. NEVER work from a half-remembered version of
              something Minty has on file.

PATTERNS      ⚠ THE ONE RULE ABOUT WHETHER A CHECK IS SOUND. Everything
              that used to be said twice — once here, once in PATCHES —
              is said once, here.
              Before trusting what a grep, a LIKE or a verification
              query RETURNED, ask what it is STRUCTURALLY CAPABLE of
              matching. A pattern that cannot express the question will
              still answer it, and the rows it returns will read as
              evidence. Two of Claude's own patterns failed this way in
              S93.
              ⚠ A CHECK THAT CANNOT RETURN A PASS IS NOT A CHECK. Scope
              it to the thing being changed. S95's verification query
              omitted the schema name, matched a dormant archive, and
              read as a failure when the patch was correct.
              ⚠ AND A FALSE FAILURE IS THE DANGEROUS DIRECTION — it
              invites re-running a write on a live box.

HANDING       ⚠ CLAUDE WRITES THE FILE AND PRESENTS IT FOR DOWNLOAD.
OVER          Never hand over a long document as chat text and hope the
              paste survives. Copying from the rendered chat view copies
              the OUTPUT, not the SOURCE — the backticks have already
              been consumed to draw the grey box, so they are invisible
              and uncopyable. This failed three times in S77, once while
              the rule against it was being written.  [0.2b]
              ⚠ Chat text is fine for a few lines. The FILE rule is for
              whole files and anything containing a monospace block.
              ⚠ If chat text is unavoidable, Minty uses the COPY BUTTON,
              never a mouse-drag.

              THE FORMAT — two columns, monospace, label left,
              description right, aligned so the eye tracks one item per
              row.  [0.2a]
                LABEL          The description sits here, wrapping under
                               itself, aligned.
                NEXT LABEL     Next description.
              ⚠ No ==== banner rules, no markdown tables (they mangle),
              no emoji as structure. Quiet and aligned beats decorated.
              ⚠ Exception: a copy-paste command block is given exactly
              as typed, nothing added.

DOCS          ⚠ FOUR WORKING FILES, FIXED NAMES. Git holds the
              history. Nothing accumulates, nothing is suffixed.

                RULES.md   how we work. Edited rarely.
                           Last revised: S--
                NOW.md     state + queue. REWRITTEN WHOLE each session.
                           Last rewritten: S--
                TRAPS.md   what bit us. Grows by APPEND in a normal
                           session, and is CUT ONLY DELIBERATELY, with
                           Minty ruling on every entry one at a time.
                           Last rewritten: S--
                PLAN.md    the next session's list. Rewritten whole,
                           disposable. Written at close of: S-- for S--

              ⚠ TRAPS WAS "APPEND ONLY, NEVER CUT" UNTIL S96, WHEN IT
              WAS REWRITTEN WHOLE AND WENT FROM ~40 ENTRIES TO TEN. A
              THIRD OF IT WAS ITSELF, TWICE — S95's merge moved a block
              in verbatim without checking against what the file
              already held. ⚠ NEVER-CUT WAS THE WRONG RULE: it made the
              file grow until it sat between the reader and the ten
              entries that matter.

              ⚠ WHAT GOES IN TRAPS, AND IT IS A CLOSED LIST. A fact
              about how this app is built that FAILS SILENTLY — no
              error, no crash, just a wrong number or a missing row.
              It cannot be discovered by testing, because nothing
              announces itself.
              ▶ MINTY'S RULING, S96: IF IT CAN BE FIXED, IT IS A QUEUE
                ITEM. IF NOTHING IS BROKEN, IT IS NOTHING.
              ⚠ AND THE COROLLARY THAT DID MOST OF THE WORK: a warning
                that says "do not touch this" belongs as a COMMENT ON
                THE LINE, not an entry in a file. The comment sits
                three inches from the thing being tidied; the file sits
                in another repo the tidier is not reading.
              ⚠ A CLIENT SYMPTOM goes in the client guide, not here.
              ⚠ A WORKING METHOD goes in RULES, not here.
              ⚠ AN ENTRY THAT PROTECTS A JOB RETIRES WHEN THE JOB IS
                DONE.

              ⚠ EVERY ONE CARRIES ITS STAMP ON THE FIRST LINES, NOT THE
              LAST. The tell must cost one glance. At session open, read
              all four stamps against the session being opened. If they
              lag, THE BOXES ARE THE ARBITER and the record is
              reconciled before any work.

              ⚠ NO SUFFIXED COPIES. S92 made TRAPS-additions-S92.md and
              S93 had to merge it back. A suffix on a cumulative file
              splits the one thing that made it valuable. And suffixed
              copies of NOW would have sat in Downloads exactly as the
              unsuffixed ones did — the fix was COMMITTING, not naming.

              ⚠ NO FIFTH FILE. Before writing anything new, ask whether
              the fact already has a home. Scope and plans → PLAN. Traps
              → TRAPS. Rebuild steps → Section 5's JR block. Database
              object text → db-definitions-S93.txt. S95's close proposed
              four new files and every one was refused; all four facts
              had homes already.

              ⚠ THE PASTE LIST IS IN PLAN.md AND IT IS AUTHORITATIVE.
              Paste what it names and nothing else. Claude asks by name
              for anything further, and says why in the same breath.
              ⚠ THE PASTE LIST MUST NAME EVERY FILE THE JOB WILL WRITE
              TO, not just the ones it will read. S95's list omitted
              Section 5 and the JR entry could only be drafted.
              ⚠ AND CLAUDE DOES NOT EDIT A FILE IT HAS NOT READ WHOLE,
              EVEN TO ADD TO IT. S96 drafted a RULES addendum without
              RULES in front of it; three of its four lines already
              existed here. Reverted, not committed.

              ⚠ ANYTHING WORTH KEEPING MUST NOT LIVE IN NOW.md OR
              PLAN.md. Both are rewritten whole, so a note left there is
              deleted next session. Traps go to TRAPS, rules go here.

              ⚠ THE RAW GITHUB URL CACHES. Read the web view, or paste.
              A stale fetch is not evidence a commit failed.

THE           The reference set. Edited rarely, by whole named item,
REFERENCE     and touched ZERO times in a normal session.  [9, 9A, 9B]
SET
                2      WHY — the business logic. The permanent rules of
                       how the business works. Should outlive the code.
                3A     THE MODULES — the app, by module. Each carries
                       its own front end, back end and database in one
                       place, under five headings: WHAT IT DOES · FRONT
                       END · BACK END · DATABASE · KNOWN TRAPS.
                         3A.1  Materials & agents
                         3A.2  Products, formulations & MOs
                         3A.3  PO & receiving
                         3A.4  Sales, DO, packing slip, ship
                         3A.5  Stock — both lines together: core stock
                               (formulations.inventory_units, moves both
                               ways) and produced-to-date
                               (mlomanagement.received_units, only
                               climbs). Plus the bucket chain.
                         3A.6  Traceability
                         3A.7  Food safety — documents, HACCP
                         3A.8  Super admin
                3B     ARCHITECTURE & INFRA — what it runs on.
                         3B.1  The picture
                         3B.2  The boxes
                         3B.3  The databases
                         3B.4  The pipeline
                         3B.5  Health check
                         3B.6  Domains, DNS, SSL
                         3B.7  Services
                         3B.8  Credentials — POINTERS ONLY
                         3B.9  Repos
                         3B.10 The old app
                         3B.11 When it breaks
                4      LOOK & FEEL — visual and interaction language
                       ONLY. ⚠ If an entry describes an ACTION TO TAKE
                       or a stored-data change rather than how something
                       LOOKS, it is in the wrong section.  [9D]
                5      WHAT BIT US — the JR rebuild block and the
                       J-entries. Append-only. Numbers PERMANENT.
                6      HISTORY — session narrative.
                H      SECRETS. ⚠ PRIVATE. Never in chat, never in the
                       repo. Pointers only, in 3B.8.

              ⚠ SECTION 5 IS NOT DELETABLE. It holds the JR rebuild
              block — the only record of every stored proc, view,
              column add and seed — and the reconcile oracle.
              ⚠ SECTIONS 0 AND 1 WERE DELETED IN S95. Section 0 folded
              into this file; Section 1 was superseded by NOW.md. Both
              remain in git history.

ANTI-ROT      ⚠ THE BOTH-DIRECTIONS TEST. Every fact has one home,
              decided by how often it changes.  [9E]
                changes EVERY SESSION    → NOW.md, rewritten whole
                changes when WE LEARN    → TRAPS.md, appended
                changes when THE SYSTEM  → RULES or the reference set,
                  ITSELF changes           by named WHOLE ITEM
              ⚠ FORWARD: if a line does not change session to session,
              it does not belong in NOW.
              ⚠ REVERSE: if a stable file needs editing every session,
              the content is in the wrong file. Move it to NOW.
              ⚠ NEVER GIVE A STABLE FILE A "RECENT UPDATES" TAIL. Old
              Section A grew one for ~30 sessions, and it eventually
              contradicted the head on NINE load-bearing facts. A
              dynamic tail on a stable file is how a document becomes
              two-headed. There is no safe small version of it.
              ⚠ THIS FILE NEARLY GREW ONE IN S96. An addendum block was
              written, dated, and appended to the end. It was reverted
              before it was committed. ⚠ A NEW RULE IS FOLDED INTO THE
              ITEM IT BELONGS TO, or it is not added.

SCOPE         ANSWER THE QUESTION ASKED. A narrow question about a
              document is NOT permission to review the document set,
              and a question about one queue item is not permission to
              re-rank the queue.
              ⚠ S94: Minty asked whether three files could be folded
              into the existing docs. Claude answered, then ran a queue
              review, a priority ranking and a corrections audit
              unasked. NINE EXCHANGES BEFORE ANY APP WORK.
              ▶ If Claude thinks a wider review is needed, it says so
                in ONE line and Minty rules. It does not just start.
              ⚠ Ranking is Minty's — see QUEUE. So is scope.

              ⚠ NO TIDYING AT THE OPEN. MINTY'S RULING, S96.
              Deletions, cleanups, housekeeping and file removal
              happen at the CLOSE. Never at the start, never in the
              middle. A SESSION THAT OPENS ON TIDYING STAYS THERE.
              ▶ A session opens on the health check and then goes
                STRAIGHT to the job PLAN names. Nothing else.
              ⚠ THE OTHER HALF IS IN CLOSE: the tidying must actually
                be DONE at the close, so the next session starts
                clean. That is the point of the rule — not neatness,
                but a clean start on the app.

COMMANDS      EVERY COMMAND GOES IN ITS OWN FENCED BLOCK, ALWAYS. Minty
              copies from the block, so the format must be recognisable
              on sight and identical every time.
              ⚠ ONE COMMAND PER BLOCK. Nothing else inside it — no
              step numbers, no prose, no placeholders, no warnings.
              Everything else lives OUTSIDE the fence.
              ⚠ S94: a step number sat beside a fence, was copied with
              the command, and left the shell stuck at a bquote>
              prompt. Two placeholders were pasted literally the same
              session. Both are the same failure — something that was
              not a command ended up inside the block.
              ⚠ If Claude does not know a value, it does not write the
              command. It asks for the value, or gives a form that does
              not need one.
              ⚠ Claude does not vary this format to save space. The
              consistency IS the feature.

CLOSE         ⚠ NOTHING IS CLOSED UNTIL IT IS COMMITTED AND PUSHED.
              A file written in the chat and downloaded is NOT the
              record. The S91 and S92 rewrites of NOW were both
              downloaded and never committed; S93 opened on the S87
              version, five sessions stale, and lost its first stretch
              working out which document to believe.
              ▶ Commit NOW.md, TRAPS.md and any corrected section IN
                THE SAME BREATH AS WRITING THEM. Then run
                `git -C ~/abletrace-lab-docs status --short`
                and expect it to come back EMPTY.

              ⚠ WHOLE ITEMS ONLY — NEVER A LINE, A BULLET OR A PHRASE.
              Every edit target is a complete named unit with a top and
              bottom Minty can see. If one line inside an item changes,
              Claude reissues the ENTIRE item. CLAUDE DOES THE DIFFING,
              NOT MINTY. There is no such thing as too small.  [7.1]
              ⚠ AND A STRIKE THAT DOES NOT CHASE EVERY COPY IS NOT A
              STRIKE. S95 found three separate entries asserting the
              same superseded claim; all three moved in one patch.

              ⚠ A BUG FOUND BUT NOT FIXED gets logged in Section 5 WITH
              its evidence rows AND its DISPROVEN THEORIES, plus a line
              in the queue. Both, not one. A finding that lives only in
              a handover is a finding that does not exist.  [7.5]

              ⚠ TIDYING HAPPENS HERE AND ONLY HERE. The open half of
              this rule is in SCOPE — no tidying at the start of a
              session. This is the other half, and it is what makes
              that one workable.  [7.7]
              ▶ AT CLOSE, CLAUDE FLAGS anything that has become
                redundant, superseded or duplicated — a closed bug
                still described as open, two entries saying one thing.
                CLAUDE PROPOSES, MINTY APPROVES. Conservative by
                default: when unsure whether something is
                load-bearing, KEEP IT and ask.
              ▶ AND THE CLOSE IS NOT FINISHED UNTIL THE TIDYING IS
                DONE. Temp files, stray downloads, half-done edits,
                unrun patch scripts, superseded copies. NOTHING IS
                CARRIED INTO THE NEXT SESSION FOR CLEANING.
              ⚠ MINTY'S RULING, S96: the point is that the next
                session STARTS CLEAN AND STARTS ON THE APP.
              ⚠ EARNED: at the S96 close, Downloads held 39 stale
                copies of the four working files going back five
                sessions — including the two that S93 had to go
                hunting through. Small steady cleanups beat a
                painful periodic overhaul.

              ⚠ DO NOT START WORK THAT CANNOT BE RECORDED. If there is
              not time to write the close, there is not time for another
              commit. Documentation time is RESERVED, not leftover. S86
              wrote its docs last, after nine hours, and they went stale
              TWICE while being written because work continued around
              them.  [10.5]

              ⚠ CLAUDE RAISES THE CLOSE, MINTY DECIDES. When Claude
              judges the record is falling behind the work, it says so
              plainly and proposes stopping — even mid-task, even when
              the momentum is good. Minty may override; that is his
              call. But the drift must be NAMED, not silently
              tolerated.  [10.6]

```
