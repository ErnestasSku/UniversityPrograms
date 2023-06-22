package usecases;

import entities.Equipment;
import entities.WorkOrder;
import entities.Worker;
import lombok.Getter;
import lombok.Setter;
import persistence.EquipmentDAO;
import persistence.WorkOrderDAO;
import persistence.WorkerDAO;

import javax.annotation.Resource;
import javax.enterprise.context.SessionScoped;
import javax.inject.Inject;
import javax.inject.Named;
import javax.transaction.Transactional;
import javax.transaction.UserTransaction;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;


@Named
@SessionScoped
public class WorkerInfoCDI implements Serializable {

    @Inject
    private WorkerDAO workerDAO;

    @Inject
    private EquipmentDAO equipmentDAO;

    @Inject
    private WorkOrderDAO workOrderDAO;

    @Resource
    private UserTransaction userTransaction;

    @Getter
    private Worker worker;

    @Inject
    private JobAssigner jobAssigner;

    @Getter @Setter
    private String input;

    @Getter @Setter
    private String equipmentId;

    @Getter @Setter
    private String workId;

    @Getter @Setter
    private String generatedResult;


    private CompletableFuture<Integer> jobAssignerTask;

    public void getSpecificWorker() {
        try {
            Integer id = Integer.parseInt(input);
            worker = this.workerDAO.findOne(id);

        } catch (Exception ex) {
            System.out.println("Could not parse integer");
        }
    }


    @Transactional
    public void assignTools() {
        try {
            Integer toolId = Integer.parseInt(equipmentId);
            Integer id = Integer.parseInt(input);

            Equipment eq = this.equipmentDAO.findOne(toolId);
            worker = this.workerDAO.findOne(id);

            System.out.println("DBG: " + worker.EquipmentAccess.toString());
            System.out.println("DBG " + eq);
            if (eq != null) {
                worker.EquipmentAccess.add(eq);
                this.workerDAO.update(worker);
            }
        } catch (Exception ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }

    @Transactional
    public void assignOrders() {
        try {
            Integer orderId = Integer.parseInt(workId);
            Integer workerId = Integer.parseInt(input);


            WorkOrder workOrder = this.workOrderDAO.findOne(orderId);
            worker = this.workerDAO.findOne(workerId);
            workOrder.setWorker(worker);

            worker.workOder.add(workOrder);
            this.workerDAO.update(worker);
            this.workOrderDAO.update(workOrder);

        } catch (Exception ex) {
            System.out.println("Error: " + ex.getMessage());
        }

    }

    public String generateTask() {
        try {
            System.out.println("Generate ");

            Integer workerId = Integer.parseInt(input);

            Worker worker = workerDAO.findOne(workerId);
            List<Integer> nums = new ArrayList<Integer>();
            nums.addAll(worker.workOder.stream().map(x -> x.getId()).collect(Collectors.toList()));

            List<Integer> workOrderIds = workOrderDAO.loadAll().stream().map(x -> x.getId()).collect(Collectors.toList());

            jobAssignerTask = CompletableFuture.supplyAsync(() -> jobAssigner.assignJob(workerId, workOrderIds, nums)).thenApply(result ->
            {
                this.workId = String.valueOf(result);
                return result;
            });


        } catch (Exception ex) {}
        return "/allWorkers.xhtml?faces-redirect=true";
    }

    public void jobAssignerTaskStatus() {
        if (jobAssignerTask == null) {
            return;
        } else if (isJobAssignerTaskRunning()) {
            return;
        }
        return;
    }

    private boolean isJobAssignerTaskRunning() {
        return jobAssignerTask != null && !jobAssignerTask.isDone();
    }

    public String getJobAssignerTask() throws ExecutionException, InterruptedException {
        if (jobAssignerTask == null) {
            return "`";
        } else if (isJobAssignerTaskRunning()) {
            return "Calculating";
        }

        return "Suggested task: " + String.valueOf(jobAssignerTask.get());
    }
}
