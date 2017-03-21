//
//  Created by Markus Hanauska on 2017-03-16.
//

#import "Argon2KeyDerivator.h"

#import "argon2.h"

#define SIZE_OF_ARRAY(x) (sizeof(x) / sizeof(x[0]))

struct RangeTest {
	NSUInteger value;
	NSUInteger min;
	NSUInteger max;
	char * name;
};


static
void verifyNotNil ( id _Nullable anyObject, char *_Nonnull name ) {
	if (!anyObject) {
		[NSException raise:NSInvalidArgumentException
			format:@"%s must not be nil!", name
		];
	}
}


static
void verifyInRange (
	NSUInteger value, NSUInteger min, NSUInteger max, char *_Nonnull name
) {
	if (value < min) {
		[NSException raise:NSInvalidArgumentException
			format:@"%s must be at least %@!", name, @(min)
		];
	}
	if (value > max) {
		[NSException raise:NSInvalidArgumentException
			format:@"%s must be at most %@!", name, @(max)
		];
	}
}


static
void processRangeTests (
	struct RangeTest * tests, size_t count
) {
	for (size_t i = 0; i < count; i++) {
		verifyInRange(
			tests[i].value, tests[i].min, tests[i].max, tests[i].name
		);
	}
}


@implementation Argon2KeyDerivator

+ (NSData *_Nullable)makeKeyOfLength:(uint32_t)length
	usingType:(Argon2Type)type rounds:(uint32_t)rounds
	memory:(uint32_t)memoryInKiB threads:(uint32_t)threadCount
	password:(NSData *_Nullable)password salt:(NSData *_Nonnull)salt
	secretKey:(NSData *_Nullable)secretKey
	additionalData:(NSData *_Nullable)additionalData
	outError:(NSError *_Nullable *_Nullable)outError
{
	verifyNotNil(salt, "salt");

	struct RangeTest tests[ ] = {
		{ length, ARGON2_MIN_OUTLEN, ARGON2_MAX_OUTLEN,
			"length"
		},
		{ rounds, ARGON2_MIN_TIME, ARGON2_MAX_TIME,
			"rounds"
		},
		{ memoryInKiB, ARGON2_MIN_MEMORY, ARGON2_MAX_MEMORY,
			"memoryInKiB"
		},
		{ threadCount, ARGON2_MIN_THREADS, ARGON2_MAX_THREADS,
			"threadCount"
		},
		{ password.length, ARGON2_MIN_PWD_LENGTH, ARGON2_MAX_PWD_LENGTH,
			"password"
		},
		{ salt.length, ARGON2_MIN_SALT_LENGTH, ARGON2_MAX_SALT_LENGTH,
			"salt"
		},
		{ secretKey.length, ARGON2_MIN_SECRET, ARGON2_MAX_SECRET,
			"secretKey"
		},
		{ additionalData.length, ARGON2_MIN_AD_LENGTH, ARGON2_MAX_AD_LENGTH,
			"additionalData"
		}
	};
	processRangeTests(tests, SIZE_OF_ARRAY(tests));

	NSMutableData * result = [[NSMutableData alloc] initWithLength:length];
	if (!result) {
		if (outError) {
			*outError = [NSError errorWithDomain:Argon2ErrorDomain
				code:Argon2ErrorMemoryAllocation userInfo:nil
			];
		}
		return nil;
	}

	argon2_type atype = Argon2_i;
	switch (type) {
		case Argon2i: atype = Argon2_i; break;
		case Argon2d: atype = Argon2_d; break;
		case Argon2id: atype = Argon2_id; break;
	}

	argon2_context context = {
		.out = result.mutableBytes,
		.outlen = length,

		.pwd = (uint8_t *)password.bytes,
		.pwdlen = (uint32_t)password.length,

		.salt = (uint8_t *)salt.bytes,
		.saltlen = (uint32_t)salt.length,

		.secret = (uint8_t *)secretKey.bytes,
		.secretlen = (uint32_t)secretKey.length,

		.ad = (uint8_t *)additionalData.bytes,
		.adlen = (uint32_t)additionalData.length,

		.t_cost = rounds,
		.m_cost = memoryInKiB,
		.lanes = threadCount,
		.threads = threadCount,

		.version = ARGON2_VERSION_13
	};

	int errCode = argon2_ctx(&context, atype);

	NSError * error = nil;
	switch (errCode) {
		case ARGON2_OK:
			break;

		case ARGON2_MEMORY_ALLOCATION_ERROR:
			error = [NSError errorWithDomain:Argon2ErrorDomain
				code:Argon2ErrorMemoryAllocation userInfo:nil
			];
			break;

		default:
			error = [NSError errorWithDomain:Argon2ErrorDomain
				code:Argon2ErrorInternal userInfo:nil
			];
			break;
	}
	if (error) {
		if (outError) *outError = error;
		return nil;
	}

	return result;
}


+ (NSData *_Nullable)makeKeyOfLength:(uint32_t)length
	usingType:(Argon2Type)type rounds:(uint32_t)rounds
	memory:(uint32_t)memoryInKiB threads:(uint32_t)threadCount
	password:(NSData *_Nullable)password salt:(NSData *_Nonnull)salt
	outError:(NSError *_Nullable *_Nullable)outError
{
	return [self makeKeyOfLength:length usingType:type
		rounds:rounds memory:memoryInKiB threads:threadCount
		password:password salt:salt secretKey:nil additionalData:nil
		outError:outError
	];
}


@end

// MARK: Error Domain

NSString *_Nonnull const Argon2ErrorDomain = @"Argon2ErrorDomain";
