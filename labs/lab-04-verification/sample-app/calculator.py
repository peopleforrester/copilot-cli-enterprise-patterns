# ABOUTME: Tiny calculator module used by the verification lab.
# ABOUTME: Contains a deliberate bug in `divide` that the learner's agent must fix.

def add(a: float, b: float) -> float:
    return a + b


def subtract(a: float, b: float) -> float:
    return a - b


def multiply(a: float, b: float) -> float:
    return a * b


def divide(a: float, b: float) -> float:
    # Bug: returns inf instead of raising ValueError on b == 0.
    return a / b
