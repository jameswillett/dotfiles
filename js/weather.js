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
  `#[bold]${
    getDayOfWeek(c)
  }#[nobold]:#[fg=#ffaa00,bold][#[fg=${fg},nobold]${
    getEmoji(c.code, service)
  }${
    c.precip ? ` (${Math.floor(c.precip * 100)}%)` : ''
  } ${
    getColor(c.high, fg)
  }℉/${
    getColor(c.low, fg)
  }℉#[fg=#ffaa00,bold]]#[fg=${fg},nobold]`;

const PRECIP_THRESH = 0.005;

const makeString = ({ now, today, tomorrow: t, later: l, extendedForecast, nextPrecip }, service) => {
  const rightNow = new Date();
  const showMoon = rightNow < new Date(today.sunrise * 1000) || rightNow > new Date(today.sunset * 1000);
  const sigPrecip = now.precipIntensity >= PRECIP_THRESH;
  const fg = '#BBBBBB';
  const main = ` ${getEmoji(now.code, service)} ${getColor(now.temp, fg)}℉`;
  const later = ` -> ${getEmoji(l.code, service)} ${getColor(l.temp, fg)}℉`;
  const precipString = (() => {
    if (sigPrecip && !nextPrecip) return ' for the hour';
    if (nextPrecip) {
      return ` ${
        getEmoji(nextPrecip.precipType, service)
      }${sigPrecip ? 'stopping' : ''} in ${
        Math.ceil((new Date(nextPrecip.time * 1000) - rightNow) / 1000 / 60)
      }m`;
    }
    return '';
  })();
  const moon = showMoon ? ` ${getMoon(today.moonPhase)}` : '';
  const highLow = '   ' + stringForDay(today, service, fg);
  const tomorrow = '    ' + stringForDay(t, service, fg);
  const WEATHER = main + later + precipString + moon + highLow + tomorrow;
  const maxExtended = (width - 120) / 22;
  if (width < 90) return WEATHER;
  const extended = extendedForecast.reduce((a, c, i) => {
    if (i > maxExtended) return a;
    return a + '    ' + stringForDay(c, service, fg);
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

const errorMessage = blob => {
  console.log(`#[fg=#ff0000,bold]could not get weather. last ran at #[fg=#ff69b4]${blob.locale.timestamp}#[nobold]`);
};

if ((now.getSeconds() === 0 || invokeImmediately) && isFirstSession) {
  getIpInfo()
    .then((ipInfo) => {
      if (invokeImmediately) console.log('ip info: ', ipInfo);
      const atWork = ipInfo.loc === configs.workIpLoc ||
        ipInfo.hostname === configs.workHostname ||
        ipInfo.org === configs.workOrg;

      const [lat, lng] = (atWork
        ? configs.workLoc
        : ipInfo.loc
      ).split(',');
      return getDarkSkyWeather(lat, lng);
    })
    .then((d) => {
      if (invokeImmediately) console.log('weather: ', d);
      if (d.error) return errorMessage(d);
      const { currently, hourly, daily, minutely } = d;
      const isUnavailable = !!d.flags['darksky-unavailable'];
      const later = hourly.data[0];
      const [ today, tomorrow, ...restOfDays] = daily.data;
      const sigPrecip = currently.precipIntensity >= PRECIP_THRESH;
      const nextPrecip = !isUnavailable && minutely.data.find((m, i) => {
        if (i === 0) return;
        if (sigPrecip) return m.precipIntensity < PRECIP_THRESH;
        return m.precipIntensity >= PRECIP_THRESH;
      });
      const parts = {
        now: {
          code: currently.icon, weather: currently.summary, temp: currently.temperature,
          bar: currently.pressure, humidity: currently.humidity,
          precip: currently.precipProbability, precipIntensity: currently.precipIntensity, precipType: currently.precipType,
        },
        later: {
          code: later.icon, weather: later.summary, temp: later.temperature,
          bar: later.pressure, humidity: later.humidity,
          precip: later.precipProbability, precipIntensity: later.precipIntensity, precipType: later.precipType,
        },
        today: mapDay(today),
        tomorrow: mapDay(tomorrow),
        minutely,
        isUnavailable,
        nextPrecip,
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
        error: false,
        poweredBy: 'Dark Sky (https://darksky.net/poweredby/)',
      }, null, '  ');
      fs.writeFileSync(lastWeather, cached, { encoding: 'utf8' });
      if (invokeImmediately) console.log('parts: ', parts);
      console.log(string);
    }).catch((e) => {
      const error = { error: true, locale: { timestamp: new Date() } };
      fs.writeFileSync(lastWeather, error, { encoding: 'utf-8' });
      errorMessage(error);
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
