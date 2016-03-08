# DHS_overview
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: overview.csv 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
include $(ms)/perl.def

##################################################################

# http://lalashan.mcmaster.ca/theobio/DHS/index.php/Main_Page

## Download overview pages

DATE = $(shell date +"%y%m%d")

date:
	@echo $(DATE)

## This is made manually to force a new download of available datasets
update:
	date >> overview.update

overview.update: 
	$(MAKE) update

overview.dmp: overview.update
	wget -O $@ "http://www.measuredhs.com/data/available-datasets.cfm"

## Archive downloaded overview files
Archive += $(wildcard archive/*)
Sources += $(wildcard *.pl)

archive/overview.%.csv: overview.dmp overview.pl
	$(PUSH)

overview.csv: archive/overview.$(DATE).csv
	$(copy)

######################################################################

Makefile: archive

archive:
	mkdir $@

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
