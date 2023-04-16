package persistence;

import entities.WorkOrder;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import java.util.List;

@ApplicationScoped
public class WorkOrderDAO {

    @Inject
    private EntityManager em;

    public void setEm(EntityManager em) {
        this.em = em;
    }

    public List<WorkOrder> loadAll() {
        return em.createNamedQuery("WorkOrder.findAll", WorkOrder.class).getResultList();
    }

    public void persist(WorkOrder workOrder){
        this.em.persist(workOrder);
    }

    public WorkOrder findOne(Integer id) {
        return em.find(WorkOrder.class, id);
    }
    
}
