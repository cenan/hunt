module test.BigIntegerTest;

import hunt.math.BigInteger;
import hunt.logging;
import hunt.util.exception;

import std.conv;
import std.random;
import std.stdio;



/**
Replace from: random.nextInt\(([\w +-\.]*)\)
to: uniform(0, $1, random)

*/
class BigIntegerTest {

    enum int BITS_KARATSUBA = 2560;
    enum int BITS_TOOM_COOK = 7680;
    enum int BITS_KARATSUBA_SQUARE = 4096;
    enum int BITS_TOOM_COOK_SQUARE = 6912;
    enum int BITS_SCHOENHAGE_BASE = 640;
    enum int BITS_BURNIKEL_ZIEGLER = 2560;
    enum int BITS_BURNIKEL_ZIEGLER_OFFSET = 1280;

    enum int ORDER_SMALL = 60;
    enum int ORDER_MEDIUM = 100;
    // #bits for testing Karatsuba
    enum int ORDER_KARATSUBA = 2760;
    // #bits for testing Toom-Cook and Burnikel-Ziegler
    enum int ORDER_TOOM_COOK = 8000;
    // #bits for testing Karatsuba squaring
    enum int ORDER_KARATSUBA_SQUARE = 4200;
    // #bits for testing Toom-Cook squaring
    enum int ORDER_TOOM_COOK_SQUARE = 7000;

    enum int SIZE = 1000; // numbers per batch

    private static Random random; // = new Random();

    static bool failure = false;


    static void report(string testName, int failCount) {
        writeln(testName~ ": " ~
                           (failCount==0 ? "Passed":"Failed(" ~ failCount.to!string() ~ ")"));
        if (failCount > 0)
            failure = true;
    }


    void testAdd01() {
        BigInteger bint = new BigInteger("234");
		BigInteger bintRes = bint.add(new BigInteger("450"));

        assert(bintRes.toString() == "684", bintRes.toString());
    }


    // /**
    //  * Main to interpret arguments and run several tests.
    //  *
    //  * Up to three arguments may be given to specify the SIZE of BigIntegers
    //  * used for call parameters 1, 2, and 3. The SIZE is interpreted as
    //  * the maximum number of decimal digits that the parameters will have.
    //  *
    //  */
    // void testAll() {
    //     // Some variables for sizing test numbers in bits
    //     int order1 = ORDER_MEDIUM;
    //     int order2 = ORDER_SMALL;
    //     int order3 = ORDER_KARATSUBA;
    //     int order4 = ORDER_TOOM_COOK;

    //     int aa = Character.digit('A', 14);

    //     if (args.length >0)
    //         order1 = (int)((Integer.parseInt(args[0]))* 3.333);
    //     if (args.length >1)
    //         order2 = (int)((Integer.parseInt(args[1]))* 3.333);
    //     if (args.length >2)
    //         order3 = (int)((Integer.parseInt(args[2]))* 3.333);
    //     if (args.length >3)
    //         order4 = (int)((Integer.parseInt(args[3]))* 3.333);

    //     // BigInteger b = BigInteger.valueOf(60000);
    //     // byte[] bytes = b.toByteArray();

    //     constructor();

    //     prime();
    //     nextProbablePrime();

    //     arithmetic(order1);   // small numbers
    //     arithmetic(order3);   // Karatsuba range
    //     arithmetic(order4);   // Toom-Cook / Burnikel-Ziegler range

    //     divideAndRemainder(order1);   // small numbers
    //     divideAndRemainder(order3);   // Karatsuba range
    //     divideAndRemainder(order4);   // Toom-Cook / Burnikel-Ziegler range

    //     pow(order1);
    //     pow(order3);
    //     pow(order4);

    //     square(ORDER_MEDIUM);
    //     square(ORDER_KARATSUBA_SQUARE);
    //     square(ORDER_TOOM_COOK_SQUARE);

    //     squareRoot();
    //     squareRootAndRemainder();

    //     bitCount();
    //     bitLength();
    //     bitOps(order1);
    //     bitwise(order1);

    //     shift(order1);

    //     byteArrayConv(order1);

    //     modInv(order1);   // small numbers
    //     modInv(order3);   // Karatsuba range
    //     modInv(order4);   // Toom-Cook / Burnikel-Ziegler range

    //     modExp(order1, order2);
    //     modExp2(order1);

    //     stringConv();
    //     serialize();

    //     multiplyLarge();
    //     squareLarge();
    //     divideLarge();

    //     if (failure)
    //         throw new RuntimeException("Failure in BigIntegerTest.");
    // }

    // static void testConstructor() {
    //     int failCount = 0;

    //     // --- guard condition tests for array indexing ---

    //     int arrayLength = 23;
    //     int halfLength = arrayLength/2;
    //     byte[] array = new byte[arrayLength];
    //     foreach(size_t i; 0..arrayLength)
    //         array[i] = uniform(byte.min, byte.max, random);

    //     int[][] offLen = [ // offset, length, num exceptions
    //         [-1, arrayLength, 1],                         // negative offset
    //         [0, arrayLength, 0],                          // OK
    //         [1, arrayLength, 1],                          // length overflow
    //         [arrayLength - 1, 1, 0],                      // OK
    //         [arrayLength, 1, 1],                          // offset overflow
    //         [0, -1, 1],                                   // negative length
    //         [halfLength, arrayLength - halfLength + 1, 1] // length overflow
    //     ];

    //     // two's complement
    //     foreach (int[] ol ; offLen) {
    //         int numExceptions = 0;
    //         try {
    //             BigInteger bi = new BigInteger(array, ol[0], ol[1]);
    //         } catch (IndexOutOfBoundsException e) {
    //             numExceptions++;
    //         }
    //         if (numExceptions != ol[2]) {
    //             writeln("IndexOutOfBoundsException did not occur for "
    //                 ~ " two's complement constructor with parameters offset "
    //                 ~ ol[0].to!string() ~ " and length " ~ ol[1].to!string());
    //             failCount++;
    //         }
    //     }

    //     // sign-magnitude
    //     foreach (int[] ol ; offLen) {
    //         int numExceptions = 0;
    //         try {
    //             BigInteger bi = new BigInteger(1, array, ol[0], ol[1]);
    //         } catch (IndexOutOfBoundsException e) {
    //             numExceptions++;
    //         }
    //         if (numExceptions != ol[2]) {
    //             writeln("IndexOutOfBoundsException did not occur for "
    //                 ~ " sign-magnitude constructor with parameters offset "
    //                 ~ ol[0].to!string() ~ " and length " ~ ol[1].to!string());
    //             failCount++;
    //         }
    //     }

    //     // --- tests for creation of zero-valued BigIntegers ---

    //     byte[] magZeroLength = new byte[0];
    //     for (int signum = -1; signum <= 1; signum++) {
    //         BigInteger bi = new BigInteger(signum, magZeroLength);
    //         if (bi.compareTo(BigInteger.ZERO) != 0) {
    //             writeln("A: Zero length BigInteger != 0 for signum " ~ signum.to!string());
    //             failCount++;
    //         }
    //     }

    //     for (int signum = -1; signum <= 1; signum++) {
    //         BigInteger bi = new BigInteger(signum, magZeroLength, 0, 0);
    //         if (bi.compareTo(BigInteger.ZERO) != 0) {
    //             writeln("B: Zero length BigInteger != 0 for signum " ~ signum.to!string());
    //             failCount++;
    //         }
    //     }

    //     byte[] magNonZeroLength = new byte[42];
    //     // random.nextBytes(magNonZeroLength);
    //     foreach(size_t i; 0..magNonZeroLength.length)
    //         magNonZeroLength[i] = uniform(byte.min, byte.max, random);

    //     for (int signum = -1; signum <= 1; signum++) {
    //         BigInteger bi = new BigInteger(signum, magNonZeroLength, 0, 0);
    //         if (bi.compareTo(BigInteger.ZERO) != 0) {
    //             writeln("C: Zero length BigInteger != 0 for signum " ~ signum.to!string());
    //             failCount++;
    //         }
    //     }

    //     // --- tests for accurate creation of non-zero BigIntegers ---

    //     for (int i = 0; i < SIZE; i++) {
    //         // create reference value via a different code path from those tested
    //         BigInteger reference = new BigInteger(2 + uniform(0, 336, random), 4, &random);

    //         byte[] refArray = reference.toByteArray();
    //         int refLen = cast(int)refArray.length;
    //         int factor = uniform(0, 5, random);
    //         int objLen = refLen + factor*uniform(0, refLen, random) + 1;
    //         int offset = uniform(0, objLen - refLen, random);
    //         byte[] objArray = new byte[objLen];
    //         // System.arraycopy(refArray, 0, objArray, offset, refLen);
    //         objArray[offset .. offset+refLen] = refArray[0 .. refLen];

    //         BigInteger twosComp = new BigInteger(objArray, offset, refLen);
    //         if (twosComp.compareTo(reference) != 0) {
    //             writeln("Two's-complement BigInteger not equal for offset " ~
    //                     offset.to!string() ~ " and length " ~ refLen.to!string());
    //             failCount++;
    //         }

    //         bool isNegative = (random.front % 2 == 0);
    //         BigInteger signMag = new BigInteger(isNegative ? -1 : 1, objArray, offset, refLen);
    //         if (signMag.compareTo(isNegative ? reference.negate() : reference) != 0) {
    //             writeln("Sign-magnitude BigInteger not equal for offset " ~
    //                     offset.to!string() ~ " and length " ~ refLen.to!string());
    //             failCount++;
    //         }
    //     }

    //     report("Constructor", failCount);
    // }

    // static void pow(int order) {
    //     int failCount1 = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         // Test identity x^power == x*x*x ... *x
    //         int power = random.nextInt(6) + 2;
    //         BigInteger x = fetchNumber(order);
    //         BigInteger y = x.pow(power);
    //         BigInteger z = x;

    //         for (int j=1; j<power; j++)
    //             z = z.multiply(x);

    //         if (!y.equals(z))
    //             failCount1++;
    //     }
    //     report("pow for " + order + " bits", failCount1);
    // }

    // static void square(int order) {
    //     int failCount1 = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         // Test identity x^2 == x*x
    //         BigInteger x  = fetchNumber(order);
    //         BigInteger xx = x.multiply(x);
    //         BigInteger x2 = x.pow(2);

    //         if (!x2.equals(xx))
    //             failCount1++;
    //     }
    //     report("square for " + order + " bits", failCount1);
    // }

    // private static void printErr(String msg) {
    //     System.err.println(msg);
    // }

    // private static int checkResult(BigInteger expected, BigInteger actual,
    //     String failureMessage) {
    //     if (expected.compareTo(actual) != 0) {
    //         printErr(failureMessage + " - expected: " + expected
    //             + ", actual: " + actual);
    //         return 1;
    //     }
    //     return 0;
    // }

    // private static void squareRootSmall() {
    //     int failCount = 0;

    //     // A negative value should cause an exception.
    //     BigInteger n = BigInteger.ONE.negate();
    //     BigInteger s;
    //     try {
    //         s = n.sqrt();
    //         // If sqrt() does not throw an exception that is a failure.
    //         failCount++;
    //         printErr("sqrt() of negative number did not throw an exception");
    //     } catch (ArithmeticException expected) {
    //         // A negative value should cause an exception and is not a failure.
    //     }

    //     // A zero value should return BigInteger.ZERO.
    //     failCount += checkResult(BigInteger.ZERO, BigInteger.ZERO.sqrt(),
    //         "sqrt(0) != BigInteger.ZERO");

    //     // 1 <= value < 4 should return BigInteger.ONE.
    //     long[] smalls = new long[] {1, 2, 3};
    //     for (long small : smalls) {
    //         failCount += checkResult(BigInteger.ONE,
    //             BigInteger.valueOf(small).sqrt(), "sqrt("+small+") != 1");
    //     }

    //     report("squareRootSmall", failCount);
    // }

    // static void squareRoot() {
    //     squareRootSmall();

    //     ToIntFunction<BigInteger> f = (n) -> {
    //         int failCount = 0;

    //         // square root of n^2 -> n
    //         BigInteger n2 = n.pow(2);
    //         failCount += checkResult(n, n2.sqrt(), "sqrt() n^2 -> n");

    //         // square root of n^2 + 1 -> n
    //         BigInteger n2up = n2.add(BigInteger.ONE);
    //         failCount += checkResult(n, n2up.sqrt(), "sqrt() n^2 + 1 -> n");

    //         // square root of (n + 1)^2 - 1 -> n
    //         BigInteger up =
    //             n.add(BigInteger.ONE).pow(2).subtract(BigInteger.ONE);
    //         failCount += checkResult(n, up.sqrt(), "sqrt() (n + 1)^2 - 1 -> n");

    //         // sqrt(n)^2 <= n
    //         BigInteger s = n.sqrt();
    //         if (s.multiply(s).compareTo(n) > 0) {
    //             failCount++;
    //             printErr("sqrt(n)^2 > n for n = " + n);
    //         }

    //         // (sqrt(n) + 1)^2 > n
    //         if (s.add(BigInteger.ONE).pow(2).compareTo(n) <= 0) {
    //             failCount++;
    //             printErr("(sqrt(n) + 1)^2 <= n for n = " + n);
    //         }

    //         return failCount;
    //     };

    //     Stream.Builder<BigInteger> sb = Stream.builder();
    //     int maxExponent = Double.MAX_EXPONENT + 1;
    //     for (int i = 1; i <= maxExponent; i++) {
    //         BigInteger p2 = BigInteger.ONE.shiftLeft(i);
    //         sb.add(p2.subtract(BigInteger.ONE));
    //         sb.add(p2);
    //         sb.add(p2.add(BigInteger.ONE));
    //     }
    //     sb.add((new BigDecimal(Double.MAX_VALUE)).toBigInteger());
    //     sb.add((new BigDecimal(Double.MAX_VALUE)).toBigInteger().add(BigInteger.ONE));
    //     report("squareRoot for 2^N and 2^N - 1, 1 <= N <= Double.MAX_EXPONENT",
    //         sb.build().collect(Collectors.summingInt(f)));

    //     IntStream ints = random.ints(SIZE, 4, Integer.MAX_VALUE);
    //     report("squareRoot for int", ints.mapToObj(x ->
    //         BigInteger.valueOf(x)).collect(Collectors.summingInt(f)));

    //     LongStream longs = random.longs(SIZE, (long)Integer.MAX_VALUE + 1L,
    //         Long.MAX_VALUE);
    //     report("squareRoot for long", longs.mapToObj(x ->
    //         BigInteger.valueOf(x)).collect(Collectors.summingInt(f)));

    //     DoubleStream doubles = random.doubles(SIZE,
    //         (double) Long.MAX_VALUE + 1.0, Math.sqrt(Double.MAX_VALUE));
    //     report("squareRoot for double", doubles.mapToObj(x ->
    //         BigDecimal.valueOf(x).toBigInteger()).collect(Collectors.summingInt(f)));
    // }

    // static void squareRootAndRemainder() {
    //     ToIntFunction<BigInteger> g = (n) -> {
    //         int failCount = 0;
    //         BigInteger n2 = n.pow(2);

    //         // square root of n^2 -> n
    //         BigInteger[] actual = n2.sqrtAndRemainder();
    //         failCount += checkResult(n, actual[0], "sqrtAndRemainder()[0]");
    //         failCount += checkResult(BigInteger.ZERO, actual[1],
    //             "sqrtAndRemainder()[1]");

    //         // square root of n^2 + 1 -> n
    //         BigInteger n2up = n2.add(BigInteger.ONE);
    //         actual = n2up.sqrtAndRemainder();
    //         failCount += checkResult(n, actual[0], "sqrtAndRemainder()[0]");
    //         failCount += checkResult(BigInteger.ONE, actual[1],
    //             "sqrtAndRemainder()[1]");

    //         // square root of (n + 1)^2 - 1 -> n
    //         BigInteger up =
    //             n.add(BigInteger.ONE).pow(2).subtract(BigInteger.ONE);
    //         actual = up.sqrtAndRemainder();
    //         failCount += checkResult(n, actual[0], "sqrtAndRemainder()[0]");
    //         BigInteger r = up.subtract(n2);
    //         failCount += checkResult(r, actual[1], "sqrtAndRemainder()[1]");

    //         return failCount;
    //     };

    //     IntStream bits = random.ints(SIZE, 3, Short.MAX_VALUE);
    //     report("sqrtAndRemainder", bits.mapToObj(x ->
    //         BigInteger.valueOf(x)).collect(Collectors.summingInt(g)));
    // }

    // static void arithmetic(int order) {
    //     int failCount = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order);
    //         while(x.compareTo(BigInteger.ZERO) != 1)
    //             x = fetchNumber(order);
    //         BigInteger y = fetchNumber(order/2);
    //         while(x.compareTo(y) == -1)
    //             y = fetchNumber(order/2);
    //         if (y.equals(BigInteger.ZERO))
    //             y = y.add(BigInteger.ONE);

    //         // Test identity ((x/y))*y + x%y - x == 0
    //         // using separate divide() and remainder()
    //         BigInteger baz = x.divide(y);
    //         baz = baz.multiply(y);
    //         baz = baz.add(x.remainder(y));
    //         baz = baz.subtract(x);
    //         if (!baz.equals(BigInteger.ZERO))
    //             failCount++;
    //     }
    //     report("Arithmetic I for " + order + " bits", failCount);

    //     failCount = 0;
    //     for (int i=0; i<100; i++) {
    //         BigInteger x = fetchNumber(order);
    //         while(x.compareTo(BigInteger.ZERO) != 1)
    //             x = fetchNumber(order);
    //         BigInteger y = fetchNumber(order/2);
    //         while(x.compareTo(y) == -1)
    //             y = fetchNumber(order/2);
    //         if (y.equals(BigInteger.ZERO))
    //             y = y.add(BigInteger.ONE);

    //         // Test identity ((x/y))*y + x%y - x == 0
    //         // using divideAndRemainder()
    //         BigInteger baz[] = x.divideAndRemainder(y);
    //         baz[0] = baz[0].multiply(y);
    //         baz[0] = baz[0].add(baz[1]);
    //         baz[0] = baz[0].subtract(x);
    //         if (!baz[0].equals(BigInteger.ZERO))
    //             failCount++;
    //     }
    //     report("Arithmetic II for " + order + " bits", failCount);
    // }

    // /**
    //  * Sanity test for Karatsuba and 3-way Toom-Cook multiplication.
    //  * For each of the Karatsuba and 3-way Toom-Cook multiplication thresholds,
    //  * construct two factors each with a mag array one element shorter than the
    //  * threshold, and with the most significant bit set and the rest of the bits
    //  * random. Each of these numbers will therefore be below the threshold but
    //  * if shifted left be above the threshold. Call the numbers 'u' and 'v' and
    //  * define random shifts 'a' and 'b' in the range [1,32]. Then we have the
    //  * identity
    //  * <pre>
    //  * (u << a)*(v << b) = (u*v) << (a + b)
    //  * </pre>
    //  * For Karatsuba multiplication, the right hand expression will be evaluated
    //  * using the standard naive algorithm, and the left hand expression using
    //  * the Karatsuba algorithm. For 3-way Toom-Cook multiplication, the right
    //  * hand expression will be evaluated using Karatsuba multiplication, and the
    //  * left hand expression using 3-way Toom-Cook multiplication.
    //  */
    // static void multiplyLarge() {
    //     int failCount = 0;

    //     BigInteger base = BigInteger.ONE.shiftLeft(BITS_KARATSUBA - 32 - 1);
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(BITS_KARATSUBA - 32 - 1);
    //         BigInteger u = base.add(x);
    //         int a = 1 + random.nextInt(31);
    //         BigInteger w = u.shiftLeft(a);

    //         BigInteger y = fetchNumber(BITS_KARATSUBA - 32 - 1);
    //         BigInteger v = base.add(y);
    //         int b = 1 + random.nextInt(32);
    //         BigInteger z = v.shiftLeft(b);

    //         BigInteger multiplyResult = u.multiply(v).shiftLeft(a + b);
    //         BigInteger karatsubaMultiplyResult = w.multiply(z);

    //         if (!multiplyResult.equals(karatsubaMultiplyResult)) {
    //             failCount++;
    //         }
    //     }

    //     report("multiplyLarge Karatsuba", failCount);

    //     failCount = 0;
    //     base = base.shiftLeft(BITS_TOOM_COOK - BITS_KARATSUBA);
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(BITS_TOOM_COOK - 32 - 1);
    //         BigInteger u = base.add(x);
    //         BigInteger u2 = u.shiftLeft(1);
    //         BigInteger y = fetchNumber(BITS_TOOM_COOK - 32 - 1);
    //         BigInteger v = base.add(y);
    //         BigInteger v2 = v.shiftLeft(1);

    //         BigInteger multiplyResult = u.multiply(v).shiftLeft(2);
    //         BigInteger toomCookMultiplyResult = u2.multiply(v2);

    //         if (!multiplyResult.equals(toomCookMultiplyResult)) {
    //             failCount++;
    //         }
    //     }

    //     report("multiplyLarge Toom-Cook", failCount);
    // }

    // /**
    //  * Sanity test for Karatsuba and 3-way Toom-Cook squaring.
    //  * This test is analogous to {@link AbstractMethodError#multiplyLarge}
    //  * with both factors being equal. The squaring methods will not be tested
    //  * unless the <code>bigInteger.multiply(bigInteger)</code> tests whether
    //  * the parameter is the same instance on which the method is being invoked
    //  * and calls <code>square()</code> accordingly.
    //  */
    // static void squareLarge() {
    //     int failCount = 0;

    //     BigInteger base = BigInteger.ONE.shiftLeft(BITS_KARATSUBA_SQUARE - 32 - 1);
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(BITS_KARATSUBA_SQUARE - 32 - 1);
    //         BigInteger u = base.add(x);
    //         int a = 1 + random.nextInt(31);
    //         BigInteger w = u.shiftLeft(a);

    //         BigInteger squareResult = u.multiply(u).shiftLeft(2*a);
    //         BigInteger karatsubaSquareResult = w.multiply(w);

    //         if (!squareResult.equals(karatsubaSquareResult)) {
    //             failCount++;
    //         }
    //     }

    //     report("squareLarge Karatsuba", failCount);

    //     failCount = 0;
    //     base = base.shiftLeft(BITS_TOOM_COOK_SQUARE - BITS_KARATSUBA_SQUARE);
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(BITS_TOOM_COOK_SQUARE - 32 - 1);
    //         BigInteger u = base.add(x);
    //         int a = 1 + random.nextInt(31);
    //         BigInteger w = u.shiftLeft(a);

    //         BigInteger squareResult = u.multiply(u).shiftLeft(2*a);
    //         BigInteger toomCookSquareResult = w.multiply(w);

    //         if (!squareResult.equals(toomCookSquareResult)) {
    //             failCount++;
    //         }
    //     }

    //     report("squareLarge Toom-Cook", failCount);
    // }

    // /**
    //  * Sanity test for Burnikel-Ziegler division.  The Burnikel-Ziegler division
    //  * algorithm is used when each of the dividend and the divisor has at least
    //  * a specified number of ints in its representation.  This test is based on
    //  * the observation that if {@code w = u*pow(2,a)} and {@code z = v*pow(2,b)}
    //  * where {@code abs(u) > abs(v)} and {@code a > b && b > 0}, then if
    //  * {@code w/z = q1*z + r1} and {@code u/v = q2*v + r2}, then
    //  * {@code q1 = q2*pow(2,a-b)} and {@code r1 = r2*pow(2,b)}.  The test
    //  * ensures that {@code v} is just under the B-Z threshold, that {@code z} is
    //  * over the threshold and {@code w} is much larger than {@code z}. This
    //  * implies that {@code u/v} uses the standard division algorithm and
    //  * {@code w/z} uses the B-Z algorithm.  The results of the two algorithms
    //  * are then compared using the observation described in the foregoing and
    //  * if they are not equal a failure is logged.
    //  */
    // static void divideLarge() {
    //     int failCount = 0;

    //     BigInteger base = BigInteger.ONE.shiftLeft(BITS_BURNIKEL_ZIEGLER + BITS_BURNIKEL_ZIEGLER_OFFSET - 33);
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger addend = new BigInteger(BITS_BURNIKEL_ZIEGLER + BITS_BURNIKEL_ZIEGLER_OFFSET - 34, random);
    //         BigInteger v = base.add(addend);

    //         BigInteger u = v.multiply(BigInteger.valueOf(2 + random.nextInt(Short.MAX_VALUE - 1)));

    //         if(random.nextBoolean()) {
    //             u = u.negate();
    //         }
    //         if(random.nextBoolean()) {
    //             v = v.negate();
    //         }

    //         int a = BITS_BURNIKEL_ZIEGLER_OFFSET + random.nextInt(16);
    //         int b = 1 + random.nextInt(16);
    //         BigInteger w = u.multiply(BigInteger.ONE.shiftLeft(a));
    //         BigInteger z = v.multiply(BigInteger.ONE.shiftLeft(b));

    //         BigInteger[] divideResult = u.divideAndRemainder(v);
    //         divideResult[0] = divideResult[0].multiply(BigInteger.ONE.shiftLeft(a - b));
    //         divideResult[1] = divideResult[1].multiply(BigInteger.ONE.shiftLeft(b));
    //         BigInteger[] bzResult = w.divideAndRemainder(z);

    //         if (divideResult[0].compareTo(bzResult[0]) != 0 ||
    //                 divideResult[1].compareTo(bzResult[1]) != 0) {
    //             failCount++;
    //         }
    //     }

    //     report("divideLarge", failCount);
    // }

    // static void bitCount() {
    //     int failCount = 0;

    //     for (int i=0; i<SIZE*10; i++) {
    //         int x = random.nextInt();
    //         BigInteger bigX = BigInteger.valueOf((long)x);
    //         int bit = (x < 0 ? 0 : 1);
    //         int tmp = x, bitCount = 0;
    //         for (int j=0; j<32; j++) {
    //             bitCount += ((tmp & 1) == bit ? 1 : 0);
    //             tmp >>= 1;
    //         }

    //         if (bigX.bitCount() != bitCount) {
    //             //System.err.println(x+": "+bitCount+", "+bigX.bitCount());
    //             failCount++;
    //         }
    //     }
    //     report("Bit Count", failCount);
    // }

    // static void bitLength() {
    //     int failCount = 0;

    //     for (int i=0; i<SIZE*10; i++) {
    //         int x = random.nextInt();
    //         BigInteger bigX = BigInteger.valueOf((long)x);
    //         int signBit = (x < 0 ? 0x80000000 : 0);
    //         int tmp = x, bitLength, j;
    //         for (j=0; j<32 && (tmp & 0x80000000)==signBit; j++)
    //             tmp <<= 1;
    //         bitLength = 32 - j;

    //         if (bigX.bitLength() != bitLength) {
    //             //System.err.println(x+": "+bitLength+", "+bigX.bitLength());
    //             failCount++;
    //         }
    //     }

    //     report("BitLength", failCount);
    // }

    // static void bitOps(int order) {
    //     int failCount1 = 0, failCount2 = 0, failCount3 = 0;

    //     for (int i=0; i<SIZE*5; i++) {
    //         BigInteger x = fetchNumber(order);
    //         BigInteger y;

    //         // Test setBit and clearBit (and testBit)
    //         if (x.signum() < 0) {
    //             y = BigInteger.valueOf(-1);
    //             for (int j=0; j<x.bitLength(); j++)
    //                 if (!x.testBit(j))
    //                     y = y.clearBit(j);
    //         } else {
    //             y = BigInteger.ZERO;
    //             for (int j=0; j<x.bitLength(); j++)
    //                 if (x.testBit(j))
    //                     y = y.setBit(j);
    //         }
    //         if (!x.equals(y))
    //             failCount1++;

    //         // Test flipBit (and testBit)
    //         y = BigInteger.valueOf(x.signum()<0 ? -1 : 0);
    //         for (int j=0; j<x.bitLength(); j++)
    //             if (x.signum()<0  ^  x.testBit(j))
    //                 y = y.flipBit(j);
    //         if (!x.equals(y))
    //             failCount2++;
    //     }
    //     report("clearBit/testBit for " + order + " bits", failCount1);
    //     report("flipBit/testBit for " + order + " bits", failCount2);

    //     for (int i=0; i<SIZE*5; i++) {
    //         BigInteger x = fetchNumber(order);

    //         // Test getLowestSetBit()
    //         int k = x.getLowestSetBit();
    //         if (x.signum() == 0) {
    //             if (k != -1)
    //                 failCount3++;
    //         } else {
    //             BigInteger z = x.and(x.negate());
    //             int j;
    //             for (j=0; j<z.bitLength() && !z.testBit(j); j++)
    //                 ;
    //             if (k != j)
    //                 failCount3++;
    //         }
    //     }
    //     report("getLowestSetBit for " + order + " bits", failCount3);
    // }

    // static void bitwise(int order) {

    //     // Test identity x^y == x|y &~ x&y
    //     int failCount = 0;
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order);
    //         BigInteger y = fetchNumber(order);
    //         BigInteger z = x.xor(y);
    //         BigInteger w = x.or(y).andNot(x.and(y));
    //         if (!z.equals(w))
    //             failCount++;
    //     }
    //     report("Logic (^ | & ~) for " + order + " bits", failCount);

    //     // Test identity x &~ y == ~(~x | y)
    //     failCount = 0;
    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order);
    //         BigInteger y = fetchNumber(order);
    //         BigInteger z = x.andNot(y);
    //         BigInteger w = x.not().or(y).not();
    //         if (!z.equals(w))
    //             failCount++;
    //     }
    //     report("Logic (&~ | ~) for " + order + " bits", failCount);
    // }

    // static void shift(int order) {
    //     int failCount1 = 0;
    //     int failCount2 = 0;
    //     int failCount3 = 0;

    //     for (int i=0; i<100; i++) {
    //         BigInteger x = fetchNumber(order);
    //         int n = Math.abs(random.nextInt()%200);

    //         if (!x.shiftLeft(n).equals
    //             (x.multiply(BigInteger.valueOf(2L).pow(n))))
    //             failCount1++;

    //         BigInteger y[] =x.divideAndRemainder(BigInteger.valueOf(2L).pow(n));
    //         BigInteger z = (x.signum()<0 && y[1].signum()!=0
    //                         ? y[0].subtract(BigInteger.ONE)
    //                         : y[0]);

    //         BigInteger b = x.shiftRight(n);

    //         if (!b.equals(z)) {
    //             System.err.println("Input is "+x.toString(2));
    //             System.err.println("shift is "+n);

    //             System.err.println("Divided "+z.toString(2));
    //             System.err.println("Shifted is "+b.toString(2));
    //             if (b.toString().equals(z.toString()))
    //                 System.err.println("Houston, we have a problem.");
    //             failCount2++;
    //         }

    //         if (!x.shiftLeft(n).shiftRight(n).equals(x))
    //             failCount3++;
    //     }
    //     report("baz shiftLeft for " + order + " bits", failCount1);
    //     report("baz shiftRight for " + order + " bits", failCount2);
    //     report("baz shiftLeft/Right for " + order + " bits", failCount3);
    // }

    // static void divideAndRemainder(int order) {
    //     int failCount1 = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order).abs();
    //         while(x.compareTo(BigInteger.valueOf(3L)) != 1)
    //             x = fetchNumber(order).abs();
    //         BigInteger z = x.divide(BigInteger.valueOf(2L));
    //         BigInteger y[] = x.divideAndRemainder(x);
    //         if (!y[0].equals(BigInteger.ONE)) {
    //             failCount1++;
    //             System.err.println("fail1 x :"+x);
    //             System.err.println("      y :"+y);
    //         }
    //         else if (!y[1].equals(BigInteger.ZERO)) {
    //             failCount1++;
    //             System.err.println("fail2 x :"+x);
    //             System.err.println("      y :"+y);
    //         }

    //         y = x.divideAndRemainder(z);
    //         if (!y[0].equals(BigInteger.valueOf(2))) {
    //             failCount1++;
    //             System.err.println("fail3 x :"+x);
    //             System.err.println("      y :"+y);
    //         }
    //     }
    //     report("divideAndRemainder for " + order + " bits", failCount1);
    // }

    // static void stringConv() {
    //     int failCount = 0;

    //     // Generic string conversion.
    //     for (int i=0; i<100; i++) {
    //         byte xBytes[] = new byte[Math.abs(random.nextInt())%100+1];
    //         random.nextBytes(xBytes);
    //         BigInteger x = new BigInteger(xBytes);

    //         for (int radix=Character.MIN_RADIX; radix < Character.MAX_RADIX; radix++) {
    //             String result = x.toString(radix);
    //             BigInteger test = new BigInteger(result, radix);
    //             if (!test.equals(x)) {
    //                 failCount++;
    //                 System.err.println("BigInteger toString: "+x);
    //                 System.err.println("Test: "+test);
    //                 System.err.println(radix);
    //             }
    //         }
    //     }

    //     // String conversion straddling the Schoenhage algorithm crossover
    //     // threshold, and at twice and four times the threshold.
    //     for (int k = 0; k <= 2; k++) {
    //         int factor = 1 << k;
    //         int upper = factor * BITS_SCHOENHAGE_BASE + 33;
    //         int lower = upper - 35;

    //         for (int bits = upper; bits >= lower; bits--) {
    //             for (int i = 0; i < 50; i++) {
    //                 BigInteger x = BigInteger.ONE.shiftLeft(bits - 1).or(new BigInteger(bits - 2, random));

    //                 for (int radix = Character.MIN_RADIX; radix < Character.MAX_RADIX; radix++) {
    //                     String result = x.toString(radix);
    //                     BigInteger test = new BigInteger(result, radix);
    //                     if (!test.equals(x)) {
    //                         failCount++;
    //                         System.err.println("BigInteger toString: " + x);
    //                         System.err.println("Test: " + test);
    //                         System.err.println(radix);
    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     report("String Conversion", failCount);
    // }

    // static void byteArrayConv(int order) {
    //     int failCount = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order);
    //         while (x.equals(BigInteger.ZERO))
    //             x = fetchNumber(order);
    //         BigInteger y = new BigInteger(x.toByteArray());
    //         if (!x.equals(y)) {
    //             failCount++;
    //             System.err.println("orig is "+x);
    //             System.err.println("new is "+y);
    //         }
    //     }
    //     report("Array Conversion for " + order + " bits", failCount);
    // }

    // static void modInv(int order) {
    //     int failCount = 0, successCount = 0, nonInvCount = 0;

    //     for (int i=0; i<SIZE; i++) {
    //         BigInteger x = fetchNumber(order);
    //         while(x.equals(BigInteger.ZERO))
    //             x = fetchNumber(order);
    //         BigInteger m = fetchNumber(order).abs();
    //         while(m.compareTo(BigInteger.ONE) != 1)
    //             m = fetchNumber(order).abs();

    //         try {
    //             BigInteger inv = x.modInverse(m);
    //             BigInteger prod = inv.multiply(x).remainder(m);

    //             if (prod.signum() == -1)
    //                 prod = prod.add(m);

    //             if (prod.equals(BigInteger.ONE))
    //                 successCount++;
    //             else
    //                 failCount++;
    //         } catch(ArithmeticException e) {
    //             nonInvCount++;
    //         }
    //     }
    //     report("Modular Inverse for " + order + " bits", failCount);
    // }

    // static void modExp(int order1, int order2) {
    //     int failCount = 0;

    //     for (int i=0; i<SIZE/10; i++) {
    //         BigInteger m = fetchNumber(order1).abs();
    //         while(m.compareTo(BigInteger.ONE) != 1)
    //             m = fetchNumber(order1).abs();
    //         BigInteger base = fetchNumber(order2);
    //         BigInteger exp = fetchNumber(8).abs();

    //         BigInteger z = base.modPow(exp, m);
    //         BigInteger w = base.pow(exp.intValue()).mod(m);
    //         if (!z.equals(w)) {
    //             System.err.println("z is "+z);
    //             System.err.println("w is "+w);
    //             System.err.println("mod is "+m);
    //             System.err.println("base is "+base);
    //             System.err.println("exp is "+exp);
    //             failCount++;
    //         }
    //     }
    //     report("Exponentiation I for " + order1 + " and " +
    //            order2 + " bits", failCount);
    // }

    // // This test is based on Fermat's theorem
    // // which is not ideal because base must not be multiple of modulus
    // // and modulus must be a prime or pseudoprime (Carmichael number)
    // static void modExp2(int order) {
    //     int failCount = 0;

    //     for (int i=0; i<10; i++) {
    //         BigInteger m = new BigInteger(100, 5, random);
    //         while(m.compareTo(BigInteger.ONE) != 1)
    //             m = new BigInteger(100, 5, random);
    //         BigInteger exp = m.subtract(BigInteger.ONE);
    //         BigInteger base = fetchNumber(order).abs();
    //         while(base.compareTo(m) != -1)
    //             base = fetchNumber(order).abs();
    //         while(base.equals(BigInteger.ZERO))
    //             base = fetchNumber(order).abs();

    //         BigInteger one = base.modPow(exp, m);
    //         if (!one.equals(BigInteger.ONE)) {
    //             System.err.println("m is "+m);
    //             System.err.println("base is "+base);
    //             System.err.println("exp is "+exp);
    //             failCount++;
    //         }
    //     }
    //     report("Exponentiation II for " + order + " bits", failCount);
    // }

    // private static final int[] mersenne_powers = {
    //     521, 607, 1279, 2203, 2281, 3217, 4253, 4423, 9689, 9941, 11213, 19937,
    //     21701, 23209, 44497, 86243, 110503, 132049, 216091, 756839, 859433,
    //     1257787, 1398269, 2976221, 3021377, 6972593, 13466917 };

    // private static final long[] carmichaels = {
    //   561,1105,1729,2465,2821,6601,8911,10585,15841,29341,41041,46657,52633,
    //   62745,63973,75361,101101,115921,126217,162401,172081,188461,252601,
    //   278545,294409,314821,334153,340561,399001,410041,449065,488881,512461,
    //   225593397919L };

    // // Note: testing the larger ones takes too long.
    // private static final int NUM_MERSENNES_TO_TEST = 7;
    // // Note: this constant used for computed Carmichaels, not the array above
    // private static final int NUM_CARMICHAELS_TO_TEST = 5;

    // private static final String[] customer_primes = {
    //     "120000000000000000000000000000000019",
    //     "633825300114114700748351603131",
    //     "1461501637330902918203684832716283019651637554291",
    //     "779626057591079617852292862756047675913380626199",
    //     "857591696176672809403750477631580323575362410491",
    //     "910409242326391377348778281801166102059139832131",
    //     "929857869954035706722619989283358182285540127919",
    //     "961301750640481375785983980066592002055764391999",
    //     "1267617700951005189537696547196156120148404630231",
    //     "1326015641149969955786344600146607663033642528339" };

    // private static final BigInteger ZERO = BigInteger.ZERO;
    // private static final BigInteger ONE = BigInteger.ONE;
    // private static final BigInteger TWO = new BigInteger("2");
    // private static final BigInteger SIX = new BigInteger("6");
    // private static final BigInteger TWELVE = new BigInteger("12");
    // private static final BigInteger EIGHTEEN = new BigInteger("18");

    // static void prime() {
    //     BigInteger p1, p2, c1;
    //     int failCount = 0;

    //     // Test consistency
    //     for(int i=0; i<10; i++) {
    //         p1 = BigInteger.probablePrime(100, random);
    //         if (!p1.isProbablePrime(100)) {
    //             System.err.println("Consistency "+p1.toString(16));
    //             failCount++;
    //         }
    //     }

    //     // Test some known Mersenne primes (2^n)-1
    //     // The array holds the exponents, not the numbers being tested
    //     for (int i=0; i<NUM_MERSENNES_TO_TEST; i++) {
    //         p1 = new BigInteger("2");
    //         p1 = p1.pow(mersenne_powers[i]);
    //         p1 = p1.subtract(BigInteger.ONE);
    //         if (!p1.isProbablePrime(100)) {
    //             System.err.println("Mersenne prime "+i+ " failed.");
    //             failCount++;
    //         }
    //     }

    //     // Test some primes reported by customers as failing in the past
    //     for (int i=0; i<customer_primes.length; i++) {
    //         p1 = new BigInteger(customer_primes[i]);
    //         if (!p1.isProbablePrime(100)) {
    //             System.err.println("Customer prime "+i+ " failed.");
    //             failCount++;
    //         }
    //     }

    //     // Test some known Carmichael numbers.
    //     for (int i=0; i<carmichaels.length; i++) {
    //         c1 = BigInteger.valueOf(carmichaels[i]);
    //         if(c1.isProbablePrime(100)) {
    //             System.err.println("Carmichael "+i+ " reported as prime.");
    //             failCount++;
    //         }
    //     }

    //     // Test some computed Carmichael numbers.
    //     // Numbers of the form (6k+1)(12k+1)(18k+1) are Carmichael numbers if
    //     // each of the factors is prime
    //     int found = 0;
    //     BigInteger f1 = new BigInteger(40, 100, random);
    //     while (found < NUM_CARMICHAELS_TO_TEST) {
    //         BigInteger k = null;
    //         BigInteger f2, f3;
    //         f1 = f1.nextProbablePrime();
    //         BigInteger[] result = f1.subtract(ONE).divideAndRemainder(SIX);
    //         if (result[1].equals(ZERO)) {
    //             k = result[0];
    //             f2 = k.multiply(TWELVE).add(ONE);
    //             if (f2.isProbablePrime(100)) {
    //                 f3 = k.multiply(EIGHTEEN).add(ONE);
    //                 if (f3.isProbablePrime(100)) {
    //                     c1 = f1.multiply(f2).multiply(f3);
    //                     if (c1.isProbablePrime(100)) {
    //                         System.err.println("Computed Carmichael "
    //                                            +c1.toString(16));
    //                         failCount++;
    //                     }
    //                     found++;
    //                 }
    //             }
    //         }
    //         f1 = f1.add(TWO);
    //     }

    //     // Test some composites that are products of 2 primes
    //     for (int i=0; i<50; i++) {
    //         p1 = BigInteger.probablePrime(100, random);
    //         p2 = BigInteger.probablePrime(100, random);
    //         c1 = p1.multiply(p2);
    //         if (c1.isProbablePrime(100)) {
    //             System.err.println("Composite failed "+c1.toString(16));
    //             failCount++;
    //         }
    //     }

    //     for (int i=0; i<4; i++) {
    //         p1 = BigInteger.probablePrime(600, random);
    //         p2 = BigInteger.probablePrime(600, random);
    //         c1 = p1.multiply(p2);
    //         if (c1.isProbablePrime(100)) {
    //             System.err.println("Composite failed "+c1.toString(16));
    //             failCount++;
    //         }
    //     }

    //     report("Prime", failCount);
    // }

    // private static final long[] primesTo100 = {
    //     2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
    // };

    // private static final long[] aPrimeSequence = {
    //     1999999003L, 1999999013L, 1999999049L, 1999999061L, 1999999081L,
    //     1999999087L, 1999999093L, 1999999097L, 1999999117L, 1999999121L,
    //     1999999151L, 1999999171L, 1999999207L, 1999999219L, 1999999271L,
    //     1999999321L, 1999999373L, 1999999423L, 1999999439L, 1999999499L,
    //     1999999553L, 1999999559L, 1999999571L, 1999999609L, 1999999613L,
    //     1999999621L, 1999999643L, 1999999649L, 1999999657L, 1999999747L,
    //     1999999763L, 1999999777L, 1999999811L, 1999999817L, 1999999829L,
    //     1999999853L, 1999999861L, 1999999871L, 1999999873
    // };

    // static void nextProbablePrime() {
    //     int failCount = 0;
    //     BigInteger p1, p2, p3;
    //     p1 = p2 = p3 = ZERO;

    //     // First test nextProbablePrime on the low range starting at zero
    //     for (int i=0; i<primesTo100.length; i++) {
    //         p1 = p1.nextProbablePrime();
    //         if (p1.longValue() != primesTo100[i]) {
    //             System.err.println("low range primes failed");
    //             System.err.println("p1 is "+p1);
    //             System.err.println("expected "+primesTo100[i]);
    //             failCount++;
    //         }
    //     }

    //     // Test nextProbablePrime on a relatively small, known prime sequence
    //     p1 = BigInteger.valueOf(aPrimeSequence[0]);
    //     for (int i=1; i<aPrimeSequence.length; i++) {
    //         p1 = p1.nextProbablePrime();
    //         if (p1.longValue() != aPrimeSequence[i]) {
    //             System.err.println("prime sequence failed");
    //             failCount++;
    //         }
    //     }

    //     // Next, pick some large primes, use nextProbablePrime to find the
    //     // next one, and make sure there are no primes in between
    //     for (int i=0; i<100; i+=10) {
    //         p1 = BigInteger.probablePrime(50 + i, random);
    //         p2 = p1.add(ONE);
    //         p3 = p1.nextProbablePrime();
    //         while(p2.compareTo(p3) < 0) {
    //             if (p2.isProbablePrime(100)){
    //                 System.err.println("nextProbablePrime failed");
    //                 System.err.println("along range "+p1.toString(16));
    //                 System.err.println("to "+p3.toString(16));
    //                 failCount++;
    //                 break;
    //             }
    //             p2 = p2.add(ONE);
    //         }
    //     }

    //     report("nextProbablePrime", failCount);
    // }

    // static void serialize() {
    //     int failCount = 0;

    //     String bitPatterns[] = {
    //          "ffffffff00000000ffffffff00000000ffffffff00000000",
    //          "ffffffffffffffffffffffff000000000000000000000000",
    //          "ffffffff0000000000000000000000000000000000000000",
    //          "10000000ffffffffffffffffffffffffffffffffffffffff",
    //          "100000000000000000000000000000000000000000000000",
    //          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    //         "-ffffffff00000000ffffffff00000000ffffffff00000000",
    //         "-ffffffffffffffffffffffff000000000000000000000000",
    //         "-ffffffff0000000000000000000000000000000000000000",
    //         "-10000000ffffffffffffffffffffffffffffffffffffffff",
    //         "-100000000000000000000000000000000000000000000000",
    //         "-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //     };

    //     for(int i = 0; i < bitPatterns.length; i++) {
    //         BigInteger b1 = new BigInteger(bitPatterns[i], 16);
    //         BigInteger b2 = null;

    //         File f = new File("serialtest");

    //         try (FileOutputStream fos = new FileOutputStream(f)) {
    //             try (ObjectOutputStream oos = new ObjectOutputStream(fos)) {
    //                 oos.writeObject(b1);
    //                 oos.flush();
    //             }

    //             try (FileInputStream fis = new FileInputStream(f);
    //                  ObjectInputStream ois = new ObjectInputStream(fis))
    //             {
    //                 b2 = (BigInteger)ois.readObject();
    //             }

    //             if (!b1.equals(b2) ||
    //                 !b1.equals(b1.or(b2))) {
    //                 failCount++;
    //                 System.err.println("Serialized failed for hex " +
    //                                    b1.toString(16));
    //             }
    //         }
    //         f.delete();
    //     }

    //     for(int i=0; i<10; i++) {
    //         BigInteger b1 = fetchNumber(random.nextInt(100));
    //         BigInteger b2 = null;
    //         File f = new File("serialtest");
    //         try (FileOutputStream fos = new FileOutputStream(f)) {
    //             try (ObjectOutputStream oos = new ObjectOutputStream(fos)) {
    //                 oos.writeObject(b1);
    //                 oos.flush();
    //             }

    //             try (FileInputStream fis = new FileInputStream(f);
    //                  ObjectInputStream ois = new ObjectInputStream(fis))
    //             {
    //                 b2 = (BigInteger)ois.readObject();
    //             }
    //         }

    //         if (!b1.equals(b2) ||
    //             !b1.equals(b1.or(b2)))
    //             failCount++;
    //         f.delete();
    //     }

    //     report("Serialize", failCount);
    // }

    // /*
    //  * Get a random or boundary-case number. This is designed to provide
    //  * a lot of numbers that will find failure points, such as max sized
    //  * numbers, empty BigIntegers, etc.
    //  *
    //  * If order is less than 2, order is changed to 2.
    //  */
    // private static BigInteger fetchNumber(int order) {
    //     boolean negative = random.nextBoolean();
    //     int numType = random.nextInt(7);
    //     BigInteger result = null;
    //     if (order < 2) order = 2;

    //     switch (numType) {
    //         case 0: // Empty
    //             result = BigInteger.ZERO;
    //             break;

    //         case 1: // One
    //             result = BigInteger.ONE;
    //             break;

    //         case 2: // All bits set in number
    //             int numBytes = (order+7)/8;
    //             byte[] fullBits = new byte[numBytes];
    //             for(int i=0; i<numBytes; i++)
    //                 fullBits[i] = (byte)0xff;
    //             int excessBits = 8*numBytes - order;
    //             fullBits[0] &= (1 << (8-excessBits)) - 1;
    //             result = new BigInteger(1, fullBits);
    //             break;

    //         case 3: // One bit in number
    //             result = BigInteger.ONE.shiftLeft(random.nextInt(order));
    //             break;

    //         case 4: // Random bit density
    //             byte[] val = new byte[(order+7)/8];
    //             int iterations = random.nextInt(order);
    //             for (int i=0; i<iterations; i++) {
    //                 int bitIdx = random.nextInt(order);
    //                 val[bitIdx/8] |= 1 << (bitIdx%8);
    //             }
    //             result = new BigInteger(1, val);
    //             break;
    //         case 5: // Runs of consecutive ones and zeros
    //             result = ZERO;
    //             int remaining = order;
    //             int bit = random.nextInt(2);
    //             while (remaining > 0) {
    //                 int runLength = Math.min(remaining, random.nextInt(order));
    //                 result = result.shiftLeft(runLength);
    //                 if (bit > 0)
    //                     result = result.add(ONE.shiftLeft(runLength).subtract(ONE));
    //                 remaining -= runLength;
    //                 bit = 1 - bit;
    //             }
    //             break;

    //         default: // random bits
    //             result = new BigInteger(order, random);
    //     }

    //     if (negative)
    //         result = result.negate();

    //     return result;
    // }
}