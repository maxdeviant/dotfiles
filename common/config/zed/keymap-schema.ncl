let KeymapSectionSchema = {
  context | String | optional,
  use_key_equivalents | Bool | optional,
  bindings | { _ : Dyn }
}
in

{
  ZedKeymapSchema = Array KeymapSectionSchema
}
