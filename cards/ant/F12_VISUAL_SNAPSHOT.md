# F12 VISUAL SNAPSHOT CARD
**CARD_ID:** F12-004 | **Phase:** SNAPSHOT | **Role:** DevTools Sentinel Ant
**INPUTS:** Page inventory from F12-001, console + network findings
> Read this card after F12_NETWORK_AUDIT. Follow every □ item for EACH page.

## 1. CAPTURE VISUAL BASELINE
□ For each page in inventory:
  □ `select_page` (if multiple tabs)
  □ `take_screenshot` → save as evidence (format: png)
  □ `take_snapshot` → capture a11y tree (DOM structure)
  □ Record page load time (from network waterfall timing)

## 2. VISUAL CHECK (per page)
□ Review screenshot:
  □ Page renders without white screen / blank content?
  □ No visible layout breakage (overlapping elements, cut-off text)?
  □ No broken images (check for alt text in snapshot)?
  □ Loading states resolved (no infinite spinners)?
□ Review snapshot:
  □ Key interactive elements present? (buttons, links, forms)
  □ ARIA labels present on interactive elements?

| # | Page | Screenshot | Snapshot | Load Time | Visual Status |
|---|------|-----------|----------|-----------|---------------|
| 1 | {route} | {path} | {path} | {ms} | {OK / ISSUE: desc} |

## 3. DARK MODE CHECK (optional — if app supports it)
□ `emulate(colorScheme: "dark")`
□ `take_screenshot` → save as dark mode evidence
□ `emulate(colorScheme: "auto")` → reset
□ Note any contrast or visibility issues

## 4. SENTINEL VERDICT
□ Aggregate ALL findings from F12-002 + F12-003 + F12-004:

```
DEVTOOLS SENTINEL VERDICT
═════════════════════════
Pages inspected: {N}
Console: {N blocking, M advisory}
Network: {N blocking, M advisory}
Visual:  {N issues}

VERDICT: PASS / FAIL_ADVISORY / FAIL_BLOCKING

BLOCKING:
  {numbered list with evidence}

ADVISORY:
  {numbered list with evidence}

SPECIALIST TRIGGERS:
  ⚡ Perf: {reason or NONE}
  🌐 Network: {reason or NONE}
```

□ Save verdict to DEVTOOLS_REPORT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Sentinel complete. Verdict: {VERDICT}. Specialist triggers: {list or NONE}.
Do NOT produce specialist card output in this same response.
Hand off to BECCA for specialist dispatch decision.
```

## STOP CONDITIONS THIS PHASE
- Screenshot fails → note failure, continue with snapshot only
- Page crashes during snapshot → record as visual FAIL_BLOCKING
