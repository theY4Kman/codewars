#include <criterion/criterion.h>

extern long long reverse_num(long long n);

Test(Sample_Test, should_return_the_reversed_number)
{
    cr_assert_eq(reverse_num(123), 321);
    cr_assert_eq(reverse_num(-456), -654);
    cr_assert_eq(reverse_num(1000), 1);
    cr_assert_eq(reverse_num(0), 0);
    cr_assert_eq(reverse_num(-5), -5);
}
