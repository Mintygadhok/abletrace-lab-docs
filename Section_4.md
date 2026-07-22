# SECTION 4 — LOOK & FEEL

> The visual and interaction language for the whole app. Read before any UI/UX work.
>
> **⚠ THIS SECTION HOLDS VISUAL AND INTERACTION LANGUAGE ONLY** (rule 9D). Two things routinely leak in and must be moved out on sight:
> - a **DB change** that happens to touch a screen → belongs in Section 5 or its module in 3A
> - a **work-queue item** (a label to rename, a fix to make) → belongs in Section 1
>
> ⚠ THE TEST: if an entry describes an **action to take** or a **stored-data change** rather than how something **looks or behaves**, it is in the wrong section.
>
> Locked S36. Built and verified across the app (template = Manage Companies). Folded from old Section I, S79 — four misfiled blocks removed, all duplicated elsewhere.

---

## ⚠ WHAT WAS REMOVED AT FOLD TIME (S79) — nothing was lost

```
I-S50   a stored-proc DROP+CREATE with backup paths. No visual content.
        → lives at J23 · JR7c · 3A.6

I-S51   the "closed vs completed" domain clarification.
        → lives in §2 Dated Domain Rules · JT6

I-S55   the nested-pop read-path rule. ⚠ The entry ADMITTED it was
        misfiled: "only if you keep arch decisions here; otherwise
        these can live in B."
        → lives at §0 rule 2.8 · JT8 (food-safety-critical)

I-S64   a work queue: delete an old S3 key, review RDS public access.
        → the key was deleted S65. ⚠ THE RDS REVIEW WAS IN NOBODY'S
          QUEUE and is now P32.
```

---

## CORE PRINCIPLE — TWO INDEPENDENT LAYERS

```
COLOUR = CONSEQUENCE    what happens if I act on this?
                        rust / red / blue / grey-ghost

GREY = LOCATION         where am I, what is in focus?
(future)                one light grey

They never compete because they answer DIFFERENT QUESTIONS. Colour
answers "what does it do"; grey answers "where are you".

⚠ THE GREY LAYER IS PARKED. Tested S36 on Manage Companies (region
wash + row hover + selected row) and REVERTED — it read muddy and
added little over the colour and layout work. The TWO-LAYER PRINCIPLE
stands as the long-term model. Revisit only if it earns its place,
and only during or after the shell restructure.
```

### ⚠ THE SECOND PRINCIPLE — GLOBAL CHANGE WITH EXCEPTIONS

```
The colour system is maintained by setting a value GLOBALLY and carving
out NAMED EXCEPTIONS — never by editing screen after screen.

MECHANICS: grep a colour across all files to confirm how it is used,
then sed it everywhere at once, SPLITTING BY PROPERTY where one hex
serves two purposes.

⚠ This is how two retired colours were unified across ~64 files in a
single session. Any future colour change follows the same discipline:
global rule first, per-screen only for a true one-off.
```

---

## COLOUR = CONSEQUENCE — the button system ✅ DONE APP-WIDE

```
⚠ THE RULE IS DEFAULT + EXCEPTIONS. Do NOT colour each button type
  one by one — that is what created the mess this replaced.

DEFAULT       every button is RUST #E0712F.
              ⚠ Any NEW button is rust unless explicitly named an
              exception below. The system maintains itself.

EXCEPTION     DESTRUCTIVE = RED #E24B4A. Reserved.
              Delete · Cancel DO/PS · Remove. ⚠ Nothing else is red.

EXCEPTION     EDIT = BLUE #378ADD. Single purpose.
              Modify-an-EXISTING-record ONLY.
              ⚠ This is a NEW blue. The OLD app-blue #176ba9 was
              RETIRED and must STAY retired. Same for cadetblue.
              Do not let either creep back anywhere.

EXCEPTION     BACK / CANCEL / CLOSE = GREY GHOST.
              Outline, no fill. The absence of colour.
```

```
RUST COVERS ALL COMMIT ACTIONS
  Create · Save · Submit · Confirm · Add · Activate · Inactivate ·
  Renew · Release · Ship · Send Invite · Print · Upload · Download ·
  Excel · Bulk Activate
```

### ⚠ GREEN IS NOT A BUTTON COLOUR

```
GREEN #639922 is SUCCESS FEEDBACK and SELECTION only.

  · the "Saved" / "Activated" toast — the RESULT, after acting.
    ⚠ THE BUTTON SAYS "SAVE" AND IS RUST. THE MESSAGE THAT COMES BACK
      SAYS "SAVED" AND IS GREEN. Action = rust. Outcome = green.
  · the checkbox selection tick (selected / affirmed = green)

Error feedback = red, matching destructive.
```

### NEUTRAL GREY — affordance hints, not actions

```
Search magnifying-glass icons and "Details →" row arrows =
neutral grey #5f5e5a.

⚠ They point the way but are not consequences, so they stay quiet.
```

### STATUS COLOURS — badges and dots, never buttons

```
green   in-date / active
amber   #EF9F27  expired / warning / pending
red     no-cert / critical
grey    inactive / neutral

LICENCE BANNER STATES
  ok       green tint
  TRIAL    AMBER tint (#fdf3e3 background / #9a6212 text)
           ⚠ trial is "pending", not blue
  expired  red tint

⚠ CERT-STATUS COLOUR LOGIC IS BROKEN AND IS NOW TRACKED. The indicator
  shows RED REGARDLESS OF STATE. It should be state-driven:
  red = no cert · amber = expired · green = in-date.
  → P33. This is FUNCTIONAL, not a swatch — a permanently-red
  indicator on a food-safety system either trains people to ignore it
  or hides a real expiry.
```

### NAV TILES AND LEFT RAIL — the neutral / location family ✅ DONE

```
NAV TILES       home-screen module sub-function cards.
                light grey fill #f4f2ec + 1.5px grey border #5f5e5a +
                dark text #2c2c2a. Hover darkens slightly.
                ⚠ Defined cards, not floating. NO COLOUR — they are
                navigation, not consequence.

LEFT RAIL       same light-grey-fill boxes, so rail and tiles read as
                ONE FAMILY.
                SELECTED item = darker fill #e6e2d6 + RUST left-bar
                #E0712F + dark readable text + rounded corners.

⚠ THE RAIL IS DATA-DRIVEN, NOT HARDCODED. Items render from the user's
  roles. Adding a role makes a new rail box appear automatically with
  the styling above — no per-component work. → §2 Logic E · 3A.8
```

### ⚠ HISTORICAL FINDING — COLOUR HID IN FIVE MECHANISMS AT ONCE

```
⚠ RETAINED AS A CAUTION, NOT A TODO. All five are unified.

At the start of the overhaul the app's colour came from FIVE separate
sources:
  (a) Material raised buttons (primary/accent/warn)
  (b) Material checkboxes (green tick, grey border, pink halo)
  (c) hardcoded `cadetblue` across ~35 component files
  (d) per-component blue tiles (#176ba9 backgrounds)
  (e) the rail "selected" highlight

⚠ THE LESSON: A SINGLE MATERIAL OVERRIDE DOES NOT RECOLOUR THE APP.
  Colour can hide in keyword colours, per-component hex, and theme
  bleed simultaneously. "Default rust + exceptions" plus global
  find-replace is what caught all of them.
```

---

## FIELD EMPHASIS — forms, moves with the cursor ⚠ PENDING

```
ACTIVE FIELD        cursor here = RUST ring / underline; inside stays
                    normal. ⚠ NOT blue — Material's default blue focus
                    underline must be killed. It is still present.
REQUIRED BUT EMPTY  faint NEUTRAL tint inside. Not blue.
OPTIONAL            recedes.
ACTIVE + REQUIRED   rust ring AND faint fill — edge versus inside,
                    no collision.

⚠ MATERIAL MDC FIELD/FOCUS CSS IS THE FIDDLY PART. Expect selector
  iteration. Pure CSS, so it cannot break logic — it just needs
  build-check-adjust on two or three forms.
```

---

## ICONS, LABELS, BUTTON POSITION — the "stop the hotchpotch" rules ⚠ PENDING ROLLOUT

```
EVERY BUTTON = ICON + TEXT, side by side. Icon left, text right.
  ⚠ Icon-ONLY is allowed only for the universally obvious: close (×),
    search. Everything else gets a label — Download, Upload, Print,
    Edit, Save, Delete, Add, Back.

SIDE-BY-SIDE    all row / footer / toolbar buttons (wide shape)
STACKED         icon on top, label below — ONLY for big square
                navigation tiles

POSITION GRAMMAR — fixed, never varies
  top-left          Back / where-am-I
  top-right         Add New / primary page action
  top bar           Search, Filter
  row right-edge    View · Edit · Delete  ⚠ fixed order, Delete LAST
  form footer       bottom-right: [Cancel] [Primary]

EQUAL-WIDTH buttons in a group. No ragged auto-width — colour
differentiates, size stays uniform.
```

```
FIRST CONCRETE APPLICATION (the reference pattern to copy):
the MO sheet and Product-Traceability details both show
  [download icon] Download   [print icon] Print
side by side, icon-left, text-right, both RUST — Download and Print
are listed rust commit actions and no exception applies.
```

---

## PAGE SHELL ⚠ TARGET MODEL, NOT BUILT

```
⚠ THE BIG STRUCTURAL MILESTONE. Deliberately sequenced AFTER
  surface/colour because it changes LAYOUT, not just style.

TOP STRIP       fixed. Logo + company/account + user menu/logout.
                Never changes.
LEFT RAIL       fixed. All modules; one lit, others recede.
                ⚠ Rail is already boxed, styled and data-driven. The
                restructure makes it PERMANENT and ALWAYS-VISIBLE.
SUB-ELEMENT     contextual. The selected module's sub-functions as
TILES           tiles below the top strip; they swap on module switch.
                Grey fill, grey border, dark text, icon-on-top,
                hover-lift. Distinct from buttons by size and shape,
                same grey family.
                ⚠ FOOD SAFETY IS THE LIVE EXAMPLE — one rail module
                  whose two sub-functions (Procedures + HACCP) are the
                  contextual tiles. Use it as the prototype reference.
CONTENT AREA    page header (title LEFT, primary action right, Back if
                sub-page) → toolbar (search/filter) → table/form →
                footer ([Cancel][Save] bottom-right).
LOGIN           auto-select the first module. No blank screen.

⚠ OPEN QUESTION, decide on a prototype: inside a sub-screen, do the
  sub-tiles shrink to a compact row and stay, or collapse away for
  full content room?
```

---

## PRINT AND EXPORT — ⚠ ITS OWN SURFACE, DELIBERATELY DIFFERENT

```
⚠ READ THIS BEFORE "FIXING" ANY DOCUMENT TO MATCH THE APP.

A generated PDF or workbook is a DOCUMENT SURFACE, NOT A SCREEN, and
is deliberately NOT bound to the app's screen colour system.

⚠ DO NOT "RUST-IFY" A PRINTED DOCUMENT TO MATCH THE UI. A printed
  work-order or audit sheet wants neutral, high-contrast,
  ink-economical styling — not screen-brand colour. The document is
  allowed its own restrained language, exactly as the public landing
  page is allowed its own font.
```

### The shared PDF document language

```
HEADER          AbleTrace logo band + tagline, repeated per page
SECTION BARS    light grey fill, dark text, bold. Quiet and
                print-legible. ⚠ NOT the rust/green action palette.
TABLE GRID      hairline light-grey borders, 8.5pt body, header row in
                muted grey. Two-line cells preserved as stacked lines.
EMPTY SECTIONS  "No records" / "No data found" in italic muted grey
FOOTER          document title + Page X of Y

⚠ ANY FUTURE PRINTABLE SURFACE (packing slip, DO, SO, label sheets)
  REUSES THE SHARED SERVICE AND INHERITS THIS LANGUAGE — never the
  screen tokens.
```

### ⚠ THE TWO DOCUMENT FAMILIES LOOK DIFFERENT ON PURPOSE

```
Someone WILL eventually see these side by side and try to make them
match. They must not.

PROCEDURES PDF        BLACK ON WHITE. Document-neutral: black/grey
                      text, white header fills, light-grey borders,
                      logo band.
                      ⚠ WHY: a printed REGULATORY document reads as
                      formal black-on-white, distinct from the live UI.
                      Section headers inside the body are differentiated
                      by WEIGHT (bold) and WHITESPACE (a spacer row),
                      never by colour.

HACCP EXCEL           BLUE BRANDED. Keeps Mintek blue #1F4E79 header
                      rows and light-blue #EBF3FB info fills.
                      ⚠ WHY: it is a branded WORKBOOK, not a regulatory
                      printout. It is deliberately not all-black.

⚠ THE ALL-BLACK RULE IS PROCEDURES-ONLY. This is not an inconsistency
  to fix.
```

### The document cover principle

```
A cover's job is to establish OWNER + DOCUMENT TYPE + BRAND at a glance.

  · a real embedded LOGO image as the visual anchor, not text-only
  · ⚠ THE CLIENT COMPANY NAME AS THE LARGEST ELEMENT — the document
    belongs to the client, not to us
  · a divider rule separating the header band from the info grid
  · generous row heights and vertical balance

⚠ EARNED THE HARD WAY: the prior bare top-left grid read as "weak".
  Breathing room plus the logo fixed it. Name big, logo present,
  metadata secondary.
```

### exceljs image embedding — reusable technique

```
const id = workbook.addImage({ base64: '<bare-base64>', extension: 'png' });
ws.addImage(id, { tl: { col, row }, ext: { width, height } });

⚠ The base64 must be the BARE string — no "data:image/png;base64,"
  prefix.
⚠ Anchor with a fractional tl (e.g. row 0.35) and give the anchor row
  enough HEIGHT or the image clips at the top.
```

---

## TYPOGRAPHY ✅ DONE

```
APP CHROME      ONE font: INTER.
                Loaded in index.html from Google Fonts, applied in
                styles.scss. Fallback chain 'Inter', Roboto, Arial.
                ⚠ This replaced a Roboto-vs-Segoe-UI conflict that
                caused "sharp here, dull there". The stray
                html{Segoe UI} line is GONE — keep it gone.

SCALE           body/table 14px · labels/secondary 13px ·
                page titles 20px · section headings 16px

WEIGHTS         TWO ONLY: 400 regular, 500–600 medium. No more.

⚠ THE ONE INTENTIONAL EXCEPTION — THE PUBLIC LANDING PAGE.
  The logged-out marketing page uses MONTSERRAT 800 for the hero
  heading (52px, tight tracking) and INTER for body (19px, #3a3a38,
  line-height 1.5). Both fonts load in index.html.
  ⚠ THE LANDING PAGE IS ALLOWED MORE TYPOGRAPHIC PERSONALITY THAN THE
    WORKING APP. THIS IS DELIBERATE, NOT DRIFT.
```

---

## COMPONENT SPECS — the ones with a canonical home

### MO PRODUCTION-STATUS INDICATOR ✅ BUILT

```
⚠ ONE SHARED COMPONENT, NOT A PER-SCREEN STYLE. Any future change to
  this visual happens THERE, once. This is the "global, not
  per-screen" discipline applied to a component instead of a
  stylesheet.

  <app-mo-progress-chart [mo]="row">   standalone Angular

THE VISUAL — two status CIRCLES + one buildup BAR
  Circle 1   grey outline → GREEN #639922 when material issued
  Circle 2   grey → GREEN when production started
             ⚠ BINARY. No partial fill.
  Bar 3      track #E8E6DF; fill ORANGE #EF9F27 while cumulative <
             planned; flips GREEN #639922 at ≥ 100%.

  DONE END-STATE = two green circles + a full green bar.

TOKENS        all already in the palette — no new colours. The bar's
              orange is the "pending/in-progress" status colour;
              green is success. Consistent with COLOUR = CONSEQUENCE.
COMPACT SPEC  8px circles, 24×6px bar, 5px gaps, inline-flex.
              Status-name text REMOVED from the component; screens
              show it separately if needed.

LIVE ON FIVE SURFACES, all identical: MLO-Management · Mfg-lot-codes ·
Production-Controller · Closed-MLCs · Stock-Info popup.

⚠ WHY A COMPONENT AND NOT A STYLESHEET RULE: the status value arrives
  in THREE SHAPES across screens — object(.id), bare number, and
  status_id. The component absorbs all three so one tag works
  everywhere. (JT1 · J22 · J27.)

⚠ TWO SURFACES DEFERRED, BLOCKED ON DATA NOT DESIGN: Product-
  Traceability and the Create-MO intermediate block. Their rows lack
  the units figure the bar needs. Unlocked by a backend change, then
  the same component drops in.
```

### HACCP SCORING-KEY LEGEND ✅ BUILT

```
A .haccp-scoring-key box above the Add-HACCP hazard grid.
Neutral grey fill #f4f2ec · hairline border #e0ddd4 · 6px radius ·
Inter 12.5px · flex-wrap row of keyed items. Title in rust bold.
⚠ Matches the standard grey-box / hairline pattern.
```

### CLIENT GUIDES + BRANDED GUIDE PDF ✅ BUILT

```
THE PAGE      rust title · grey subtitle · list of guide rows (name +
              one-line description + rust "Download PDF" button) ·
              confidential subline. Palette matches app tokens.

THE PDF       light header band with a two-ring logo mark (rust +
TEMPLATE      green interlocking circles) + "AbleTrace / Traceability
              Solutions" wordmark + "Client Help Guide" tag; rust rule
              under the module title; rust guide headings; numbered
              one-action steps; grey-italic notes.
              FOOTER: "Confidential — for authorized client use only"
              + page/module + copyright, "Not for redistribution."

TRAINING      milestone format — rust milestone name / green week /
GUIDE         bold Objective + optional detail. Five milestones.
              ⚠ No sign-off boxes, no checkboxes. Minty's call.
```

---

## ⚠ PENDING DESIGN WORK — STILL THE PLAN, NEVER ACTIONED

```
⚠ THIS LIST WAS WRITTEN AT S38 AND NOTHING ON IT HAS BEEN DONE — 41
  sessions. It said form-field emphasis was "NEXT". It was not.
  CONFIRMED S79: still the plan, not dead scope.

⚠ TWO ITEMS WERE PULLED OUT AND PUT IN THE QUEUE, because they are
  functional rather than cosmetic:
    · cert-status colour logic  → P33
    · (and from a misfiled note) RDS public access → P32

IN PRIORITY ORDER:
  1  GLOBAL FORM-FIELD EMPHASIS — rust focus ring, kill the Material
     blue underline, neutral required-tint. ⚠ The fiddly MDC one.
     A fresh-start candidate.
  2  ICON+TEXT AND POSITION GRAMMAR ROLLOUT. The two PDF surfaces are
     the reference pattern.
  3  PAGE-SHELL RESTRUCTURE — permanent module rail + contextual
     sub-parts. ⚠ The big structural move. The rail being data-driven
     de-risks it; Food Safety is the working reference.
  4  SCREEN-BY-SCREEN COMB — per-form layout and grouping, strip
     view-screen asterisks, status badges, status-as-badge/dot,
     catch one-offs.
  5  GREY FOCUS LAYER — ⚠ PARKED. Tested and reverted. Revisit only
     if it earns its place, post-shell.

⚠ WORK ORDER MATTERS: globals first, because each one improves every
  screen at once, so the final comb is a quick pass rather than a
  rebuild.
```

---

# APPENDIX — GLOBAL vs PAGE-SPECIFIC MAP

> ⚠ **Read this before ANY colour or font change.** It tells you whether a thing is set once (global) or per-screen, the exact file, and the safe command. This is what keeps refinement fast and prevents re-introducing the scatter that took a whole session to remove.

```
⚠ THE GOLDEN RULE OF THIS APP'S STYLING

Colour and font are set GLOBALLY wherever possible, with a SMALL
number of NAMED page-specific exceptions.

Before changing anything, ask: IS THIS GLOBAL OR PAGE-SPECIFIC?
⚠ NEVER patch one screen for something that should move everywhere.

ALWAYS: back the file up to /home/ubuntu/ first · edit via an
assert-anchored patch · build · verify on screen · commit.
```

## A. WHAT IS GLOBAL — set once, every screen inherits

```
1  FONT (app chrome) = INTER
   WHERE  src/index.html (the Google Fonts link) +
          src/styles.scss (the font-family rule)
   ⚠ TO CHANGE THE APP FONT: edit those two places only. Every screen
     follows. ⚠ DO NOT set font-family in a component .scss — that is
     exactly what caused the old Roboto/Segoe mess.

2  BUTTON COLOURS = "default rust + exceptions", set globally
   WHERE  src/styles.scss holds the Material button overrides
          (primary/accent → rust, warn → red) and the palette.

   ⚠ THE TWO RETIRED COLOURS were removed app-wide by GLOBAL
     FIND-REPLACE, not by editing screens. If either creeps back,
     kill it the same way:

       grep -rn "cadetblue" src --include="*.scss"
       grep -rl "cadetblue" src --include="*.scss" \
         | xargs sed -i 's/cadetblue/#E0712F/g'

   ⚠ FOR THE OLD BLUE, SPLIT BY PROPERTY — it meant two things:
       background: #176ba9  → rust #E0712F   (action buttons)
       color:      #176ba9  → grey #5f5e5a   (search icons, arrows)

3  THE PALETTE — the canonical hex values. ⚠ THE HEX VALUES ARE THE
   CONTRACT. If you change one, grep it and change every place it
   appears so the system stays coherent.
```

### THE PALETTE

```
RUST           #E0712F   default action / commit buttons
RED            #E24B4A   destructive ONLY (Delete, Cancel DO/PS, Remove)
BLUE           #378ADD   EDIT buttons only (modify existing record)
GREEN          #639922   success feedback + checkbox tick — NOT a button
AMBER          #EF9F27   status: expired / pending / warning
GREY (ghost)             back / cancel / close — outline, no fill
GREY           #5f5e5a   neutral affordance: search icons, detail
                         arrows, tile borders, selected text
GREY-FILL      #f4f2ec   nav tiles + rail item fill (location family)
SELECTED-FILL  #e6e2d6   selected rail item (with a rust left-bar)
TEXT           #2c2c2a   dark readable text

DOCUMENT SURFACES (print only — ⚠ NOT screen tokens)
MINTEK BLUE    #1F4E79   HACCP Excel header rows
LIGHT BLUE     #EBF3FB   HACCP Excel info fills
BAR TRACK      #E8E6DF   MO progress bar track
HAIRLINE       #e0ddd4   grey-box borders
```

## B. WHAT IS PAGE-SPECIFIC — lives in ONE component's .scss

```
⚠ These are INTENTIONAL local styles. They do NOT live in styles.scss.
  When refining one, edit ONLY that file — it affects only that screen.

1  NAV TILES        home-screen module sub-function cards
   FILE            admin-dashboard/home/home.component.scss
   CONTROLS        tile grey fill, 1.5px grey border, dark text,
                   hover-darken
   ⚠ Page-specific because the tile markup lives in this component.
     If tiles appear in another module's home, that module has its
     OWN home.component.scss.

2  LEFT RAIL        the module nav column
   FILE            admin-dashboard/admin-dashboard.component.scss
   CONTROLS        rail item boxes, and .active-menu = the SELECTED
                   item (darker fill + rust left-bar + readable text)
   ⚠ The STYLING is here, but WHICH ITEMS APPEAR is DATA-DRIVEN —
     adding or removing a rail module is a DATA change, not CSS.
   ⚠ ONE GLOBAL GOTCHA: a global `.active-menu span { color }` rule in
     styles.scss can override the rail's selected-text colour. If
     selected text ever looks wrong, CHECK BOTH FILES.

3  LICENCE BANNER   the "Trial — expires…" strip at the top of home
   FILE            admin-dashboard/home/home.component.scss
   CONTROLS        three state blocks: .licence-ok (green tint),
                   .licence-trial (AMBER tint), .licence-expired (red)

4  PUBLIC LANDING   the logged-out marketing site
   FILES           app/home/home.component.html + .scss
   ⚠ A SEPARATE AREA from the app chrome with its OWN font choice on
     purpose: hero = MONTSERRAT 800, body = INTER. Montserrat loads in
     index.html alongside Inter.
   ⚠ Changes here affect ONLY the landing page. Do not apply
     app-chrome rules here, and DO NOT LET LANDING-PAGE FONTS LEAK
     INTO THE APP.
```

## C. DECISION SHORTCUT — "I want to change a colour or font, where do I go?"

```
the font of the whole app       → styles.scss + index.html      GLOBAL
a button colour everywhere      → styles.scss, then grep/replace
                                  any hardcoded hex in components
a retired colour reappeared     → grep it, global-replace (see A2)
the nav tiles                   → home.component.scss            PAGE
the left rail / selected item   → admin-dashboard.component.scss PAGE
                                  ⚠ + check the global
                                    .active-menu span rule
                                  ⚠ WHICH items appear = data, not CSS
the trial / licence banner      → home.component.scss            PAGE
the landing page look or font   → app/home/                      PAGE
a printed document              → the shared PDF service.
                                  ⚠ DOCUMENT LANGUAGE, NOT SCREEN
                                    TOKENS
a new screen's buttons look off → they SHOULD inherit rust
                                  automatically. If one is wrong it is
                                  hardcoded in that component — grep
                                  for a stray hex and fix locally. If
                                  it is app-wide, fix the global rule.
```

```
⚠ WHY THIS MAP EXISTS — the lesson that produced it

The overhaul started with colour scattered across FIVE mechanisms, so
changing one changed nothing. The fix was to make colour GLOBAL with a
few NAMED page exceptions, listed above.

⚠ REFINEMENT STAYS FAST ONLY IF THAT DISCIPLINE HOLDS. Change globals
  globally; touch a component file only for the handful of genuinely
  page-specific things in section B.

⚠ IF YOU FIND YOURSELF EDITING THE SAME COLOUR IN MANY COMPONENT
  FILES — STOP. IT SHOULD BE GLOBAL.
```

---

**END SECTION 4**
