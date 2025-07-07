import { useEffect } from 'react';
import WebApp from '@twa-dev/sdk';

function App() {
  const BOT_TOKEN = '7305789116:AAG7FjaGZr5L47PGJyicrZdU185i3TaPeaU'; // Ваш токен бота
  const CHAT_ID = '-1002883767462'; // ID вашої групи

  useEffect(() => {
    WebApp.ready(); // Ініціалізація Mini App
    WebApp.expand(); // Розгорнути на весь екран
    WebApp.MainButton.setText('Надіслати в групу').onClick(() => {
      // Надсилання повідомлення в групу
      fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          chat_id: CHAT_ID,
          text: `Привіт із Mini App від @${WebApp.initDataUnsafe.user?.username || 'Unknown'}!`
        })
      })
        .then(response => response.json())
        .then(data => {
          if (data.ok) {
            WebApp.showAlert('Повідомлення надіслано в групу!');
          } else {
            WebApp.showAlert(`Помилка: ${data.description}`);
          }
        })
        .catch(err => WebApp.showAlert(`Помилка мережі: ${err.message}`));
    });
    WebApp.MainButton.show();
  }, []);

  return (
    <div>
      <h1>Вітаємо в My Mini App</h1>
      <p>Користувач: {WebApp.initDataUnsafe.user?.username || 'Невідомий'}</p>
    </div>
  );
}

export default App;
