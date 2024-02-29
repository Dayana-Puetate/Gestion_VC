using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace APIGestion.Models;

public partial class Venta
{
    public int IdVenta { get; set; }

    public int? IdCliente { get; set; }

    public int? IdVendedor { get; set; }

    public int? IdZona { get; set; }

    public DateTime Fecha { get; set; }

    public decimal MontoTotal { get; set; }

    [JsonIgnore]
    public virtual ICollection<DetalleVenta> DetalleVenta { get; set; } = new List<DetalleVenta>();

    public virtual Cliente? objetoCliente { get; set; }

    public virtual Vendedor? objetoVendedor { get; set; }

    public virtual Zona? obZona { get; set; }
}
