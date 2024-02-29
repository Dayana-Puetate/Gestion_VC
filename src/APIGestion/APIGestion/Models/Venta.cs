using System;
using System.Collections.Generic;

namespace APIGestion.Models;

public partial class Venta
{
    public int IdVenta { get; set; }

    public int? IdCliente { get; set; }

    public int? IdVendedor { get; set; }

    public int? IzZona { get; set; }

    public DateTime Fecha { get; set; }

    public decimal MontoTotal { get; set; }

    public virtual ICollection<DetalleVenta> DetalleVenta { get; set; } = new List<DetalleVenta>();

    public virtual Cliente? IdClienteNavigation { get; set; }

    public virtual Vendedore? IdVendedorNavigation { get; set; }

    public virtual Zona? IzZonaNavigation { get; set; }
}
