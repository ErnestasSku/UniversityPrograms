package entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;


@Entity
@Getter @Setter
public class Equipment {
    public Equipment() {

    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String equipmentName;

    @ManyToMany
    private List<Worker> Workers;

}

// @Entity
// public class Equipment implements Serializable {
//    @Id
//    private Long id;

//    public void setId(Long id) {
//        this.id = id;
//    }

//    public Long getId() {
//        return id;
//    }

//    @Basic
//    private String equipmentName;


//    @ManyToMany
//    private List<Worker> Workers;

// }
