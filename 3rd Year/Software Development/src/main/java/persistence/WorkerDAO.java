package persistence;

import entities.Worker;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import java.util.List;

@ApplicationScoped
public class WorkerDAO {

    @Inject
    private EntityManager em;

    public List<Worker> loadAll() {
        return em.createNamedQuery("Worker.findAll", Worker.class).getResultList();
    }

    public void setEm(EntityManager em) {
        this.em = em;
    }

    public void persist(Worker worker){
        this.em.persist(worker);
    }

    public void update(Worker worker) {
        this.em.merge(worker);
    }

    public Worker findOne(Integer id) {
        return em.find(Worker.class, id);
    }
}
