# hash-cracker

Simple script to get some hash cracking done effectively.

Some sites where you can find wordlists:

* <https://hashes.org/>
* <https://weakpass.com/>

Want to make the ***$HEX[1234]*** Hashcat output readable? Have a look at [hex-to-readable](https://github.com/crypt0rr/hex-to-readable).

## Version log

### v0.1 - Initial release

* Initial release

### v0.2 - Multiple changes

* New improved way of performing actions
* Requirements checker
* Iterations of results put into a separate function
* Added function for result processing / output
* Results to final.txt removed, must now use option to show results

### v0.3 - Added plain processing

* Added the ability to process a plain word/password list against input hashes
* Added tab completion for hashlist and wordlist selector

### v0.4 - Added Hybrid attack

* Added hybrid attack support
* Removed line for uniq hashes output because not showing correct numbers depending on input
* Reordered start menu

### v0.5 - Added Toggle-Case attack

* Adjusted default bitmap-max size to 24
* Added two bruteforce defaults
* Added the following rules (leetspeak, toggles1, toggles2)
* Added new rules to default processing job
* Added basic Toggle-Case attack

### v0.6 - Added Prefix and suffix

* Implemented prefix and suffix processing
* Reordered some functions

### v0.7 - Loop the loop

* Added '--loopback' to rule based cracking
* Extended brute force digits from 8 to 10

### v0.8 - Combinator

* Added combination attack support
* Reduced information directly in the menu moved to separate overview
* Added simple information about the options

### v0.9 - Light and heavy lifting

* Made light and heavy rules separate job
* Added fordyv1.rule

## License

MIT
