using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PiperChatWebApiData.Models;
using PiperChatWebApiData.Repositories;
using PiperChatWebApiData.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PiperChatWebApiCore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        IChatUser chatUsers = new UserRepository();

        [HttpPost]
        public IActionResult AddChatUser([FromBody] ChatUser user)
        {
            Console.WriteLine(user);
            chatUsers.AddChatUser(user);
            Console.WriteLine("Added");
            return Ok(user);
        }

        [HttpPost]
        [Route("[action]")]
        public IActionResult login([FromBody] ChatUser user)
        {
            ChatUser loginUser = chatUsers.LoginUser(user);
            return Ok(loginUser);
        }

        [HttpGet]
        public IActionResult GetAllUsers()
        {
            List<ChatUser> allUsers = chatUsers.GetChatUsers();
            return Ok(allUsers);
        }

    }
}
