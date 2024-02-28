using GestionVC_API.Models.Datos;
using GestionVC_API.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GestionVC_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ZonaController : ControllerBase
    {
        private readonly ContextoBD bd;
        public ZonaController(ContextoBD bd)
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
        [Route("zonaId")]
        public async Task<IActionResult> zonaId(int id)
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
    }
}
