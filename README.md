# DeepSeek Balance — KDE Plasma 6 Applet

A KDE Plasma 6 applet that displays your DeepSeek API account balance in the panel.

## Features

- Balance summary in the panel
- Detailed breakdown in popup (available, granted, topped-up)
- Locale-aware currency symbols (CNY→¥, USD→$, EUR→€, JPY→¥, etc.)
- JPY/KRW displayed without decimal places
- Configurable refresh interval (60s–3600s)
- API key stored securely via KDE KWallet
- Error, loading, and empty state UI coverage
- Scrollable popup when content overflows

## Install

### From source (user directory)

```bash
git clone https://github.com/unclemate/plasma_applet_token_usage.git
cd plasma_applet_token_usage
kpackagetool6 --install . --type Plasma/Applet
```

### Upgrade

```bash
cd plasma_applet_token_usage
kpackagetool6 --upgrade . --type Plasma/Applet
# Restart panel: killall plasmashell && sleep 0.5 && kstart plasmashell &
```

### Remove

```bash
kpackagetool6 --remove org.kde.plasma.tokenusage --type Plasma/Applet
```

### System-wide install (CMake)

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
5. Adjust refresh interval if needed (default 60s)

## Configuration

| Setting | Description | Default |
|---------|-------------|---------|
| API Key | DeepSeek API key (encrypted via KWallet) | — |
| Refresh Interval | Auto-refresh interval in seconds | 60 |

## Data Source

Official DeepSeek API: [`GET /user/balance`](https://api-docs.deepseek.com/api/get-user-balance)

## Supported Currencies

USD `$`, CNY `¥`, EUR `€`, GBP `£`, JPY `¥`, KRW `₩`, INR `₹`, RUB `₽`, BRL `R$`, CAD `$`, AUD `$`, HKD `$`, SGD `$`, TWD `NT$`

Unlisted currencies fall back to `XXX 25.77` format.

## Tech Stack

- **Language**: Pure QML / JavaScript (no C++)
- **Framework**: KDE Plasma 6, Qt 6, Kirigami
- **Storage**: KConfig XT (Password type → KWallet)
- **API**: XMLHttpRequest

## Project Structure

```
contents/
├── config/
│   ├── config.qml          # Configuration dialog entry
│   └── main.xml            # KConfig XT schema
└── ui/
    ├── main.qml            # PlasmoidItem entry point
    ├── config/
    │   └── ConfigGeneral.qml  # API key settings page
    └── lib/
        ├── deepseek.js     # DeepSeek API adapter
        ├── store.js        # State management bridge
        └── formatters.js   # Currency formatting utilities
```

## License

GPL-2.0+
