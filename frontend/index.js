import { backend } from "declarations/backend";

async function fetchCryptoData() {
    try {
        // Get random crypto IDs from backend
        const cryptoIds = await backend.getRandomCryptos();
        
        // Fetch prices from CoinGecko API
        const response = await fetch(`https://api.coingecko.com/api/v3/simple/price?ids=${cryptoIds.join(',')}&vs_currencies=usd`);
        const data = await response.json();
        
        // Format data for backend
        const prices = cryptoIds.map(id => [id, data[id]?.usd || 0]);
        
        // Update backend with new prices
        await backend.updateCryptoPrices(prices);
        
        // Get updated data from backend
        const cryptoData = await backend.getCurrentCryptos();
        displayCryptoData(cryptoData);
    } catch (error) {
        console.error("Failed to fetch cryptocurrency data:", error);
    }
}

function displayCryptoData(cryptoData) {
    const container = document.getElementById('crypto-container');
    if (!container) return;

    container.innerHTML = '';
    cryptoData.forEach(crypto => {
        const div = document.createElement('div');
        div.className = 'crypto-item';
        
        const name = document.createElement('h3');
        name.textContent = crypto.id;
        
        const price = document.createElement('p');
        price.className = 'price';
        price.textContent = `$${crypto.price.toFixed(2)}`;
        
        const timestamp = document.createElement('p');
        timestamp.className = 'timestamp';
        timestamp.textContent = new Date(Number(crypto.lastUpdate / 1000000n)).toLocaleString();
        
        div.appendChild(name);
        div.appendChild(price);
        div.appendChild(timestamp);
        container.appendChild(div);
    });
}

// Initial fetch
fetchCryptoData();

// Update every 10 minutes
setInterval(fetchCryptoData, 600000);
