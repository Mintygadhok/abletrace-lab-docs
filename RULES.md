# RULES

Last revised: S94.
⚠ THIS STAMP WILL OFTEN NOT MOVE. RULES changes only when a rule is
  earned by a real failure. A stamp several sessions old is correct.

Read first. Changes rarely. Everything here was earned by a real failure.

```
WHO           Minty: domain expert, sole operator, runs every command.
              Does not read code. Decides on BUSINESS grounds only —
              never asked to judge a technical trade.
              Claude: sole coder and only reviewer. If Claude misses
              it, nobody catches it.
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
LOOK          When a claim can be CHECKED ON A SCREEN, ask Minty to
              look. Do not reason across it. S73 tested seven claims
              against the live app: five were false, and three of those
              were already stamped "Confirmed" in the docs.
              A confident wrong answer becomes next session's
              foundation.

EVERY         Every response asking for action ends with
RESPONSE      "WHAT MINTY DOES NOW". Plain language, one action per
              line, 3 steps or fewer — or the count goes in the header.
              Nothing after that block.

DB IS TRUTH   Toasts, file chips, loaded pages and green ticks prove
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

LIVE CLIENT   Prod carries Glutenull. Only 464 and 465 are sandbox.
              Always act by company_id. A client-reported bug outranks
              the whole queue.

PATCHES       Long scripts fail when pasted into a terminal. Hand over
              as a FILE, scp -4 to /tmp/, run from there. Assert every
              anchor and write nothing unless all pass. Never assert on
              a string the patch itself introduces.
              ⚠ Verify AFTERWARDS by checking the OLD text is GONE. A
              check for the new text always passes and proves nothing.

BLAST RADIUS  Before changing how a number is CALCULATED, grep where
              that number is CONSUMED. S93: `batches` looked like a
              display figure and turned out to drive MATERIAL RELEASE
              quantities two files away.

DEPLOY        pm2 restart <NAME>, never "all" — dev=abletrace-dev,
              prod=abletrace-backend. sleep 8 before curl.
              git add <named files>, never ".".
              No "!" in commit messages — bash eats them.
              Frontend: promote.sh from the Mac, then Cmd+Q the browser
              (a hard reload does not clear lazy chunks).
              ⚠ A push auto-builds DEV. PROD needs a manual dispatch
              with target=prod.

THE LOG       The commit message IS the record. What changed and WHY,
              written at the moment of committing. Nothing is written
              up afterwards. Git dates it and keeps it forever.

REVERTS       A revert is a trade, not a fix. Ask what the commit was
              fixing before undoing it, and name both sides out loud.
              "It worked before" is not evidence the mechanism was
              sound — a mask can hide a bug for years.

QUEUE         New items go at the BOTTOM with the next free number.
              Claude never renumbers. Ranking is Minty's, in one pass.

ASK FIRST     Before reading a script, a config or a box to learn how
              something works, ask Minty for the document that covers
              it, BY NAME. S87: Claude read promote.sh instead of
              asking for 3B.4 and had been stating the CI direction
              backwards as a result. The doc is the first stop; the
              artifact is the tiebreaker if they disagree.

PATTERNS      Before trusting what a grep or a LIKE RETURNED, ask what
              it is STRUCTURALLY CAPABLE of matching. A pattern that
              cannot express the question will still answer it, and the
              rows it returns will read as evidence. Two of Claude's
              own patterns failed this way in S93.

DOCS          ⚠ FOUR WORKING FILES, FIXED NAMES. Git holds the
              history. Nothing accumulates, nothing is suffixed.

                RULES.md   how we work. Edited rarely.
                           Last revised: S--
                NOW.md     state + queue. REWRITTEN WHOLE each session.
                           Last rewritten: S--
                TRAPS.md   what bit us. APPENDED ONLY, never cut.
                           Last appended: S--
                PLAN.md    the next session's list. Rewritten whole,
                           disposable. Written at close of: S-- for S--

              ⚠ EVERY ONE CARRIES ITS STAMP ON THE FIRST LINES, NOT THE
              LAST. The tell must cost one glance, and TRAPS is long.
              At session open, read all four stamps against the session
              being opened. If they lag, THE BOXES ARE THE ARBITER and
              the record is reconciled before any work.

              ⚠ NO SUFFIXED COPIES. S92 made TRAPS-additions-S92.md and
              S93 had to merge it back. A suffix on a cumulative file
              splits the one thing that made it valuable. And suffixed
              copies of NOW would have sat in Downloads exactly as the
              unsuffixed ones did — the fix was COMMITTING, not naming.

              ⚠ THE PASTE LIST IS IN PLAN.md AND IT IS AUTHORITATIVE.
              Paste what it names and nothing else. Claude asks by name
              for anything further, and says why in the same breath.

              ⚠ ANYTHING WORTH KEEPING MUST NOT LIVE IN NOW.md OR
              PLAN.md. Both are rewritten whole, so a note left there is
              deleted next session. Traps go to TRAPS, rules go here.

              ⚠ THE RAW GITHUB URL CACHES. Read the web view, or paste.
              A stale fetch is not evidence a commit failed.

              ⚠ SECTION 5 IS NOT DELETABLE. It holds the JR rebuild
              block — the only record of every stored proc, view,
              column add and seed — and the reconcile oracle.

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
              ⚠ Same shape as the queue rule: logging is mechanical,
                RANKING IS MINTY'S. So is scope.

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
```
