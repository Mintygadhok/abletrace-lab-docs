# TRAPS — ADDITIONS FROM S92

⚠ APPEND THESE. Do not reorganise or cut anything already in TRAPS.
⚠ Insert the one-line edit to the existing "NOT SECURE" entry where
  shown, then append the rest at the end of the file.

---

## EDIT TO THE EXISTING ENTRY

Find: **JT — "NOT SECURE" HAS MORE THAN ONE CAUSE, AND NEITHER IS THE SERVER**

Append inside that block, after the S91 line:

```
S92  Chased TWICE MORE in one session, on a second Mac. Same two
     causes, no new mechanism. FOURTH AND FIFTH TIME.
⚠ AND THE SEPARATE, PERMANENT CASE — see the localhost entry below.
  Do not confuse them: on an app URL the chip is a fault to clear,
  on localhost:9101 it is normal forever.
```

---

## JT — LABEL PRINTING HAS THREE BARRIERS, NOT ONE

```
S91 documented ONE barrier — the self-signed certificate — and closed
the question. S92 walked a clean second Mac as a client and found
THREE, all real, all required, and they fire in a FIXED ORDER:

  1 CERTIFICATE        Browser warning at https://localhost:9101.
                       Cleared via Advanced → Proceed.
                       Scope: PER BROWSER, PER USER. Stored: browser.

  2 CHROME LOCAL NET   "<site> wants to Access other apps and services
                       on this device"   Block / ALLOW
                       Scope: PER BROWSER, PER SITE. Stored: Chrome
                       site settings.

  3 BROWSER PRINT      "<site> wants to access your Zebra Devices.
                       Allow <site> and add it to the accepted hosts
                       list?"   Cancel / No / YES
                       Scope: PER USER, PER HOSTNAME. Stored: Browser
                       Print's own Accepted Hosts list.

⚠ THE ORDER IS FIXED AND IT IS WHY ONLY ONE WAS EVER SEEN. Barrier 1
  blocks the connection outright, so 2 and 3 CANNOT FIRE until it is
  cleared. S91 cleared the certificate, saw printing work, and
  concluded the certificate was the whole story. It was the first
  gate of three.

⚠ 2 AND 3 FIRE ON THE FIRST PRINT, NOT DURING INSTALL. Anyone
  documenting setup and stopping at "it prints" will miss both.

⚠ CLICKING Block OR No BREAKS PRINTING SILENTLY AND PERMANENTLY, and
  the two are undone in DIFFERENT PLACES:
    Chrome  Settings → Privacy and security → Site settings → the site
    Browser Print  menu bar icon → Settings → Blocked Hosts →
                   Delete Selected
  The app shows only "print failed" for either.

⚠ PER HOSTNAME, PROVEN: dev.mintekfoodsafety.com and
  trace.mintekfoodsafety.com are SEPARATE Accepted Hosts entries.
  Testing on dev does NOT pre-authorise prod.

⚠ BROWSER PRINT'S CONTROLS ARE IN THE MENU BAR, TOP RIGHT, NOT THE
  DOCK. Clicking the Dock icon appears to do nothing. Cost real
  minutes in S92 to somebody who already knew the app existed.

⚠ THE WIDER SHAPE: "it worked after I did X" identifies A barrier,
  never THE barrier — because a gate that is still closed downstream
  cannot announce itself. Same family as S90's kill-and-reopen, where
  two faults had one fix each and the record collapsed them into one
  mystery. When a fix works, ask what ELSE would have been invisible
  until that moment.
```

---

## JT — ON localhost, "NOT SECURE" IS PERMANENT AND MEANS NOTHING

```
Accepting a self-signed certificate stops the browser BLOCKING the
connection. It does NOT turn the padlock green. The chip on
https://localhost:9101 reads Not Secure forever, on every machine,
including while printing works perfectly.

PHOTOGRAPHED S92, one screen: chip red "Not Secure", printer listed in
full (usb#vid_0a5f&pid_00d5#52N224501603, ZPL), label printed.

⚠ THE TRAP: this is the SAME CHIP that has been a real fault twice on
  app URLs (see the Not Secure entry above). On localhost it is
  meaningless. Reading it as a health indicator will mislead every
  time, and a client will read it exactly that way.

⚠ NOW IN THE CLIENT GUIDE for that reason.
```

---

## JT — A HANDOVER NOTE IS NOT THE RECORD. NOW SUPERSEDES IT.

```
S92 opened with an S92-opening-note.md written DURING S91, before
S91 finished. Claude read it as current and told Minty that the
275c0250 prod artifact still needed promoting and that P72 had not
reached Glutenull.

BOTH WERE ALREADY DONE. NOW.md, written at S91 CLOSE, recorded the
promote to dev AND prod with scanner verification. The note also
listed P75, P76 and P78 as new/open when NOW had all three closed,
and described P58 as a different item entirely.

⚠ THE RULE: a note written mid-session freezes at the moment it was
  written. NOW.md is rewritten at CLOSE and is the only current
  record. WHERE THEY DISAGREE, NOW WINS — always, without checking.

⚠ WHY IT MATTERS MORE THAN IT LOOKS: the note is pasted FIRST and
  reads as a brief, so it frames everything after it. Claude acted on
  it for two turns before NOW arrived and contradicted it.
```

---

## JT — "A JAVA PROCESS" AND "A SECURITY WARNING" NAME NOTHING

```
Extension of the existing Browser Print / java entry, same shape,
different surface.

S92: Minty reported "a security warning which said something about
accessing your other apps". Claude inferred a macOS permission prompt
and reasoned from there. IT WAS CHROME'S OWN local-network prompt —
different mechanism, different place to undo it, different platform
behaviour.

⚠ THE RULE: a half-remembered dialog is a CATEGORY, not an identity.
  "A security warning", "a java process", "a permission popup" — all
  name a shape and no more. Get the WORDING, or a photograph, before
  building anything on it. The wording is one screenshot away and the
  inference is always cheaper and always worse.
```

---

## JT — THE ZEBRA DOWNLOAD PATH IS NOT WHERE ANYONE LOOKS

```
Browser Print is NOT under support.zebra.com's "Drivers and
Downloads". It is on the main site:
  zebra.com/us/en/support-downloads/software/printer-software/
    browser-print.html
Breadcrumb: Support and Downloads → SOFTWARE → Browser Print.

⚠ THE DANGER IS NOT GETTING LOST. "Drivers and Downloads" leads to a
  printer DRIVER, which installs the macOS print path and invites
  adding the Zebra in Printers & Scanners — the exact thing the client
  procedure forbids. The wrong door does not dead-end, it succeeds at
  the wrong thing.

⚠ The link is labelled "Download Browser Print For OSX", not Mac.
⚠ The form is plain — country, name, company, email. NO ACCOUNT AND
  NO MFA, despite the site-wide MFA banner (effective 1 July 2026).
```
