#!/usr/bin/env node
/*eslint no-console: 0*/

/*

Convert characters into hex representation suitable for use in SQL.

$ echo string | ./conv-into-hex-for-mysql.js
input: string
0x73, 0x74, 0x72, 0x69, 0x6E, 0x67
737472696E67
*/

let buf = Buffer('');
process.stdin.on('data', data => {
  // console.log('DEBUG: ' + `data`, data);
  buf = Buffer.concat([buf, data]);
});
process.stdin.on('end', () => {
  // console.log('DEBUG: ' + `end`);
  main(buf);
});

function main(buf) {
  //const s = 'áéíóúüñÁÉÍÓÚÜÑ';
  const s = buf.toString('utf-8').trim();
  console.log(`input: ${s}`);
  let t = s
    .split('')
    .map(c =>
      Buffer.from(c)
        .toString('hex')
        .toUpperCase()
    )
    .map(c => `0x${c}`)
    .join(', ');
  console.log(t);

  t = s
    .split('')
    .map(c =>
      Buffer.from(c)
        .toString('hex')
        .toUpperCase()
    )
    .join('');
  console.log(t);
}

A 65 0x41 u+0041
Buffer.from([65]).toString('utf-8')
Buffer.from([257]).toString('utf-8')
257
'0x101'
