#!/bin/bash

TRACE_FILES=("Trace1.din" "Trace2.din" "Trace3.din")
CACHE_BLOCK_SIZES=("32" "32" "32" "64" "64" "64")
CACHE_ASSOCIATIVITIES=("1" "2" "4")

for j in {0..2}; do
  CURRENT_TRACE=${TRACE_FILES[j]}
  
  for i in {0..5}; do
    L1_CACHE_SIZE="16K"
    L1_BLOCK_SIZE=${CACHE_BLOCK_SIZES[i]}
    L1_ASSOC=${CACHE_ASSOCIATIVITIES[i % 3]}

    echo "Simulating with $CURRENT_TRACE: L1 size=$L1_CACHE_SIZE, block size=$L1_BLOCK_SIZE, associativity=$L1_ASSOC"
    ~/dineroIV \
      -l1-isize $L1_CACHE_SIZE \
      -l1-iassoc $L1_ASSOC \
      -l1-ibsize $L1_BLOCK_SIZE \
      -l1-dsize $L1_CACHE_SIZE \
      -l1-dassoc $L1_ASSOC \
      -l1-dbsize $L1_BLOCK_SIZE \
      -informat d < ./$CURRENT_TRACE > "./output/${CURRENT_TRACE}_${L1_CACHE_SIZE}_${L1_ASSOC}_${L1_BLOCK_SIZE}.txt"

    L2_CACHE_SIZE="128K"
    L2_BLOCK_SIZE=$L1_BLOCK_SIZE
    L2_ASSOC=$L1_ASSOC

    echo "Simulating with $CURRENT_TRACE: L1 size=$L1_CACHE_SIZE, L2 size=$L2_CACHE_SIZE, block size=$L2_BLOCK_SIZE, associativity=$L2_ASSOC"
    ~/dineroIV \
      -l1-isize $L1_CACHE_SIZE \
      -l1-iassoc $L1_ASSOC \
      -l1-ibsize $L1_BLOCK_SIZE \
      -l1-dsize $L1_CACHE_SIZE \
      -l1-dassoc $L1_ASSOC \
      -l1-dbsize $L1_BLOCK_SIZE \
      -l2-usize $L2_CACHE_SIZE \
      -l2-uassoc $L2_ASSOC \
      -l2-ubsize $L2_BLOCK_SIZE \
      -informat d < ./$CURRENT_TRACE > "./output/${CURRENT_TRACE}_${L1_CACHE_SIZE}_${L1_ASSOC}_${L1_BLOCK_SIZE}_${L2_CACHE_SIZE}_${L2_ASSOC}_${L2_BLOCK_SIZE}.txt"
  done
done
