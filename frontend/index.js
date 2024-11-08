import { backend } from "declarations/backend";

const REFRESH_INTERVAL = 600000; // 10 minutes
let nextUpdate = Date.now() + REFRESH_INTERVAL;

async function fetchCryptoData() {
    try {
        document.getElementById('loading').classList.remove('d-none');
        
        // Get random crypto IDs from backend
        const cryptoIds = await backend.getRandomCryptos();
        
        // Fetch data from CoinGecko API
        const response = await fetch(
            `https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=${cryptoIds.join(',')}&order=market_cap_desc&sparkline=false&price_change_percentage=24h`
        );
        
        const data = await response.json();
        updateUI(data);
    } catch (error) {
        console.error('Error fetching data:', error);
    } finally {
        document.getElementById('loading').classList.add('d-none');
    }
}

function updateUI(cryptoData) {
    const container = document.getElementById('cryptoContainer');
    container.innerHTML = '';

    cryptoData.forEach(crypto => {
        const priceChangeClass = crypto.price_change_percentage_24h >= 0 ? 'price-up' : 'price-down';
        const priceChangeSymbol = crypto.price_change_percentage_24h >= 0 ? '↑' : '↓';

        const card = document.createElement('div');
        card.className = 'col-md-6 col-lg-4';
        card.innerHTML = `
            <div class="card crypto-card">
                <div class="card-header">
                    <img src="${crypto.image}" alt="${crypto.name}" class="crypto-image">
                    <h5 class="mb-0">${crypto.name} (${crypto.symbol.toUpperCase()})</h5>
                </div>
                <div class="card-body">
                    <h4 class="card-title">$${crypto.current_price.toLocaleString()}</h4>
                    <p class="card-text ${priceChangeClass}">
                        ${priceChangeSymbol} ${Math.abs(crypto.price_change_percentage_24h).toFixed(2)}%
                    </p>
                    <p class="card-text">
                        Market Cap: $${crypto.market_cap.toLocaleString()}<br>
                        24h Volume: $${crypto.total_volume.toLocaleString()}
                    </p>
                </div>
            </div>
        `;
        container.appendChild(card);
    });
}

function updateTimer() {
    const now = Date.now();
    const timeLeft = Math.max(0, nextUpdate - now);
    const minutes = Math.floor(timeLeft / 60000);
    const seconds = Math.floor((timeLeft % 60000) / 1000);
    
    document.getElementById('timer').textContent = 
        `Next update in ${minutes}:${seconds.toString().padStart(2, '0')}`;
}

async function initialize() {
    await fetchCryptoData();
    setInterval(async () => {
        await fetchCryptoData();
        nextUpdate = Date.now() + REFRESH_INTERVAL;
    }, REFRESH_INTERVAL);
    
    setInterval(updateTimer, 1000);
}

initialize();
