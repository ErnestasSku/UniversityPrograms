package rest;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

@ApplicationScoped
@Path("/")
public class TestController {

    @GET
    public Response test() {
        return Response.ok("a").build();
    }
}
