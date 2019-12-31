const longDir = process.argv[2] || 'Users/james.willett/documents/hello.js';

const shortDir = longDir.replace(/^\//, '').split('/').reduce((a, c, i, arr) => {
  if (i < arr.length - 1) {
    c = c[0];
  }
  if (i === 0 && c === '~') return c;
  return `${a}/${c}`;
}, '');

console.log(shortDir);

