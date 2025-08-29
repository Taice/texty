package main

import rl "vendor:raylib"
import e "editor"

main :: proc() {

	state: e.Editor
    state = e.make_editor("font")
	defer e.free_editor(&state)
    assert(len(state.data) != 0)

    rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(500, 500, "big sigma thing")
	defer rl.CloseWindow()


	rl.SetTargetFPS(60)

    e.update_camera_rows(&state.camera, int(state.opts.font_size))

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		e.update(&state)
		e.render_editor(&state)

		rl.EndDrawing()
	}
}
