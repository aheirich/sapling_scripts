#!/bin/bash

if [[ "${LEGION_PATH}" == "" ]]
then
  echo set LEGION_PATH first
  exit -1
fi

echo filtering soleil_prof_0

cat soleil_prof_0 | grep -v "Prof Meta.*Info" | grep -v "Prof Message Info" | grep -v "Prof ProfTask" > soleil_prof_0.filtered

echo getting execution span

${LEGION_PATH}/tools/serializer_examples/span_example.py -t calculateConvectiveSpectralRadius Particles_DeleteEscapingParticles -a soleil_prof_0.filtered

echo find render tasks

pypy ${LEGION_PATH}/tools/serializer_examples/find_tasks.py -t "(Render|Reduce|Render)" -a soleil_prof_0.filtered

