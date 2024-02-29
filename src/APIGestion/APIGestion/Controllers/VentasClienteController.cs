using APIGestion.Models.Datos;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Controllers
{
    [EnableCors("ReglasCors")]
    [Route("api/[controller]")]
    [ApiController]
    public class VentasClienteController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public VentasClienteController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpGet("ObtenerVentasPorCliente")]
        public IActionResult ObtenerVentasPorCliente()
        {
            var result = bd.ObtenerVentasPorCliente();
            return Ok(result);
        }
    }
}
