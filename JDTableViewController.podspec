Pod::Spec.new do |s|
  s.name         = "JDTableViewController"
  s.version      = "0.0.1"
  s.summary      = "JDTableViewController"
  s.description  = <<-DESC
                   DESC
  s.homepage     = "https://github.com/johannesd/JDTableViewController.git"
  s.license      = { 
    :type => 'Custom permissive license',
    :text => <<-LICENSE
          Free for commercial use and redistribution. No warranty.

        	Johannes Dörr
        	mail@johannesdoerr.de
    LICENSE
  }
  s.author       = { "Johannes Doerr" => "mail@johannesdoerr.de" }
  s.platform     = :ios, '5.0'
  s.source_files  = '*.{h,m}'

  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true

  s.dependency 'JDCategories', '~> 0.0.1'
  s.dependency 'JDUIUpdates', '~> 0.0.1'

end
