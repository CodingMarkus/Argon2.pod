//
//  Created by Markus Hanauska on 2017-03-16.
//
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

+ (NSData *_Nullable)makeKeyOfLength:(uint32_t)desiredOutputLength
	usingType:(Argon2Type)type rounds:(uint32_t)rounds
	memory:(uint32_t)memoryInKiB threads:(uint32_t)threadCount
	password:(NSData *_Nullable)password salt:(NSData *_Nonnull)salt
	outError:(NSError *_Nullable *_Nullable)outError
{
	verifyNotNil(salt, "salt");

	struct RangeTest tests[ ] = {
		{ desiredOutputLength, ARGON2_MIN_OUTLEN, ARGON2_MAX_OUTLEN,
			"desiredOutputLength"
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
		}
	};
	processRangeTests(tests, SIZE_OF_ARRAY(tests));

	NSMutableData * result = [[NSMutableData alloc]
		initWithLength:desiredOutputLength
	];
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

	int errCode = argon2_hash(
		rounds, memoryInKiB, threadCount,
		password.bytes, password.length, salt.bytes, salt.length,
		result.mutableBytes, desiredOutputLength, NULL, 0,
		atype, ARGON2_VERSION_13
	);

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

@end

NSString *_Nonnull const Argon2ErrorDomain = @"Argon2ErrorDomain";
