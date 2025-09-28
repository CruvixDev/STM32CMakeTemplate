#include "unity.h"

void setUp(void) {
    // This function is run before each test
}

void tearDown(void) {
    // This function is run after each test
}

void test_sum(void) {
    int result = 2 + 3;
    TEST_ASSERT_EQUAL_INT(5, result);
}

void test_sum_negative(void) {
    int result = -2 + -3;
    TEST_ASSERT_EQUAL_INT(-5, result);
}
