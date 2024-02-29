using APIGestion.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace APIGestion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductoController : ControllerBase
    {
        private readonly BaseGestionContext bd;
        public ProductoController(BaseGestionContext bd)
        {
            this.bd = bd;
        }

        [HttpPost]
        [Route("crearProducto")]
        public async Task<IActionResult> crearProducto(Producto producto)
        {
            await bd.Productos.AddAsync(producto);
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpGet]
        [Route("listarProductos")]
        public async Task<ActionResult<IEnumerable<Producto>>> listarProductos()
        {
            var productos = await bd.Productos.ToListAsync();
            return Ok(productos);
        }

        [HttpGet]
        [Route("productoId")]
        public async Task<IActionResult> productoId(int id)
        {
            Producto producto = await bd.Productos.FindAsync(id);
            if (producto == null)
            {
                return NotFound();
            }
            return Ok(producto);
        }

        [HttpPut]
        [Route("editarPro")]
        public async Task<IActionResult> editarPro(int id, Producto productoN)
        {
            var producto = await bd.Productos.FindAsync(id);
            producto!.Nombre = productoN.Nombre;
            producto.Descripcion = productoN.Descripcion;
            producto.Precio = productoN.Precio;
            producto.Stock = productoN.Stock;
            producto.Categoria = productoN.Categoria;
            await bd.SaveChangesAsync();
            return Ok();
        }

        [HttpDelete]
        [Route("eliminarPro")]
        public async Task<IActionResult> eliminarPro(int id)
        {
            var producto = await bd.Productos.FindAsync(id);
            bd.Productos.Remove(producto!);
            await bd.SaveChangesAsync();
            return Ok();
        }
    }
}
