# NOW

S125 close, 16 Aug 2026.

A session opens on **RULES** and this file. Everything else on demand.

This is a launchpad: state, one job, the pending list. Facts the open check measures are not written here.

---

## STATE

### Deliberate — do not "fix" these

| looks wrong | why it isn't |
|---|---|
| prod's frontend git checkout lags the served build | by design. P8. Read the live build off the newest `www-html.bak-*` name |
| prod on Node 18, dev on Node 24 | dev runs a new engine for a while before prod is asked to. → P210 |
| CI builder on Node 20 | Angular 18 caps at 20, so parity is unreachable. Documented gap, S121. → P217 |
| dev 24.04, prod 26.04 | the hosts do not transfer. Say the verdict out loud before relying on a dev result |

### Half-done

- **Prod was never checked at the S125 open.** Dev was read and matched. Run both boxes at the S126 open.
- **Dev's Node-18 rollback tree is still on disk** — 303 MB at `~/abletrace-lab-backend/node_modules.old-node18`. **Not** at `~/`, where three sessions of notes had it. Nothing depends on it. Delete on the next visit to dev. → P227
- **The project Instructions field holds stale RULES**, now two commits behind. Changes no command.

---

## THE JOB — S126 · 3B'S FATE

> Minty, S124: *"this section has cost us a lot to maintain it. not sure if it has value."*

829 lines, last edited 28 July. **No session has ever read 60% of it.** S124 corrected seventeen things in it and the file came out **43 lines longer** — that session is why RULES now says replace, don't patch.

### Action

**1 · Map it.** The line numbers we hold are derived, not measured. An address is a claim.

```
grep -n "^## 3B" ~/abletrace-lab-docs/Section_3B.md
```

**2 · Read the seven blocks nobody has opened.** 3B.3 databases · 3B.5 health check · 3B.6 domains/DNS/SSL · 3B.7 services · 3B.9 repos · 3B.10 the old app · 3B.11 when it breaks. ~430 lines. **Two pastes, not one.**

**3 · Sort every line into three buckets.** This is a hunt, not a comprehension read.

- **measurable** — a command returns it. Goes, whatever happens to 3B.
- **load-bearing and unmeasurable** — a credential location, or a procedure the box will not tell you. The only content that must survive.
- **history** — git holds it.

**4 · Decide.** Retire, or replace whole at ~150 lines — the operations card someone reaches for when something is broken.

**5 · Tie off the two RULES pointers**, quoted here so nobody goes looking:

- §4 CREDENTIALS — *"Rotation method is 3B.8. Read it first — a fumble on a live DB password locks the app out."* **The one genuinely load-bearing pointer in RULES.** If 3B goes, this needs a home.
- THE FILES — *"3B — boxes, databases, pipeline, DNS, printer."*

**6 · Settle P204's six orphans** while the blocks are on screen. 3B cites queue numbers that exist in no queue: **P1(b), P3, P4, P28, P74, P76, P77**. All in unread blocks. They die with 3B if it retires.

### Material — done at S124, do not redo

**The six-facts analysis.** Six operational facts from 3B were vetted as candidates for RULES. **Only two are genuinely missing.**

*Already covered, do not add:* rollback paths (§2 says read them off the box — writing them down is what creates the stale copy) · cannot-build-Angular (§2 already assigns build to GitHub, run to dev) · rotation order (§4's pointer, above) · nginx symlink and HSTS (needed once a year; not a rule).

*Genuinely missing:*

```
ssh -i ~/.ssh/abletrace-lab-key.pem ubuntu@16.55.10.205
ssh -i ~/.ssh/abletrace-lab-key.pem ubuntu@15.157.38.101
```

§2 says ssh always from the Mac but never gives the command, and `~/.ssh/config` has no host entry for either box.

▶ **Claude's recommendation, S125: don't write these down — make them measurable.** Add host entries to `~/.ssh/config` so `ssh dev` and `ssh prod` work. Nothing to store, nothing to go stale.

**Dev's ssh is fragile.** Dev's security group allows inbound 22 from **one IPv4 /32**, so the Mac drifting onto IPv6 locks you out of dev while prod still connects — that asymmetry is the tell. Always `ssh -4`; plain `curl ifconfig.me` reports a phantom address, only `curl -4 ifconfig.me` gives the real source. Cost a session at S73. → P224

### Analysis

**The evidence leans to retire.** Last edited 28 July. S122 mapped its headers without opening it. Every fact corrected into it at S124 had already been *measured somewhere else*, because someone needed it and went and looked rather than reading 3B. A document that gets re-derived instead of read is not being used.

**Against that: replace means read first.** Retiring or rewriting a document nobody has read deletes facts nobody knows are there. Git holds them, but nobody goes looking for what they don't know was removed. Step 2 is not optional.

Everything cut stays in git history. Nothing is lost by cutting.

### Precondition — only if the answer is "cut and upload"

The upload is a manual copy into project Context, the staleness we have hit twice already. The GitHub connector would remove it. Unmeasured:

1. **Does a connected repo stay current, or snapshot?** If it snapshots it solves nothing. Establish first.
2. OAuth grants write access to the account holding the working PAT. Nothing needs write. Is read-only available?
3. Section_4.md becomes searchable and it is stale. → P222

Not a blocker for **retire**.

### Verify

All seven unread blocks on screen · decision made on evidence · 3B replaced whole or retired with its load-bearing facts relocated · both RULES pointers resolved · P204's six orphans settled or killed · committed and pushed.

---

## PENDING

New items at the bottom, never renumbered. **Ranking is Minty's.**

### Next up

**P210 · PROD TO NODE 24.** Own session, nothing else in it. Prod unpatched since April 2025. Install method measured S122 — NodeSource `node_18.x`, pinned 600. Dev's route transfers: change the repo line to `node_24.x`, apt update, apt install. **Apt replaces, it does not add.**

> **Mandatory gate — Minty's ruling, S122.** needrestart *will* restart pm2 mid-upgrade: apt sees the pm2 service linked to the Node binary it just replaced and runs `systemctl restart pm2-ubuntu.service`, whose job is `pm2 resurrect`. A deliberately stopped app comes back **unattended**, on the new engine, against the **old** `node_modules`, pointed at the **live database** — and pm2 reads `online` with ↺0 as though all were well. Measured S120 on dev. On prod that is Glutenull and Hagensborg back up without instruction.
>
> Three steps, in order, **inside** the runbook: **prevent** (needrestart set to never restart, proven in force *before* the repo line is touched) · **verify** (`pm2 status` immediately after `apt install nodejs`, every time, whether or not step 1 looked like it worked) · **stop again** (if it resurrected, stop the app before reinstalling `node_modules`).

**P217 · Angular 18 → 20.** The only thing that unblocks a Node 24 builder. Angular 20 supports ^20.19 || ^22.12 || ^24. Framework major on a live client app — multiple sessions, own gate.

**P206 · MO release panel shows one release per material, not each.** MO-0014 traceability lists six Ginger Powder releases; the MO's own panel shows a single row of 916.471 and is not summing them either. A warehouse controller cannot see what was actually consumed. Suspect a join collapse or missing aggregate. Raised by Minty.

**P228 · Move three business-logic rulings into Bible Part 1** (`Section_2.md`). They are domain rules and have been sitting in NOW:

- *Traceability reports what was released at the time.* MO-0007 ran under IP2 version 1 and reports version 1's figures. A screen that re-cast history against the current formulation **would be the defect**. (S112)
- *~0.001 variance on a multi-release lot is accepted.* SOH is reconciled against physical count monthly. The cumulative fix was offered and rejected on domain grounds. (S116)
- *Stock must never go negative.* `Math.max(0,…)` on both branches.

⚠ Part 1 is edited only on Minty's express permission, wording approved in advance. And **read first** — P221 says four of its blocks are self-declared incomplete. Do this as a job, not a close task. Originals are in Section 5 regardless.

**P111 · QuickBooks.** Precondition met. One planning session, no code. Needs a new column (TRAPS 3).

### Return path — goes last, Minty's ruling S112

P163 · **P164** · P165 · P168 · Bible rows 20/42/43. Budget as a survey; never read end to end.

**P164 is live on both clients today, deliberately.** `Formulations.js` declares `returnSum` in all three branches and never assigns it, then adds the return into the **released** total — so returning material makes the screen show *more* released, and Returned Qty always reads 0. `MLOManagement.js:1112` does the identical job correctly. **The proof one file is wrong is sitting in the other file.**

Also here: `PackingSlips.js:267` and `:419` subtract `currentToDate - returnQty` with no floor — the negative-balance exposure ruled against in S116, on the return path.

### Infrastructure

**P203** No ESM Apps on either box; 17 updates pending dev, 36 prod (S118).
**P205** pm2 differs, dev 7.0.3 / prod 7.0.1. Global, outside package-lock. `package.json` declares `^5.3.0` and neither box runs 5.x. P210 will not fix it.
**P207** Waterline warns at every boot — null `description` on `companyuserrole` and `roles`, null timestamps on `company`. Harmless, but it floods the log and a real error would be buried.
**P208** `npm install` reports 110 vulnerabilities, 33 critical. `npm audit` names them.
**P214** Old repo `~/abletrace-lab/abletrace-frontend`, GitLab-era. GitHub token dead (401). **GitLab token never measured, may still be live** — revoke in GitLab's UI, it is free. Keep one sanitized snapshot (strip remotes first), then delete.
**P215** `promote.sh` is not in version control — `/Users/mintym1/promote.sh`, outside any repo, one machine. `deploy-frontend.sh` likewise only on the boxes. **These two scripts are the deploy procedure.**
**P216** GitHub Actions v4 deprecated. Bump `checkout`, `setup-node`, `upload-artifact` to @v5. Unrelated to `node-version: '20'`. Cheap.
**P219** `deploy-frontend.sh` names backups after the build. The name is true about what is live; the **contents** are the trap.
**P224** Dev SSH has no IPv6 rule — see the job block.
**P225** Sweep `~/Downloads`. 11+ build artifacts back to S61. `promote.sh` deploys whatever zip you name, and S111 offered a superseded artifact for prod.
**P227** Delete dev's `~/abletrace-lab-backend/node_modules.old-node18`, 303 MB.

### Documents

**P90** Two false claims in 3A, which is searchable in project knowledge. Five of eight modules self-marked STUB is honest; a false claim is not. Find them.
**P221** Bible Part 1 has four self-declared incomplete blocks. **TO BE VERIFIED is the hazard** — it says outright "unconfirmed against live code" and sits in the document a session trusts for business rules. Untouched since S84, now searchable a paragraph at a time.
**P222** Section 4, 635 lines, never edited since S79, held out of the project. ⚠ **The item starts from the wrong end:** it assumed Section 4's "MO production-status indicator ✅ BUILT" was false, but Section_5's J22 says the component *was* built at S49, commit 2228cda9. **Section 4 is probably right and the S46 backlog is the stale record.** Do not correct a true claim.
**P229** Bible **Part 4** records the IP4 lot ratio as 0.04478498…. True figure is 41 ÷ 915.53 = 0.0447828…. Changed no result — 1.957 either way — but wrong where a future session would copy it.

### Business questions — Minty's, not defects

**P218** Over-release accepted silently. MO-0014 requires 916.471 Kg of Ginger Powder; the screen read 1016.471/916.471 and the app took it. Not a wrong row — the S106 clamshell ruling holds. **Should it warn?**
**P200** Negative quantity accepted on add-sales-order. `.html:84` no `min`; `.ts:245` and `:249` no `Validators.min(0)`. Frontend build and deploy, known 20-minute path.
**P201** `add-sales-order.component.ts:393` — `(quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit)`. batch_qty cancels, so it divides a weight to make a unit count. Reachability unmeasured.

### Units campaign — 38 green of 51, a deliberate stop

Bible frozen as an archive; consulted per row.

**Row 41 is cheapest and most visible** — release details shows Kg with no unit count. All history reads 0 (the JR20/P170 trade); sooner is cheaper.
**P196** Two intermediate blocks disagree by 0.011 Kg (0.004 on IP4). Display only.
**P135** Two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
**P198** `formulations.inventory` carries float tails — no floor, no rounding. Only `inventory_units` gets `Math.round` and `Math.max(0,…)`. Low.

### Unranked

P8 · P17 · P20/P22 · P64 · P65 · P84/P85 · P86 · P88 · P94 · P101/P109 · P106 · P108 · P114 · P116/P117 · P118 · P119 · P120 · P121–P123 · P124 · P129 · P130 · P131 · P132 · P133 · P134 · P136 · P137 · P138 · P139 · P142 · P145/P146 · P148 · P152 · P153 · P155 · P156 · P158/P159 · P166 · P167 · P169 · P170 · P171 · P172 · P173 · P174 · P175 · P178 · P179 · P182 · P185 · P189 · P190 · P191 · P192 · P194/P195

**P115 dead code:** `rejected-materials.ts:152-154` · `MLOManagement.js` getMLCbyId/V2 · PopUps/add-dispatch v1 · `edit-mlc.ts:311,227` · `MaterialsProductsReleased.js:52` and `:83-98` · `material-traceability-details.html:113-125, 191-216` · `Traceability.js` @returnedQty/@mprIDs

---

## SETTLED — DO NOT RE-OPEN

Rulings that are **not** already in RULES:

- **Section 5 is never cleaned.** Append-only forensic record; its value is that nothing was removed.
- **A reboot is its own step.** Never mid-work, never both boxes at once. Dev first, standalone.
- **The working GitHub PAT is not rotated.** Never exposed; the leaked one (`061cec73339d`) is dead, HTTP 401.
- **The old GitLab-era app is being dismantled.** Do not spend time repairing or rotating its credentials.
- **Release input stays kilograms.** The unit count is derived once at the write, rounded to three decimals, banked in the row and subtracted from stock. (S116 — now RULES §7 as the single exception to the units test.)
- **Materials are Kg only;** anything carrying a `formula_id` carries units. (S112)
