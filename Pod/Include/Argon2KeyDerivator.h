//
//  Created by Markus Hanauska on 2017-03-16.
//

/*
Runs Argon2 with certain inputs and parameters, inputs not cleared. Prints the
Base64-encoded hash string
@out output array with at least 32 bytes allocated
@pwd NULL-terminated string, presumably from argv[]
@salt salt array
@t_cost number of iterations
@m_cost amount of requested memory in KB
@lanes amount of requested parallelism
@threads actual parallelism
@type Argon2 type we want to run
@encoded_only display only the encoded hash
@raw_only display only the hexadecimal of the hash
@version Argon2 version
*/

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, Argon2Type) {
	/// Argon2i instead uses data-independent memory access, which is preferred
	/// for password hashing and password-based key derivation, but it is
	/// slower as it makes more passes over the memory to protect from tradeoff
	/// attacks.
	Argon2i,

	/// Argon2d is faster and uses data-depending memory access, which makes it
	/// highly resistant against GPU cracking attacks and suitable for
	/// applications with no threats from side-channel timing attacks (eg.
	/// cryptocurrencies).
	Argon2d,

	/// Argon2id is a hybrid of Argon2i and Argon2d, using a combination of
	/// data-depending and data-independent memory accesses, which gives some
	/// of Argon2i's resistance to side-channel cache timing attacks and much
	/// of Argon2d's resistance to GPU cracking attacks.
	Argon2id
};


@interface Argon2KeyDerivator : NSObject

	/// Make a key using Argon2
	///
	/// @param desiredOutputLength Desired length of returned \c NSData object.
	///        Allowed range: [4, 2^32]
	/// @param type The algorithm to use, see types above.
	/// @param rounds The number of rounds to use. More rounds use more CPU
	///        time and thus makes the key harder to compute.
	///        Allowed range: [1, 2^32]
	/// @param memory The amount of memory in KibiBytes to use. More memory
	///        makes it harder to attach the key for brute force number
	///        cruncher that usually have a lot of computation power but rather
	///        little memory.
	///        Allowed range: [8, 2^32] (equals 8 kiB to 4 TiB)
	///        <b>But never more than half of the process address space!</b>
	/// @param threads The number of lanes and threads to use for computation.
	///        More threads makes it harder for simple hardware devices to
	///        break the key as these devices usually have no threading and
	///        and emulating threading costs a lot more computation power.
	///        Allowed range: [1, 2^32]
	/// @param password The actual password. \c nil is the same as feeding data
	///        of length zero.
	/// @param salt The salt. Allowed range: [8, 2^32]
	/// @param outError Unless \c nil, errors are written to \c outError
	///
	/// @return The Argon2 digest of length \c desiredOutputLegnth, \c nil in
	///         case of an error.
	+ (NSData *_Nullable)makeKeyOfLength:(uint32_t)desiredOutputLength
		usingType:(Argon2Type)type rounds:(uint32_t)rounds
		memory:(uint32_t)memoryInKiB threads:(uint32_t)threadCount
		password:(NSData *_Nullable)password salt:(NSData *_Nonnull)salt
		outError:(NSError *_Nullable *_Nullable)outError;

@end


/// The Argon2 error domain
extern NSString *_Nonnull const Argon2ErrorDomain;

typedef NS_ENUM(int, Argon2Error) {
	/// Internal error in the implementation.
	Argon2ErrorInternal,

	/// Memory allocation failed.
	Argon2ErrorMemoryAllocation
};
