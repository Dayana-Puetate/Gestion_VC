namespace GestionVC_API.Models.Entidades
{
    public class Venta
    {
        public int Id_Venta { get; set; }
        public int Id_Cliente { get; set; }
        public int Id_Vendedor { get; set; }
        public int Id_Zona { get; set; }
        public DateTime Fecha { get; set; }
        public decimal MontoTotal { get; set; }

        // Propiedades de navegación
        public Cliente Cliente { get; set; }
        public Vendedor Vendedor { get; set; }
        public Zona Zona { get; set; }
    }
}
