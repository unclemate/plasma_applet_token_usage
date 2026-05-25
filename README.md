# DeepSeek Balance — KDE Plasma 6 Applet

A KDE Plasma 6 applet that shows your DeepSeek API account balance in the panel.

## Features

- Display DeepSeek balance on panel
- Detailed breakdown (granted/topped-up) in popup
- Configurable refresh interval (60s–3600s)
- API key stored securely via KDE KWallet
- Error handling for network/auth failures

## Requirements

- KDE Plasma 6
- Qt 6.5+
- DeepSeek API key ([platform.deepseek.com](https://platform.deepseek.com))

## Install

```bash
# Install from source
kpackagetool6 --install . --type Plasma/Applet

# Upgrade after changes
kpackagetool6 --upgrade . --type Plasma/Applet

# Remove
kpackagetool6 --remove org.kde.plasma.tokenusage
```

### Build with CMake (system-wide)

```bash
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make
sudo make install
```

## Usage

1. Right-click panel → **Add Widgets...**
2. Search for "DeepSeek Balance"
3. Right-click the applet → **Configure**
4. Enter your DeepSeek API key
5. Adjust refresh interval if needed

## Data Source

Uses the official DeepSeek API: [`GET /user/balance`](https://api-docs.deepseek.com/api/get-user-balance)

DeepSeek does not provide a programmatic API for historical token usage data. For detailed usage analysis, use the web dashboard at [platform.deepseek.com/usage](https://platform.deepseek.com/usage).

## License

GPL-2.0+
