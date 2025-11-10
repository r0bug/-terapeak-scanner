# Terapeak Barcode Scanner Setup Guide for Ubuntu

Complete setup guide for the automated barcode scanning tool for eBay Terapeak.

---

## Quick Start

```bash
# 1. Run the installation script
chmod +x install_terapeak_scanner.sh
./install_terapeak_scanner.sh

# 2. Run the scanner
python3 terapeak_barcode_scanner.py
```

---

## What This Tool Does

✅ Opens Chrome browser to eBay Terapeak
✅ Automatically detects when you scan a barcode
✅ Submits the search automatically
✅ Clears the search field for the next scan
✅ Continuous scanning mode - scan as many items as you need
✅ Logs all scans for record keeping

---

## Requirements

- **Ubuntu 20.04 or later** (or any Debian-based Linux)
- **Python 3.8+** (usually pre-installed)
- **Chrome browser** (will be installed if needed)
- **USB barcode scanner** (configured to send Enter after scan)
- **Active eBay account** with Terapeak access (free for sellers)

---

## Installation

### Option 1: Automatic Installation (Recommended)

```bash
# Download and run the installation script
cd /home/ynebay/Ebaytools
chmod +x install_terapeak_scanner.sh
./install_terapeak_scanner.sh
```

### Option 2: Manual Installation

```bash
# 1. Update system
sudo apt update

# 2. Install Chrome (if not already installed)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# 3. Install ChromeDriver
sudo apt install chromium-chromedriver

# 4. Install Python dependencies
pip3 install selenium

# 5. Make script executable
chmod +x terapeak_barcode_scanner.py
```

---

## Configuration

### Barcode Scanner Setup

Your barcode scanner needs to be configured to:

1. **Act as a keyboard input device** (most USB scanners do this by default)
2. **Send Enter/Return key after each scan** (check scanner manual)
   - Most scanners have a setting for "Suffix" or "Terminator"
   - Set it to send "CR" (Carriage Return) or "Enter"

**Testing Your Scanner:**
```bash
# Open a text editor
gedit test.txt

# Scan a barcode
# You should see: BARCODE_VALUE<newline>
# If the cursor moves to the next line, it's configured correctly!
```

---

## Usage

### Basic Usage

```bash
cd /home/ynebay/Ebaytools
python3 terapeak_barcode_scanner.py
```

**What happens:**
1. Chrome opens to eBay Terapeak
2. If you're not logged in, you'll be prompted to log in
3. Click on the search field
4. Scan barcodes with your scanner
5. Results appear automatically, field clears for next scan

### Interactive Mode

```bash
python3 terapeak_barcode_scanner.py --interactive
```

Uses polling to detect barcode input (alternative method).

### View Help

```bash
python3 terapeak_barcode_scanner.py --help
```

---

## Workflow

```
┌─────────────────────────────────────────┐
│  1. Start Script                        │
│     python3 terapeak_barcode_scanner.py │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  2. Browser Opens to Terapeak           │
│     (Log in if needed)                  │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  3. Click on Search Field               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  4. Scan Barcode                        │
│     Scanner types: "123456789012"       │
│     Scanner sends: Enter key            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  5. Script Detects Enter                │
│     Automatically submits search        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  6. Results Appear                      │
│     (View Terapeak data)                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  7. Field Clears Automatically          │
│     Ready for next scan                 │
└──────────────┬──────────────────────────┘
               │
               ▼
        (Back to step 4)
```

---

## Example Session

```
╔═══════════════════════════════════════════════════════════╗
║       TERAPEAK BARCODE SCANNER for Ubuntu                 ║
║                                                           ║
║  Automated barcode scanning for eBay Terapeak           ║
╚═══════════════════════════════════════════════════════════╝

2025-11-06 14:32:10 - INFO - Setting up Chrome browser...
2025-11-06 14:32:12 - INFO - Browser setup complete
2025-11-06 14:32:13 - INFO - Opening Terapeak at https://www.ebay.com/sh/research...
2025-11-06 14:32:16 - INFO - ✓ Terapeak page loaded
2025-11-06 14:32:16 - INFO - ✓ Found search input using selector: input[placeholder*='Search']

============================================================
✓ READY TO SCAN BARCODES
============================================================

Instructions:
1. Click on the search field in the browser
2. Scan a barcode (scanner will type it + Enter)
3. Script automatically processes and clears for next scan
4. Press Ctrl+C in terminal to exit

Waiting for barcode scans...

2025-11-06 14:32:45 - INFO - 📊 Barcode detected: 074108434343
2025-11-06 14:32:45 - INFO - Waiting for search results...
2025-11-06 14:32:50 - INFO - ✓ Search results loaded
2025-11-06 14:32:50 - INFO - ✓ Scan #1 complete
2025-11-06 14:32:52 - INFO - ✓ Search field cleared
2025-11-06 14:32:52 - INFO - Ready for next scan...

2025-11-06 14:33:15 - INFO - 📊 Barcode detected: 012345678901
2025-11-06 14:33:15 - INFO - Waiting for search results...
2025-11-06 14:33:20 - INFO - ✓ Search results loaded
2025-11-06 14:33:20 - INFO - ✓ Scan #2 complete
2025-11-06 14:33:22 - INFO - ✓ Search field cleared
2025-11-06 14:33:22 - INFO - Ready for next scan...

^C
============================================================
Scanner stopped. Total scans: 2
============================================================
2025-11-06 14:34:01 - INFO - Closing browser...
2025-11-06 14:34:02 - INFO - ✓ Browser closed
```

---

## Troubleshooting

### Issue: "chromedriver not found"

**Solution:**
```bash
sudo apt update
sudo apt install chromium-chromedriver
```

### Issue: "Chrome binary not found"

**Solution:**
```bash
# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

### Issue: Barcode scanner not working

**Check:**
1. Scanner is plugged in via USB
2. Scanner light turns on when you scan
3. Test in a text editor (gedit) - does it type the barcode?
4. Scanner is configured to send Enter after scan

**Common Fix:**
- Some scanners require configuration barcode to enable "Enter" suffix
- Check your scanner's manual for "Suffix" or "Terminator" settings

### Issue: Search field not found

**Solution:**
```bash
# Run with verbose logging to see what selectors are tried
python3 terapeak_barcode_scanner.py
```

The script tries multiple selectors automatically. If it still fails:
1. The Terapeak page structure may have changed
2. You may not be logged in to eBay
3. Check the log file: `terapeak_scanner.log`

### Issue: "You need to log in to eBay"

**Solution:**
1. The script will pause and prompt you
2. Log in manually in the browser window
3. Navigate to Terapeak
4. Press Enter in the terminal to continue

### Issue: Results not loading

**Solution:**
- The script waits 5 seconds for results by default
- Slow internet? Increase timeout in code:
  ```python
  # In terapeak_barcode_scanner.py, line ~165
  self.wait_for_results(timeout=10)  # Change from 5 to 10
  ```

---

## Advanced Configuration

### Change Wait Times

Edit `terapeak_barcode_scanner.py`:

```python
# Line ~215: Time to wait after results load (for viewing)
time.sleep(2)  # Change to your preference (in seconds)

# Line ~165: Timeout for results loading
def wait_for_results(self, timeout=5):  # Change timeout value
```

### Run in Background (Headless Mode)

Currently not recommended for this use case since you need to see the results!

---

## Logs

All activity is logged to: **`terapeak_scanner.log`**

```bash
# View recent logs
tail -f terapeak_scanner.log

# View all logs
cat terapeak_scanner.log

# Clear logs
> terapeak_scanner.log
```

---

## Keyboard Shortcuts

While the scanner is running:

- **Ctrl+C** - Stop the scanner gracefully
- **Ctrl+Z** - Pause (not recommended, use Ctrl+C instead)

In the browser:
- **Click search field** - Ensure it's focused for scanning
- **Ctrl+L** - Focus address bar if you need to navigate

---

## Tips & Best Practices

### For Best Results:

1. **Keep browser window visible** - You need to see the results!
2. **Don't minimize the browser** - Script needs the window active
3. **Wait for results to load** - Script pauses 2 seconds for you to view
4. **Clean barcodes** - Dirty/damaged barcodes may not scan correctly
5. **Steady scanning** - Don't rush, let each result load

### Workflow Tips:

1. **Have a notepad ready** - Write down interesting findings
2. **Use a second monitor** - Browser on one screen, notes on another
3. **Take breaks** - Scanning for hours can be tiring!
4. **Keep scanner charged** - If wireless, ensure good battery

### Safety Tips:

1. **Check what you're scanning** - Ensure barcodes are valid products
2. **Respect Terapeak terms** - Don't abuse the service with excessive requests
3. **Rate limiting** - The 2-second pause helps avoid overloading

---

## Features

✅ **Automatic Detection** - No manual clicking needed
✅ **Continuous Scanning** - Scan multiple items in sequence
✅ **Auto-Clear** - Search field clears after each scan
✅ **Logging** - All scans recorded with timestamps
✅ **Error Recovery** - Handles most common errors gracefully
✅ **User-Friendly** - Clear terminal output and instructions
✅ **Flexible** - Two modes (auto and interactive) for different scanners

---

## Limitations

⚠️ **Manual Login Required** - You must log in to eBay first time
⚠️ **eBay Terapeak Access Needed** - Free for eBay sellers with Seller Hub
⚠️ **Internet Required** - Real-time web access needed
⚠️ **Desktop Only** - Not suitable for headless servers
⚠️ **Ubuntu/Linux** - Designed for Ubuntu, may work on other distros

---

## Uninstallation

```bash
# Remove installed packages
pip3 uninstall selenium

# Remove Chrome (optional)
sudo apt remove google-chrome-stable

# Remove ChromeDriver (optional)
sudo apt remove chromium-chromedriver

# Remove script files
cd /home/ynebay/Ebaytools
rm terapeak_barcode_scanner.py
rm install_terapeak_scanner.sh
rm terapeak_scanner.log
```

---

## Support & Updates

**Log File**: Check `terapeak_scanner.log` for detailed error messages

**Common Issues**: See Troubleshooting section above

**Updates**: If Terapeak changes their interface, the script may need updates

---

## Technical Details

**Technology Stack:**
- Python 3.8+
- Selenium WebDriver
- Chrome/Chromium browser
- ChromeDriver

**How It Works:**
1. Selenium controls Chrome via WebDriver protocol
2. JavaScript event listener detects Enter key in search field
3. When Enter is detected (after barcode scan), value is captured
4. Script submits search, waits for results, then clears field
5. Loop continues until Ctrl+C

**Why This Approach:**
- Barcode scanners act as keyboard input devices
- They type the barcode digits followed by Enter
- Script detects the Enter key press as completion signal
- No need for special barcode libraries or drivers

---

## Security & Privacy

✅ **No data collected** - Everything runs locally on your machine
✅ **No external servers** - Only connects to eBay
✅ **Open source** - You can review all code
✅ **Logs stored locally** - `terapeak_scanner.log` on your computer
✅ **Your eBay credentials** - Never accessed by the script
✅ **Browser control** - Only automates search field interaction

---

## License

This tool is provided as-is for personal use. Use responsibly and in accordance with eBay's Terms of Service.

---

**Version**: 1.0
**Last Updated**: November 6, 2025
**Tested On**: Ubuntu 22.04 LTS
