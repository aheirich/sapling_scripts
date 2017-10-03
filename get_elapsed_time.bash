#!/bin/bash
# Generates a CSV to make performance graphs for sc'17 viz paper
#

SKIP0=$1
SKIP1=$2

if [[ "${LG_RT_DIR}" == "" ]]
then
  echo Need to define LG_RT_DIR
  exit -1
fi

LEGION_PATH=${LG_RT_DIR}/..

if [[ "${SKIP1}" == "" ]]
then
  echo Need to define skip values, e.g. 2 0
  exit -1
fi

for type in soleil-m soleil-x
do
  FILE=`pwd`/${type}.csv
  rm -f ${FILE}
  for nodes in 4 8 16 32 64 128 256 512
  do
    pushd ${type}/Job_${nodes}
    TIME=`\
      cat soleil_prof_0 | grep -v "Prof Meta.*Info" | grep -v "Prof Message Info" | grep -v "Prof ProfTask" > soleil_prof_0.filtered
      ${LEGION_PATH}/tools/serializer_examples/span_example.py -t calculateConvectiveSpectralRadius Particles_DeleteEscapingParticles -a soleil_prof_0.filtered -s ${SKIP0} ${SKIP1} \
        | grep Range \
        | sed -e "s/Range.*was //" \
        | sed -e "s/(start:.*//" \
        | sed -e "s/us//" \
        `
    echo ${nodes}, ${TIME} >> ${FILE}
    popd
  done
done

