using APIGestion.Models.Datos;
using APIGestion.Models.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Cors;

namespace APIGestion.Controllers
{
    [EnableCors("ReglasCors")]
    [Route("api/[controller]")]
    [ApiController]
    public class ClienteController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public ClienteController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearCliente")]
        public async Task<IActionResult> crearCliente(Cliente cliente)
        {
            await bd.Clientes.AddAsync(cliente);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route( "listarClientes")]
        public async Task<ActionResult<IEnumerable<Cliente>>> listarClientes()
        {
            var clientes = await bd.Clientes.ToListAsync();
            return Ok(clientes);
        }

        [HttpGet]
        [Route("clienteId")]
        public async Task<IActionResult> clienteId(int id)
        {
            Cliente cliente = await bd.Clientes.FindAsync(id);
            if (cliente == null)
            {
                return NotFound();
            }
            return Ok(cliente);
        }

        [HttpPut]
        [Route("editarCli")]
        public async Task<IActionResult> editarCli(int id, Cliente clienteN)
        {
            var cliente = await bd.Clientes.FindAsync(id);
            cliente!.Nombre = clienteN.Nombre;
            cliente.Email = clienteN.Email;
            cliente.Telefono = clienteN.Telefono;
            cliente.Direccion = clienteN.Direccion;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarCli")]
        public async Task<IActionResult> eliminarCli(int id)
        {
            var cliente = await bd.Clientes.FindAsync(id);
            bd.Clientes.Remove(cliente!);
            await bd.SaveChangesAsync();
            return Ok();
        }
    }
}
