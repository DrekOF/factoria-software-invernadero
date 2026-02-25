package org.usco.invernadero.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "invernadero")
public class Invernadero {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false)
    private String nombre;


    @Column(length = 200, nullable = false)
    private String ubicacion;


    @Column()
    private BigDecimal latitud;


    @Column()
    private BigDecimal longitud;


    @Column(nullable = false)
    private BigDecimal areaM2;


    @Column(nullable = false)
    private LocalDate fechaInstalacion;


    @Column(length = 20, nullable = false)
    private String estado;


    @OneToMany(mappedBy = "invernadero")
    private List<CicloCultivo> cicloCultivos;


    @OneToMany(mappedBy = "invernadero")
    private List<Sensor> sensors;


    @OneToMany(mappedBy = "invernadero")
    private List<Alerta> alertas;


    // Constructores
    public Invernadero() {
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


    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }


    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }


    public BigDecimal getLatitud() {
        return latitud;
    }

    public void setLatitud(BigDecimal latitud) {
        this.latitud = latitud;
    }


    public BigDecimal getLongitud() {
        return longitud;
    }

    public void setLongitud(BigDecimal longitud) {
        this.longitud = longitud;
    }


    public BigDecimal getAreaM2() {
        return areaM2;
    }

    public void setAreaM2(BigDecimal areaM2) {
        this.areaM2 = areaM2;
    }


    public LocalDate getFechaInstalacion() {
        return fechaInstalacion;
    }

    public void setFechaInstalacion(LocalDate fechaInstalacion) {
        this.fechaInstalacion = fechaInstalacion;
    }


    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }


    public List<CicloCultivo> getCicloCultivos() {
        return cicloCultivos;
    }

    public void setCicloCultivos(List<CicloCultivo> cicloCultivos) {
        this.cicloCultivos = cicloCultivos;
    }


    public List<Sensor> getSensors() {
        return sensors;
    }

    public void setSensors(List<Sensor> sensors) {
        this.sensors = sensors;
    }


    public List<Alerta> getAlertas() {
        return alertas;
    }

    public void setAlertas(List<Alerta> alertas) {
        this.alertas = alertas;
    }

}