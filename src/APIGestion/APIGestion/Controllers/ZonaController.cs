using APIGestion.Models.Datos;
using APIGestion.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ZonaController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public ZonaController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearZona")]
        public async Task<IActionResult> crearZona(Zona zona)
        {
            await bd.Zonas.AddAsync(zona);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarZonas")]
        public async Task<ActionResult<IEnumerable<Zona>>> listarZonas()
        {
            var zonas = await bd.Zonas.ToListAsync();
            return Ok(zonas);
        }

        [HttpGet]
        [Route("listarZonaId")]
        public async Task<IActionResult> listarZonaId(int id)
        {
            Zona zona = await bd.Zonas.FindAsync(id);
            if (zona == null)
            {
                return NotFound();
            }
            return Ok(zona);
        }

        [HttpPut]
        [Route("editarZona")]
        public async Task<IActionResult> editarZona(int id, Zona zonaNueva)
        {
            var zona = await bd.Zonas.FindAsync(id);
            zona!.NombreZona = zonaNueva.NombreZona;
            zona.Descripcion = zonaNueva.Descripcion;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarZona")]
        public async Task<IActionResult> eliminarZona(int id)
        {
            var zona = await bd.Zonas.FindAsync(id);
            bd.Zonas.Remove(zona!);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("ZonasSinVentasEnIntervaloDeFechas")]
        public IActionResult ZonasSinVentasEnIntervaloDeFechas(DateTime fechaInicio, DateTime fechaFin)
        {
            var result = bd.ZonasSinVentasEnIntervaloDeFechas(fechaInicio, fechaFin);
            return Ok(result);
        }
    }
}
