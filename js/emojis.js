
const emojiDict = {
  0: '🌪', 1: '🌀', 2: '🌀', 3: '⚡️❗️', 4: '⚡️', 5: '🌧 ❄️ ',
  6: '🌧 🧊 ', 7: '❄️🧊', 8: '🧊💦', 9: '💦', 10: '🧊🌧  ',
  11: '☔️', 12: '🌧 ', 13: '⛄️', 14: '🌨 ', 15: '🌬🌨',
  16: '⛄️', 17: '🧊', 18: '🧊', 19: '🟫', 20: '🌁',
  21: '🌫', 22: '🔥', 23: '🌬', 24: '🌬', 25: '🥶',
  26: '☁️', 27: '🌥', 28: '🌥', 29: '🌤', 30: '🌤',
  31: '🌚', 32: '🌞', 33: '🌑', 34: '☀️', 35: '🌧 /🧊 ',
  36: '🥵', 37: '⚡️', 38: '⚡️', 39: '☔️', 40: '🌧 ❗️ ',
  41: '❄️☔️', 42: '☃️', 43: '☃️❗️', 45: '☔️', 46: '❄️☔️',
  47: '⚡️☔️',
};

const q = '❓';

const darkSkyEmojis = {
  'clear-day': '☀️',
  'clear-night': '🌑',
  rain: '☔️',
  sleet: '🧊',
  snow: '❄️ ',
  wind: '🌬',
  fog: '🌫',
  cloudy: '☁️ ',
  'partly-cloudy-day': '⛅️',
  'partly-cloudy-night': '⛅️',
};

const moons = ['🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘'];
const getMoon = phase => moons[Math.floor(phase * 8)];

const getEmoji = (code, service='yahoo') =>
  ((service === 'darksky' ? darkSkyEmojis : emojiDict)[code] || q).padEnd(2, ' ');

const getRising = ({ rising }) => rising ? '👆' :'👇';

const weed = '🍁';


module.exports = { getEmoji, getMoon, getRising, weed };
