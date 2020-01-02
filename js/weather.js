const fs = require('fs');

const { getIpInfo, getYahooWeather } = require('./apiStuff');

const width = process.argv[2];
const invokeImmediately = process.argv[3];

const lastWeather = `${process.env.HOME}/lastweather.json`;

const emojiDict = {
  0: '🌪', 1: '🌀', 2: '🌀', 3: '⚡️❗️', 4: '⚡️', 5: '🌧❄️',
  6: '🌧🧊', 7: '❄️🧊', 8: '🧊💦', 9: '💦', 10: '🧊🌧',
  11: '☔️', 12: '🌧', 13: '⛄️', 14: '🌨', 15: '🌬🌨',
  16: '⛄️', 17: '🧊', 18: '🧊', 19: '🟫', 20: '🌁',
  21: '🌫', 22: '🔥', 23: '🌬', 24: '🌬', 25: '🥶',
  26: '☁️', 27: '🌥', 28: '🌥', 29: '🌤', 30: '🌤',
  31: '🌚', 32: '🌞', 33: '🌑', 34: '☀️', 35: '🌧/🧊',
  36: '🥵', 37: '⚡️', 38: '⚡️', 39: '☔️', 40: '🌧❗️',
  41: '❄️☔️', 42: '☃️', 43: '☃️❗️', 45: '☔️', 46: '❄️☔️',
  47: '⚡️☔️',
};

const getColor = temp => {
  let R = 15, G = 15, B = 15;

  if (temp >= 100) {
    R = 15;
    G = 0;
    B = 0;
  } else if (temp >= 85) {
    R = 15;
    G = 100 - temp;
    B = 0;
  } else if (temp >= 70) {
    R = temp - 70;
    G = 15;
    B = 0;
  } else if (temp >= 55) {
    R = 0;
    G = 15;
    B = 70 - temp;
  } else if (temp >= 40) {
    R = 4;
    G = temp - 40;
    B = 15;
  } else if (temp >= 25) {
    R = 40 - temp;
    G = 4;
    B = 15;
  } else if (temp >= 10) {
    R = 15;
    G = 25 - temp;
    B = 15;
  }

  const hex = ['#',
    (R + (16 * R)).toString(16),
    (G + (16 * G)).toString(16),
    (B + (16 * B)).toString(16),
  ].join('');

  return `#[fg=${hex},bold]${temp}#[fg=colour255,nobold]`;
};

const makeString = ({ code, temp, high, low, tCode, tHigh, tLow }) => {
  const c = '#000000';
  const main = `#[fg=${c}]#[bg=${c},fg=colour255] ${emojiDict[code] || '❓'}  ${getColor(temp)}℉`;
  if (width < 200) return main;
  const highLow = ` [${getColor(high)}℉/${getColor(low)}℉]`;
  if (width < 220 ) return main + highLow;
  const tomorrow = ` => [${emojiDict[tCode] ||  '❓'}  ${getColor(tHigh)}℉/${getColor(tLow)}℉]`;
  return main + highLow + tomorrow;
};

const now = new Date();

if ((now.getMinutes() % 3 === 0 && now.getSeconds() === 0) || invokeImmediately) {
  getIpInfo()
    .then(({ /* postal, */ lat, lng }) => getYahooWeather(lat, lng))
    .then((d) => {
      const [ today, tomorrow ] = d.forecasts;
      const code = today.code;
      const weather = today.text;
      const temp = Math.floor(d['current_observation'].condition.temperature);
      const high = Math.floor(today.high);
      const low = Math.floor(today.low);
      const tHigh = Math.floor(tomorrow.high);
      const tLow = Math.floor(tomorrow.low);
      const tCode = tomorrow.code;
      const tWeather = tomorrow.text;
      const sunset = d['current_observation'].astronomy.sunset;
      const sunrise = d['current_observation'].astronomy.sunrise;
      const parts = {
        code, weather, temp, high, low, sunset, sunrise,
        tCode, tWeather, tHigh, tLow,
      };
      const string = makeString(parts);
      const cached = JSON.stringify({...parts, timestamp: new Date()});
      fs.writeFileSync(lastWeather, cached, { encoding: 'utf8' });
      console.log(string);
    }).catch((e) => {
      console.log(e);
      console.log('');
    });
} else {
  try {
    const raw = fs.readFileSync(lastWeather, { encoding: 'utf8' });
    console.log(makeString(JSON.parse(raw)));
  } catch(e) { // eslint-disable-line no-empty
  }
}
