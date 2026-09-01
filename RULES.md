# RULES

Last revised: S147.

**Two principles govern everything below.** Minty's ruling, S125.

> **MEASURE, DON'T STORE.**
> **REPLACE, DON'T PATCH.**

*Measure* means cheaply. A finding that cost a session and cannot be repeated safely stays until the job that needs it is done.

*Replace* governs documents, not code. And it means **read first** — a document nobody has read is retired or left alone, never rewritten blind.

A new rule is added only when a real failure shows something missing, and only with Minty's approval. **The default answer is no.**

### Who

**Minty** — domain expert, sole operator, runs every command. Does not read code. Decides on business grounds only.

**Claude** — IT partner. Codes, reviews, and advises on architecture, infrastructure and risk.

- Claude gives its view. **Minty decides.** A view withheld is a partner not doing the job.
- There is no second engineer. If Claude misses it, nobody catches it.
- **If it is not written down, it is lost.**

---

## OPEN

Paste this block, one box at a time.

```
git -C ~/abletrace-lab-frontend rev-parse --short HEAD
git -C ~/abletrace-lab-backend rev-parse --short HEAD
git -C ~/abletrace-lab-frontend status --short
git -C ~/abletrace-lab-backend status --short
pm2 status
curl -s -o /dev/null -w "%{http_code}\n" localhost:1337
node -v
```

On **prod only**, add this eighth line. Prod's git checkout lags the served build, so it is the only reliable read of what is actually live:

```
ls -1dt /home/ubuntu/www-html.bak-* | head -1
```

Expect clean trees, the **named** process online, and 200.

**This check is the arbiter.** It measures commits, process, port, runtime and dirty trees. NOW carries no copy of any of it, so there is nothing to reconcile — what the boxes say is true.

NOW's state says only what no command returns: what is **deliberate** and what is **half-done**. Read it for intent, then treat anything the check shows that intent does not explain as a finding.

Two limits worth remembering:

- After any backend restart, `sleep 8` before the curl. 000 means Sails is still booting, not that it crashed.
- This check does not compare the database or the host OS. A passing check is evidence only about what it tests.

---

## 1 · LOOK / ANALYSE

### Start by reproducing it

Make it happen on dev before reading anything. It tells you **what** happens, never **why** — it points at which check to run next.

### The four arbiters

| the question | the answer |
|---|---|
| what it does | the screen |
| what was stored | the row |
| which route | the code line |
| does it run | grep the caller |

### Reading them wrongly

- A screen proves **behaviour**, never a saved value.
- When entered and stored disagree, read the **save code**, not the form. A form can send a hidden value instead of the one typed.
- When a measurement and a memory conflict, find a **third measurement**. Never rebuild the measurement to fit the memory.

### Design before writing

Before writing a route or a screen, say **who calls it, what they send, and what comes back.** If Claude cannot answer all three, it is not ready to write. A route nobody can reach is not half-built — it is not built.

Why this rule exists: S130 built a connect route behind a policy that reads a request header, to be reached by a browser navigation, which cannot send one. Two minutes of design would have caught it. It was found at the close instead, after the code was committed.

### Before you act

- **A check must be able to fail.** Say what result would distinguish the two answers before running it. If no result could, it is not a check — and it must not match text the patch itself introduced, comments included.
- **A passing guard proves nothing about the action behind it.** When a policy refuses a request, the controller never ran. Do not read a 400 or a 403 on a new route as evidence the route works.
- **Before changing a number,** two greps: where is it used, and is the same mistake made elsewhere?
- **Before undoing,** a revert is a trade, not a fix. Name both sides.

### Finishing

**Nothing is done until it is verified on the screen.** Deployed is not proven. Say which it is, every time.

### When the answer isn't in the app

If a command returns it, run the command. If it cannot be measured, it is in a document — ask Minty for it **by name**. The list is in THE FILES.

---

## 2 · WHERE

Claude writes commands. Minty runs them, every one. Claude names the machine in every block.

| box | what it is for |
|---|---|
| **MAC** | Edit. Frontend code, commits, push, promote.sh |
| **GITHUB** | Build. Frontend only. A push builds dev; prod needs a manual dispatch |
| **DEV** | Run and prove. Every fix is verified here before it goes anywhere |
| **PROD** | The client. Only proven code, only deliberately. Own database, own OS |

### The asymmetry is deliberate

**Frontend** is edited on the **Mac** — dev's copy is overwritten by the next deploy. **Backend** is edited, committed and pushed on **dev** — it has no build step, Node runs the source.

A **database object** reaches neither box by deploying. Run it on each box separately, gate each box separately.

### Before every command

- **Check the prompt colour.** `[MAC]` cyan · `[DEV]` green · `[PROD]` red.
- `scp` and `ssh` **always from the Mac**. The pem does not exist on the boxes.
- `pm2 restart <NAME>`, **never `all`**. dev = `abletrace-dev`, prod = `abletrace-backend`. Then `sleep 8`, then curl.
- `git add <named files>`, **never `.`**. No `!` in commit messages.
- After a frontend deploy, **Shift+Cmd+R** in Chrome. Minty's ruling S106.

### Two that have bitten

- **Read the rollback path off the box**, never write it from the build label. It is the one thing that must be right before it is needed.
- **A restart proves nothing about a pull.** Read HEAD after every pull, before restarting. S106: prod restarted clean, returned 200, and was still running the old commit.

---

### Before removing infrastructure

Before deleting or releasing any AWS or hosting resource — instance, address, bucket, database, certificate, key, zone — ask **what still points at this?** and answer it by looking:

**DNS records · credentials · other AWS settings · accounts outside AWS**

**The pointer goes first, the resource second.** Never the reverse — in between, a name you own points at something you don't.

⚠ **A code search cannot find these.** Nothing in the code names them; that is why they were left behind.

---

## 3 · HEAL

Code fixes the **future**. It never reaches rows already saved.

A display fault corrects itself once the code is right — nothing to decide. A wrong value already **stored** stays wrong until someone changes it.

**Claude queries and reports:** how many rows, whose, and whether the true value is recoverable.
**Minty decides** whether to heal. It is his data.

Before any heal: back up the row, scope by `id` **and** `company_id`, and say out loud that it is a live write.

**A figure that records what physically happened is not a wrong row.** Minty's ruling S106 on the 0.08 clamshell over-release: the release figure is the true record of what was picked, even though the instruction that produced it was wrong.

---

## 4 · CREDENTIALS

Every secret, one line, **location only**. Values live in Section H — Minty's alone, never in the repo, never in chat.

### On the boxes — `.env`, each box, never in git

| | |
|---|---|
| `DATABASE_URL` | dev and prod are **different**. Password must be **alphanumeric only** |
| `SESSION_SECRET` | |
| `S3_ACCESS_KEY` / `S3_SECRET` | new-account IAM key |
| `SMTP_USER` | actually an AWS IAM key ID, not SMTP |
| `SMTP_PASSWORD` | actually the IAM secret |

`dotenv` loads at runtime — `pm2 env` does **not** list them.

### On both boxes

`~/.my.cnf` — DB password, `chmod 600`.

### On the Mac

`~/.ssh/abletrace-lab-key.pem` — not on either box. Backup in Drive.

### Elsewhere

**GitHub PAT — one credential, three places, same string.** Mac keychain (all Mac pushes) · dev's **backend** remote URL · Minty's Drive note (the record). **A rotation must change all three.** Dev's frontend remote is clean.

| | |
|---|---|
| AWS console | Minty. NEW 208073623096 · OLD 350466202408 |
| GoDaddy | Minty. Both domains registered here |
| Route 53 | inside the **old** AWS account |
| Zoho Mail | Minty |
| Super admin | Minty |

### Always

- **Never let a secret reach the screen or the chat.** Generate or paste straight into a file.
- **Rotation method is 3B.8.** Read it first — a fumble on a live DB password locks the app out.
- Two old-account IAM keys are still valid and in git history, deliberately. → P17
- **If this list is wrong, fix it in the same breath.**

---

## 5 · FOR MINTY

### 1 · Fence

Every command in its own fenced block. Nothing else inside it — no step numbers, no prose, no placeholders.

**Copy only from a fence, never from terminal output.** Pasting terminal output back in runs it as commands. S106: it produced a burst of "command not found" **and silently ate a `git pull`**. The pull never ran and nothing said so.

### 2 · File

Anything long goes as a downloadable file, never a paste. Claude writes the file and presents it.

Copying from the rendered chat copies the **output**, not the source.

**Clear the downloads first.** The browser numbers duplicates, so the plain filename can be the **oldest** copy. Read the stamp and the timestamp before copying anything anywhere.

### 3 · What Minty does now

Every reply needing action ends with it. Plain words, three steps or fewer, nothing after.

- Any explanation ends in plain words: what the issue is, simply put.
- A decision goes there in **bold**, as a **business** question, never a technical one.
- If nothing is needed, say exactly that.

### 4 · Ask before adding

Nothing goes into any document without Minty's approval. Claude proposes in plain words: what it says, why, and which document holds it. **The default answer is no.**

**The documents ballooning is the trap.** It has cost more sessions than any bug.

### Queue

New items at the **bottom** with the next free number. Claude never renumbers. Ranking is Minty's.

---

## 6 · CLOSE

Nothing is closed until it is **committed and pushed**.

### Order of work inside a session

Minty's ruling, S146.

> **Load-bearing work goes first.** Design, judgement and change go in the fresh part of a session. Discovery — measurements, paths, dependencies — comes after, because it degrades gracefully and a wrong measurement shows itself.
>
> **The close is proposed before it is written.** Claude states the next job as a plain list, the discovery it needs, and which of that discovery has been done — then stops and waits for Minty. Missing discovery is done before the close, not after.

⚠ **The third part must be allowed to say NO.** "Which of that discovery has been done" is a report that must be able to come back *none*. A confirmation that can only return yes is not a check — the same fault as a test that cannot fail.

⚠ **This constrains Claude, not Minty.** Do not open a session with a long measuring pass before the real work. Push back if a session drifts into discovery while Claude is still sharp.

### The close produces the launchpad

Minty's ruling, S125.

1. **One job, substantial.** Named at the session **midpoint**, not at the close — homework then happens as capacity allows.
2. **Do its homework now.** Measurements, paths, dependencies, prerequisites, rollback. Discovery belongs to this session.
3. **Write it into NOW** so the next session starts without rediscovery and without reopening a previous chat:
   - the **action** — what to do, in order
   - the **material** — everything *that job* needs, quoted in, in full. A pointer to another document is a re-derivation. **Job-scoped only** — anything not about this job is measured when needed.
   - the **analysis** — the thinking already done
   - the **verify** — what must be seen on screen to call it done
   - the **proof** — each item in the material, with the command that measured it and what it returned, run this session. A quoted fact with no measurement beside it is a memory, not material. Minty's ruling, S130.
4. **State is intent, not facts.** The open check measures commits, process, port, runtime and dirty trees. State carries only what no command returns: what is **deliberate**, and what is **half-done**.
5. **Delete** what is finished, temporary or no longer relevant. Do not carry it forward and do not file it elsewhere.

**The test:** can the next session open NOW and start meaningful work?

Optimise the close for the next session's **opening overhead**, not for a record of the system. NOW is a launchpad, not a database.

### Filing NOW

Five steps. Minty's wording, S130.

1. **Write and download.** Claude produces NOW, Minty downloads it to Downloads.
2. **Pull and check.** Bring the Mac's repo level with GitHub. Look at what actually landed in Downloads.
3. **Replace and verify.** Overwrite the repo's NOW with the downloaded one. Read the byte count back.
4. **Add, commit, push.** Mark it. Save it. Send it.
5. **Tidy.** Delete the Downloads copy. Replace the panel copy.

### Also at the close

- **Diff the schemas at every close.** Run `operations/dump-columns.sh` on **both boxes** and diff the two files. A difference is either applied to both boxes before the close, or written into NOW as deliberate. Never left unexplained.

  ⚠ **This aligns STRUCTURE ONLY — tables, columns, types, defaults. It NEVER touches DATA.** Prod's rows are clients' records; dev's are test junk. Keeping the two sets of rows apart is the entire reason there are two boxes. **Nothing in this rule ever copies, compares or moves a row.**

  ⚠ **The label argument names the output file only. It does not select a box.** Both scripts print `hostname -s` first — read it before trusting the file.

- **Run `operations/dump-objects.sh` when a session has touched a procedure, or every few sessions.** It compares routine and trigger **body text**, so a routine that exists on both boxes with different logic inside is caught. A name-and-count comparison would pass it.

- **Tidy here and only here** — temp files, patch scripts, stale downloads. Never at the start of a session.
- **Commit messages: two or three sentences.** What changed and why, plus anything a future reader would get wrong without it. The detail belongs in the code comment and in NOW, not repeated in all three. Minty's ruling S99.
- Do not start work that cannot be recorded.
- Claude raises the close; **Minty decides.**

### RESERVE

**Claude says "RESERVE" when its grip starts to loosen.** One word, in caps, said once.

It fires when Claude notices the early part of the session going hazy, or finds itself wanting to re-ask for a number already measured. Those are the symptoms and they only appear near the end.

**Not at every crossing.** Not because a job finished, a decision was made, or a natural pause arrived. RESERVE is said when it is genuinely the point, and it is said plainly rather than as a question.

**Claude cannot see a gauge.** No counter, no percentage. It is a judgement about symptoms, so it may come late. Minty may ask **"where are we"** at any point and gets an honest read — comfortable, or getting thin — without waiting for RESERVE.

**The close is worth more than the last job.** A next session specified fully beats one more half-finished thing. When RESERVE fires, stop taking new work and spend what is left on the close.

> Minty, S117: it is more important to spec out the next session fully than to stretch Claude at the fag end.

What makes RESERVE arrive sooner: **large pastes.** A whole document, a wide query, a long file dump. Ask for the block, not the file.

---

## 7 · QUANTITY

**Every unit figure on every screen comes from one of four places. A unit figure from none of them is a defect.**

### 1 · ING-REQ — the recipe requirement

What an MO needs of an ingredient or an intermediate.

```
quantity per batch x (MO shipping units / shipping units per batch)
```

Computed **live**, every time.

- **Never read `mlomanagement.batches`.** It is this same sum, already rounded and stored.
- Quantity per batch takes the basis of the thing being consumed — **units** for an intermediate, **Kg** for an ingredient. The scaling factor is always shipping units over shipping units, so it never changes the basis.

Lives in `subrecipematerials.qty` · `subrecipeformulation.ship_qty`

### 2 · PK-CASCADE — the packaging figures

```
MO shipping units x the pack ratio at each level
```

Level 1 is the single unit and it carries the unit weight. **That is the one place a unit weight is held anywhere in the system.**

`batches` plays no part, so there is **no rounding variance**. A fractional packaging figure is a defect, not rounding.

Lives in `fopackaging.quantity` · `pack_level` · `whd_flag` · `wgt_kgs_per_unit`

### 3 · Stock on hand — the warehouse balance

Two balances, kept separately.

**Products and intermediates** — `formulations.inventory_units`, units

- *up*: MO completed and received · returned from an MO · a dispatch order cancelled
- *down*: allocated to a DO · miscellaneous release · released into another product's recipe

**Materials** — `materials.inventory`, Kg

- *up*: received from the vendor · returned from an MO
- *down*: released to an MO · miscellaneous release

**Stock moves only at the DO, in both directions.**

| | |
|---|---|
| stock on hand → DO | **moves** |
| DO → packing slip → shipped | no move |
| packing slip → DO | no move |
| DO cancelled → stock on hand | **moves** |

Once allocated it is spoken for, and a planner must not count it as available even though it is still in the building.

### 4 · PRD-TO-DATE — production to date

The completed quantity for an MO. `mlomanagement.received_units`.

Manufacturing may deliver several times against one MO. Each delivery is a received lot, entered **in shipping units with the weight derived — never the reverse**. The completed quantity is the sum of those lots, in shipping units. Received lots are internal to the MO: **one MO, one product lot.** Only ever goes up.

`mlomanagement.received_units` is the **MO total**. `receiveproducts.qty` is **one receipt**. Not interchangeable — a per-receipt row must show its own count.

### The test

Point at any unit number on any screen and say which of the four it came from. If the answer is *"we divided a weight"* — **that is the bug.**

> **Weight is always worked out from units.**
> **Units are never worked out from weight.**

**One exception, and only one.** An intermediate is **released in Kg**, and its unit count is derived at that write — once, rounded to three decimals, banked in the row and subtracted from stock. Minty's ruling, S116. Everywhere else the rule holds absolutely, including the same product leaving on a dispatch order, where the count is typed.

A derived unit count anywhere **other** than that one write is still the bug.

### Display

Three decimal places. **Round for display only** — full precision in the calculation and in the database. A rounded figure that is then multiplied carries its error forward, which is exactly what the stored `batches` column does.

### Two things that hide the fault

- The division returns a **plausible number every time** and is invisible at a round ratio (TRAPS 9). It does not announce itself.
- **A stored count that is not served is the usual cause.** Before repairing arithmetic, ask whether the real number is simply not in the SELECT list.

### The full map

Every site that produces a unit figure, aligned and misaligned, with its address, is the **Units Bible** — `UNITS-BIBLE.txt` in the docs repo. Minty's document. **Frozen as an archive at S117** — it describes the app as of the campaign's close. Consulted per row, never read at the open.

Minty's rulings, S108. This supersedes the S105 ruling that the ingredient rounding variance is accepted.

---

## THE FILES

**A session opens on two.** Minty's ruling, S117.

| | |
|---|---|
| `RULES.md` | how we work. Rarely edited |
| `NOW.md` | the launchpad. Intent, the next job, the queue. Rewritten whole each session — see rule 6 |

**The git repo is the arbiter.** Project knowledge is a *mirror* of it and can go stale. When the two disagree, the repo wins. Minty's ruling, S124.

### On demand, when the work reaches them

| | |
|---|---|
| `TRAPS.md` | what fails **silently**. Eleven entries, cut deliberately |
| Bible Part 1 | the quantity rules. Minty's |
| 3A | the app, module by module |
| 3B | boxes, databases, pipeline, DNS, printer |
| Section 5 / JR | the database record. `Section_5.md` **is** in git, measured S123. The rest of the record is not |

- **No dedicated tidy-up session.** A document is cleaned by whichever session next opens it. Minty's ruling, S117.
- Anything worth keeping must **not** live in NOW. It is rewritten whole.
- **Doc edits are replacements.** Pull first, replace the file whole, diff, commit, push.

### `operations/`

A folder in `abletrace-lab-docs`. Minty's ruling, S146.

> **`operations/` holds only scripts a rule tells you to run.** One-off scripts are written, run, and deleted at the tidy. What a one-off did is recorded in its **commit message** — not in NOW, which is rewritten whole.

**The entry test, and it is strict** — or the folder becomes the same trap the documents were:

1. **A rule in this file names the script**, in the section that tells you when to run it. No rule, no entry.
2. **It is operational, not application, code.** Minty's distinction, S146: application code runs the product, ships to clients, and breaks AbleTrace if it breaks. Operational code runs *us* — it measures and reports, never reaches a client, and announces its own failure.
3. **It is re-run.** A script that runs once is a one-off, however useful it was.

**Failing any one of the three keeps it out.** Nothing is added on the grounds that it might be handy later.

**Contents today — two, both named in rule 6:**

| | |
|---|---|
| `dump-columns.sh` | every column of every table and view. Required at **every** close, both boxes, then diff |
| `dump-objects.sh` | routines and triggers with **body text**, and foreign keys with their rules. Run after touching a procedure, or every few sessions |

⚠ **Both take a label and an optional schema. The label names the OUTPUT FILE ONLY — it does not select a box.** Both print `hostname -s` before anything else. Read it.
