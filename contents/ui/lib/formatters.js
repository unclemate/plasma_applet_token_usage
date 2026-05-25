.pragma library

var currencySymbols = {
    "USD": "$",
    "CNY": "¥",
    "EUR": "€",
    "GBP": "£",
    "JPY": "¥",
    "KRW": "₩",
    "INR": "₹",
    "RUB": "₽",
    "BRL": "R$",
    "CAD": "$",
    "AUD": "$",
    "HKD": "$",
    "SGD": "$",
    "TWD": "NT$"
};

function symbolFor(currency) {
    return currencySymbols[currency] || currency + " ";
}

var noDecimalCurrencies = {
    "JPY": true,
    "KRW": true
};

function formatBalance(balanceInfo) {
    if (!balanceInfo || !balanceInfo.balance_infos || balanceInfo.balance_infos.length === 0) {
        return {
            total: "0.00",
            granted: "0.00",
            toppedUp: "0.00",
            currency: "USD",
            available: false,
            formatted: "N/A"
        };
    }

    var info = balanceInfo.balance_infos[0];
    var currency = info.currency || "USD";
    var decimals = noDecimalCurrencies[currency] ? 0 : 2;
    var total = parseFloat(info.total_balance).toFixed(decimals);
    var granted = parseFloat(info.granted_balance).toFixed(decimals);
    var toppedUp = parseFloat(info.topped_up_balance).toFixed(decimals);
    var sym = symbolFor(currency);

    return {
        total: total,
        granted: granted,
        toppedUp: toppedUp,
        currency: currency,
        available: balanceInfo.is_available || false,
        formatted: sym + total,
        grantedFormatted: sym + granted,
        toppedUpFormatted: sym + toppedUp
    };
}

function timeAgo(date) {
    if (!date) return "";

    var diff = Math.floor((new Date() - date) / 1000);
    if (diff < 10) return i18n("just now");
    if (diff < 60) return i18n("%1s ago", diff);
    if (diff < 3600) return i18n("%1m ago", Math.floor(diff / 60));
    if (diff < 86400) return i18n("%1h ago", Math.floor(diff / 3600));
    return i18n("%1d ago", Math.floor(diff / 86400));
}
