namespace GestionVC_API.Models.Entidades
{
    public class VentasPorCliente
    {
        public int Id_Cliente { get; set; }
        public string NombreCliente { get; set; }
        public string Zona { get; set; }
        public decimal Ventas2020 { get; set; }
        public decimal Ventas2021 { get; set; }
        public decimal Ventas2022 { get; set; }
        public decimal Ventas2023 { get; set; }
    }
}
