package persistence;

import entities.Equipment;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import java.util.List;

@ApplicationScoped
public class EquipmentDAO {

    @Inject
    private EntityManager em;

//    public List<Equipment> loadAll() {
//        return em.createNamedQuery("Equipment.findAll", Equipment.class).getResultList();
//    }

    public void setEm(EntityManager em) {
        this.em = em;
    }

    public void persist(Equipment equipment){
        this.em.persist(equipment);
    }


    public Equipment findOne(Integer id) {
        return em.find(Equipment.class, id);
    }

}
