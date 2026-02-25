package org.usco.invernadero.entity;

$IMPORTS$

@Entity
@Table(name = "$TABLE_NAME$")
public class $CLASS_NAME$ {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
$ATRIBUTOS$
$RELACIONES$

    // Constructores
    public $CLASS_NAME$() {
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
$GETTERS_SETTERS$
}