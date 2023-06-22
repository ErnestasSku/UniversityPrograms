package usecases;

import entities.Worker;
import lombok.Getter;
import lombok.Setter;
import entities.WorkOrder;
import persistence.WorkOrderDAO;
import persistence.WorkerDAO;

import javax.annotation.PostConstruct;
import javax.enterprise.inject.Model;
import javax.inject.Inject;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Model
public class WorkerOrder {
    
    @Inject
    private WorkOrderDAO workOrderDAO;

    @Inject WorkerDAO workerDAO;

    @Getter @Setter
    private WorkOrder workOrderToCreate = new WorkOrder();

    @Getter @Setter
    private String workerToAssign;

    @Getter
    private List<WorkOrder> allWorkOrders;

    @Getter @Setter
    private OrderCreationTask createdOrder = new OrderCreationTask();

    @PostConstruct
    public void init(){
        loadAllWorkOrders();
    }

    @Transactional
    public void createWorkOrder(){

        try {
            Integer id = Integer.parseInt(workerToAssign);
            Worker worker = workerDAO.findOne(id);
            if (worker != null) {
                workOrderToCreate.setWorker(worker);
            }
        } catch (Exception e) {

        }

        this.workOrderDAO.persist(workOrderToCreate);
    }

    public void retrieveTask() {
        List<String> workTitles = Arrays.asList("Cleaning", "Cooking", "Customer service");
        List<String> workTypes = Arrays.asList("Easy", "Medium", "Difficult");
        Random random = new Random();
        this.createdOrder.workType = workTypes.get(random.nextInt(workTypes.size()));
        this.createdOrder.workTitle = workTitles.get(random.nextInt(workTitles.size()));
        this.createdOrder.success = true;
    }

    public class OrderCreationTask {
        @Getter @Setter
        private String workTitle;
        @Getter @Setter
        private String workType;

        @Getter @Setter
        private boolean success;

         OrderCreationTask() {
             workTitle = "";
             workType = "";
             success = true;
         }
    }

    private void loadAllWorkOrders(){
        this.allWorkOrders = workOrderDAO.loadAll();
    }
}
