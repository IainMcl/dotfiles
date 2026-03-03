---
name: view-screenshot
description: View a screenshot file. Use when the user mentions a screenshot or asks you to look at one. If no filename is specified, find and use the most recent screenshot.
---

# View Screenshot

## Finding the screenshot

### If a filename is given
Search for it in the platform screenshot directories:

**Linux:** `/home/iainmclaughlan/Pictures/Screenshots/`
**macOS:** `~/Desktop/` and `~/Pictures/Screenshots/`

Use `Glob` to locate the file by name pattern.

### If no filename is given
Find the most recent screenshot using `Bash`:

**Linux:**
```bash
ls -t /home/iainmclaughlan/Pictures/Screenshots/ | head -1
```

**macOS:**
```bash
ls -t ~/Desktop/*.png ~/Desktop/*.jpg 2>/dev/null | head -1
```

Use whichever platform the user is on. If unclear, try Linux first then macOS.

## Viewing the screenshot

Once the full path is resolved, use the `Read` tool to view the image file.
