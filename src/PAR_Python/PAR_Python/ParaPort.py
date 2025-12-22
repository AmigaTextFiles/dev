def main():
	while 1:
		pointer = open('PAR:', 'rb', 1)
		mybyte = str(pointer.read(1))
		pointer.close()
		print 'Decimal value at the parallel port is:-',ord(mybyte),'.    '
main()
