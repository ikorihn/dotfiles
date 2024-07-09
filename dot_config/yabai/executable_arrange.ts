#!bun run

import { $ } from "bun";
import { parseArgs } from "node:util";

const RIGHT_HALF = "16:10:5:0:5:16";
const LEFT_HALF = "16:10:0:0:5:16";
const TOP_RIGHT = "16:10:5:0:5:8";
const BOTTOM_RIGHT = "16:10:5:8:5:8";
const RIGHT_70 = "16:10:7:0:3:16";
const LEFT_70 = "16:10:0:0:7:16";
const LEFT_60 = "16:20:0:0:11:16";
const RIGHT_40 = "16:20:11:0:9:16";
const FULL = "1:1:0:0:1:1";

function split(leftPercent: number, overwrap: number = 0) {
  return [`16:100:0:0:${leftPercent + overwrap}:16`, `16:100:${leftPercent - overwrap}:0:${100 - leftPercent + overwrap}:16`];
}

const width = Number.parseInt(await $`yabai -m query --displays --display | jq '.frame.w | floor'`.text());
const percent = width < 3000 ? split(50, 10) : split(50);
const left = percent[0];
const right = percent[1];

interface Window {
  id: number;
  app: string;
  title: string;
  space: number;
  "is-floating": boolean;
}

async function arrange_float() {
  const windows = (await $`yabai -m query --windows`.json()) as Window[];

  let i = 0;
  const gridmap = new Map();
  for (const window of windows) {
    if (/System Settings|Karabiner.*|Finder|Bitwarden|KeePassXC|カレンダー/.test(window.app)) {
      console.log(window.app, "ignore");
      continue;
    }

    if (width < 2000) {
      await $`yabai -m window ${window.id} --grid ${FULL}`;
      continue;
    }

    switch (window.app) {
      case "Alacritty":
        gridmap.set(window.app, right);
        break;
      case "Vivaldi":
        gridmap.set(window.app, left);
        break;
      default:
        let grid = gridmap.get(window.app);
        if (grid == null) {
          if (i % 2 === 0) {
            grid = left;
          } else {
            grid = right;
          }
          i++;
          gridmap.set(window.app, grid);
        }
    }

    const grid = gridmap.get(window.app);
    console.log(window.app, grid);
    await $`yabai -m window ${window.id} --grid ${grid}`;
  }
}

const { values } = parseArgs({
  args: Bun.argv.slice(2),
  options: {
    position: {
      type: "string",
      short: "p",
    },
  },
  strict: true,
});

const position = values.position;

if (position === "left") {
  await $`yabai -m window --grid ${left}`;
} else if (position === "right") {
  await $`yabai -m window --grid ${right}`;
} else {
  await arrange_float();
}
