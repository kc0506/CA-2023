C=codes
SUBDIR=b10401006_lab1
submit:
	-mkdir $(SUBDIR) 2>/dev/null
	rm $(SUBDIR)/* -rf
	mkdir $(SUBDIR)/codes
	find $C -regex ".*\.v" -not \( -name "testbench.v" -o -name "Instruction_Memory.v" \
	-o -name "Registers.v" -o -name "PC.v"	\) \
	-exec cp '{}' $(SUBDIR)/codes/ \;
	cp b10401006_lab1_report.pdf $(SUBDIR)
	zip -r b10401006_lab1.zip $(SUBDIR)/*