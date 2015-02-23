## 2.5.0

* Removed unnecessary comments - c01daaf
* Code format - 9bec21a
* Add possible EOF at table body end - This will allow for capturing tables that are at end of file w/o trailing newline - 0288974
* Extra newline removed - a58db64
* Fix typo - b0a5323
* Add testcases for Chinese and Russian tables - 8f0a05e
* Use wcwidth - 4e258ce
* Small regex format update - 0d115b6
* Extend selections to whole tables - e960df1
* Only auto-select document if all ranges are empty - 4376aed
* Only extend ranges when not empty or not ASED (auto-select entire document - 1e1f7a0


## 2.4.2
* Update specs to check more cases
* Put all extra content into last cell
* Correct CJK character width counting


## 2.4.1

* Fix #11
* Settings are now handled via fields to facilitate easier testing
* Update specs


## 2.4.0

* Fixed stray `if` from #7

I'm very sorry for this bug. I didn't tested because today was my first day at work after my vacation. Things were a little crazy. I promisse I'll be more careful from now on.


## 2.3.0

* Merged changes from #7 and #8
* **Now the package is ready for Atom API 1.0**


## 2.2.0

* Merge branch 'lierdakil-newregex' lierdakil@08374da6c9ec2bb35d35bc666c0408929448fe37


## 2.1.1

* Fix for bug #3 "Insertion Point Lost On Save"


## 2.1.0

* Fix for keeping document auto selected


## 2.0.1

* Fix a regression where a table wouldn't be recognized


## 2.0.0

* Added option to choose if first and last pipes should be kept
* Added option to choose the padding of the cells
* Added support for latest config api
* Added specs to package
* Changed regex to identify pipeless tables
* Changed requirements to atom >= 0.135.0
* Removed deprecated APIs to observe text editors


## 1.0.2

* Sorry to anyone using my package, had some troubles with git and remote tags. Hope this fixes everything.


## 1.0.1

* Added option to restore selections (default: false)
* Fixed incorrect trimming of selected tables
* Auto-select entire document if selection is empty (default: true)
* Added a fix in the regex to consider spaces at the end of each line


## 0.1.2

* Bug fixes


## 0.1.1

* Bug fixes


## 0.1.0

* Every feature added
