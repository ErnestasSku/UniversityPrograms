package utilities;

import javax.enterprise.inject.Decorated;
import javax.interceptor.InvocationContext;
import javax.enterprise.inject.Default;

@Default
public class Logger implements BaseLogger {
    @Override
    public String createLog(InvocationContext context) {
        return "Called method: " + context.getMethod().getName();
    }

    @Override
    public void log(String log) {
        System.out.println(log);
    }
}
