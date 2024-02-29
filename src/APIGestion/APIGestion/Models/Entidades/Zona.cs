using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace APIGestion.Models.Entidades;

public partial class Zona
{
    public int IdZona { get; set; }

    public string NombreZona { get; set; } = null!;

    public string? Descripcion { get; set; }

    [JsonIgnore]
    public virtual ICollection<Venta> Venta { get; set; } = new List<Venta>();
}
