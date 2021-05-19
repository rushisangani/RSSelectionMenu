Pod::Spec.new do |s|
          
	s.name         = "RSSelectionMenu"
  	s.version      = "7.1.3"

    s.summary      = "An elegant selection list or dropdown menu for iOS with single or multiple selections."
  	s.description  = <<-DESC
    RSSelectionMenu provides easy to use features to show drop-down or selection list with the single or multiple selections.
   	RSSelectionMenu can work with custom cells as well.
                    DESC

  	s.homepage     = "https://github.com/rushisangani/RSSelectionMenu"

    s.screenshots  = "https://github.com/rushisangani/RSSelectionMenu/tree/master/Images/multi1.gif", "https://github.com/rushisangani/RSSelectionMenu/tree/master/Images/custom.gif"

  
  	s.license      = { :type => "MIT", :file => "LICENSE" }
  	s.author       = { "Rushi Sangani" => "rushisangani@gmail.com" }
  	s.source       = { :git => "https://github.com/rushisangani/RSSelectionMenu.git", :tag => "v#{s.version}" }

    s.ios.deployment_target = '9.0'
  	s.source_files = "RSSelectionMenu/**/*.swift"

    s.requires_arc = true
    s.swift_versions = ['4.2', '5.0', '5.1', '5.2']
end
