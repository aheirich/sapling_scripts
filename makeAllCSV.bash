#!/bin/bash

TARFILE="timing_csv.tar"
tar -cf ${TARFILE} makeCSV.bash

for N in 4 8 16 32 64 128 256 512 
do
  JOB=Job_${N}
  ./makeCSV.bash decode_ascii_profiles.log soleil-x ${JOB} ${TARFILE}
done

tar -tf ${TARFILE}

