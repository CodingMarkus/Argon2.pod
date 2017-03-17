//
//  Created by Markus Hanauska on 2017-03-17.
//

#import <XCTest/XCTest.h>

#import "Argon2KeyDerivator.h"

#define OUT_LEN 32


//    char encoded[ENCODED_LEN];
//    int ret, i;
//
//    ret = argon2_hash(t, 1 << m, p, pwd, strlen(pwd), salt, strlen(salt), out,
//                      OUT_LEN, encoded, ENCODED_LEN, Argon2_i, version);
//    assert(ret == ARGON2_OK);
//
//    for (i = 0; i < OUT_LEN; ++i)
//        sprintf((char *)(hex_out + i * 2), "%02x", out[i]);
//
//    assert(memcmp(hex_out, hexref, OUT_LEN * 2) == 0);
//
//    if (ARGON2_VERSION_NUMBER == version) {
//        assert(memcmp(encoded, mcfref, strlen(mcfref)) == 0);
//    }
//
//    ret = argon2_verify(encoded, pwd, strlen(pwd), Argon2_i);
//    assert(ret == ARGON2_OK);
//    ret = argon2_verify(mcfref, pwd, strlen(pwd), Argon2_i);
//    assert(ret == ARGON2_OK);
//
//    printf("PASS\n");


@interface TestArgon2 : XCTestCase

@end


@implementation TestArgon2

- (void)test {

#	define hashtest(v0, t0, m0, p0, pwd0, salt0, hexref0, mcfref0) \
		[self t:t0 m:m0 p:p0 pwd:pwd0 salt:salt0 hexref:hexref0 mcfref:mcfref0]

	// Original reference vectors follow below:
    hashtest(version, 2, 16, 1, "password", "somesalt",
             "c1628832147d9720c5bd1cfd61367078729f6dfb6f8fea9ff98158e0d7816ed0",
             "$argon2i$v=19$m=65536,t=2,p=1$c29tZXNhbHQ"
             "$wWKIMhR9lyDFvRz9YTZweHKfbftvj+qf+YFY4NeBbtA");
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


- (void)t:(uint32_t)t m:(uint32_t)m p:(uint32_t)p
	pwd:(char *)pwd salt:(char *)salt
	hexref:(char *)hexref mcfref:(char *)mcfref
{
	NSError * error = nil;
	NSData * rawPwd = [NSData dataWithBytes:pwd length:strlen(pwd)];
	NSData * rawSalt = [NSData dataWithBytes:salt length:strlen(salt)];
	NSData * result = [Argon2KeyDerivator makeKeyOfLength:OUT_LEN
		usingType:Argon2i rounds:t memory:1 << m threads:p
		password:rawPwd salt:rawSalt outError:&error
	];
	XCTAssertNotNil(result);
	if (!result) return;

	const uint8_t * outPtr = result.bytes;
	unsigned char hex_out[(OUT_LEN * 2) + 4] = { 0 };
	for (int i = 0; i < OUT_LEN; i++) {
		sprintf((char *)(hex_out + (i * 2)), "%02x", outPtr[i]);
	}
	XCTAssert(memcmp(hex_out, hexref, OUT_LEN * 2) == 0);
}

@end
