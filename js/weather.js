const fs = require('fs');

const configs = require('./configs');
const { getIpInfo, getDarkSkyWeather } = require('./apiStuff');
const { getEmoji, getMoon } = require('./emojis');

const width = process.argv[2];
const invokeImmediately = process.argv[3] === 'true';

const isFirstSession = (process.argv[4] || '').indexOf(process.argv[5]) === 0 || invokeImmediately;

const lastWeather = `${process.env.HOME}/lastweather.json`;

const toHex = n => (n + (16 * n)).toString(16).padStart(2, '0');

const getColor = (tempDirty, fg) => {
  let R = 15, G = 15, B = 15;

  const temp = Math.floor(Number(tempDirty));
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

const days = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];
const getDayOfWeek = day => days[new Date(day.date).getDay()];

const stringForDay = (c, service, fg) =>
  ` #[bold]${
    getDayOfWeek(c)
  }#[nobold]:[${
    getEmoji(c.code, service)
  }${
    c.precip ? ` (${c.precip * 100}%)` : ''
  } ${
    getColor(c.high, fg)
  }℉/${
    getColor(c.low, fg)
  }℉]`;

const makeString = ({ now, today, tomorrow: t, later: l, extendedForecast }, service) => {
  const rightNow = new Date();
  const showMoon = rightNow < new Date(today.sunrise * 1000) || rightNow > new Date(today.sunset * 1000);
  const bg = 'colour233';
  const fg = '#BBBBBB';
  const main = `#[bg=${bg}] ${getEmoji(now.code, service)} ${getColor(now.temp, fg)}℉`;
  const later = ` -> ${getEmoji(l.code, service)} ${getColor(l.temp, fg)}℉`;
  const moon = showMoon ? ` ${getMoon(today.moonPhase)}` : '';
  const highLow = stringForDay(today, service, fg);
  const tomorrow = stringForDay(t, service, fg);
  const WEATHER = main + later + moon + highLow + tomorrow;
  const maxExtended = (width - 140) / 10;
  if (width < 100) return WEATHER;
  const extended = extendedForecast.reduce((a, c, i) => {
    if (i > maxExtended) return a;
    return a + stringForDay(c, service, fg);
  }, '');
  return WEATHER + extended;
 
};

const now = new Date();

const mapDay = d => ({
  date: new Date(d.time * 1000), high: d.temperatureHigh, low: d.temperatureLow, code: d.icon,
  weather: d.summary, sunset: d.sunsetTime, sunrise: d.sunriseTime,
  precip: d.precipProbability, precipIntensity: d.precipIntensity, precipType: d.precipType,
  moonPhase: d.moonPhase,
});

if ((now.getSeconds() === 0 || invokeImmediately) && isFirstSession) {
  getIpInfo()
    .then((ipInfo) => {
      if (invokeImmediately) console.log('ip info: ', ipInfo);
      const [lat, lng] = (ipInfo.loc === configs.workIpLoc
        ? configs.workLoc
        : ipInfo.loc
      ).split(',');
      return getDarkSkyWeather(lat, lng);
    })
    // .then(() => JSON.parse(fs.readFileSync(sampleDarkskyResponse, { encoding: 'utf8' })))
    .then((d) => {
      if (invokeImmediately) console.log('weather: ', d);
      const { currently, hourly, daily } = d;
      const later = hourly.data[0];
      const [ today, tomorrow, ...restOfDays] = daily.data;
      const parts = {
        now: {
          code: currently.icon, weather: currently.summary, temp: currently.temperature,
          bar: currently.pressure, humidity: currently.humidity,
          precip: currently.precipProbability, precipIntensity: currently.precipIntensity, precipType: currently.precipType,
        },
        later: {
          code: later.icon, weather: later.summary, temp: later.temperature,
          bar: later.pressure, humidity: later.humidity,
        },
        today: mapDay(today),
        tomorrow: mapDay(tomorrow),
        extendedForecast: restOfDays.map(mapDay),
      };
      const string = makeString(parts, 'darksky');
      const cached = JSON.stringify({
        ...parts,
        locale: {
          timestamp: new Date(),
          timezone: d.timezone,
          lat: d.latitude,
          lng: d.longitude,
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
    console.log(makeString(JSON.parse(raw), 'darksky'));
  } catch(e) {
    console.log(e);
    console.log('');
  }
}
