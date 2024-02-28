using GestionVC_API.Models.Datos;
using GestionVC_API.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GestionVC_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DetalleVentaController : ControllerBase
    {
        private readonly ContextoBD bd;
        public DetalleVentaController(ContextoBD bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearDV")]
        public async Task<IActionResult> crearDV(Detalle_Venta dv)
        {
            await bd.Detalle_Ventas.AddAsync(dv);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarDV")]
        public async Task<ActionResult<IEnumerable<Detalle_Venta>>> listarDV()
        {
            var dventas = await bd.Detalle_Ventas.ToListAsync();
            return Ok(dventas);
        }
    }
}
