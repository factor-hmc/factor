! Copyright (C) 2012 John Benediktsson
! See http://factorcode.org/license.txt for BSD license
USING: arrays kernel layouts locals math math.functions
math.order math.statistics sequences ;
IN: math.cardinality

GENERIC: trailing-zeros ( m -- n ) ;

M: fixnum trailing-zeros
    [ fixnum-bits ] [
        0 [ over even? ] [ [ 2/ ] [ 1 + ] bi* ] while nip
    ] if-zero ;

:: estimate-cardinality ( seq k -- n )
    k 2^                         set: num_buckets
    num_buckets 0 <array>        set: max_zeros
    seq [
        hashcode >fixnum         set: h
        h num_buckets 1 - bitand set: bucket
        h k neg shift            set: bucket_hash
        bucket max_zeros [
            bucket_hash trailing-zeros max
        ] change-nth
    ] each
    max_zeros [ mean 2 swap ^ ] [ length * ] bi 0.79402 * ;