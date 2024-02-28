using GestionVC_API.Models.Datos;
using GestionVC_API.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GestionVC_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VendedorController : ControllerBase
    {
        private readonly ContextoBD bd;
        public VendedorController(ContextoBD bd)
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
        [Route("vendedorId")]
        public async Task<IActionResult> vendedorId(int id)
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
    }
}
