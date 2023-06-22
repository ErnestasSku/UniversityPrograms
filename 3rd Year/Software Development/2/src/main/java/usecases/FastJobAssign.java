package usecases;

import interceptors.LoggedInvocation;
import persistence.WorkOrderDAO;
import persistence.WorkerDAO;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Alternative;
import javax.enterprise.inject.Default;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import java.io.Serializable;
import java.util.List;
import java.util.Random;

@ApplicationScoped
@Alternative @Default
public class FastJobAssign implements JobAssigner, Serializable {

    @Inject
    private WorkerDAO workerDAO;

    @Inject
    private WorkOrderDAO workOrderDAO;

    @Inject
    EntityManager em;

    @Override
    @LoggedInvocation
    public int assignJob(int workerId, List<Integer> orderList, List<Integer> workerOrders) {

        return new Random().nextInt(orderList.size());
    }
}
