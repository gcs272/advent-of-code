const fs = require('fs');

type Tile = { id: string, contents: string[] };

const readTiles = (): Tile[] => {
  let buf = Buffer.alloc(1024 * 1024);
  let len = fs.readSync(process.stdin.fd, buf);
  return buf.toString('utf8', 0, len - 1).split('\n\n').map((c) => {
    let lines = c.split('\n');
    return {
      id: lines[0].substring(5, lines[0].length - 1),
      contents: lines.slice(1)
    };
  })
}

// top, bottom, left, right edges plus their reverse
const edges = (t: Tile): string[] => {
  let basics = [
    t.contents[0],
    t.contents[t.contents.length - 1],
    t.contents.map(l => l[0]).join(''),
    t.contents.map(l => l[l.length - 1]).join('')
  ];

  return basics.concat(basics.map(l => l.split('').reverse().join('')));
}

const connections = (t: Tile, others: Tile[]): number => {
  return edges(t).filter(edge => {
    return others.some(other => {
      return edges(other).indexOf(edge) != -1;
    })
  }).length;
}

type ConnectionCount = { id: string, count: number };

let tiles = readTiles();
let corners: ConnectionCount[] = tiles
  .map(t => { return { id: t.id, count: connections(t, tiles.filter(ot => ot != t)) } })
  .filter(a => a.count == 4);

console.log('one=' + corners.map(c => parseInt(c.id)).reduce((acc, i) => acc * i, 1));
