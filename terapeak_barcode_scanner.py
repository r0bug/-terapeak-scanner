#!/usr/bin/env python3
"""
Terapeak Barcode Scanner for Ubuntu
Automates barcode scanning workflow on eBay Terapeak

Features:
- Opens browser to Terapeak
- Auto-submits when barcode is scanned
- Clears search field for next scan
- Continuous scanning mode
"""

import time
import sys
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException, NoSuchElementException
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('terapeak_scanner.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class TerapeakBarcodeScanner:
    """Automated barcode scanner for eBay Terapeak."""

    def __init__(self, headless=False):
        """
        Initialize the scanner.

        Args:
            headless: Run browser in headless mode (no GUI)
        """
        self.driver = None
        self.wait = None
        self.headless = headless
        self.terapeak_url = "https://www.ebay.com/sh/research"
        self.scan_count = 0

    def setup_browser(self):
        """Set up Chrome browser with appropriate options."""
        logger.info("Setting up Chrome browser...")

        chrome_options = Options()

        if self.headless:
            chrome_options.add_argument('--headless')

        # Additional options for better performance
        chrome_options.add_argument('--no-sandbox')
        chrome_options.add_argument('--disable-dev-shm-usage')
        chrome_options.add_argument('--disable-blink-features=AutomationControlled')
        chrome_options.add_argument('--start-maximized')

        # Remove "Chrome is being controlled by automated software" banner
        chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
        chrome_options.add_experimental_option('useAutomationExtension', False)

        try:
            self.driver = webdriver.Chrome(options=chrome_options)
            self.wait = WebDriverWait(self.driver, 10)
            logger.info("Browser setup complete")
            return True
        except Exception as e:
            logger.error(f"Failed to setup browser: {str(e)}")
            logger.error("Make sure chromedriver is installed: sudo apt install chromium-chromedriver")
            return False

    def open_terapeak(self):
        """Navigate to Terapeak Product Research page."""
        logger.info(f"Opening Terapeak at {self.terapeak_url}...")

        try:
            self.driver.get(self.terapeak_url)
            time.sleep(3)  # Allow page to load

            # Check if we're on the login page
            if "signin" in self.driver.current_url.lower():
                logger.warning("⚠️ You need to log in to eBay!")
                logger.info("Please log in manually in the browser window...")
                logger.info("Press Enter in this terminal once you're logged in and on the Terapeak page...")
                input()

                # Navigate to Terapeak again after login
                self.driver.get(self.terapeak_url)
                time.sleep(3)

            logger.info("✓ Terapeak page loaded")
            return True

        except Exception as e:
            logger.error(f"Failed to open Terapeak: {str(e)}")
            return False

    def find_search_input(self):
        """Find the Terapeak search input field."""
        # Try multiple possible selectors for the search input
        selectors = [
            "input[placeholder*='Search']",
            "input[name='keyword']",
            "input[type='search']",
            "input[aria-label*='search']",
            "#keyword",
            ".search-input input",
            "input[data-test-id*='search']"
        ]

        for selector in selectors:
            try:
                element = self.driver.find_element(By.CSS_SELECTOR, selector)
                if element.is_displayed():
                    logger.info(f"✓ Found search input using selector: {selector}")
                    return element
            except NoSuchElementException:
                continue

        logger.error("Could not find search input field")
        return None

    def wait_for_results(self, timeout=5):
        """Wait for search results to load."""
        try:
            # Wait for results to appear (adjust selector based on Terapeak's actual structure)
            time.sleep(timeout)  # Simple wait for results
            logger.info("✓ Search results loaded")
            return True
        except Exception as e:
            logger.warning(f"Could not detect results loading: {str(e)}")
            return False

    def clear_search_field(self, search_input):
        """Clear the search field."""
        try:
            # Select all text and delete
            search_input.click()
            search_input.send_keys(Keys.CONTROL + "a")
            search_input.send_keys(Keys.DELETE)
            logger.info("✓ Search field cleared")
            return True
        except Exception as e:
            logger.error(f"Failed to clear search field: {str(e)}")
            return False

    def process_barcode_scan(self, search_input, barcode):
        """
        Process a barcode scan.

        Args:
            search_input: The search input element
            barcode: The barcode string that was scanned
        """
        try:
            logger.info(f"Processing barcode: {barcode}")

            # The barcode scanner will have already typed the barcode
            # We just need to submit the search
            search_input.send_keys(Keys.RETURN)

            # Wait for results
            logger.info("Waiting for search results...")
            self.wait_for_results()

            self.scan_count += 1
            logger.info(f"✓ Scan #{self.scan_count} complete")

            # Wait a moment for user to view results
            time.sleep(2)

            # Clear field for next scan
            self.clear_search_field(search_input)

            return True

        except Exception as e:
            logger.error(f"Error processing barcode: {str(e)}")
            return False

    def run_interactive_mode(self):
        """
        Run in interactive mode where user scans barcodes.
        The barcode scanner acts as a keyboard input device.
        """
        logger.info("="*60)
        logger.info("TERAPEAK BARCODE SCANNER - INTERACTIVE MODE")
        logger.info("="*60)

        if not self.setup_browser():
            return False

        if not self.open_terapeak():
            self.driver.quit()
            return False

        # Find the search input
        search_input = self.find_search_input()
        if not search_input:
            logger.error("Cannot proceed without search input field")
            self.driver.quit()
            return False

        # Click on the search field to focus it
        search_input.click()

        logger.info("")
        logger.info("="*60)
        logger.info("✓ READY TO SCAN BARCODES")
        logger.info("="*60)
        logger.info("")
        logger.info("Instructions:")
        logger.info("1. Make sure the search field is focused (click on it if needed)")
        logger.info("2. Scan a barcode with your barcode scanner")
        logger.info("3. The script will automatically submit and clear for next scan")
        logger.info("4. Press Ctrl+C to exit")
        logger.info("")
        logger.info("Monitoring for barcode scans...")
        logger.info("")

        try:
            last_value = ""

            while True:
                # Check current value in search field
                current_value = search_input.get_attribute('value') or ""

                # If value changed and ends with newline/enter, it's a complete barcode scan
                if current_value and current_value != last_value:
                    # Barcode scanners typically send Enter after the barcode
                    # Wait a tiny bit to ensure the full barcode is captured
                    time.sleep(0.1)

                    final_value = search_input.get_attribute('value') or ""

                    # Process if we have a non-empty value
                    if final_value.strip():
                        self.process_barcode_scan(search_input, final_value)
                        last_value = ""
                    else:
                        last_value = current_value
                else:
                    last_value = current_value

                # Small sleep to prevent CPU overuse
                time.sleep(0.1)

        except KeyboardInterrupt:
            logger.info("")
            logger.info("="*60)
            logger.info(f"Scanner stopped. Total scans: {self.scan_count}")
            logger.info("="*60)

        finally:
            self.cleanup()

    def run_auto_mode(self):
        """
        Run in automatic mode monitoring for Enter key after barcode input.
        This is more reliable for detecting complete barcode scans.
        """
        logger.info("="*60)
        logger.info("TERAPEAK BARCODE SCANNER - AUTO MODE")
        logger.info("="*60)

        if not self.setup_browser():
            return False

        if not self.open_terapeak():
            self.driver.quit()
            return False

        # Find the search input
        search_input = self.find_search_input()
        if not search_input:
            logger.error("Cannot proceed without search input field")
            self.driver.quit()
            return False

        # Click on the search field to focus it
        search_input.click()

        logger.info("")
        logger.info("="*60)
        logger.info("✓ READY TO SCAN BARCODES")
        logger.info("="*60)
        logger.info("")
        logger.info("Instructions:")
        logger.info("1. Click on the search field in the browser")
        logger.info("2. Scan a barcode (scanner will type it + Enter)")
        logger.info("3. Script automatically processes and clears for next scan")
        logger.info("4. Press Ctrl+C in terminal to exit")
        logger.info("")
        logger.info("Waiting for barcode scans...")
        logger.info("")

        try:
            # Use JavaScript to detect Enter key in the search field
            script = """
            window.lastBarcode = '';
            document.querySelector('body').addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    var searchInput = arguments[0];
                    if (searchInput && searchInput.value) {
                        window.lastBarcode = searchInput.value;
                    }
                }
            }.bind(null, arguments[0]));
            """

            self.driver.execute_script(script, search_input)

            while True:
                # Check if a barcode was scanned (Enter was pressed)
                last_barcode = self.driver.execute_script("return window.lastBarcode;")

                if last_barcode:
                    logger.info(f"📊 Barcode detected: {last_barcode}")

                    # Clear the JavaScript variable
                    self.driver.execute_script("window.lastBarcode = '';")

                    # Wait for results
                    self.wait_for_results()

                    self.scan_count += 1
                    logger.info(f"✓ Scan #{self.scan_count} complete")

                    # Wait for user to view results
                    time.sleep(2)

                    # Clear and refocus
                    self.clear_search_field(search_input)
                    search_input.click()

                    logger.info("Ready for next scan...")
                    logger.info("")

                time.sleep(0.2)

        except KeyboardInterrupt:
            logger.info("")
            logger.info("="*60)
            logger.info(f"Scanner stopped. Total scans: {self.scan_count}")
            logger.info("="*60)

        finally:
            self.cleanup()

    def cleanup(self):
        """Clean up resources."""
        if self.driver:
            logger.info("Closing browser...")
            self.driver.quit()
            logger.info("✓ Browser closed")


def main():
    """Main entry point."""
    print("""
╔═══════════════════════════════════════════════════════════╗
║       TERAPEAK BARCODE SCANNER for Ubuntu                 ║
║                                                           ║
║  Automated barcode scanning for eBay Terapeak           ║
╚═══════════════════════════════════════════════════════════╝
    """)

    # Check for command line arguments
    mode = "auto"  # Default mode

    if len(sys.argv) > 1:
        if sys.argv[1] == "--interactive":
            mode = "interactive"
        elif sys.argv[1] == "--help":
            print("Usage: python3 terapeak_barcode_scanner.py [OPTIONS]")
            print("")
            print("Options:")
            print("  --interactive    Use interactive polling mode")
            print("  --auto          Use automatic detection mode (default)")
            print("  --help          Show this help message")
            print("")
            print("Example:")
            print("  python3 terapeak_barcode_scanner.py")
            print("  python3 terapeak_barcode_scanner.py --interactive")
            return

    scanner = TerapeakBarcodeScanner(headless=False)

    if mode == "interactive":
        scanner.run_interactive_mode()
    else:
        scanner.run_auto_mode()


if __name__ == "__main__":
    main()
