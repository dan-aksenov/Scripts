sqlplus dbax/dbax@IOTA1 @compression_test %1 %2 %3
findstr "Testing Elapsed Select Insert Delete Update Size" log\%1_%2_%3.log > log\%1_%2_%3.fin