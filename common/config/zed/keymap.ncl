let { ZedKeymapSchema } = import "./keymap-schema.ncl" in
[
  {
    context = "Editor",
    bindings = {
      cmd-shift-k = "editor::DeleteLine",
      alt-up = "editor::MoveLineUp",
      alt-down = "editor::MoveLineDown",
      cmd-shift-l = "editor::SelectAllMatches",
      cmd-shift-b = "editor::ToggleGitBlame",
      alt-q = "editor::Rewrap"
    }
  }
] | ZedKeymapSchema
