package org.usco.invernadero.entity;

import java.time.LocalDate;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "sensor")
public class Sensor {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50, nullable = false)
    private String tipoSensor;


    @Column(length = 50)
    private String marca;


    @Column(length = 50)
    private String modelo;


    @Column(length = 100)
    private String ubicacionSensor;


    @Column(nullable = false)
    private LocalDate fechaInstalacion;


    @Column(length = 20, nullable = false)
    private String estado;


    @ManyToOne
    @JoinColumn(name = "invernadero_id", nullable = true)
    private Invernadero invernadero;


    @OneToMany(mappedBy = "sensor")
    private List<LecturaSensor> lecturaSensors;


    // Constructores
    public Sensor() {
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


    public String getTipoSensor() {
        return tipoSensor;
    }

    public void setTipoSensor(String tipoSensor) {
        this.tipoSensor = tipoSensor;
    }


    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }


    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }


    public String getUbicacionSensor() {
        return ubicacionSensor;
    }

    public void setUbicacionSensor(String ubicacionSensor) {
        this.ubicacionSensor = ubicacionSensor;
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


    public Invernadero getInvernadero() {
        return invernadero;
    }

    public void setInvernadero(Invernadero invernadero) {
        this.invernadero = invernadero;
    }


    public List<LecturaSensor> getLecturaSensors() {
        return lecturaSensors;
    }

    public void setLecturaSensors(List<LecturaSensor> lecturaSensors) {
        this.lecturaSensors = lecturaSensors;
    }

}