# SECTION 3B — ARCHITECTURE & INFRASTRUCTURE

> Everything the app RUNS ON. Different knowledge from 3A, reached at a different moment: a client bug → 3A. A deploy, a key, a reboot → 3B. They almost never overlap.
>
> **⚠ HOW THIS SECTION WAS BUILT (S79) — read once, then trust the blocks.** Old Section A had grown by append for ~30 sessions and had become TWO-HEADED: its top half (A1–A25, stamped S42) contradicted its own bottom half (appends through S71) on nine load-bearing facts. It also carried a "correction" that was itself the error — it asserted the boxes were t2.small, which S73 disproved in the console. ⚠ THEREFORE A'S TOP HALF WAS NOT COPIED FORWARD. Blocks 3B.2 / 3B.3 / 3B.4 are rebuilt from Section 1's S72 console-verified infrastructure block; A contributed only its S53-onward append-era material. Roughly half of A was not infrastructure at all and was routed to §2 / 3A / §4 — see the ROUTING RECORD at the foot of this section.
>
> **⚠ VERIFICATION STATUS.** Facts marked `[S72 CONSOLE]` were read off the AWS console in S72. Facts marked `[A-append]` come from Section A's dated appends and were NOT re-verified at build time. Facts marked `⚠ UNVERIFIED` need a look before being relied on. Nothing here is stamped "confirmed" without saying by whom and when — that stamp is what caused the A collapse (0.1a).

---

## 3B.1 THE PICTURE — read this first

```
THE STACK      Angular  →  Nginx (80/443)  →  Sails.js (internal 1337)
               →  RDS MySQL 8.4 (3306)

               Frontend is a static bundle served from /var/www/html.
               The API is proxied at /api/ to localhost:1337.
               Nothing else sits between them.

THREE          ⚠ THERE ARE THREE ENVIRONMENTS, not two. Old Section A
ENVIRONMENTS   said two for ~30 sessions and it was wrong.

  PROD    trace.mintekfoodsafety.com   NEW account   ⚠ LIVE CLIENT
  DEV     dev.mintekfoodsafety.com     NEW account   true twin of prod
  OLD APP abletrace.ca                 OLD account   2 legacy clients
                                                     → see 3B.10

TWO AWS        NEW  208073623096  the live app: EC2 · RDS · S3 bucket
ACCOUNTS       OLD  350466202408  the old app · abletrace.ca DNS in
                                  Route 53 · SES for abletrace.ca
               ⚠ THE NEW APP STILL DEPENDS ON THE OLD ACCOUNT for two
               things: outbound email (SES) and abletrace.ca DNS. The
               old account is NOT closeable until those move. → 3B.10

MODULES        One app, one URL, two modules (Traceability + Food
               Safety), shared backend and DB. Module-based licensing.
               ⚠ The licensing LOGIC is domain, not infra → §2 A7.
```

---

## 3B.2 THE BOXES

```
                    [S72 CONSOLE — the authority for this block]

PROD   abletrace-lab-prod   i-0b54ae374250348e0   t3.small   Running
DEV    abletrace-lab-dev    i-098e2cc59844d9ef3   t3.small   Running
       Region ca-central-1b. Both in the NEW account.

⚠ BOTH ARE t3.small (2 GB). Section A asserted t2.small as a
  "CORRECTION, EC2 console confirmed" — that assertion was FALSE and
  the original t3.small record was right (S73, rule 0.1a). The RAM
  conclusion is unaffected either way: 2 GB cannot build Angular.

PROD ELASTIC IP   15.157.38.101   (permanent, public)
DEV ELASTIC IP    16.55.10.205    (eipalloc-0c1a1db8451091427)
⚠ Two other EIPs in the account (15.223.243.179, 16.54.131.69) are
  RDS-MANAGED — not releasable, not associable. Leave them. [J63]

OS         Ubuntu 26.04 "resolute", kernel 7.0.0-1004-aws.  [A-append S61]
           ⚠ NOT 24.04 — that was A1's stale value. The OS moved during
           the S56 upgrade window.
NODE       v18.20.8 on the box; CI pins Node 18 to match.

⚠ "SYSTEM RESTART REQUIRED" — PENDING SINCE S35, STILL SHOWING.
  Do NOT reboot casually and do NOT reboot mid-work. It is its own
  clean step: verify pm2 resurrects on the 26.04 kernel (pm2 save /
  pm2 startup) BEFORE relying on it, then reboot standalone.
  ⚠ DO DEV FIRST — it is a true twin, so it is a real rehearsal. → P21

PM2        prod = abletrace-backend      dev = abletrace-dev
           ⚠ NEVER `pm2 restart all`. Always the NAMED process.

NGINX      PROD /etc/nginx/sites-enabled/abletrace
                ⚠ A REAL FILE, not a symlink. Two server_names. Carries
                an HSTS header. Patch against its own text, never dev's.
           DEV  /etc/nginx/sites-available/dev.mintekfoodsafety.com
                symlinked into sites-enabled.
           Both serve /var/www/html with SPA fallback
           (try_files $uri $uri/ /index.html) and proxy /api/ to
           localhost:1337.
```

### SSH

```
KEY        ~/.ssh/abletrace-lab-key.pem   ON THE MAC, chmod 600.
           Fingerprint SHA256:g0mRgRAw2QXrdROdBHVeLPU6myZA8CAOsWDvc0GK76U
           Verify any copy: ssh-keygen -lf <path>
           Backup in Drive Master Brief (abletrace-lab-key-BACKUP.pem).
           ⚠ Never keep it in Downloads/Desktop — Drive stream mode
           deletes local copies.

⚠ scp AND ssh ALWAYS RUN FROM THE MAC. The pem does not exist on either
  box. If the prompt reads ubuntu@ip-172-31-... you are ON the box and
  scp will fail with "Identity file not accessible". `whoami` to check.

PROD       ssh -i ~/.ssh/abletrace-lab-key.pem ubuntu@15.157.38.101

⚠ DEV SSH — LEARNED THE HARD WAY S73, DO NOT RE-DERIVE:
  Dev SG inbound SSH/22 allows ONE IPv4 /32 — Minty's home address.
  ALWAYS connect with `ssh -4`. The Mac drifts onto IPv6, and a plain
  `curl ifconfig.me` reports a PHANTOM address; only `curl -4
  ifconfig.me` gives the real SSH source.
  IF DEV SSH TIMES OUT: run `curl -4 ifconfig.me`, put THAT /32 on the
  rule, connect with -4. ⚠ Prod SSH is more permissive so prod still
  connects — that difference IS the tell that it is a dev-SG issue.
  → P23 (add an IPv6 rule so this stops recurring).
```

### ⚠ PROMPT COLOURS — check before every command

```
[MAC]   cyan    ~/.zshrc   PROMPT='%F{cyan}[MAC]%f %n@%m %1~ %# '
[DEV]   green   ~/.bashrc  PS1='\[\e[1;32m\][DEV]\[\e[0m\] \u@\h:\w\$ '
[PROD]  red     ~/.bashrc  PS1='\[\e[1;31m\][PROD]\[\e[0m\] \u@\h:\w\$ '

RED = PROD = LIVE CLIENTS. Think before typing.
⚠ S70: commands landed on the wrong box twice. Harmless both times,
  but only by luck. If a box is rebuilt, re-add its prompt first.
```

---

## 3B.3 THE DATABASES

```
                    [S72 CONSOLE — the authority for the instances]

TWO SEPARATE RDS INSTANCES, both db.t3.micro, both Available:
  abletrace-lab-prod           the live database
  abletrace-lab-dev-s62-dev    dev's own (shrunk S72)

⚠ DEV IS A TRUE TWIN OF PROD on both box and database.
⚠ THEY ARE SEPARATE INSTANCES. The same fixture (company 464) has
  DIFFERENT ROW IDS on each. NEVER compare ids across boxes.

ENGINE     MySQL 8.4.9 (upgraded from 8.0.44 on 2026-07-01, Blue/Green).
           The upgraded instance took the ORIGINAL name and endpoint, so
           DATABASE_URL and ~/.my.cnf needed NO change.  [A-append S56]

PARAMETER  abletrace-mysql84 (family mysql8.4), NOT default.mysql8.4.
GROUP      ⚠ ITS LOAD-BEARING SETTING: mysql_native_password = ON.
           This is the ONLY reason the old mysql@2.18.0 driver still
           connects. default.mysql8.4 has it OFF and WOULD BREAK THE
           APP ENTIRELY. Any new 8.4 group MUST set it. → JR12

AUTO-MINOR ⚠ TURNED OFF on prod during the S56 pre-flight and still off.
UPGRADE    Leaving it off avoids surprise engine bumps.

BINLOG     24h retention, set S55, carried through the upgrade.
           Verify: CALL mysql.rds_show_configuration;  → JR12
```

### ⚠ TWO DATABASES ON THE PROD INSTANCE — NAME IT EXPLICITLY

```
abletracelab_live   THE LIVE DATABASE. Structure + logic + seed +
                    real client data.
abletrace           THE ARCHIVE. A folded client's real 2-year history,
                    ~160 MB, DORMANT. Kept, not migrated.

⚠⚠ A BARE `mysql` ON PROD LANDS IN THE ARCHIVE, because ~/.my.cnf
   carries `database=abletrace`. ALWAYS: `mysql abletracelab_live`.
⚠⚠ ANY FILE LOAD MUST NAME THE DB: `mysql abletracelab_live < file.sql`.
   A bare `mysql < file.sql` SILENTLY WRITES INTO THE ARCHIVE. Data-only
   dumps emit no USE line, so they follow whatever the client points at.

⚠ OLD SECTION A SAID "RDS database: abletrace" FOR ~30 SESSIONS. That
  is the archive. This is the single most dangerous stale fact A carried.
```

### ACCESS — the recipes

```
PROD       ~/.my.cnf exists (chmod 600). A bare `mysql` works but lands
           in the ARCHIVE — see above.

⚠ DEV      HAS NO ~/.my.cnf AT ALL. A bare `mysql` hits a nonexistent
           local socket. BUILD A TEMP CNF FROM .env, chmod 600, rm after.
           ⚠ dotenv PRINTS A BANNER TO STDOUT ("◇ injected env…").
           NEVER capture a `node -e` output into a shell variable — the
           banner lands in the variable and corrupts it. Hardcode
           `abletracelab_live`, or silence with 2>/dev/null.
           (S77 — cost 3 retries. This is P28, now homed here.)

⚠ mysqldump AND mysqlsh REJECT the `database=` line that plain mysql
  accepts. Strip it to a temp file:
    grep -v -i "database" ~/.my.cnf > /tmp/dump.cnf && chmod 600 /tmp/dump.cnf
    <tool> --defaults-file=/tmp/dump.cnf ...
    rm -f /tmp/dump.cnf          ⚠ it holds the password in PLAINTEXT

⚠ ON RDS mysqldump ALSO needs --single-transaction (RDS blocks the
  default FLUSH TABLES lock) and --column-statistics=0 when the client
  is newer than the server.

⚠ BANG TRAP: a grep or sed pattern containing `!` (e.g. an SQL comment
  /*!40000 ...*/) triggers bash history expansion. SINGLE-QUOTE it.
  Same mechanism as the git commit -m bang trap.
```

### REBUILD

```
⚠ THE FULL FRESH-DB REBUILD CHECKLIST IS SECTION 5's JR BLOCK, NOT HERE.
  Everything in the database that is NOT in git lives there — column
  adds, proc fixes, seed data, RDS config. None of it fails loudly.
  This block does not duplicate it; two homes for one fact is what
  rotted Section A.

  JR1 order of operations · JR2–JR4 columns · JR5–JR8 routines ·
  JR9–JR11 security/index/seed · JR12 RDS config · JR13 nginx ·
  JR14 off-git scripts.

⚠ THE STANDING RISK (JR foot): every source file named in JR lives in
  /home/ubuntu on the PROD box, which is NOT backed up off-instance.
  The Drive copy is not verified current. → P16
```

### PRE-UPGRADE RECORD

```
FULL DUMP   /home/ubuntu/abletrace-pre-upgrade-20260701.sql (116 MB,
            all 36 procs verified) + a copy in Drive Master Brief.
            Copied off with scp FROM THE MAC.  [A-append S56]

⚠ THE 8.0 ROLLBACK INSTANCE abletrace-lab-prod-old1 IS DELETED. It was
  to be deleted WITH a final snapshot — the only frozen record of the
  8.0 database. ⚠ THAT SNAPSHOT'S EXISTENCE IS UNVERIFIED. → P3
```

---

## 3B.4 THE PIPELINE

```
⚠⚠ THE BOX CANNOT BUILD ANGULAR. THIS IS THE CENTRAL FACT OF THIS BLOCK.

   Root cause, settled S61: the box has ~1.9 GB RAM and an Angular prod
   build needs ~2 GB heap. It spills into swap and thrashes — looks like
   a hang, no OOM-kill line, just crawls for 10+ minutes.
   ⚠ NOT swap-missing (2 GB present and healthy). NOT the RDS upgrade
   (MySQL runs on a SEPARATE machine and cannot consume EC2 build RAM).
   NOT a stray process (box confirmed clean).
   ⚠ THE BOX WAS ALWAYS TOO SMALL. The old app never hit this because
   it built in CI for two years; that CI was deleted in S39, which
   silently pushed the build onto the box.

⚠ OLD SECTION A's A12 STILL CARRIED THE ON-BOX BUILD RECIPE AND
  "deploys manually, no CI/CD". Both were dead by S61. A12 is not
  folded — it is replaced by what follows.
```

### THE FLOW

```
1  BUILD      GitHub Actions. .github/workflows/build-frontend.yml,
              IN GIT (commit 1bf26deb), frontend repo.
              A PUSH to main auto-builds PROD.
              A MANUAL DISPATCH takes a `target` input (prod|dev).
              Runner ~7 GB RAM, Node pinned 18,
              NODE_OPTIONS=--max-old-space-size=4096. ~9 min.
              Artifact name: dist-<target>-<sha>

2  PROMOTE    ~/promote.sh ON THE MAC.
              Usage:  ~/promote.sh <artifact.zip> <dev|prod>
              Unzips → scp to the box's /home/ubuntu/dist-<label> →
              ssh and run deploy-frontend.sh there.
              ⚠ SAFETY GUARD: refuses to push a dist-dev-* artifact to
              prod, or dist-prod-* to dev. A dev build on prod would
              point live clients at the dev backend. Prod requires
              typing 'yes'.
              md5 362e2f297aec9f1843ba38c82484d6cb

3  DEPLOY     /home/ubuntu/deploy-frontend.sh, on BOTH boxes.
              Backs up /var/www/html → /home/ubuntu/www-html.bak-<label>,
              wipes, copies the new build in, prints the rollback line.
              Has set -euo pipefail, an empty-source guard, and a
              ${LIVE:?} guard on the rm -rf.
              md5 50e66fd427ebd31ff4502d4cd6b495a8

4  VERIFY     ⚠ CONFIRM THE ARTIFACT PREFIX MATCHES THE TARGET
              (dist-dev- / dist-prod-).
              ⚠ THEN Cmd+Q THE BROWSER. A hard reload does NOT clear
              lazy-loaded chunks — popups and the HACCP module cache
              separately from the main bundle. Empty-Cache-Hard-Reload
              and even LOGOUT do not do it. Only a full quit. [J66]

⚠ BOTH SCRIPTS ARE ON-BOX / MAC ONLY, NOT IN GIT. Drive is the only
  other copy and /home/ubuntu is not backed up. → JR14 · P16
```

### BACKEND DEPLOY — different, simpler

```
git pull on the box
pm2 restart <NAMED>        prod: abletrace-backend   dev: abletrace-dev
sleep 8
curl -s -o /dev/null -w "%{http_code}\n" localhost:1337    → expect 200

⚠ NO BUILD, NO CACHE CLEAR. Only the Angular BUILD was ever the RAM
  problem.
⚠ sleep 8 IS NOT OPTIONAL. A 000 immediately after restart is Sails
  still booting, NOT a crash. Re-curl after the wait.
⚠ NEVER `pm2 restart all`.
```

### ROLLBACK

```
Every deploy leaves /home/ubuntu/www-html.bak-<label>. Restore by
copying it back over /var/www/html.

CURRENT ROLLBACK POINTS:
  www-html.bak-prod-53db203d4ef4
  www-html.bak-dev-53db203d4ef4

⚠ PROD'S FRONTEND GIT CHECKOUT LAGS THE SERVED BUILD. It reads
  9bce0238 while prod SERVES 53db203d. The deploy swaps built files
  into /var/www/html; the git checkout is not what is served.
  ⚠ READING A FILE FROM PROD'S CHECKOUT SHOWS CODE THAT IS NOT LIVE.
  This caused a stale read in S70. Cosmetic to fix (a git pull tidies
  it) but a real diagnosis trap. → P8

⚠ SWEEP THE MAC's ~/Downloads. 11+ old build artifacts back to S61.
  promote.sh deploys whatever zip you name — a stale-zip promote is a
  real risk. → P12
```

---

## 3B.5 HEALTH CHECK — every session open (rule 1.1)

```
ON BOTH BOXES:
  1  git -C ~/abletrace-lab-frontend rev-parse --short HEAD
  2  git -C ~/abletrace-lab-backend  rev-parse --short HEAD
  3  git status                     → expect clean trees
  4  pm2 status                     → expect the NAMED process online
  5  curl -s -o /dev/null -w "%{http_code}\n" localhost:1337  → 200

⚠ AFTER ANY BACKEND RESTART: sleep 8 before the curl. 000 = booting.
⚠ COMPARE THE REAL HEADS AGAINST SECTION 1'S CLAIM. If they differ,
  STOP and reconcile THE RECORD before doing any work.
  (S70 opened by chasing a delta that did not exist — and that same
  unrecorded commit turned out to be the cause of the client's bug four
  hours later. J77.)
⚠ NOTE THE ROLLBACK POINTS BEFORE TOUCHING ANYTHING.

⚠ PROD'S FRONTEND CHECKOUT WILL READ STALE (see 3B.4). Judge prod's
  frontend by the SERVED bundle, not the checkout.
```

---

## 3B.6 DOMAINS · DNS · SSL

```
⚠ THE TWO ZONES LIVE IN DIFFERENT PLACES. This is the trap.

mintekfoodsafety.com    DNS at GODADDY.
                        Nameservers ns15/ns16.domaincontrol.com.
                        ⚠ NOT Route 53, NOT the old account.
                          trace  → prod
                          dev    → 16.55.10.205 (A record, TTL 600)

abletrace.ca            Registered at GoDaddy but DNS HOSTED IN
                        ROUTE 53 IN THE OLD AWS ACCOUNT (350466202408).
                        GoDaddy's nameservers point at Route 53.
                        ⚠ SO abletrace.ca DNS CHANGES GO IN THE OLD
                          ACCOUNT'S ROUTE 53, NOT GODADDY.
                        ⚠ THAT ZONE ALSO HOLDS THE LIVE ZOHO MAIL
                          RECORDS (MX/SPF/DKIM/DMARC). BE SURGICAL.

Verify:  dig dev.mintekfoodsafety.com +short   → 16.55.10.205
```

### SSL

```
DEV    Let's Encrypt via certbot (snap install --classic certbot).
       sudo certbot --nginx -d dev.mintekfoodsafety.com \
         -m info@abletrace.ca --agree-tos --no-eff-email --redirect
       Auto-renew scheduled. Files under
       /etc/letsencrypt/live/dev.mintekfoodsafety.com/
       ⚠ Registered WITH an email so renewal warnings arrive.

PROD   ⚠ REGISTERED WITH NO EMAIL. Confirmed via
       `sudo certbot show_account` → "Email contact: none".
       ⚠ SO PROD GETS NO RENEWAL WARNINGS. Worth fixing.
```

### THE FUTURE MOVE — app.abletrace.ca

```
PLAN (locked S52, still the plan): keep trace.mintekfoodsafety.com live
now; later re-onboard the 2 old clients onto THIS app (procedures-only,
fresh start, NO raw-data migration); THEN switch the address to
app.abletrace.ca; THEN the old account becomes closeable.
abletrace.ca itself stays as a marketing site.

A DOMAIN MOVE IS FOUR THINGS: DNS · nginx server_name · SSL cert ·
CORS/cookie-domain. Server, code, DB and IP unchanged.

EDIT POINTS WHEN READY:
  frontend  src/environments/environment.prod.ts  apiUrl
            ⚠ currently mislabelled with a "// dev server" comment
  backend   config/env/production.js  UI_Base_Url (line ~24, outbound
            email and reset links) + CORS origins (lines ~151, ~250)

⚠ SEQUENCING: the two old-account IAM keys (→ 3B.8, P17) are deactivated
  AFTER this switch, per Minty — to keep the old account undisturbed
  during the move.
⚠ THE ENV-DRIVEN-URL half of the S53 dev/prod plan was NEVER DONE. These
  edit points still stand as hardcoded values.
```

---

## 3B.7 SERVICES

```
S3          Bucket abletrace-lab-fileuploads · ca-central-1 · NEW account
            IAM user abletrace-lab-fileuploads-user, policy scoped to
            this bucket ONLY.
            Structure: bucket → companyID/ → category/ (Agent, Material,
            PurchaseOrders, ReceiveLots) → UUID-named file.
            ⚠ FRIENDLY NAMES LIVE IN RDS, NOT S3.
            ACLs public-read enabled; bucket-policy public blocked. App
            uploads with ACL:"public-read".
            ⚠ Bucket name is HARDCODED IN 5 PLACES in s3Service.js.
            Future hardening: signed expiring URLs. Deferred.
            Old bucket abletrace-fileuploads1 (OLD account) untouched.

SES         ⚠⚠ EMAIL IS AWS SES VIA THE AWS SDK — NOT SMTP, NOT ZOHO.
            api/services/email.js calls SES.sendEmail(), region hardcoded
            ca-central-1, FROM_EMAIL=info@abletrace.ca.
            ⚠ IT AUTHENTICATES WITH A RAW IAM ACCESS KEY. The env vars
            are MISLEADINGLY NAMED: SMTP_USER holds the AKIA… 20-char
            key ID and SMTP_PASSWORD holds the 40-char secret.
            ⚠ DO NOT generate "SMTP credentials" in the SES console for
            this app — the SDK cannot use them. THIS MISTAKE COST ~AN
            HOUR IN S35.
            ⚠ THE IAM USER "ses" LIVES IN THE **OLD** ACCOUNT, where
            abletrace.ca SES is verified. → 3B.10
            SES is in PRODUCTION mode (50k/day), not sandbox.
            ⚠ KNOWN ISSUE: email.js .catch SWALLOWS send errors with no
            logging. Failures are INVISIBLE. Test by sending an invite
            and checking the inbox.

ZOHO        Inbound only — where humans READ mail. info@abletrace.ca is
            an ALIAS on Minty's existing Zoho user, not a separate
            mailbox or seat. Send-as is enabled in Zoho compose.
            ⚠ "Sent from" = SES. "Read at" = Zoho. Different systems.
            DNS records (MX/SPF/DKIM/DMARC) live in the OLD account's
            Route 53 → 3B.6.
            SPF authorizes BOTH: "v=spf1 include:zohomail.com
            include:amazonses.com ~all"

ZEBRA       Zebra ZT230-203dpi ZPL · Serial 52N224501603 · USB via hub.
            Driver: Zebra Browser Print (Mac), https://localhost:9101
            (test /available). Label 4"x4" (812x812 @203dpi), Code128,
            CI27.
            ⚠ A Java process may occupy port 9100 on Mac startup and
            block Browser Print → sudo lsof -i :9100, kill, reopen.
```

---

## 3B.8 CREDENTIALS — ⚠ POINTERS ONLY

```
⚠⚠ NO SECRET VALUE EVER APPEARS IN THIS SECTION, IN ANY REPO SECTION,
   OR IN ANY CHAT. Values live in SECTION H, which is Minty's alone and
   never enters the repo. This block says WHAT each secret is, WHERE it
   lives, and HOW to rotate it.

WHAT EXISTS
  DATABASE_URL      RDS connection. ⚠ PASSWORD MUST BE ALPHANUMERIC ONLY
                    — / : @ # ? ' " | break the connection-string parse.
  SMTP_USER         ⚠ actually an IAM key ID for SES (3B.7)
  SMTP_PASSWORD     ⚠ actually the IAM 40-char secret
  S3_ACCESS_KEY     NEW-account key
  S3_SECRET
  SESSION_SECRET    signs user sessions
  GitHub PAT        embedded in both repo remote URLs
  PEM key           SSH → 3B.2

WHERE      All backend secrets live in `.env` ON THE SERVER, never in git.
           ⚠ dotenvx loads .env at RUNTIME, so `pm2 env` does NOT list
           them. Verify by grepping .env for NAMES, never values.
           (Nearly chased a phantom "S3 broken" bug on this in S35.)

ROTATION   ⚠ GENERATE STRAIGHT INTO A FILE, NEVER PRINT TO SCREEN, NEVER
           PASTE INTO CHAT. openssl rand -hex 16 > /tmp/newpw.txt
           ⚠ AWS secrets can contain / and other chars that BREAK sed →
           use the /tmp-file + Python rewrite method for .env, NEVER sed.
           ⚠ NEVER nano for .env — line-merge and doubled-paste bugs.
           Order: cp .env to /home/ubuntu/.env.bak-<tag> → verify the new
           value AT SOURCE (mysql SELECT 1) → update .env → pm2 restart
           NAMED --update-env → sleep 8 → curl 200 → update Section H.
           ⚠ A fumble on a live DB password LOCKS THE APP OUT. Have the
           health check ready before starting.

PASSWORD   ⚠ App passwords are 10-char salt + MD5(password+salt), stored
HASHING    as salt(10)+hash(32) = 42 chars, no `$` prefix.
           ⚠ MD5 IS WEAK AND THIS IS KNOWN AND DEFERRED, not overlooked.
           A hash CANNOT be hand-generated without the plaintext, so
           copy-then-reset-through-the-app is the only clean path. [J52]

⚠ OUTSTANDING: TWO OLD-ACCOUNT IAM KEYS ARE STILL VALID and still in git
  history — the SES key and the s3_cloudfront key. They are deliberately
  left active because the 2 legacy clients MAY authenticate via them.
  ⚠ Sequenced AFTER the app.abletrace.ca switch. → P17 · J1 · 3B.10
```

---

## 3B.9 REPOS

```
FRONTEND   github.com/Mintygadhok/abletrace-lab-frontend
BACKEND    github.com/Mintygadhok/abletrace-lab-backend
DOCS       github.com/Mintygadhok/abletrace-lab-docs   ⚠ PUBLIC
           Claude reads this directly. Section H NEVER goes in it.
           Raw base: https://raw.githubusercontent.com/Mintygadhok/
           abletrace-lab-docs/refs/heads/main/
           ⚠ THE RAW URL LAGS SEVERAL MINUTES behind a fresh commit.
           The GitHub WEB VIEW is immediate truth. Do NOT conclude "it
           didn't commit" from a stale fetch.

USER       Mintygadhok. PAT in Section H — classic token, repo scope,
           expires 2027-06-10, embedded in both remote URLs.
           ⚠ PAT paste at the hidden prompt MIS-KEYS often. "Invalid
           username or token" → just retry.

GIT        DEV box identity is set (Minty Gadhok / msgadhok@gmail.com).
IDENTITY   ⚠ PROD's is NOT set — prod should not be committing anyway.
```

### ⚠ WHAT IS IN GIT AND WHAT IS NOT

```
IN GIT          all app code · .github/workflows/build-frontend.yml ·
                config/bootstrap.js dev-safety guard (b70ba10) ·
                src/assets/docs/help-guides/ (the 8 client-guide PDFs,
                deliberately bundled so they ride CI→promote)

⚠ NOT IN GIT    ~/promote.sh (Mac) · deploy-frontend.sh (both boxes) ·
                both nginx vhosts · SSL certs · .env · ~/.my.cnf ·
                EVERY stored procedure and view (~36 procs, 9 views) ·
                every DB column add · all seed data · RDS config
                → all of it is Section 5's JR block, the ONLY record

⚠⚠ A COMMITTED .sql IS DOCUMENTATION, NOT AN APPLIED MIGRATION.
   db-changes/S42-pack-cascade.sql sits in the backend repo and does NOT
   put the proc in any database. "In git" ≠ "in the DB". [J6]

⚠ NEVER a .bak inside api/models | controllers | config — SAILS LOADS
  EVERY .js AS LIVE CODE. Backups go to /home/ubuntu/ only.
⚠ git add <named files> — never `git add .`
⚠ NO "!" in a commit message — bash history expansion aborts it.
```

---

## 3B.10 THE OLD APP — ⚠ ITS OWN BLOCK, AND IT IS NOT DEAD

```
WHAT IT IS      The previous AbleTrace, in AWS account 350466202408.
                App https://abletrace.ca · API https://prodapi.abletrace.ca
                Hosted on GitLab, not GitHub.
                ⚠ TWO LIVE CLIENTS ARE STILL ON IT.

⚠⚠ THE NEW APP DEPENDS ON THE OLD ACCOUNT FOR TWO LIVE THINGS:
   1. SES — the IAM user "ses" and abletrace.ca's SES verification
      live there. ALL OUTBOUND EMAIL FROM THE NEW APP GOES THROUGH IT.
   2. DNS — abletrace.ca's Route 53 zone lives there, including the
      live Zoho mail records.
   ⚠ SO THE OLD ACCOUNT CANNOT BE CLOSED until both move.

⚠ ANY REFERENCE TO abletrace.ca API = OLD. NEVER TOUCH THE OLD APP OR
  SERVER until the Step-2 migration. Editing abletrace.ca DNS/mail
  records in Route 53 is fine and does NOT touch the old app.

TWO IAM KEYS    ses …ILD4K76I · s3_cloudfront …H7IPS3W7
                Both still VALID, both in git history, both deliberately
                left active — the 2 legacy clients MAY authenticate via
                them, and deactivating blind could break a live app.
                ⚠ The s3_cloudfront key was ALSO found hardcoded in two
                frontend GitHub Actions workflow files; those were
                deleted (df4cf421) so the LIVE-TREE exposure is closed,
                but the key is still valid and still in history.
                ⚠ EXPOSURE REDUCED, NOT CLOSED. → P17 · J1

⚠ THE SIZING EVIDENCE — DO NOT UPSIZE PROD ON A HUNCH:
  the old app ran TWO LIVE CLIENTS FOR TWO YEARS on a t3.small app box
  and a db.t3.micro database. Prod's current sizing is fine. S73 argued
  prod-on-micro was a risk; the evidence beat the reasoning. (0.1a)

OLD BOXES       devapi_windows / stgapi_windows — old account, STOPPED.
                Their DB passwords (sudhirv / sudhirVstg) still exist but
                there is ZERO BRIDGE to the new account: a MySQL password
                is scoped to its own instance and is NOT an AWS
                credential. Harmless until torn down. [J33]
```

---

## 3B.11 WHEN IT BREAKS — triage

```
SYMPTOM                          LIKELY CAUSE / WHERE TO LOOK

⚠ ANY HIDDEN ERROR               GO TO THE BROWSER CONSOLE FIRST.
                                 nginx-level rejections (413/502) NEVER
                                 reach pm2 logs — Sails never runs. And
                                 the alert() plague renders everything as
                                 "[object Object]". S71 lost ~40 min to
                                 this. (JT18 · P4)

Cannot SSH to dev                Mac drifted to IPv6. curl -4 ifconfig.me,
                                 update the /32, connect with ssh -4.
                                 ⚠ Prod still connecting is the TELL.
Cannot SSH at all                pem is on the MAC, not the box, and not
                                 in Downloads.
Cannot connect to RDS            Mac IP changed → add to the RDS SG, or
                                 connect FROM the EC2 box.
App 502                          pm2 down → pm2 status, restart NAMED.
App shows wrong data             environment.prod.ts apiUrl pointing at
                                 the wrong host.
Built but site unchanged         the deploy did not run, or the browser
                                 cached a lazy chunk → Cmd+Q. (J66)
Upload fails silently            file >10MB → nginx 413, invisible to
                                 Sails. (JR13 · P4)
GitHub push fails                PAT expired or mis-keyed → retry, then
                                 regenerate and reset both remotes.
Email not sending                It is SES via SDK. Check SMTP_USER/
                                 PASSWORD hold a valid IAM key (40-char
                                 secret), NOT SMTP creds. ⚠ Errors are
                                 SWALLOWED — test by sending an invite.
S3 upload fails                  grep .env for the key NAMES; pm2 env
                                 will not show them (dotenvx).
Mail to abletrace.ca missing     Route 53 in the OLD account → MX must
                                 point at Zoho.
A rail module / tile missing     ⚠ IT IS DATA, NOT CODE → 3A.8 and §2
                                 Logic E. Check roles / role_task /
                                 company_user_role / company_user_task.
A record "missing" from a list   ⚠ CHECK THE DB FIRST. Usually wrong
                                 company view, version-superseding, or a
                                 stale view — NOT a save failure. (JT12)
Multi-level product reads 1/1/1  the packing proc lost whd_flag +
                                 pack_level → JR6.
HACCP plan rows out of order     a fetch proc lost its ORDER BY step →
                                 JR5. ⚠ FOOD-SAFETY CRITICAL.
A quantity shows an ugly         units↔Kg basis mismatch. ⚠ Diagnostic:
fraction (0.5128…#)              a clean fraction like 1÷wgt is the
                                 FINGERPRINT of a units-stored field
                                 being divided. → §2 Core #1, 3A.5.
```

### ⚠ SHELL TRAPS THAT COST REAL TIME

```
STUCK PASTE BUFFER      If the shell replays old scrollback, OPEN A
                        FRESH TERMINAL WINDOW. It is the only reliable
                        clear. Bit 3× in S70 alone.
LONG PASTES TRUNCATE    Long base64/heredoc one-liners truncate
                        MID-PASTE. Write a local file, then decode/pipe.
                        ⚠ macOS base64 needs `-i <file>`; the macOS
                        checksum tool is `md5`, Linux is `md5sum`.
MULTI-STATEMENT SQL     Must be SOURCED FROM A FILE (mysql < file), never
                        pasted as a heredoc — an inner `;` breaks the
                        CREATE, and a partial run can DROP a procedure
                        without recreating it. Happened mid-S38.
PATCHING FILES          Assert-anchored /tmp/patch.py written as ONE
                        paste, run separately. The assert must prove the
                        anchor appears EXACTLY ONCE.
                        ⚠ Verify on disk with sed -n / cat -A, never the
                        grep echo — grep output is a rendered screen and
                        can lie. (JT17)
THE LESS PAGER          Must be exited with `q` before the next command.
BUILD vs SERVE          Stop any local http.server holding dist/ BEFORE
                        building into it.
```

---

## ⚠ ROUTING RECORD — where the rest of old Section A went (S79)

```
Roughly half of Section A was never infrastructure. Recorded here so a
future reader does not go looking for it in 3B.

→ §2 (WHY)     A7 licence lifecycle · A11 quantity/HACCP/packing rules ·
               A16 NgRx pattern · A18 bulk actions + soft delete ·
               A6's module-licensing half
→ 3A           A9 · A10 · A15 file maps · A24 role/task nav (→ 3A.8 and
               §2 Logic E) · A6's module half
→ §4 (LOOK)    A23 design system — font, palette, tiles, rail.
               ⚠ THIS IS P1(b)'s INCOMING MATERIAL.
→ §5           A25 proc discipline (already JR) · the three S69 entries
               misfiled under A (they are J-entries: J71, J72, and a
               deploy record)
→ §0           A's "SESSION 0" block — wholly superseded by Section 0
→ DELETED      the S66 DEV ENVIRONMENT block, which appeared TWICE
               verbatim · "CURRENT POSITION (S42 close)", 37 sessions
               stale · A12's on-box build recipe · A13's "two
               environments" · A1's Ubuntu 24.04 and `abletrace`-as-live
               · the A-S61 "t2.small correction", which was itself wrong

⚠ ONCE THIS SECTION IS APPROVED, SECTION A IS DELETED, NOT EDITED. → P22
```

---

**END SECTION 3B**
