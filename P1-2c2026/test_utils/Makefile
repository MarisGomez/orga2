PYTHON = python3
PYPATH = PYTHONPATH=python_packages/pycparser-2.23-py3-none-any.whl

diff: asm_defs.txt $(INPUT_PATH)/$(INPUT_C)
	@$(PYPATH) $(PYTHON) parse.py $(INPUT_PATH)/$(INPUT_C) | gcc -x c - -o test
	@./test | $(PYPATH) $(PYTHON) diff.py
	@rm test

asm_defs.txt: $(INPUT_PATH)/$(INPUT_ASM)
	@nasm -f dbg $(INPUT_PATH)/$(INPUT_ASM) --before "BITS 64" -o checker.o 
	cat checker.o | $(PYPATH) $(PYTHON) parse_nasm_dbg.py > asm_defs.txt ; rm checker.o

clean:
	rm -f asm_defs.txt global_foos.txt

.PHONY: asm_defs.txt
