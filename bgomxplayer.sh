#!/bin/sh
#-------------------------------------------------------------------------------
# Меняет ссылку на playlist
#-------------------------------------------------------------------------------
chbg ()
{   dt=$(date '+%H%M')
    tm=$(cat ~/log/tm)
    if [ "$dt" -ge "$tm" ] ; then
            if [ -f ~/log/date ] ; then
                    oldate=$(cat ~/log/date)
                    newdate=$(date '+%D')
                    echo $newdate > ~/log/date
                    if [ "$oldate" != "$newdate" ] ; then
                            allbg=$(ls -l ~/upload | grep BGVIDEO | wc -l)
                            nowbg=$(ls -l ~/LBG | awk '{print $11}' | awk -F "." '{print $1}' | tail -c 2 | head -c 1)
                            while $true ; do
                                    if [ "$allbg" -gt "$nowbg" ] ; then
                                            nowbg=$(($nowbg+1))
                                            if [ -f ~/pls/pls"$nowbg".pls ] ; then
                                                    unlink ~/LBG
                                                    ln -s ~/pls/pls"$nowbg".pls ~/LBG
                                                    rm ~/log/numbertrack
                                                    break 2
                                            fi
                                    else
                                            nowbg=1
                                            if [ -f ~/pls/pls"$nowbg".pls ] ; then
                                                    unlink ~/LBG
                                                    ln -s ~/pls/pls"$nowbg".pls ~/LBG
                                                    break 2
                                            fi
                                    fi
                            done
                    fi
            else
                    echo $(date '+%D') > ~/log/date
            fi
    fi
}   # ----------  end of function chbg  --------

while true  ; do
    i=0
    if [ -f ~/log/numbertrack ] ; then
            numbertrack=$(cat ~/log/numbertrack)
    else
            echo 1 > ~/log/numbertrack
            numbertrack=$(cat ~/log/numbertrack)
    fi
    for track  in $(cat ~/LBG) ; do
            i=$(($i+1))
            chbg
            if [ "$numbertrack" -gt "$i" ] ; then
                    continue
            fi
            omxplayer --win `cat ~/xywh.txt` -o local -b $track
            echo $i >  ~/log/numbertrack
            if [ -f ~/mp/lnmp.sh ] ; then
                    ./mp/lnmp.sh 2 > /dev/null
            fi
    done
    rm ~/log/numbertrack
done
