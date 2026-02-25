package org.usco.invernadero.entity;

import java.time.LocalDate;
import javax.persistence.*;

@Entity
@Table(name = "ciclo_cultivo")
public class CicloCultivo {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate fechaSiembra;


    @Column(nullable = false)
    private LocalDate fechaCosechaEstimada;


    @Column()
    private LocalDate fechaCosechaReal;


    @Column(nullable = false)
    private Integer cantidadPlantas;


    @Column(length = 20, nullable = false)
    private String estado;


    @ManyToOne
    @JoinColumn(name = "invernadero_id", nullable = true)
    private Invernadero invernadero;


    @ManyToOne
    @JoinColumn(name = "cultivo_id", nullable = true)
    private Cultivo cultivo;


    // Constructores
    public CicloCultivo() {
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public LocalDate getFechaSiembra() {
        return fechaSiembra;
    }

    public void setFechaSiembra(LocalDate fechaSiembra) {
        this.fechaSiembra = fechaSiembra;
    }


    public LocalDate getFechaCosechaEstimada() {
        return fechaCosechaEstimada;
    }

    public void setFechaCosechaEstimada(LocalDate fechaCosechaEstimada) {
        this.fechaCosechaEstimada = fechaCosechaEstimada;
    }


    public LocalDate getFechaCosechaReal() {
        return fechaCosechaReal;
    }

    public void setFechaCosechaReal(LocalDate fechaCosechaReal) {
        this.fechaCosechaReal = fechaCosechaReal;
    }


    public Integer getCantidadPlantas() {
        return cantidadPlantas;
    }

    public void setCantidadPlantas(Integer cantidadPlantas) {
        this.cantidadPlantas = cantidadPlantas;
    }


    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }


    public Invernadero getInvernadero() {
        return invernadero;
    }

    public void setInvernadero(Invernadero invernadero) {
        this.invernadero = invernadero;
    }


    public Cultivo getCultivo() {
        return cultivo;
    }

    public void setCultivo(Cultivo cultivo) {
        this.cultivo = cultivo;
    }

}