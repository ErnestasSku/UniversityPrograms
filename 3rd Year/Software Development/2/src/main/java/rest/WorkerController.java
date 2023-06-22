package rest;

import entities.Equipment;
import entities.WorkOrder;
import entities.Worker;
import interceptors.LoggedInvocation;
import persistence.EquipmentDAO;
import persistence.WorkOrderDAO;
import persistence.WorkerDAO;
import rest.dto.WorkerDTO;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.OptimisticLockException;
import javax.sound.midi.SysexMessage;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@ApplicationScoped
@Path("/workers")
public class WorkerController {

    @Inject
    private WorkerDAO workerDAO;

    @Inject
    private EquipmentDAO equipmentDAO;

    @Inject
    private WorkOrderDAO workOrderDAO;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @LoggedInvocation
    public Response getAllWorkers() {
        List<Worker> workers = workerDAO.loadAll();

        List<WorkerDTO> workerDTOS = new ArrayList<WorkerDTO>();
        for (Worker worker : workers) {
            WorkerDTO newWorker = new WorkerDTO();
            newWorker.setName(worker.getName());
            newWorker.setEquipmentDTO(worker.getEquipmentAccess());
            newWorker.setWorkOrder(worker.getWorkOder());
            workerDTOS.add(newWorker);
        }

        return Response.ok(workerDTOS).build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response createWorker(WorkerDTO workerDTO) {

        Worker worker = new Worker();
        worker.setName(workerDTO.getName());
        if (workerDTO.getEquipmentDTO() != null ){
//            worker.setEquipmentAccess(workerDTO.getEquipmentDTO()
//                    .stream()
//                    .map(elem -> this.equipmentDAO.findOne(elem))
//                    .collect(Collectors.toList()));

            List<Equipment> eq = workerDTO.getEquipmentDTO().stream().map(x -> this.equipmentDAO.findOne(x)).collect(Collectors.toList());
            worker.setEquipmentAccess(eq);

        }
        if (workerDTO.getWorkOders() != null ) {
            worker.setWorkOder(this.workOrderDAO.loadAll().stream()
                    .filter(elem -> workerDTO.getWorkOders().contains(elem.getId()))
                    .collect(Collectors.toList()));
            List<WorkOrder> ords = worker.workOder.stream()
                    .map(x -> {x.setWorker(worker); this.workOrderDAO.update(x); return x;})
                    .collect(Collectors.toList());
        }
        worker.setVersion(0);
        workerDAO.persist(worker);
        return Response.ok().build();
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response updateWorker(@PathParam("id") Integer id, WorkerDTO updatedWorker) {
        try {

            Worker existingWorker = workerDAO.findOne(id);
            if (existingWorker == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            existingWorker.setName(updatedWorker.getName());

//            if (updatedWorker.getEquipmentDTO() != null) {
//                List<Equipment> updatedEquipment = updatedWorker.getEquipmentDTO().stream()
//                        .map(elem -> equipmentDAO.findOne(elem))
//                        .filter(Objects::nonNull)
//                        .collect(Collectors.toList());
//                existingWorker.setEquipmentAccess(updatedEquipment);
//            }
//
//            if (updatedWorker.getWorkOders() != null) {
//                List<WorkOrder> updatedWorkOrders = workOrderDAO.loadAll().stream()
//                        .filter(elem -> updatedWorker.getWorkOders().contains(elem.getId()))
//                        .collect(Collectors.toList());
//                existingWorker.setWorkOder(updatedWorkOrders);
//                for (WorkOrder order : updatedWorkOrders) {
//                    order.setWorker(existingWorker);
//                    try {
////                        workOrderDAO.update(order);
//                    } catch (Exception ex) {
//                        return Response.status(Response.Status.CONFLICT).build();
//                    }
//                }
//            }

            try {
            } catch (Exception ex) {
                return Response.status(Response.Status.CONFLICT).build();
            }

            try {
                Thread.sleep(2000);
                workerDAO.update(existingWorker);
                Thread.sleep(2000);
            } catch (Exception ex) {
                return Response.status(Response.Status.CONFLICT).build();
            }

            return Response.ok().build();
        } catch (OptimisticLockException ex) {
            return Response.status(Response.Status.CONFLICT).build();
        }
        catch (Exception ex) {
            return Response.status(Response.Status.GONE).build();
        }
    }

}
