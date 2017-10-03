#!/bin/bash

FILE=$1
MODEL=$2
JOB=$3
TARFILE=$4

if [[ "${TARFILE}" == "" ]]
then
  echo specify file model soleil-x or soleil-m and job e.g. Job_4  tarfile
  exit -1
fi

echo makeCSV for ${FILE} ${MODEL} ${JOB}

DIR=${MODEL}/${JOB}
pushd ${DIR}

RENDERLINE=`grep -n "Task Render" ${FILE} | sed -e "s/:.*//"`
REDUCELINE=`grep -n "Task Reduce" ${FILE} | sed -e "s/:.*//"`
LASTLINE=`wc -l ${FILE} | sed -e "s/${FILE}//"`

if (( ${RENDERLINE} >  ${REDUCELINE} ))
then
  echo REDUCE ${REDUCELINE} RENDER ${RENDERLINE} LAST ${LASTLINE}
  NUMREDUCE=$(( ${RENDERLINE} - ${REDUCELINE} - 1 ))
  NUMRENDER=$(( ${LASTLINE} - ${RENDERLINE} ))
else
  echo RENDER ${RENDERLINE} REDUCE ${REDUCELINE} LAST ${LASTLINE}
  NUMRENDER=$(( ${REDUCELINE} - ${RENDERLINE} - 1 ))
  NUMREDUCE=$(( ${LASTLINE} - ${REDUCELINE} ))
fi

RENDERCSV="render.csv"
REDUCECSV="reduce.csv"

tail -n +$((${RENDERLINE}+1)) ${FILE} >rencsv
tail -n +$((${REDUCELINE}+1)) ${FILE} >redcsv

tail -n +$((${RENDERLINE}+1)) ${FILE} | head -${NUMRENDER} | sed -e "s/[():]/,/g" | sed -e "s/us/ /g" | sort --key=3 -n > ${RENDERCSV}
tail -n +$((${REDUCELINE}+1)) ${FILE} | head -${NUMREDUCE} | sed -e "s/[():]/,/g" | sed -e "s/us/ /g" | sort --key=3 -n > ${REDUCECSV}

wc -l ${RENDERCSV} ${REDUCECSV}

popd

tar -r -f ${TARFILE} ${DIR}/${RENDERCSV} ${DIR}/${REDUCECSV}
ls -l ${TARFILE}

