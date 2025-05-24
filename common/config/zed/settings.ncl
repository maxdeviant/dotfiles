let { ZedSettingsSchema } = import "./settings-schema.ncl" in
{
  base_keymap = "VSCode",
  theme = "Melange Dark",
  buffer_font_family = "Fira Code Retina",
  buffer_font_size = 14,
  buffer_font_features = {
    ss09 = true
  },
  ui_font_family = "Zed Plex Sans",
  ui_font_size = 16,
  format_on_save = "off",
  seed_search_query_from_cursor = "selection",
  when_closing_with_no_tabs = "keep_window_open",
  show_whitespaces = "boundary",
  project_panel = {
    auto_fold_dirs = false
  },
  git = {
    inline_blame = {
      enabled = false
    }
  },
  tabs = {
    file_icons = true
  },
  inlay_hints = {
    enabled = true
  },
  features = {
    edit_prediction_provider = "zed"
  },
  completions = {
    words = "disabled"
  },
  edit_predictions = {
    mode = "subtle",
    disabled_globs = ["*.md"]
  },
  agent = {
    version = "2",
    default_model = {
      provider = "zed.dev",
      model = "claude-sonnet-4"
    },
    preferred_completion_mode = "max",
    always_allow_tool_actions = true,
    single_file_review = false
  },
  languages = {
    Gleam = {
      language_servers = ["gleam", "..."]
    },
    Nickel = {
      tab_size = 2,
      language_servers = ["nls", "..."]
    },
    Nix = {
      tab_size = 2,
      language_servers = ["!nil", "!nixd", "..."]
    },
    Rust = {
      preferred_line_length = 120
    },
    SCSS = {
      tab_size = 2
    },
    SQL = {
      prettier = {
        allowed = false
      }
    },
    WIT = {
      language_servers = ["!wit", "..."]
    }
  },
  lsp = {
    rust-analyzer = {
      initialization_options = {
        imports = {
          prefix = "crate",
          granularity = {
            enforce = true,
            group = "module"
          }
        }
      }
    }
  }
}
  | ZedSettingsSchema
