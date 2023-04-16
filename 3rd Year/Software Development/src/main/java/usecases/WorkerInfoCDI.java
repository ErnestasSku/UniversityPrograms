package usecases;

import entities.Equipment;
import entities.Worker;
import lombok.Getter;
import lombok.Setter;
import persistence.EquipmentDAO;
import persistence.WorkerDAO;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.inject.Named;
import javax.transaction.Transactional;
import java.util.Date;

@Named
@RequestScoped
public class WorkerInfoCDI {

    @Inject
    private WorkerDAO workerDAO;

    @Inject
    private EquipmentDAO equipmentDAO;

    @Getter
    private Worker worker;

    @Getter @Setter
    private String input;

    @Getter @Setter
    private String equipmentId;

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
            Equipment eq = this.equipmentDAO.findOne(toolId);
            Integer id = Integer.parseInt(input);
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
    public void assignOrders(Integer orderId) {

    }

}
