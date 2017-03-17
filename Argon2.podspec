Pod::Spec.new do |spec|
 	spec.name     = 'Argon2'
 	spec.version  = '1.0.1'
 	spec.license  = { :type => 'Apache License Version 2' }
 	spec.homepage = 'https://github.com/CodingMarkus/Argon2.pod'
	spec.authors  = { 'Markus Hanauska' => 'CodingMarkus@hanauska.name' }
	spec.summary  = 'The Argon2 key derivator as a CocaPod to be used in Obj-C or Swift.'
	spec.source   = { :git => 'https://github.com/CodingMarkus/Argon2.pod.git',
		              :tag => spec.version, :submodules => true }

	submodulePath = 'Pod/Submodules'
	argon2Path    = "#{submodulePath}/phc-winner-argon2.git"

	spec.framework           = 'Foundation'
	spec.source_files        = 'Pod/Source/*.{h,m}', 'Pod/Include/*.h',
	                           "#{argon2Path}/include/argon2.h",
	                           "#{argon2Path}/src/argon2.c",
							   "#{argon2Path}/src/opt.c",
							   "#{argon2Path}/src/core.{c,h}",
							   "#{argon2Path}/src/thread.{c,h}",
							   "#{argon2Path}/src/encoding.{c,h}",
							   "#{argon2Path}/src/blake2/*.{c,h}"
	spec.public_header_files = 'Pod/Include/*.h'
end
