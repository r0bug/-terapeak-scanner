#!/bin/bash
#
# Terapeak Barcode Scanner Installation Script for Ubuntu
# Installs all dependencies and sets up the barcode scanning tool
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}"
    echo "═══════════════════════════════════════════════════════"
    echo "  $1"
    echo "═══════════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running on Ubuntu/Debian
check_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" && "$ID_LIKE" != *"debian"* ]]; then
            print_warning "This script is designed for Ubuntu/Debian systems"
            print_warning "Your system: $PRETTY_NAME"
            read -p "Continue anyway? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi
}

# Check for sudo privileges
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root/sudo"
        print_info "The script will ask for sudo password when needed"
        exit 1
    fi
}

# Main installation function
main() {
    print_header "TERAPEAK BARCODE SCANNER INSTALLATION"

    echo "This script will install:"
    echo "  • Google Chrome browser"
    echo "  • ChromeDriver"
    echo "  • Python Selenium library"
    echo "  • Terapeak barcode scanner script"
    echo ""
    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi

    check_system
    check_sudo

    echo ""
    print_header "STEP 1: UPDATE SYSTEM"

    echo "Updating package lists..."
    sudo apt update || {
        print_error "Failed to update package lists"
        exit 1
    }
    print_success "Package lists updated"

    echo ""
    print_header "STEP 2: INSTALL PYTHON3 AND PIP"

    # Check if Python 3 is installed
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        print_success "Python 3 already installed: $PYTHON_VERSION"
    else
        echo "Installing Python 3..."
        sudo apt install -y python3 python3-pip || {
            print_error "Failed to install Python 3"
            exit 1
        }
        print_success "Python 3 installed"
    fi

    # Install pip if not present
    if ! command -v pip3 &> /dev/null; then
        echo "Installing pip3..."
        sudo apt install -y python3-pip || {
            print_error "Failed to install pip3"
            exit 1
        }
        print_success "pip3 installed"
    else
        print_success "pip3 already installed"
    fi

    echo ""
    print_header "STEP 3: INSTALL GOOGLE CHROME"

    if command -v google-chrome &> /dev/null; then
        CHROME_VERSION=$(google-chrome --version)
        print_success "Google Chrome already installed: $CHROME_VERSION"
    else
        echo "Downloading Google Chrome..."
        cd /tmp
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || {
            print_error "Failed to download Google Chrome"
            exit 1
        }

        echo "Installing Google Chrome..."
        sudo apt install -y ./google-chrome-stable_current_amd64.deb || {
            print_error "Failed to install Google Chrome"
            exit 1
        }

        rm google-chrome-stable_current_amd64.deb
        print_success "Google Chrome installed"
    fi

    echo ""
    print_header "STEP 4: INSTALL CHROMEDRIVER"

    if command -v chromedriver &> /dev/null; then
        CHROMEDRIVER_VERSION=$(chromedriver --version)
        print_success "ChromeDriver already installed: $CHROMEDRIVER_VERSION"
    else
        echo "Installing ChromeDriver..."
        sudo apt install -y chromium-chromedriver || {
            print_error "Failed to install ChromeDriver"
            exit 1
        }
        print_success "ChromeDriver installed"
    fi

    echo ""
    print_header "STEP 5: INSTALL PYTHON DEPENDENCIES"

    echo "Installing Selenium..."
    pip3 install --user selenium || {
        print_error "Failed to install Selenium"
        exit 1
    }
    print_success "Selenium installed"

    echo ""
    print_header "STEP 6: SETUP BARCODE SCANNER SCRIPT"

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SCRIPT_FILE="$SCRIPT_DIR/terapeak_barcode_scanner.py"

    if [ -f "$SCRIPT_FILE" ]; then
        chmod +x "$SCRIPT_FILE"
        print_success "Barcode scanner script is ready"
        print_info "Location: $SCRIPT_FILE"
    else
        print_error "Barcode scanner script not found!"
        print_error "Expected location: $SCRIPT_FILE"
        exit 1
    fi

    echo ""
    print_header "STEP 7: VERIFY INSTALLATION"

    echo "Checking installations..."

    # Check Python
    if command -v python3 &> /dev/null; then
        print_success "Python 3: $(python3 --version)"
    else
        print_error "Python 3 not found"
    fi

    # Check Chrome
    if command -v google-chrome &> /dev/null; then
        print_success "Chrome: $(google-chrome --version)"
    else
        print_error "Chrome not found"
    fi

    # Check ChromeDriver
    if command -v chromedriver &> /dev/null; then
        print_success "ChromeDriver: $(chromedriver --version 2>&1 | head -n1)"
    else
        print_error "ChromeDriver not found"
    fi

    # Check Selenium
    if python3 -c "import selenium" 2>/dev/null; then
        SELENIUM_VERSION=$(python3 -c "import selenium; print(selenium.__version__)")
        print_success "Selenium: $SELENIUM_VERSION"
    else
        print_error "Selenium not found"
    fi

    echo ""
    print_header "INSTALLATION COMPLETE"

    echo ""
    print_success "All dependencies installed successfully!"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  NEXT STEPS"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "1. Connect your barcode scanner via USB"
    echo ""
    echo "2. Configure scanner to send Enter after barcode"
    echo "   (Check your scanner's manual)"
    echo ""
    echo "3. Test your scanner in a text editor:"
    echo "   gedit test.txt"
    echo "   Scan a barcode - it should type and go to next line"
    echo ""
    echo "4. Run the barcode scanner:"
    echo "   cd $SCRIPT_DIR"
    echo "   python3 terapeak_barcode_scanner.py"
    echo ""
    echo "5. For help:"
    echo "   python3 terapeak_barcode_scanner.py --help"
    echo ""
    echo "6. Read the full documentation:"
    echo "   cat TERAPEAK_SCANNER_SETUP.md"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""

    print_info "Installation log saved to: install_terapeak_scanner.log"
}

# Run main installation
main 2>&1 | tee install_terapeak_scanner.log
