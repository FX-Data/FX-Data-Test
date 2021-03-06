TF    ?= M1,M5,M15,M30,H1,H4,D1,W1,MN1
SHELL := /usr/bin/env TF=$(TF) $(SHELL) -x
SCR_D	:= $(PWD)/FX-BT-Scripts
xargs := $(shell which gxargs xargs | head -n1)
pair  := $(shell find ?????? -maxdepth 0 -print -quit)
year  := $(shell (cd ??????; find ???? -maxdepth 0 -type d))
size  := $(shell du -sb $(pair) | cut -f1)

# HST files.
m1_hst=$(pair)1.hst
m5_hst=$(pair)5.hst
m15_hst=$(pair)15.hst
m30_hst=$(pair)30.hst
h1_hst=$(pair)60.hst
h4_hst=$(pair)240.hst
d1_hst=$(pair)1440.hst
w1_hst=$(pair)10080.hst
mn_hst=$(pair)43200.hst

# FXT files.
m1_fxt=$(pair)1_0.fxt
m5_fxt=$(pair)5_0.fxt
m15_fxt=$(pair)15_0.fxt
m30_fxt=$(pair)30_0.fxt
h1_fxt=$(pair)60_0.fxt
h4_fxt=$(pair)240_0.fxt
d1_fxt=$(pair)1440_0.fxt
w1_fxt=$(pair)10080_0.fxt
mn_fxt=$(pair)43200_0.fxt

csvfile=all.csv
spread=20

all: hst fxt
	git tag
	@echo Done.

hst: FX-BT-Scripts $(csvfile) $(m1_hst).gz
	@echo Done.

fxt: FX-BT-Scripts $(csvfile) $(m1_fxt).gz
	@echo Done.

clean:
	git clean -fd
	rm -fr FX-BT-Scripts

FX-BT-Scripts:
	git clone --depth 1 https://github.com/FX31337/FX-BT-Scripts.git

$(csvfile):
	find . -name '*.csv' -print0 | sort -z | $(xargs) -r0 cat | tee $(csvfile) > /dev/null
# find . -name '*.csv' -print0 | sort -z | $(xargs) -r0 cat | tee $(csvfile) | pv -ps $(size) > /dev/null

# Generate HST files.
$(m1_hst).gz:
	$(SCR_D)/fx-data-convert-from-csv.py -v -i $(csvfile) -p $(pair) -s $(spread) -S default -t $(TF) -f hst
	gzip -v *.hst

# Generate FXT files.
$(m1_fxt).gz:
	$(SCR_D)/fx-data-convert-from-csv.py -v -i $(csvfile) -p $(pair) -s $(spread) -S default -t $(TF) -f fxt -m 0,1,2
	gzip -v *.fxt
