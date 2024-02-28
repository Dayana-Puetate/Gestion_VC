using GestionVC_API.Models.Datos;
using GestionVC_API.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GestionVC_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VentaController : ControllerBase
    {
        private readonly ContextoBD bd;
        public VentaController(ContextoBD bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearVenta")]
        public async Task<IActionResult> crearVenta(Venta venta)
        {
            await bd.Ventas.AddAsync(venta);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarVentas")]
        public async Task<ActionResult<IEnumerable<Venta>>> listarVentas()
        {
            var ventas = await bd.Ventas.ToListAsync();
            return Ok(ventas);
        }

        [HttpGet]
        [Route("ventaId")]
        public async Task<IActionResult> ventaId(int id)
        {
            Venta venta = await bd.Ventas.FindAsync(id);
            if (venta == null)
            {
                return NotFound();
            }
            return Ok(venta);
        }

        [HttpPut]
        [Route("editarVenta")]
        public async Task<IActionResult> editarVenta(int id, Venta ventaNueva)
        {
            var venta = await bd.Ventas.FindAsync(id);
            venta!.Id_Cliente = ventaNueva.Id_Cliente;
            venta.Id_Vendedor = ventaNueva.Id_Vendedor;
            venta.Id_Zona = ventaNueva.Id_Zona;
            venta.Fecha = ventaNueva.Fecha;
            venta.MontoTotal = ventaNueva.MontoTotal;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarVenta")]
        public async Task<IActionResult> eliminarVenta(int id)
        {
            var venta = await bd.Ventas.FindAsync(id);
            bd.Ventas.Remove(venta!);
            await bd.SaveChangesAsync();
            return Ok();
        }
    }
}
