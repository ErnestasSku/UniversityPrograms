package usecases;

import entities.Worker;
import persistence.WorkOrderDAO;
import persistence.WorkerDAO;

import javax.enterprise.context.Dependent;
import javax.enterprise.inject.Alternative;
import javax.inject.Inject;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Alternative
//@ApplicationScoped
@Dependent
public class ComplexJobAssign implements JobAssigner, Serializable {

    @Inject
    private WorkerDAO workerDAO;

    @Inject
    private WorkOrderDAO workOrderDAO;


    @Override
    public int assignJob(int workerId, List<Integer> orderList, List<Integer> workerOrders) {
        try {
            Thread.sleep(5000);
        } catch (Exception e) {}



        List<Integer> missingElements = orderList.stream()
                .filter(element -> !workerOrders.contains(element))
                .collect(Collectors.toList());

        Integer ans = missingElements.size() > 1 ? missingElements.get(0) : new Random().nextInt(orderList.size());

        return ans;
    }
}
