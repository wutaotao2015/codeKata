# the below command reture a future object
# futrueRes := URL with("http://www.baidu.com") @fetch
# below imitate the process
futureRes := method(
    wait(3)
    66
)

"waiting to get the result" println
"still waiting" println

writeln("finally got it, the answer is ", futureRes)
 
