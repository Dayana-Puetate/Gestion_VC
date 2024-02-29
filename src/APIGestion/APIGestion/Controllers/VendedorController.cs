using APIGestion.Models.Datos;
using APIGestion.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace APIGestion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VendedorController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public VendedorController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearVendedor")]
        public async Task<IActionResult> crearVendedor(Vendedor vendedor)
        {
            await bd.Vendedores.AddAsync(vendedor);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarVendedores")]
        public async Task<ActionResult<IEnumerable<Vendedor>>> listarVendedores()
        {
            var vendedores = await bd.Vendedores.ToListAsync();
            return Ok(vendedores);
        }

        [HttpGet]
        [Route("listarVendedorId")]
        public async Task<IActionResult> listarVendedorId(int id)
        {
            Vendedor vendedor = await bd.Vendedores.FindAsync(id);
            if (vendedor == null)
            {
                return NotFound();
            }
            return Ok(vendedor);
        }

        [HttpPut]
        [Route("editarVendedor")]
        public async Task<IActionResult> editarVendedor(int id, Vendedor vendedorN)
        {
            var vendedor = await bd.Vendedores.FindAsync(id);
            vendedor!.Nombre = vendedorN.Nombre;
            vendedor.Apellido = vendedorN.Apellido;
            vendedor.Email = vendedorN.Email;
            vendedor.Direccion = vendedorN.Direccion;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarVendedor")]
        public async Task<IActionResult> eliminarVendedor(int id)
        {
            var vendedor = await bd.Vendedores.FindAsync(id);
            bd.Vendedores.Remove(vendedor!);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("ZonasMasVentasVendedor")]
        public IActionResult ZonasMasVentasVendedor()
        {
            var result = bd.ZonasMasVentasVendedor().ToList();
            return Ok(result);
        }

        [HttpGet]
        [Route("VendedoresSinVentasEnIntervaloDeFechas")]
        public IActionResult VendedoresSinVentasEnIntervaloDeFechas(DateTime fechaInicio, DateTime fechaFin)
        {
            var result = bd.VendedoresSinVentasEnIntervaloDeFechas(fechaInicio, fechaFin);
            return Ok(result);
        }
    }
}
