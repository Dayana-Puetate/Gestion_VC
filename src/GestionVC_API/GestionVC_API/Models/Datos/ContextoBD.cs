using GestionVC_API.Models.Entidades;
using Microsoft.EntityFrameworkCore;

namespace GestionVC_API.Models.Datos
{
    public class ContextoBD: DbContext
    {
        public ContextoBD(DbContextOptions<ContextoBD> options) : base(options)
        {
        }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Vendedor> Vendedores { get; set; }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<Zona> Zonas { get; set; }
        public DbSet<Venta> Ventas { get; set; }
        public DbSet<Detalle_Venta> Detalle_Ventas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cliente>(entity =>
            {
                entity.HasKey(e => e.Id_Cliente);
                entity.Property(e => e.Nombre).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Telefono).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Direccion).IsRequired().HasMaxLength(20);
            });

            modelBuilder.Entity<Vendedor>(entity =>
            {
                entity.HasKey(e => e.Id_Vendedor);
                entity.Property(e => e.Nombre).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Apellido).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Direccion).IsRequired().HasMaxLength(20);
            });

            modelBuilder.Entity<Zona>(entity =>
            {
                entity.HasKey(e => e.Id_Zona);
                entity.Property(e => e.NombreZona).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Descripcion).IsRequired().HasMaxLength(20);
            });

            modelBuilder.Entity<Producto>(entity =>
            {
                entity.HasKey(e => e.Id_Producto);
                entity.Property(e => e.Nombre).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Descripcion).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Precio).IsRequired().HasColumnType("decimal(10,2)");
                entity.Property(e => e.Stock).IsRequired();
                entity.Property(e => e.Categoria).HasMaxLength(20);
            });

            modelBuilder.Entity<Venta>(entity =>
            {
                entity.HasKey(e => e.Id_Venta);
                entity.Property(e => e.Fecha).IsRequired();
                entity.Property(e => e.MontoTotal).IsRequired().HasColumnType("decimal(10,2)");

                // Configuración de las relaciones con las claves foráneas
                entity.HasOne(e => e.Cliente)
                    .WithMany()
                    .HasForeignKey(e => e.Id_Cliente)
                    .OnDelete(DeleteBehavior.ClientSetNull);

                entity.HasOne(e => e.Vendedor)
                    .WithMany()
                    .HasForeignKey(e => e.Id_Vendedor)
                    .OnDelete(DeleteBehavior.ClientSetNull);

                entity.HasOne(e => e.Zona)
                    .WithMany()
                    .HasForeignKey(e => e.Id_Zona)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });


            modelBuilder.Entity<Detalle_Venta>(entity =>
            {
                entity.HasKey(e => e.Id_Detalle_Venta);
                entity.Property(e => e.Cantidad).IsRequired();
                entity.Property(e => e.PrecioUnitario).IsRequired().HasColumnType("decimal(10,2)");
                entity.Property(e => e.Subtotal).IsRequired().HasColumnType("decimal(10,2)");

                // Configuración de las relaciones con las claves foráneas
                entity.HasOne(e => e.Venta)
                    .WithMany()
                    .HasForeignKey(e => e.Id_Venta)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Detalle_Venta_Venta");

                entity.HasOne(e => e.Producto)
                    .WithMany()
                    .HasForeignKey(e => e.Id_Producto)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Detalle_Venta_Producto");
            });

        }


    }
}
