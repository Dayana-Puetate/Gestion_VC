using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace APIGestion.Models;

public partial class Vendedor
{
    public int IdVendedor { get; set; }

    public string Nombre { get; set; } = null!;

    public string Apellido { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Direccion { get; set; } = null!;


    [JsonIgnore]
    public virtual ICollection<Venta> Venta { get; set; } = new List<Venta>();
}
