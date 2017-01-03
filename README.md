Get information about DHS data sets by scraping. Make makefiles and lists that are used elsewhere.

It would be great to keep the functionality of this repo but lose the scraping part.

This is all sort of in midstream, but seems to work with some of the other repos.

Install
-------

clone. Possibly make a local.mk (try linking simple.tmp). try making things.

Notes
-----

* What information is available from DHS? Where is it and what are the file names? This is an older, scraping-based approach. I am still in the middle of rescuing it from the wiki (and haven't quite decided yet whether it's worth the time).

This repo "rips" information from the DHS web site about the availability and DHS names of data sets?

* What information is available from DHS? Where is it and what are the file names? It would be nice to replace this with something less fragile.


* We can still download; it selects "standard" datasets and makes nice tables and Makefiles.

* We want to make chained rules to download things and convert them

* We also want more query stuff -- for example, we should be able to select world regions and data sets that have HIV biomarkers
