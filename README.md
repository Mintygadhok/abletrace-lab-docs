# AbleTrace — Working Documentation

Technical and domain memory for **AbleTrace**, a food-safety traceability platform.
Operated by Minty (domain expert, sole operator). Claude is the sole coder and technical reviewer.

⚠ **These documents are the only technical memory that exists.** There is no other developer to ask. If a fact is not written down here, it is lost.

---

## THE FOUR WORKING FILES — paste these, every session

| File | Name | What it holds | Discipline |
|---|---|---|---|
| `RULES.md` | **RULES** | How we work. Every rule was earned by a real failure. Also carries the map of what each reference section holds. | Edited rarely. Stamped `Last revised:` |
| `NOW.md` | **NOW** | Current state of both boxes, and the queue — everything banked for later, unranked. | ⚠ **Rewritten whole every session.** Stamped `Last rewritten:` |
| `TRAPS.md` | **TRAPS** | What bit us. The standing traps (JT) and everything learned the hard way. | ⚠ **Appended only, never cut.** Stamped `Last appended:` |
| `PLAN.md` | **PLAN** | The next session's list. Two or three jobs, sharply defined, and the paste list. | Rewritten whole, disposable. Stamped `Written at close of:` |

⚠ **EVERY FILE CARRIES ITS STAMP ON THE FIRST LINES, NOT THE LAST.** At session open, read all four stamps against the session being opened. If they lag, **the boxes are the arbiter** and the record is reconciled before any work.

⚠ **THE PASTE LIST IS IN `PLAN.md` AND IT IS AUTHORITATIVE.** Paste what it names and nothing else. It names every file the next job will *write* to, not just the ones it reads.

---

## THE REFERENCE SET — fetched by name, when the work reaches it

| File | Name | What it holds | Read when |
|---|---|---|---|
| `Section_2.md` | **WHY** | The business logic. The permanent rules of how the business works — should outlive the code. | Before touching anything with a domain meaning. |
| `Section_3A.md` | **THE MODULES** | What the app *does*, by module: materials, products, stock, sales, food safety. Each module carries its own front end, back end and database in one place. | A client bug. "How does formulation editing work?" |
| `Section_3B.md` | **INFRASTRUCTURE** | What the app *runs on*: boxes, databases, deploy pipeline, domains, credentials, the old app. | A deploy, a key, a reboot, a certificate. |
| `Section_5.md` | **THE REBUILD RECORD** | The JR fresh-database checklist — every proc, view, column add and seed that is **not in git** — and the numbered J-entries holding the evidence behind each finding. | ⚠ Before touching the database. ⚠ **Not deletable.** |
| `Section_6.md` | **HISTORY** | Session narrative. Reconstruction-of-record, not daily reading. | "Why did we do it that way?" — never "what is true now?" |

**Supporting files:** `db-definitions-S93.txt` holds the committed text of eleven database objects. `acrobatics-map-S91.txt` and `units-kg-checklist-S93.md` are working notes.

**Not in this repo:**
- **Section 4 — LOOK & FEEL.** UI/UX design language. Not yet converted.
- ⚠ **Section H — SECRETS.** Private, Minty only. Never in chat, never in this repo. Pointers only live in 3B.8.

⚠ **`Section_0.md` and `Section_1.md` NO LONGER EXIST.** Section 0 was folded into `RULES.md` and Section 1 was superseded by `NOW.md`, both deleted at the S95 close (P95). They had become second heads of documents that already existed, each internally consistent and each pointing at a different paste list. Both remain in git history. ⚠ **Anything anywhere that tells you to read Section 0 or Section 1 is stale** — `Section_6.md` refers to them throughout, correctly, as history.

---

## WHY IT IS PUBLIC

A public repo is the only form readable from a plain URL with no credentials — the alternative is going back to pasting everything, which is what caused unrecorded gaps to cost real sessions.

⚠ The genuinely identifying infrastructure strings — RDS endpoint, instance ids, security-group ids, IAM user names, bucket name — are **scrubbed out** and kept in Section H. This repo carries the **logic, structure, traps and reasoning**. Not the front-door coordinates.

⚠ **The raw URL lags several minutes behind a fresh commit.** The GitHub web view is immediate truth. Do not conclude "it didn't commit" from a stale fetch.

---

## THE HOUSE RULES, IN ONE PLACE

```
ONE FACT, ONE HOME     Two homes for one fact is how drift starts. It is
                       what rotted the old documents, and it is what
                       P95 and P105 closed in S95.

WHOLE ITEMS ONLY       Never edit a line or a bullet. Reissue the entire
                       named item with the change in it. Claude does the
                       diffing, not Minty.

A STRIKE CHASES        Correcting a claim in one place is not a strike
EVERY COPY             while the same claim survives elsewhere. S95
                       found three entries asserting one superseded
                       fact; all three moved in one patch.

NEVER RENUMBER         New queue items go at the BOTTOM of NOW with the
                       next free number. Logging is mechanical; ranking
                       is Minty's, at session open, in one pass.

LOOK, DON'T REASON     When a claim can be tested by looking, look.
                       ⚠ A confident wrong answer becomes next session's
                       foundation. Earned three times.

NOTHING IS CLOSED      A file written in the chat and downloaded is not
UNTIL IT IS PUSHED     the record. Two sessions' closes were downloaded
                       and never committed, and the session after opened
                       five sessions stale.

DOC EDITS ARE          The repo is cloned to the Mac and edited like
PATCHES, NOT PASTES    code: assert-anchored script, run from /tmp, read
                       the diff, commit. ⚠ The script is a TOOL, not a
                       document — it is deleted, never committed.

RESOLUTION DECAYS      History compresses backwards as it ages, so the
                       record stops growing. Nothing may live ONLY in
                       history.
```
