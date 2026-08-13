# NOW — S117 close, 13 Aug 2026

**State, next job, queue. Nothing else.**

⚠⚠ **A SESSION OPENS ON TWO FILES: RULES AND THIS ONE.** *(Minty, S117)*
Everything else is consulted ON DEMAND, when the work touches it:
**BUSINESS LOGIC** (Bible Part 1) · **3B** infrastructure · **3A** the app ·
**Section 5 / JR** the database record · **TRAPS** (10).
▶ NO DEDICATED TIDY-UP SESSION. A document is cleaned when it is next
opened, by the session that opens it. *(Minty, S117)*

**What does not go here:** lessons, narrative, retrospectives, proof
write-ups. A lesson becomes a RULES line, a TRAPS entry, or a comment
beside the code. If it fits none of those it goes nowhere.

---

## STATE

```
DEV   16.55.10.205  backend 99852bf  pm2 abletrace-dev ↺267  200  clean
      frontend serving 4910b46d · checkout c2a52d8e (stale, harmless)
PROD  15.157.38.101  backend 99852bf  pm2 abletrace-backend ↺344  200  clean
      frontend serving 4910b46d · checkout 9bce0238 (P8, by design)
MAC   frontend repo clean at 4910b46d — the only machine that edits it
```

**⚠ BACKENDS MATCH FOR THE FIRST TIME IN THREE SESSIONS.** The three
intermediate-release commits — `2c2da8b · ba668aa · 99852bf` — were
promoted this session. Nothing pending.

**Databases match.** Both boxes carry `mprrecievelots.qty_allocated_units`
and JR24.

**Rollback:** frontend `www-html.bak-{dev,prod}-4910b46d*` (holds
e1a82e02). Backend on prod `git reset --hard 4d43bd4`. JR24 from
`~/WhC_GetMoMaterialProductReleaseDetails_SP.bak-S116-{DEV,PROD}.txt`,
2390 bytes each — SHOW CREATE text, needs the DELIMITER wrapper.

**Clients:** 471 Glutenull (2 MOs, round ratios) · 469 Hagensborg
(13 MOs, none run, batch_qty 1 — can never demonstrate a quantity fix).
Neither has ever created a dispatch order or released an intermediate.

**Housekeeping measured at close:** dist folders three generations on
dev, www-html.bak three on prod — P178's limit, nothing to prune.
`/tmp/*.py` clear on dev.

**Not measured this session:** OS updates on either box.
⚠ Both boxes report **"System restart required"** at login. Dev also
reports 12 updates pending.

---

## PENDING PROMOTION

Nothing. Backend, frontend and database are all level across both boxes.

---

## THE NEXT JOB — S118

**P102 — reboot both boxes.**

Pending since S35. Two live clients, 23+ days, security updates waiting.
pm2 units enabled on both, untested through a reboot.

**WHY IT MATTERS, IN PLAIN WORDS.** A security patch replaces the file on
disk but the running kernel and libraries keep using the old copy. Until
the box restarts, the fix is downloaded and not in force. Pending since
S35 on an internet-facing box holding two clients' data.

**WHY IT KEEPS BEING DEFERRED, AND IT IS A GOOD REASON.** The reboot is
the moment we find out whether the app comes back by itself. pm2 is
recorded as enabled on both boxes and **never tested through a reboot**.
If it does not resurrect, prod is down until someone SSHs in.

**⚠ AND THE USUAL SAFETY NET DOES NOT APPLY.** 3B records the hosts as
DIFFERENT — prod 26.04, dev 24.04, two major releases apart. A clean
reboot on dev proves little about prod. That fact is from S79 and has
never been re-read. **Measure it before relying on either reading.**

```
ACTION

1  HOST CHECK, BOTH BOXES, and compare:
     cat /etc/os-release | head -4      ⚠ the FILE, not the banner
     uname -r
     node -v
     systemctl is-enabled pm2-ubuntu 2>/dev/null || echo "NOT enabled"
   ⚠ Read node -v against P180 while here — 3B says v18.20.8 and the
     queue says Node 20 deprecated. One of them is wrong.

2  STATE THE REHEARSAL VERDICT OUT LOUD before touching anything.
   If the hosts differ, dev is NOT a rehearsal and "dev worked" is not
   evidence for prod.

3  PIN THE RESURRECT PATH on each box:  pm2 save, then confirm
   pm2 startup is installed. ⚠ pm2 save AFTER confirming the named
   process is the one running — saving a bad process list persists it.

4  DEV FIRST, STANDALONE. sudo reboot. Wait. SSH back.
   Verify: pm2 status shows abletrace-dev online WITHOUT being started
   by hand · sleep 8 · curl 200 · a screen loads.

5  ONLY IF DEV RESURRECTED CLEANLY: PROD, STANDALONE.
   ⚠ Tell the clients' working day apart from ours — prefer a quiet
     window. Prod is 15.157.38.101, red prompt, two live clients.
   Verify: abletrace-backend online unstarted · curl 200 ·
   Glutenull's own login loads and MO-0001 still reads 1750# (560 Kg).

MATERIAL
  3B.5 HOST CHECK · 3B.2 THE BOXES (pm2 names, prompt colours)
  Rollback if pm2 does not resurrect: ssh in, pm2 start the named
  process from its ecosystem file or cwd, then diagnose. NOT a code
  rollback — nothing about the app changed.

VERIFY
  Both boxes: named process online after reboot WITHOUT manual start,
  200 on localhost:1337, and one client screen read on prod.
  ⚠ NOTHING IS DONE UNTIL IT IS SEEN ON THE SCREEN.
```

⚠ **A REBOOT IS ITS OWN STEP.** Never mid-work, never at the end of a
long session, never both boxes at once.

⚠ **IF DEV DOES NOT COME BACK CLEANLY, STOP.** Do not reboot prod to see
whether it behaves differently. Fix dev first — that is the whole value
of doing dev first, and it survives the hosts being different.

**While 3B is open for step 1, it gets its pass** — no separate job:
- Re-measure the stale facts. Rollback points still read S91 values;
  Node is recorded v18.20.8 on both boxes while **P180** says Node 20
  deprecated; the OS split is S79 and unverified since.
- Strip incident language. Session numbers, "cost 40 minutes in S71",
  "old Section A said X" — the facts survive without the stories.
- Delete the build-history header and the ROUTING RECORD. Both describe
  a 2026 reorganisation and say nothing about the system.

---

## QUEUE — Minty ranks. New items at the bottom, never renumbered.

**Top candidates**

- **P102** Reboot both boxes. → THE NEXT JOB, above.
- **Return path** — P163, **P164 (inverted sign, live on both clients)**,
  P165, P168, rows 20/42/43. Budget as a survey; never read end to end.
  ⚠ `PackingSlips.js:267` and `:419` subtract `currentToDate - returnQty`
  with **no floor** — the same negative-balance exposure Minty ruled
  against in S116, on the return path. Measured S117.
- **P111** QuickBooks. Precondition met — the units write path is closed
  and promoted. One planning session, no code. Needs a new column
  (TRAPS 3).

**Units campaign leftovers** — board 38 green of 51, a deliberate stop.
⚠ The Bible is **frozen as an archive at S117**. It describes the app as
of the campaign's close and is consulted per row, not read at the open.

- **Rows 37-41** unblocked; the column is populated. Row 41 is cheapest
  and most visible — release details shows Kg with no unit count.
  ⚠ All history still reads 0 (the JR20/P170 trade); sooner is cheaper.
- **P196** two intermediate blocks disagree by 0.011 Kg (0.004 on the
  IP4 fixture). Display only. Re-seen S117 on MO-0016 and MO-0017.
- **P135** two divisions left in `Trace_ProductHeaderView`. Retires TRAPS 10.
- **P198** `formulations.inventory` (the Kg line) carries float tails.
  ⚠ Measured S117: the Kg line has **no floor and no rounding** — only
  `inventory_units` gets `Math.round` and `Math.max(0,…)`. Low.

**Open, unranked**

P8 prod frontend checkout lags · P17 two old IAM keys live · P20/P22
delete old section files · P64 product label prints "null" · P65
promote.sh no -4 · P66 stale rollback points · P84/P85 printer guides ·
P86 cold boot untested · P88 dead "Fix A" pointers · P90 two false claims
in 3A · P94 stray heal file on prod · P101/P109 dormant archive holds its
own procedures · P106 old map file · P108 review J-entries · P114 closed
vs in-progress MOs · **P115 delete dead code** (below) · P116/P117
file-read handling · P118 comment deliberate code *(working — keep)* ·
P119 db definitions stale on ten objects · P120 material barcode ·
P121-P123 client guide gaps · P124 SO status compares units to Kg,
**live** · P129 food safety toggle has no attribute · P130 Excel exports
unchecked · P131 unit count with weight label · P132 dead status columns ·
P133 do_status never advances · P134 schema naming · P136 view returns
duplicates · P137 MR numbering global · P138 soproducts has no unit count
⚠ **and no company_id — scope any heal through SO_id → somanagement
(measured S117)** · P139 not defects · P142 MR buttons commented out ·
P145/P146 MR screen quirks · P148 narrow residual · P152 read-rows drops
columns · P153 .bak in api/models · P154/P176 deploy procedure not
written down · P155 Mac push and prod origin · P156 company-id namespaces
differ · P158/P159 IP trace procedures divide · P166 field named ship_qty
holds Kg · P167 seven-copy helper · P169 transposed labels · P170
pre-JR15 MR rows read low · P171 unmapped quantity tables · P172 receipt
code not unique · P173 nameless 0.000 row · P174 form control written
into batches · P175 gate that cannot fail · P178 retention rule *(run
S117, both boxes at three generations)* · P179 `formulations_myCodee`
typo · P180 Node 20 deprecated ⚠ **3B still records v18.20.8 — one of
them is wrong** · P182 undocumented controls · P185 eval() on release
screen, five sites · P189 possible double-count · P190 VARCHAR
subtraction · P191 lot scanner undocumented · P192 final_qty from
`batches` (fires only on duplicate rows) · P194/P195 Kg displays, correct
under the S116 ruling

- **P200** Negative quantity accepted on the add-sales-order screen.
  `add-sales-order.component.html:84` has no `min`; `.ts:245` and `:249`
  have no `Validators.min(0)`. A negative unit count multiplies cleanly
  through `:256` and banks a negative Kg plan at `soproducts.quantity`.
  Fix both. Frontend — needs a build and deploy.
  ⚠ Check the sibling quantity-entry screens before calling it done.
- **P201** Acrobatics at `add-sales-order.component.ts:393`.
  `(quantity / batch_qty) × (batch_qty / wgt_kgs_per_unit)` — batch_qty
  cancels, so it divides a weight to make a unit count. Assigns
  `shippingUnit`, not `quantity`. ⚠ **Not the cause of P199.**
  ⚠ Reachability unmeasured — confirm what calls it before fixing.

**P115 dead code:** `rejected-materials.ts:152-154` · `MLOManagement.js`
getMLCbyId/V2 · `PopUps/add-dispatch` v1 · `edit-mlc.ts:311,227` ·
`MaterialsProductsReleased.js:52` and `:83-98` (the dead release twin) ·
`material-traceability-details.html:113-125, 191-216` · `Traceability.js`
@returnedQty/@mprIDs

---

## CLOSED — delete these lines at the next close

**P199** (negative SO plan figure — diagnosed S117, operator input, not a
defect; the screen gap it exposed is P200) · P184 · P188 · P197 · P187 ·
P186 · P181 · P177 · P183 · P160 · P162 · P151 · P157 · P147 · P161 ·
P104 · P150

---

## SETTLED DECISIONS — do not re-open

- **A session opens on RULES and NOW only.** Everything else on demand.
  No dedicated documents session — a file is cleaned when next opened.
  *(Minty, S117)*
- **Release input stays kilograms.** The unit count is derived once at
  the write, rounded to three decimals, and the same figure is banked in
  the row and subtracted from stock. *(Minty, S116)*
- **~0.001 variance on a multi-release lot is accepted.** SOH is
  reconciled against physical count monthly. The cumulative fix was
  offered and rejected on domain grounds — do not re-derive it.
  *(Minty, S116)*
- **Stock must never go negative.** `Math.max(0,…)` on both branches.
- **Return path goes last.** *(Minty, S112)*
- **Materials are Kg only; anything carrying a formula_id carries
  units.** *(Minty, S112 — Bible Part 1 §5)*
- **Traceability reports what was released at the time.** *(Minty, S112)*

---

## ONE CORRECTION TO CARRY

Bible PART 4 records the IP4 lot ratio as `0.04478498…`. The true figure
is `41 ÷ 915.53 = 0.0447828…`. It changed no result — 1.957 either way —
but it is wrong where a future session would copy it.
