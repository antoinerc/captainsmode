const uuid = require('uuid');

/**
 * Transforms a UTF8 string into base64 encoding.
 */
export function encodeBase64(string) {
    return btoa(unescape(encodeURIComponent(string)));
}

/**
 * Transforms base64 encoding into UTF8 string.
 */
export function decodeBase64(binary) {
    return decodeURIComponent(escape(atob(binary)));
}

export function generateIdToken() {
    return uuid.v4();
}