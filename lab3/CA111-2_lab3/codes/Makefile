
IVER=/mnt/c/iverilog/bin
GTK=/mnt/c/iverilog/gtkwave/bin



vvp:
	$(IVER)/iverilog.exe -o CPU.out *.v
	@$(IVER)/vvp.exe CPU.out > /dev/null 2>&1 

test: vvp
	diff output.txt output_ref.txt
	@if [ $$? -eq 0 ]; then \
		echo "Success"; \
	fi

gtk: vvp
	@$(GTK)/gtkwave.exe CPU.vcd

clean:
	rm -f CPU.out CPU.vcd
