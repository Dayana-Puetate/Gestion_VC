namespace GestionVC_API.Models.Entidades
{
    public class Detalle_Venta
    {
        public int Id_Detalle_Venta { get; set; }
        public int Id_Venta { get; set; }
        public int Id_Producto { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }

        // Propiedades de navegación
        public Venta Venta { get; set; }
        public Producto Producto { get; set; }
    }
}
