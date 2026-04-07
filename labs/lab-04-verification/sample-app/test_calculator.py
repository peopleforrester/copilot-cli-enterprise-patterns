# ABOUTME: Tests for calculator.py used by the verification lab.
# ABOUTME: One test fails by design until the learner's agent fixes the divide bug.

import pytest

from calculator import add, divide, multiply, subtract


def test_add():
    assert add(2, 3) == 5


def test_subtract():
    assert subtract(5, 2) == 3


def test_multiply():
    assert multiply(4, 3) == 12


def test_divide():
    assert divide(10, 2) == 5


def test_divide_by_zero_raises():
    with pytest.raises(ValueError):
        divide(1, 0)
