#include <criterion/criterion.h>

char *time_math(const char *time1, const char *op, const char *time2);
void doTest(const char *time1, const char *op, const char *time2, const char *expected);

Test(Time_Math, add)
{
doTest("01:24:31", "+", "02:16:05", "03:40:36");
doTest("01:24:31", "+", "22:35:28", "23:59:59");
}
Test(Time_Math, subtract)
{
doTest("11:24:31", "-", "11:24:31", "00:00:00");
doTest("11:24:31", "-", "03:15:28", "08:09:03");
}
void doTest(const char *time1, const char *op, const char *time2, const char *expected)
{
    char *actual = time_math(time1, op, time2);
    if ( !actual ) cr_assert_not_null(actual, "Received null pointer");
    cr_assert_str_eq(actual, expected);
    free(actual);
}
