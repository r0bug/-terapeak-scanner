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

# Check internet connectivity
check_internet() {
    print_info "Checking internet connectivity..."
    if ! ping -c 1 -W 2 google.com &> /dev/null && ! ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
        print_error "No internet connection detected"
        print_error "Internet connection is required for installation"
        exit 1
    fi
    print_success "Internet connection verified"
}

# Check required tools
check_required_tools() {
    print_info "Checking for required tools..."
    local missing_tools=()

    if ! command -v wget &> /dev/null; then
        missing_tools+=("wget")
    fi

    if ! command -v sudo &> /dev/null; then
        missing_tools+=("sudo")
    fi

    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_info "Install with: sudo apt install ${missing_tools[*]}"
        exit 1
    fi
    print_success "All required tools present"
}

# Check disk space (need at least 500MB)
check_disk_space() {
    print_info "Checking available disk space..."
    local available_mb=$(df /tmp | tail -1 | awk '{print int($4/1024)}')
    if [ "$available_mb" -lt 500 ]; then
        print_warning "Low disk space: ${available_mb}MB available"
        print_warning "At least 500MB recommended"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Sufficient disk space: ${available_mb}MB available"
    fi
}

# Check Python version (need 3.8+)
check_python_version() {
    if command -v python3 &> /dev/null; then
        local python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
        local major=$(echo "$python_version" | cut -d. -f1)
        local minor=$(echo "$python_version" | cut -d. -f2)

        if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -lt 8 ]; }; then
            print_error "Python $python_version is too old (need 3.8+)"
            return 1
        fi
    fi
    return 0
}

# Check what needs to be installed
check_installation_status() {
    echo ""
    print_info "Checking current installation status..."
    echo ""

    local needs_chrome=false
    local needs_chromedriver=false
    local needs_python=false
    local needs_pip=false
    local needs_selenium=false

    # Check Chrome
    if ! command -v google-chrome &> /dev/null; then
        echo "  ⚪ Chrome: Not installed"
        needs_chrome=true
    else
        echo "  ✓ Chrome: $(google-chrome --version)"
    fi

    # Check ChromeDriver
    if ! command -v chromedriver &> /dev/null; then
        echo "  ⚪ ChromeDriver: Not installed"
        needs_chromedriver=true
    else
        echo "  ✓ ChromeDriver: $(chromedriver --version 2>&1 | head -n1)"
    fi

    # Check Python
    if ! command -v python3 &> /dev/null || ! check_python_version; then
        echo "  ⚪ Python 3.8+: Not installed"
        needs_python=true
    else
        echo "  ✓ Python: $(python3 --version)"
    fi

    # Check pip
    if ! command -v pip3 &> /dev/null; then
        echo "  ⚪ pip3: Not installed"
        needs_pip=true
    else
        echo "  ✓ pip3: Installed"
    fi

    # Check Selenium
    if ! python3 -c "import selenium" 2>/dev/null; then
        echo "  ⚪ Selenium: Not installed"
        needs_selenium=true
    else
        local selenium_ver=$(python3 -c "import selenium; print(selenium.__version__)" 2>/dev/null)
        echo "  ✓ Selenium: $selenium_ver"
    fi

    echo ""

    if ! $needs_chrome && ! $needs_chromedriver && ! $needs_python && ! $needs_pip && ! $needs_selenium; then
        print_success "All dependencies are already installed!"
        echo ""
        read -p "Run installation anyway to verify/update? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation skipped"
            exit 0
        fi
    else
        print_info "The following will be installed:"
        $needs_chrome && echo "  • Google Chrome browser"
        $needs_chromedriver && echo "  • ChromeDriver"
        $needs_python && echo "  • Python 3.8+"
        $needs_pip && echo "  • pip3"
        $needs_selenium && echo "  • Selenium library"
        echo ""
    fi
}

# Main installation function
main() {
    print_header "TERAPEAK BARCODE SCANNER INSTALLATION"

    check_installation_status

    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi

    check_system
    check_sudo
    check_required_tools
    check_internet
    check_disk_space

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
        if check_python_version; then
            print_success "Python 3 already installed: $PYTHON_VERSION"
        else
            print_warning "$PYTHON_VERSION detected (need 3.8+)"
            echo "Installing newer Python 3..."
            sudo apt install -y python3 python3-pip || {
                print_error "Failed to install Python 3"
                exit 1
            }
            if ! check_python_version; then
                print_error "Python version still too old after installation"
                print_error "Please upgrade Python manually to 3.8 or higher"
                exit 1
            fi
            print_success "Python 3 installed"
        fi
    else
        echo "Installing Python 3..."
        sudo apt install -y python3 python3-pip || {
            print_error "Failed to install Python 3"
            exit 1
        }
        if ! check_python_version; then
            print_error "Installed Python version is too old (need 3.8+)"
            exit 1
        fi
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

    # Check if Selenium is already installed
    if python3 -c "import selenium" 2>/dev/null; then
        SELENIUM_VERSION=$(python3 -c "import selenium; print(selenium.__version__)" 2>/dev/null)
        print_success "Selenium already installed: $SELENIUM_VERSION"

        # Ask if user wants to upgrade
        read -p "Update Selenium to latest version? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Updating Selenium..."
            pip3 install --user --upgrade selenium || {
                print_warning "Failed to upgrade Selenium (current version still works)"
            }
        fi
    else
        echo "Installing Selenium..."
        pip3 install --user selenium || {
            print_error "Failed to install Selenium"
            print_info "Try: python3 -m pip install --user selenium"
            exit 1
        }
        print_success "Selenium installed"
    fi

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
