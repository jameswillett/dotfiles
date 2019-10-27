const applescript = require('applescript');

const trunc = (s, l) => s.length - 3 < l ? s : s.substring(0, l) + '...';

const pad = n => n >= 10 ? String(n) : `0${n}`;

const timeString = (rawSeconds) => {
  const flooredSeconds = Math.round(rawSeconds);
  const seconds = flooredSeconds % 60;
  const minutes = Math.floor((flooredSeconds % 3600) / 60);
  const hours = Math.floor(flooredSeconds / 3600);

  const finalHours = hours ? `${hours}:` : '';
  const finalMinutes = hours ? pad(minutes) : `${minutes}`;
  const finalSeconds = pad(seconds);

  return `${finalHours}${finalMinutes}:${finalSeconds}`;
};

const v = (num, muted = false) => {
  if (num == 0 || muted) return '✘';
  if (num < 15) return '▁';
  if (num < 30) return '▂';
  if (num < 45) return '▃';
  if (num < 60) return '▄';
  if (num < 75) return '▅';
  if (num < 88) return '▆';
  if (num < 100) return '▇';
  return '█';
};

const getRunningApp = (data) => {
  const { spotify, itunes, system } = JSON.parse(data);
  const app = (() => {
    if (spotify && spotify.running && itunes && itunes.running) {
      return itunes.state === 'playing' ? itunes : spotify;
    } else if (spotify && spotify.running) {
      return spotify;
    } else if (itunes && itunes.running) {
      return itunes;
    }
  })();

  const fg = 232;
  const bg = app && app.app === 'spotify' ? 10 : 213;
  return { app, fg, bg, system };
}

const p = (fn) => new Promise((resolve, reject) =>
  fn((e, d) => e ? reject(e) : resolve(d)));

applescript.execFile('/Users/james/configs/scripts/music', (err, d) => {
  if (err) return console.log(err);
  const lastBg = process.argv[2];
  const { app, fg, bg, system } = getRunningApp(d);
  const sysVol = (background) =>
    `#[fg=colour240,bg=colour${background},bold]#[fg=colour39,bg=colour240] 🔈 ${v(system.volume, system.muted)} `;
  if (!app || !app.running) return console.log(sysVol(lastBg));
  const {
    shuffling, repeating, state,
    position, duration,
    artist, title, volume,
  } = app;

  const r = repeating ? ' ⟳' : '';
  const s = state === 'playing' ? '►' : '✘';
  const shuf = shuffling ? ' ⤭' : '';
  const playStates = `[ ${s}${shuf}${r} ]`;

  const curr = timeString(position);
  const tot = timeString(duration);
  const times = `[${curr} - ${tot}]`;

  const string = `${playStates} ${artist} - ${title} ${times}`;
  const truncString = `${
    playStates // is this an ugly way to do this?
  } ${
    trunc(artist, 17) // probably.
  }${
    artist ? ' - ' : '' // do i care?
  }${
    trunc(title, artist ? 30 : 45) // nope
  } ${
    times // sorry
  } #[fg=colour9]${
    v(volume)
  } ${
    sysVol(bg)
  }`;

  console.log(`#[fg=colour${bg},bg=colour${lastBg}]#[fg=colour${fg},bg=colour${bg},bold] ${truncString}`);
});
