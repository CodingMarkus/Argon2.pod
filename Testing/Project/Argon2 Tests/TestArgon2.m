//
//  Created by Markus Hanauska on 2017-03-17.
//

#import <XCTest/XCTest.h>

#import "Argon2KeyDerivator.h"

@interface TestArgon2 : XCTestCase

@end


@implementation TestArgon2

- (void)test {
#	define OUT_LEN 32
#	define hashtest(v0, t0, m0, p0, pwd0, salt0, hexref0, mcfref0)            \
	do {                                                                      \
		NSError * error = nil;                                                \
		NSData * rawPwd = [NSData dataWithBytes:pwd0 length:strlen(pwd0)];    \
		NSData * rawSalt = [NSData dataWithBytes:salt0 length:strlen(salt0)]; \
		NSData * result = [Argon2KeyDerivator makeKeyOfLength:OUT_LEN         \
			usingType:Argon2i rounds:t0 memory:1 << m0 threads:p0             \
			password:rawPwd salt:rawSalt outError:&error                      \
		];                                                                    \
		XCTAssertNotNil(result);                                              \
		if (result) XCTAssertNil(error);                                      \
		if (result && !error) {                                               \
			const uint8_t * outPtr = result.bytes;                            \
			unsigned char hex_out[(OUT_LEN * 2) + 4] = { 0 };                 \
			for (int i = 0; i < OUT_LEN; i++) {                               \
				sprintf((char *)(hex_out + (i * 2)), "%02x", outPtr[i]);      \
			}                                                                 \
			XCTAssert(memcmp(hex_out, hexref0, OUT_LEN * 2) == 0);            \
		}                                                                     \
	} while(0)

	// Original reference vectors follow below:
    hashtest(version, 2, 16, 1, "password", "somesalt",
             "c1628832147d9720c5bd1cfd61367078729f6dfb6f8fea9ff98158e0d7816ed0",
             "$argon2i$v=19$m=65536,t=2,p=1$c29tZXNhbHQ"
             "$wWKIMhR9lyDFvRz9YTZweHKfbftvj+qf+YFY4NeBbtA");
    hashtest(version, 2, 20, 1, "password", "somesalt",  
             "d1587aca0922c3b5d6a83edab31bee3c4ebaef342ed6127a55d19b2351ad1f41",
             "$argon2i$v=19$m=1048576,t=2,p=1$c29tZXNhbHQ"  
             "$0Vh6ygkiw7XWqD7asxvuPE667zQu1hJ6VdGbI1GtH0E");
    hashtest(version, 2, 18, 1, "password", "somesalt",
             "296dbae80b807cdceaad44ae741b506f14db0959267b183b118f9b24229bc7cb",
             "$argon2i$v=19$m=262144,t=2,p=1$c29tZXNhbHQ"
             "$KW266AuAfNzqrUSudBtQbxTbCVkmexg7EY+bJCKbx8s");
    hashtest(version, 2, 8, 1, "password", "somesalt",
             "89e9029f4637b295beb027056a7336c414fadd43f6b208645281cb214a56452f",
             "$argon2i$v=19$m=256,t=2,p=1$c29tZXNhbHQ"
             "$iekCn0Y3spW+sCcFanM2xBT63UP2sghkUoHLIUpWRS8");
    hashtest(version, 2, 8, 2, "password", "somesalt",
             "4ff5ce2769a1d7f4c8a491df09d41a9fbe90e5eb02155a13e4c01e20cd4eab61",
             "$argon2i$v=19$m=256,t=2,p=2$c29tZXNhbHQ"
             "$T/XOJ2mh1/TIpJHfCdQan76Q5esCFVoT5MAeIM1Oq2E");
    hashtest(version, 1, 16, 1, "password", "somesalt",
             "d168075c4d985e13ebeae560cf8b94c3b5d8a16c51916b6f4ac2da3ac11bbecf",
             "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQ"
             "$0WgHXE2YXhPr6uVgz4uUw7XYoWxRkWtvSsLaOsEbvs8");
    hashtest(version, 4, 16, 1, "password", "somesalt",
             "aaa953d58af3706ce3df1aefd4a64a84e31d7f54175231f1285259f88174ce5b",
             "$argon2i$v=19$m=65536,t=4,p=1$c29tZXNhbHQ"
             "$qqlT1YrzcGzj3xrv1KZKhOMdf1QXUjHxKFJZ+IF0zls");
    hashtest(version, 2, 16, 1, "differentpassword", "somesalt",
             "14ae8da01afea8700c2358dcef7c5358d9021282bd88663a4562f59fb74d22ee",
             "$argon2i$v=19$m=65536,t=2,p=1$c29tZXNhbHQ"
             "$FK6NoBr+qHAMI1jc73xTWNkCEoK9iGY6RWL1n7dNIu4");
    hashtest(version, 2, 16, 1, "password", "diffsalt",
             "b0357cccfbef91f3860b0dba447b2348cbefecadaf990abfe9cc40726c521271",
             "$argon2i$v=19$m=65536,t=2,p=1$ZGlmZnNhbHQ"
             "$sDV8zPvvkfOGCw26RHsjSMvv7K2vmQq/6cxAcmxSEnE");
}

@end
