IVER=/mnt/c/iverilog/bin
GTK=/mnt/c/iverilog/gtkwave/bin

src=$(wildcard *.v)
all: CPU.out

CPU.out: $(src)
	$(IVER)/iverilog.exe -o CPU.out $(src)

test: CPU.out
	@$(IVER)/vvp.exe CPU.out >/dev/null 2>&1
	diff output.txt output_ref.txt
	@if [ $$? -eq 0 ]; then \
		echo "Success"; \
	fi

gtk: test
	$(GTK)/gtkwave.exe CPU.vcd

clean:
	rm -rf CPU.out
