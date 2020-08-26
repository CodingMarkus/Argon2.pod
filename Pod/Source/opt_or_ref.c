//
//  Created by CodingMarkus on 2020-08-26.
//

#ifdef __x86_64__
	#include "../Submodules/phc-winner-argon2.git/src/opt.c"
#else
	#include "../Submodules/phc-winner-argon2.git/src/ref.c"
#endif

