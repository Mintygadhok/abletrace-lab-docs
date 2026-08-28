# NOW

Rewritten whole at the close of S141.
Read RULES.md and this file. Nothing else at the open.

**S141 fixed P250.** The server now decides which company a request may touch. Written, tested, proven on screen, committed, pushed, and live on prod with its database prepared. **Done, both boxes.**

**S142 audits the old AWS account and disconnects it, one dependency at a time.** ⚠ **Minty's ruling S141: the audit comes FIRST, before the domain move, because Route 53 lives in the old account and the move stands on it.** Keep SES and Route 53 untouched. Everything else is checked and test-disconnected.

**S143 moves the app to `abletrace.ca`**, on ground that is by then understood.

**S144 is the QuickBooks production approval.** Its brief is a separate file Minty holds, `QB-PRODUCTION-BRIEF.md`, updated by S141's decisions below.

⚠ **The importer (P262) is specified below with its homework intact and has NOT been dropped — only outranked.**

---

## STATE

What no command returns. Everything a command returns is measured by the open check.

**P250 is complete on both boxes.** Not partial, nothing half-applied, nothing awaiting a follow-up.

**The QuickBooks backend chain is on prod and deliberately dormant.** Prod pulled `99852bf..cf7722d`, which carried the whole QuickBooks chain along with P250 — there was no way to take one without the other. The routes are live but unreachable: no prod company is connected, `quickbooks_tokens` is empty, and prod's **frontend was not deployed**, so the QuickBooks tile does not exist on prod. **This is intended. Do not "fix" the missing tile.**

**Prod's frontend is deliberately behind.** Prod serves `9bce0238`. Dev is `c2a52d8e`. No frontend deploy was made in S141 because none was needed.

**Three spent Mava export items on prod are still there** — `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/`. S141 did not reach them. Part of P256.

**`node_modules.old-node18/` untracked on dev backend is deliberate.** P227.

---

## THE JOB — S142: AUDIT AND DISCONNECT THE OLD AWS ACCOUNT

**Old account `350466202408`.** New account `208073623096`.

⚠ **THE FIRST ACT OF S142 IS TO WRITE THE SCAN, NOT TO RUN ONE.** S141 closed under RESERVE and deliberately did NOT write an exhaustive scan, because a thin one would give false confidence. **Minty's ruling S141.** The requirements are below; the command set is built at the top of S142 with fresh capacity.

⚠ **Nobody has ever listed every resource in this account.** What follows from S139/S140 is a handful of findings, not an inventory. **Do not treat it as coverage.**

### The target

Every element in the old account examined, and every one except SES and Route 53 **test-disconnected** — so that S143 can move the domain without standing on unmeasured ground.

### The hard keep-list

⚠ **SES and Route 53 are NOT touched.** Minty's ruling S139, restated S141.

- **SES** — the app's only working email path. Old account, domain `abletrace.ca`, sender `info@abletrace.ca`, IAM user `abletrace260825-ses-sender`, send-only. Restored S139.
- **Route 53** — zone `Z0710124HPIPA4X553D7` for `abletrace.ca`. ⚠ **S143's domain move depends on this. Breaking it blocks the next two sessions.**

**The old account is being TRIMMED, not torn down.**

### What the scan must cover

Exhaustive means every service, not the remembered ones. At minimum:

- **IAM** — users, roles, groups, policies (managed and inline), access keys **with last-used dates**, console access, MFA
- **EC2** — instances, volumes, snapshots, AMIs, security groups, key pairs, **Elastic IPs**
- **S3** — buckets, bucket policies, public access settings, static website hosting
- **RDS** — instances, snapshots (manual and automated), parameter groups
- **Route 53** — zones and **every record in each** ⚠ read-only in this session
- **ACM** — certificates and what they are attached to
- **CloudFront, Lambda, SNS, SQS, CloudWatch** — alarms, log groups, rules, schedules
- **SES** — identities, sending config, suppression list ⚠ read-only
- **Billing / Cost Explorer** — ⚠ **do not skip.** It is the only view that lists what is alive without needing to know it exists, and it catches services nobody remembers enabling.

### The question asked of every resource

⚠ **RULES §2.** Before disconnecting or releasing anything, ask **what still points at this?** and answer it by looking, in four places:

**DNS records · credentials · other AWS settings · accounts outside AWS**

⚠ **A code search cannot find these.** Nothing in the code names an Elastic IP, a bucket or a policy. That is exactly why they were left behind, and why this is console work.

### The order

1. **Scan everything first.** Change nothing.
2. **Sort into three piles** — keep (SES, Route 53), disconnect, and **unknown**. ⚠ **Unknown means scan again, never guess.**
3. **One dependency at a time.** Pointer first, resource second. Prove each before starting the next.
4. **Deactivate before deleting** where the service allows it — deactivation is reversible, deletion is not. Applies to IAM keys especially.
5. **Nothing released that something still points at.**

### What is already known — partial, NOT an inventory

Each with its source session. ⚠ **Treat as a starting list, not coverage.**

- **`Bobby1`** — IAM user, console access, 734 days idle. S139. → P260
- **`abletracelab-ses-smtp-s35`** — IAM user, plausibly still wired into something. S139. ⚠ **Ask what points at it first.** → P260
- **Two old-account IAM keys still valid and in git history**, deliberately. S138. → P17
- **`abletrace260825-ses-sender`** — the live SES sender. **KEEP.** S139.
- **Route 53 zone `Z0710124HPIPA4X553D7`** — `abletrace.ca`. **KEEP.** S139.

### Verify

- A written inventory of every service in the old account exists, produced this session.
- Every resource is in exactly one of the three piles, with no resource unaccounted for.
- Everything outside the keep-list is test-disconnected, each proven separately.
- SES still sends and Route 53 still resolves, checked on screen at the close.

### The lesson this job exists to honour

⚠ **The subdomain takeover.** IPs were released before DNS was audited, and for a period a name Mintek owned pointed at something Mintek did not. **The pointer goes first, the resource second. Never the reverse.**

---

## CARRIED — S143: MOVE THE APP TO `abletrace.ca`

⚠ **Waits on S142.** Route 53 is in the old account, so the move stands on the audit being done.

### The action

1. **Discovery** — the block below, read-only, one paste.
2. **Design in prose** before touching anything: which names point where now, which must move, in what order.
3. **Dev first.** DNS, certificate, Nginx, the frontend's API base. Prove on screen.
4. **Prod second, same session.**
5. **Terms and privacy served from the new domain** — their URLs go to Intuit and must be stable before S144.

### The discovery block

Read-only.

```
dig +short abletrace.ca
dig +short www.abletrace.ca
dig +short trace.mintekfoodsafety.com
dig +short dev.mintekfoodsafety.com
```

```
ls -1 /etc/nginx/sites-enabled/
```

```
grep -rn "server_name\|ssl_certificate\|proxy_pass" /etc/nginx/sites-enabled/ /etc/nginx/sites-available/ 2>/dev/null
```

⚠ **`grep -r` on nginx skips symlinks.** An empty result does not mean no config exists — TRAPS.

```
sudo certbot certificates 2>/dev/null || ls -1 /etc/letsencrypt/live/ 2>/dev/null || echo NO_CERTBOT
```

```
grep -rn "mintekfoodsafety\|abletrace.ca" ~/abletrace-lab-frontend/src/environments/ 2>/dev/null
```

```
grep -rn "UI_Base_Url\|APP_BASE_URL" ~/abletrace-lab-backend/config/ 2>/dev/null
```

### Material measured in S141

**`config/env/development.js` already reads its base URL from the environment.** Measured by:
```
git -C ~/abletrace-lab-backend diff 99852bf..cf7722d -- config/env/development.js
```
which returned the line becoming `(process.env.APP_BASE_URL || 'https://dev.mintekfoodsafety.com') + '/'`. ⚠ **Whether prod's `production.js` does the same is UNMEASURED.**

**Email already sends from `info@abletrace.ca`** — same diff, `fromEmail` line. The sending domain is already the target; the serving domain lags.

**Addresses** — dev `16.55.10.205` (`172.31.1.196` internal), prod `15.157.38.101` (`172.31.3.156` internal). Read from every S141 command block.

---

## CARRIED — S144: THE QUICKBOOKS TOKEN AND TILE DESIGN

**Minty's ruling S141.** Settles a question that has been open since the tile was built.

### Why the token expires — it is Intuit's design, not ours

The **access token lives about an hour**. Short by design: a stolen one is useless quickly. It cannot be held open.

Alongside it sits a **refresh token**, good for roughly a hundred days, whose only job is to obtain a fresh access token. ⚠ **It rotates — each use issues a new one and kills the old.** That is why it lives in a database row and not in `.env`, and why `quickbooksService` has two race guards.

### The ruling

**Refresh on demand, server-side, invisible.** The send route refreshes if the token is stale, immediately before calling Intuit. No timer, no cron entry, no screen visit.

⚠ **Rejected: a scheduled refresh.** A timer is a moving part that can stop silently. On-demand cannot drift, because nothing else uses the token.

⚠ **This replaces the manual workaround in TRAPS** — "load the QuickBooks page in Chrome first, that page refreshes and writes back." **That trap is retired the moment this is built.**

### The tile

**Kept, and client-facing.** It answers the client's own question: is my accounting linked?

- **Connected / not connected status**, read **live from Intuit**, never from our own row. ⚠ **A row can hold a revoked connection and look fully populated.** The S134 status route already does this.
- **Connect** and **Disconnect**. ⚠ **Intuit requires a disconnect URL regardless of the App Store question.**
- **Reconnect** where the connection is dead, going through Intuit properly.

⚠ **No refresh button.** It implies the client keeps the connection alive, and they do not — the server does. A button that usually does nothing teaches people to press it when something else is wrong.

### S141's decisions on the approval, carried

1. **No QuickBooks App Store listing.** ⚠ **Conditional on reading Intuit's own current wording first.** If production keys turn out to require a listing, re-scope.
2. **Minty is the named privacy officer.**
3. **Minty drafts the privacy policy from a skeleton, then a lawyer finalises it.** The Terms of Service were drafted by a lawyer and are sound. ⚠ **Write facts, not law** — who receives the data, where it lives, what happens on a breach, who is accountable, and the difference between Mintek's own users and data held for a client.
4. **The skeleton is the first deliverable**, and it runs in parallel with everything else because the lawyer's turnaround is the long pole.

---

## CARRIED — THE CLIENT ONBOARDING IMPORTER (P262)

⚠ **Outranked by the domain move, not dropped. Homework intact.**

⚠ **Do not reopen S140 to recover this.** Everything measured is below.

**Minty's ruling S140: complete rebuild, no constraint to preserve the existing template or importer. Several clients are coming. This must be robust.**

**Mava is the pilot.** Real data, real complexity, nobody harmed if it goes wrong.

### What exists today

An importer and an Excel template already exist and Minty has used them. The template Minty supplied has eight tabs:
```
Instructions · Agents · Manufacturers · Customers · Materials · Products · GetMaterialInfo · GetProductInfo
```
⚠ **Claude has NOT looked at the importer code.** It may have drifted or broken since the schema moved on. **First measurement of S142.**

⚠ **The template references everything by NAME, not by id.** That is correct and should be kept — it is what makes the sheet human-editable and removes all id-remapping from the load.

### ⚠ The two fragilities that justify the rebuild

**1 — Parallel comma lists.** `Sub_Recipe1_Materials` holds `"Ginger Powder,Salt"` and `Sub_Recipe1_Materials_Qty` holds `"7,1"`. Nothing enforces that the two lists are the same length or the same order. ⚠ **When it breaks it misassigns quantities rather than failing** — the worst kind of error, and invisible.

**2 — `$` packed into customer cells.** `Shipping_Contact_Person` holds `"Shanda$tom$Gerry"` with matching `$` lists in three other columns. Same failure mode.

**The fix, and it is one idea: one row per record, everywhere.** A `Recipe_Lines` tab — parent code, component name, component type, quantity, one line each. A `Customer_Addresses` tab — one row per address. ⚠ **This is exactly the shape the Mava export already has, because it is the shape the database has.**

### ⚠ Minty's step 2 can be deleted entirely

Today the recipe load is two steps: formulations without intermediates, then **Minty manually amends recipes to add intermediate products.** The manual step exists because a product cannot be referenced before it exists.

**Measured S140, from `6-recipes.tsv`:**
```
parents that use a sub-recipe:              12
distinct children used:                     16
children that are THEMSELVES parents:       none — depth is exactly 1
```
Command:
```
python3 -c "import csv; rows=list(csv.reader(open('6-recipes.tsv'),delimiter='\t'))[1:]; edges={}; [edges.setdefault(r[1],set()).add(r[7]) for r in rows if r[5]=='product']; kids=set().union(*edges.values()); print(len(edges), len(kids), sorted(kids & set(edges)))"
```

⚠ **Nothing nests.** So the importer inserts all products with their material lines, then makes a **second automated pass** wiring the product-as-component lines. Same script, no human. A dependency sort handles nesting if a future client has it; Mava does not need one.

### The Mava data, measured S140 — all on prod, archive `abletrace`, company 184

⚠ **164 is an empty shell despite being named `Mava Foods`.** 184 is the operating company despite being named `mavatrial2`. Confirmed across five tables — 164 returned nothing on every one.

```
materials      310      companyagents (suppliers)   25
formulations   171      companycustomers            13
recipe lines  1055      shipping addresses          13
dispatch orders 93      MOs                        131   last activity Jan 2025
```

**Schema, measured S140:**
```
fosubrecipe            createdAt, updatedAt, id, formulation_id
subrecipematerials     createdAt, updatedAt, id, qty, sub_recipe_id, material_id
subrecipeformulation   createdAt, updatedAt, id, qty, ship_qty, sub_recipe_id, formulation_id
companyagents          ... company_name, address, contact_person, email, contact_number, is_agent ...
customershippingadresses  ... shipping_contact_person, shipping_contact_person_no,
                             email_address, shipment_address, billing_adrress, customer_id
unitmeasurement        createdAt, updatedAt, id, company_id, unit_name
```

⚠ **`formulation_id` means PARENT in `fosubrecipe` and CHILD in `subrecipeformulation`.** Join it the wrong way round and you get a plausible-looking file that is silently wrong.

⚠ **There is no supplier or vendor table.** Suppliers are `companyagents`. Every name search for `%uppl%` and `%endor%` returned nothing — the concept is called "agents".

⚠ **`unitmeasurement` is per-company.** A new company needs its own unit rows created before any material can reference one. Raw `uom` values are ids, not text.

⚠ **Every one of the 170 recipes has exactly one stage.** Only one `Sub_Recipe` column pair is ever needed for Mava.
```
awk -F'\t' 'NR>1 {print $2"|"$5}' 6-recipes.tsv | sort -u | cut -d'|' -f1 | uniq -c | awk '{print $1}' | sort -n | uniq -c
→ 170 recipes, all with 1 stage
```

**Product UOM spread:**
```
135 Kg · 20 Ea · 10 Ltr · 6 Box
```

⚠ **`ship_qty` is blank or 0 on all 25 sub-recipe lines.** Never populated in that version.

**Status:** materials 307 Active / 3 Inactive. Products 135 Active / **36 Inactive**. Suppliers 25 Active. Customers 13 Active. ⚠ **Inactive products are referenced by live recipes — they cannot simply be skipped.**

⚠ **All 13 billing and shipping addresses are identical.** Mava never used a separate ship-to address, so the one-to-many capability was never exercised in this data.

### Batch quantity — settled, do not relitigate

⚠ **Minty's ruling S140: batch quantity goes across as a blind input and the client edits it.** It is easily changed in the app.

**Rule 7 does NOT apply here.** It governs figures the running app computes, not a seed value being loaded. Claude misapplied it in S140 and was corrected.

Batch quantity moved from Kg in the old version to units in the new. 135 of Mava's 171 products carry a Kg batch. **Carry the stored figure across and flag it for Mava to correct.** Do not attempt a weight-to-units conversion.

⚠ **Worth one cheap check anyway:** whether `fopackaging` holds level-1 rows for company 184. If it does, the unit count per batch may be **stored** there rather than derived, which would be better than a blind input and costs one query.

### Open questions for S142

1. **Does the existing importer still work?** First measurement. If it does not, "extend" was never on the table.
2. **Can the importer accept a PRODUCT as a sub-recipe component?** 25 lines across 12 products depend on it. The template's columns say "Materials", and the demo row `Baked Chicken with BBQ Sauce` has `Sub_Recipe1_Materials` = `Null` with qty 1, which reads like a workaround.
3. **`producttype` table** — needed to turn `type_id` into the Type column. Mava's materials are `type_id` 1 (294) and 2 (16). Unmeasured.
4. **Packing configuration** — the template needs it; `fopackaging` was never exported. Level 1 carries `wgt_kgs_per_unit`, the one place a unit weight is held anywhere.
5. ⚠ **The schema has moved since the archive.** That data is 2019–21; dev is current. `formulations` has gained `inventory_units`, `companycustomers` has gained `external_id`. **A column diff between `abletrace` and `abletracelab_live` answers it in one command.**

### ⚠ The company must be created through the app, not by SQL

**Minty creates the dummy Mava company through the UI.** RULES and S135: the app's creation path copies every `role_task` into `company_user_task`; SQL runs no application code. A company or role created by SQL grants nothing.

### The deliverable, already built

`Mava-Foods-master-data.xlsx` — 8 tabs, handed to Minty S140 and checked on screen. README, Materials, Suppliers, Material-Suppliers, Customers (shipping merged, one row per address, `ship_no` numbering them), Products, Recipes (`s_no` 1–170 keyed on `recipe_code`), Products-No-Recipe.

⚠ **`s_no` is keyed on the code, never the name.** **Six different products are called "Slow Roast"** — 171 products, 171 unique `internalCode`, only **139 distinct titles**. Keying on name merges separate products into one.
```
mysql -N -B -e "SELECT COUNT(DISTINCT title), COUNT(DISTINCT internalCode), COUNT(*) FROM abletrace.formulations WHERE company_id=184;"
→ 139  171  171
```

---

## CARRIED — OLD AWS ACCOUNT: THE S139 MATERIAL

⚠ **Supporting material for S142 above. Partial — NOT an inventory. Do not mistake it for coverage.**

⚠ **Carried whole from the S139 close. Do not reopen S139 or S140 to recover it.**

**Inventory the old AWS account 350466202408. Delete nothing. Produce the list.**

### The action, in order

1. **Start with the bill, not the console.** Cost Explorer, grouped by service, last 6 months. ⚠ **The bill is the only inventory that misses nothing chargeable.**
2. **Settle the open question below first.** Nothing else can be trusted until it is answered.
3. **Route 53** — every hosted zone, every record. ⚠ **Record what each A/CNAME points at.** This is the list the cleanup acts on first.
4. **EC2** — instance, Elastic IP, volumes, snapshots, key pairs, security groups. Note what each is attached to.
5. **RDS** — the six manual snapshots, their sizes and their monthly cost.
6. **S3, ACM certificates, CloudWatch, anything the bill surfaced.**
7. **IAM** — all 8 users, keys, key ages, last-used dates, console access.
8. **Write the list.** For each item: what it is, what points at it, keep or candidate, and what must go first if it goes.

⚠ **Nothing is deleted in the audit session.** The next one acts on the list, in the order the list dictates.

### ⚠ THE OPEN QUESTION — answer this before anything else

⚠ **We do not know which AWS account the live dev and prod boxes are in.**

The reasoning that says "the new account" is an inference, not a measurement: the old account's EC2 console showed **one** instance in ca-central-1, so dev and prod cannot both be there.

But the old account holds **1 Elastic IP**, and prod's public IP is `15.157.38.101`. If those are the same address, **prod is in the old account** and that Elastic IP must never be released.

⚠ **Releasing an Elastic IP that prod uses would take the live app off the internet.** The single most expensive thing the cleanup could get wrong.

Settle it on the boxes, not by reasoning:
```
curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 60')" http://169.254.169.254/latest/meta-data/instance-id; echo
```
Run on **dev** and on **prod**. Compare each returned instance-id against the old account's EC2 list. ⚠ **Written in S139, still never run — it is not a measurement yet.**

### The material — measured S139

**SES, old account, the thing being kept.** Console → Account dashboard:
```
Daily sending quota   50,000 emails per 24-hour period
Maximum send rate     14 emails per second
Region                Canada (Central)
Account health        Healthy
```
⚠ **This is production access, not sandbox.** Sandbox is capped at 200/day and 1/sec with a persistent banner. None present.

SES → Identities, 4 rows, all **Verified**:
```
abletrace.ca                    Domain
info@abletrace.ca               Email address
mintydev210706@yopmail.com      Email address
mintydev210705@yopmail.com      Email address
```
⚠ **`mintekfoodsafety.com` is NOT verified here.** `FROM_EMAIL` must stay an `@abletrace.ca` address on both boxes.

**What S139 built, which email now depends on.** Old account IAM:
```
policy  abletrace260825-ses-send      ses:SendRawEmail + ses:SendEmail, Resource *
user    abletrace260825-ses-sender    that policy only, no console access
key     created S139, secret filed in Section H
```
⚠ **One key serves both boxes.** → P259.

**Both boxes, measured S139:**
```
FROM_EMAIL=info@abletrace.ca
SMTP_USER length: 20        SMTP_PASSWORD length: 40
```
⚠ **These are NOT SMTP credentials.** An AWS IAM key id and secret; the app uses the AWS SDK via nodemailer's SES transport. A rotation is an IAM key rotation.

⚠ **Region is hardcoded `ca-central-1` at `api/services/email.js:7`** — not an environment variable.

**Old account EC2, console, ca-central-1:**
```
Instances (running) 1     Elastic IPs 1      Volumes 1
Key pairs 5               Security groups 7  Snapshots 7 (EBS)
Load balancers 0          Auto Scaling Groups 0
EC2 cost, past 6 months, Global: $145.51
```
The one instance:
```
AbleTrace Prod N...   i-088b7969158c43bca   Running   t3.small   ca-central-1b
```
⚠ **NOW.md never knew this instance existed.** It is why this is an audit and not a cleanup.

**The dead app in the old account:**
```
abletrace.ca/login          serves a live login page
prodapi.abletrace.ca        500 Internal Server Error on loginUser
```
A backend up with no database behind it. ⚠ **Only a corpse if the open question says prod lives elsewhere. Confirm before touching it.**

**RDS snapshots, old account, 6 manual, none automated:**
```
abletrace-dev-snapshot          8.0.42   abletrace-dev    July 06, 2026
abletrace-dev-snapshot260706    8.0.42   abletrace-dev    July 06, 2026
abletrace-stg-snapshot          8.0.44   abletrace-stg    July 06, 2026
abletrace-stg-snapshot260706    8.0.44   abletrace-stg    July 06, 2026
newinstance-final-20260817      8.0.45   newinstance      August 17, 2026
newinstance-snapshot260706      8.0.44   newinstance      July 06, 2026
```
⚠ **Three former instances** — a three-tier estate, all gone, only snapshots left.
⚠ **All MySQL 8.0.x.** Restoring starts the extended-support meter. **Restore, read, delete in the same session.**
⚠ **EBS snapshots are not RDS snapshots.** The "Snapshots 7" on the EC2 dashboard is a separate list.

**IAM, old account, 8 users, three seen:**
```
abletrace260825-ses-sender    created S139, the live sender
abletracelab-ses-smtp-s35     an older sender, 1 group
Bobby1                        last activity 734 days, password age 1496 days, console access
```
⚠ **P17 lives here.** → P260 for the deletes.

### The analysis

**Why SES stays in the old account.** Keys are account-scoped; cross-account is invisible to the code. Three consequences:
1. **The old account can never be closed.** Permanent infrastructure — root credentials, MFA, billing, security surface, forever.
2. **P17 rises.** Live keys in git history now sit in the account onboarding depends on.
3. **DNS is the only real coupling.** Route 53 serves abletrace.ca; SES verification and DKIM are records in that zone.

⚠ **Correction to the S135 "email-only" ruling.** Route 53 **stays** with SES. ⚠ **DKIM failure is silent** — SES still accepts the message, the log says sent, deliverability quietly rots. Read S135 as *"email, and the DNS email depends on."*

**The benefit worth naming:** the old account holds years of sending reputation, 50k/day, clean record. A new account starts cold.

**Why rebuilding in the old account was rejected, S139.** It would move the live app, two clients' books, the database, nginx, certs and the pipeline onto a different account — downtime and real risk — to gain nothing a client would notice.

**Why the SES re-application does not gate anything.** Both AWS objections are needed anyway: from-domain/link-domain mismatch is fixed by the abletrace.ca move, and bounce/complaint handling is P257. ⚠ **The S138 appeal WAS sent.** Case `178710371200148`, refused 22 Aug.

**⚠ The order that must not be reversed.** RULES: ask what still points at this — DNS records, credentials, other AWS settings, accounts outside AWS. **The pointer goes first, the resource second.** ⚠ **A code search cannot find these.**

The most likely place the cleanup goes wrong: abletrace.ca DNS records pointing at the dead EC2. Those must be removed **before** the Elastic IP is released.

### The verify

1. The instance-id command run on **both** boxes, compared against the old account's EC2 list, answered in writing.
2. Cost Explorer read by service, every chargeable line matched to an entry.
3. Every Route 53 record written down with what it points at.
4. The list exists as a document, keep/candidate marked, removal order stated.
5. **Nothing deleted.**

---

## WHAT S141 CHANGED

**P250 done, dev and prod.** `api/policies/isAuth.js`, commit `cf7722d`. The policy looks the user up in `company_users` and rewrites `req.body.company_id`, which covers 165 controller sites without editing one of them. Url and query values are compared and refused rather than rewritten. Super admin is exempt.

**Six columns added to prod by hand** — `companycustomers.external_id`, and five `qb_*` on `packingslips`. Definitions read off dev, read back on prod, identical.

**`quickbooks_tokens` created on prod by hand.** Empty, and should stay empty until Phase 3.

**Prod backend moved `99852bf` → `cf7722d`**, carrying the whole QuickBooks chain with P250.

**The first automated test exists** — `attack-test-s141.sh`, eight checks, 8/8 on dev. ⚠ **It has NOT been run against prod.** Running it needs two prod companies with different row counts, which was never measured.

---

## WHAT S141 MEASURED — the app's authorization shape

Each with the command that measured it.

**One shared layer.** `config/policies.js` has `'*': 'isAuth'`. Public actions are login and password reset only, plus `QuickbooksController.callback`.
```
cat ~/abletrace-lab-backend/config/policies.js
```

**165 body sites, 16 `params.company_id`, 1 `query.company_id`, 43 `companyId`.**
```
grep -rn "body.company_id" ~/abletrace-lab-backend/api --include=*.js | wc -l
grep -rno "query.company_id\|params.company_id\|companyId\|company_Id" ~/abletrace-lab-backend/api --include=*.js | sed 's|.*:||' | sort | uniq -c
```

**13 routes carry a company in the URL** — 10 spelled `:company_id`, 3 `:companyId`, all Traceability.
```
grep -n "company_id" ~/abletrace-lab-backend/config/routes.js
grep -n "companyId" ~/abletrace-lab-backend/config/routes.js
```

**One token mint.** `generateJWT` has exactly one caller, `api/models/User.js:9`. Login is `POST /api/v1/User/loginUser`, fields `username` and `password` (`User.js:430-431`).
```
grep -rn "jwt.sign" ~/abletrace-lab-backend/api ~/abletrace-lab-backend/config --include=*.js
```

**Super admin is `user_id 1`, `info.abletrace@gmail.com`, with zero rows in `company_users`.** No user belongs to more than one company.
```
mysql -N -B -e "SELECT s.user_id, u.email, (SELECT COUNT(*) FROM abletracelab_live.company_users c WHERE c.user_id=s.user_id) FROM abletracelab_live.super_admin s JOIN abletracelab_live.user u ON u.id=s.user_id;"
```

**Dev's app database is `abletracelab_live`**, not `abletrace-dev`.
```
grep DATABASE_URL ~/abletrace-lab-backend/.env | sed 's|.*/||'
```

**Test identities for the attack test, dev:**
| | user | company | materials |
|---|---|---|---|
| A | `test_glutenull_260701@mailinator.com` | 466 | 63 |
| B | `test_truffle260719c@mailinator.com` | 473 | 47 |
```
mysql -N -B -e "SELECT company_id, COUNT(*) FROM abletracelab_live.materials GROUP BY company_id ORDER BY 2 DESC;"
```

**No route passes `req.body` wholesale into a query**, so injecting a key cannot add a filter.
```
grep -rn "find(req.body)\|findOne(req.body)\|create(req.body)\|update(req.body)\|\.where(req.body)" ~/abletrace-lab-backend/api --include=*.js
```

---

## THINGS THAT COST TIME IN S141

**Claude wrote a check that could not fail.** A `grep -l` piped to `uniq -c` was meant to show how concentrated the 165 hits were; `-l` lists each file once, so every count was 1. It reported nothing and looked like an answer. ⚠ **RULES: say what result would distinguish the two answers before running it.**

**Claude designed a fix that leaned on an untested assumption.** The first design overwrote `req.body`, `req.params` and `req.query` alike. Express rebuilds `req.params` between routing layers, so that half could have failed silently. The design was changed to compare-and-refuse for the URL, leaving one load-bearing assumption instead of two — and the attack test was written so that assumption's failure would show as a 200 instead of a 403.

**Claude nearly wrote a column definition from memory.** The six QuickBooks columns were added by hand on dev in an earlier session. They were read off dev before being written to prod. ⚠ **RULES: never rebuild a measurement to fit a memory.**

**A grep for a table looked for the wrong name.** `quickbookstoken` was inferred from the model filename; the table is `quickbooks_tokens`. The model file named it correctly and was read before creating anything.

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **`isAuth` now rewrites `req.body.company_id` on every authenticated request.** A controller reading it is reading the SERVER's value, not the client's. **Sending a different one has no effect and is not a bug.**

⚠ **A URL or query carrying another company returns 403 "Company mismatch".** That is P250 working, not a broken route.

⚠ **Eleven `Object.keys(req.body).length > 0` guards are now always true**, because `company_id` is always injected. Harmless today — the frontend never sends an empty body. → P266

⚠ **The QuickBooks tile does not exist on prod.** Prod's frontend was not deployed and the routes are dormant on purpose. **Not a fault.**

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **A 400 on a guarded route proves nothing about the route.** `isAuth` returns 400 for four reasons, all before the controller runs.

⚠ **Role and task data is cached at login.** A database change will not appear in an open session.

⚠ **A master role row created by SQL grants nothing.** The app's creation path copies every `role_task` into `company_user_task`. **Companies, roles and tasks on prod must be created through the UI.**

⚠ **`mysql abletracelab_live` — name the DB explicitly.** A bare `mysql` on prod lands in the dormant ARCHIVE `abletrace`.

⚠ **`formulation_id` means PARENT in `fosubrecipe`, CHILD in `subrecipeformulation`.**

⚠ **`unitmeasurement` is per-company.** A `uom` value is an id, and the same id means different things to different companies.

⚠ **Product titles are not unique.** 171 products, 139 distinct titles. **Match on `internalCode`, never on name.**

⚠ **`SELECT ... INTO OUTFILE` does not work on RDS.** Use `mysql -B` to write tab-separated output.

⚠ **A newline inside a text column breaks a TSV row.** Wrap `remarks`, `address` and `ops_instructions` in `REPLACE` for tab, CR and LF.

⚠ **DKIM failure is silent.** SES accepts the message, the log says sent, deliverability quietly drops.

⚠ **`.env` is one file per box and is not in git.** A deploy, a promote, a pull and a restart all fail to carry it.

⚠ **`pm2 restart` prints "Use --update-env"** — that is PM2's own env. `dotenv` reads the file at boot. Not a warning being ignored.

⚠ **An RDS snapshot cannot be queried.** Restoring is the only read path and it starts an 8.0 extended-support meter.

⚠ **Automated RDS backups die with the instance.** Only a manual or final snapshot survives.

**QuickBooks Canada refuses any transaction with no tax code on a line**, and any line with no Amount. ⚠ **Always log `err.response.data`, truncated.**

**`CustomTxnNumbers: true` returns a blank document number with no error at all.**

**The QuickBooks access token expires in hours.** Load `dev.mintekfoodsafety.com/quickbooks` in Chrome first — that page refreshes and writes back. ⚠ **Retired the moment on-demand refresh is built — see the S144 section.**

⚠ **`mysql2` is not a dependency.** `require('mysql2/promise')` fails. Use a shell variable.

⚠ **No HttpInterceptor.** Every service sets `authorization: bearer <webToken>` per call, lower case.

⚠ **`src/app/Services` has a CAPITAL S.** macOS is case-insensitive; Angular's AOT compiler is not.

**`formulations` has no `name` column — it is `title`.**

**`shipped_flag` is the ship gate, not `status_id`.**

⚠ **`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.**

**Licence statuses:** 1 Invited · 2 Trial · 3 Active · 4 Expired · 6 Inactive. ⚠ **Only Inactive blocks login. Expired keeps access.**

---

## QUEUE

Minty ranks. Claude never renumbers.

| # | item |
|---|---|
| P263 | **S142. Audit and disconnect the old AWS account, one dependency at a time.** ⚠ **Minty's ruling S141: FIRST, ahead of the domain move.** Keep SES and Route 53. ⚠ **Write the exhaustive scan at the top of the session — S141 deliberately did not.** Full spec above |
| P265 | **S143. Move the app to `abletrace.ca`.** ⚠ **Waits on P263 — Route 53 is in the old account.** Full spec above |
| P262 | **Client onboarding importer — complete rebuild.** ⚠ **Minty's ruling S140: several clients coming, must be robust, no constraint to preserve the existing template.** Mava is the pilot. Full spec above |
| P267 | **S144. QuickBooks production approval.** Brief is a separate file Minty holds. ⚠ **No App Store listing, conditional on step 1.** First deliverable is the privacy policy skeleton. **Token refreshes on demand server-side; tile keeps status, Connect and Disconnect; no refresh button** |
| P17 | **Two old-account IAM keys still valid and in git history.** The old account is load-bearing for email |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — **Phase 2 core DONE and proven.** Four failure-handling items remain. ⚠ **P250 is done, so Phase 3 is UNBLOCKED.** The hardcoded `sandbox260820` can now become `req.companyId` |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn`. ⚠ **NOT done in S141 — `generateJWT.js` was never touched. Still open** |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22+. Both report "system restart required" |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dev home is full of dead build folders**, ~50 back to S63. ⚠ **Keep the live rollback and one prior.** ⚠ **Add: `.env.bak-s139` on BOTH boxes — do not delete until the S139 keys are proven stable.** ⚠ **Add: prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/` — spent, NOT deleted in S141, still there** |
| P257 | **Automated bounce and complaint handling.** ⚠ **Required for any SES re-application.** Overlaps P240 |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` dev, `testsesprod260825` **prod**. ⚠ **Set Inactive through the app, Super Admin → License and Billing — NOT by SQL** |
| P259 | **One IAM key serves both boxes.** ⚠ **Minty's ruling S139: separate eventually, not now.** Fold into a session already editing `.env`. **Dev first, prove a send, leave prod on the working key** |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` — console access, 734 days idle. `abletracelab-ses-smtp-s35` — plausibly still wired into something. ⚠ **Ask what still points at this, first.** ⚠ **Deactivate a key before deleting it** — deactivation is reversible |
| P266 | **Eleven dead `Object.keys(req.body)` guards**, always true since P250 injects `company_id`. Harmless; do not touch casually |
| P268 | **The QuickBooks tile's visibility gate is not in `src/app/Layouts`.** A grep there returned nothing. Matters when the screen must work for real clients |
| P269 | **Two stored procedures are built by string interpolation.** `Materials.js:137` and `Hazards.js:224`. Found S141, not fixed |
| P264 | **No automated tests anywhere.** Raised S140 while sizing P250. The attack test built in S141 is the first one; it should not be the last. ⚠ **It has never been run against prod** |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

### THE ESTATE — sequenced

**Minty's ruling S138, still standing:** (1) restore email — **done S139**, (2) audit dependencies — **now S143**, (3) move to abletrace.ca.

**Minty's ruling S139:** keep SES **and Route 53** in the old account. Everything else is a candidate.

**Minty's ruling S141:** P250 is done. The order is now **audit and disconnect the old account (S142), then the domain move (S143), then QuickBooks (S144)**. The audit comes first because Route 53 lives in the old account and the move stands on it.

⚠ **The abletrace.ca move has two reasons.** One app rather than two, and sending domain matching link domain.

### P245 Phase 3 — blocked on P250

**Clients do not get sandboxes.** Each client clicks Connect, signs in, approves, and gets a row in `quickbooks_tokens` under their company name. The company column was added S129.

⚠ **The company must come from the logged-in session, never a parameter.** Both transaction routes and the status route use a hardcoded `sandbox260820`. ⚠ **P250 is DONE — `req.companyId` now exists on every authenticated request. This is a small change, not a campaign.**

**Also at Phase 3**
- Intuit **production** keys. They never appear in chat.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- ~~Schema changes run on prod separately.~~ **DONE S141.** All six columns and `quickbooks_tokens` exist on prod, read back and verified.
- **Role and task rows through the UI on prod, not by SQL.**
- A **Reconnect URL** is mandatory in Intuit app settings as of Feb 2026.
- ⚠ **Custom transaction numbers is per-client.**

**Minty's ruling on ownership, 21 Aug**

> The client's admin owns their data. Super admin runs the platform, not the tenants. Super admin has **no** access to a client's QuickBooks data, and none to their inventories. Today Minty sees everything because it is early; that is temporary, not the design.

**Direction, not to be built yet:** support access is **break-glass** — closed by default, client-consented, expiring, logged. Never standing.

⚠ **Consequence to accept:** when a client's connection breaks, Mintek cannot look. Which is why the failure-handling items are not optional.

**The four failure-handling items** — what remains of Phase 2.
1. ~~A status on every slip, always visible.~~ **Done S136–S138, on screen.**
2. The reason, in plain words, on the slip. ⚠ **The route already returns exactly these reasons; they are shown transiently and not stored.**
3. A retry button. ⚠ **Send is blocked once `qb_estimate_id` is set — deliberate.**
4. A list of slips shipped with no invoice number. ⚠ **Belongs on the QuickBooks tab.**

⚠ **Canadian tax is not uniform.** Basic groceries are zero-rated, other food is not. Sandbox codes: 2 Exempt, 3 Zero-rated, 5 HST ON, 6 Out of Scope.

**Later, its own phase** — material receipts to supplier bills. One PO can be received in three deliveries and billed in two invoices. The linking rule is a business decision.
