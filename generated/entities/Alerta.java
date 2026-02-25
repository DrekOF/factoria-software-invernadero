package org.usco.invernadero.entity;

import java.time.LocalDateTime;
import javax.persistence.*;

@Entity
@Table(name = "alerta")
public class Alerta {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50, nullable = false)
    private String tipoAlerta;


    @Column(length = 20, nullable = false)
    private String nivelSeveridad;


    @Column(nullable = false, columnDefinition = "TEXT")
    private String descripcion;


    @Column(nullable = false)
    private LocalDateTime timestampInicio;


    @Column()
    private LocalDateTime timestampFin;


    @Column(length = 20, nullable = false)
    private String estado;


    @ManyToOne
    @JoinColumn(name = "invernadero_id", nullable = true)
    private Invernadero invernadero;


    @ManyToOne
    @JoinColumn(name = "sensor_id", nullable = false)
    private Sensor sensor;


    // Constructores
    public Alerta() {
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


    public String getTipoAlerta() {
        return tipoAlerta;
    }

    public void setTipoAlerta(String tipoAlerta) {
        this.tipoAlerta = tipoAlerta;
    }


    public String getNivelSeveridad() {
        return nivelSeveridad;
    }

    public void setNivelSeveridad(String nivelSeveridad) {
        this.nivelSeveridad = nivelSeveridad;
    }


    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }


    public LocalDateTime getTimestampInicio() {
        return timestampInicio;
    }

    public void setTimestampInicio(LocalDateTime timestampInicio) {
        this.timestampInicio = timestampInicio;
    }


    public LocalDateTime getTimestampFin() {
        return timestampFin;
    }

    public void setTimestampFin(LocalDateTime timestampFin) {
        this.timestampFin = timestampFin;
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


    public Sensor getSensor() {
        return sensor;
    }

    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
    }

}