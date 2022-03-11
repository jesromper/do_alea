function newNumber() {
    const newNumber = generateRandomNumber();
    renderNumber(newNumber.toString());
}
function clearAll() {
    renderNumber('-');
}

// function generateRandomNumber() {
//     return 9;
// }

function generateRandomNumber() {
    return Math.floor(Math.random() * 10);
}

function renderNumber(text) {
    document.getElementById("generado").innerHTML = text;
}

function getAppVersion() {
    document.getElementById("appVersion").innerHTML = "1.3.0";
}

function init() {
    getAppVersion();
}

module.exports = generateRandomNumber;