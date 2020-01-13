const longDir = process.argv[2] || 'Users/james.willett/documents/hello.js';
const branch = process.argv[3];

const prettyBranch = !branch ? '' : ` #[fg=#ffaa00] ${branch}`;

const shortDir = longDir.replace(new RegExp(`^${process.env.HOME}`), '~')
  .replace(/^\//, '')
  .split('/')
  .reduce((a, c, i, arr) => {
    if (i < arr.length - 1) {
      c = c[0];
    }
    if (i === 0 && c === '~') return c;
    return `${a}/${c}`;
  }, '');

console.log(`${shortDir}${prettyBranch}`);

