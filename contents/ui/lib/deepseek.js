.pragma library

var BASE_URL = "https://api.deepseek.com";

function fetchBalance(apiKey, callback) {
    if (!apiKey || apiKey.trim() === "") {
        callback(new Error("API key not configured"));
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("GET", BASE_URL + "/user/balance");
    xhr.setRequestHeader("Authorization", "Bearer " + apiKey.trim());
    xhr.setRequestHeader("Accept", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState !== XMLHttpRequest.DONE) {
            return;
        }

        if (xhr.status === 200) {
            try {
                var data = JSON.parse(xhr.responseText);
                callback(null, data);
            } catch (e) {
                callback(new Error("Failed to parse response: " + e.message));
            }
        } else if (xhr.status === 401) {
            callback(new Error("Authentication failed — check your API key"));
        } else if (xhr.status === 402) {
            callback(new Error("Insufficient balance"));
        } else if (xhr.status === 429) {
            callback(new Error("Rate limited — try again later"));
        } else {
            callback(new Error("HTTP " + xhr.status + ": " + xhr.statusText));
        }
    };

    xhr.onerror = function() {
        callback(new Error("Network error — check your connection"));
    };

    xhr.ontimeout = function() {
        callback(new Error("Request timed out"));
    };

    xhr.timeout = 10000;
    xhr.send();
}
