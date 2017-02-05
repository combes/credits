Pod::Spec.new do |spec|
  spec.name = "Credits"
  spec.version = "1.0.0"
  spec.summary = "A framework for displaying third-party attributions in iOS projects."
  spec.homepage = "https://github.com/combes/credits"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Christopher Combes" => 'ChristopherMichaelCombes@gmail.com' }

  spec.platform = :ios, "10.2"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/combes/credits/Credits.git", tag: "v#{spec.version}", submodules: false }
  spec.source_files = "Source/*.swift"
end
