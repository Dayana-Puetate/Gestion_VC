namespace GestionVC_API.Models.Entidades
{
    public class Producto
    {
        public int Id_Producto { get; set; }
        public string Nombre { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public string Categoria { get; set; }
    }
}
