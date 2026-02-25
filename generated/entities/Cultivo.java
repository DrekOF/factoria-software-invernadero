package org.usco.invernadero.entity;

import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "cultivo")
public class Cultivo {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false)
    private String nombreComun;


    @Column(length = 150)
    private String nombreCientifico;


    @Column(nullable = false)
    private BigDecimal phOptimoMin;


    @Column(nullable = false)
    private BigDecimal phOptimoMax;


    @Column(nullable = false)
    private BigDecimal tempOptimaMin;


    @Column(nullable = false)
    private BigDecimal tempOptimaMax;


    @Column(nullable = false)
    private Integer diasCosecha;


    @OneToMany(mappedBy = "cultivo")
    private List<CicloCultivo> cicloCultivos;


    // Constructores
    public Cultivo() {
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


    public String getNombreComun() {
        return nombreComun;
    }

    public void setNombreComun(String nombreComun) {
        this.nombreComun = nombreComun;
    }


    public String getNombreCientifico() {
        return nombreCientifico;
    }

    public void setNombreCientifico(String nombreCientifico) {
        this.nombreCientifico = nombreCientifico;
    }


    public BigDecimal getPhOptimoMin() {
        return phOptimoMin;
    }

    public void setPhOptimoMin(BigDecimal phOptimoMin) {
        this.phOptimoMin = phOptimoMin;
    }


    public BigDecimal getPhOptimoMax() {
        return phOptimoMax;
    }

    public void setPhOptimoMax(BigDecimal phOptimoMax) {
        this.phOptimoMax = phOptimoMax;
    }


    public BigDecimal getTempOptimaMin() {
        return tempOptimaMin;
    }

    public void setTempOptimaMin(BigDecimal tempOptimaMin) {
        this.tempOptimaMin = tempOptimaMin;
    }


    public BigDecimal getTempOptimaMax() {
        return tempOptimaMax;
    }

    public void setTempOptimaMax(BigDecimal tempOptimaMax) {
        this.tempOptimaMax = tempOptimaMax;
    }


    public Integer getDiasCosecha() {
        return diasCosecha;
    }

    public void setDiasCosecha(Integer diasCosecha) {
        this.diasCosecha = diasCosecha;
    }


    public List<CicloCultivo> getCicloCultivos() {
        return cicloCultivos;
    }

    public void setCicloCultivos(List<CicloCultivo> cicloCultivos) {
        this.cicloCultivos = cicloCultivos;
    }

}