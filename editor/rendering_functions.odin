package editor

import rl "vendor:raylib"

measure_rune :: proc(c: rune, font: rl.Font, font_scale: f32) -> f32 {
	idx := rl.GetGlyphIndex(font, c)

	return f32(font.glyphs[idx].image.width) * font_scale
}

render_slice :: proc(
	slice: []$T,
	pos: Vec2,
    opts: FontOpts,
	color: rl.Color,
) {
	font := rl.IsFontValid(opts.font) ? opts.font : rl.GetFontDefault()
	pos := pos
	dim := Vec2{0, opts.font_size}
	font_scale := opts.font_size / f32(font.baseSize)
	for c, i in slice {
        c := rune(c)

		dim.x = measure_rune(c, font, font_scale)

		rl.DrawTextCodepoint(font, c, pos, opts.font_size, color)

		pos.x += dim.x + opts.font_spacing
	}
}

render_slice_callback :: proc(
	slice: []$T,
	pos: Vec2,
    opts: FontOpts,
	color: rl.Color,
	callback: proc(_: ^Vec2, _: Vec2),
	callback_idx: int,
) {
	font := rl.IsFontValid(opts.font) ? opts.font : rl.GetFontDefault()
	pos := pos
	dim := Vec2{opts.font_size / 2., opts.font_size}
	font_scale := opts.font_size / f32(font.baseSize)
    i := 0
	for c in slice {
        c := rune(c)

		dim.x = measure_rune(c, font, font_scale)

		if i == callback_idx {
			callback(&pos, dim)
		}

		rl.DrawTextCodepoint(font, c, pos, opts.font_size, color)

		pos.x += dim.x + opts.font_spacing
        i += 1
	}
	if callback_idx == i {
		callback(&pos, dim)
	}
}


measure_slice :: proc(slice: []$T, opts: FontOpts) -> Vec2 {
    font := rl.IsFontValid(opts.font) ? opts.font : rl.GetFontDefault()
    font_scale := opts.font_spacing / f32(font.baseSize)

    width: Vec2

    for c in slice {
        c := rune(c)
        idx := rl.GetGlyphIndex(font, c)
        width.x += f32(font.glyphs[idx].image.width) + opts.font_spacing
    }

    width.y = opts.font_size
    return width
}
