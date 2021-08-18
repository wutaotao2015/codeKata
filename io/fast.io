
slow := Object clone
fast := Object clone

slow do := method(wait(2); "slow" println)
fast do := method(wait(1); "fast" println)

#slow do
#fast do

slow @@do
fast @@do
wait(3)


