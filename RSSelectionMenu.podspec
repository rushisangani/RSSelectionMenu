Pod::Spec.new do |s|
          
	s.name         = "RSSelectionMenu"
  	s.version      = "1.0.0"
  	s.requires_arc = true
  	s.summary      = "An elegant selection list or dropdown menu for iOS with single or multiple selections."
  	s.description  = <<-DESC
    RSSelectionMenu provides easy to use features to show drop-down or selection list with the single or multiple selections.
   	RSSelectionMenu can work with custom cells as well.
                   DESC
  	s.homepage     = "https://github.com/rushisangani/RSSelectionMenu"
  
  	s.license      = { :type => "GNU GENERAL PUBLIC LICENSE", :file => "LICENSE" }
  	s.author       = { "Rushi Sangani" => "rushisangani@gmail.com" }
  	s.platform     = :ios, "10.0"
  	s.source       = { :git => "https://github.com/rushisangani/RSSelectionMenu.git", :tag => "1.0.0" }
  	s.source_files = "RSSelectionMenu/**/*.{h,m,swift}"
end
