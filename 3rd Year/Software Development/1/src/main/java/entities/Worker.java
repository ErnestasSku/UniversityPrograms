package entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Entity
@NamedQueries({
        @NamedQuery(name = "Worker.findAll", query = "select t from Worker as t")
})
@Getter @Setter
public class Worker {

    public Worker(){

    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    @ManyToMany
    @Column(nullable = true)
    public List<Equipment> EquipmentAccess;

    @OneToMany(mappedBy = "worker")
    @Column(nullable = true)
    public List<WorkOrder> workOder;


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Worker worker = (Worker) o;
        return Objects.equals(name, worker.name);
    }

    @Override
    public int hashCode() {

        return Objects.hash(name);
    }
}
