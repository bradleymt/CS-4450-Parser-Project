#indentation tests
#uses if statements as the blocks

x = 1

#simple block
if block1:
    a = 1
    b = 2

#nested blocks
if outer:
    a = 1
    if inner:
        b = 2
        if innermost:
            c = 3
    d = 4

#dedent more than one level at once
if level1:
    if level2:
        if level3:
            deep = 1
back_to_top = 0

#blank lines and comments inside a block
if spaced:
    a = 1

    # comment in the middle

        # comment at a weird indent
    b = 2

#tabs work too
if tabbed:
	t = 1
	if tabbed_inner:
		t2 = 2

#file ends while still indented
if last:
    if end1:
        end2 = 1

#if / elif / else chains, nested
if a < b:
    x = 1
elif a == b:
    if c:
        x = 2
    else:
        x = 3
elif not c:
    x = 4
else:
    x = 5
y = x
