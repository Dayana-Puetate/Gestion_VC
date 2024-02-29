using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace APIGestion.Models.Entidades;

public partial class Producto
{
    public int IdProducto { get; set; }

    public string Nombre { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public decimal Precio { get; set; }

    public int Stock { get; set; }

    public string? Categoria { get; set; }

    [JsonIgnore]
    public virtual ICollection<DetalleVenta> DetalleVenta { get; set; } = new List<DetalleVenta>();
}
