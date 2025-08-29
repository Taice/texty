package editor

import "core:fmt"
import "core:math"
import "core:mem"
import rl "vendor:raylib"

Vec2 :: [2]f32
IVec2 :: [2]int

Editor :: struct {
	data:   [dynamic]TextBuffer,
	cur:    IVec2,
	screen: IVec2,
	opts:   FontOpts,
	camera: Camera,
}

make_editor :: proc(font: cstring, font_size: f32 = 20, font_spacing: f32 = 2) -> Editor {
	state := Editor {
		data = make([dynamic][dynamic]rune),
		screen = get_screen_size(),
		opts = {font = rl.LoadFont(font), font_size = font_size, font_spacing = font_spacing},
	}

	append(&state.data, make([dynamic]rune))

	return state
}

free_editor :: proc(self: ^Editor) {
	for &i in self.data {
		delete(i)
	}

	delete(self.data)
}

update :: proc(self: ^Editor) {
	{ 	// handle chars
		c := rl.GetCharPressed()
		switch c {
		case 0:
		case:
			idx := min(self.cur.x, len(self.data[self.cur.y]))
			inject_at(&self.data[self.cur.y], idx, c)
			self.cur.x += 1
		}
	}

	{ 	// handle keys
		key := rl.GetKeyPressed()

		#partial switch key {
		case .LEFT:
			move_left(self)
		case .RIGHT:
			move_right(self)
		case .UP:
			move_up_checked(self)
		case .DOWN:
			move_down_checked(self)
		case .BACKSPACE:
			remove_idx(&self.data[self.cur.y], self.cur.x)
			self.cur.x -= 1
		case .ENTER, .KP_ENTER:
			insert_enter(self)
		}
	}
}

callback :: proc(pos: ^Vec2, size: Vec2) {
	rl.DrawRectangleV(pos^, size, rl.LIGHTGRAY)
}

render_editor :: proc(self: ^Editor) {
	num_width := measure_rune('8', rl.GetFontDefault(), 2.0)
	x_offset := num_width * 5 + 10
	pos := Vec2{x_offset, 5}

	rl.DrawRectangleRec({0, 0, x_offset, f32(rl.GetScreenHeight())}, rl.DARKGRAY)

	line_buf: [10]u8
    screen_height := f32(rl.GetScreenHeight());
    i := max(self.camera.pos - self.camera.n_rows / 2 - 1, 0)
	for &text_buffer in self.data[i:] {
		pos.x = 5
		line_num := abs_diff(self.cur.y, i)
		inline_num := true
		if line_num == 0 {
			line_num = self.cur.y + 1
			inline_num = false
		}
		buf_len := len(fmt.bprint(line_buf[:], line_num))

		if inline_num {
			width := measure_slice(line_buf[:buf_len], self.opts).x
			pos.x = x_offset - 15 - width
		}

		render_slice(line_buf[:buf_len], pos, self.opts, rl.BLACK)

		pos.x = x_offset + 5

		if i == self.cur.y {
			render_slice_callback(
				text_buffer[:],
				pos,
				self.opts,
				rl.BLACK,
				callback,
				min(self.cur.x, len(text_buffer)),
			)
		} else {
			render_slice(text_buffer[:], pos, self.opts, rl.BLACK)
		}
		pos.y += self.opts.font_size
        if pos.y >= screen_height do break
	}
}

get_screen_size :: proc() -> IVec2 {
	return IVec2{int(rl.GetScreenWidth()), int(rl.GetScreenHeight())}
}

abs_diff :: proc(a, b: $T) -> T {
	return max(a, b) - min(a, b)
}
