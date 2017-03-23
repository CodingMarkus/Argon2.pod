# Argon2.pod
The Argon2 key derivation function as a CocaPod.

Quote from the [Argon2 specification](
https://github.com/P-H-C/phc-winner-argon2/blob/master/argon2-specs.pdf):

> Passwords, despite all their drawbacks, remain the primary form of
> authentication on various web-services. Passwords are usually stored in a
> hashed form in a server’s database. These databases are quite often captured
> by the adversaries, who then apply dictionary attacks since passwords tend
> to have low entropy. Protocol designers use a number of tricks to mitigate
> these issues. Starting from the late 70’s, a password is hashed together
> with a random salt value to prevent detection of identical passwords across
> different users and services. The hash function computations, which became
> faster and faster due to Moore’s law have been called multiple times to
>increase the cost of password trial for the attacker.
>
> In the meanwhile, the password crackers migrated to new architectures,
> such as FPGAs, multiple-core GPUs and dedicated ASIC modules, where the
> amortized cost of a multiple-iterated hash function is much lower. It was
> quickly noted that these new environments are great when the computation is
> almost memoryless, but they experience difficulties when operating on a large
> amount of memory. The defenders responded by designing memory-hard functions,
> which require a large amount of memory to be computed, and impose
> computational penalties if less memory is used. The password hashing
> scheme `scrypt` is an instance of such function.
>
> *[...]*
>
> **Our Solution**
> We offer a hashing scheme called Argon2. Argon2 summarizes the state of the
> art in the design of memory-hard functions. It is a streamlined and simple
> design. It aims at the highest memory filling rate and effective use of
> multiple computing units, while still providing defense against tradeoff
> attacks. Argon2 is optimized for the x86 architecture and exploits the
> cache and memory organization of the recent Intel and AMD processors.


Quote from the
[Wikipedia entry about Argon2](https://en.wikipedia.org/wiki/Argon2):

> Argon2is a key derivation function that was selected
> [as the winner](https://eprint.iacr.org/2016/104.pdf) of the
> [Password Hashing Competition](https://password-hashing.net)
> in July 2015. It was designed by Alex Biryukov, Daniel Dinu, and
> Dmitry Khovratovich from [University of Luxembourg](http://wwwen.uni.lu)
>
> Argon2 is released under a Creative Commons CC0 license, and provides three
> related versions:
>
>  - Argon2d maximizes resistance to GPU cracking attacks.
>  - Argon2i is optimized to resist side-channel attacks.
>  - Argon2id is a hybrid version out of Argon2d and Argon2i.
>
> All three allow specification by three parameters that control:
>
>  - execution time
>  - memory required
>  - degree of parallelism
