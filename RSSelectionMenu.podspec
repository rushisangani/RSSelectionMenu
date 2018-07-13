Pod::Spec.new do |s|
          
	s.name         = "RSSelectionMenu"
  	s.version      = "4.0.2"

    s.summary      = "An elegant selection list or dropdown menu for iOS with single or multiple selections."
  	s.description  = <<-DESC
    RSSelectionMenu provides easy to use features to show drop-down or selection list with the single or multiple selections.
   	RSSelectionMenu can work with custom cells as well.
                    DESC

  	s.homepage     = "https://github.com/rushisangani/RSSelectionMenu"

    s.screenshots  = "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image1.png", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image2.png", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image3.png", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image4.png", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image5.png", "https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/image6.png"

  
  	s.license      = { :type => "MIT", :file => "LICENSE" }
  	s.author       = { "Rushi Sangani" => "rushisangani@gmail.com" }
  	s.source       = { :git => "https://github.com/rushisangani/RSSelectionMenu.git", :tag => s.version }

    s.ios.deployment_target = '9.0'
  	s.source_files = "RSSelectionMenu/**/*.swift"

    s.requires_arc = true
    s.pod_target_xcconfig = { "SWIFT_VERSION" => "4" }
end
