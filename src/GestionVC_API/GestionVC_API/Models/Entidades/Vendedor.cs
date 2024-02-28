namespace GestionVC_API.Models.Entidades
{
    public class Vendedor
    {
        public int Id_Vendedor { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; }
        public string Direccion { get; set; }

        public ICollection<Venta> Ventas { get; set; }
    }
}
