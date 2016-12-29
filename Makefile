# DHS_overview
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: overview.html 

##################################################################

# make files

Sources += Makefile .gitignore README.md stuff.mk LICENSE.md
Sources += $(wildcard *.tmp)
include stuff.mk
-include $(ms)/perl.def

##################################################################

# Other directories

Countries = $(gitroot)/Country_lists
pointers = $(Drop)/DHS_pointers

######################################################################

# http://lalashan.mcmaster.ca/theobio/DHS/index.php/Main_Page

## Download overview pages

DATE = $(shell date +"%y%m%d")
update_download overview.update:
	@echo $(DATE) > overview.update

## Touch or edit overview.update to download a new version of the available datasets page
overview.dmp: overview.update
	wget -O $@ "http://www.measuredhs.com/data/available-datasets.cfm"

Sources += $(wildcard *.pl)

overview.csv: overview.dmp overview.pl
	$(PUSH)

overview.html: overview.csv

######################################################################

### Finding the "standard" sets (the ones we mostly want, from around the world)

## Standard abbreviations
overview.short.csv: %.short.csv: %.csv $(Countries)/short.csv $(Countries)/abb.pl
	$(PUSH)

dhs.select.csv: overview.short.csv typeSelect.pl
	perl -wf typeSelect.pl "Standard DHS" < $< > $@
ais.select.csv: overview.short.csv typeSelect.pl
	perl -wf typeSelect.pl "Standard AIS" < $< > $@

standard.select.csv: dhs.select.csv ais.select.csv
	cat $^ > $@

## Make a file with unique tags that identify both "phase" and "manual".
## This is giving some strange warnings. Investigate.
standard.tagged.csv:
%.tagged.csv: %.select.csv tag.pl
	$(PUSH)

## Rules for making files with fancy names from DHS download files
standard.files.mk: standard.files.csv convertRules.pl
	$(PUSH)

######################################################################

## Finding the files

-include standard.inc.mk
 
standard.inc.mk: standard.select.csv pages.pl
	$(PUSH)

standard_pages: $(standard.select)
	cat /dev/null > $@

## Touch or edit cfm.update to invalidate the .cfm files (if they need to be downloaded again)
cfm.update:
	date > $@

$(pointers):
	mkdir $@

.PRECIOUS: $(pointers)/%.cfm
$(pointers)/%.cfm: cfm.update
	wget -O $@ "http://www.measuredhs.com/data/dataset/$*.cfm"
	sleep 1

%.cfm: $(pointers)/%.cfm
	$(forcelink)

## Go to the pages we've dumped, and find names of current datasets
standard.files.html:
standard.files.csv: standard.tagged.csv standard_pages files.pl
	$(PUSH)

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
