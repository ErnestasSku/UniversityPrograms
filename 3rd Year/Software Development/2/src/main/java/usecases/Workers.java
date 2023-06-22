package usecases;

import lombok.Getter;
import lombok.Setter;
import entities.Worker;
import persistence.WorkerDAO;

import javax.annotation.PostConstruct;
import javax.enterprise.inject.Model;
import javax.inject.Inject;
import javax.transaction.Transactional;
import java.util.List;

@Model
public class Workers {

    @Inject
    private WorkerDAO workerDAO;

    @Getter @Setter
    private Worker workerToCreate = new Worker();

    @Getter
    private List<Worker> allWorkers;

    @PostConstruct
    public void init(){
        loadAllWorkers();
    }

    @Transactional
    public void createWorker(){
        this.workerDAO.persist(workerToCreate);
    }

    private void loadAllWorkers(){
        this.allWorkers = workerDAO.loadAll();
    }
}
