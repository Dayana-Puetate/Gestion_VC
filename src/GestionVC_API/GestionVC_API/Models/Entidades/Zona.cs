namespace GestionVC_API.Models.Entidades
{
    public class Zona
    {
        public int Id_Zona { get; set; }
        public string NombreZona { get; set; }
        public string Descripcion { get; set; }

        public ICollection<Venta> Ventas { get; set; }
    }
}
