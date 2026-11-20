#indentation tests
#uses the temporary "name:" block rule until if statements are added

x = 1

#simple block
block1:
    a = 1
    b = 2

#nested blocks
outer:
    a = 1
    inner:
        b = 2
        innermost:
            c = 3
    d = 4

#dedent more than one level at once
level1:
    level2:
        level3:
            deep = 1
back_to_top = 0

#blank lines and comments inside a block
spaced:
    a = 1

    # comment in the middle

        # comment at a weird indent
    b = 2

#tabs work too
tabbed:
	t = 1
	tabbed_inner:
		t2 = 2

#file ends while still indented
last:
    end1:
        end2 = 1