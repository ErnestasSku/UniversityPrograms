package entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Entity
@NamedQueries({
    @NamedQuery(name = "WorkOrder.findAll", query = "select t from WorkOrder as t")
})
@Getter @Setter
public class WorkOrder {
    public WorkOrder() {

    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String title;

    private String type;

    @ManyToOne
    @JoinColumn(name = "worker_id")
    private Worker worker;
}

