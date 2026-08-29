# NOW

Rewritten whole at the close of **S142**.

The open check measures commits, process, port, runtime and dirty trees. Nothing here repeats it. This carries only what no command returns.

---

## STATE

**S142 was the old-account audit (P263). It is complete as an audit and partially complete as a disconnection.**

An exhaustive read-only scan of old account `350466202408` was written, uploaded to CloudShell and run across all 17 opted-in regions. Two files were produced and downloaded: `abletrace260828-oldacct-FULL.txt` (4,813 lines) and `abletrace260828-oldacct-SUMMARY.txt` (237 lines). Every finding below was measured this session from inside the account.

**Deliberate, done, verified:** six IAM console passwords deleted, each confirmed `NoSuchEntity` immediately after. Two of them held `AdministratorAccess`. **The only way into the old account is now root, which has MFA (`AccountMFAEnabled = 1`).**

**Deliberate, NOT done:** no key was touched, no data-bearing resource was touched, SES and Route 53 were not touched. All five access keys confirmed `Active` after the password work.

**Nothing is half-applied.** No resource was deleted this session.

⚠ **Minty's ruling S142: protect the data of the four old clients for some time yet.** Every data-bearing resource in the old account stays until he says otherwise. The account is being reduced by removing *access* and *pointers*, not storage.

---

## THE JOB — S143: PREPARE AND PROVE `abletrace.ca` ON THE NEW SERVER

**Nothing public changes in S143.** At its close the new server is fully ready to answer for `abletrace.ca` and the old site is still live. The DNS switch is S144.

### The action, in order

1. **Add the names to nginx on prod.** Add `abletrace.ca` and `www.abletrace.ca` to `server_name`, **keeping** `trace.mintekfoodsafety.com` and `mintekfoodsafety.com`. Reload nginx.
2. **Test privately.** Add `15.157.38.101 abletrace.ca` to `/etc/hosts` on the Mac. The browser then reaches the new server by the real name while the public still sees the old site. Test login, dashboard, uploads, email send.
3. **Check the frontend API URL and backend CORS.** If either is hardcoded to `mintekfoodsafety.com`, the page loads at the new name and every API call fails. ⚠ **This is the item most likely to turn into a frontend rebuild and deploy — size it early.**
4. **Issue the certificate by DNS-01.** Certbot writing a TXT record into the Route 53 zone in the **old** account.
5. **Lower the TTL** on `abletrace.ca` and `www.abletrace.ca` to 60 seconds. This is the rollback speed for S144.

### ⚠ The certificate trap — the one thing that would have bitten on the day

Certbot's ordinary method proves ownership by serving a file at `http://abletrace.ca/.well-known/...`. **That name resolves to CloudFront today, not to `.101`, so the check fails until DNS has already changed.** The certificate cannot be pre-issued that way.

**Use DNS-01 instead** — Certbot writes a TXT record into the Route 53 zone and never needs the name to point anywhere. It works before cutover. The alternative is to change DNS first and issue the cert immediately after, accepting a window of HTTP-only service; that is worse.

### Material — measured S142

| fact | measured by | returned |
|---|---|---|
| Zone id | `aws route53 list-hosted-zones` | `/hostedzone/Z0710124HPIPA4X553D7`, `abletrace.ca.`, 20 records |
| Site records | `aws route53 list-resource-record-sets --hosted-zone-id /hostedzone/Z0710124HPIPA4X553D7` | `abletrace.ca. A` → alias `d1gnzid0cfbv78.cloudfront.net.`; `www.abletrace.ca. A` → same alias |
| Old API record | same command | `prodapi.abletrace.ca. A → 3.98.223.126` |
| CloudFront | `aws cloudfront list-distributions` | `E311W5PD650CXV`, `d1gnzid0cfbv78.cloudfront.net`, origin `abletrace-prod1.s3.amazonaws.com`, aliases `abletrace.ca` + `www.abletrace.ca`, **Enabled** |
| What `3.98.223.126` is | `aws ec2 describe-addresses --region ca-central-1` | Elastic IP `eipalloc-0c92c5288b99c278c`, assoc `eipassoc-01988cbd8041a381e`, eni `eni-084ab74cc3169b555`, attached to `i-088b7969158c43bca` |
| The old instance | `aws ec2 describe-instances --region ca-central-1` | `i-088b7969158c43bca`, t3.small, **running**, launched 2026-07-07 |
| Old site contents | `aws s3 ls s3://abletrace-prod1 --recursive --summarize` | 227 objects, 20,169,545 bytes — hashed Angular chunks + `assets/` |
| New app serves the marketing site | Chrome, `https://trace.mintekfoodsafety.com` and `https://dev.mintekfoodsafety.com` | **Both show Home / Features / Testimonials / Contact Us / Login** — identical to `abletrace.ca` |
| Why it does | `grep -rn "path: ''" ~/abletrace-lab-frontend/src/app/app-routing.module.ts` then `sed -n '1,50p'` | first `path: ''` loads `./home/home.module` → `HomeModule`, ahead of the dashboard shells |
| nginx names on `.101` | Minty's ChatGPT audit note 1, not re-measured | `trace.mintekfoodsafety.com`, `mintekfoodsafety.com` — **`abletrace.ca` absent**. Docroot `/var/www/html`, proxies to `localhost:1337` |
| **No SPF record exists** | the 20-record dump above | apex TXT is the Zoho verification string only. No `v=spf1` anywhere in the zone |

### The eighteen records that must not be touched

Zoho `MX 10 mx.zoho.com` · apex TXT `zoho-verification=zb15310048...` · `zmail._domainkey` TXT · **8 SES DKIM CNAMEs** (`*._domainkey.abletrace.ca` → `*.dkim.amazonses.com`) · `_amazonses.abletrace.ca` TXT · `_dmarc` TXT (`p=none`, `adkim=r`, `aspf=r`) · two ACM validation CNAMEs · NS · SOA.

⚠ **Only the two site records change, ever.** Email breaks silently if the others are disturbed.

### Analysis — what S142 settled so S143 does not reopen it

**`abletrace.ca` is not a parked domain and not a brochure site.** It is the old AbleTrace Angular app, whose root route is the marketing site (Home, Features, Testimonial, Contact Us, Login). Proven on screen.

**The new app has exactly the same shape** — same marketing pages at the root, login at `/login`, dashboards behind `AuthGuard`. Proven on screen at both `trace.` and `dev.mintekfoodsafety.com`, and in `app-routing.module.ts`.

**Therefore the cutover loses nothing and needs nothing built.** S143 is a domain move, not a cutover of function. This was the open question at the start of S142 and it is closed.

⚠ **AbleTrace still has no page explaining itself to a stranger beyond those four tabs.** That is a marketing gap, not an infrastructure one, and it does not block anything.

**There is no SPF record for the domain.** Mail works because DMARC is `p=none` with relaxed alignment and both senders publish DKIM — Zoho at `zmail._domainkey`, SES via the 8 CNAMEs. ⚠ **Adding SPF is an improvement, not a repair, and belongs in its own session.** Minty's ChatGPT note 3 assumes an SPF record exists and asks for it to be preserved; there is nothing to preserve, and inventing one during a cutover could break mail that currently works.

**The zone is not moving.** Notes 1 and 3 both plan around reproducing records at a replacement DNS provider. Route 53 in the old account is on the permanent keep-list, so that sequence is not needed.

### Verify — S143 is done when

- `curl -I https://trace.mintekfoodsafety.com` still returns 200 — **the existing site was not broken**
- With the `/etc/hosts` line in place, `https://abletrace.ca` in Chrome loads the new app, login works, an email sends
- `certbot certificates` on prod lists a certificate covering `abletrace.ca` and `www.abletrace.ca`
- The two site records show TTL 60 in Route 53
- **`dig abletrace.ca` from a machine without the hosts entry still returns the CloudFront alias** — the public has not moved

---

## THE THREE-SESSION SHAPE

**S143 — prepare and prove.** Steps 1–5 above. Nothing public changes.
**S144 — cut over.** Change the two records to A → `15.157.38.101`. Verify on screen. Short session, high stakes, no second job in it. ⚠ **Update the QuickBooks redirect URI in the Intuit developer app in the same session — the OAuth callback breaks otherwise, even in sandbox.**
**S145 — retire.** A week after the new name is stable: CloudFront, the instance, the Elastic IP, the volume, `abletrace-prod1`, the `prodapi` record. Pointer first, resource second.

⚠ **The TTL wait is why S143 and S144 cannot merge.** The old TTL must expire before a 60-second TTL means anything.

**QuickBooks production approval (P267) comes after the domain move.** The launch URL and privacy policy URL are declared to Intuit; declaring `mintekfoodsafety.com` and then moving means going back mid-review.

---

## THE OLD ACCOUNT — DISPOSITION

Measured S142. ⚠ **Nothing on this list has been deleted.**

### Goes safely — nothing points at these

`abletrace-development1` · `stgapifrontend` · `abletrace-frontend1` · `ftp-transfer-abletrace` (empty) · 3 Lambda functions · 1 API Gateway REST API · 6 CloudWatch log groups · 5 EC2 key pairs · IAM user `abletracelab-ses-smtp-s35` and its key (**`ACCESSKEYLASTUSED = N/A` — never used, ever**).

Worth about $2/month. The value is tidiness, not saving.

### Stays — permanently, or until replaced

- **SES `ca-central-1`** — production access, 4 identities. The only working email path. New account 208073623096 was **denied**.
- **IAM user `abletrace260825-ses-sender` + key `AKIAVDGLJ3MUJM62YWFZ`** — what the app sends with. Last used 2026-08-27.
- **Route 53 zone `abletrace.ca`** — all 20 records.
- **`abletrace-fileuploads1`** — client documents and photos, filed by company id, from 2021. ⚠ **The only copy. The archive holds the rows that reference these files, not the files.**
- **Root + MFA** — now the only way in.

### Goes after a recheck

**After S144 proves the new site works** — about $58/month:
instance `i-088b7969158c43bca` · its volume and ENI · Elastic IP `3.98.223.126` (⚠ **the DNS record goes first, never the IP first** — the S138 subdomain-takeover lesson) · CloudFront `E311W5PD650CXV` · `abletrace-prod1` · the `prodapi.abletrace.ca` record.

**After Minty is comfortable** — $25.76/month: **the 6 manual RDS snapshots.** See the ruling below.

**Needs a question answered first:**
- **`s3_cloudfront` key `AKIAVDGLJ3MUH7IPS3W7` — last used 2026-07-08.** Something used it. It carries EC2 + S3 + SES + CloudFront + SSM + CodeDeploy full access. ⚠ **Ask what still points at this before disabling. Deactivate before deleting — deactivation is reversible.**
- **`ses` keys `AKIAVDGLJ3MUDCJBHJXH` (used 2026-08-12) and `AKIAVDGLJ3MUILD4K76I` (used 2026-06-11).** Almost certainly the P17 pair in git history.
- `s3` key `AKIAVDGLJ3MUIEVY5IWC` — idle since 2025-05-06.
- 7 EBS snapshots · 3 AMIs · CloudTrail bucket · **VPC at $20.03/month, unexplained at this size** — low urgency.

### Cost, July 2026, measured by `aws ce get-cost-and-usage`

`EC2 - Other 39.97` · `RDS 25.76` · `VPC 20.03` · `EC2-Compute 17.53` · `Tax 12.51` · S3 0.31 · Route 53 0.51 · SES 0.004 · CloudFront 0.0004. **About $116/month total; everything on the permanent keep-list costs under a dollar.**

---

## ⚠ THE RDS SNAPSHOTS — SETTLED, DO NOT RELITIGATE

The question was whether the 6 manual snapshots can go. **They can, but not yet.**

**Master data for all four old clients is duplicated in schema `abletrace` on the new account's prod RDS**, which is backed up with it. Measured S142:

```
mysql -e "SELECT c.id, c.company_name,
 (SELECT COUNT(*) FROM abletrace.materials m WHERE m.company_id=c.id) AS materials,
 (SELECT COUNT(*) FROM abletrace.formulations f WHERE f.company_id=c.id) AS recipes,
 (SELECT COUNT(*) FROM abletrace.companyagents a WHERE a.company_id=c.id) AS suppliers,
 (SELECT COUNT(*) FROM abletrace.companycustomers cu WHERE cu.company_id=c.id) AS customers
 FROM abletrace.company c WHERE c.id IN (164,181,183,184,213,240,366,378,418,419);"
```

| id | company | materials | recipes | suppliers | customers |
|---|---|---|---|---|---|
| 164 | Mava Foods | 0 | 0 | 0 | 0 |
| 181 | Mava Trial | 204 | 167 | 18 | 0 |
| 183 | mavatrial1 | 204 | 0 | 18 | 0 |
| **184** | **mavatrial2** | **310** | **171** | **25** | **13** |
| **213** | **Kans Gourmet Foods Trial** | **79** | **101** | **25** | **21** |
| 240 | Kans Gourmet Foods | 75 | 31 | 22 | 0 |
| 366 | Truffle | 43 | 14 | 9 | 172 |
| 378 | Truffle Pig | 26 | 14 | 9 | 172 |
| 418 | Truffle | 28 | 19 | 9 | 175 |
| **419** | **hagensborg** | **34** | **84** | **10** | **175** |

⚠ **`164 Mava Foods` is an abandoned registration — empty.** Mava's real record is **184 mavatrial2**. Anyone reading "Mava Foods, 0 materials" and concluding the data is missing will reach the wrong answer.

**Kiron was part of Kans Gourmet** — Minty, S142. The `kiron04@` / `kiron05@` rows are mailinator tests, not a client.

**Schema sizes:** `abletrace` 78 tables / ~291,958 rows · `abletrace-dev` 66 / ~57,441 · `abletracelab_live` 77 / ~9,260.

⚠ **Master data is database data.** Materials, suppliers, customers and recipes are rows, not files. `abletrace-fileuploads1` holds PDFs and JPEGs whose filenames name no company — the rows that give them meaning are in the database. **The bucket and the snapshots are not copies of each other, and neither substitutes for the other.**

**A snapshot cannot be inspected without restoring it**, which restarts the extended-support cost that removing the instance escaped. Read identifiers, sizes and dates — never restore to look.

**Recommendation, not yet a ruling: wait a few weeks, then delete.** Nothing is lost by waiting; the whole $25.76 is available whenever Minty says.

---

## WHAT S142 CHANGED

**Six IAM console passwords deleted in old account `350466202408`**, each verified `NoSuchEntity` straight after:

`Bobby1` (**AdministratorAccess**, password since 2022-07-21, no keys) · `Brijesh` (**AdministratorAccess** + Route 53, since 2022-01-26, no keys) · `sudhirv` (since 2024-06-17, no keys) — **all three past developers, Minty's ruling S142** · `s3` · `s3_cloudfront` · `ses` — three service accounts that had browser logins they never needed.

**All five access keys confirmed Active afterwards**, including the live SES sender. **`AccountMFAEnabled = 1`.**

**P260 is therefore partly done** — `Bobby1`'s login is gone; the user, its policies and `abletracelab-ses-smtp-s35` remain.

**P263 is done as an audit.** The disconnection half is now sequenced into S143–S145 above.

⚠ **A console review by eye missed the running EC2 instance, the 6 RDS snapshots, the 7 EBS snapshots, the 3 AMIs, the Lambdas, the API Gateway and the whole IAM position.** The scan found them in twenty minutes. **Scan, do not click** — and the scan script is worth keeping for the next account audit.

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
