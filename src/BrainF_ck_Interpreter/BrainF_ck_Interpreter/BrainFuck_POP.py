# BrainFuck_POP.py
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

def defaultdict(default_factory):
	class DefaultDict(dict):
		def __getitem__(self, key):
			if key not in self:
				dict.__setitem__(self, key, default_factory())
			return dict.__getitem__(self, key)
	return DefaultDict()

def brainfuck(fd=None):
	if len(sys.argv) != 2:
		print("ERROR! Usage: python BrainFuck.py SourceFile[.ext]<CR>")
		sys.exit(1)
	fd = open(sys.argv[1])
	source = fd.read()
	# Option below to print the source code.
	# print(source)
	source=list(source)
	loop_ptrs = {}
	loop_stack = []
	#for ptr, opcode in enumerate(source):
	ptr = 0
	for opcode in source:
		if opcode == '[': loop_stack.append(ptr)
		if opcode == ']':
			if not loop_stack:
				source = source[:ptr]
				break
			sptr = loop_stack.pop()
			loop_ptrs[ptr] = sptr
			loop_ptrs[sptr] = ptr
		ptr = ptr + 1

	# If there are more '[' than ']' then crash out.
	if loop_stack:
		print("ERROR: Unequal '[' ']' brackets!")
		sys.exit(2)

	tape = defaultdict(int)
	cell = 0
	ptr = 0
	while ptr < len(source):
		opcode = source[ptr]
		if   opcode == '>': cell = cell + 1
		elif opcode == '<': cell = cell - 1
		elif opcode == '+': tape[cell] = tape[cell] + 1
		elif opcode == '-': tape[cell] = tape[cell] - 1
		elif opcode == ',': tape[cell] = ord(sys.stdin.read(1))
		elif opcode == '.': sys.stdout.write(chr(tape[cell]))
		elif (opcode == '[' and not tape[cell]) or (opcode == ']' and tape[cell]): ptr = loop_ptrs[ptr]
		ptr = ptr + 1

if __name__ == "__main__": brainfuck()

sys.exit()