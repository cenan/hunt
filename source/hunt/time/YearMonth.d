
module hunt.time.YearMonth;

import hunt.time.temporal.ChronoField;
import hunt.time.temporal.ChronoUnit;

import hunt.io.DataInput;
import hunt.io.DataOutput;
import hunt.lang.exception;

//import hunt.io.ObjectInputStream;
import hunt.io.Serializable;
import hunt.time.chrono.Chronology;
import hunt.time.chrono.IsoChronology;
import hunt.time.format.DateTimeFormatter;
import hunt.time.format.DateTimeFormatterBuilder;
import hunt.time.format.DateTimeParseException;
import hunt.time.format.SignStyle;
import hunt.time.temporal.ChronoField;
import hunt.time.temporal.ChronoUnit;
import hunt.time.temporal.Temporal;
import hunt.time.temporal.TemporalAccessor;
import hunt.time.temporal.TemporalAdjuster;
import hunt.time.temporal.TemporalAmount;
import hunt.time.temporal.TemporalField;
import hunt.time.temporal.TemporalQueries;
import hunt.time.temporal.TemporalQuery;
import hunt.time.temporal.TemporalUnit;
import hunt.time.temporal.UnsupportedTemporalTypeException;
import hunt.time.temporal.ValueRange;
import hunt.lang.common;
import hunt.time.ZoneId;
import hunt.time.Clock;
import hunt.time.Month;
import hunt.time.LocalDate;
import hunt.time.DateTimeException;
import hunt.time.Year;
import hunt.lang;
import hunt.time.Ser;
import hunt.string.StringBuilder;
/**
 * A year-month _in the ISO-8601 calendar system, such as {@code 2007-12}.
 * !(p)
 * {@code YearMonth} is an immutable date-time object that represents the combination
 * of a year and month. Any field that can be derived from a year and month, such as
 * quarter-of-year, can be obtained.
 * !(p)
 * This class does not store or represent a day, time or time-zone.
 * For example, the value "October 2007" can be stored _in a {@code YearMonth}.
 * !(p)
 * The ISO-8601 calendar system is the modern civil calendar system used today
 * _in most of the world. It is equivalent to the proleptic Gregorian calendar
 * system, _in which today's rules for leap years are applied for all time.
 * For most applications written today, the ISO-8601 rules are entirely suitable.
 * However, any application that makes use of historical dates, and requires them
 * to be accurate will find the ISO-8601 approach unsuitable.
 *
 * !(p)
 * This is a <a href="{@docRoot}/java.base/java/lang/doc-files/ValueBased.html">value-based</a>
 * class; use of identity-sensitive operations (including reference equality
 * ({@code ==}), identity hash code, or synchronization) on instances of
 * {@code YearMonth} may have unpredictable results and should be avoided.
 * The {@code equals} method should be used for comparisons.
 *
 * @implSpec
 * This class is immutable and thread-safe.
 *
 * @since 1.8
 */
public final class YearMonth
        : Temporal, TemporalAdjuster, Comparable!(YearMonth), Serializable {

    /**
     * Serialization version.
     */
    private enum long serialVersionUID = 4183400860270640070L;
    /**
     * Parser.
     */
    __gshared DateTimeFormatter PARSER ;

    /**
     * The year.
     */
    private  int year;
    /**
     * The month-of-year, not null.
     */
    private  int month;

    // shared static this()
    // {
    //     PARSER = new DateTimeFormatterBuilder()
    //     .appendValue(ChronoField.YEAR, 4, 10, SignStyle.EXCEEDS_PAD)
    //     .appendLiteral('-')
    //     .appendValue(ChronoField.MONTH_OF_YEAR, 2)
    //     .toFormatter();
    // }

    //-----------------------------------------------------------------------
    /**
     * Obtains the current year-month from the system clock _in the default time-zone.
     * !(p)
     * This will query the {@link Clock#systemDefaultZone() system clock} _in the default
     * time-zone to obtain the current year-month.
     * !(p)
     * Using this method will prevent the ability to use an alternate clock for testing
     * because the clock is hard-coded.
     *
     * @return the current year-month using the system clock and default time-zone, not null
     */
    public static YearMonth now() {
        return now(Clock.systemDefaultZone());
    }

    /**
     * Obtains the current year-month from the system clock _in the specified time-zone.
     * !(p)
     * This will query the {@link Clock#system(ZoneId) system clock} to obtain the current year-month.
     * Specifying the time-zone avoids dependence on the default time-zone.
     * !(p)
     * Using this method will prevent the ability to use an alternate clock for testing
     * because the clock is hard-coded.
     *
     * @param zone  the zone ID to use, not null
     * @return the current year-month using the system clock, not null
     */
    public static YearMonth now(ZoneId zone) {
        return now(Clock.system(zone));
    }

    /**
     * Obtains the current year-month from the specified clock.
     * !(p)
     * This will query the specified clock to obtain the current year-month.
     * Using this method allows the use of an alternate clock for testing.
     * The alternate clock may be introduced using {@link Clock dependency injection}.
     *
     * @param clock  the clock to use, not null
     * @return the current year-month, not null
     */
    public static YearMonth now(Clock clock) {
        LocalDate now = LocalDate.now(clock);  // called once
        return YearMonth.of(now.getYear(), now.getMonth());
    }

    //-----------------------------------------------------------------------
    /**
     * Obtains an instance of {@code YearMonth} from a year and month.
     *
     * @param year  the year to represent, from MIN_YEAR to MAX_YEAR
     * @param month  the month-of-year to represent, not null
     * @return the year-month, not null
     * @throws DateTimeException if the year value is invalid
     */
    public static YearMonth of(int year, Month month) {
        assert(month, "month");
        return of(year, month.getValue());
    }

    /**
     * Obtains an instance of {@code YearMonth} from a year and month.
     *
     * @param year  the year to represent, from MIN_YEAR to MAX_YEAR
     * @param month  the month-of-year to represent, from 1 (January) to 12 (December)
     * @return the year-month, not null
     * @throws DateTimeException if either field value is invalid
     */
    public static YearMonth of(int year, int month) {
        ChronoField.YEAR.checkValidValue(year);
        ChronoField.MONTH_OF_YEAR.checkValidValue(month);
        return new YearMonth(year, month);
    }

    //-----------------------------------------------------------------------
    /**
     * Obtains an instance of {@code YearMonth} from a temporal object.
     * !(p)
     * This obtains a year-month based on the specified temporal.
     * A {@code TemporalAccessor} represents an arbitrary set of date and time information,
     * which this factory converts to an instance of {@code YearMonth}.
     * !(p)
     * The conversion extracts the {@link ChronoField#YEAR YEAR} and
     * {@link ChronoField#MONTH_OF_YEAR MONTH_OF_YEAR} fields.
     * The extraction is only permitted if the temporal object has an ISO
     * chronology, or can be converted to a {@code LocalDate}.
     * !(p)
     * This method matches the signature of the functional interface {@link TemporalQuery}
     * allowing it to be used as a query via method reference, {@code YearMonth.from}.
     *
     * @param temporal  the temporal object to convert, not null
     * @return the year-month, not null
     * @throws DateTimeException if unable to convert to a {@code YearMonth}
     */
    public static YearMonth from(TemporalAccessor temporal) {
        if (cast(YearMonth)(temporal) !is null) {
            return cast(YearMonth) temporal;
        }
        assert(temporal, "temporal");
        try {
            if ((IsoChronology.INSTANCE == Chronology.from(temporal)) == false) {
                temporal = LocalDate.from(temporal);
            }
            return of(temporal.get(ChronoField.YEAR), temporal.get(ChronoField.MONTH_OF_YEAR));
        } catch (DateTimeException ex) {
            throw new DateTimeException("Unable to obtain YearMonth from TemporalAccessor: " ~
                    typeid(temporal).name ~ " of type " ~ typeid(temporal).stringof, ex);
        }
    }

    //-----------------------------------------------------------------------
    /**
     * Obtains an instance of {@code YearMonth} from a text string such as {@code 2007-12}.
     * !(p)
     * The string must represent a valid year-month.
     * The format must be {@code uuuu-MM}.
     * Years outside the range 0000 to 9999 must be prefixed by the plus or minus symbol.
     *
     * @param text  the text to parse such as "2007-12", not null
     * @return the parsed year-month, not null
     * @throws DateTimeParseException if the text cannot be parsed
     */
    public static YearMonth parse(string text) {
        return parse(text, PARSER);
    }

    /**
     * Obtains an instance of {@code YearMonth} from a text string using a specific formatter.
     * !(p)
     * The text is parsed using the formatter, returning a year-month.
     *
     * @param text  the text to parse, not null
     * @param formatter  the formatter to use, not null
     * @return the parsed year-month, not null
     * @throws DateTimeParseException if the text cannot be parsed
     */
    public static YearMonth parse(string text, DateTimeFormatter formatter) {
        assert(formatter, "formatter");
        return formatter.parse(text, new class TemporalQuery!YearMonth{
            YearMonth queryFrom(TemporalAccessor temporal)
            {
                if (cast(YearMonth)(temporal) !is null) {
                    return cast(YearMonth) temporal;
                }
                assert(temporal, "temporal");
                try {
                    if ((IsoChronology.INSTANCE == Chronology.from(temporal)) == false) {
                        temporal = LocalDate.from(temporal);
                    }
                    return of(temporal.get(ChronoField.YEAR), temporal.get(ChronoField.MONTH_OF_YEAR));
                } catch (DateTimeException ex) {
                    throw new DateTimeException("Unable to obtain YearMonth from TemporalAccessor: " ~
                            typeid(temporal).name ~ " of type " ~ typeid(temporal).stringof, ex);
                }
            }
        });
    }

    //-----------------------------------------------------------------------
    /**
     * Constructor.
     *
     * @param year  the year to represent, validated from MIN_YEAR to MAX_YEAR
     * @param month  the month-of-year to represent, validated from 1 (January) to 12 (December)
     */
    private this(int year, int month) {
        this.year = year;
        this.month = month;
    }

    /**
     * Returns a copy of this year-month with the new year and month, checking
     * to see if a new object is _in fact required.
     *
     * @param newYear  the year to represent, validated from MIN_YEAR to MAX_YEAR
     * @param newMonth  the month-of-year to represent, validated not null
     * @return the year-month, not null
     */
    private YearMonth _with(int newYear, int newMonth) {
        if (year == newYear && month == newMonth) {
            return this;
        }
        return new YearMonth(newYear, newMonth);
    }

    //-----------------------------------------------------------------------
    /**
     * Checks if the specified field is supported.
     * !(p)
     * This checks if this year-month can be queried for the specified field.
     * If false, then calling the {@link #range(TemporalField) range},
     * {@link #get(TemporalField) get} and {@link #_with(TemporalField, long)}
     * methods will throw an exception.
     * !(p)
     * If the field is a {@link ChronoField} then the query is implemented here.
     * The supported fields are:
     * !(ul)
     * !(li){@code MONTH_OF_YEAR}
     * !(li){@code PROLEPTIC_MONTH}
     * !(li){@code YEAR_OF_ERA}
     * !(li){@code YEAR}
     * !(li){@code ERA}
     * </ul>
     * All other {@code ChronoField} instances will return false.
     * !(p)
     * If the field is not a {@code ChronoField}, then the result of this method
     * is obtained by invoking {@code TemporalField.isSupportedBy(TemporalAccessor)}
     * passing {@code this} as the argument.
     * Whether the field is supported is determined by the field.
     *
     * @param field  the field to check, null returns false
     * @return true if the field is supported on this year-month, false if not
     */
    override
    public bool isSupported(TemporalField field) {
        if (cast(ChronoField)(field) !is null) {
            return field == ChronoField.YEAR || field ==ChronoField.MONTH_OF_YEAR ||
                    field == ChronoField.PROLEPTIC_MONTH || field == ChronoField.YEAR_OF_ERA || field == ChronoField.ERA;
        }
        return field !is null && field.isSupportedBy(this);
    }

    /**
     * Checks if the specified unit is supported.
     * !(p)
     * This checks if the specified unit can be added to, or subtracted from, this year-month.
     * If false, then calling the {@link #plus(long, TemporalUnit)} and
     * {@link #minus(long, TemporalUnit) minus} methods will throw an exception.
     * !(p)
     * If the unit is a {@link ChronoUnit} then the query is implemented here.
     * The supported units are:
     * !(ul)
     * !(li){@code MONTHS}
     * !(li){@code YEARS}
     * !(li){@code DECADES}
     * !(li){@code CENTURIES}
     * !(li){@code MILLENNIA}
     * !(li){@code ERAS}
     * </ul>
     * All other {@code ChronoUnit} instances will return false.
     * !(p)
     * If the unit is not a {@code ChronoUnit}, then the result of this method
     * is obtained by invoking {@code TemporalUnit.isSupportedBy(Temporal)}
     * passing {@code this} as the argument.
     * Whether the unit is supported is determined by the unit.
     *
     * @param unit  the unit to check, null returns false
     * @return true if the unit can be added/subtracted, false if not
     */
    override
    public bool isSupported(TemporalUnit unit) {
        if (cast(ChronoUnit)(unit) !is null) {
            return unit == ChronoUnit.MONTHS || unit == ChronoUnit.YEARS || unit == ChronoUnit.DECADES || unit == ChronoUnit.CENTURIES || unit == ChronoUnit.MILLENNIA || unit == ChronoUnit.ERAS;
        }
        return unit !is null && unit.isSupportedBy(this);
    }

    //-----------------------------------------------------------------------
    /**
     * Gets the range of valid values for the specified field.
     * !(p)
     * The range object expresses the minimum and maximum valid values for a field.
     * This year-month is used to enhance the accuracy of the returned range.
     * If it is not possible to return the range, because the field is not supported
     * or for some other reason, an exception is thrown.
     * !(p)
     * If the field is a {@link ChronoField} then the query is implemented here.
     * The {@link #isSupported(TemporalField) supported fields} will return
     * appropriate range instances.
     * All other {@code ChronoField} instances will throw an {@code UnsupportedTemporalTypeException}.
     * !(p)
     * If the field is not a {@code ChronoField}, then the result of this method
     * is obtained by invoking {@code TemporalField.rangeRefinedBy(TemporalAccessor)}
     * passing {@code this} as the argument.
     * Whether the range can be obtained is determined by the field.
     *
     * @param field  the field to query the range for, not null
     * @return the range of valid values for the field, not null
     * @throws DateTimeException if the range for the field cannot be obtained
     * @throws UnsupportedTemporalTypeException if the field is not supported
     */
    override
    public ValueRange range(TemporalField field) {
        if (field == ChronoField.YEAR_OF_ERA) {
            return (getYear() <= 0 ? ValueRange.of(1, Year.MAX_VALUE + 1) : ValueRange.of(1, Year.MAX_VALUE));
        }
        return /* Temporal. super.*/super_range(field);
    }
    ValueRange super_range(TemporalField field) {
        if (cast(ChronoField)(field) !is null) {
            if (isSupported(field)) {
                return field.range();
            }
            throw new UnsupportedTemporalTypeException("Unsupported field: " ~ typeid(field).name);
        }
        assert(field, "field");
        return field.rangeRefinedBy(this);
    }
    /**
     * Gets the value of the specified field from this year-month as an {@code int}.
     * !(p)
     * This queries this year-month for the value of the specified field.
     * The returned value will always be within the valid range of values for the field.
     * If it is not possible to return the value, because the field is not supported
     * or for some other reason, an exception is thrown.
     * !(p)
     * If the field is a {@link ChronoField} then the query is implemented here.
     * The {@link #isSupported(TemporalField) supported fields} will return valid
     * values based on this year-month, except {@code PROLEPTIC_MONTH} which is too
     * large to fit _in an {@code int} and throw a {@code DateTimeException}.
     * All other {@code ChronoField} instances will throw an {@code UnsupportedTemporalTypeException}.
     * !(p)
     * If the field is not a {@code ChronoField}, then the result of this method
     * is obtained by invoking {@code TemporalField.getFrom(TemporalAccessor)}
     * passing {@code this} as the argument. Whether the value can be obtained,
     * and what the value represents, is determined by the field.
     *
     * @param field  the field to get, not null
     * @return the value for the field
     * @throws DateTimeException if a value for the field cannot be obtained or
     *         the value is outside the range of valid values for the field
     * @throws UnsupportedTemporalTypeException if the field is not supported or
     *         the range of values exceeds an {@code int}
     * @throws ArithmeticException if numeric overflow occurs
     */
    override  // override for Javadoc
    public int get(TemporalField field) {
        return range(field).checkValidIntValue(getLong(field), field);
    }

    /**
     * Gets the value of the specified field from this year-month as a {@code long}.
     * !(p)
     * This queries this year-month for the value of the specified field.
     * If it is not possible to return the value, because the field is not supported
     * or for some other reason, an exception is thrown.
     * !(p)
     * If the field is a {@link ChronoField} then the query is implemented here.
     * The {@link #isSupported(TemporalField) supported fields} will return valid
     * values based on this year-month.
     * All other {@code ChronoField} instances will throw an {@code UnsupportedTemporalTypeException}.
     * !(p)
     * If the field is not a {@code ChronoField}, then the result of this method
     * is obtained by invoking {@code TemporalField.getFrom(TemporalAccessor)}
     * passing {@code this} as the argument. Whether the value can be obtained,
     * and what the value represents, is determined by the field.
     *
     * @param field  the field to get, not null
     * @return the value for the field
     * @throws DateTimeException if a value for the field cannot be obtained
     * @throws UnsupportedTemporalTypeException if the field is not supported
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public long getLong(TemporalField field) {
        if (cast(ChronoField)(field) !is null) {
            auto f = cast(ChronoField) field;
            {
                if( f ==  ChronoField.MONTH_OF_YEAR) return month;
                if( f ==  ChronoField.PROLEPTIC_MONTH) return getProlepticMonth();
                if( f ==  ChronoField.YEAR_OF_ERA) return (year < 1 ? 1 - year : year);
                if( f ==  ChronoField.YEAR) return year;
                if( f ==  ChronoField.ERA) return (year < 1 ? 0 : 1);
            }
            throw new UnsupportedTemporalTypeException("Unsupported field: " ~ f.toString);
        }
        return field.getFrom(this);
    }

    private long getProlepticMonth() {
        return (year * 12L + month - 1);
    }

    //-----------------------------------------------------------------------
    /**
     * Gets the year field.
     * !(p)
     * This method returns the primitive {@code int} value for the year.
     * !(p)
     * The year returned by this method is proleptic as per {@code get(YEAR)}.
     *
     * @return the year, from MIN_YEAR to MAX_YEAR
     */
    public int getYear() {
        return year;
    }

    /**
     * Gets the month-of-year field from 1 to 12.
     * !(p)
     * This method returns the month as an {@code int} from 1 to 12.
     * Application code is frequently clearer if the enum {@link Month}
     * is used by calling {@link #getMonth()}.
     *
     * @return the month-of-year, from 1 to 12
     * @see #getMonth()
     */
    public int getMonthValue() {
        return month;
    }

    /**
     * Gets the month-of-year field using the {@code Month} enum.
     * !(p)
     * This method returns the enum {@link Month} for the month.
     * This avoids confusion as to what {@code int} values mean.
     * If you need access to the primitive {@code int} value then the enum
     * provides the {@link Month#getValue() int value}.
     *
     * @return the month-of-year, not null
     * @see #getMonthValue()
     */
    public Month getMonth() {
        return Month.of(month);
    }

    //-----------------------------------------------------------------------
    /**
     * Checks if the year is a leap year, according to the ISO proleptic
     * calendar system rules.
     * !(p)
     * This method applies the current rules for leap years across the whole time-line.
     * In general, a year is a leap year if it is divisible by four without
     * remainder. However, years divisible by 100, are not leap years, with
     * the exception of years divisible by 400 which are.
     * !(p)
     * For example, 1904 is a leap year it is divisible by 4.
     * 1900 was not a leap year as it is divisible by 100, however 2000 was a
     * leap year as it is divisible by 400.
     * !(p)
     * The calculation is proleptic - applying the same rules into the far future and far past.
     * This is historically inaccurate, but is correct for the ISO-8601 standard.
     *
     * @return true if the year is leap, false otherwise
     */
    public bool isLeapYear() {
        return IsoChronology.INSTANCE.isLeapYear(year);
    }

    /**
     * Checks if the day-of-month is valid for this year-month.
     * !(p)
     * This method checks whether this year and month and the input day form
     * a valid date.
     *
     * @param dayOfMonth  the day-of-month to validate, from 1 to 31, invalid value returns false
     * @return true if the day is valid for this year-month
     */
    public bool isValidDay(int dayOfMonth) {
        return dayOfMonth >= 1 && dayOfMonth <= lengthOfMonth();
    }

    /**
     * Returns the length of the month, taking account of the year.
     * !(p)
     * This returns the length of the month _in days.
     * For example, a date _in January would return 31.
     *
     * @return the length of the month _in days, from 28 to 31
     */
    public int lengthOfMonth() {
        return getMonth().length(isLeapYear());
    }

    /**
     * Returns the length of the year.
     * !(p)
     * This returns the length of the year _in days, either 365 or 366.
     *
     * @return 366 if the year is leap, 365 otherwise
     */
    public int lengthOfYear() {
        return (isLeapYear() ? 366 : 365);
    }

    //-----------------------------------------------------------------------
    /**
     * Returns an adjusted copy of this year-month.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the year-month adjusted.
     * The adjustment takes place using the specified adjuster strategy object.
     * Read the documentation of the adjuster to understand what adjustment will be made.
     * !(p)
     * A simple adjuster might simply set the one of the fields, such as the year field.
     * A more complex adjuster might set the year-month to the next month that
     * Halley's comet will pass the Earth.
     * !(p)
     * The result of this method is obtained by invoking the
     * {@link TemporalAdjuster#adjustInto(Temporal)} method on the
     * specified adjuster passing {@code this} as the argument.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param adjuster the adjuster to use, not null
     * @return a {@code YearMonth} based on {@code this} with the adjustment made, not null
     * @throws DateTimeException if the adjustment cannot be made
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth _with(TemporalAdjuster adjuster) {
        return cast(YearMonth) adjuster.adjustInto(this);
    }

    /**
     * Returns a copy of this year-month with the specified field set to a new value.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the value
     * for the specified field changed.
     * This can be used to change any supported field, such as the year or month.
     * If it is not possible to set the value, because the field is not supported or for
     * some other reason, an exception is thrown.
     * !(p)
     * If the field is a {@link ChronoField} then the adjustment is implemented here.
     * The supported fields behave as follows:
     * !(ul)
     * !(li){@code MONTH_OF_YEAR} -
     *  Returns a {@code YearMonth} with the specified month-of-year.
     *  The year will be unchanged.
     * !(li){@code PROLEPTIC_MONTH} -
     *  Returns a {@code YearMonth} with the specified proleptic-month.
     *  This completely replaces the year and month of this object.
     * !(li){@code YEAR_OF_ERA} -
     *  Returns a {@code YearMonth} with the specified year-of-era
     *  The month and era will be unchanged.
     * !(li){@code YEAR} -
     *  Returns a {@code YearMonth} with the specified year.
     *  The month will be unchanged.
     * !(li){@code ERA} -
     *  Returns a {@code YearMonth} with the specified era.
     *  The month and year-of-era will be unchanged.
     * </ul>
     * !(p)
     * In all cases, if the new value is outside the valid range of values for the field
     * then a {@code DateTimeException} will be thrown.
     * !(p)
     * All other {@code ChronoField} instances will throw an {@code UnsupportedTemporalTypeException}.
     * !(p)
     * If the field is not a {@code ChronoField}, then the result of this method
     * is obtained by invoking {@code TemporalField.adjustInto(Temporal, long)}
     * passing {@code this} as the argument. In this case, the field determines
     * whether and how to adjust the instant.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param field  the field to set _in the result, not null
     * @param newValue  the new value of the field _in the result
     * @return a {@code YearMonth} based on {@code this} with the specified field set, not null
     * @throws DateTimeException if the field cannot be set
     * @throws UnsupportedTemporalTypeException if the field is not supported
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth _with(TemporalField field, long newValue) {
        if (cast(ChronoField)(field) !is null) {
            ChronoField f = cast(ChronoField) field;
            f.checkValidValue(newValue);
            {
                if( f== ChronoField.MONTH_OF_YEAR) return withMonth(cast(int) newValue);
                if( f== ChronoField.PROLEPTIC_MONTH) return plusMonths(newValue - getProlepticMonth());
                if( f== ChronoField.YEAR_OF_ERA) return withYear(cast(int) (year < 1 ? 1 - newValue : newValue));
                if( f== ChronoField.YEAR) return withYear(cast(int) newValue);
                if( f== ChronoField.ERA) return (getLong(ChronoField.ERA) == newValue ? this : withYear(1 - year));
            }
            throw new UnsupportedTemporalTypeException("Unsupported field: " ~ f.toString);
        }
        return cast(YearMonth)(field.adjustInto(this, newValue));
    }

    //-----------------------------------------------------------------------
    /**
     * Returns a copy of this {@code YearMonth} with the year altered.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param year  the year to set _in the returned year-month, from MIN_YEAR to MAX_YEAR
     * @return a {@code YearMonth} based on this year-month with the requested year, not null
     * @throws DateTimeException if the year value is invalid
     */
    public YearMonth withYear(int year) {
        ChronoField.YEAR.checkValidValue(year);
        return _with(year, month);
    }

    /**
     * Returns a copy of this {@code YearMonth} with the month-of-year altered.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param month  the month-of-year to set _in the returned year-month, from 1 (January) to 12 (December)
     * @return a {@code YearMonth} based on this year-month with the requested month, not null
     * @throws DateTimeException if the month-of-year value is invalid
     */
    public YearMonth withMonth(int month) {
        ChronoField.MONTH_OF_YEAR.checkValidValue(month);
        return _with(year, month);
    }

    //-----------------------------------------------------------------------
    /**
     * Returns a copy of this year-month with the specified amount added.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the specified amount added.
     * The amount is typically {@link Period} but may be any other type implementing
     * the {@link TemporalAmount} interface.
     * !(p)
     * The calculation is delegated to the amount object by calling
     * {@link TemporalAmount#addTo(Temporal)}. The amount implementation is free
     * to implement the addition _in any way it wishes, however it typically
     * calls back to {@link #plus(long, TemporalUnit)}. Consult the documentation
     * of the amount implementation to determine if it can be successfully added.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param amountToAdd  the amount to add, not null
     * @return a {@code YearMonth} based on this year-month with the addition made, not null
     * @throws DateTimeException if the addition cannot be made
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth plus(TemporalAmount amountToAdd) {
        return cast(YearMonth) amountToAdd.addTo(this);
    }

    /**
     * Returns a copy of this year-month with the specified amount added.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the amount
     * _in terms of the unit added. If it is not possible to add the amount, because the
     * unit is not supported or for some other reason, an exception is thrown.
     * !(p)
     * If the field is a {@link ChronoUnit} then the addition is implemented here.
     * The supported fields behave as follows:
     * !(ul)
     * !(li){@code MONTHS} -
     *  Returns a {@code YearMonth} with the specified number of months added.
     *  This is equivalent to {@link #plusMonths(long)}.
     * !(li){@code YEARS} -
     *  Returns a {@code YearMonth} with the specified number of years added.
     *  This is equivalent to {@link #plusYears(long)}.
     * !(li){@code DECADES} -
     *  Returns a {@code YearMonth} with the specified number of decades added.
     *  This is equivalent to calling {@link #plusYears(long)} with the amount
     *  multiplied by 10.
     * !(li){@code CENTURIES} -
     *  Returns a {@code YearMonth} with the specified number of centuries added.
     *  This is equivalent to calling {@link #plusYears(long)} with the amount
     *  multiplied by 100.
     * !(li){@code MILLENNIA} -
     *  Returns a {@code YearMonth} with the specified number of millennia added.
     *  This is equivalent to calling {@link #plusYears(long)} with the amount
     *  multiplied by 1,000.
     * !(li){@code ERAS} -
     *  Returns a {@code YearMonth} with the specified number of eras added.
     *  Only two eras are supported so the amount must be one, zero or minus one.
     *  If the amount is non-zero then the year is changed such that the year-of-era
     *  is unchanged.
     * </ul>
     * !(p)
     * All other {@code ChronoUnit} instances will throw an {@code UnsupportedTemporalTypeException}.
     * !(p)
     * If the field is not a {@code ChronoUnit}, then the result of this method
     * is obtained by invoking {@code TemporalUnit.addTo(Temporal, long)}
     * passing {@code this} as the argument. In this case, the unit determines
     * whether and how to perform the addition.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param amountToAdd  the amount of the unit to add to the result, may be negative
     * @param unit  the unit of the amount to add, not null
     * @return a {@code YearMonth} based on this year-month with the specified amount added, not null
     * @throws DateTimeException if the addition cannot be made
     * @throws UnsupportedTemporalTypeException if the unit is not supported
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth plus(long amountToAdd, TemporalUnit unit) {
        if (cast(ChronoUnit)(unit) !is null) {
            auto f = cast(ChronoUnit) unit;
            {
                if( f == ChronoUnit.MONTHS) return plusMonths(amountToAdd);
                if( f == ChronoUnit.YEARS) return plusYears(amountToAdd);
                if( f == ChronoUnit.DECADES) return plusYears(Math.multiplyExact(amountToAdd, 10));
                if( f == ChronoUnit.CENTURIES) return plusYears(Math.multiplyExact(amountToAdd, 100));
                if( f == ChronoUnit.MILLENNIA) return plusYears(Math.multiplyExact(amountToAdd, 1000));
                if( f == ChronoUnit.ERAS) return _with(ChronoField.ERA, Math.addExact(getLong(ChronoField.ERA), amountToAdd));
            }
            throw new UnsupportedTemporalTypeException("Unsupported unit: " ~ f.toString);
        }
        return cast(YearMonth)(unit.addTo(this, amountToAdd));
    }

    /**
     * Returns a copy of this {@code YearMonth} with the specified number of years added.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param yearsToAdd  the years to add, may be negative
     * @return a {@code YearMonth} based on this year-month with the years added, not null
     * @throws DateTimeException if the result exceeds the supported range
     */
    public YearMonth plusYears(long yearsToAdd) {
        if (yearsToAdd == 0) {
            return this;
        }
        int newYear = ChronoField.YEAR.checkValidIntValue(year + yearsToAdd);  // safe overflow
        return _with(newYear, month);
    }

    /**
     * Returns a copy of this {@code YearMonth} with the specified number of months added.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param monthsToAdd  the months to add, may be negative
     * @return a {@code YearMonth} based on this year-month with the months added, not null
     * @throws DateTimeException if the result exceeds the supported range
     */
    public YearMonth plusMonths(long monthsToAdd) {
        if (monthsToAdd == 0) {
            return this;
        }
        long monthCount = year * 12L + (month - 1);
        long calcMonths = monthCount + monthsToAdd;  // safe overflow
        int newYear = ChronoField.YEAR.checkValidIntValue(Math.floorDiv(calcMonths, 12));
        int newMonth = Math.floorMod(calcMonths, 12) + 1;
        return _with(newYear, newMonth);
    }

    //-----------------------------------------------------------------------
    /**
     * Returns a copy of this year-month with the specified amount subtracted.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the specified amount subtracted.
     * The amount is typically {@link Period} but may be any other type implementing
     * the {@link TemporalAmount} interface.
     * !(p)
     * The calculation is delegated to the amount object by calling
     * {@link TemporalAmount#subtractFrom(Temporal)}. The amount implementation is free
     * to implement the subtraction _in any way it wishes, however it typically
     * calls back to {@link #minus(long, TemporalUnit)}. Consult the documentation
     * of the amount implementation to determine if it can be successfully subtracted.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param amountToSubtract  the amount to subtract, not null
     * @return a {@code YearMonth} based on this year-month with the subtraction made, not null
     * @throws DateTimeException if the subtraction cannot be made
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth minus(TemporalAmount amountToSubtract) {
        return cast(YearMonth) amountToSubtract.subtractFrom(this);
    }

    /**
     * Returns a copy of this year-month with the specified amount subtracted.
     * !(p)
     * This returns a {@code YearMonth}, based on this one, with the amount
     * _in terms of the unit subtracted. If it is not possible to subtract the amount,
     * because the unit is not supported or for some other reason, an exception is thrown.
     * !(p)
     * This method is equivalent to {@link #plus(long, TemporalUnit)} with the amount negated.
     * See that method for a full description of how addition, and thus subtraction, works.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param amountToSubtract  the amount of the unit to subtract from the result, may be negative
     * @param unit  the unit of the amount to subtract, not null
     * @return a {@code YearMonth} based on this year-month with the specified amount subtracted, not null
     * @throws DateTimeException if the subtraction cannot be made
     * @throws UnsupportedTemporalTypeException if the unit is not supported
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public YearMonth minus(long amountToSubtract, TemporalUnit unit) {
        return (amountToSubtract == Long.MIN_VALUE ? plus(Long.MAX_VALUE, unit).plus(1, unit) : plus(-amountToSubtract, unit));
    }

    /**
     * Returns a copy of this {@code YearMonth} with the specified number of years subtracted.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param yearsToSubtract  the years to subtract, may be negative
     * @return a {@code YearMonth} based on this year-month with the years subtracted, not null
     * @throws DateTimeException if the result exceeds the supported range
     */
    public YearMonth minusYears(long yearsToSubtract) {
        return (yearsToSubtract == Long.MIN_VALUE ? plusYears(Long.MAX_VALUE).plusYears(1) : plusYears(-yearsToSubtract));
    }

    /**
     * Returns a copy of this {@code YearMonth} with the specified number of months subtracted.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param monthsToSubtract  the months to subtract, may be negative
     * @return a {@code YearMonth} based on this year-month with the months subtracted, not null
     * @throws DateTimeException if the result exceeds the supported range
     */
    public YearMonth minusMonths(long monthsToSubtract) {
        return (monthsToSubtract == Long.MIN_VALUE ? plusMonths(Long.MAX_VALUE).plusMonths(1) : plusMonths(-monthsToSubtract));
    }

    //-----------------------------------------------------------------------
    /**
     * Queries this year-month using the specified query.
     * !(p)
     * This queries this year-month using the specified query strategy object.
     * The {@code TemporalQuery} object defines the logic to be used to
     * obtain the result. Read the documentation of the query to understand
     * what the result of this method will be.
     * !(p)
     * The result of this method is obtained by invoking the
     * {@link TemporalQuery#queryFrom(TemporalAccessor)} method on the
     * specified query passing {@code this} as the argument.
     *
     * @param !(R) the type of the result
     * @param query  the query to invoke, not null
     * @return the query result, null may be returned (defined by the query)
     * @throws DateTimeException if unable to query (defined by the query)
     * @throws ArithmeticException if numeric overflow occurs (defined by the query)
     */
    /*@SuppressWarnings("unchecked")*/
    // override
    public R query(R)(TemporalQuery!(R) query) {
        if (query == TemporalQueries.chronology()) {
            return cast(R) IsoChronology.INSTANCE;
        } else if (query == TemporalQueries.precision()) {
            return cast(R) (ChronoUnit.MONTHS);
        }
        return /* Temporal. */super_query(query);
    }
    R super_query(R)(TemporalQuery!(R) query) {
         if (query == TemporalQueries.zoneId()
                 || query == TemporalQueries.chronology()
                 || query == TemporalQueries.precision()) {
             return null;
         }
         return query.queryFrom(this);
     }
    /**
     * Adjusts the specified temporal object to have this year-month.
     * !(p)
     * This returns a temporal object of the same observable type as the input
     * with the year and month changed to be the same as this.
     * !(p)
     * The adjustment is equivalent to using {@link Temporal#_with(TemporalField, long)}
     * passing {@link ChronoField#PROLEPTIC_MONTH} as the field.
     * If the specified temporal object does not use the ISO calendar system then
     * a {@code DateTimeException} is thrown.
     * !(p)
     * In most cases, it is clearer to reverse the calling pattern by using
     * {@link Temporal#_with(TemporalAdjuster)}:
     * !(pre)
     *   // these two lines are equivalent, but the second approach is recommended
     *   temporal = thisYearMonth.adjustInto(temporal);
     *   temporal = temporal._with(thisYearMonth);
     * </pre>
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param temporal  the target object to be adjusted, not null
     * @return the adjusted object, not null
     * @throws DateTimeException if unable to make the adjustment
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public Temporal adjustInto(Temporal temporal) {
        if ((Chronology.from(temporal) == IsoChronology.INSTANCE) == false) {
            throw new DateTimeException("Adjustment only supported on ISO date-time");
        }
        return temporal._with(ChronoField.PROLEPTIC_MONTH, getProlepticMonth());
    }

    /**
     * Calculates the amount of time until another year-month _in terms of the specified unit.
     * !(p)
     * This calculates the amount of time between two {@code YearMonth}
     * objects _in terms of a single {@code TemporalUnit}.
     * The start and end points are {@code this} and the specified year-month.
     * The result will be negative if the end is before the start.
     * The {@code Temporal} passed to this method is converted to a
     * {@code YearMonth} using {@link #from(TemporalAccessor)}.
     * For example, the amount _in years between two year-months can be calculated
     * using {@code startYearMonth.until(endYearMonth, YEARS)}.
     * !(p)
     * The calculation returns a whole number, representing the number of
     * complete units between the two year-months.
     * For example, the amount _in decades between 2012-06 and 2032-05
     * will only be one decade as it is one month short of two decades.
     * !(p)
     * There are two equivalent ways of using this method.
     * The first is to invoke this method.
     * The second is to use {@link TemporalUnit#between(Temporal, Temporal)}:
     * !(pre)
     *   // these two lines are equivalent
     *   amount = start.until(end, MONTHS);
     *   amount = MONTHS.between(start, end);
     * </pre>
     * The choice should be made based on which makes the code more readable.
     * !(p)
     * The calculation is implemented _in this method for {@link ChronoUnit}.
     * The units {@code MONTHS}, {@code YEARS}, {@code DECADES},
     * {@code CENTURIES}, {@code MILLENNIA} and {@code ERAS} are supported.
     * Other {@code ChronoUnit} values will throw an exception.
     * !(p)
     * If the unit is not a {@code ChronoUnit}, then the result of this method
     * is obtained by invoking {@code TemporalUnit.between(Temporal, Temporal)}
     * passing {@code this} as the first argument and the converted input temporal
     * as the second argument.
     * !(p)
     * This instance is immutable and unaffected by this method call.
     *
     * @param endExclusive  the end date, exclusive, which is converted to a {@code YearMonth}, not null
     * @param unit  the unit to measure the amount _in, not null
     * @return the amount of time between this year-month and the end year-month
     * @throws DateTimeException if the amount cannot be calculated, or the end
     *  temporal cannot be converted to a {@code YearMonth}
     * @throws UnsupportedTemporalTypeException if the unit is not supported
     * @throws ArithmeticException if numeric overflow occurs
     */
    override
    public long until(Temporal endExclusive, TemporalUnit unit) {
        YearMonth end = YearMonth.from(endExclusive);
        if (cast(ChronoUnit)(unit) !is null) {
            long monthsUntil = end.getProlepticMonth() - getProlepticMonth();  // no overflow
            auto f = cast(ChronoUnit) unit;
            {
                if( f == ChronoUnit.MONTHS) return monthsUntil;
                if( f == ChronoUnit.YEARS) return monthsUntil / 12;
                if( f == ChronoUnit.DECADES) return monthsUntil / 120;
                if( f == ChronoUnit.CENTURIES) return monthsUntil / 1200;
                if( f == ChronoUnit.MILLENNIA) return monthsUntil / 12000;
                if( f == ChronoUnit.ERAS) return end.getLong(ChronoField.ERA) - getLong(ChronoField.ERA);
            }
            throw new UnsupportedTemporalTypeException("Unsupported unit: " ~ f.toString);
        }
        return unit.between(this, end);
    }

    /**
     * Formats this year-month using the specified formatter.
     * !(p)
     * This year-month will be passed to the formatter to produce a string.
     *
     * @param formatter  the formatter to use, not null
     * @return the formatted year-month string, not null
     * @throws DateTimeException if an error occurs during printing
     */
    public string format(DateTimeFormatter formatter) {
        assert(formatter, "formatter");
        return formatter.format(this);
    }

    //-----------------------------------------------------------------------
    /**
     * Combines this year-month with a day-of-month to create a {@code LocalDate}.
     * !(p)
     * This returns a {@code LocalDate} formed from this year-month and the specified day-of-month.
     * !(p)
     * The day-of-month value must be valid for the year-month.
     * !(p)
     * This method can be used as part of a chain to produce a date:
     * !(pre)
     *  LocalDate date = year.atMonth(month).atDay(day);
     * </pre>
     *
     * @param dayOfMonth  the day-of-month to use, from 1 to 31
     * @return the date formed from this year-month and the specified day, not null
     * @throws DateTimeException if the day is invalid for the year-month
     * @see #isValidDay(int)
     */
    public LocalDate atDay(int dayOfMonth) {
        return LocalDate.of(year, month, dayOfMonth);
    }

    /**
     * Returns a {@code LocalDate} at the end of the month.
     * !(p)
     * This returns a {@code LocalDate} based on this year-month.
     * The day-of-month is set to the last valid day of the month, taking
     * into account leap years.
     * !(p)
     * This method can be used as part of a chain to produce a date:
     * !(pre)
     *  LocalDate date = year.atMonth(month).atEndOfMonth();
     * </pre>
     *
     * @return the last valid date of this year-month, not null
     */
    public LocalDate atEndOfMonth() {
        return LocalDate.of(year, month, lengthOfMonth());
    }

    //-----------------------------------------------------------------------
    /**
     * Compares this year-month to another year-month.
     * !(p)
     * The comparison is based first on the value of the year, then on the value of the month.
     * It is "consistent with equals", as defined by {@link Comparable}.
     *
     * @param other  the other year-month to compare to, not null
     * @return the comparator value, negative if less, positive if greater
     */
    // override
    public int compareTo(YearMonth other) {
        int cmp = (year - other.year);
        if (cmp == 0) {
            cmp = (month - other.month);
        }
        return cmp;
    }

     override
    public int opCmp(YearMonth other) {
        return compareTo(other);
    }

    /**
     * Checks if this year-month is after the specified year-month.
     *
     * @param other  the other year-month to compare to, not null
     * @return true if this is after the specified year-month
     */
    public bool isAfter(YearMonth other) {
        return compareTo(other) > 0;
    }

    /**
     * Checks if this year-month is before the specified year-month.
     *
     * @param other  the other year-month to compare to, not null
     * @return true if this point is before the specified year-month
     */
    public bool isBefore(YearMonth other) {
        return compareTo(other) < 0;
    }

    //-----------------------------------------------------------------------
    /**
     * Checks if this year-month is equal to another year-month.
     * !(p)
     * The comparison is based on the time-line position of the year-months.
     *
     * @param obj  the object to check, null returns false
     * @return true if this is equal to the other year-month
     */
    override
    public bool opEquals(Object obj) {
        if (this is obj) {
            return true;
        }
        if (cast(YearMonth)(obj) !is null) {
            YearMonth other = cast(YearMonth) obj;
            return year == other.year && month == other.month;
        }
        return false;
    }

    /**
     * A hash code for this year-month.
     *
     * @return a suitable hash code
     */
    override
    public size_t toHash() @trusted nothrow {
        return year ^ (month << 27);
    }

    //-----------------------------------------------------------------------
    /**
     * Outputs this year-month as a {@code string}, such as {@code 2007-12}.
     * !(p)
     * The output will be _in the format {@code uuuu-MM}:
     *
     * @return a string representation of this year-month, not null
     */
    override
    public string toString() {
        int absYear = Math.abs(year);
        StringBuilder buf = new StringBuilder(9);
        if (absYear < 1000) {
            if (year < 0) {
                buf.append(year - 10000).deleteCharAt(1);
            } else {
                buf.append(year + 10000).deleteCharAt(0);
            }
        } else {
            buf.append(year);
        }
        return buf.append(month < 10 ? "-0" : "-")
            .append(month)
            .toString();
    }

    //-----------------------------------------------------------------------
    /**
     * Writes the object using a
     * <a href="{@docRoot}/serialized-form.html#hunt.time.Ser">dedicated serialized form</a>.
     * @serialData
     * !(pre)
     *  _out.writeByte(12);  // identifies a YearMonth
     *  _out.writeInt(year);
     *  _out.writeByte(month);
     * </pre>
     *
     * @return the instance of {@code Ser}, not null
     */
    private Object writeReplace() {
        return new Ser(Ser.YEAR_MONTH_TYPE, this);
    }

    /**
     * Defend against malicious streams.
     *
     * @param s the stream to read
     * @throws InvalidObjectException always
     */
     ///@gxc
    // private void readObject(ObjectInputStream s) /*throws InvalidObjectException*/ {
    //     throw new InvalidObjectException("Deserialization via serialization delegate");
    // }

    void writeExternal(DataOutput _out) /*throws IOException*/ {
        _out.writeInt(year);
        _out.writeByte(month);
    }

    static YearMonth readExternal(DataInput _in) /*throws IOException*/ {
        int year = _in.readInt();
        byte month = _in.readByte();
        return YearMonth.of(year, month);
    }

}