const fs = require('fs');

const configs = require('./configs');
const { getIpInfo, getYahooWeather } = require('./apiStuff');
const { getEmoji, getRising } = require('./emojis');


const width = process.argv[2];
const invokeImmediately = process.argv[3] === 'true';

const isFirstSession = (process.argv[4] || '').indexOf(process.argv[5]) === 0 || invokeImmediately;

const lastWeather = `${process.env.HOME}/lastweather.json`;

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
  const bg = 'colour233';
  const fg = '#BBBBBB';
  const main = `#[bg=${bg}] ${getEmoji(now.code)} ${getColor(now.temp, fg)}℉`;
  if (width < 200) return main;
  const highLow = ` [${getEmoji(today.code)} ${getColor(today.high, fg)}℉/${getColor(today.low, fg)}℉]`;
  if (width < 220 ) return main + highLow;
  const tomorrow = ` [${getEmoji(t.code)} ${getColor(t.high, fg)}℉/${getColor(t.low, fg)}℉]`;
  if (width < 240) return main + highLow + tomorrow;
  const atmosphere = ` #[fg=#ffffff,bold]${now.bar}#[nobold]"☿${getRising(now)} #[bold]${now.humidity}#[nobold]%#[fg=${fg}]`;
  return main + atmosphere + highLow + tomorrow;
};

const now = new Date();

if ((now.getSeconds() === 0 || invokeImmediately) && isFirstSession) {
  getIpInfo()
    .then((ipInfo) => {
      if (invokeImmediately) console.log('ip info: ', ipInfo);
      const [lat, lng] = (ipInfo.loc === configs.workIpLoc
        ? configs.workLoc
        : ipInfo.loc
      ).split(',');
      return getYahooWeather(lat, lng);
    })
    .then((d) => {
      if (invokeImmediately) console.log('weather: ', d);
      const [ today, tomorrow ] = d.forecasts;
      const now = d['current_observation'];
      const parts = {
        now: {
          code: now.condition.code, weather: now.condition.text, temp: now.condition.temperature,
          bar: now.atmosphere.pressure, rising: now.atmosphere.rising, humidity: now.atmosphere.humidity,
        },
        today: {
          high: today.high, low: today.low, code: today.code,
          weather: today.text, sunset: now.astronomy.sunset, sunrise: now.astronomy.sunrise,
        },
        tomorrow: {
          code: tomorrow.code, weather: tomorrow.text, high: tomorrow.high, low: tomorrow.low,
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
