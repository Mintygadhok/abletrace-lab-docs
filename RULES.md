# RULES

Read first. Changes rarely. Everything here was earned by a real failure.

```
WHO           Minty: domain expert, sole operator, runs every command.
              Does not read code. Decides on BUSINESS grounds only —
              never asked to judge a technical trade.
              Claude: sole coder and only reviewer. If Claude misses
              it, nobody catches it.

OPEN          Every session starts with this, on BOTH boxes, before any
              work. Paste it and give Claude the output:

                git -C ~/abletrace-lab-frontend rev-parse --short HEAD
                git -C ~/abletrace-lab-backend  rev-parse --short HEAD
                git status --short
                pm2 status
                curl -s -o /dev/null -w "%{http_code}\n" localhost:1337

              Expect clean trees, the NAMED process online, and 200.
              ⚠ COMPARE THE REAL HEADS AGAINST WHAT NOW.md CLAIMS. If
              they differ, STOP and reconcile the record before doing
              any work. S70 opened by chasing a delta that did not
              exist — and that same unrecorded commit turned out to be
              the cause of the client's bug four hours later.
              ⚠ After any backend restart, sleep 8 before the curl.
              000 means Sails is still booting, not that it crashed.
              ⚠ Prod's frontend git checkout LAGS the served build.
              Judge prod's frontend by the bundle, not the checkout.
              ⚠ Note the rollback points before touching anything.
              (Fuller version, plus the host check, lives in 3B.5.)

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

DEV ONLY      Edit on dev. Never hand-edit prod. Never promote
              unverified code. If it is late and unproven, stop.

LIVE CLIENT   Prod carries Glutenull. Only 464 and 465 are sandbox.
              Always act by company_id. A client-reported bug outranks
              the whole queue.

PATCHES       Long scripts fail when pasted into a terminal. Hand over
              as a FILE, scp -4 to /tmp/, run from there. Assert every
              anchor and write nothing unless all pass. Never assert on
              a string the patch itself introduces.

DEPLOY        pm2 restart <NAME>, never "all" — dev=abletrace-dev,
              prod=abletrace-backend. sleep 8 before curl.
              git add <named files>, never ".".
              No "!" in commit messages — bash eats them.
              Frontend: promote.sh from the Mac, then Cmd+Q the browser
              (a hard reload does not clear lazy chunks).

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

DOCS          NOW.md is the only file rewritten each session. TRAPS.md
              grows only when something bites twice. Everything else is
              frozen and is allowed to be imperfect — it is not tidied.
              ⚠ ANYTHING WORTH KEEPING MUST NOT LIVE IN NOW.md. NOW is
              rewritten whole, so a note left there is deleted next
              session. Traps go to TRAPS, rules go here.
              ⚠ SECTION 5 IS NOT DELETABLE. It holds the JR rebuild
              block — the only record of every stored proc, view,
              column add and seed — and the reconcile oracle. → P67
```
