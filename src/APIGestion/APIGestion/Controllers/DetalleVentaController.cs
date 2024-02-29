using APIGestion.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DetalleVentaController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public DetalleVentaController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearDV")]
        public async Task<IActionResult> crearDV(DetalleVenta dv)
        {
            await bd.DetalleVentas.AddAsync(dv);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarDV")]
        public async Task<ActionResult<IEnumerable<DetalleVenta>>> listarDV()
        {
            var dventas = await bd.DetalleVentas.ToListAsync();
            return Ok(dventas);
        }

        [HttpPut]
        [Route("editarDV")]
        public async Task<IActionResult> editarDV(int id, DetalleVenta dvNueva)
        {
            var dv = await bd.DetalleVentas.FindAsync(id);
            dv!.IdProducto = dvNueva.IdProducto;
            dv.Cantidad = dvNueva.Cantidad;
            dv.PrecioUnitario = dvNueva.PrecioUnitario;
            dv.Subtotal = dvNueva.Subtotal;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarDV")]
        public async Task<IActionResult> eliminarDV(int id)
        {
            var dventa = await bd.DetalleVentas.FindAsync(id);
            bd.DetalleVentas.Remove(dventa!);
            await bd.SaveChangesAsync();
            return Ok();
        }
    }
}
