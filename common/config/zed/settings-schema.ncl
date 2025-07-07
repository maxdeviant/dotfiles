let LanguageSettingsSchema = {
  tab_size | Number | optional,
  language_servers | Array String | optional,
  ..
}
in

let ProjectPanelSchema = {
  auto_fold_dirs | Bool | optional,
  sticky_scroll | Bool | optional,
}
in

{
  ZedSettingsSchema = {
    base_keymap | String | optional,
    buffer_font_family | String | optional,
    buffer_font_size | Number | optional,
    ui_font_family | String | optional,
    ui_font_size | Number | optional,
    format_on_save | String | optional,
    seed_search_query_from_cursor | String | optional,
    when_closing_with_no_tabs | String | optional,
    show_whitespaces | String | optional,
    project_panel | ProjectPanelSchema | optional,
    tabs | { file_icons | Bool | optional } | optional,
    inlay_hints | { enabled | Bool | optional } | optional,
    languages | { _ : LanguageSettingsSchema } | optional,
    ..
  },
}
