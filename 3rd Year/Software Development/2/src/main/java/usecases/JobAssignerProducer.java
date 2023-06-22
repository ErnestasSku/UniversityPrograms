package usecases;

import usecases.JobAssigner;
import javax.enterprise.inject.Produces;
import javax.enterprise.inject.spi.CDI;

public class JobAssignerProducer {

    @Produces
    public JobAssigner createJobAssigner() {
        CDI<Object> cdi = CDI.current();
        JobAssigner jobAssigner = cdi.select(JobAssigner.class).get();
        return jobAssigner;
    }
}
