package rest.dto;

import entities.Equipment;
import entities.WorkOrder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.stream.Collectors;

@Getter @Setter
public class WorkerDTO {
    private String name;
    private List<Integer> workOders;
    private List<Integer> equipmentDTO;

    public void setEquipment(List<Integer> equipment) {
        this.equipmentDTO = equipment;
    }

    public void setEquipmentDTO(List<Equipment> equipmentDTO) {
        List<Integer> eqIds = equipmentDTO.stream()
                .map(x -> x.getId())
                .collect(Collectors.toList());
        this.equipmentDTO = eqIds;
    }

//    public void setEquipment(List<Integer> equipment) {
//        this.equipment = equipment;
//    }

    public void setWorkOrder(List<WorkOrder> orders) {
        List<Integer> wIds = orders.stream()
                .map(x -> x.getId())
                .collect(Collectors.toList());
        this.workOders = wIds;
    }
}
