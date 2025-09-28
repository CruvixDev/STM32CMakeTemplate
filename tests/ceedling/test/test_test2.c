#include "unity.h"

void setUp(void) {
    // This function is run before each test
}

void tearDown(void) {
    // This function is run after each test
}

void test_sum2(void) {
    int result = 3 + 3;
    TEST_ASSERT_EQUAL_INT(6, result);
}

void test_sum_negative2(void) {
    int result = -1 + -3;
    TEST_ASSERT_EQUAL_INT(-4, result);
}
