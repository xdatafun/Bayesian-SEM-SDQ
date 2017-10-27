grep -A 25 "F1       BY" wave*_5f-step3.out | grep "*" > F1sig.txt
grep -A 25 "F2       BY" wave*_5f-step3.out | grep "*" > F2sig.txt
grep -A 25 "F3       BY" wave*_5f-step3.out | grep "*" > F3sig.txt
grep -A 25 "F4       BY" wave*_5f-step3.out | grep "*" > F4sig.txt
grep -A 25 "F5       BY" wave*_5f-step3.out | grep "*" > F5sig.txt

grep -A 1 "F2       WITH" wave*_5f-step3.out | grep "*" > f2with.txt
grep -A 2 "F3       WITH" wave*_5f-step3.out | grep "*" > f3with.txt
grep -A 3 "F4       WITH" wave*_5f-step3.out | grep "*" > f4with.txt
grep -A 4 "F5       WITH" wave*_5f-step3.out | grep "*" > f5with.txt