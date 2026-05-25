#!/usr/bin/env bash
set -euo pipefail

# Install plasmoid for development
kpackagetool6 --install . --type Plasma/Applet 2>/dev/null || \
    kpackagetool6 --upgrade . --type Plasma/Applet
