let KeymapSectionSchema = {
  context | String | optional,
  use_key_equivalents | Bool | optional,
  bindings | { _ : String }
}
in

{
  ZedKeymapSchema = Array KeymapSectionSchema
}
