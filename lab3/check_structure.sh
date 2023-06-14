#! /usr/bin/env bash

if [[ $# -lt 1 ]]; then
    exit 1
fi

file=$1

urls=`mktemp`
tmp3=`mktemp`
while IFS=  read -r line; do

    line=${line::-1}

    declare -A map

    test(){

        local hrefs_file=`mktemp`
        local res_file=`mktemp`

        local url=$1
        res=`curl -L $url 2>/dev/null`

        header=`curl -sIL -w "%{url_effective} %{http_code}" $url -o /dev/null`
        url=`cut -d ' ' -f 1 <<< $header | sed 's!http://!!' | sed 's.https://..'`
        base=`sed 's:[^/]*$::' <<< $url`

        # echo url=$url
        if [[ -n ${map[$url]} ]]; then
            exit 0
        fi
    
        echo $url >> $urls

        status=`cut -d " " -f 2 <<< $header`
        if [[ $status != 200 ]]; then
            exit -1
        fi

        echo `curl -sIL -w "%{url_effective} %{http_code}" $url -o /dev/null` \
            | sed 's\http://\\' \
            | sed 's\https://\\' >> $res_file


        for link in "`echo $res | grep -o "<a[^>]*>"`"; do

            rel=`echo "$link" | grep -Po 'rel=\K"[^"]*"' | tr -d '"'`
            if [[ "$rel" == nofollow ]]; then
                continue
            fi

            href=`echo "$link" | grep -Po 'href=\K"[^"]*"' | tr -d '"'`
            echo "$href" > $hrefs_file
        done


        while read -r href; do
            if [[ -z `echo $href | grep '^http://'` ]]; then
                if [[ -z `echo $href | grep '^https://'` ]]; then
                    href="http://$base/$href"
                fi
            fi

            echo `curl -sIL -w "%{url_effective} %{http_code}" $href -o /dev/null` \
                | sed 's\http://\\' \
                | sed 's\https://\\' >> $res_file
        done < $hrefs_file
    
        result=`mktemp`
        while read -r line; do
            status=`echo "$line" |  cut -d ' ' -f 2`
            if [[ "$status" == 200 ]]; then
                cur_url=`cut -d ' ' -f 1 <<< $line`
                if [[ -z `grep $cur_url $urls` ]]; then
                    echo $cur_url >> $urls;
                    map[$url]+=" $cur_url"
                    test $cur_url
                fi
            fi
        done < $res_file 
    }

    test "$line"
done < $file

sorted=`mktemp`
sort "$urls" | awk '!seen[$0]++' > $sorted

cat $sorted
echo ======

# declare -A order
declare -A arr
l=0
while read -r line; do
    l=$(( $l+1 ))
    # order[$line]=$l
    arr[$l]=$line
done < $sorted

for i in $( seq 1 $l ); do
    for j in $( seq 1 $l ); do
        url_i=${arr[$i]}
        url_j=${arr[$j]}
        if [[ -n `grep $url_j <<< ${map[$url_i]}` ]]; then
            printf "1 "
        else
            printf "0 "
        fi
    done
    echo 
done
