using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace APIGestion.Models.Entidades;

public partial class Cliente
{
    public int IdCliente { get; set; }

    public string Nombre { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public string Direccion { get; set; } = null!;

    [JsonIgnore]
    public virtual ICollection<Venta> Venta { get; set; } = new List<Venta>();
}
