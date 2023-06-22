package utilities;

import javax.interceptor.InvocationContext;

public interface BaseLogger {
    public String createLog(InvocationContext context);
    public void log(String log);
}
