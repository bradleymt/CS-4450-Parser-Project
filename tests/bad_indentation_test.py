#bad indentation, every section should give an error

#unexpected indent
x = 1
    y = 2

#unindent to a level that doesnt exist
if block:
        a = 1
    b = 2

#block with no indented body
if empty:
z = 4

#else with no if
else:
    w = 1

#elif indented deeper than its if
if a:
    v = 1
    elif b:
        v = 2
