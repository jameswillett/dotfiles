const applescript = require('applescript');

const trunc = (s, l) => s.length - 3 < l ? s : s.substring(0, l) + '...';

const pad = n => n >= 10 ? String(n) : `0${n}`;

const timeString = (rawSeconds) => {
  const seconds = rawSeconds % 60;
  const minutes = Math.floor((rawSeconds % 3600) / 60);
  const hours = Math.floor(rawSeconds / 3600);

  const finalHours = hours ? `${hours}:` : '';
  const finalMinutes = hours ? pad(minutes) : `${minutes}`;
  const finalSeconds = pad(seconds);

  return `${finalHours}${finalMinutes}:${finalSeconds}`;
};

const v = (num) => {
  if (num == 0) return ' ';
  if (num < 15) return '▁';
  if (num < 30) return '▂';
  if (num < 45) return '▃';
  if (num < 60) return '▄';
  if (num < 75) return '▅';
  if (num < 88) return '▆';
  if (num < 100) return '▇';
  return '█';
};

const p = (fn) => new Promise((resolve, reject) =>
  fn((e, d) => e ? reject(e) : resolve(d)));

applescript.execFile('/Users/james/configs/scripts/spotify', (err, d) => {
  if (err) return;
  const data = JSON.parse(d);
  if (!data.running) return;
  const {
    shuffling, repeating, state,
    position, duration,
    artist, title, volume,
  } = JSON.parse(d)

  const r = repeating ? ' ⟳' : '';
  const s = state === 'playing' ? '►' : '✘';
  const shuf = shuffling ? ' ⤭' : '';
  const playStates = `[ ${s}${shuf}${r} ]`;

  const curr = timeString(position);
  const tot = timeString(Math.floor(duration));
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
  }`;

  console.log(`#[fg=colour10,bg=colour240]#[fg=colour232,bg=colour10,bold] ${truncString} `);
});
