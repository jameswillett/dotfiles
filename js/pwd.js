const cp = require('child_process');
const { weed } = require('./emojis');


const longDir = process.argv[2] || 'Users/james.willett/documents/hello.js';

const exec = cmd => {
  try {
    return cp.execSync(cmd, { encoding: 'utf8', cwd: longDir });
  } catch (e) {
    // if theres an error we just dont care about it
    return '';
  }
};

const branch = exec('git rev-parse --abbrev-ref HEAD').trim();
const prettyBranch = !branch ? '' : `#[fg=#dddddd]  #[fg=#ffaa00] ${branch}`;

const shortDir = longDir.replace(new RegExp(`^${process.env.HOME}`), '~')
  .replace(/^~\/leafly-dev/, weed)
  .replace(/^\//, '')
  .split('/')
  .reduce((a, c, i, arr) => {
    if (i < arr.length - 1 && c !== weed) {
      if (c[0] === '.') {
        c = c[0] + c[1];
      } else {
        c = c[0];
      }
    }
    if (i === 0 && (c === '~' || c === weed)) return c;
    return `${a}/${c}`;
  }, '');

const statuses = exec('git status -s');

const statusString = !statuses ? '' : (() => {
  const statusMap = statuses.split('\n').reduce((a, c) => {
    if (!c) return a;
    const k = c.substring(0,2).replace(/\s/g, '');
    return {
      ...a,
      [k]: (a[k] || 0) + 1,
    };
  }, {});
  const statusString = Object.keys(statusMap).reduce((a, c) => {
    return a.concat(`${c}:${statusMap[c]}`);
  }, []).join(', ');
  return statusString;
})();

const unpushedCommits = exec('git cherry -v').split('\n').reduce((a, c) => {
  if (!c) return a;
  return a + 1;
}, 0);

const segments = [
  shortDir,
  prettyBranch,
  unpushedCommits ? ` #[fg=#bbbbff]${unpushedCommits}⬆` : '',
  statusString ? ` [#[fg=#22dd22]${statusString}#[fg=#ffaa00]]` : '',
];

console.log(segments.join(''));
