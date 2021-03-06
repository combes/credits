Pod::Spec.new do |s|
  s.name = "Credits"
  s.version = "1.0.1"
  s.summary = "A framework for displaying third-party attributions in iOS projects."
  s.homepage = "https://github.com/combes/credits"
  s.license = { :type=> "MIT", :file => "LICENSE" }
  s.authors = { "Christopher Combes" => "ChristopherMichaelCombes@gmail.com" }
  s.platform = :ios, "9.0"
  s.requires_arc = true
  s.source = { :git => "https://github.com/combes/credits.git", :tag => s.version }
  s.source_files = "Source/*.swift"
  s.resources = "Source/*.{html,storyboard}"
  s.resource_bundles = {
	'Credits' => ['Source/*.{html,storyboard}']
  }
end
