import { generateIdToken, generateUsername, encodeBase64, decodeBase64 } from "./utils";

const USER_DATA_COOKIE = "user_data";

export function storeUserData(userData) {
    const json = JSON.stringify(userData);
    const encoded = encodeBase64(json);
    setCookie(USER_DATA_COOKIE, encoded, 157_680_000);
}

export function loadUserData() {
    const encoded = getCookieValue(USER_DATA_COOKIE);
    if (encoded) {
        const json = decodeBase64(encoded);
        return JSON.parse(json);
    } else {
        const token = generateIdToken();
        const username = generateUsername();
        storeUserData({token, username});
        return loadUserData();
    }
}

function getCookieValue(key) {
    const cookie = document
        .cookie
        .split("; ")
        .find((cookie) => cookie.startsWith(`${key}=`));

    if (cookie) {
        const value = cookie.replace(`${key}=`, "");
        return value;
    } else {
        return null;
    }
}

function setCookie(key, value, timeout) {
    const cookie = `${key}=${value};max-age=${timeout};path=/`;
    document.cookie = cookie;
}