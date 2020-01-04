const fs = require('fs');

const { getIpInfo, getYahooWeather } = require('./apiStuff');

const width = process.argv[2];
const invokeImmediately = process.argv[3] === 'true';

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

const getEmoji = code => emojiDict[code] || '❓';

const toHex = n => (n + (16 * n)).toString(16).padStart(2, '0');

const getColor = (temp, fg) => {
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

  const hex = `#${toHex(R)}${toHex(G)}${toHex(B)}`;

  return `#[fg=${hex},bold]${temp}#[fg=${fg},nobold]`;
};

const makeString = ({ now, today, tomorrow: t }) => {
  const bg = (() => {
    if (now.temp >= 80) return '#440000';
    if (now.temp >= 50) return '#004400';
    return '#000044';
  })();
  const fg = '#BBBBBB';
  const main = `#[fg=${bg}]#[bg=${bg}] ${getEmoji(now.code)}  ${getColor(now.temp, fg)}℉`;
  if (width < 200) return main;
  const highLow = ` [${getEmoji(today.code)}  ${getColor(today.high, fg)}℉/${getColor(today.low, fg)}℉]`;
  if (width < 220 ) return main + highLow;
  const tomorrow = ` => [${getEmoji(t.code)}  ${getColor(t.high, fg)}℉/${getColor(t.low, fg)}℉]`;
  return main + highLow + tomorrow;
};

const now = new Date();

if (now.getSeconds() === 0 || invokeImmediately) {
  getIpInfo()
    .then((ipInfo) => {
      if (invokeImmediately) console.log('ip info: ', ipInfo);
      const [lat, lng] = ipInfo.loc.split(',');
      return getYahooWeather(lat, lng);
    })
    .then((d) => {
      if (invokeImmediately) console.log('weather: ', d);
      const [ today, tomorrow ] = d.forecasts;
      const code = d['current_observation'].condition.code;
      const weather = d['current_observation'].condition.text;
      const laterCode = today.code;
      const laterWeather = today.text;
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
        now: {
          code, weather, temp,
        },
        today: {
          high, low, code: laterCode, weather: laterWeather, sunset, sunrise,
        },
        tomorrow: {
          code: tCode, weather: tWeather, high: tHigh, low: tLow,
        },
      };
      const string = makeString(parts);
      const cached = JSON.stringify({
        ...parts,
        locale: {
          timestamp: new Date(),
          timezone: d.location.timezone_id,
          lat: d.location.lat,
          lng: d.location.long,
        },
      }, null, '  ');
      fs.writeFileSync(lastWeather, cached, { encoding: 'utf8' });
      if (invokeImmediately) console.log('parts: ', parts);
      console.log(string);
    }).catch((e) => {
      console.log(e);
      console.log('');
    });
} else {
  try {
    const raw = fs.readFileSync(lastWeather, { encoding: 'utf8' });
    console.log(makeString(JSON.parse(raw)));
  } catch(e) {
    console.log(e);
    console.log('');
  }
}
