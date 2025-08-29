package main

import "core:os"
import "core:strings"
import e "editor"
import rl "vendor:raylib"

main :: proc() {
	state: e.Editor

	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(500, 500, "big sigma thing")
	defer rl.CloseWindow()

	font := "/usr/share/fonts/gnu-free/FreeMono.otf"
	if len(os.args) > 1 {
		font = os.args[1]
	}

	font_f := rl.LoadFont("/usr/share/fonts/gnu-free/FreeMono.otf")

	cstr := strings.clone_to_cstring(font)
	defer delete(cstr)
	state = e.make_editor(cstr)
	defer e.free_editor(&state)


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
