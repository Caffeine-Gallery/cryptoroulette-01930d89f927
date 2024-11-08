import { backend } from "declarations/backend";

async function fetchCryptos() {
    try {
        const cryptos = await backend.getTopCryptos();
        displayCryptos(cryptos);
    } catch (error) {
        console.error("Failed to fetch cryptocurrencies:", error);
    }
}

function displayCryptos(cryptos) {
    const container = document.getElementById('crypto-container');
    if (!container) return;

    container.innerHTML = '';
    cryptos.forEach(crypto => {
        const div = document.createElement('div');
        div.className = 'crypto-item';
        div.textContent = crypto;
        container.appendChild(div);
    });
}

// Initial fetch
fetchCryptos();
