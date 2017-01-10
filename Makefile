DEST=${HOME}/bin

install:
	install -m 0755 sweep.rb ${DEST}/sweep

local:
	./sweep.rb 192.168.0.1-192.168.0.9

melt:
	./sweep.rb 150.69.90.30-150.69.90.89

clean:
	${RM} *~ *.bak



