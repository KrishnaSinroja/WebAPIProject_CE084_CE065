using PiperChatWebApiData.Interfaces;
using PiperChatWebApiData.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PiperChatWebApiData.Repositories
{
    public class UserRepository : IChatUser
    {
        private readonly PiperChatCoreDbContext _db = new PiperChatCoreDbContext();

        public UserRepository(PiperChatCoreDbContext db)
        {
            _db = db;
        }
        public UserRepository()
        {
    
        }
        public void AddChatUser(ChatUser chatUser)
        {
            _db.ChatUsers.Add(chatUser);
            _db.SaveChanges();
        }

        public ChatUser GetChatUser(int chatUserId)
        {
            ChatUser user = _db.ChatUsers.Find(chatUserId);
            return user;
        }

        public List<ChatUser> GetChatUsers()
        {
            return _db.ChatUsers.ToList();
        }

        public ChatUser LoginUser(ChatUser chatUser)
        {
            var users = _db.ChatUsers.Where(user => user.Email == chatUser.Email && user.Password == chatUser.Password).ToList<ChatUser>();
            if(users.Count == 0)
            {
                return null;
            }
            return users[0];
        }
    }
}
