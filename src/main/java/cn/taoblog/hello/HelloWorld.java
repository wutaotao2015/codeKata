package cn.taoblog.hello;

import java.util.function.Function;
import java.util.function.IntBinaryOperator;
import java.util.function.IntFunction;
import java.util.function.Supplier;

/**
 * HelloWorld
 *
 * @author wutaotao
 * @version 2019/9/25 下午3:07
 */
public class HelloWorld {

    public static String say() {
       return "wtt";
    }

    public static void main(String[] args) {

        Function<Integer, Supplier<Integer>> curry = x -> () -> facTail(x, 1);
        Supplier<Integer> supplier = curry.apply(5);
        Integer result = supplier.get();

        System.out.println(result);
        System.out.println(facTail(5, 1));
        System.out.println(fac(5));
    }
    public static int facTail(int n, int total) {
        if (n == 1) return total;
        return facTail(n - 1, total * n);
     }
    public static int fac(int n) {
        if (n == 1) return 1;
        return n * fac(n - 1);
     }

}
