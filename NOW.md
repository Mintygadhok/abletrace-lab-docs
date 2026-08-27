# NOW

Rewritten whole at the close of S140.
Read RULES.md and this file. Nothing else at the open.

**S140 exported Mava's master data and found the client onboarding importer.** P261 is done. The exercise turned into the onboarding design, and the onboarding design surfaced P250 as the thing that must come first.

**S141 fixes P250.** Server-side company scoping. ⚠ **Minty's ruling S140: this goes ahead of the importer and ahead of any client.** The platform is empty today, which is the only cheap moment to fix it.

**S142 builds the client onboarding importer. S143 audits the old AWS account.** Both are specified below with their homework intact. ⚠ **Do not reopen S139 or S140 to recover either — everything needed is in this file.**

---

## STATE

What no command returns.

**Email works on dev and prod.** Both boxes send through the OLD account's SES using one IAM key created S139. Nothing half-done. Untouched in S140.

**Dev backend is `0948476`, dev frontend deployed and proven.** QuickBooks Phase 2 core is done. Untouched in S140.
```
/home/ubuntu/www-html.bak-dev-d770204085dbb138303ec6decbd3bd73a05c4a8b   dev rollback
/home/ubuntu/www-html.bak-prod-4910b46d76a4c49eee431e1a9b435a0116fc9031  prod rollback
```

**Prod backend and frontend are unchanged since before S130.** S139 restarted prod for `.env` only. S140 wrote no code at all.

**S140 wrote nothing to any database.** Every statement was a SELECT against the dormant archive on prod. Two scripts and one output folder were left on prod:
```
/home/ubuntu/mava-export.sh
/home/ubuntu/mava-export-2.sh
/home/ubuntu/mava-export-260826/          9 tsv files
```
⚠ **Delete these in S141.** They are spent. → P256.

**Both `.env` files carry `.env.bak-s139`.** Not in git, not carried by any deploy.

**Two test companies still exist and are still not Inactive.** `testses260825a` on dev, `testsesprod260825` on **prod**. → P258.

**Both boxes report "system restart required."** Noted S135, still not acted on — P248.

**Dev backend carries `node_modules.old-node18/`** untracked, deliberate — P227.

**Stray QuickBooks estimate 183** sits in the sandbox with no number. Harmless.

---

## THE JOB — S141

**P250. Make the server decide which company's data a request may touch. Stop trusting the browser.**

⚠ **Read this before anything else.** A logged-in user at client A can change one number in what their browser sends and read or write client B's data. Recipes, customers, suppliers, stock. It needs Chrome's developer tools and nothing else. It leaves no trace that looks unusual, because to the server it is an ordinary request from a valid login.

⚠ **Minty's ruling S140: this is a complete rebuild of the login and scoping path, not a patch.** No constraint to preserve what exists.

---

### ⚠ THE HOMEWORK WAS NOT DONE

⚠ **S140 took no P250 measurements.** The session went to P261 and the onboarding design. Everything below about the app's current behaviour is **memory from S135–S139, not measured this session.**

Per RULES: a quoted fact with no measurement beside it is a memory, not material. **Treat the section below as a list of things to confirm, not as facts.** The discovery block exists so that confirming them costs minutes, not a session.

---

### The action, in order

1. **Run the discovery block below.** It is written and ready. Do not start designing before it returns.
2. **Answer the one question that sizes the whole job** — can the fix go in one shared layer, or must every route be edited? See below.
3. **Build the session company lookup.** At login, read the user's company from the database once and hold it in the session.
4. **Make routes read the session, never the body.** Shape depends on step 2.
5. **Write the attack test.** Log in as company A, ask for company B, confirm refusal. Run it against every route.
6. **Prove it on the screen on dev**, then prod.

---

### THE QUESTION THAT SIZES THE JOB — answer it first

⚠ **Is there one layer every request passes through before it reaches a controller?**

**If yes** — the fix is small. Strip `company_id` out of the incoming request at that layer and inject the session's value. Every controller carries on reading `company_id` from the request exactly as it does today, except the value is now the server's and cannot be influenced from the browser. **One change, plus a check that nothing bypasses it.**

**If no** — every route must be edited individually. Mechanical, low-risk per route, but there are many and missing one leaves the hole open. It then needs a way to prove none were missed, not a careful pass.

⚠ **This is measurable, not a matter of opinion.** Sails has a policy layer and a hooks layer. Whether either can rewrite a request body before the controller runs is what decides it. The discovery block answers it.

⚠ **A passing guard proves nothing about the action behind it.** RULES: when a policy refuses a request the controller never ran. Do not read a 400 or 403 as evidence the scoping works. **The proof is a request that succeeds and returns the right company's rows, plus one that succeeds and returns nothing because it asked for someone else's.**

---

### The discovery block — run this at the open, on DEV

Each command is written to distinguish two answers. Run one box at a time.

**1 — How many routes take `company_id` from the body?** This is the size of the job if there is no shared layer.
```
grep -rn "req.body.company_id\|body.company_id" ~/abletrace-lab-backend/api --include=*.js | wc -l
```

**2 — Which files, and how concentrated?** A few big files is a different job from fifty small ones.
```
grep -rln "req.body.company_id\|body.company_id" ~/abletrace-lab-backend/api --include=*.js | sed 's|.*/||' | sort | uniq -c | sort -rn | head -30
```

**3 — What policies exist, and what runs globally?** The `'*'` entry is the shared layer if there is one.
```
cat ~/abletrace-lab-backend/config/policies.js
```

**4 — What does the auth policy actually read?** Memory says it reads only the super-admin `User` table, which would mean there is no company lookup anywhere yet.
```
cat ~/abletrace-lab-backend/api/policies/isAuth.js
```

**5 — Is there a hooks directory?** A Sails hook can rewrite a request before any policy or controller runs.
```
ls -la ~/abletrace-lab-backend/api/hooks/ 2>/dev/null; ls -1 ~/abletrace-lab-backend/config/ | head -40
```

**6 — What is in the JWT already?** If the company is in the token, the lookup may be cheaper than expected. ⚠ Memory says the token never expires — P247.
```
cat ~/abletrace-lab-backend/api/policies/generateJWT.js
```

**7 — Which table maps a user to a company?** The lookup needs a source of truth.
```
mysql -N -B -e "SELECT GROUP_CONCAT(COLUMN_NAME ORDER BY ORDINAL_POSITION SEPARATOR ', ') FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='abletracelab_live' AND TABLE_NAME='company_users';"
```

⚠ **Name the database explicitly.** A bare `mysql` on prod lands in the dormant ARCHIVE `abletrace`.

---

### The material — ⚠ ALL MEMORY, CONFIRM WITH THE BLOCK ABOVE

Measured S135–S138, **not re-measured in S140.**

**Four known sites, from S138:**
```
api/controllers/PackingSlips.js   lines 74, 148, 250, 354
```
Each takes `company_id` straight from `req.body`. ⚠ **These are the four that were looked at. The grep in step 1 is what says how many there really are.**

**`isAuth.js` reads only the super-admin `User` table.** If true, there is no "which company does this user belong to" lookup anywhere in the app, and step 3 of the action is building it from nothing rather than wiring up something that exists.

**App JWTs never expire.** `api/policies/generateJWT.js` calls `jwt.sign` with no `expiresIn`. → P247.

**No HttpInterceptor on the frontend.** Every Angular service sets `authorization: bearer <webToken>` per call, lower case. ⚠ **Relevant** — if the fix changes what the server expects, there is no single frontend place to change in step.

**Role and task data is cached at login.** A database change will not appear in an open session. ⚠ **This will make testing confusing** — log out and back in between attempts.

**`company_id` is a DOUBLE on `companycustomers` and `dispatchorders`, an INT on `packingslips` and `packingslipdos`.** ⚠ A strict comparison across the two can fail silently.

---

### The analysis

**Why this goes before the importer.** The importer creates client companies. Creating several companies on a platform that cannot keep them apart builds the problem at scale rather than fixing it. Fixing it now costs a session on an empty platform; fixing it later means changing authorization underneath live client data, where any mistake is visible to customers.

**Why this goes before any client.** A recipe is a client's trade secret. A food manufacturer seeing a competitor's formulations through the platform is not a bug report — it ends that relationship and probably the others. There is no version of that recovered by patching afterwards.

**The pattern already exists in the codebase and is proven.** QuickBooks: Intuit's token is bound to one realm, and the caller cannot ask for a different one. Identity and scope travel together, and the caller never states the scope. ⚠ **P245 Phase 3 needs exactly this too** — both transaction routes and the status route currently use a hardcoded `sandbox260820`, and NOW has recorded since S129 that the company must come from the session. **P250 unblocks that at the same time.**

**Why "harmless today" was the right call and is no longer.** With one client's data the flaw has nothing to reach. Minty's decision S140 to take several clients is what changes it.

**What Claude got wrong in S140, worth carrying.** Claude applied the rule 7 unit discipline to a seed value the client edits on day one. ⚠ **Minty's ruling S140: rule 7 governs figures the running app computes, not data being loaded in.** Do not over-apply it in the importer either.

---

### The verify

S141 is done when:

1. The discovery block has been run and the one-layer question is answered **in writing**.
2. A user's company is read from the database at login and held in the session.
3. A request that carries a different `company_id` in its body returns **that user's own company's data, or nothing** — not the requested company's.
4. The attack test exists, runs against every route, and passes.
5. Proven **on the screen** on dev, then prod. ⚠ **Deployed is not proven.**

⚠ Item 3 is the whole point. Items 1–2 are the build. Item 4 is what makes it something you can tell a client.

---

## CARRIED — S142: THE CLIENT ONBOARDING IMPORTER

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

## CARRIED — S143: AUDIT THE OLD AWS ACCOUNT

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

## WHAT S140 CHANGED

**P261 done.** Mava's master data exported and delivered as `Mava-Foods-master-data.xlsx`, checked on screen by Minty.

**Nothing written to any database. No code changed. No deploy. Neither box restarted.**

**The queue was reordered by Minty:** P250 to the front, importer second, AWS audit third.

**Rule 7's scope was clarified by Minty** — it governs figures the running app computes, not seed data being loaded.

---

## THINGS THAT COST TIME IN S140

**Claude accepted an absence instead of looking.** No table matched `%uppl%` or `%endor%`, and Claude was one step from concluding suppliers were never tracked. A full table list found `companyagents` immediately. ⚠ **An absence is a weaker finding than a presence — check it a second way.**

**Claude guessed `uom` was text.** It is a foreign key to a per-company table, so the first export printed `642` and `635` where Kg and Ea belonged. Caught only because Minty read the file on screen. ⚠ **Deployed is not proven; exported is not correct.**

**Claude added six columns to an agreed format without saying so.** Minty approved five columns and got eleven. ⚠ **Additions need saying out loud, even good ones.**

**Two counts disagreed and the discrepancy was real information.** 139 distinct recipe names against 170 products with recipes looked like a dropped join; it was duplicate titles. ⚠ **RULES: when a measurement and a memory conflict, find a third measurement.**

---

## TRAPS CARRIED FORWARD — all look like broken code

⚠ **`company_id` comes from `req.body` on every route.** Until P250 lands, any logged-in user can read or write another company's data with Chrome's developer tools.

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

**The QuickBooks access token expires in hours.** Load `dev.mintekfoodsafety.com/quickbooks` in Chrome first — that page refreshes and writes back.

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
| P250 | **S141. Authorization is enforced by the screen, not the server.** ⚠ **Minty's ruling S140: complete rebuild, ahead of the importer and ahead of any client.** Full spec above |
| P262 | **S142. Client onboarding importer — complete rebuild.** ⚠ **Minty's ruling S140: several clients coming, must be robust, no constraint to preserve the existing template.** Mava is the pilot. Full spec above |
| P263 | **S143. Audit the old AWS account.** Carried whole from S139 with its material intact. Full spec above |
| P17 | **Two old-account IAM keys still valid and in git history.** The old account is load-bearing for email |
| P8 | Prod git checkout lags the served build — read rollback path off the box |
| P210 | Prod to Node v24. Dev has run v24 cleanly for several sessions |
| P224 | Dev SSH IPv6 rule |
| P227 | Dev backend `node_modules.old-node18/` — deliberate, untracked |
| P240 | The app cannot tell anyone a send failed. Overlaps P257 |
| P241 | Quarterly security audit, five named checks |
| P245 | QuickBooks — **Phase 2 core DONE and proven.** Four failure-handling items remain. ⚠ **Phase 3 is blocked on P250** |
| P246 | `User.creatSuperAdmin` hardcodes password `"12345678"`. `api/models/User.js:98`. Fold into P241 |
| P247 | **App JWTs never expire.** `api/policies/generateJWT.js`, no `expiresIn`. ⚠ **Touch it in S141 — the same file is being rebuilt** |
| P248 | **OS updates.** Prod 59 pending / 12 security. Dev 22+. Both report "system restart required" |
| P249 | **Typing any URL logs the user out.** `auth.guard.ts` reads the NGRX store, memory only |
| P251 | GitHub warns Node.js 20 actions are deprecated |
| P252 | **External ID duplicate guard, customers and products.** ⚠ `editCustomer` has no duplicate check at all |
| P253 | **No SSH host aliases.** Two lines in `~/.ssh/config`. dev `16.55.10.205`, prod `15.157.38.101` |
| P254 | **A sales order cannot be edited once created.** Business question |
| P256 | **Dev home is full of dead build folders**, ~50 back to S63. ⚠ **Keep the live rollback and one prior.** ⚠ **Add: `.env.bak-s139` on BOTH boxes — do not delete until the S139 keys are proven stable.** ⚠ **Add: prod `mava-export.sh`, `mava-export-2.sh`, `mava-export-260826/` — spent, delete in S141** |
| P257 | **Automated bounce and complaint handling.** ⚠ **Required for any SES re-application.** Overlaps P240 |
| P258 | **Two test companies exist and cannot be deleted.** `testses260825a` dev, `testsesprod260825` **prod**. ⚠ **Set Inactive through the app, Super Admin → License and Billing — NOT by SQL** |
| P259 | **One IAM key serves both boxes.** ⚠ **Minty's ruling S139: separate eventually, not now.** Fold into a session already editing `.env`. **Dev first, prove a send, leave prod on the working key** |
| P260 | **Old-account IAM users that should not exist.** `Bobby1` — console access, 734 days idle. `abletracelab-ses-smtp-s35` — plausibly still wired into something. ⚠ **Ask what still points at this, first.** ⚠ **Deactivate a key before deleting it** — deactivation is reversible |
| P264 | **No automated tests anywhere.** Raised S140 while sizing P250. The attack test built in S141 is the first one; it should not be the last |
| — | **`role_task` id 24 — QuickBooks under the Admin role.** Minty's convention S135: admin reaches QuickBooks by holding the QuickBooks Controller role |
| — | **Materials may have the same quoting fault.** `Materials.js:380` and `:790` use `myCode`; still not checked |
| — | Section_3B.md rewrite. Verdict: replace whole. ~430 lines unread |

### THE ESTATE — sequenced

**Minty's ruling S138, still standing:** (1) restore email — **done S139**, (2) audit dependencies — **now S143**, (3) move to abletrace.ca.

**Minty's ruling S139:** keep SES **and Route 53** in the old account. Everything else is a candidate.

**Minty's ruling S140:** P250 and the importer come before the estate work. **Client readiness outranks tidiness.**

⚠ **The abletrace.ca move has two reasons.** One app rather than two, and sending domain matching link domain.

### P245 Phase 3 — blocked on P250

**Clients do not get sandboxes.** Each client clicks Connect, signs in, approves, and gets a row in `quickbooks_tokens` under their company name. The company column was added S129.

⚠ **The company must come from the logged-in session, never a parameter.** Both transaction routes and the status route use a hardcoded `sandbox260820`. ⚠ **P250 unblocks this.**

**Also at Phase 3**
- Intuit **production** keys. They never appear in chat.
- The API base **host** changes — production is `quickbooks.api.intuit.com`, which returns 403 to a sandbox token.
- Schema changes run on prod **separately**. ⚠ **Including the five `qb_*` columns and `companycustomers.external_id`, dev only.**
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
