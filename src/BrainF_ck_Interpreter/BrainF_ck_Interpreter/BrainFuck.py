# BrainFuck.py
#
# BrainFuck Interpreter.
# Inspired by this version:
# https://rosettacode.org/wiki/Execute_Brain****/Python
#
# https://en.wikipedia.org/wiki/Brainfuck
#
# And greatly modified to work on AMIGA python 2.4.3, A1200, Amiga OS3.0x...
# Usage: python [DRIVE:path/to/]BraunFuck.py [DRIVE:path/to/]SourceFile[.ext]<CR>

import sys

# Create a default dictionary.
def defaultdict(default_factory):
	class Default_Dict(dict):
		def __getitem__(self, key):
			if key not in self:
				dict.__setitem__(self, key, default_factory())
			return dict.__getitem__(self, key)
	return Default_Dict()

def brainfuck(fd=None):
	if len(sys.argv) != 2:
		print("Usage: python [DRIVE:path/to/]BrainFuck.py [DRIVE:path/to/]SourceFile[.ext]<CR>")
		sys.exit(1)
	fd = open(sys.argv[1])
	source = fd.read()
	# Remove comment on the line below to show the source code.
	# print(source)
	source = list(source)
	loop_pointers = {}
	loop_stack = []
	pointer = 0
	for opcode in source:
		# Ensure [] loop brackets in matched pairs.
		if opcode == '[': loop_stack.append(pointer)
		if opcode == ']':
			if not loop_stack:
				source = source[:pointer]
				break
			if len(loop_stack) >= 2:
				stack_pointer = loop_stack[len(loop_stack) - 1]
				del loop_stack[len(loop_stack) - 1]
			else:
				stack_pointer = loop_stack[0]
				del loop_stack[0]
			loop_pointers[pointer] = stack_pointer
			loop_pointers[stack_pointer] = pointer
		pointer = pointer + 1

	# If there are more '[' than ']' then crash out.
	if loop_stack:
		print("ERROR: Unequal '[' ']' brackets!")
		sys.exit(2)

	# The decoder...
	tape = defaultdict(int)
	cell = 0
	pointer = 0
	while pointer < len(source):
		opcode = source[pointer]
		if opcode == '>': cell = cell + 1
		elif opcode == '<': cell = cell - 1
		elif opcode == '+': tape[cell] = tape[cell] + 1
		elif opcode == '-': tape[cell] = tape[cell] - 1
		elif opcode == ',': tape[cell] = ord(sys.stdin.read(1))
		elif opcode == '.': sys.stdout.write(chr(tape[cell]))
		elif (opcode == '[' and not tape[cell]) or (opcode == ']' and tape[cell]): pointer = loop_pointers[pointer]
		pointer = pointer + 1

if __name__ == "__main__": brainfuck()

sys.exit(0)

# "Hello World!" source code:
#
# ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
