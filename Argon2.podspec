Pod::Spec.new do |spec|
	##########################################################################
	## General infos
	#####
 	spec.name     = 'Argon2'
 	spec.version  = '1.3'
 	spec.license  = { :type => 'Apache License 2.0',
					  :file => 'License.txt' }

 	spec.homepage = 'https://github.com/CodingMarkus/Argon2.pod'
	spec.authors  = { 'CodingMarkus' =>
					  '26418089+CodingMarkus@users.noreply.github.com' }

	spec.summary  = 'The Argon2 key derivation function as a CocoaPod.'
	spec.source   = { :git => 'https://github.com/CodingMarkus/Argon2.pod.git',
	                  :tag => "Releases/#{spec.version}", :submodules => true }

	##########################################################################
	## What to build
	####
	submodulePath = 'Pod/Submodules'
	argon2Path    = "#{submodulePath}/phc-winner-argon2.git"

	spec.source_files         = 'Pod/Source/*.{h,m}', 'Pod/Include/*.h',
															"#{argon2Path}/include/argon2.h",
	                            "#{argon2Path}/src/argon2.c",
	                            "#{argon2Path}/src/core.{c,h}",
	                            "#{argon2Path}/src/thread.{c,h}",
	                            "#{argon2Path}/src/encoding.{c,h}",
	                            "#{argon2Path}/src/blake2/*.{c,h}"

	spec.osx.source_files     = "Pod/Source/opt_or_ref.c"
	spec.ios.source_files     = "#{argon2Path}/src/ref.c"
	spec.tvos.source_files    = "#{argon2Path}/src/ref.c"
	spec.watchos.source_files = "#{argon2Path}/src/ref.c"

	spec.public_header_files = 'Pod/Include/*.h'

	spec.osx.preserve_path    = "#{argon2Path}/src/ref.c",
	                            "#{argon2Path}/src/opt.c"

	##########################################################################
	## How to build
	####
	spec.requires_arc   = true
	spec.compiler_flags = '-O3'
	spec.framework      = 'Foundation'
end
