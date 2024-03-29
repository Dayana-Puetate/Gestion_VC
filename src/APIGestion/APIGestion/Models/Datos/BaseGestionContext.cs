﻿using System;
using System.Collections.Generic;
using APIGestion.Models.Entidades;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Models.Datos;

public partial class BaseGestionContext : DbContext
{
    public BaseGestionContext()
    {
    }

    public BaseGestionContext(DbContextOptions<BaseGestionContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<DetalleVenta> DetalleVentas { get; set; }

    public virtual DbSet<Producto> Productos { get; set; }

    public virtual DbSet<Vendedor> Vendedores { get; set; }

    public virtual DbSet<Venta> Ventas { get; set; }

    public virtual DbSet<Zona> Zonas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasKey(e => e.IdCliente).HasName("PK__CLIENTES__677F38F531901BED");

            entity.ToTable("CLIENTES");

            entity.Property(e => e.IdCliente)
                .ValueGeneratedNever()
                .HasColumnName("id_cliente");
            entity.Property(e => e.Direccion)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("direccion");
            entity.Property(e => e.Email)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.Nombre)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.Telefono)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("telefono");
        });

        modelBuilder.Entity<DetalleVenta>(entity =>
        {
            entity.HasKey(e => e.IdDetalleVenta).HasName("PK__DETALLE___5B265D47260F30A1");

            entity.ToTable("DETALLE_VENTAS");

            entity.Property(e => e.IdDetalleVenta)
                .ValueGeneratedNever()
                .HasColumnName("id_detalle_venta");
            entity.Property(e => e.Cantidad).HasColumnName("cantidad");
            entity.Property(e => e.IdProducto).HasColumnName("id_producto");
            entity.Property(e => e.IdVenta).HasColumnName("id_venta");
            entity.Property(e => e.PrecioUnitario)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("precio_unitario");
            entity.Property(e => e.Subtotal)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("subtotal");

            entity.HasOne(d => d.objetoProducto).WithMany(p => p.DetalleVenta)
                .HasForeignKey(d => d.IdProducto)
                .HasConstraintName("FK__DETALLE_V__id_pr__4222D4EF");

            entity.HasOne(d => d.objetoIdVenta).WithMany(p => p.DetalleVenta)
                .HasForeignKey(d => d.IdVenta)
                .HasConstraintName("FK__DETALLE_V__id_ve__412EB0B6");
        });

        modelBuilder.Entity<Producto>(entity =>
        {
            entity.HasKey(e => e.IdProducto).HasName("PK__PRODUCTO__FF341C0DA946ADC8");

            entity.ToTable("PRODUCTOS");

            entity.Property(e => e.IdProducto)
                .ValueGeneratedNever()
                .HasColumnName("id_producto");
            entity.Property(e => e.Categoria)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("categoria");
            entity.Property(e => e.Descripcion)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("descripcion");
            entity.Property(e => e.Nombre)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.Precio)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("precio");
            entity.Property(e => e.Stock).HasColumnName("stock");
        });

        modelBuilder.Entity<Vendedor>(entity =>
        {
            entity.HasKey(e => e.IdVendedor).HasName("PK__VENDEDOR__00930308834FFB03");

            entity.ToTable("VENDEDORES");

            entity.Property(e => e.IdVendedor)
                .ValueGeneratedNever()
                .HasColumnName("id_vendedor");
            entity.Property(e => e.Apellido)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("apellido");
            entity.Property(e => e.Direccion)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("direccion");
            entity.Property(e => e.Email)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.Nombre)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("nombre");
        });

        modelBuilder.Entity<Venta>(entity =>
        {
            entity.HasKey(e => e.IdVenta).HasName("PK__VENTAS__459533BF679A6FE1");

            entity.ToTable("VENTAS");

            entity.Property(e => e.IdVenta)
                .ValueGeneratedNever()
                .HasColumnName("id_venta");
            entity.Property(e => e.Fecha)
                .HasColumnType("datetime")
                .HasColumnName("fecha");
            entity.Property(e => e.IdCliente).HasColumnName("id_cliente");
            entity.Property(e => e.IdVendedor).HasColumnName("id_vendedor");
            entity.Property(e => e.IdZona).HasColumnName("id_zona");
            entity.Property(e => e.MontoTotal)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("monto_total");

            entity.HasOne(d => d.objetoCliente).WithMany(p => p.Venta)
                .HasForeignKey(d => d.IdCliente)
                .HasConstraintName("FK__VENTAS__id_clien__3C69FB99");

            entity.HasOne(d => d.objetoVendedor).WithMany(p => p.Venta)
                .HasForeignKey(d => d.IdVendedor)
                .HasConstraintName("FK__VENTAS__id_vende__3D5E1FD2");

            entity.HasOne(d => d.obZona).WithMany(p => p.Venta)
                .HasForeignKey(d => d.IdZona)
                .HasConstraintName("FK__VENTAS__id_zona__3E52440B");
        });

        modelBuilder.Entity<Zona>(entity =>
        {
            entity.HasKey(e => e.IdZona).HasName("PK__ZONAS__67C936113F53B3A0");

            entity.ToTable("ZONAS");

            entity.Property(e => e.IdZona)
                .ValueGeneratedNever()
                .HasColumnName("id_zona");
            entity.Property(e => e.Descripcion)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("descripcion");
            entity.Property(e => e.NombreZona)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("nombre_zona");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

    public IQueryable<IGrouping<int, Venta>> ZonasMasVentasVendedor()
    {
        // Agrupar las ventas por zona y vendedor y contar la cantidad de ventas
        var cantVentas = from venta in Set<Venta>()
                         group venta by new { venta.IdZona, venta.IdVendedor } into grp
                         select new { IdZona = grp.Key.IdZona ?? 0, IdVendedor = grp.Key.IdVendedor ?? 0, CantidadVentas = grp.Count() };

        // Convertir la consulta a IQueryable<IGrouping<int, Venta>>
        var ventasAgrupadas = cantVentas.GroupBy(x => x.IdZona, x => new Venta { IdZona = x.IdZona, IdVendedor = x.IdVendedor });

        return (IQueryable<IGrouping<int, Venta>>)ventasAgrupadas.AsQueryable();
    }


    public List<Zona> ZonasSinVentasEnIntervaloDeFechas(DateTime fechaInicio, DateTime fechaFin)
    {
        var zonasSinVentas = from zona in Set<Zona>()
                             where !zona.Venta.Any(venta => venta.Fecha >= fechaInicio && venta.Fecha <= fechaFin)
                             select zona;

        return zonasSinVentas.ToList();
    }

    public List<Vendedor> VendedoresSinVentasEnIntervaloDeFechas(DateTime fechaInicio, DateTime fechaFin)
    {
        var vendedoresSinVentas = from vendedor in Set<Vendedor>()
                                  where !vendedor.Venta.Any(venta => venta.Fecha >= fechaInicio && venta.Fecha <= fechaFin)
                                  select vendedor;

        return vendedoresSinVentas.ToList();
    }

    public List<VentasPorCliente> ObtenerVentasPorCliente()
    {
        var ventasPorCliente = from venta in Set<Venta>()
                               where venta.Fecha.Year >= 2020 && venta.Fecha.Year <= 2023
                               group venta by new { venta.IdCliente, venta.objetoCliente.Nombre, venta.obZona.NombreZona } into grp
                               select new VentasPorCliente
                               {
                                   Id_Cliente = (int)grp.Key.IdCliente,
                                   NombreCliente = grp.Key.Nombre,
                                   Zona = grp.Key.NombreZona,
                                   Ventas2020 = grp.Where(v => v.Fecha.Year == 2020).Sum(v => v.MontoTotal),
                                   Ventas2021 = grp.Where(v => v.Fecha.Year == 2021).Sum(v => v.MontoTotal),
                                   Ventas2022 = grp.Where(v => v.Fecha.Year == 2022).Sum(v => v.MontoTotal),
                                   Ventas2023 = grp.Where(v => v.Fecha.Year == 2023).Sum(v => v.MontoTotal)
                               };

        return ventasPorCliente.ToList();
    }
}
