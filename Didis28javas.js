import { useState, useEffect } from 'react';
import WebApp from '@twa-dev/sdk';
import './App.css';

function App() {
  const BOT_TOKEN = '7305789116:AAG7FjaGZr5L47PGJyicrZdU185i3TaPeaU'; // Ваш токен бота
  const CHAT_ID = '-1002883767462'; // ID групи
  const [rotation, setRotation] = useState(0);
  const [spinning, setSpinning] = useState(false);
  const [points, setPoints] = useState(0);
  const [rewards, setRewards] = useState([]);
  const [lastSpinTime, setLastSpinTime] = useState(localStorage.getItem('lastSpinTime') || null);
  const [dayPassUsed, setDayPassUsed] = useState(localStorage.getItem('dayPassUsed') === 'true');
  const [message, setMessage] = useState('');

  // Нагороди за обертання
  const wheelRewards = [
    { points: 10, label: '10 очок' },
    { points: 20, label: '20 очок' },
    { points: 50, label: '50 очок' },
    { points: 100, label: '100 очок' },
    { points: 0, label: 'Спробуй ще!' },
    { points: 30, label: '30 очок' },
    { points: 75, label: '75 очок' },
    { points: 150, label: 'Джекпот!' },
  ];

  // Предмети Battle Pass
  const battlePassItems = [
    { id: 1, name: 'Крутий аватар', cost: 50, owned: false },
    { id: 2, name: 'Ексклюзивний стікер', cost: 100, owned: false },
    { id: 3, name: 'Тема для профілю', cost: 200, owned: false },
  ];

  useEffect(() => {
    WebApp.ready();
    WebApp.expand();
    WebApp.setBackgroundColor(WebApp.themeParams.bg_color || '#FFFFFF');
    WebApp.setHeaderColor(WebApp.themeParams.bg_color || '#FFFFFF');

    // Налаштування головної кнопки Telegram
    WebApp.MainButton.setText('Оберти колесо').onClick(spinWheel);
    if (canSpin()) {
      WebApp.MainButton.show();
    } else {
      WebApp.MainButton.hide();
      setMessage('Ви вже крутили колесо сьогодні! Спробуйте завтра або використайте Day Pass.');
    }
  }, []);

  // Перевірка, чи можна крутити колесо
  const canSpin = () => {
    if (dayPassUsed) return false;
    if (!lastSpinTime) return true;
    const lastSpin = new Date(parseInt(lastSpinTime));
    const now = new Date();
    const diff = now - lastSpin;
    const oneDay = 24 * 60 * 60 * 1000; // Один день у мілісекундах
    return diff >= oneDay;
  };

  // Обертання колеса
  const spinWheel = () => {
    if (spinning || !canSpin()) {
      WebApp.showAlert('Ви не можете крутити колесо зараз!');
      return;
    }

    setSpinning(true);
    const randomIndex = Math.floor(Math.random() * wheelRewards.length);
    const reward = wheelRewards[randomIndex];
    const spins = 5; // Кількість обертів
    const degreesPerSegment = 360 / wheelRewards.length;
    const finalRotation = 360 * spins + randomIndex * degreesPerSegment;

    setRotation(finalRotation);

    setTimeout(() => {
      setSpinning(false);
      setPoints(points + reward.points);
      setRewards([...rewards, reward.label]);
      setLastSpinTime(Date.now());
      localStorage.setItem('lastSpinTime', Date.now());
      WebApp.MainButton.hide();
      setMessage(`Ви виграли: ${reward.label}!`);

      // Надсилаємо результат у групу
      fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          chat_id: CHAT_ID,
          text: `🎉 @${WebApp.initDataUnsafe.user?.username || 'Unknown'} виграв у Колесі Фортуни: ${reward.label}! Очки: ${points + reward.points}`
        })
      })
        .then(response => response.json())
        .then(data => {
          if (!data.ok) {
            WebApp.showAlert(`Помилка надсилання в групу: ${data.description}`);
          }
        })
        .catch(err => WebApp.showAlert(`Помилка мережі: ${err.message}`));
    }, 4000); // Час анімації
  };

  // Використання Day Pass
  const useDayPass = () => {
    if (points >= 50 && !dayPassUsed) {
      setPoints(points - 50);
      setDayPassUsed(true);
      localStorage.setItem('dayPassUsed', 'true');
      WebApp.MainButton.show();
      setMessage('Day Pass активовано! Крутіть колесо!');
    } else {
      WebApp.showAlert('Недостатньо очок або Day Pass уже використано!');
    }
  };

  // Купівля предметів Battle Pass
  const buyItem = (item) => {
    if (points >= item.cost && !rewards.includes(item.name)) {
      setPoints(points - item.cost);
      setRewards([...rewards, item.name]);
      WebApp.showAlert(`Ви купили: ${item.name}!`);
    } else {
      WebApp.showAlert('Недостатньо очок або предмет уже куплено!');
    }
  };

  return (
    <div className="app">
      <h1>Колесо Фортуни 🎡</h1>
      <p>Користувач: @{WebApp.initDataUnsafe.user?.username || 'Невідомий'}</p>
      <p>Очки: {points}</p>
      <p>{message}</p>
      <div className="wheel-container">
        <div className="wheel" style={{ transform: `rotate(${rotation}deg)` }}>
          {wheelRewards.map((reward, index) => (
            <div
              key={index}
              className="wheel-segment"
              style={{
                transform: `rotate(${index * (360 / wheelRewards.length)}deg)`,
                backgroundColor: index % 2 === 0 ? WebApp.themeParams.bg_color || '#FFFFFF' : WebApp.themeParams.secondary_bg_color || '#E0E0E0'
              }}
            >
              <span>{reward.label}</span>
            </div>
          ))}
        </div>
        <div className="wheel-pointer">▼</div>
      </div>
      <button className="day-pass-button" onClick={useDayPass}>
        <span role="img" aria-label="ticket">🎟️</span> Day Pass (50 очок)
      </button>
      <h2>Battle Pass</h2>
      <div className="battle-pass">
        {battlePassItems.map(item => (
          <div key={item.id} className="battle-pass-item">
            <span>{item.name} ({item.cost} очок)</span>
            <button onClick={() => buyItem(item)} disabled={rewards.includes(item.name)}>
              {rewards.includes(item.name) ? 'Куплено' : 'Купити'}
            </button>
          </div>
        ))}
      </div>
      <h2>Ваші нагороди</h2>
      <ul>
        {rewards.map((reward, index) => (
          <li key={index}>{reward}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
