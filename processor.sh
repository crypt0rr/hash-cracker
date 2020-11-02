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
leetspeak="rules/leetspeak.rule"
ORTRTA="rules/OneRuleToRuleThemAll.rule"
pantag="rules/pantagrule.popular.rule"
williamsuper="rules/williamsuper.rule"
toggles1="rules/toggles1.rule"
toggles2="rules/toggles2.rule"
RULELIST=($ORTRTA $d3ad0ne $d3adhob0 $generated2 $digits1 $digits2 $digits3 $dive $hob064 $leetspeak $pantag $williamsuper $toggles1 $toggles2)
SMALLRULELIST=($digits1 $digits2 $hob064 $leetspeak)

function requirement_checker () {
    if ! [ -x "$(command -v $HASHCAT)" ]; then
        echo -e '\e[31m[-]' Hashcat  'is not installed or not in path (/usr/local/bin/hashcat)\e[0m'; ((COUNTER=COUNTER + 1))
    else
        echo -e '\e[32m[+]' Hashcat 'is installed\e[0m'
    fi
    if [[ -x "common-substr" ]]; then
        echo -e '\e[32m[+]' 'common-substr is executable\e[0m'
    else
        echo -e '\e[31m[-]' 'common-substr is not executable or found\e[0m'; ((COUNTER=COUNTER + 1))
    fi
    if [ "$COUNTER" \> 0 ]; then
        echo -e "\n\e[31mNot all requirements met please fix and try again"; exit 1
    fi
}

function selector_hashtype () {
    read -p "Enter hashtype (number): " HASHTYPE
    if [ -z "${HASHTYPE##*[!0-9]*}" ]; then
        echo -e "\e[31mNot a valid hashtype number, try again (https://hashcat.net/wiki/doku.php?id=example_hashes)\e[0m"; selector_hashtype 
    else
        echo "Hashtype" $HASHTYPE "selected."
    fi
}

function selector_hashlist () {
    read -e -p "Enter full path to hashlist: " HASHLIST
    if [ -f "$HASHLIST" ]; then
        echo "Hashlist" $HASHLIST "selected."
    else
        echo -e "\e[31mFile does not exist, try again\e[0m"; selector_hashlist
    fi
}

function selector_wordlist () {
    read -e -p "Enter full path to wordlist: " WORDLIST
    if [ -f "$WORDLIST" ]; then
        echo "Wordlist" $WORDLIST "selected."
    else
        echo -e "\e[31mFile does not exist, try again\e[0m"; selector_wordlist
    fi
}

function default_processing () {
    $HASHCAT -O  --bitmap-max=24 -m$HASHTYPE $HASHLIST $WORDLIST
    for RULE in ${RULELIST[*]}; do
        $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST $WORDLIST -r $RULE
    done
    echo -e "\n\e[32mDefault processing done\e[0m\n"; main
}

function bruteforce_processing () {
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?a?a?a?a?a' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?l?l?l?l?l?l?l?l' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?u?u?u?u?u?u?u?u' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?d?d?d?d?d?d?d?d' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?1?1?1?1?1?1?1' -1 '?l?d?u' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?1?1?1?1?2?2?2?2' -1 '?l?u' -2 '?d' --increment
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a3 '?1?1?1?1?2?2?2?2' -1 '?d' -2 '?l?u' --increment
    echo -e "\n\e[32mBrute force processing done\e[0m\n"; main
}

function iterate_processing () {
    for RULE in ${RULELIST[*]}; do
        $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_output && cat tmp_output | cut -d ':' -f2 | sort -u | tee tmp_pwonly &>/dev/null; rm tmp_output
        $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST tmp_pwonly -r $RULE
    done
    rm tmp_pwonly
    echo -e "\n\e[32mIteration processing done\e[0m\n"; main
}

function results_processing () {
    echo "Total uniq hashes cracked:" $($HASHCAT -O -m$HASHTYPE $HASHLIST --show | tee results_cracked.txt | wc -l)
    echo "Total uniq hashes that are left:" $($HASHCAT -O -m$HASHTYPE $HASHLIST --left | tee results_lefts.txt | wc -l)
    cat results_cracked.txt | cut -d ':' -f2 | sort | tee results_clears.txt &>/dev/null
    echo -e "\nResult processing done, results can be found in \e[32mresults_cracked.txt, results_lefts.txt and results_clears.txt\e[0m\n"; main
}

function substring_processing () {
    $HASHCAT -O -m$HASHTYPE $HASHLIST --show > tmp_substring
    cat tmp_substring | cut -d ':' -f2 | sort | tee tmp_passwords &>/dev/null && ./common-substr -n -f tmp_passwords > tmp_allsubstrings && rm tmp_passwords tmp_substring
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a1 tmp_allsubstrings tmp_allsubstrings
    rm tmp_allsubstrings; echo -e "\n\e[32mSubstring processing done\e[0m\n"; main
}

function plain_processing () {
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST $WORDLIST
    echo -e "\n\e[32mPlain processing done\e[0m\n"; main
}

function hybrid_processing () {
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a6 $WORDLIST -j c '?s?d?d?d?d' -i
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a6 $WORDLIST -j c '?d?d?d?d?s' -i
    $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST -a6 $WORDLIST -j c '?a?a' -i
    echo -e "\n\e[32mHybrid processing done\e[0m\n"; main
}

function toggle_processing () {
    for RULE in ${SMALLRULELIST[*]}; do
        $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST $WORDLIST -r $toggles1 -r $RULE
        $HASHCAT -O --bitmap-max=24 -m$HASHTYPE $HASHLIST $WORDLIST -r $toggles2 -r $RULE
    done
    echo -e "\n\e[32mToggle processing done\e[0m\n"; main
}

function main () {
    echo -e "Hash-cracker v0.5 by crypt0rr\n"
    echo "Checking if requirements are met:"
    requirement_checker
    
    echo -e "\n0. Exit"
    echo "1. Default processing"
    echo "2. Default brute force"
    echo "3. Iterate gathered results again"
    echo "4. Just plain word/password list against hashes"
    echo "5. Hybrid processing"
    echo "6. Toggle-case processing"
    echo "8. Common substring processing (advise: first run steps above)"
    echo "9. Show results in usable format"
    read -p "Please enter number: " START
    if [[ $START = '0' ]]; then
        echo "Bye..."; exit 1
    elif [[ $START = '1' ]]; then
        selector_hashtype; selector_hashlist; selector_wordlist; default_processing
    elif [[ $START = '2' ]]; then
        selector_hashtype; selector_hashlist; bruteforce_processing
    elif [[ $START = '3' ]]; then
        selector_hashtype; selector_hashlist; iterate_processing
    elif [[ $START = '4' ]]; then
        selector_hashtype; selector_hashlist; selector_wordlist; plain_processing
    elif [[ $START = '5' ]]; then
        selector_hashtype; selector_hashlist; selector_wordlist; hybrid_processing
    elif [[ $START = '6' ]]; then
        selector_hashtype; selector_hashlist; selector_wordlist; toggle_processing
    elif [[ $START = '8' ]]; then
        selector_hashtype; selector_hashlist; substring_processing
    elif [[ $START = '9' ]]; then
        selector_hashtype; selector_hashlist; results_processing
    else
        echo -e "\e[31mNot valid, try again\n\e[0m"; main
    fi
}

main