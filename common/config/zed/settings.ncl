let { ZedSettingsSchema } = import "./settings-schema.ncl" in
{
  base_keymap = "VSCode",
  theme = "Melange Dark",
  buffer_font_family = "Fira Code Retina",
  buffer_font_size = 14,
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
  edit_predictions = {
    mode = "auto",
    disabled_globs = ["*.md"]
  },
  assistant = {
    version = "2",
    default_model = {
      provider = "zed.dev",
      model = "claude-3-5-sonnet-20240620-fast-edit"
    }
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
