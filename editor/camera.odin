package editor

import rl "vendor:raylib"

Camera :: struct {
	pos:    int,
	lim:    int,
	n_rows: int,
    center: int, 
}

update_camera_rows :: proc(self: ^Camera, row_height: int) {
    self.n_rows = int(rl.GetScreenHeight()) / row_height
    self.center = self.n_rows / 2
}
