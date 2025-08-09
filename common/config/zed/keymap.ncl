let { ZedKeymapSchema } = import "./keymap-schema.ncl" in
[
  {
    bindings = {
      "cmd-," = null,
    }
  },
  {
    context = "Editor",
    bindings = {
      cmd-shift-k = "editor::DeleteLine",
      alt-up = "editor::MoveLineUp",
      alt-down = "editor::MoveLineDown",
      cmd-shift-l = "editor::SelectAllMatches",
      cmd-shift-b = "editor::ToggleGitBlame",
      alt-z = "editor::ToggleSoftWrap",
      alt-q = "editor::Rewrap"
    }
  }
] | ZedKeymapSchema
