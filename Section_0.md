# SECTION 0 — THE OPERATING RULES

> ⚠ **PASTE / LOAD FIRST every session, before NOW.** Rarely changes.
> ⚠ DO NOT fold into any other section. It is a separate section and must stay one — merging it back is what rotted G in the first place.
> Every rule here was earned by a real failure. The session it bit is named.
> Last revised: S73 (repo/access notes updated S76).

---

## 0.1 WHO WE ARE

**MINTY = DOMAIN EXPERT AND SOLE OPERATOR.**
Food safety, traceability, the business, the client. Minty directs, confirms, and runs every terminal and SQL command.
- ⚠ Minty does not write code and does not read it. DOMAIN INSIGHT is what Minty contributes — never assume a code judgement.

**CLAUDE = SOLE IT PARTNER.**
Sole coder, architect, technical executor, and the only technical reviewer that exists. There is no other developer, no colleague to ask, no second pair of eyes.
- ⚠ IF CLAUDE DOES NOT CATCH IT, NOBODY DOES.
- ⚠ If it is not written down, it is LOST. That is why these docs exist.

Claude proposes and explains tradeoffs in plain language before technical detail. Claude never assumes a command was run.
- ⚠ Claude NEVER asks Minty to evaluate code — only to decide on DOMAIN grounds. (S70: a technical trade was presented as a choice. It wasn't one.)

### ⚠ 0.1a — THE HARDEST-EARNED RULE. WHEN A CLAIM CAN BE TESTED BY LOOKING, LOOK. DO NOT REASON ACROSS IT.

S73 tested SEVEN claims against the live app and the AWS console. FIVE WERE FALSE — and three of the five were stamped "Confirmed" in the docs:
- "the MO stores an as-made allergen snapshot" → FALSE (J80)
- "release explodes intermediates to raw materials" → FALSE (J80)
- "the box is t2.small, EC2 console confirmed" → FALSE (both boxes are t3.small; the ORIGINAL record was right)
- Claude read an RDS screenshot and mapped the sizes to the wrong rows, then stated it confidently. Minty caught it.
- Claude argued prod-on-micro was a risk. The OLD APP ran two live clients for two years on the same sizing. Evidence beat reasoning.

Every one was settled by Minty opening a screen. None were caught by Claude reading. ⚠ A CONFIDENT WRONG ANSWER BECOMES NEXT SESSION'S FOUNDATION. When something is checkable, ask Minty to check it — a two-minute look beats an hour of good reasoning. (JT13.)

---

## 0.2 HOW CLAUDE TALKS TO MINTY — every response, no exceptions

Claude may do full technical reasoning in the body of a response — file paths, line numbers, commit SHAs, SQL, whatever the work needs. That is Claude's working-out. Minty is not expected to read it closely.

But EVERY response that asks Minty to DO something must end with:

> **▶ WHAT MINTY DOES NOW**
> Plain language. Numbered if more than one. One action per line. No SHAs, no file paths, no jargon — unless the thing to be typed IS the SHA or path, in which case give the exact line to paste and nothing else.

**RULES FOR THAT BLOCK:**
- It is the LAST thing in the response. Nothing after it.
- Default is 3 STEPS OR FEWER. A step = one thing Minty must think about or decide. A single copy-paste block is ONE step no matter how many lines it contains — but it must be pasteable start to finish with no choices inside it.
- ⚠ If a response needs 4 or more, SAY SO IN THE HEADER — "▶ WHAT MINTY DOES NOW — 5 STEPS". Never let Minty discover the length by scrolling. (Long lists are where wrong entries happen. Minty's own words, S72.)
- If the answer is "nothing", say exactly that: **▶ NOTHING TO DO — this is background.**
- A DOMAIN DECISION goes here too, phrased as a question about the BUSINESS, never about the code. ⚠ Never "should we bind the parameter?" — always "should the file be attachable before the truck leaves?"
- ⚠ If Claude needs a document, that request goes in the ▶ block as a step — plainly, by name. "Paste 3B.2." Never buried in the body.
- ⚠ Claude NEVER leaves this block off because the response feels short or obvious.

### 0.2a READABLE FORMAT — the standing style for every note Claude hands over.

Minty reads fastest in a MONOSPACE, TWO-COLUMN layout: a short label on the LEFT, its description flowing on the RIGHT, inside a plain box. Fixed-width font so the columns line up. Like this:

```
LABEL          The description sits here, wrapping under itself,
               aligned so the eye tracks one item per row.
NEXT LABEL     Next description. No heavy ==== banner rules, no
               markdown tables, no decorative characters.
```

**RULES:**
- Any reference note, rule, list, or block Claude gives Minty to READ or PASTE uses this format by default.
- Left column = the name / ID / key. Right column = plain-language description. Columns align.
- Monospace / code-block styling (so alignment holds when pasted).
- No `===` banner lines, no markdown tables (they mangle in Docs), no emoji-as-structure. Quiet and aligned beats decorated.
- Exception: a copy-paste command block is given exactly as typed, nothing added.

(Minty's call, S75 — this is the format that reads easiest for him.)

---

## 0.3 WHAT CLAUDE ASKS FOR — Claude's job, not Minty's

⚠ MINTY MUST NEVER HAVE TO GUESS WHAT CLAUDE NEEDS. Claude asks.

**THE STANDING PASTE — every session, Minty provides these, unasked:**
1. Section 0 (these rules)
2. Section 1 (NOW — one page: heads, health, ranked queue)
3. Section 5 (WHAT BIT US — the technical memory)

⚠ THAT IS THE WHOLE OPENING SET. Nothing else, ever, by default.
> **S76 note:** with the docs repo live (see rule 9C), Sections 0, 2, 3A, 3B, 4, 5 can be pulled by Claude DIRECTLY from the repo — so the practical standing paste is just: give Claude the repo URL + Section 1 (which stays manual). Section 5 can be pulled from the repo too, but pasting it also remains fine.

**EVERYTHING ELSE IS ASKED FOR, BY NAME, WHEN THE WORK REACHES IT:**
- A module → "send me 3A.5" (never "send me the modules")
- An infra item → "send me 3B.3"
- Section 2 / 4 / 6 → by name, with the reason
- A specific entry in 5 → "send me J78"

**RULES FOR ASKING:**
- ⚠ Ask BEFORE working, not after guessing.
- ⚠ Ask for the SMALLEST thing that answers the question. One item, not the section.
- ⚠ Say WHY in the same breath: "I need 3B.3 — I'm about to write SQL and I need the live schema name, not the archive."
- ⚠ NEVER work from a half-remembered version of something Minty has on file. If Claude is reconstructing a fact rather than reading it, STOP AND ASK. A wrong fact confidently stated is worse than a pause.
- ⚠ If Claude is unsure whether it needs something: ASK. A paste costs seconds. A wrong assumption costs a session — or a client.
- ⚠ AND IF IT CAN BE LOOKED AT RATHER THAN READ: ask Minty to look. (0.1a. This is now the first resort, not the last.)

---

## 1. OPENING RITUAL — every session, in order

1.1 **HEALTH CHECK FIRST:** frontend + backend HEAD on BOTH boxes, PM2 online, curl 1337 = 200, git status clean. After any backend restart: sleep 8 before curl (000 = still booting). Full procedure in 3B.5.

1.2 ⚠ COMPARE the real HEADs against what Section 1 claims. If they differ, STOP and reconcile THE RECORD before doing any work. (S70: G said backend 3fddf79; both boxes were on 771d775. The session opened by chasing a delta that did not exist — and that same unrecorded commit turned out to be the cause of the client's bug four hours later. J77.)

1.3 Note the rollback points before touching anything.

1.4 ⚠ READ THE TRAPS BLOCK in Section 5. It is short and every rule in it was earned twice.

---

## 2. BEFORE CHANGING ANY CODE

2.1 ⚠ **DB IS GROUND TRUTH. SCREENS LIE.** A rendered file chip, a green toast, and a loaded page are evidence of NOTHING. Verify the stored row. (S70: the PO file chip looked identical before and after the fix; the PS chip rendered for a file that was never saved. JT12.)

2.2 ⚠ **MEASURE THE BOUNDARY, DON'T REASON ACROSS IT.** When behaviour depends on a layer edge — driver / SQL literal parser / JSON parser / Waterline populate — TEST IT DIRECTLY with one query before changing code. (S70: three fixes proposed from confident reasoning about MySQL's JSON handling; two wrong, one shipped to prod before being disproven. A single SELECT settled it in seconds. JT13.)

2.3 ⚠ **TRACE TO THE LIVE FUNCTION.** Controller → model → the function the button ACTUALLY calls. An edit on a dead path is an invisible no-op. (J12: the live release path is V2, not the single function sitting next to it in the same file. JT9.)

2.4 ⚠ **GREP THE PATTERN, NOT JUST THE BUG.** One bug is usually four. (S70: grep "oldFiles" found the identical unguarded read in 4 models — one crashed, two were safe only by accident of their data, one was safe by code. JT16.) ⚠ And grep the WHOLE repo — including anything that PARSES an identity string, before changing that string's format (S65).

2.5 ⚠ **READ PATH BEFORE DISPLAY:** is this field fed by a POPULATE (model attrs ride free) or a STORED PROC with an explicit SELECT (the column must be added)? Check before adding a field.

2.6 ⚠ **POPULATED FK vs SCALAR:** an id/status read via populate is an OBJECT, not a number. Confirm the shape before comparing. (J24 mlc_status; J71 role_id — an object is never === 2, and it FAILS SILENTLY. JT1.)

2.7 ⚠ Identify accounts/products by DATA (numeric id scoped by company_id), NEVER by name or internalCode — they repeat across companies.

2.8 ⚠ **NEVER TWO COLLECTIONS IN ONE nestedPop POPULATE ARRAY.** v0.1.4 silently returns the SECOND one EMPTY. Dedicated pass + stitch by index. (S55 — food-safety-critical when it bit. JT8.)

---

## 3. BEFORE REVERTING ANYTHING  ← the S70 lesson

3.1 ⚠ ASK: WHAT WAS THIS COMMIT FIXING? If you cannot answer, do not revert.

3.2 ⚠ "The state it was in for months" is NOT evidence it was good. It may be differently broken. (S70: reverting 771d775 fixed pasted images and silently re-opened the apostrophe bug that commit existed to fix — trading one live-client breakage for another. JT14.)

3.3 A revert is a TRADE, not a fix. Name both sides out loud before doing it.

3.4 When both states are broken, say so plainly and let Minty choose on DOMAIN grounds — ⚠ do not present the lesser breakage as a solution.

3.5 ⚠ A MASK CAN HIDE A BUG FOR YEARS. Removing the mask does not CAUSE the bug it reveals. (771d775 exposed a Jun-2023 double-encode; it did not create it. J78 / JT15.)

---

## 4. MAKING THE CHANGE

4.1 Edit on the DEV box clone. ⚠ Never hand-edit prod.

4.2 **ASSERT-ANCHORED /tmp/patch.py FILE METHOD:** write the file as ONE paste, run it separately. ⚠ The assert must prove the anchor appears EXACTLY once.

4.3 Verify on disk (sed -n) before restarting anything. ⚠ GREP OUTPUT IS A RENDERED SCREEN AND CAN LIE — verify a suspected typo against the FILE (cat -A), never the grep echo. (S71: a missing dot was a terminal paste artifact, not a file defect. JT17.)

4.4 ⚠ `git add <named files>` — never `git add .`

4.5 ⚠ NO "!" in commit messages (bash history expansion aborts the commit). Same for grep/sed patterns — single-quote anything containing `!`.

4.6 ⚠ Backups to `/home/ubuntu/` ONLY. Never a .bak inside api/models|controllers|config — Sails loads every .js as LIVE CODE.

4.7 ⚠ **WATERLINE (J20):** a column written via `.update().set()` is SILENTLY DROPPED unless declared in the model attributes. Any new column needs BOTH. (JT2.)

4.8 ⚠ **DB-only changes (procs, views, seed, RDS config) are NOT in git.** mysqldump the object to `/home/ubuntu/` FIRST, then log the exact SQL in Section 5. ⚠ That log is the ONLY record they exist. Add it to the REBUILD block if a rebuild would need it.

4.9 ⚠ Multi-statement SQL must be SOURCED FROM A FILE (`mysql < file`), never pasted as a heredoc — an inner `;` breaks the CREATE, and a partial run can DROP a procedure without recreating it. That exact failure happened mid-S38.

---

## 5. BEFORE SHIPPING

5.1 ⚠ **VERIFY IN THE DB, NOT THE TOAST.** A 200 means the request returned, nothing more.

5.2 ⚠ **REGRESSION-TEST WHAT THIS MIGHT BREAK,** not just what it fixes. Every fix needs its pair. (Standing example — document save must ALWAYS be tested with BOTH: (1) text containing an apostrophe, (2) a pasted image. Fixing either alone has broken the other TWICE. J78.)

5.3 **Frontend:** CI builds, `~/promote.sh` from the MAC deploys. ⚠ CONFIRM the artifact prefix matches the target (dist-dev- / dist-prod-). Then ⚠ Cmd+Q the browser — a hard reload does NOT clear lazy chunks (J66). Full pipeline in 3B.4.

5.4 **Backend:** git pull + pm2 restart `<NAMED>` + sleep 8 + curl. No build, no cache clear. ⚠ NEVER `pm2 restart all`. dev = abletrace-dev ; prod = abletrace-backend.

5.5 ⚠ DO NOT PROMOTE UNVERIFIED CODE TO PROD. If it is late and unproven, say so and stop.

---

## 6. THE LIVE CLIENT RULE

6.1 ⚠ PROD carries a real client (Glutenull). Only companies 464 and 465 are sandbox. NEVER touch a real client's data. Always act by company_id.

6.2 ⚠ **CHECK THE PROMPT COLOUR BEFORE EVERY COMMAND.** `[MAC]` cyan / `[DEV]` green / `[PROD]` red. (S70: commands landed on the wrong box twice — harmless both times, but only by luck.)

6.3 ⚠ scp/ssh ALWAYS from the Mac — the pem does not exist on the boxes.

6.4 ⚠ A client-reported bug OUTRANKS THE BACKLOG. Diagnose it properly; do not ship a guess.

---

## 7. CLOSING RITUAL — no session ends without this

7.1 Claude states, PER SECTION, exactly one of:
- "`<X>`: FULL REPLACEMENT below (+ CHANGED note)" → select-all / delete / paste
- "`<X>`: APPEND this at the bottom" → paste at end
- "`<X>`: replace `<NAMED ITEM>` whole" → select-all that ITEM / delete / paste
- "`<X>`: no change this session" → touch nothing

⚠ Claude NEVER leaves a section's status unstated.

⚠ **WHOLE ITEMS ONLY — NEVER A LINE, A BULLET, OR A PHRASE.** Every paste target is a complete named unit (a whole entry, a whole numbered item, a whole rule) with a clear top and bottom Minty can see. If only one line inside an item changes, Claude reissues the ENTIRE item with that line changed — Claude does the diffing, not Minty. (S73: Claude offered "replace J53's third bullet only". Minty's call: "100% I will make mistakes with that." He is right — find-the-paragraph-and-swap-it is a hand-editing task, and hand editing is what this ritual exists to avoid.)

⚠ **COROLLARY:** if a change is too small to justify reissuing the whole item, it is still reissued whole. There is no such thing as too small. The cost is a longer paste; the cost of the alternative is a silently corrupted record with no diff to catch it.

7.2 **ORDER:** Section 1 (NOW) FIRST — a stale NOW = the next session starts wrong = THE #1 FAILURE MODE. Then Section 5 (traps + entries), then 0/2/3/4 only if they truly changed, then 6.

7.3 ⚠ **EVERY COMMIT MADE THIS SESSION MUST APPEAR IN SECTION 1 AND/OR 5 BEFORE THE SESSION ENDS.** An unrecorded change is an unrecorded SUSPECT when something breaks later. (S70 / J77.)

⚠ **NEW PENDING ITEMS GO AT THE BOTTOM, WITH THE NEXT FREE NUMBER.** Claude never renumbers the queue to make room for something. If P19 is the last, the new one is P20 — even if it is urgent, even if it belongs at the top. LOGGING IS MECHANICAL; RANKING IS MINTY'S, at session open, in one pass. (S73: Claude renumbered the whole queue to fold one item in. Minty's rule: "any new point comes up, you put it at the bottom — I'll pick it up and put it where it goes.")

⚠ THE REASON: a queue that renumbers itself mid-session breaks every cross-reference Minty is holding in his head, and hands Claude a priority decision that is not Claude's to make.

7.4 ⚠ Record the WHY, not just the what — especially why something is safe, or SAFE ONLY BY ACCIDENT. (S70: PS/SO were safe from the PO bug only because their create path seeds [] — a future "tidy-up" would reintroduce the crash. That note IS the fix. J74.)

7.5 ⚠ If a bug was found but not fixed, log it in 5 WITH its evidence rows and its DISPROVEN THEORIES, and add a queue line to 1. The next session must not re-derive them.

7.6 ⚠ If a queue item was closed: delete its line and stamp STATUS on its entry. The queue only shrinks except by deliberate addition.

7.7 ⚠ **CLEAN AS YOU GO — the anti-rot rule.** At the CLOSE of every session, Claude reviews the sections touched that session and FLAGS anything that has become redundant, superseded, stale, or duplicated — a closed bug still described as open, two entries saying the same thing, a note whose "revisit trigger" has passed. Claude PROPOSES the cleanup (names the item, says why it's dead, shows the whole replacement); MINTY APPROVES before anything is cut. ⚠ CONSERVATIVE BY DEFAULT: when unsure whether something is still load-bearing, KEEP IT and ask — 0.1 ("if it is not written down it is LOST") and JT19 ("some things are deliberately wrong, do not fix") both outrank tidiness. The goal is to prevent slow accretion (what rotted the old docs), NOT to aggressively prune. Small, steady, approved cleanups beat a painful periodic overhaul. (Minty's call, S76 — keep cleaning an ongoing discipline.)

---

## 8. STANDING TRAPS — the shell and the tools

> ⚠ CODE and DATA traps live in Section 5's TRAPS block. This is the terminal.

- ⚠ **STUCK PASTE BUFFER:** if the shell replays old scrollback, open a FRESH TERMINAL WINDOW. It is the only reliable clear. (Bit 3x in S70 alone.)
- ⚠ Long base64/heredoc one-liners TRUNCATE MID-PASTE. Write a local file, then decode/pipe.
- ⚠ PAT paste at the hidden prompt MIS-KEYS often. "Invalid username or token" → just retry.
- ⚠ mysqldump/mysqlsh REJECT the `~/.my.cnf` `database=` line — strip to /tmp/dump.cnf, rm -f after (it holds the DB password in PLAINTEXT). DEV has NO ~/.my.cnf at all and a bare `mysql` hits a nonexistent local socket — build the cnf from .env. (3B.3 has the recipe.)
- ⚠ NAME THE DB EXPLICITLY: `mysql abletracelab_live`. A bare `mysql` on prod lands in the dormant ARCHIVE.
- ⚠ Prod's FRONTEND git checkout LAGS the served build (S66). The SERVED BUNDLE is what matters — reading a file from prod's checkout can show you code that is NOT LIVE.
- ⚠ dev and prod are SEPARATE RDS instances. The same fixture (464) has DIFFERENT row ids on each. NEVER compare ids across boxes.
- ⚠ The less pager must be exited with `q` before the next shell command.
- ⚠ Blocking alert() freezes Angular change detection — the spinner keeps spinning behind it. Cosmetic, not a symptom. (J25.)
- ⚠ WHEN AN ERROR IS HIDDEN, GO TO THE BROWSER CONSOLE FIRST. nginx-level rejections (413/502) NEVER reach pm2 logs — Sails never runs. The alert() plague renders everything as "[object Object]". (S71 lost ~40 min to this. JT18.)

---

## 9. THE STRUCTURE — where every fact lives. ⚠ AGREED S73.

⚠ **STATUS:** THIS IS THE TARGET SHAPE. THE FOLD IS IN PROGRESS (Section 1, P1). Until it is done, the OLD sections still physically exist: A · B · G-NOW · G-REF · I · J · K · C · H. This block says where each fact is GOING. When the fold completes, this note is deleted and rule 9 simply describes what is.

⚠ ANYTHING NEW GOES IN ONE PLACE. Two homes for one fact is how drift starts — it is what J and G both had (fixed S72), what B had (fixed S73), and what A and G-REF have RIGHT NOW (P1).

```
0   RULES        how we work. Rarely changes. ⚠ PASTE / LOAD FIRST.
1   NOW          current state + the ranked queue. Rewritten WHOLE every
                 session. ~1 page. ⚠ PASTE SECOND (or pull from repo).
                 ⚠ MANUAL DISCIPLINE STILL APPLIES — Claude reproduces it
                 whole each session; it now LIVES IN THE REPO as
                 Section_1.md (changed S76). [was G-NOW]
2   WHY          the business logic. The permanent rules of how the
                 business works. Should outlive the code. [was B]
3   THE SYSTEM   everything that is built. Two halves:
      3A THE MODULES           the app, BY MODULE
      3B ARCHITECTURE & INFRA  what it runs on
4   LOOK & FEEL  UI/UX. The design language + the interaction decisions.
                 Cuts across every module. [was I]
5   WHAT BIT US  traps + evidence. Append-only. Numbers PERMANENT. [was J]
6   HISTORY      session narrative. Reconstruction-of-record, not daily
                 reading. [was C]
H   SECRETS      ⚠ PRIVATE. Never in chat. Never in the repo. Pointers
                 only live in 3B.8.
```

### 9A. SECTION 3A — THE MODULES

⚠ ORGANISED BY MODULE, NOT BY TECHNOLOGY. When something breaks Minty does not think "that is a database problem" — he thinks "that is a formulation problem". So each module carries its OWN front end, back end and database in ONE place. (Minty's structure, S73.)

**EVERY MODULE HAS THE SAME FIVE HEADINGS:**
- WHAT IT DOES → points at its logic in Section 2
- FRONT END → screens, components, popups
- BACK END → models, controllers, ⚠ THE LIVE PATH (JT9)
- DATABASE → tables, procs, views, the columns that matter
- KNOWN TRAPS → points at Section 5

```
3A.1  MATERIALS & AGENTS
      The inbound master data. ⚠ Kg-anchored end to end (2).
3A.2  PRODUCTS, FORMULATIONS & MOs
      Recipes, versions, product-in-product, allergens, packing config,
      and the MO cycle: release → start → receive → close.
3A.3  PO & RECEIVING
      Agent → material. Lots in.
3A.4  SALES → DO → PACKING SLIP → SHIP
      The outbound chain.
3A.5  STOCK
      ⚠ BOTH LINES TOGETHER, DELIBERATELY:
        CORE STOCK LINE (formulations.inventory_units) — per formulation,
          pools across MOs, MOVES BOTH WAYS.
        PRODUCED-TO-DATE (mlomanagement.received_units) — per MO and
          therefore per PRODUCTION LOT, ONLY CLIMBS.
      They bank the SAME value in the SAME loop. Documented apart, a
      reader meets each alone and merges them. Side by side, the
      difference is unmissable. (Minty's call, S73.)
      Plus THE BUCKET CHAIN: SOH → DO → PS → Shipped, + Misc Release,
      + consumed-by-a-parent-MO.
      ⚠ 3A.2 and 3A.4 POINT HERE for the stock hops; they do not describe them.
3A.6  TRACEABILITY
3A.7  FOOD SAFETY
      Documents, HACCP.
3A.8  SUPER ADMIN
      Onboarding, global procedures, client guides, licences, roles.
```

### 9B. SECTION 3B — ARCHITECTURE & INFRASTRUCTURE

⚠ Everything the app RUNS ON. Different kind of knowledge from 3A, and reached at a different moment: a client bug → 3A. A deploy, a key, a reboot → 3B. They almost never overlap.

```
3B.1   THE PICTURE       One page. Angular → Nginx → Sails → RDS. The
                         three environments (old / dev / prod), which
                         account each lives in, what talks to what. Read first.
3B.2   THE BOXES         EC2 prod + dev: ids, types, EIPs, OS, security
                         groups, PM2 names. SSH lines. [MAC]/[DEV]/[PROD] colours.
3B.3   THE DATABASES     RDS prod + dev: endpoints, classes, engine, param
                         groups, the two schemas (archive vs live). ⚠ The
                         native-password trap. Access method + temp-cnf recipe.
3B.4   THE PIPELINE      CI → artifact → promote.sh → deploy-frontend.sh →
                         verify. Backend deploy. Rollback. ⚠ THE BOX CANNOT BUILD.
3B.5   HEALTH CHECK      How to verify both boxes are alive and in sync. Every session.
3B.6   DOMAINS/DNS/SSL   trace / dev / the future app.abletrace.ca. ⚠ Which
                         DNS lives where (GoDaddy vs Route 53 in the OLD
                         account). Certs, renewal, nginx vhosts.
3B.7   SERVICES          S3 · SES (⚠ IAM key, NOT SMTP) · Zoho (read only) · Zebra.
3B.8   CREDENTIALS       ⚠ POINTERS ONLY. What each secret is, where it
                         lives, how to rotate it. Values live in H, NEVER leave it.
3B.9   REPOS             Frontend · Backend · DOCUMENTATION. PAT. What is in
                         git and what is not.
3B.10  THE OLD APP       Its own block. Old account, two live clients, ⚠ WHAT
                         STILL DEPENDS ON IT (SES + abletrace.ca DNS are LIVE
                         dependencies of the NEW app), domain-switch plan, two IAM keys.
3B.11  WHEN IT BREAKS    Triage. Symptom → likely cause → where to look.
```

### 9C. THE ENDPOINT — WHERE THE DOCS LIVE  ⚠ UPDATED S76

The docs live in a GitHub repository Claude reads DIRECTLY. No deploy process; readable at any time.

```
Repo    Mintygadhok/abletrace-lab-docs   (PUBLIC — see the decision below)
Web     https://github.com/Mintygadhok/abletrace-lab-docs
Raw     https://raw.githubusercontent.com/Mintygadhok/abletrace-lab-docs/main/<file>
Files   Section_0.md · Section_1.md · Section_2.md · Section_3A.md ·
        Section_3B.md · Section_4.md · Section_5.md
        (⚠ Section 1 now IN repo, changed S76; H NEVER in repo)
```

**⚠ PUBLIC, NOT PRIVATE — the decision (S76, revises the S73 "private" call).**
The original S73 decision was PRIVATE, reasoning: the docs name live infrastructure (instance ids, RDS endpoints, security groups, IAM users, bucket names, the deploy path) — no secrets, but a map of a live food-safety system. S76 revised this to PUBLIC because (a) a public repo is the only form Claude can read via a plain URL with no credentials — private access would drag us back to pasting — and (b) under **Option B** the genuinely-identifying infra strings (RDS endpoint, instance ids, SG ids, IAM user names, bucket name) are SCRUBBED OUT of the public files and kept in Section H. So the public repo carries the LOGIC, STRUCTURE, TRAPS and REASONING — what Claude needs to diagnose — but not the front-door coordinates. Minty's decision, S76.

**⚠ WHAT THIS FIXES:** previously Claude saw ONLY WHAT WAS PASTED — so a gap in the source was invisible to Claude, and unrecorded gaps had already cost real sessions. A repo Claude reads directly kills that failure mode.

**⚠ SECTION 1 (NOW) — IN THE REPO, BUT KEEPS ITS DISCIPLINE (changed S76).**
Originally NOW was kept OUT of the repo and held by Minty, so that rewriting it whole was a deliberate manual act each session. S76 moved it INTO the repo (as Section_1.md) because the repo actually REDUCES the staleness risk the old rule feared: git timestamps show when it was last updated, and there is no loose copy to paste stale by accident. ⚠ THE DISCIPLINE IS UNCHANGED — NOW is still REWRITTEN WHOLE every session per rule 7.1/7.2; living in the repo is a convenience (one-line standing paste, markdown easier to edit than docx, Claude always sees current state), NOT a licence to let it drift. A stale NOW is still THE #1 failure mode. (Minty's call, S76.)

**⚠ SECTION H (SECRETS) — THE ONE PERMANENT REPO EXCEPTION.**
Never in chat, never in the repo. Minty only. Under Option B, the scrubbed infra identifiers (RDS endpoint, instance ids, SG ids, IAM user names, bucket name) live here too.

### 9D. WHAT THE DESIGN SECTION (4 / LOOK) HOLDS — AND WHAT IT DOESN'T.

Section 4 (LOOK) is visual + interaction language ONLY: palette, typography, tiles, rail, shell, component styling, document/print design. Two kinds of thing routinely LEAK into it and must be moved out on sight:
- A DB CHANGE (proc, view, seed, column) that happens to touch a screen → belongs in the traps/DB log (5) or its module (3A), NEVER in 4. (S50 Trace proc fix was filed in design; moved to the DB map.)
- A WORK QUEUE ITEM (a label to rename, a fix to make) → belongs in NOW (1) as a pending item. Design records that it was surfaced; the queue owns the action. (S67 label backlog.)

RULE: if an entry in 4 describes an ACTION TO TAKE or a STORED-DATA change rather than how something LOOKS or BEHAVES, it is in the wrong section. Move it; leave a one-line pointer.

---

**END SECTION 0**
