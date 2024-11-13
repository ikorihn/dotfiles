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
  return [
    `16:100:1:0:${leftPercent + overwrap}:16`,
    `16:100:${leftPercent - overwrap}:0:${100 - 1 - leftPercent + overwrap}:16`,
  ];
}

const width = Number.parseInt(
  await $`yabai -m query --displays --display | jq '.frame.w | floor'`.text(),
);

interface Window {
  id: number;
  app: string;
  title: string;
  space: number;
  "is-floating": boolean;
}

async function arrange_float(overwrap: number) {
  const percent = split(50, overwrap);
  const left = percent[0];
  const right = percent[1];

  const windows = (await $`yabai -m query --windows`.json()) as Window[];

  let i = 0;
  const gridmap = new Map();
  for (const window of windows) {
    if (
      /System Settings|Karabiner.*|Finder|Bitwarden|KeePassXC|カレンダー|Calendar|Tandem/.test(
        window.app,
      )
    ) {
      console.log(window.app, "ignore");
      continue;
    }

    if (width < 1600) {
      await $`yabai -m window ${window.id} --grid ${FULL}`;
      continue;
    }

    switch (window.app) {
      case "Alacritty":
        gridmap.set(window.app, right);
        break;
      case "Vivaldi":
        gridmap.set(window.app, right);
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
    overwrap: {
      type: "string",
      short: "w",
      default: "0",
    },
    full: {
      type: "boolean",
      short: "f",
    },
  },
  strict: true,
});

const position = values.position;
const overwrap = parseInt(values.overwrap ?? (width < 3000 ? "20" : "0"));
const percent = split(50, overwrap);
const left = percent[0];
const right = percent[1];

if (values.full) {
  await $`yabai -m window --grid ${FULL}`;
} else if (position === "left") {
  await $`yabai -m window --grid ${left}`;
} else if (position === "right") {
  await $`yabai -m window --grid ${right}`;
} else {
  await arrange_float(overwrap);
}
