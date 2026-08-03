# PLAN

Written at close of: S99 · for S100.
Disposable. Rewritten whole at every close.

⚠ RANKING IS MINTY'S, SET AT THE S99 CLOSE:
  JOB B first, then FIX 7, then P82c. Fix 6 needs backend work and
  is bigger than it looked — it is NOT in this session.

⚠ EVERY PATH BELOW WAS VERIFIED IN S99 WITH `find` + `grep`.
  DO NOT RE-LOCATE THEM. Paths in older documents are stale.

---

## FIRST TWO ACTIONS

```
1  Health check both boxes. RULES → OPEN.
   EXPECT  dev  backend 2ae869c · frontend checkout c2a52d8e · clean
           prod backend 2ae869c · frontend checkout 9bce0238 · clean
           both 200
   ⚠ BACKENDS NOW MATCH. That is S99's promotion.
   ⚠ ON DEV, IGNORE THE SEVENTH LINE. The newest backup dir is
     named www-html.bak-dev-34e99c3e7a53 but dev was ROLLED BACK
     from it and is serving 770d3c4f's code. The name lies. It
     self-corrects on the next clean promote — which is JOB B.

2  Start JOB B. It is ranked first and it is the only job here
   that touches the live client.
```

---

## JOB B · PROMOTE FIVE FRONTEND FIXES TO PROD

⚠ RANKED FIRST. The gap has grown two sessions running.

```
WHAT THIS IS, IN PLAIN WORDS
  Five display fixes are proven on dev and have never reached
  Glutenull. Each one changes HOW a number is worked out, not what
  the number is: the screen used to divide a weight to rediscover
  a unit count the app already stores. Same answer, correct route,
  and no ugly decimals on awkward weights.

ACTION
  1  GitHub → Actions → build-frontend.yml → Run workflow →
     target = prod.
     ⚠ A PUSH ONLY BUILDS DEV. Prod needs this manual dispatch.
  2  CLEAR ~/Downloads of old dist zips FIRST.
     rm -f ~/Downloads/dist-prod-*.zip
     ⚠ The browser cannot overwrite; it appends (1) and (2), which
       makes the plain filename the OLDEST copy. RULES/CLOSE.
  3  Download the dist-prod-<40-char-sha> artifact.
  4  ls -lt ~/Downloads/dist-prod-*.zip   — confirm ONE file,
     and that the sha matches the artifact page.
  5  On the MAC:  ~/promote.sh <that zip> prod
     ⚠ It will require typing 'yes'.
  6  READ THE ROLLBACK PATH OFF THE SCREEN. Do not write it from
     the build label.
  7  Cmd+Q the browser before looking.

MATERIAL
  Nothing to paste. Build from main HEAD 2e22e0a1.
  ⚠ The revert sitting on top is a NO-OP. The code equals
    770d3c4f. Building from main is correct and safe.

ANALYSIS — DONE, DO NOT REDERIVE
  THE FIVE COMMITS
    a52e4bfc  Products list stock on hand
    b8e7248b  Add-MLO warehouse stock
    824e0e6d  Closed MOs planned/completed qty + Excel export
    9b9cf05d  Closed-SOs status dot                    (S99)
    770d3c4f  P82 fix 5, Edit Closed MO received figure (S99)

  ⚠ NO CLIENT SYMPTOM ON ANY OF THEM. Measured on prod S98:
    formulations.inventory and inventory_units AGREE on all 27
    Glutenull products (FO-0019 560 Kg / 1750 units at 0.32;
    FO-0022 192.48 / 802 at 0.24; the other 25 are zero).
  ⚠ SO THE VERIFICATION IS NOT "the number is right" — it already
    is. WHAT MUST BE CHECKED IS THAT NOTHING BLANKS.

VERIFY on prod, as Glutenull — EVERY LINE, NOT A SAMPLE
  Products list      FO-0019 must read 1750# (560 Kg)
                     FO-0022 must read 802# (192.48 Kg)
                     ⚠ If either reads 0, inventory_units is not
                       reaching that screen. ROLL BACK.
  Closed MOs         Planned and Completed both units-first.
                     ⚠ Compare one MO against MLO-Management for
                       the same product — they must agree.
  Closed SOs         ⚠ Glutenull has NO SALES ORDERS, so this
                     screen will be EMPTY. That is expected and it
                     is not a failure. Say so out loud.
  Edit Closed MO     open one of Glutenull's two MOs and confirm
                     the WDU line shows a unit count and a Kg
                     figure, neither blank.
  Add-MLO            only if Glutenull has a product with an
                     intermediate. If not, this screen cannot be
                     checked on prod and that is fine — say so.
  ▶ Rollback: the path printed by promote.sh, read off the box.
```

---

## FIX 7 · PRODUCT TRACEABILITY  (P82)

⚠ RANKED SECOND. ⚠ FRONTEND — edit on the MAC.

```
WHAT THIS IS, IN PLAIN WORDS
  Two lines rebuild a produced-unit count by dividing the weight
  received by the weight of one unit. The app already stores that
  unit count. Same fault as fix 5 and fix 6.

⚠ DO THE GATE BEFORE THE PATCH. FIX 6 FAILED FOR EXACTLY THIS
  REASON AND HAD TO BE REVERTED.

  THE GATE: prove received_units actually REACHES this component.
  A column existing in the database does NOT mean every screen
  receives it. Fix 5's screen gets it; /Edit-Mlc does not.
  ▶ HOW: grep the backend route that serves /Product-Traceability
    and confirm received_units is returned. If it is served by a
    STORED PROC, the proc must SELECT it explicitly.
  ▶ WHAT DISTINGUISHES: if the column is not in the returned
    object, the frontend patch will render 0 and this becomes a
    backend job. STOP AND SAY SO rather than patching.

FILE  app/Layouts/admin-dashboard/traceability/
      product-traceability/product-traceability.component.ts
      lines 109 AND 161
NOW   wduRec = Math.round((item.received_qty / ...wgt_kgs_per_unit)...)
FIX   read received_units.
⚠ LINES 107 AND 159 ARE CORRECT and sit two lines away — they
  MULTIPLY item.qty to derive Kg. DO NOT TOUCH THEM.

VERIFY
  ⚠ NAME THE ROUTE: /Product-Traceability, then a product, then
    its details. S95 asked for "product traceability" and got a
    different screen.
  ⚠ USE test1.39 (1.39 Kg/unit). NEVER a 1:1 product — a ratio of
    1 makes the division invisible.
  ⚠ TAKE A BEFORE-READING. Note what the field shows BEFORE the
    promote. Without it, an after-reading proves nothing. This is
    the S99 lesson and it cost an hour.
```

---

## P82c · THE MISC RELEASE UNITS COLUMN

⚠ RANKED THIRD. ⚠ MUCH SMALLER THAN THE OLD RECORD SAYS.

```
WHAT THIS IS, IN PLAIN WORDS
  When stock is released for miscellaneous reasons, the app stores
  the weight but not the unit count. The column does not exist.
  Adding it is a precondition for fixing stock on hand later.

ACTION
  1  ALTER TABLE rejectmaterialandproduct ADD COLUMN <units> double
     DEFAULT 0;
     ⚠ ON EACH BOX SEPARATELY, against `abletracelab_live`.
       There is NO promote path for a schema change.
  2  Declare it in RejectMaterialAndProduct.js attributes.
     ⚠ WITHOUT THIS THE WRITE VANISHES SILENTLY. TRAPS 3.
       This is not theoretical — received_units banked 0 silently
       until it was declared, and food_safety_enabled still does.
  3  Change the write path so the unit count is captured.
  4  Back the column up and log it in Section 5's JR block IN THE
     SAME BREATH. JR is the only record these exist.

MATERIAL
  Section 5 — the JR block. NOT OPTIONAL, the job writes to it.
  ⚠ ASK MINTY FOR IT BY NAME AT SESSION OPEN.
  TRAPS entry 3.

ANALYSIS — DONE, DO NOT REDERIVE
  ⚠ NO BACKFILL IS NEEDED. Measured on prod S98:
      SELECT company_id, COUNT(*) FROM rejectmaterialandproduct
      GROUP BY company_id;  →  464 only, 4 rows. GLUTENULL ZERO.
    There is no live client data to heal. That was the risky half
    of this job and it is gone.
  ⚠ ADDING THE COLUMN DOES NOT FIX SOH. SOH is computed by
    Trace_ProductHeaderView, and that is P82a. This column is a
    PRECONDITION, not the fix.
  ⚠ Dev's four rows in 464 are the test fixture for the write path.

VERIFY
  Make a misc release on dev, then read the row. The unit count
  must be stored, not zero. ⚠ Read the ROW, not the toast.
```

---

## NOT IN THIS SESSION

```
FIX 6  ⚠ BIGGER THAN IT LOOKED. The frontend line is correct; the
       BACKEND ROUTE serving /Edit-Mlc does not return
       received_units. Needs a backend change first, then the
       frontend line, then a before-and-after on the same screen.
       ▶ The reverted patch is in history at 34e99c3e. Read it
         rather than rewriting it.
       ⚠ /Edit-Mlc and /Edit-MLO ARE DIFFERENT SCREENS with nearly
         the same name, both showing MO details. This tangled S99
         badly. Name the URL every time.

P82a   Trace_ProductHeaderView repoint. ⚠ THE VIEW HAS NOT BEEN
       READ. Needs SHOW CREATE VIEW on BOTH boxes first.
       ⚠ TRAPS 10 protects this job and retires when it lands.
P82b   SOH. Blocked behind P82a and P82c.
P82e   Trace_ProductProdLotView selects mm.qty twice. Not read.
P82f   received_qty stores float garbage. ⚠ CONFIRMED BY ROW in
       S99 — MO-0009 holds 15.290000000000001. Still unfixed.
P82g   /Dispatch-orders shows 0# on shipped DOs. ⚠ THE TEMPLATE
       IS CORRECT — proven with cat -A in S97. ▶ Needs a ROW read
       on packingslips / packingslipdos, NOT another code read.
P102   THE REBOOT. Its own sitting. ⚠ VERIFY PM2 STARTS ON BOOT
       FIRST, and remember prod runs a different OS so dev does
       not rehearse it. ⚠ MISSED FOUR DAYS RUNNING NOW.
P108   Retire the J-entries. ⚠ KEEP JR. Own sitting, with Minty.
P111   QUICKBOOKS. Planning only, no code.
P131/132/133/134  New in S99. Not yet ranked.
```

---

## OPEN QUESTIONS CARRIED FORWARD

```
✓ CLOSED: the dev restart-count question. ↺ held at 129 all day
  in S99 with two deploys and a rollback. Not investigated
  further, and no longer needs to be.

⚠ /Edit-Mlc showed 0# for Completed Quantity under fix 6 and 51#
  without it. The frontend patch causes it. But WHY that component
  lacks received_units — plain Waterline find vs stored proc — was
  never established. One grep of its backend route settles it and
  it is the first step of the fix 6 rework.
```

---

## THE LESSONS S99 EARNED

⚠ Kept here deliberately rather than added to RULES. If they
  recur, Claude proposes a rule; the default is still NO.

```
1  A STORED COLUMN IS NOT AVAILABLE TO EVERY SCREEN.
   Fix 5 worked and fix 6 failed on the SAME column, because the
   two components load by different routes. Prove the column
   reaches the component BEFORE patching the display.

2  AN AFTER-READING WITHOUT A BEFORE-READING PROVES NOTHING.
   Claude called a 0 a regression having never seen the field
   before the patch. It happened to be right, but only the second
   check established that.

3  TWO SCREENS WITH NEARLY THE SAME NAME WILL BE CONFUSED.
   /Edit-Mlc and /Edit-MLO. /Closed-SO and /SO-Management.
   Name the URL, not the description.

4  CHECK THE PROMPT COLOUR. A frontend patch ran on DEV in S99
   and had to be undone and redone on the MAC. RULES section 2
   already says this. It was not followed.
```

---

## PASTE LIST

```
RULES.md · NOW.md · TRAPS.md · PLAN.md
PLUS Section 5's JR block — ONLY IF P82c IS SCHEDULED.
NOTHING ELSE.
```
