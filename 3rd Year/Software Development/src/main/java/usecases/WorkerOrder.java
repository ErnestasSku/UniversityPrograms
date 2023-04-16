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
import java.util.List;

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

    private void loadAllWorkOrders(){
        this.allWorkOrders = workOrderDAO.loadAll();
    }
}
