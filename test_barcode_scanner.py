#!/usr/bin/env python3
"""
Simple Barcode Scanner Test Tool

This script helps you verify that your barcode scanner is working
correctly before using the Terapeak automation tool.
"""

import sys
import time

def main():
    print("""
╔═══════════════════════════════════════════════════════════╗
║         BARCODE SCANNER HARDWARE TEST                     ║
║                                                           ║
║  This tool helps verify your scanner is configured       ║
║  correctly before using the Terapeak automation.         ║
╚═══════════════════════════════════════════════════════════╝

Instructions:
1. Make sure your barcode scanner is plugged in via USB
2. This terminal window should be focused (click on it)
3. Scan a barcode with your scanner
4. The barcode should appear below followed by a new line
5. Press Ctrl+C to exit when done

Expected behavior:
- Scanner types the barcode digits
- Scanner sends Enter key (moves to next line)
- You see: "Barcode detected: XXXXXXXXXX"

If the barcode doesn't appear, check:
- Scanner is powered on (light should come on when scanning)
- Scanner is plugged into USB port
- Scanner is set to "keyboard mode"
- Scanner "suffix" is set to send Enter/CR

════════════════════════════════════════════════════════════

Ready to test! Scan a barcode now:
    """)

    scan_count = 0

    try:
        while True:
            # Read input from stdin (which includes barcode scanner input)
            barcode = input().strip()

            if barcode:
                scan_count += 1
                print(f"\n✓ Barcode detected: {barcode}")
                print(f"  Length: {len(barcode)} characters")
                print(f"  Scan count: {scan_count}")
                print("\n" + "─" * 60)
                print("Scan another barcode (or press Ctrl+C to exit):")
            else:
                print("(Empty input received - scan again)")

    except KeyboardInterrupt:
        print("\n\n" + "═" * 60)
        print(f"Test complete. Total scans: {scan_count}")

        if scan_count > 0:
            print("\n✓ SUCCESS! Your barcode scanner is working correctly!")
            print("\nYou can now use the Terapeak automation tool:")
            print("  python3 terapeak_barcode_scanner.py")
        else:
            print("\n✗ No barcodes detected.")
            print("\nTroubleshooting:")
            print("1. Check scanner is plugged in and powered on")
            print("2. Try scanning in a text editor (gedit) first")
            print("3. Check scanner manual for 'keyboard mode' setting")
            print("4. Verify scanner sends 'Enter' after barcode")

        print("═" * 60)

    except EOFError:
        print("\n\nEOF detected. Exiting...")

if __name__ == "__main__":
    main()
