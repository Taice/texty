package editor

import "core:fmt"
move_left :: proc(self: ^Editor) {
	if self.cur.x > 0 {
		len := len(self.data[self.cur.y])
		if self.cur.x < len {
			self.cur.x -= 1
		} else {
			self.cur.x = len - 1
		}
	} else {
		if self.cur.y > 0 {
			move_up(self)
			self.cur.x = len(&self.data[self.cur.y])
		} else {
			self.cur.x = 0
		}
	}
}

move_right :: proc(self: ^Editor) {
	row := self.data[self.cur.y]

	if self.cur.x < len(&row) {
		self.cur.x += 1
	} else {
		if self.cur.y + 1 < len(self.data) {
			move_down(self)
			self.cur.x = 0
		}
	}
}

move_up :: proc(self: ^Editor) {
	self.cur.y -= 1
    self.camera.pos -= 1
	if self.camera.pos < self.camera.lim {
		self.camera.pos = self.camera.lim
	}
}

move_up_checked :: proc(self: ^Editor) {
	if self.cur.y > 0 {
		move_up(self)
	}
}

move_down :: proc(self: ^Editor) {
	self.cur.y += 1
	self.camera.pos += 1
	if abs_diff(self.camera.pos, self.camera.n_rows) < self.camera.lim {
		self.camera.pos = self.camera.n_rows - self.camera.lim
	}
}

move_down_checked :: proc(self: ^Editor) {
	if self.cur.y + 1 < len(self.data) {
		move_down(self)
	}
}

insert_enter :: proc(self: ^Editor) {
	row := &self.data[self.cur.y]
	idx := min(self.cur.x, len(row))
	new_row := make(TextBuffer)

	if idx != len(row) {
		append(&new_row, ..row[idx:])

		remove_range(row, idx, len(row))
	}

	move_down(self)
	self.cur.x = 0
	inject_at(&self.data, self.cur.y, new_row)
}
