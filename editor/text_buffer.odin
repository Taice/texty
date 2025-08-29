package editor

import "core:fmt"
import rl "vendor:raylib"

TextBuffer :: [dynamic]rune

remove_idx :: proc(self: ^TextBuffer, idx: int) {
    if len(self) > 0 {
        ordered_remove(self, min(idx, len(self) - 1))
    }
}
