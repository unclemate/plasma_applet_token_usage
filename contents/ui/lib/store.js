.pragma library

// Thin orchestrator — fetches balance via deepseek.js and pushes state
// into a QML bridge object for reactive bindings.

var _bridge = null;
var _apiKey = "";

function init(bridge) {
    _bridge = bridge;
}

function setApiKey(key) {
    _apiKey = key || "";
}

function triggerFetch(deepseek) {
    if (!_bridge) return;

    if (!_apiKey) {
        _bridge.isLoading = false;
        _bridge.errorMessage = "No API key configured";
        return;
    }

    _bridge.isLoading = true;
    _bridge.errorMessage = "";

    deepseek.fetchBalance(_apiKey, function(err, data) {
        _bridge.isLoading = false;
        if (err) {
            _bridge.errorMessage = err.message;
            return;
        }
        _bridge.balanceData = data;
        _bridge.lastFetchTime = new Date();
    });
}
