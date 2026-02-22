import Lake
open Lake DSL

package «GFF» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩
  ]

require «GaussianField» from git
  "https://github.com/mrdouglasny/gaussian-field.git" @ "main"

require «QFTFramework» from git
  "https://github.com/mrdouglasny/QFTFramework.git" @ "main"

@[default_target]
lean_lib «GFF» where
