package cn.taoblog.hello;

import org.junit.Test;

import static org.junit.Assert.*;

public class HelloWorldTest {

    @Test
    public void testSay() {
        System.out.println("####");
        System.out.println(HelloWorld.say());
        System.out.println("from ivim haha copy success");
        System.out.println("####");
        assertEquals(HelloWorld.say(), "wtt");
    }
}
