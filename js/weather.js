const axios = require('axios');
const fs = require('fs');
const { weather } = require('./configs');

const width = process.argv[2];
const lastWeather = `${process.env.HOME}/.lastweather`;

const getEmoji = (icon) => {
  if (/01/.test(icon)) {
    if (/d$/.test(icon)) return '🌞';
    return '🌚';
  }
  if (/02/.test(icon)) return '🌤';
  if (/03/.test(icon)) return '🌥';
  if (/04/.test(icon)) return '☁️';
  if (/09/.test(icon)) return '🌧';
  if (/10/.test(icon)) return '🌦';
  if (/11/.test(icon)) return '⚡️';
  if (/13/.test(icon)) return '☃️';
  if (/50/.test(icon)) return '🌫';
  return '';
};

const getColor = temp => {
  const fg = (() => {
    if (temp >= 90) return 1;
    if (temp > 75) return 3;
    if (temp > 55) return 2;
    if (temp > 32) return 14;
    return 21;
  })();
  return `#[fg=colour${fg}]${temp}#[fg=colour255]`;
}
const makeString = ({ icon, temp, high, low }) => {
  let color = 238;
  const main = `#[fg=colour${color}]#[bg=colour${color},fg=colour255] ${getEmoji(icon)}  ${getColor(temp)}℉`
  if (width < 200) return main;
  const extra = ` [ ↑${getColor(high)}℉ ↓${getColor(low)}℉ ]`
  return main + extra;
}

const now = new Date();

if (now.getSeconds() === 0) {
  axios.get('https://ipinfo.io')
    .then(r => r.data)
    .then(({ postal }) =>
      axios.get(
        `http://api.openweathermap.org/data/2.5/weather?zip=${postal},us&appid=${weather}&units=imperial`
      ))
    .then(r => r.data)
    .then((d) => {
      const { icon } = d.weather[0];
      const temp = Math.floor(d.main.temp);
      const high = Math.floor(d.main.temp_max);
      const low = Math.floor(d.main.temp_min);
      const sunset = new Date(d.sys.sunset * 1000)
      const sunrise = new Date(d.sys.sunrise * 1000)
      const parts = { icon, temp, high, low };
      const string = makeString(parts);
      const cached = JSON.stringify(parts)
      fs.writeFileSync(lastWeather, cached, { encoding: 'utf8' });
      console.log(string);
    }).catch((e) => {console.log(e); console.log('');})
} else {
  try {
    const raw = fs.readFileSync(lastWeather, { encoding: 'utf8' });
    console.log(makeString(JSON.parse(raw)));
  } catch(e) {
  }
}
