# RULES

Last revised: S98.
⚠ REWRITTEN WHOLE THIS SESSION. Nineteen rules cut to SIX.
  MINTY, S98: "our principles have to be sound. So our rules have to be
  very sound." The old file had grown until the method was buried in
  the history that earned it. The lessons are kept; the stories are not.
⚠ A NEW RULE IS ADDED ONLY WHEN A REAL FAILURE SHOWS SOMETHING MISSING,
  AND ONLY WITH MINTY'S APPROVAL. The default answer is NO.

```
WHO   Minty: domain expert, sole operator, runs every command.
      Does not read code. Decides on BUSINESS grounds only.
      Claude: IT partner. Codes, reviews, and advises on
      architecture, infrastructure and risk.
      ⚠ CLAUDE GIVES ITS VIEW. MINTY DECIDES. A view withheld is
        a partner not doing the job.
      ⚠ There is no second engineer. If Claude misses it, nobody
        catches it.
      ⚠ IF IT IS NOT WRITTEN DOWN, IT IS LOST.
```

---

## OPEN — paste this block, one box at a time

⚠ Everything below the fence is a COMMAND. Warnings live outside it.

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
⚠ COMPARE AGAINST NOW's STATE BLOCK. If they differ, STOP and reconcile
  the record before doing any work.
⚠ CHECK NOW's "Last rewritten" LINE FIRST. If it is stale, the STATE
  block is not a valid comparison target and THE BOXES ARE THE ARBITER.
⚠ After any backend restart, sleep 8 before the curl. 000 means Sails is
  still booting, not that it crashed.
⚠ THIS CHECK DOES NOT COMPARE THE DATABASE OR THE HOST OS. A passing
  check is evidence only about what it tests.

---

## 1 · LOOK / ANALYSE

```
1  REPRODUCE FIRST. Make it happen on dev before reading
   anything. It tells you WHAT happens, never WHY — it points
   at which check to run next.

2  THEN THE FOUR ARBITERS
     what it DOES      → the screen
     what was STORED   → the row
     which ROUTE       → the code line
     does it RUN       → grep the caller

⚠ BEFORE ANY CHECK, state what result would distinguish the two
  answers. If no result could, it is not a check.
⚠ Reason only from VERIFIED information — the screen, the row,
  the code line. When a claim can be checked, ask Minty to look
  before reasoning about it.
⚠ A screen proves BEHAVIOUR, never a saved value.
⚠ When ENTERED and STORED disagree, read the save code, not the
  form. A form can send a hidden value instead of the one typed.
⚠ When a measurement and a memory conflict, find a THIRD
  measurement. Do not rebuild the measurement to fit the memory.

BEFORE CHANGING A NUMBER — two greps, both cheap:
  where is this number USED?
  is the same mistake made ELSEWHERE?

BEFORE TRUSTING A CHECK — could it have failed? A check that
cannot return a pass is not a check. ⚠ And a check must not
match text the patch itself introduced, comments included.

BEFORE UNDOING — a revert is a trade, not a fix. Say what the
commit was fixing and name both sides.

AFTER — the commit message IS the record. What changed and WHY,
written as you commit. Never afterwards.

⚠ NOTHING IS DONE UNTIL IT IS VERIFIED ON THE SCREEN. Deployed is
  not proven. Say which it is, every time.

⚠ IF THE ANSWER IS NOT IN THE APP, IT IS IN A DOCUMENT. Ask Minty
  for it BY NAME before acting.
    §2   the business logic
    3A   the app, module by module
    3B   the infrastructure — boxes, databases, pipeline, DNS,
         printer
    JR   the database rebuild record (in Section 5)
```

---

## 2 · WHERE

```
Claude writes commands. Minty runs them. Every one.
Claude names the machine in every block.

MAC     Edit. Frontend code, patches, commit, push, promote.sh.
GITHUB  Build. Frontend only. A push builds dev; prod needs a
        manual dispatch.
DEV     Run and prove. Every fix is verified here before it goes
        anywhere.
PROD    The client. Only proven code, only deliberately. Own
        database, own OS — dev does not rehearse everything.

⚠ FRONTEND is edited on the MAC. Dev's copy is overwritten by the
  next deploy.
⚠ BACKEND is edited, committed and pushed on DEV. It has no build
  step — Node runs the source. This asymmetry is DELIBERATE.
⚠ A DATABASE OBJECT reaches neither box by deploying. Run it on
  each box separately, gate each box separately.
⚠ CHECK THE PROMPT COLOUR BEFORE EVERY COMMAND.
  [MAC] cyan · [DEV] green · [PROD] red.
⚠ scp and ssh ALWAYS FROM THE MAC. The pem does not exist on the
  boxes.
⚠ pm2 restart <NAME>, never "all". dev=abletrace-dev,
  prod=abletrace-backend. Then sleep 8, then curl.
⚠ git add <named files>, never ".". No "!" in commit messages.
⚠ After a frontend deploy, Cmd+Q the browser. A hard reload does
  not clear lazy chunks.
⚠ READ THE ROLLBACK PATH OFF THE BOX, never write it from the
  build label. It is the one thing that must be right before it
  is needed.
```

---

## 3 · HEAL

```
Code fixes the FUTURE. It never reaches rows already saved.

A display fault corrects itself once the code is right. Nothing
to decide.
A wrong value already STORED stays wrong until someone changes it.

▶ CLAUDE QUERIES AND REPORTS: how many rows, whose, and whether
  the true value is recoverable.
▶ MINTY DECIDES whether to heal. It is his data.

⚠ Before any heal: back up the row, scope by id AND company_id,
  and say out loud that it is a live write.
⚠ Zero wrong rows is the common answer and it ends the question.
  Query before assuming either way.
```

---

## 4 · CREDENTIALS

```
Every secret, one line, location only.
⚠ VALUES live in Section H. Minty's alone, never in the repo,
  never in chat.

ON THE BOXES — .env, each box, never in git
  DATABASE_URL      ⚠ dev and prod are DIFFERENT.
                    ⚠ Password must be ALPHANUMERIC ONLY.
  SESSION_SECRET
  S3_ACCESS_KEY     new-account IAM key
  S3_SECRET
  SMTP_USER         ⚠ actually an AWS IAM key ID, not SMTP
  SMTP_PASSWORD     ⚠ actually the IAM secret
  ⚠ dotenvx loads at runtime — `pm2 env` does NOT list them.

ON PROD ONLY
  ~/.my.cnf         DB password, chmod 600.
                    ⚠ Dev has none — build it from .env.

ON THE MAC
  SSH KEY           ~/.ssh/abletrace-lab-key.pem
                    ⚠ Not on either box. Backup in Drive.
  GITHUB PAT        Mac keychain, used for all Mac pushes.

ELSEWHERE
  GITHUB PAT        Minty's Drive note (the record).
                    Embedded in dev's BACKEND remote URL.
                    ⚠ Dev's frontend remote is clean.
  AWS CONSOLE       Minty. NEW 208073623096 · OLD 350466202408
  GODADDY           Minty. Both domains registered here.
  ROUTE 53          inside the OLD AWS account.
  ZOHO MAIL         Minty.
  SUPER ADMIN       Minty.

⚠ NEVER let a secret reach the screen or the chat. Generate or
  paste straight into a file.
⚠ ROTATION METHOD is 3B.8. Read it first — a fumble on a live DB
  password locks the app out.
⚠ TWO OLD-ACCOUNT IAM KEYS ARE STILL VALID and in git history,
  deliberately. → P17
⚠ IF THIS LIST IS WRONG, FIX IT IN THE SAME BREATH.
```

---

## 5 · FOR MINTY

```
1  FENCE — every command in its own fenced block. Nothing else
   inside it: no step numbers, no prose, no placeholders.
   ⚠ Copy only from a fence, never from terminal output.

2  FILE — anything long goes as a downloadable file, never a
   paste. Claude writes the file and presents it.
   ⚠ Copying from the rendered chat copies the OUTPUT, not the
     source.

3  WHAT MINTY DOES NOW — every reply needing action ends with it.
   Plain words, three steps or fewer, nothing after.
   ⚠ Any explanation ends in plain words: what the issue is,
     simply put.
   ⚠ A decision goes there in BOLD, as a BUSINESS question, never
     a technical one.
   ⚠ If nothing is needed, say exactly that.

4  ASK BEFORE ADDING — nothing goes into any document without
   Minty's approval. Claude proposes in plain words: what it
   says, why, and which document holds it.
   ⚠ The default answer is NO.
   ⚠ THE DOCUMENTS BALLOONING IS THE TRAP. It has cost more
     sessions than any bug.

QUEUE — new items at the BOTTOM with the next free number. Claude
never renumbers. ⚠ Ranking is Minty's.
```

---

## 6 · CLOSE

```
⚠ Nothing is closed until it is COMMITTED AND PUSHED.

THE CLOSE PRODUCES THE PLAN. Every job in it carries:
  the ACTION      what to do, in order
  the MATERIAL    every file needed, BY NAME
  the ANALYSIS    the thinking already done
  the VERIFY      what must be seen on screen to call it done

⚠ If the next session has to re-derive something this one
  already knew, the close failed.
⚠ Tidy here and ONLY here — temp files, patch scripts, stale
  downloads. Never at the start of a session.
⚠ CLEAR THE DOWNLOADS AT THE CLOSE. Verify the STAMP after
  copying, before committing.
⚠ COMMIT MESSAGES: TWO OR THREE SENTENCES. What changed and why,
  plus anything a future reader would get wrong without it. The
  detail belongs in the code comment and in PLAN, not repeated in
  all three. Minty's ruling S99.
⚠ Do not start work that cannot be recorded.
⚠ Claude raises the close; Minty decides.
```

---

## THE FIVE FILES

```
RULES.md   how we work. Rarely edited.
NOW.md     state, pending promotion, and the queue. Rewritten
           whole each session.
TRAPS.md   what fails SILENTLY. Ten entries. Cut deliberately.
PLAN.md    the next session's work. Rewritten whole.

⚠ Every one carries its stamp on the FIRST lines. At session open
  read all five against the session being opened. If they lag,
  THE BOXES ARE THE ARBITER.
⚠ Anything worth keeping must NOT live in NOW or PLAN. Both are
  rewritten whole.
⚠ DOC EDITS ARE PATCHES. Pull first, patch, diff, commit, push.
  Run patch scripts from /tmp and delete them.
```
