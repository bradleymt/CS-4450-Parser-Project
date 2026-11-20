# Condition tests -Michael
# Every line *should* be valid Python, but I also kind of hate Python so we'll see how that goes.

# Each comparison operator.
c1 = a < b
c2 = a <= b
c3 = a > b
c4 = a >= b
c5 = a == b
c6 = a != b

# Operands that aren't variables.
c7 = 1.5 > 0.5
c8 = "abc" == 'abc'
c9 = True != False
c10 = x + 1 >= y * 2
c11 = -x < -5
c12 = (x + 1) < 3

# Chained comparison.
c13 = a < b < c
c14 = 1 <= x <= 10

# And, Or, and Not.
l1 = a and b
l2 = a or b
l3 = not a
l4 = not not a
l5 = a and b and c
l6 = a or b or c

# Precedence: not > and > or, comparison binds the tightest.
p1 = a or b and c
p2 = not a and b
p3 = not a < b
p4 = a < b and c > d or e == f
p5 = not a or not b

# Parentheses
q1 = (a or b) and c
q2 = (not flag) and x > 10
a3 = ((a))
a4 = ((a < b) or (c > d)) and not (e == f)
a5 = (a)

# Names that start with a keyword are still names.
android = 1
nottingham = 2
ordain = 3
or_x = android < nottingham
and_y = not ordain

# Trailing comment.
t1 = a < b # Awesome sick great comment here.
t2 = a and b
