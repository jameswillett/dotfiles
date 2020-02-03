const exec = require('child_process').exec;
const { weed } = require('./emojis');

const longDir = process.argv[2] || 'Users/james.willett/documents/hello.js';
const branch = process.argv[3];

const prettyBranch = !branch ? '' : ` #[fg=#ffaa00] ${branch}`;

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

exec(`cd ${longDir}; git status -s`, (e, sO) => {
  if (e || !sO) return console.log(`${shortDir}${prettyBranch}`);
  const statusMap = sO.split('\n').reduce((a, c) => {
    if (!c) return a;
    const k = c.substring(0,2).replace(/\s/g, '');
    return {
      ...a,
      [k]: (a[k] || 0) + 1,
    };
  }, {});
  const statusString = Object.keys(statusMap).reduce((a, c) => {
    return a.concat(`${c}: ${statusMap[c]}`);
  }, []).join(', ');
  console.log(`${shortDir}${prettyBranch}${statusString ? ` [${statusString}]` : ''}`);
});
