#!bun run

import { $ } from "bun";

const RIGHT_HALF = "16:10:5:0:5:16";
const LEFT_HALF = "16:10:0:0:5:16";
const TOP_RIGHT = "16:10:5:0:5:8";
const BOTTOM_RIGHT = "16:10:5:8:5:8";
const LEFT_70 = "16:10:0:0:7:16";
const RIGHT_70 = "16:10:3:0:7:16";
const FULL = "1:1:0:0:1:1";

interface Window {
  id: number;
  app: string;
  title: string;
  space: number;
  "is-floating": boolean;
}

async function arrange_float() {
  const width =
    await $`yabai -m query --displays --display | jq '.frame.w | floor'`.text();
  const windows = (await $`yabai -m query --windows`.json()) as Window[];

  let i = 0;
  const gridmap = new Map();
  for (const window of windows) {
    if (
      /System Settings|Karabiner.*|Finder|Bitwarden|KeePassXC|カレンダー/.test(
        window.app,
      )
    ) {
      console.log(window.app, "ignore");
      continue;
    }

    if (parseInt(width) < 2000) {
      $`yabai -m window $id --grid ${FULL}`;
      continue;
    }

    switch (window.app) {
      case "Alacritty":
        gridmap.set(window.app, RIGHT_HALF);
        break;
      case "Vivaldi":
        gridmap.set(window.app, LEFT_HALF);
        break;
      default:
        let grid = gridmap.get(window.app);
        if (grid == null) {
          if (i % 2 === 0) {
            grid = LEFT_HALF;
          } else {
            grid = RIGHT_HALF;
          }
          i++;
          gridmap.set(window.app, grid);
        }
    }

    const grid = gridmap.get(window.app)
    console.log(window.app, grid);
    await $`yabai -m window ${window.id} --grid ${grid}`;
  }
}

await arrange_float();
