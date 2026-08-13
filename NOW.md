# NOW — S116 close, 12 Aug 2026

**This file replaces NOW.md and PLAN.md.** State, next job, queue. Nothing else.

Other files: **RULES** (how we work) · **TRAPS** (silent failures, 10) · **UNITS-BIBLE Part 1** (Minty's quantity rules) · **Section 5 / JR** (database rebuild record — none of it is in git).

**What does not go here:** lessons, narrative, retrospectives, proof write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment beside the code. If it fits none of those it goes nowhere. The commit message and `git log` are the session history.

---

## STATE

```
DEV   16.55.10.205  backend 99852bf  pm2 abletrace-dev ↺267  200
      frontend serving 4910b46d · checkout c2a52d8e (stale, harmless)
PROD  15.157.38.101  backend 4d43bd4  pm2 abletrace-backend ↺343  200
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   frontend repo clean at 4910b46d — the only machine that edits it
```

**Backends differ by three commits, deliberately** — `2c2da8b · ba668aa · 99852bf`, all the intermediate-release work. Inert on prod: neither client has an intermediate. They promote together.

**Databases match.** Both boxes carry `mprrecievelots.qty_allocated_units` and JR24 (the release-details procedure serving it).

**Rollback:** frontend `www-html.bak-{dev,prod}-4910b46d*` (holds e1a82e02). Backend on dev `git reset --hard 4d43bd4`. JR24 from `~/WhC_GetMoMaterialProductReleaseDetails_SP.bak-S116-{DEV,PROD}.txt`, 2390 bytes each — SHOW CREATE text, needs the DELIMITER wrapper.

**Clients:** 471 Glutenull (2 MOs, round ratios) · 469 Hagensborg (13 MOs, none run, batch_qty 1 — can never demonstrate a quantity fix). Neither has ever created a dispatch order or released an intermediate.

**Not measured this session:** OS updates on either box, dist folder counts, /tmp contents.

---

## PENDING PROMOTION

- **Backend** — three commits, dev only. Blocked on dev testing below.
- **Frontend** — nothing. No build ran.
- **Database** — nothing. JR24 is on both boxes.

---

## THE NEXT JOB — S117

**Test the write path properly, then promote.**

S116 proved one case: a single full release, clean (41 − 1.957 = 39.043 exactly). Three shipped paths have never run — the **partial/clamp branch**, a **second release against the same lot**, and the **`Math.max(0,…)` floor**. A **draw-down to exhaustion** is also unmeasured.

Fixture: IP4 lot `Pdt-260811-1`, receiveproducts 11457. **39.043 units / 871.83 Kg remaining**; `prev_received_qty` is 43.700.

```
1  Minty builds two P4 MOs on 474: one small (second release), one
   large enough to exceed what the lot holds (clamp + exhaustion).
   Claude computes the sizes from the lot first.
2  Baseline by query. Prediction written before each release.
3  Release, compare, record.
4  Promote: backend 4d43bd4 → 99852bf, THREE commits.
   Gate: material release on prod sandbox 465 (not 464), and no client
   figure moves — check through Glutenull's own login.
```

**Overdue at the close:** P178's retention rule (set S115, not run twice — and S116 left six files in /tmp), and re-measure P102's numbers.

---

## QUEUE — Minty ranks. New items at the bottom, never renumbered.

**Top candidates**

- **P199** Negative shipped figure on the SO sheet. Dev company test260810@, SO-0001 shows `-76.000# (-380.000 Kg)`; 1# (5.000 Kg) was shipped. Client-facing and negative. Not diagnosed — measure first. Related: J91, P124, P138. First step: read the company id off the box.
- **P102** Reboot both boxes. Two live clients, 22+ days, security updates pending. pm2 units enabled on both, untested through a reboot.
- **Return path** — P163, **P164 (inverted sign, live on both clients)**, P165, P168, rows 20/42/43. Budget as a survey; never read end to end.
- **P111** QuickBooks. Precondition met — the units write path is closed. One planning session, no code. Needs a new column (TRAPS 3).

**Units campaign leftovers** — board 38 green of 51, a deliberate stop

- **Rows 37-41** now unblocked; the column is populated. Row 41 is cheapest and most visible — release details shows Kg with no unit count. ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
- **P196** two intermediate blocks disagree by 0.011 Kg. Display only.
- **P135** two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
- **P198** `formulations.inventory` (the Kg line) carries float tails. Not caused by S116. Low.

**Open, unranked**

P8 prod frontend checkout lags · P17 two old IAM keys live · P20/P22 delete old section files · P64 product label prints "null" · P65 promote.sh no -4 · P66 stale rollback points · P84/P85 printer guides · P86 cold boot untested · P88 dead "Fix A" pointers · P90 two false claims in 3A · P94 stray heal file on prod · P101/P109 dormant archive holds its own procedures · P106 old map file · P108 review J-entries · P114 closed vs in-progress MOs · **P115 delete dead code** (below) · P116/P117 file-read handling · P118 comment deliberate code *(working — keep)* · P119 db definitions stale on ten objects · P120 material barcode · P121-P123 client guide gaps · P124 SO status compares units to Kg, **live** · P129 food safety toggle has no attribute · P130 Excel exports unchecked · P131 unit count with weight label · P132 dead status columns · P133 do_status never advances · P134 schema naming · P136 view returns duplicates · P137 MR numbering global · P138 soproducts has no unit count · P139 not defects · P142 MR buttons commented out · P145/P146 MR screen quirks · P148 narrow residual · P152 read-rows drops columns · P153 .bak in api/models · P154/P176 deploy procedure not written down · P155 Mac push and prod origin · P156 company-id namespaces differ · P158/P159 IP trace procedures divide · P166 field named ship_qty holds Kg · P167 seven-copy helper · P169 transposed labels · P170 pre-JR15 MR rows read low · P171 unmapped quantity tables · P172 receipt code not unique · P173 nameless 0.000 row · P174 form control written into batches · P175 gate that cannot fail · **P178 retention rule (overdue)** · P179 `formulations_myCodee` typo · P180 Node 20 deprecated · P182 undocumented controls · P185 eval() on release screen, five sites · P189 possible double-count · P190 VARCHAR subtraction · P191 lot scanner undocumented · P192 final_qty from `batches` (fires only on duplicate rows) · P194/P195 Kg displays, correct under the S116 ruling

**P115 dead code:** `rejected-materials.ts:152-154` · `MLOManagement.js` getMLCbyId/V2 · `PopUps/add-dispatch` v1 · `edit-mlc.ts:311,227` · `MaterialsProductsReleased.js:52` and `:83-98` (the dead release twin) · `material-traceability-details.html:113-125, 191-216` · `Traceability.js` @returnedQty/@mprIDs

---

## CLOSED — delete these lines at the next close

P184 (write-path defect, fixed and healed S116) · P188 (settled by ruling S116) · P197 · P187 · P186 · P181 · P177 · P183 · P160 · P162 · P151 · P157 · P147 · P161 · P104 · P150

---

## SETTLED DECISIONS — do not re-open

- **Release input stays kilograms.** The unit count is derived once at the write, rounded to three decimals, and the same figure is banked in the row and subtracted from stock. *(Minty, S116)*
- **~0.001 variance on a multi-release lot is accepted.** SOH is reconciled against physical count monthly. The cumulative fix was offered and rejected on domain grounds — do not re-derive it. *(Minty, S116)*
- **Stock must never go negative.** `Math.max(0,…)` on both branches. Shipped, never exercised.
- **Return path goes last.** *(Minty, S112)*
- **Materials are Kg only; anything carrying a formula_id carries units.** *(Minty, S112 — Bible Part 1 §5)*
- **Traceability reports what was released at the time.** A screen re-casting history against the current formulation would be the defect. *(Minty, S112)*
