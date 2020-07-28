const cp = require('child_process');
const { weed } = require('./emojis');

const longDir = process.argv[2] || process.cwd();

const exec = cmd => {
  try {
    return cp.execSync(cmd, { encoding: 'utf8', cwd: longDir });
  } catch (e) {
    // if theres an error we just dont care about it
    return '';
  }
};

const shortDir = longDir.replace(new RegExp(`^${process.env.HOME}`), '~')
  .replace(/^~\/leafly-dev/, weed)
  .replace(/^\//, '')
  .split('/')
  .reduce((a, c, i, { length }) => {
    if (i < length - 1 && c !== weed) {
      if (c[0] === '.') {
        c = c[0] + c[1];
      } else {
        c = c[0];
      }
    }
    if (i === 0 && (c === '~' || c === weed)) return c;
    return `${a}/${c}`;
  }, '');

const statuses = exec('git status -sb');

const statusArray = statuses.split('\n');

const statusString = !statuses ? '' : (() => {
  const statusMap = statusArray.reduce((a, c) => {
    if (!c || /^##/.test(c)) return a;
    const k = c.substring(0,2);
    return {
      ...a,
      [k]: (a[k] || 0) + 1,
    };
  }, {});
  const statusString = Object.keys(statusMap).reduce((a, c) => {
    const styled = [...c].reduce((sA, sC, i) => {
      if (!sC || sC === ' ') return sA;
      if (sC === '?') return `${sA}#[fg=#ff0000]${sC}`;
      const color = i ? 'ff0000' : '22dd22';
      return `${sA}#[fg=#${color}]${sC}`;
    }, '');
    return a.concat(`${styled.trim()}#[fg=#dddddd]:${statusMap[c]}`);
  }, []).join(', ');
  return statusString;
})();

const originArr = statusArray[0].replace(/\.\.\.origin\//, ' ').split(' ');
const branch = originArr[1];

const origin = originArr[2] || branch;

const prettyBranch = !branch ? '' : `#[fg=#dddddd]  #[fg=#ffaa00] ${branch}`;

const [unmergedCommits, unpushedCommits] = exec(`
  git rev-list --left-right --count origin/${origin}...${branch}
`).split(/\s+/).map(Number);

const segments = [
  shortDir,
  prettyBranch,
  unmergedCommits ? ` #[fg=#bbbbff]${unmergedCommits}⬇︎` : '',
  unpushedCommits ? ` #[fg=#bbbbff]${unpushedCommits}⬆` : '',
  statusString ? ` [${statusString}#[fg=#ffaa00]]` : '',
];

console.log(segments.join('#[fg=#ffaa00]'));
