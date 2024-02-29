using System;
using System.Collections.Generic;

namespace APIGestion.Models;

public partial class DetalleVenta
{
    public int IdDetalleVenta { get; set; }

    public int? IdVenta { get; set; }

    public int? IdProducto { get; set; }

    public int Cantidad { get; set; }

    public decimal PrecioUnitario { get; set; }

    public decimal Subtotal { get; set; }

    public virtual Producto? objetoProducto { get; set; }

    public virtual Venta? objetoIdVenta { get; set; }
}
