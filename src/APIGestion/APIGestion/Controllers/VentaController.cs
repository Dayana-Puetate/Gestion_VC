using APIGestion.Models.Datos;
using APIGestion.Models.Entidades;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Controllers
{
    [EnableCors("ReglasCors")]
    [Route("api/[controller]")]
    [ApiController]
    public class VentaController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public VentaController(BaseGestionContext bd)
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
            venta!.IdCliente = ventaNueva.IdCliente;
            venta.IdVendedor = ventaNueva.IdVendedor;
            venta.IdZona = ventaNueva.IdZona;
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
