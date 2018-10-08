Pod::Spec.new do |s|
          
	s.name         = "RSSelectionMenu"
  	s.version      = "5.3.2"

    s.summary      = "An elegant selection list or dropdown menu for iOS with single or multiple selections."
  	s.description  = <<-DESC
    RSSelectionMenu provides easy to use features to show drop-down or selection list with the single or multiple selections.
   	RSSelectionMenu can work with custom cells as well.
                    DESC

  	s.homepage     = "https://github.com/rushisangani/RSSelectionMenu"

    s.screenshots  = "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/01.gif", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/02.gif", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/03.gif"

  
  	s.license      = { :type => "MIT", :file => "LICENSE" }
  	s.author       = { "Rushi Sangani" => "rushisangani@gmail.com" }
  	s.source       = { :git => "https://github.com/rushisangani/RSSelectionMenu.git", :tag => s.version }

    s.ios.deployment_target = '9.0'
  	s.source_files = "RSSelectionMenu/**/*.swift"

    s.requires_arc = true
    s.pod_target_xcconfig = { "SWIFT_VERSION" => "4.2" }
end
