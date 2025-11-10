# Terapeak Barcode Scanner - Quick Start

Automated barcode scanning for eBay Terapeak on Ubuntu.

---

## 🚀 Quick Start (3 Steps)

```bash
# 1. Install
./install_terapeak_scanner.sh

# 2. Test your scanner
python3 test_barcode_scanner.py

# 3. Run the tool
python3 terapeak_barcode_scanner.py
```

**That's it!** Your browser will open to Terapeak, ready for barcode scanning.

---

## 📋 What You Get

This tool automates your Terapeak research workflow:

1. **Opens Browser** → Chrome opens to eBay Terapeak
2. **Scan Barcode** → Point scanner at product barcode
3. **Auto-Submit** → Search happens automatically
4. **View Results** → See Terapeak sales data
5. **Auto-Clear** → Ready for next scan immediately
6. **Repeat** → Scan as many products as you need

No clicking, no typing - just point and scan!

---

## 🛠️ Installation

### One-Command Install:

```bash
cd /home/ynebay/Ebaytools
./install_terapeak_scanner.sh
```

This installs:
- ✅ Google Chrome browser
- ✅ ChromeDriver (browser automation)
- ✅ Python Selenium library
- ✅ The barcode scanner script

**Time**: ~2-5 minutes depending on your internet speed

---

## 🔍 Testing Your Scanner

Before using the main tool, verify your scanner works:

```bash
python3 test_barcode_scanner.py
```

**What should happen:**
- You scan a barcode
- The barcode number appears on screen
- Cursor moves to next line
- Ready for another scan

**If it doesn't work:**
- Check scanner is plugged in
- Check scanner light turns on when you scan
- Read: [Scanner Troubleshooting](#scanner-troubleshooting)

---

## 📖 Usage

### Start the Scanner:

```bash
python3 terapeak_barcode_scanner.py
```

### What Happens:

```
1. Browser opens to eBay Terapeak
   ↓
2. Log in if prompted (first time only)
   ↓
3. Click on the search field
   ↓
4. Scan barcodes with your scanner
   ↓
5. Results appear automatically
   ↓
6. Field clears, ready for next scan
   ↓
7. Repeat steps 4-6 as needed
   ↓
8. Press Ctrl+C when done
```

### Example Output:

```
============================================================
✓ READY TO SCAN BARCODES
============================================================

2025-11-06 14:32:45 - INFO - 📊 Barcode detected: 074108434343
2025-11-06 14:32:50 - INFO - ✓ Scan #1 complete
2025-11-06 14:32:52 - INFO - Ready for next scan...

2025-11-06 14:33:15 - INFO - 📊 Barcode detected: 012345678901
2025-11-06 14:33:20 - INFO - ✓ Scan #2 complete
2025-11-06 14:33:22 - INFO - Ready for next scan...
```

---

## ⚡ Features

- ✅ **Zero-Click Operation** - Just scan, results appear
- ✅ **Continuous Scanning** - Scan 100+ items in a session
- ✅ **Auto-Clear Field** - Instantly ready for next barcode
- ✅ **Activity Logging** - All scans recorded with timestamps
- ✅ **Error Recovery** - Handles connection issues gracefully
- ✅ **Real Terapeak Data** - Actual eBay sales history

---

## 🎯 Requirements

**Hardware:**
- USB barcode scanner (any brand that acts as keyboard)
- Computer running Ubuntu 20.04+

**Software:**
- Python 3.8+ (pre-installed on Ubuntu)
- Chrome browser (auto-installed by script)
- Internet connection

**eBay Account:**
- Active eBay seller account
- Terapeak access (free for sellers via Seller Hub)

---

## 🔧 Scanner Configuration

Your barcode scanner needs these settings:

### ✅ Required Settings:
1. **Mode**: Keyboard emulation (most scanners default to this)
2. **Suffix**: Send "Enter" or "CR" after each scan

### How to Check:

Open a text editor:
```bash
gedit test.txt
```

Scan a barcode. You should see:
```
123456789012
▌ <-- cursor on new line
```

If cursor stays on same line, configure scanner to send Enter.

### How to Configure:

Check your scanner's manual for:
- "Suffix setting"
- "Terminator character"
- "Add carriage return"
- "Send Enter key"

Usually involves scanning a configuration barcode from the manual.

---

## 📊 Usage Tips

### For Best Results:

**📌 Setup:**
- Use second monitor for notes if available
- Have notepad ready for interesting items
- Good lighting helps scanner accuracy

**📌 During Scanning:**
- Wait for results before next scan (2 sec pause)
- Keep browser window visible
- Clean barcodes scan better than dirty ones

**📌 Workflow:**
- Scan similar items together
- Take breaks every 30-50 scans
- Keep search patterns organized

---

## 🐛 Troubleshooting

### Scanner Not Working

**Problem**: Barcode doesn't appear when I scan

**Solutions:**
```bash
# 1. Test in text editor first
gedit test.txt
# Scan - does barcode appear?

# 2. Check USB connection
lsusb
# Your scanner should appear in list

# 3. Run hardware test
python3 test_barcode_scanner.py
```

### Browser Issues

**Problem**: Chrome won't open or crashes

**Solutions:**
```bash
# Reinstall Chrome
sudo apt remove google-chrome-stable
./install_terapeak_scanner.sh

# Check ChromeDriver
chromedriver --version
```

### Terapeak Not Loading

**Problem**: Browser opens but Terapeak doesn't load

**Solutions:**
1. Check internet connection
2. Log out and back into eBay
3. Verify Terapeak access: https://www.ebay.com/sh/research
4. Check log file: `cat terapeak_scanner.log`

### Search Field Not Found

**Problem**: Script can't find the search input

**Solution:**
- Terapeak interface may have changed
- Check you're on the right page
- Try clicking search field manually
- Check log for details: `terapeak_scanner.log`

---

## 📝 Files Included

```
/home/ynebay/Ebaytools/
├── terapeak_barcode_scanner.py      # Main automation script
├── test_barcode_scanner.py           # Hardware test tool
├── install_terapeak_scanner.sh       # Installation script
├── TERAPEAK_SCANNER_README.md        # This file
└── TERAPEAK_SCANNER_SETUP.md         # Detailed setup guide
```

**Logs:**
- `terapeak_scanner.log` - Activity log (created on first run)
- `install_terapeak_scanner.log` - Installation log

---

## 🔒 Privacy & Security

- ✅ Everything runs locally on your computer
- ✅ No external data collection
- ✅ Only connects to eBay
- ✅ Open source - review the code yourself
- ✅ Your eBay credentials never touched by script
- ✅ Logs stored locally on your machine

---

## 📚 Documentation

- **This File**: Quick start guide
- **TERAPEAK_SCANNER_SETUP.md**: Detailed setup and configuration
- **Code Comments**: Full documentation in Python files

---

## 💡 Command Reference

```bash
# Install everything
./install_terapeak_scanner.sh

# Test scanner hardware
python3 test_barcode_scanner.py

# Run the main tool
python3 terapeak_barcode_scanner.py

# Run with alternative mode
python3 terapeak_barcode_scanner.py --interactive

# View help
python3 terapeak_barcode_scanner.py --help

# Check logs
tail -f terapeak_scanner.log

# Uninstall
pip3 uninstall selenium
sudo apt remove google-chrome-stable chromium-chromedriver
```

---

## ❓ FAQ

**Q: Do I need to keep clicking search?**
A: No! That's the point - just scan, it auto-submits.

**Q: Can I use any barcode scanner?**
A: Yes, as long as it acts as a USB keyboard input device (most do).

**Q: Does this work with wireless scanners?**
A: Yes, if they connect via USB dongle or Bluetooth keyboard mode.

**Q: How many scans can I do?**
A: As many as you want. The tool runs continuously until you stop it.

**Q: Will this get me banned from eBay?**
A: No - you're just using the normal Terapeak interface faster. But don't abuse it with thousands of scans per second.

**Q: Can I use this on Windows or Mac?**
A: This version is for Ubuntu. Would need modifications for other OS.

**Q: What if Terapeak changes their interface?**
A: The script may need updates. Check the logs for errors.

**Q: Is this against eBay's terms of service?**
A: You're using the normal Terapeak interface, just automated. Same as using any browser automation tool for legitimate research.

---

## 🆘 Getting Help

**Check Logs:**
```bash
cat terapeak_scanner.log
```

**Test Components:**
```bash
# Test scanner
python3 test_barcode_scanner.py

# Test Chrome
google-chrome --version

# Test ChromeDriver
chromedriver --version

# Test Selenium
python3 -c "import selenium; print(selenium.__version__)"
```

**Still Having Issues?**
1. Read the detailed guide: `TERAPEAK_SCANNER_SETUP.md`
2. Check troubleshooting section above
3. Review log files for error messages

---

## 🎉 Success Checklist

Before your first productive scan session:

- [ ] Installation completed successfully
- [ ] Scanner test shows barcodes correctly
- [ ] Chrome opens to Terapeak when running script
- [ ] You're logged into eBay
- [ ] Search field is clickable
- [ ] One test barcode returns results
- [ ] Field clears automatically after search

**All checked?** You're ready to scan hundreds of products efficiently!

---

## 🚀 Pro Tips

1. **Batch Processing**: Scan similar items together for easier comparison
2. **Note-Taking**: Keep a spreadsheet open for interesting finds
3. **Break Pattern**: Every 30-50 scans, take a 5-minute break
4. **Scanner Position**: Position scanner for comfortable repetitive use
5. **Lighting**: Good light reduces barcode scan errors
6. **Quality**: Clean barcodes scan better - wipe them if needed

---

**Version**: 1.0
**Platform**: Ubuntu 20.04+
**Last Updated**: November 6, 2025

**Happy Scanning! 📊🔍✨**
