let { ZedKeymapSchema } = import "./keymap-schema.ncl" in
[
  {
    bindings = {
      "ctrl-," = null,
    }
  },
  {
    context = "Editor",
    bindings = {
      "ctrl-;" = null,
      ctrl-shift-k = "editor::DeleteLine",
      alt-up = "editor::MoveLineUp",
      alt-down = "editor::MoveLineDown",
      ctrl-shift-l = "editor::SelectAllMatches",
      ctrl-shift-b = "git::Blame",
      alt-z = "editor::ToggleSoftWrap",
      alt-q = "editor::Rewrap"
    }
  }
] | ZedKeymapSchema
