#
# convert Markdown to ODT files
#

# pandoc command and options
PANDOC=pandoc
PANDOC_OPTIONS=--data-dir=$(CURDIR)/Templates --from=markdown --to=odt --lua-filter=$(CURDIR)/Templates/filter.lua

# documents
TARGETS=Policies/RC_12_1_UseAndInterpretationOfTheESG.odt

all: $(TARGETS)

Policies/%.odt: Policies/%.md Templates/reference.odt Templates/filter.lua
	cd Policies && ( $(PANDOC) $(PANDOC_OPTIONS) --output=$*.odt $*.md ; cd $(CURDIR) )

clean:
	cd Policies && rm -f RC_12_1_UseAndInterpretationOfTheESG.odt RC_12_1_UseAndInterpretationOfTheESG.pdf

