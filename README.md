# AbleTrace — Working Documentation

Technical and domain memory for **AbleTrace**, a food-safety traceability platform.
Operated by Minty (domain expert, sole operator). Claude is the sole coder and technical reviewer.

⚠ **These documents are the only technical memory that exists.** There is no other developer to ask. If a fact is not written down here, it is lost.

---

## THE SECTIONS — what each number means

| File | Name | What it holds | Read when |
|---|---|---|---|
| `Section_0.md` | **RULES** | How we work. Every rule was earned by a real failure; the session it bit is named. | ⚠ **First, every session.** Rarely changes. |
| `Section_1.md` | **NOW** | Current state, health, and the ranked work queue. | ⚠ **Second, every session.** Rewritten whole each time. |
| `Section_2.md` | **WHY** | The business logic. The permanent rules of how the business works — should outlive the code. | Before touching anything that has a domain meaning. |
| `Section_3A.md` | **THE MODULES** | What the app *does*, organised by module: materials, products, stock, sales, food safety. Each module carries its own front end, back end and database in one place. | A client bug. "How does formulation editing work?" |
| `Section_3B.md` | **INFRASTRUCTURE** | What the app *runs on*: boxes, databases, deploy pipeline, domains, credentials, the old app. | A deploy, a key, a reboot, a certificate. |
| `Section_5.md` | **WHAT BIT US** | Traps and evidence. Append-only; numbers are permanent. Holds the standing traps (JT), the rebuild checklist (JR), and the numbered entries (J). | ⚠ Before touching the DB or any odd-looking code. |
| `Section_6.md` | **HISTORY** | Session narrative. Reconstruction-of-record, not daily reading. | "Why did we do it that way?" — never "what is true now?" |

**Not in this repo:**

- **Section 4 — LOOK & FEEL.** UI/UX design language. Not yet converted.
- ⚠ **Section H — SECRETS.** Private, Minty only. Never in chat, never in this repo. Pointers only live in 3B.8.

---

## THE STANDING THREE

Every session opens with **Section 0 → Section 1 → Section 2**. Everything else is fetched by name when the work reaches it.

⚠ **The raw URL lags several minutes behind a fresh commit.** The GitHub web view is immediate truth. Do not conclude "it didn't commit" from a stale fetch.

---

## WHY IT IS PUBLIC

A public repo is the only form readable from a plain URL with no credentials — the alternative is going back to pasting everything, which is what caused unrecorded gaps to cost real sessions.

⚠ The genuinely identifying infrastructure strings — RDS endpoint, instance ids, security-group ids, IAM user names, bucket name — are **scrubbed out** and kept in Section H. This repo carries the **logic, structure, traps and reasoning**. Not the front-door coordinates.

---

## THE HOUSE RULES, IN ONE PLACE

```
ONE FACT, ONE HOME     Two homes for one fact is how drift starts. It is
                       what rotted the old documents.

WHOLE ITEMS ONLY       Never edit a line or a bullet. Reissue the entire
                       named item with the change in it. Hand editing is
                       what the discipline exists to avoid.

NEVER RENUMBER         New queue items go at the BOTTOM with the next
                       free number. Ranking is Minty's, at session open.

LOOK, DON'T REASON     When a claim can be tested by looking, look.
                       ⚠ A confident wrong answer becomes next session's
                       foundation. This rule was earned three times.

RESOLUTION DECAYS      History compresses backwards as it ages, so the
                       record stops growing. Nothing may live ONLY in
                       history.
```
