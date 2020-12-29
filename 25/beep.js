const fs = require('fs');

const findLoopSize = (subject, target) => {
  let rounds = 0;
  let current = 1;
  while (current != target) {
    current = (current * subject) % 20201227;
    rounds++;
  }
  return rounds;
}

const findEncryptionKey = (subject, rounds) => {
  let current = 1;
  for (let i = 0; i < rounds; i++) {
    current = (current * subject) % 20201227;
  }
  return current;
}

const [cardpk, doorpk] = fs.readFileSync('./input')
  .toString()
  .trim()
  .split('\n')
  .map(k => parseInt(k));

let cardRounds = findLoopSize(7, cardpk);
let key = findEncryptionKey(doorpk, cardRounds);
console.log('one=', key);
