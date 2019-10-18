const spotify = require('spotify-node-applescript');

const p = (fn) => new Promise((resolve, reject) =>
  fn((e, d) => {
    if (e) return reject(e);
    return resolve(d);
  }));

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
      const r = repeating ? ' 🔁' : '';
      const s = state.state === 'playing' ? '▶️'  : '⏸';
      const shuf = isShuffling ? ' 🔀' : '';
      const string = `${s} ${shuf}${r} : ${track.artist} - ${track.name}`;
      console.log(`#[fg=colour10,bg=colour245]#[fg=colour232,bg=colour10,bold] ${string} `);
    });
})()
