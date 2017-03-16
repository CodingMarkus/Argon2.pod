Pod::Spec.new do |spec|
 	spec.name     = 'Argon2'
 	spec.version  = '1.0.0'
 	spec.license  = { :type => 'Apache License Version 2' }
 	spec.homepage = 'https://github.com/CodingMarkus/Argon2.pod'
	spec.authors  = { 'Markus Hanauska' => 'CodingMarkus@hanauska.name' }
	spec.summary  = 'The Argon2 key derivator as a CocaPod to be used in Obj-C or Swift.'
	spec.source   = { :git => 'https://github.com/CodingMarkus/Argon2.pod', :tag => spec.version }

	spec.framework           = 'Foundation'
	spec.source_files        = 'Pod/Source/*.{h,m}','Pod/Include/*.h'
	spec.public_header_files = 'Pod/Include/*.h'
end
