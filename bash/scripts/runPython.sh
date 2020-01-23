#!/bin/bash
function run_python(){

    file_name=$(sed 's#./##' <<< $file_name)
    file_name=$(sed 's/.py//' <<< $file_name)
    file_name=$(sed 's#/#.#g' <<< $file_name)
    python -m $file_name
}
if [[ -t 0 ]];then
    if [[ $# == 1 ]]; then
        file_name=$1
        run_python
    else
        echo "there is $# matches to your file search"
        num=1
        for var in "$@"
        do
            echo "${num}) $var"
            num=$((num+1))
        done
        read -p "number:" file_numbe
        file_name=${!file_numbe}
        run_python
    fi
else
    read read_data
    echo $read_data
    file_name=$read_data
    run_python
fi
exit 0
