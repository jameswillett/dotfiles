const axios = require('axios');
const OAuth = require('oauth');

const { darkSkySecret, yahooAppId, yahooClientId, yahooClientSecret } = require('./configs');

const header = {
  'X-Yahoo-App-Id': yahooAppId,
};

const weatherRequest = new OAuth.OAuth(
  null,
  null,
  yahooClientId,
  yahooClientSecret,
  '1.0',
  null,
  'HMAC-SHA1',
  null,
  header
);

const getYahooWeather = (lat = '39.38319', lon = '-76.551872') => new Promise((resolve, reject) => {
  weatherRequest.get(
    `https://weather-ydn-yql.media.yahoo.com/forecastrss?lat=${lat}&lon=${lon}&format=json`,
    null,
    null,
    (err, data /*, result */) => err
      ? reject(err)
      : resolve(JSON.parse(data))
  );
});

const getIpInfo = () => axios.get('https://ipinfo.io').then(r => r.data);

const getDarkSkyWeather = (lat = '39.38319', lon = '-76.551872') => axios.get(
  `https://api.darksky.net/forecast/${darkSkySecret}/${lat},${lon}`
);

module.exports = { getDarkSkyWeather, getIpInfo, getYahooWeather };
