const spotify = require('spotify-node-applescript');

const trunc = (s, l) => s.length - 3 < l ? s : s.substring(0, l) + '...';

const pad = n => n > 10 ? String(n) : `0${n}`;

const timeString = (rawSeconds) => {
  const seconds = rawSeconds % 60;
  const minutes = Math.floor((rawSeconds % 3600) / 60);
  const hours = Math.floor(rawSeconds / 3600);

  const finalHours = hours ? `${hours}:` : '';
  const finalMinutes = hours ? pad(minutes) : `${minutes}`;
  const finalSeconds = pad(seconds);

  return `${finalHours}${finalMinutes}:${finalSeconds}`;
};

const p = (fn) => new Promise((resolve, reject) =>
  fn((e, d) => e ? reject(e) : resolve(d)));

(async () => {
  try {
    const isRunning = await p(spotify.isRunning)
    if (!isRunning) return console.log('');
  } catch (e) {
    return console.log('')
  }
  return Promise.all([
    p(spotify.getState),
    p(spotify.getTrack),
    p(spotify.isShuffling),
    p(spotify.isRepeating),
  ])
    .then(([state, track, isShuffling, repeating]) => {
      const r = repeating ? ' ⟳' : '';
      const s = state.state === 'playing' ? '►' : '✘';
      const shuf = isShuffling ? ' ⤭' : '';
      const playStates = `[ ${s}${shuf}${r} ]`;

      const curr = timeString(state.position);
      const tot = timeString(Math.floor(track.duration / 1000));
      const times = `[${curr} - ${tot}]`;

      const string = `${playStates} ${track.artist} - ${track.name} ${times}`;
      const truncString = `${playStates} ${trunc(track.artist, 17)} - ${trunc(track.name, 40)} ${times}`;

      if (process.argv[2]) return console.log(state, track, string, truncString, timeString(state.position));

      console.log(`#[fg=colour10,bg=colour240]#[fg=colour232,bg=colour10,bold] ${truncString} `);
    });
})()
