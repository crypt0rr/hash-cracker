#!/bin/bash
# Copyright crypt0rr
# Credits to @singe for digits rules and https://github.com/sensepost/common-substr
HASHCAT="/usr/local/bin/hashcat"
d3ad0ne="rules/d3ad0ne.rule"
d3adhob0="rules/d3adhob0.rule"
digits1="rules/digits1.rule"
digits2="rules/digits2.rule"
digits3="rules/digits3.rule"
dive="rules/dive.rule"
generated2="rules/generated2.rule"
hob064="rules/hob064.rule"
ORTRTA="rules/OneRuleToRuleThemAll.rule"
pantag="rules/pantagrule.popular.rule"
williamsuper="rules/williamsuper.rule"

function selector_hashtype () {
    read -p "Enter hashtype (number): " HASHTYPE
    if [ -z "${HASHTYPE##*[!0-9]*}" ]; then
        echo -e "\e[31mNot a valid hashtype number, try again (https://hashcat.net/wiki/doku.php?id=example_hashes)\e[0m"; selector_hashtype 
    else
        echo "Hashtype" $HASHTYPE "selected."
    fi
}

function selector_hashlist () {
    read -p "Enter full path to hashlist: " HASHLIST
    if [ -f "$HASHLIST" ]; then
        echo "Hashlist" $HASHLIST "selected."
    else
        echo -e "\e[31mFile does not exist, try again\e[0m"; selector_hashlist
    fi
}

function selector_wordlist () {
    read -p "Enter full path to wordlist: " WORDLIST
    if [ -f "$WORDLIST" ]; then
        echo "Wordlist" $WORDLIST "selected."
    else
        echo -e "\e[31mFile does not exist, try again\e[0m"; selector_wordlist
    fi
}

function default_processing () {
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $ORTRTA
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $d3ad0ne
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $d3adhob0
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $generated2
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $digits1
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $digits2
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $digits3
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $dive
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $hob064
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $pantag
    $HASHCAT -O -m$HASHTYPE $HASHLIST $WORDLIST -r $williamsuper
    read -p "How much iterations should be performed over the current results with all rules: " ITERATIONS
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $ORTRTA; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $d3ad0ne; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $d3adhob0; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $generated2; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $digits1; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $digits2; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $digits3; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $dive; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $hob064; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $pantag; done
    for i in {1..$ITERATIONS}; do $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort | uniq | tee tmp_pwonly &>/dev/null; $HASHCAT -O -m$HASHTYPE $HASHLIST tmp_pwonly -r $williamsuper; done

    rm tmp_output tmp_pwonly
    $HASHCAT -O -m$HASHTYPE $HASHLIST --show > final.txt
    echo -e "\nDefault processing done, results can be found in \e[32mfinal.txt\e[0m\n"; main
}

function bruteforce_processing () {
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?a'
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?a?a'
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?a?a?a'
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?a?a?a?a'
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?a?a?a?a?a' --increment
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?l?l?l?l?l?l?l?l' --increment
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?u?u?u?u?u?u?u?u' --increment
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?1?1?1?1?2?2?2?2' -1 '?l?u' -2 '?d' --increment
    $HASHCAT -O -m$HASHTYPE $HASHLIST -a3 '?1?1?1?1?2?2?2?2' -1 '?d' -2 '?l?u' --increment
    $HASHCAT -O -m$HASHTYPE $HASHLIST --show > final.txt
    echo -e "\Brute force processing done, results can be found in \e[32mfinal.txt\e[0m\n"; main
}

function substring_processing () {
    if [ -f "common-substr" ]; then
        if [ -f "final.txt" ]; then
            cat final.txt | cut -d ':' -f2 | sort | tee tmp_passwords &>/dev/null && ./common-substr -n -f tmp_passwords > tmp_allsubstrings && rm tmp_passwords
            $HASHCAT -O -m$HASHTYPE $HASHLIST -a1 tmp_allsubstrings tmp_allsubstrings
            $HASHCAT -O -m$HASHTYPE $HASHLIST --show > final.txt
            rm tmp_allsubstrings; echo -e "\nSubstring processing done, results can be found in \e[32mfinal.txt\e[0m\n"; main
        else
            echo -e "\e[31mFile 'final.txt' does not exist, please use option 1 first and try again\e[0m\n"; main
        fi
    else
        echo -e "\e[31mFile 'common-substr' does not exist, try again\n\e[0m"; main
    fi
}

function main () {
    echo "Hashprocessor v0.1 by crypt0rr"
    echo "0. Exit"
    echo "1. Default processing"
    echo "2. Default brute force"    
    echo "8. Common substring processing (requires step 1 or 2)"
    echo "9. Bypass; to use option 8 with own password list, final.txt required"
    read -p "Please enter number: " START
	if [[ $START = '0' ]]; then
		echo "Bye..."; exit 1
	elif [[ $START = '1' ]]; then
		selector_hashtype; selector_hashlist; selector_wordlist; default_processing
    elif [[ $START = '2' ]]; then
        selector_hashtype; selector_hashlist; bruteforce_processing
    elif [[ $START = '8' ]]; then
        substring_processing
    elif [[ $START = '9' ]]; then
        selector_hashtype; selector_hashlist; substring_processing
    else
		echo -e "\e[31mNot valid, try again\n\e[0m"; main
	fi
}

main